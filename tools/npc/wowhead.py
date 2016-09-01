#!/usr/bin/python

import json
import re
import yaml

from . import NPC, types, pack_coords
from .zones import zoneid_to_mapid

zone_map = False


class WowheadNPC(NPC):
    URL = 'http://www.wowhead.com'
    URL_PTR = 'http://ptr.wowhead.com'
    URL_BETA = 'http://legion.wowhead.com'

    def __page(self):
        url = '%s/npc=%d' % (self.url(ptr=self.ptr, beta=self.beta), self.id)
        page = self.session.get(url)
        if not page:
            print("Couldn't fetch", url)
            return ''
        return page.text

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
            data = json.loads(data)
            if type(data[0]) == float:
                data = [data]
            for x, y in ((c[0] / 100, c[1] / 100) for c in data):
                for oldx, oldy in zcoords:
                    if abs(oldx - x) < 0.05 and abs(oldy - y) < 0.05:
                        break
                else:
                    # list fully looped through, not broken.
                    zcoords.append((x, y))
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
        return questSearch(self._name(), self.session)

    @classmethod
    def query(cls, categoryid, expansion, session, ptr=False, beta=False, cached=True, **kw):
        url = "%s/npcs=%d&filter=cl=4:2;cr=39;crs=%d;crv=0" % (cls.url(ptr=ptr, beta=beta), categoryid, expansion)

        if cached:
            page = session.get(url, **kw)
        else:
            with session.cache_disabled():
                page = session.get(url, **kw)

        match = re.search(r'new Listview\({[^{]+?data: \[(.+?)\]}\);\n', page.text)
        if not match:
            return {}
        npcs = {}
        for npc in (WowheadNPC(id, ptr=ptr, session=session) for id in re.findall(r'"id":(\d+)', match.group(1))):
            print(npc)
            npcs[npc.id] = npc
        return npcs


class WowHeadQuestSearch:
    def __init__(self):
        self.quests = False

    def __call__(self, name, session):
        if not self.quests:
            questpage = session.get('http://www.wowhead.com/quests/name:vignette').text
            match = re.search(r"^new Listview\({.+?id: ?'quests', ?data: ?(.+)}\);$", questpage, re.MULTILINE)
            self.quests = [(q['id'], q['name'].replace('Vignette: ', '')) for q in yaml.load(match.group(1))]
        matcher = re.compile(r'\b%s\b' % name)
        for quest in self.quests:
            if matcher.search(quest[1]):
                return quest[0]

questSearch = WowHeadQuestSearch()
