#!/usr/bin/python

import json
import re

from .fetch import Fetch
from . import NPC, types, pack_coords
from .zones import zonename_to_zoneid

WOWHEAD_URL = 'http://www.wowhead.com/'

fetch = Fetch("wowhead.db")

zone_map = False

class WowheadNPC(NPC):
    def __page(self):
        return fetch('%snpc=%d' % (WOWHEAD_URL, self.id))

    def _name(self):
        info = re.search(r"g_pageInfo = {type: 1, typeId: \d+, name: '(.+?)'};", self.__page())
        if info:
            return info.group(1).replace("\\'", "'")

    def _creature_type(self):
        info = re.search(r"PageTemplate\.set\({breadcrumb: \[0,4,(\d+),0\]}\);", self.__page())
        if info:
            return types.get(int(info.group(1)), None)

    def _locations(self):
        page = self.__page()
        if not page:
            return
        match = re.search(r"var g_mapperData = {([^;]+)};", page)
        if not match:
            return
        coords = {}
        for zone, data in re.findall(r'^,?(\d+): {\n\d: {[^}]*coords: (\[.+?\]) }.*?\n}$', match.group(1), re.MULTILINE):
            if not self.__zone(zone):
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
            coords[self.__zone(zone)] = [pack_coords(c[0], c[1]) for c in zcoords]
        return coords

    def _tameable(self):
        return bool('\\x5DTameable\\x20' in self.__page())

    def _elite(self):
        info = re.search(r"Markup\.printHtml\('(.+?)', .+?}\);", self.__page())
        if info:
            return ("Classification\\x3A\\x20Rare\\x20Elite" in info.group(1)) or ("Classification\\x3A\\x20Elite" in info.group(1))

    def _level(self):
        info = re.search(r"Markup\.printHtml\('(.+?)', .+?}\);", self.__page())
        if info:
            level = re.search(r"Level\\x3A\\x20(.+?)\\x5B", info.group(1))
            if level:
                if level.group(1).isnumeric():
                    return int(level.group(1))
                return -1

    @staticmethod
    def __zone(wowhead_zone):
        global zone_map
        if not zone_map:
            zone_map = {}
            page = fetch("http://static.wowhead.com/js/locale_enus.js?250")
            if not page:
                return
            match = re.search(r"g_zones = ({[^}]+});", page)
            if not match:
                return
            for id, name in re.findall(r'"(\d+)":"([^"]+)"', match.group(1)):
                if name in zonename_to_zoneid:
                    zone_map[int(id)] = zonename_to_zoneid[name]
                else:
                    print("Skipping zone translation", name)
        return zone_map.get(int(wowhead_zone), False)

    @staticmethod
    def query(categoryid, expansion):
        url = "%snpcs=%d&filter=cl=4:2;cr=39;crs=%d;crv=0" % (WOWHEAD_URL, categoryid, expansion)

        page = fetch(url)
        match = re.search(r'new Listview\({[^{]+?data: \[(.+?)\]}\);\n', page)
        if not match:
            return {}
        npcs = {}
        for npc in (WowheadNPC(id) for id in re.findall(r'"id":(\d+)', match.group(1))):
            print(npc)
            npcs[npc.id] = npc
        return npcs
