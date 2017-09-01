#!/usr/bin/python

import math

from . import lua

types = {
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
    15: 'Aberration'
}


class NPC:
    @classmethod
    def url(cls, ptr=False, beta=False):
        if beta:
            return cls.URL_BETA
        if ptr:
            return cls.URL_PTR
        return cls.URL

    def __init__(self, id, fetch=True, ptr=False, beta=False, session=None):
        self.id = int(id)
        self.ptr = ptr
        self.beta = beta
        self.data = {}
        self.session = session

        if fetch:
            self.load()

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

    def load(self):
        self.data['name'] = self._name()
        self.data['creature_type'] = self._creature_type()
        self.data['elite'] = self._elite()
        self.data['level'] = self._level()
        self.data['tameable'] = self._tameable()
        self.data['locations'] = self._filter_locations(self._locations()) or {}
        self.data['vignette'] = self._vignette()
        self.data['quest'] = self._quest()
        self.data['expansion'] = self._expansion()

        if self.data['vignette'] == self.data['name']:
            self.data['vignette'] = None

    def _name(self):
        pass
    def _creature_type(self):
        pass
    def _level(self):
        pass
    def _elite(self):
        pass
    def _tameable(self):
        pass
    def _locations(self):
        pass
    def _vignette(self):
        pass
    def _quest(self):
        pass
    def _expansion(self):
        pass

    def extend(self, npc):
        """Take the data from another NPC"""
        if npc.id != self.id:
            return

        locations = self._filter_locations(merge_locations(
            self.data.get('locations', {}),
            npc.data.get('locations', {})
        ))

        self.data.update(npc.clean_data())

        self.data['locations'] = locations

    def add_notes(self, notes):
        self.data['notes'] = notes

    def clean_data(self, *keys):
        return dict((k, v) for k, v in self.data.items() if (v and (len(keys) == 0 or k in keys)))

    def to_lua(self, *args, **kwargs):
        return lua.serialize(self.clean_data(*args, **kwargs))

    def html_decode(self, text):
        return text.replace('&#39;', "'").replace('&#x27;', "'").replace('&quot;', '"')

    def _filter_locations(self, locations):
        if self.id == 32491 and 950 in locations:
            # Time-lost needs to get cleaned up a little
            del(locations[950])
        cleaned = {}
        for zone, coords in locations.items():
            coords = set(coords)
            cleaned[zone] = set()
            removed = set()
            for xy in coords:
                if too_close(coords - removed, xy):
                    removed.add(xy)
                else:
                    cleaned[zone].add(xy)
            if cleaned[zone]:
                cleaned[zone] = list(cleaned[zone])
                cleaned[zone].sort()
        return cleaned


def pack_coords(x, y):
    return math.floor(x * 10000 + 0.5) * 10000 + math.floor(y * 10000 + 0.5)


def unpack_coords(coord):
    return math.floor(coord / 10000) / 10000, (coord % 10000) / 10000


def too_close(coords, xy):
    x, y = unpack_coords(xy)
    for otherxy in coords:
        if otherxy == xy:
            continue
        otherx, othery = unpack_coords(otherxy)
        if abs(otherx - x) < 0.05 and abs(othery - y) < 0.05:
            return True


def merge_locations(old, new):
    for zone, coords in new.items():
        if zone in old:
            old[zone].extend(coords)
        else:
            old[zone] = coords
    return old
