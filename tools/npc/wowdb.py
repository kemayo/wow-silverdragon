#!/usr/bin/python

import json
import re

from . import NPC, pack_coords
from .zones import zoneid_to_mapid

zone_map = False


class WowdbNPC(NPC):
    URL = 'http://www.wowdb.com'
    URL_PTR = 'http://ptr.wowdb.com'
    URL_BETA = 'http://beta.wowdb.com'

    page = False

    def __page(self):
        if self.page is False:
            url = '%s/npcs/%d' % (self.url(ptr=self.ptr, beta=self.beta), self.id)
            self.page = self.session.get(url).text
            if not self.page:
                print("Couldn't fetch", url)
        return self.page

    def _name(self):
        name = re.search(r'<h2 class="header">([^<]+?)</h2>', self.__page())
        if name:
            return self.html_decode(name.group(1))

    def _creature_type(self):
        ctype = re.search(r'%s</dt>\s*<dd class="db-right">([^<]+?)</dd>' % self._name(), self.__page())
        if ctype:
            # for now get rid of the extra info on "Beast (Serpent)"
            return re.sub('\s+\(.+\)$', '', ctype.group(1))

    def _locations(self):
        page = self.__page()
        if not page:
            return {}
        # LocationMapper = new Mapper({"Text":"This npc can be found in $location.","Maps":{"394":{"Name":"Grizzly Hills","Floors":{"0":{"Name":"Grizzly Hills","Url":"//media-azeroth.cursecdn.com/attachments/26/576/grizzlyhills.jpg","Pins":[{"Type":"yellow","Url":null,"Coords":[72419,87286,87793,87796,100085,101630,102651]}],"Count":25}},"Count":25,"SelectedFloor":"0"}}});
        match = re.search(r"LocationMapper = new Mapper\(({.+?})\);", page)
        if not match:
            return {}
        data = json.loads(match.group(1))
        if not data.get('Maps'):
            return {}
        coords = {}
        for zone, zonedata in data.get('Maps').items():
            zone = int(zone)
            if "Name" not in zonedata or not zoneid_to_mapid.get(zone, False):
                print("Got location for unknown zone", zonedata.get("Name", False), zone, self.id)
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
                        zcoords.append((x, y))
            coords[zoneid_to_mapid[zone]] = [pack_coords(c[0], c[1]) for c in zcoords]
        return coords

    def _tameable(self):
        return "<li>Tamable</li>" in self.__page()

    def _vignette(self):
        page = self.__page()
        if not page:
            return
        # this is making a bit of an assumption about the quest names matching up, of course
        match = re.search(r'<a href="[^"]+">Vignette: ([^<]+)</a>', page)
        if not match:
            return
        return self.html_decode(match.group(1))

    def _quest(self):
        page = self.__page()
        if not page:
            return
        match = re.search(r'<a href="[^"]+/quests/(\d+)-[^"]+">[^<]*Vignette[^<]*</a>', page)
        if not match:
            return
        return int(match.group(1))

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

    def _expansion(self):
        patch = re.search(r'<li>Added in Patch (\d+)', self.__page())
        if patch:
            return int(patch.group(1))

    @classmethod
    def query(cls, creature_type, session, expansion=False, ptr=False, beta=False, cached=True, **kw):
        url = "%s/npcs/%s?filter-classification=20" % (cls.url(ptr=ptr, beta=beta), creature_type.lower())
        if expansion:
            url += "&filter-expansion=%d" % expansion

        npcs = {}
        pages_remaining = True
        while pages_remaining:
            print("Loading page", url)
            if cached:
                page = session.get(url, **kw)
            else:
                with session.cache_disabled():
                    page = session.get(url, **kw)

            for npc in (WowdbNPC(id, ptr=ptr, session=session) for id in re.findall(r'href="http://[^\.]+\.wowdb\.com/npcs/(\d+)-', page.text)):
                print(npc)
                npcs[npc.id] = npc

            nextpage = re.search(r'<a href="([^"]+?)" rel="next">', page.text)
            if nextpage:
                url = cls.url(ptr=ptr, beta=beta) + nextpage.group(1).replace('&amp;', '&').replace('cookieTest=1&', '')
            else:
                pages_remaining = False
        return npcs
