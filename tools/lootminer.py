import argparse
import glob
import re
import sys
import html
import yaml
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper
from collections import defaultdict

import requests
import requests_cache
from requests.adapters import HTTPAdapter, Retry

from npc import lua, petfamilies, pack_coords
try:
    from zones import zones as zones_raw
except ImportError:
    # zones.py should be generated from a CSV dump of the UIMap table
    # s/^([^,]+),(\d+),(\d+),.+$/$2: ("$1", ($3, $2)),/g
    # s/^"([^"]+)",(\d+),(\d+),.+$/$2: ("$1", ($3, $2)),/g
    pass
zones = defaultdict(lambda: ("Unknown", (-1, -1)))
zones.update(zones_raw)

session = requests_cache.CachedSession()
retries = Retry(total=5, backoff_factor=1, status_forcelist=[ 502, 503, 504 ])
session.mount('http://', HTTPAdapter(max_retries=retries))
session.mount('https://', HTTPAdapter(max_retries=retries))
session.headers.update({'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0'})

__start = ("name", "mount", "pet", "toy")
__end = ("hidden")
def __keysort(k):
    k = str(k)
    if k in __start:
        # 0 would be sooner, but I want numbers to come first so the {123,mount=4} output works
        return f"AAAAAAAAA{__start.index(k)}"
    if k in __end:
        return f"zzzzzzzzz{__end.index(k)}"
    return k


def additemdata(item, base="https://wowhead.com"):
    print("additemdata", item)
    item = normalizeitem(item)

    url = f"{base}/item={item[1]}"
    print("Fetching", url)
    r = session.get(url, timeout=5)
    print("fetch completed")

    if m := re.search(r'<meta property="og:title" content="([^"]+)">', r.text):
        item["name"] = html.unescape(m.group(1))

    # quest
    # new Listview({
    #     template: 'quest',
    #     id: 'provided-for',
    #     name: WH.TERMS.providedfor,
    #     tabs: 'tabsRelated',
    #     parent: 'lkljbjkb574',
    #     data: [{"category":10290,"category2":15,"id":56515,"itemrewards":[[169688,1]],"level":50,"name":"Vinyl: Gnomeregan Forever","reqlevel":50,"side":3,"wflags":32}],
    # });
    if m := re.search(r"new Listview\({\n\s*template: 'quest'.+?id: 'provided-for',.+?data: .+?\"id\":(\d+),", r.text, re.DOTALL):
        item["quest"] = int(m.group(1))
    elif m := re.search(r"\(WH\.enhanceTooltip\.bind\(tt\)\)\([^\)]+?\[(\d+)\]", r.text, re.DOTALL):
        print("found a spell, checking for quest")
        rs = session.get(f"{base}/spell={m.group(1)}")
        # this might be fragile, but...
        if m2 := re.search(r'Complete Quest.+?href="/quest=(\d+)"', rs.text):
            item["quest"] = int(m2.group(1))

    if '<span class="toycolor">Toy</span>' in r.text:
        item["toy"] = True
    # Mount and pet both lack the required data, so just leave a flag for me:
    if "mount" not in item and "Teaches you how to summon this mount." in r.text:
        item["mount"] = True
    if "pet" not in item and "Teaches you how to summon this companion." in r.text:
        item["pet"] = True

    return item


def normalizeitem(item):
    if type(item) != dict:
        item = {1: item}
    return item

def isvaliddrop(npc, loot, loot_filter="source"):
    if loot_filter == "all":
        return True
    if loot_filter in ("source", "notable"):
        if sources := loot.get("source"):
            # Available on the black market
            if 14 in sources:
                return True
        for source in loot.get("sourcemore", []):
            if source.get("ti") == npc:
                # Anything that drops from just this source is inherently notable
                return True
            if source.get("bd"):
                # Boss drop, which means it's inherently interesting
                return True
    if loot_filter == "notable":
        # Basically, is this "interesting"?
        if loot["quality"] < 3:
            # Blue and up only
            return False
        if loot["classs"] in (7, 12):
            # Trade goods, quest items
            return False
        if drops := loot.get("modes", {}).get("0", False):
            count = drops["count"]
            outof = drops["outof"]
            if outof != 0:
                rate = drops["count"] / drops["outof"]
                if rate < 0.01:
                    return False
        return True
    return False


def fetchnpc(npc, loot_filter="source", base="https://wowhead.com"):
    url = f"{base}/npc={npc}"
    print("fetchnpc", npc, url)
    r = session.get(url, timeout=5)
    print("fetch completed", r.url)

    data = None

    # Note to self: can't use yaml.safe_load here because it doesn't let you
    # override the loader, and the default loader is a lot slower.

    # $.extend(g_npcs[50358], {"classification":2,"id":50358,"location":[6507],"maxlevel":38,"minlevel":38,"name":"Haywire Sunreaver Construct","react":[-1,-1],"type":9});
    # $.extend(g_npcs[203625], {"classification":2,"displayName":"Karokta","displayNames":["Karokta"],"id":203625,"name":"Karokta","names":["Karokta"],"type":1});
    if m := re.search(r"^\$.extend\(g_npcs\[\d+], ?({.+})\);?$", r.text, re.MULTILINE):
        data = yaml.load(m.group(1), Loader=Loader)
        if data["id"] != npc:
            print("couldn't find npc data in g_npcs")
            return False
    else:
        print("couldn't find g_npc data")
        return False

    # var g_mapperData = {"13644":[{"count":1,"coords":[[33,76.4]],"uiMapId":2022,"uiMapName":"The Waking Shores"}]};
    if mapperDatas := re.findall(r"g_mapperData\s*=\s*({\"\d+\":\[.+\]});", r.text):
        for mapperData in mapperDatas:
            locations = yaml.load(mapperData, Loader=Loader)
            for locationid, locationdatas in locations.items():
                if "locations" not in data:
                    data["locations"] = []
                for locationdata in locationdatas:
                    if "coords" in locationdata:
                        locationdata["coords"] = [pack_coords(coord[0]/100, coord[1]/100) for coord in locationdata["coords"]]
                        data["locations"].append(locationdata)
                    else:
                        print("No locationdata")

    if m := re.search(r"^new Listview\({template: 'item', id: 'drops',.*data:(\[.+\])}\);$", r.text, re.MULTILINE):
        lootdata = yaml.load(m.group(1).replace("undefined", "null"), Loader=Loader)
        data["loot"] = []
        for loot in lootdata:
            if isvaliddrop(npc, loot, loot_filter):
                data["loot"].append(loot["id"])

    return data


def mergeloot(loot, new):
    # This expects `new` to be a sequence of ints, but old can be more complex which is why we need a merger
    oldlootids = {type(item) == int and item or item[1] for item in loot}
    for itemid in new:
        if not itemid in oldlootids:
            loot.append(itemid)
    return loot


def cleanloot(item):
    # get it down to what we expect in the module
    if "name" in item:
        del item["name"]
    if len(item) == 1:
        return item[1]
    return item

def output_npc(output, coords, data, indentlevel=1):
    indent = "\t" * indentlevel
    output.extend((
        f"{indent}[{coords[0]}] = {{ -- {data['name']}\n",
        len(coords) > 1 and f"{indent}\t-- {coords}\n" or "",
        f"{indent}\tquest={data.get('quest', 'nil')},\n",
        f"{indent}\tnpc={data['id']},\n",
    ))
    if data.get("loot", []):
        output.append(f"{indent}\tloot={{\n")
        for item in data.get("loot", []):
            name = item.get("name", "?")
            cleaned = cleanloot(item.copy())
            output.append(f"{indent}\t\t{lua.serialize(cleaned, key=__keysort, trailingcomma=True)}, -- {name}\n")
        output.append(f"{indent}\t}},\n")
    output.append(f"{indent}}},\n")


def update(f):
    output = []
    with open(f, 'r') as infile:
        for line in infile:
            match = re.search(r"\[(\d+)\] = ({.+}),$", line)
            if not match:
                output.append(line)
                continue

            npcid = int(match.group(1))
            try:
                data = lua.loadtable(match.group(2))
            except SyntaxError as e:
                print("Skipping", npcid)
                output.append(line)
                continue

            print("Loading", npcid, data["name"])
            remote = fetchnpc(int(npcid))
            
            loot = data.get("loot", [])
            if remote and "loot" in remote and len(remote["loot"]) > 0:
                mergeloot(loot, remote["loot"])
            if len(loot):
                data["loot"] = [cleanloot(additemdata(item).copy()) for item in loot]

            if "family" in remote and remote["family"] in petfamilies:
                data["tameable"] = petfamilies[remote["family"]][1]

            output.append(line[:match.start(2)] + lua.serialize(data, key=__keysort, trailingcomma=True) + line[match.end(2):])

    with open(f, 'w') as outfile:
        outfile.writelines(output)


def export(inf, outf, hn=False, local=False):
    mobs = {}
    with open(inf, 'r') as infile:
        for line in infile:
            match = re.search(r"\[(\d+)\] = ({.+}),$", line)
            if not match:
                continue
            npcid = int(match.group(1))
            try:
                data = lua.loadtable(match.group(2))
            except SyntaxError as e:
                print("Skipping", npcid)
                continue

            if local:
                data["loot"] = [normalizeitem(item) for item in data.get("loot", [])]
            else:
                print("Loading", npcid, data["name"])
                remote = fetchnpc(int(npcid))

                loot = data.get("loot", [])
                if remote and "loot" in remote and len(remote["loot"]) > 0:
                    mergeloot(loot, remote["loot"])
                if len(loot):
                    data["loot"] = [additemdata(item) for item in loot]

                if "family" in remote and remote["family"] in petfamilies:
                    data["tameable"] = petfamilies[remote["family"]]

            mobs[npcid] = data

    if hn:
        output = ["local myname, ns = ...\n\n"]
        mobzones = {}
        for npcid in mobs:
            data = mobs[npcid]
            # print(data)
            for zone in data["locations"]:
                if zone not in mobzones:
                    mobzones[zone] = []
                mobzones[zone].append(npcid)
        for zone in sorted(mobzones, key=lambda z: zones[z][1]):
            output.append(f"ns.RegisterPoints({zone}, {{ -- {zones[zone][0]}\n")
            for npcid in sorted(mobzones[zone], key=lambda npcid: mobs[npcid]["name"]):
                data = mobs[npcid]
                coords = data["locations"][zone]
                if not coords:
                    continue
                output_npc(coords, data)
            output.append("})\n")
    else:
        output = [f"[{npcid}]={lua.serialize(mobs[npcid], key=__keysort, trailingcomma=True)},\n" for npcid in mobs]

    with open(outf, 'w') as outfile:
        outfile.writelines(output)


def fetch_npcids_from_search(url):
    # assume this is a wowhead search page and pull down everything included on it
    r = session.get(url, timeout=5)
    match = re.search(
        r'new Listview\({[^{]+?"?data"?:\s*\[(.+?)\]}\);\n', r.text
    )
    if not match:
        return []
    headermatch = re.search(
        r'<a href="([^"]+)" class="header-logo">', r.text
    )
    return map(int, re.findall(r'"id":(\d+)', match.group(1))), headermatch and headermatch.group(1)


if __name__ == '__main__':
    # requests_cache.install_cache()
    # print(fetchnpc(50358))

    parser = argparse.ArgumentParser(description="Strip data out of wowhead")
    parser.add_argument('input', metavar="INPUT", type=str, help="Module file to use as input (wildcards work)")
    parser.add_argument('--export', nargs="?", type=str, help="Export loot data to another file rather than updating in place")
    parser.add_argument('--export_handynotes', action="store_true", default=False, help="Export in my handynotes format")
    parser.add_argument('--local', action="store_true", default=False, help="Export local data rather than fetching anything")
    parser.add_argument('--only_with_loot', action="store_true", default=False, help="Only output those with loot")
    parser.add_argument('--loot_filter', action="store", choices=("source", "notable", "all"), default="source", help="")
    args = parser.parse_args()

    if re.match(r"(?:[\d,]|^http)", args.input):
        npcids = []
        base = "https://www.wowhead.com"
        if args.input.startswith("http"):
            npcids, sub = fetch_npcids_from_search(args.input)
            if sub and sub != "/wow":
                base = base + sub
        else:
            npcids = map(int, args.input.split(","))

        npcs_byzone = {
            "UNKNOWN": []
        }
        for npcid in npcids:
            npc = fetchnpc(npcid, args.loot_filter, base)
            if not npc:
                print("couldn't fetch", npcid)
                continue
            if args.only_with_loot and not npc.get("loot", False):
                print("skipping no-loot")
                continue
            if "loot" in npc:
                npc["loot"] = [additemdata(item, base) for item in npc["loot"]]
            # print(lua.serialize(npc, key=__keysort, trailingcomma=True))
            if "locations" in npc:
                for location in npc["locations"]:
                    if "uiMapId" not in location:
                        npcs_byzone["UNKNOWN"].append(npc)
                        continue
                    if location["uiMapId"] not in npcs_byzone:
                        npcs_byzone[location["uiMapId"]] = []
                    npcs_byzone[location["uiMapId"]].append(npc)
            else:
                # no locations
                npcs_byzone["UNKNOWN"].append(npc)

        output = []
        for uiMapID, npcs in npcs_byzone.items():
            output_zone = False
            for npc in npcs:
                if "locations" in npc:
                    for location in npc["locations"]:
                        if not output_zone:
                            output.extend(("-- ", location.get("uiMapName", "Unknown"), " (", str(location.get("uiMapId", "???")), ")\n"))
                            output_zone = True
                        if (location.get("uiMapId") == uiMapID) or (uiMapID == "UNKNOWN" and "uiMapId" not in location):
                            output_npc(output, location["coords"], npc, 0)
                else:
                    # no locations
                    output_npc(output, [0], npc, 0)
        print("".join(output))
    else:
        for f in glob.glob(args.input, recursive=True):
            if args.export:
                print("Exporting", f)
                export(f, args.export, hn=args.export_handynotes, local=args.local)
            else:
                print("Updating", f)
                update(f)

