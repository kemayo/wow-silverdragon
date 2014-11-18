#!/usr/bin/python

import json
import re

from .fetch import Fetch
from . import NPC, types, pack_coords
from .zones import zoneid_to_mapid

WOWHEAD_URL = 'http://www.wowhead.com'
WOWHEAD_URL_PTR = 'http://wod.wowhead.com'

fetch = Fetch("wowhead.db")

zone_map = False

class WowheadNPC(NPC):
    def __page(self):
        page = fetch('%s/npc=%d' % (self.ptr and WOWHEAD_URL_PTR or WOWHEAD_URL, self.id))
        if not page:
            print("Couldn't fetch", '%s/npc=%d' % (self.ptr and WOWHEAD_URL_PTR or WOWHEAD_URL, self.id))
            return ''
        return page

    def _name(self):
        info = re.search(r"g_pageInfo = {type: 1, typeId: \d+, name: '(.+?)'};", self.__page())
        if info:
            return self.html_decode(info.group(1).replace("\\'", "'"))

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
            zone = int(zone)
            if not zoneid_to_mapid.get(zone, False):
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
            coords[zoneid_to_mapid[zone]] = [pack_coords(c[0], c[1]) for c in zcoords]
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
                return False

    def _quest(self):
        info = re.search(r'<pre id="questtracking">/run print\(IsQuestFlaggedCompleted\((\d+)\)\)</pre>', self.__page())
        if info:
            return int(info.group(1))

    @staticmethod
    def query(categoryid, expansion, ptr = False):
        url = "%s/npcs=%d&filter=cl=4:2;cr=39;crs=%d;crv=0" % (ptr and WOWHEAD_URL_PTR or WOWHEAD_URL, categoryid, expansion)

        page = fetch(url)
        match = re.search(r'new Listview\({[^{]+?data: \[(.+?)\]}\);\n', page)
        if not match:
            return {}
        npcs = {}
        for npc in (WowheadNPC(id, ptr=ptr) for id in re.findall(r'"id":(\d+)', match.group(1))):
            print(npc)
            npcs[npc.id] = npc
        return npcs
