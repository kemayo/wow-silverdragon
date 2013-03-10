#!/usr/bin/python

import json
import math
import re

from map import zonename_to_zoneid
from fetch import Fetch
import lua

WOWHEAD_URL = 'http://www.wowhead.com/'

fetch = Fetch("wowhead.db")

npctypes = {
    1: 'Beast',
    2: 'Dragonkin',
    3: 'Demon',
    4: 'Elemental',
    5: 'Giant',
    6: 'Undead',
    7: 'Humanoid',
    8: 'Critter',
    9: 'Mechanical',
    10: 'Uncategorized',
}
blacklist = (
    50091, # untargetable Julak-Doom component
)
force_include = (
    17591, # Blood Elf Bandit
    50409, # Mysterious Camel Figurine
    50410, # Mysterious Camel Figurine (remnants)
    3868, # Blood Seeker (thought to share Aeonaxx's spawn timer)
    51236, # Aeonaxx (engaged)
    58336, # Darkmoon Rabbit
    # Lost and Found!
    64004, # Ghostly Pandaren Fisherman
    64191, # Ghostly Pandaren Craftsman
    65552, # Glinting Rapana Whelk
    64272, # Jade Warrior Statue
    64227, # Frozen Trail Packer
    #In 5.2, world bosses are no longer flagged as rare, even if they are.
    #Granted, 3 of 4 probably won't be rare. We include anyways because we always have.
    60491, # Sha of Anger
    62346, # Galleon
    69099, # Nalak
    69161, # Oondasta
)
name_overrides = {
    50410: "Crumbled Statue Remnants",
    51401: "Madexx (red)",
    51402: "Madexx (green)",
    51403: "Madexx (black)",
    51404: "Madexx (blue)",
    50154: "Madexx (brown)",
    51236: "Aeonaxx (engaged)",
    69769: "Zandalari Warbringer (Slate)",
    69841: "Zandalari Warbringer (Amber)",
    69842: "Zandalari Warbringer (Jade)",
}
zones = {}

def pack_coords(x, y):
    return math.floor(x * 10000 + 0.5) * 10000 + math.floor(y * 10000 + 0.5)
def unpack_coords(coord):
    return math.floor(coord / 10000) / 10000, (coord % 10000) / 10000

def zone_mappings():
    page = fetch("http://static.wowhead.com/js/locale_enus.js?250")
    if not page:
        return
    match = re.search(r"g_zones = ({[^}]+});", page)
    if not match:
        return
    for id, name in re.findall(r'"(\d+)":"([^"]+)"', match.group(1)):
        if name in zonename_to_zoneid:
            zones[int(id)] = zonename_to_zoneid[name]
        else:
            print("Skipping zone translation", name)

class NPC:
    def __init__(self, id, fetch = True):
        self.id = int(id)
        self.data = {}
        if fetch:
            page = self.__page()
            if not page:
                return
            if self.id in name_overrides:
                self.data['name'] = name_overrides[self.id]
            else:
                info = re.search(r"g_pageInfo = {type: 1, typeId: \d+, name: '(.+?)'};", page)
                if info:
                    self.data['name'] = info.group(1).replace("\\'", "'")
            info = re.search(r"PageTemplate\.set\({breadcrumb: \[0,4,(\d+),0\]}\);", page)
            if info:
                self.data['creature_type'] = npctypes.get(int(info.group(1)), None)
            info = re.search(r"Markup\.printHtml\('(.+?)', .+?}\);", page)
            if info:
                level = re.search(r"Level\\x3A\\x20(.+?)\\x5B", info.group(1))
                if level:
                    if level.group(1).isnumeric():
                        self.data['level'] = int(level.group(1))
                    else:
                        self.data['level'] = -1
                if "Classification\\x3A\\x20Rare\\x20Elite" in info.group(1):
                    self.data['elite'] = True

            if bool('\\x5DTameable\\x20' in page):
                self.data['tameable'] = True
            locations = self.locations()
            if locations:
                self.data['locations'] = locations
    def __str__(self):
        return self.data.get('name', self.id)
    def __repr__(self):
        return '<NPC:%d:%s>' % (self.id, self.data.get('name', '???'))
    def __eq__(self, other):
        try:
            return self.id == other.id
        except:
            return False
    def __hash__(self):
        return self.id
    def __page(self):
        return fetch('%snpc=%d' % (WOWHEAD_URL, self.id))
    def locations(self):
        page = self.__page()
        if not page:
            return
        match = re.search(r"var g_mapperData = {([^;]+)};", page)
        if not match:
            return
        coords = {}
        for zone, data in re.findall(r'^,?(\d+): {\n\d: {[^}]*coords: (\[.+?\]) }.*?\n}$', match.group(1), re.MULTILINE):
            zone = int(zone)
            if zone not in zones:
                print("Got location for unknown zone", zone, self.id)
                continue
            zcoords = []
            for x, y in ((c[0]/100, c[1]/100) for c in json.loads(data)):
                for oldx, oldy in zcoords:
                    if abs(oldx - x) < 0.05 and abs(oldy - y) < 0.05:
                        break
                else:
                    # list fully looped through, not broken.
                    zcoords.append((x,y))
            coords[zones[zone]] = [pack_coords(c[0], c[1]) for c in zcoords]
        return coords
    def to_lua(self):
        return lua.serialize(self.data)

def npcs_from_list_page(url):
    page = fetch(url)
    match = re.search(r'new Listview\({[^{]+?data: \[(.+?)\]}\);\n', page)
    if not match:
        return {}
    npcs = {}
    for npc in (NPC(id) for id in re.findall(r'"id":(\d+)', match.group(1))):
        if npc in blacklist:
            continue
        print(npc)
        npcs[npc.id] = npc
    return npcs

def write_output(filename, data):
    with open(filename, 'w') as f:
        f.write("""-- DO NOT EDIT THIS FILE; run dataminer.lua to regenerate.
local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Data")
function module:GetDefaults()
\treturn {
""")
        for id, mob in sorted(data.items()):
            f.write('\t\t[%d] = %s,\n' % (id, mob.to_lua()))
        f.write("""\t}
end
""")

if __name__ == '__main__':
    defaults = {}
    zone_mappings()
    for i, c in npctypes.items():
        print("ACQUIRING rares for category", i, c)
        for expansion in range(1, 6):
            print("EXPANSION", expansion)
            # run per-expansion to avoid caps on results-displayed
            url = "%snpcs=%d&filter=cl=4:2;cr=39;crs=%d;crv=0" % (WOWHEAD_URL, i, expansion)
            defaults.update(npcs_from_list_page(url))
    for id in force_include:
        if id not in defaults:
            defaults[id] = NPC(id)

    write_output("../Data/defaults.lua", defaults)
    print("Defaults written")