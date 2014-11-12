#!/usr/bin/python

import json
import re

from .fetch import Fetch
from . import NPC, types, pack_coords
from .zones import zonename_to_zoneid

WOWDB_URL = 'http://www.wowdb.com'
WOWDB_URL_PTR = 'http://beta.wowdb.com'

fetch = Fetch("wowdb.db")

zone_map = False

class WowdbNPC(NPC):
    soup = False
    def __page(self):
        return fetch('%s/npcs/%d' % (self.ptr and WOWDB_URL_PTR or WOWDB_URL, self.id))

    def _name(self):
        name = re.search(r'<h2 class="header">([^<]+?)</h2>', self.__page())
        if name:
            return name.group(1).replace('&#x27;', "'").replace('&quot;', '"')

    def _creature_type(self):
        ctype = re.search(r'<td class="right">([^<]+?)</td>', self.__page())
        if ctype:
            # for now get rid of the extra info on "Beast (Serpent)"
            return re.sub('\s+\(.+\)$', '', ctype.group(1))

    def _locations(self):
        page = self.__page()
        if not page:
            return
        # LocationMapper = new Mapper({"Text":"This npc can be found in $location.","Maps":{"394":{"Name":"Grizzly Hills","Floors":{"0":{"Name":"Grizzly Hills","Url":"//media-azeroth.cursecdn.com/attachments/26/576/grizzlyhills.jpg","Pins":[{"Type":"yellow","Url":null,"Coords":[72419,87286,87793,87796,100085,101630,102651]}],"Count":25}},"Count":25,"SelectedFloor":"0"}}});
        match = re.search(r"LocationMapper = new Mapper\(({.+?})\);", page)
        if not match:
            return
        data = json.loads(match.group(1))
        if not data.get('Maps'):
            return
        coords = {}
        for zone, zonedata in data.get('Maps').items():
            if "Name" not in zonedata or zonedata["Name"] not in zonename_to_zoneid:
                print("Got location for unknown zone", zonedata.get("Name", False), self.id)
                continue
            zcoords = []
            selected_floor = zonedata["SelectedFloor"]
            if selected_floor not in zonedata["Floors"]:
                continue
            if not zonedata["Floors"][selected_floor]["Pins"]:
                continue
            for pin in zonedata["Floors"][selected_floor]["Pins"]:
                for xy in pin["Coords"]:
                    x = ((xy >> 9) / 5) / 100
                    y = ((xy & 511) / 5) / 100
                    for oldx, oldy in zcoords:
                        if abs(oldx - x) < 0.05 and abs(oldy - y) < 0.05:
                            break
                    else:
                        # list fully looped through, not broken.
                        zcoords.append((x,y))
            coords[zonename_to_zoneid[zonedata["Name"]]] = [pack_coords(c[0], c[1]) for c in zcoords]
        return coords

    def _tameable(self):
        return "<li>Tamable</li>" in self.__page()

    def _elite(self):
        tooltip = re.search(r'<table class="tooltip-table">(.+?)</table>', self.__page())
        if tooltip:
            return "Elite)" in tooltip.group(1)

    def _level(self):
        tooltip = re.search(r'<table class="tooltip-table">(.+?)</table>', self.__page())
        if tooltip:
            level = re.search(r'<td colspan="2">Level (\d+)', tooltip.group(1))
            if level:
                return int(level.group(1))
            return False

    @staticmethod
    def query(creature_type, ptr = False):
        url = "%s/npcs/%s?filter-classification=20" % (ptr and WOWDB_URL_PTR or WOWDB_URL, creature_type.lower())

        npcs = {}
        pages_remaining = True
        while pages_remaining:
            print("Loading page", url)
            page = fetch(url)

            if not page:
                break

            for npc in (WowdbNPC(id, ptr=ptr) for id in re.findall(r'href="http://[^\.]+\.wowdb\.com/npcs/(\d+)-', page)):
                print(npc)
                npcs[npc.id] = npc

            next = re.search(r'<a href="([^"]+)" rel="next">', page)
            if next:
                url = (ptr and WOWDB_URL_PTR or WOWDB_URL) + next.group(1).replace('&amp;', '&').replace('cookieTest=1&', '')
            else:
                pages_remaining = False
        return npcs
