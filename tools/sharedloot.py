#!/usr/bin/env python3
"""Find loot that a group of NPCs share, for the `loot_shared` key.

Rare mobs in a zone usually roll from one pool of gear, plus an item or two
that only they drop. This fetches the drop tables, groups every item by the
exact set of NPCs that drop it, and can print the result as Lua.
"""

import argparse
import re
import sys
import textwrap
from collections import defaultdict

import yaml
try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader

from lootminer import fetch, log, additemdata, cleanloot, __keysort
from npc import lua

# Trade goods and quest items are rarely worth a tooltip line.
DEFAULT_EXCLUDED_CLASSES = (7, 12)


class Drop:
    def __init__(self, data, npc):
        self.npc = npc
        self.id = data["id"]
        self.name = data["name"]
        self.quality = data["quality"]
        self.classs = data["classs"]
        mode = data.get("modes", {}).get("0") or {}
        self.count = mode.get("count", 0)
        self.outof = mode.get("outof", 0)

    @property
    def rate(self):
        return self.outof and self.count / self.outof or 0


def sitebase(base):
    """Accept a full URL, or a wowhead site path like "mop-classic"."""
    if base.startswith("http"):
        return base.rstrip("/")
    if base in ("retail", "live", ""):
        return "https://www.wowhead.com"
    return "https://www.wowhead.com/" + base.strip("/")


def fetchdrops(npc, base):
    """Return (npc name, {item id: Drop}) for one NPC."""
    r = fetch(f"{base}/npc={npc}")

    name = str(npc)
    if m := re.search(r"^\$.extend\(g_npcs\[\d+], ?({.+})\);?$", r.text, re.MULTILINE):
        data = yaml.load(m.group(1), Loader=Loader)
        if data["id"] != npc:
            # The era sites reuse ids, so a mismatch means we asked the wrong site
            log(f"  ignoring: {base} has npc {data['id']} under that id")
            return None, {}
        name = data.get("name", name)

    m = re.search(r"^new Listview\({template: 'item', id: 'drops',.*data:(\[.+\])}\);$", r.text, re.MULTILINE)
    if not m:
        log("  no drops listed")
        return name, {}

    drops = [Drop(d, npc) for d in yaml.load(m.group(1).replace("undefined", "null"), Loader=Loader)]
    return name, {drop.id: drop for drop in drops}


RARE_CLASSIFICATIONS = ("2", "4")  # rare elite, rare
_rareshare = {}


def rareshare(item, base):
    """What share of the NPCs dropping this item at all are rares.

    An item most of a zone's mobs drop is a zone drop that the rares happen to
    roll too, not loot worth hanging on the rare. Wowhead caps the list at 200,
    which can only understate the share, so it errs towards dropping an item.
    """
    if item in _rareshare:
        return _rareshare[item]
    r = fetch(f"{base}/item={item}")
    start = r.text.find("id: 'dropped-by'")
    droppers = []
    if start >= 0:
        end = r.text.find("new Listview({", start)
        droppers = re.findall(r'"classification":(-?\d+)', r.text[start:end if end > 0 else len(r.text)])
    share = sum(c in RARE_CLASSIFICATIONS for c in droppers) / len(droppers) if droppers else 0
    _rareshare[item] = (share, len(droppers))
    return _rareshare[item]


def prune_zonedrops(clusters, args):
    """Drop items that mostly come from ordinary mobs rather than rares."""
    kept, dropped = [], 0
    for holders, items in clusters:
        if len(holders) < args.min_npcs:
            # not going to be shown anyway, so don't pay for the lookups
            kept.append((holders, items))
            continue
        keep = []
        for perNpc in items:
            share, _total = rareshare(perNpc[0].id, args.base)
            if share < args.rare_share:
                dropped += 1
                continue
            keep.append(perNpc)
        if keep:
            kept.append((holders, keep))
    return kept, dropped


def keepdrop(drop, args):
    if drop.quality < args.min_quality:
        return False
    if drop.classs in args.exclude_classes:
        return False
    if drop.rate < args.min_rate:
        return False
    return True


def cluster(npcs, drops, args):
    """Group items by the set of NPCs dropping them.

    Returns (clusters, count of items the filters removed), widest group first,
    so the pool everything shares comes before the one-mob-only leftovers. Each
    cluster is (npc ids, [[Drop for each npc that drops it] per item]).

    Signatures are exact by default. Wowhead is built from what people actually
    looted, so a real pool of nine items can show up as nine near-identical
    groups that each miss a different mob. --threshold merges anything most of
    the group drops into one pool, which is what those zones need.
    """
    MERGED = "merged"
    signatures = defaultdict(list)
    filtered = 0
    needed = args.threshold and max(2, round(args.threshold * len(npcs)))
    for itemid in {i for npc in npcs for i in drops[npc]}:
        holders = tuple(npc for npc in npcs if itemid in drops[npc])
        perNpc = [drops[npc][itemid] for npc in holders]
        if not any(keepdrop(drop, args) for drop in perNpc):
            filtered += 1
            continue
        signatures[MERGED if needed and len(holders) >= needed else holders].append(perNpc)
    if MERGED in signatures:
        # Name the merged pool after the mobs actually in it, not everything
        # that was asked about, or a mixed input makes the label a lie.
        inpool = {drop.npc for perNpc in signatures[MERGED] for drop in perNpc}
        signatures[tuple(npc for npc in npcs if npc in inpool)] = signatures.pop(MERGED)
    clusters = [
        (holders, sorted(items, key=lambda perNpc: -meanrate(perNpc)))
        for holders, items in signatures.items()
    ]
    clusters.sort(key=lambda c: (-len(c[0]), -len(c[1])))
    return clusters, filtered


def meanrate(perNpc):
    return sum(drop.rate for drop in perNpc) / len(perNpc)


def partial(perNpc, holders):
    """Flag an item that only some of a --threshold pool were seen dropping."""
    return f"  [{len(perNpc)}/{len(holders)}]" if len(perNpc) != len(holders) else ""


def describe(holders, names, total):
    who = ", ".join(names[npc] for npc in holders)
    count = f"all {total}" if len(holders) == total else f"{len(holders)} of {total}"
    return f"{count}: {who}"


def report(clusters, names, npcs, filtered, args):
    print()
    print(f"{len(npcs)} NPCs from {args.base}")
    print(f"filters: quality>={args.min_quality}, rate>={args.min_rate:.2%}, "
          f"excluding item classes {','.join(str(c) for c in args.exclude_classes) or 'none'} "
          f"({filtered} items removed)")
    for holders, items in clusters:
        if len(holders) < args.min_npcs:
            continue
        print()
        print("--", describe(holders, names, len(npcs)))
        for perNpc in items:
            share = ""
            if args.rare_share:
                pct, total = rareshare(perNpc[0].id, args.base)
                share = f"  {pct:4.0%} of {total} droppers are rares"
            print(f"   {perNpc[0].id:>7}  {perNpc[0].name:<44} {meanrate(perNpc):6.2%}"
                  f"{partial(perNpc, holders)}{share}")


def lua_items(items, holders, indent, args):
    lines = []
    for perNpc in items:
        item = {1: perNpc[0].id}
        if args.enrich:
            item = additemdata(item, args.base)
        name = item.pop("name", perNpc[0].name)
        serialized = lua.serialize(cleanloot(item), key=__keysort, trailingcomma=True)
        lines.append(f"{indent}{serialized}, -- {name}{partial(perNpc, holders)}\n")
    return lines


def output_lua(clusters, names, npcs, args):
    """Print a loot_shared block per shared pool, then each NPC's own loot."""
    out = []
    for holders, items in clusters:
        if len(holders) < max(2, args.min_npcs):
            continue
        out.append(f"-- shared by {describe(holders, names, len(npcs))}\n")
        out.append("loot_shared={\n")
        out.extend(lua_items(items, holders, "\t", args))
        out.append("},\n")
    if args.min_npcs > 1:
        return print("".join(out))
    for npc in npcs:
        own = [items for holders, items in clusters if holders == (npc,)]
        if not own:
            continue
        out.append(f"\n-- only {names[npc]} ({npc})\n")
        out.append("loot={\n")
        out.extend(lua_items(own[0], (npc,), "\t", args))
        out.append("},\n")
    print("".join(out))


def npcids_from_input(value):
    """NPC ids from a comma-separated list, a wowhead URL, or a .lua data file."""
    if re.fullmatch(r"[\d,\s]+", value):
        return [int(n) for n in re.split(r"[,\s]+", value.strip()) if n]
    if value.startswith("http"):
        from lootminer import fetch_npcids_from_search
        ids, _sub = fetch_npcids_from_search(value)
        return list(ids)
    with open(value, "r", encoding="utf-8") as f:
        # dedupe but keep file order, so the report reads like the zone does
        return list(dict.fromkeys(int(m) for m in re.findall(r"\bnpc\s*=\s*(\d+)", f.read())))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=textwrap.dedent("""\
            examples:
              # the Jade Forest rares, read out of the zone file
              sharedloot.py --base mop-classic ../../HandyNotes_MistsOfPandariaTreasures/zones/JadeForest.lua
              # an explicit group, as Lua ready to paste
              sharedloot.py --base mop-classic --lua 50338,50363,50350,50823

            Retail pages for old mobs are full of current-expansion trash and
            Remix items. The era site for the content gives a much cleaner
            table, so use --base for anything that is not current.
        """))
    parser.add_argument('input', metavar="NPCS", type=str, nargs="+",
                        help="Comma-separated NPC ids, a wowhead search URL, or a .lua file to read npc= ids from. "
                             "Several can be given, which is how you find a pool that crosses zones")
    parser.add_argument('--base', type=str, default="retail",
                        help="Wowhead site: retail, mop-classic, cata, classic... or a full URL (default: retail)")
    parser.add_argument('--lua', action="store_true", default=False,
                        help="Print Lua blocks to paste into a zone file")
    parser.add_argument('--enrich', action="store_true", default=False,
                        help="Fetch each item too, to flag mounts, pets and toys (slow)")
    parser.add_argument('--min-quality', type=int, default=2,
                        help="Lowest item quality to keep, 0 poor to 5 legendary (default: 2)")
    parser.add_argument('--min-rate', type=float, default=0.01,
                        help="Lowest drop rate to keep, as a fraction (default: 0.01). Retail pages need this, era sites rarely do")
    parser.add_argument('--rare-share', type=float, default=None, metavar="F",
                        help="Keep an item only if this fraction of every NPC dropping it anywhere is a rare, "
                             "e.g. 0.4. Costs one fetch per item, and is what separates a rare's pool from a "
                             "zone drop the rares also roll")
    parser.add_argument('--threshold', type=float, default=None, metavar="F",
                        help="Treat an item as shared by the whole group once this fraction of it drops the item, "
                             "e.g. 0.6. Use for zones where wowhead's coverage is patchy enough to split one real pool")
    parser.add_argument('--min-npcs', type=int, default=1,
                        help="Only report pools shared by at least this many NPCs (default: 1)")
    parser.add_argument('--include-class', action="append", type=int, default=[], metavar="N",
                        help="Keep an item class excluded by default (7 trade goods, 12 quest)")
    args = parser.parse_args()

    args.base = sitebase(args.base)
    args.exclude_classes = tuple(c for c in DEFAULT_EXCLUDED_CLASSES if c not in args.include_class)

    wanted = dict.fromkeys(npc for value in args.input for npc in npcids_from_input(value))

    npcs, names, drops = [], {}, {}
    for npc in wanted:
        name, npcdrops = fetchdrops(npc, args.base)
        if name is None:
            continue
        npcs.append(npc)
        names[npc] = name
        drops[npc] = npcdrops

    if not npcs:
        sys.exit("No NPCs fetched")

    clusters, filtered = cluster(npcs, drops, args)
    if args.rare_share:
        clusters, zonedrops = prune_zonedrops(clusters, args)
        filtered += zonedrops
    if args.lua:
        output_lua(clusters, names, npcs, args)
    else:
        report(clusters, names, npcs, filtered, args)
