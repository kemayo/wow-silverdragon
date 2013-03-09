#!/usr/bin/python

import gzip
import json
import math
import re
import sqlite3

from io import BytesIO, StringIO
from urllib.request import Request, urlopen

from map import zonename_to_zoneid

__version__ = 1
USER_AGENT = 'SilverDragon/%s +http://davidlynch.org' % __version__
WOWHEAD_URL = 'http://www.wowhead.com/'

class Cache:
    """A store for values by date, sqlite-backed"""
    def __init__(self, storepath):
        """Initializes the store; creates tables if required

        storepath is the path to a sqlite database, and will be created
        if it doesn't already exist. (":memory:" will store everything
        in-memory, if you only need to use this as a temporary thing).
        """
        store = sqlite3.connect(storepath)
        self.store = store
        c = store.cursor()
        c.execute("""CREATE TABLE IF NOT EXISTS cache (url TEXT, content BLOB, time TEXT, PRIMARY KEY (url))""")
        self.store.commit()
        c.close()
    def set(self, url, value):
        """Add a value to the store, at the current time

        url is a string that the value will be associated with
        value is the value to be stored
        """
        c = self.store.cursor()
        c.execute("""REPLACE INTO cache VALUES (?, ?, CURRENT_TIMESTAMP)""", (url, value,))
        self.store.commit()
        c.close()
    def get(self, url):
        """Fetch a given url's data

        type is a string to fetch all associated values for
        """
        c = self.store.cursor()
        c.execute("""SELECT content FROM cache WHERE url = ? AND datetime(time, '+1 day') > datetime('now')""", (url,))
        row = c.fetchone()
        c.close()
        if row:
            return row[0]
        return False
CACHE = Cache("wowhead.db")

def _fetch(url, data=None, cached=True, ungzip=True):
    """A generic URL-fetcher, which handles gzipped content, returns a string"""
    if cached and CACHE.get(url):
        return CACHE.get(url)
    request = Request(url)
    request.add_header('Accept-encoding', 'gzip')
    request.add_header('User-agent', USER_AGENT)
    try:
        f = urlopen(request, data)
    except Exception as e:
        return None
    data = f.read()
    if ungzip and f.headers.get('content-encoding', '') == 'gzip':
        data = gzip.GzipFile(fileobj=BytesIO(data), mode='r').read()
        try:
            data = data.decode()
        except UnicodeDecodeError:
            data = data.decode('latin1')
    f.close()
    CACHE.set(url, data)
    return data

def _lua_value(v):
    if v == None:
        return 'nil'
    t = type(v)
    if t == str:
        return '"' + v.replace('"', '\\"') + '"'
    if t in (list, tuple, set):
        return '{' + ','.join(map(_lua_value, v)) + '}'
    if t == dict:
        out = ['{']
        for k in v:
            vk = _lua_value(v[k])
            k = str(k)
            if k.isnumeric():
                out.extend(('[', k, ']'))
            elif not k.isalnum():
                out.extend(('["', k, '"]'))
            else:
                out.append(k)
            out.extend(('=', vk, ','))
        out.append('}')
        return ''.join(out)
    if t == bool:
        return v and 'true' or 'false'
    return str(v)

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
    page = _fetch("http://static.wowhead.com/js/locale_enus.js?250")
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
        return _fetch('%snpc=%d' % (WOWHEAD_URL, self.id))
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
        return _lua_value(self.data)

def npcs_from_list_page(url):
    page = _fetch(url)
    match = re.search(r'new Listview\({[^{]+?data: \[(.+?)\]}\);\n', page)
    if not match:
        return {}
    npcs = {}
    for npc in (NPC(id) for id in re.findall(r'"id":(\d+)', match.group(1))):
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

    write_output("defaults.lua", defaults)
    print("Defaults written")