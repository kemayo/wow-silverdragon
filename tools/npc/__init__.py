#!/usr/bin/python

import math

from . import lua

types = {
    1: "Beast",
    2: "Dragonkin",
    3: "Demon",
    4: "Elemental",
    5: "Giant",
    6: "Undead",
    7: "Humanoid",
    8: "Critter",
    9: "Mechanical",
    10: "Uncategorized",
    15: "Aberration",
}

petfamilies = {
    1: ('Wolf', 132203),
    2: ('Cat', 132185),
    3: ('Spider', 132196),
    4: ('Bear', 132183),
    5: ('Boar', 132184),
    6: ('Crocolisk', 132187),
    7: ('Carrion Bird', 132200),
    8: ('Crab', 132186),
    9: ('Gorilla', 132189),
    11: ('Raptor', 132193),
    12: ('Tallstrider', 132198),
    20: ('Scorpid', 132195),
    21: ('Turtle', 132199),
    24: ('Bat', 132182),
    25: ('Hyena', 132190),
    26: ('Bird of Prey', 132192),
    27: ('Wind Serpent', 132202),
    30: ('Dragonhawk', 132188),
    31: ('Ravager', 132194),
    32: ('Warp Stalker', 132201),
    33: ('Sporebat', 132197),
    34: ('Ray', 132191),
    35: ('Serpent', 136040),
    37: ('Moth', 236193),
    38: ('Chimaera', 236190),
    39: ('Devilsaur', 236192),
    41: ('Aqiri', 236195),
    42: ('Worm', 236197),
    43: ('Clefthoof', 1044794),
    44: ('Wasp', 236196),
    45: ('Core Hound', 236191),
    46: ('Spirit Beast', 236165),
    50: ('Fox', 458223),
    51: ('Monkey', 877482),
    52: ('Hound', 877481),
    53: ('Beetle', 133570),
    55: ('Shale Beast', 877478),
    68: ('Hydra', 463493),
    125: ('Crane', 877479),
    126: ('Water Strider', 643423),
    127: ('Rodent', 644001),
    128: ('Stone Hound', 625905),
    129: ('Gruffhorn', 877477),
    130: ('Basilisk', 877476),
    138: ('Direhorn', 877480),
    150: ('Riverbeast', 1044490),
    151: ('Stag', 1044501),
    154: ('Mechanical', 132247),
    156: ('Scalehide', 646378),
    157: ('Oxen', 616693),
    160: ('Feathermane', 929300),
    288: ('Lizard', 2027936),
    290: ('Pterrordax', 1624590),
    291: ('Toad', 804969),
    292: ('Carapid', 2011146),
    296: ('Blood Beast', 1687702),
    298: ('Camel', 454771),
    299: ('Courser', 2143073),
    300: ('Mammoth', 132254)
}


def __keysort(k):
    # Yeah, this isn't very generic. But I want 'name' to always be first.
    if k == "name":
        return "aaaaaaaaa"
    if k == "hidden":
        return "zzzzzzzzz"
    return str(k)


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
            try:
                self.load()
            except Exception as e:
                print("error fetching", self.id, self.data)
                raise e

    def __str__(self):
        return self.data.get("name", self.id)

    def __repr__(self):
        return "<NPC:%d:%s>" % (self.id, self.data.get("name", "???"))

    def __eq__(self, other):
        try:
            return self.id == other.id
        except:
            return False

    def __hash__(self):
        return self.id

    def load(self):
        self.data["name"] = self._name()
        self.data["creature_type"] = self._creature_type()
        self.data["elite"] = self._elite()
        self.data["level"] = self._level()
        self.data["tameable"] = self._tameable()
        self.data["locations"] = self._filter_locations(self._locations()) or {}
        self.data["vignette"] = self._vignette()
        self.data["quest"] = self._quest()
        self.data["expansion"] = self._expansion()

        if self.data["vignette"] == self.data["name"]:
            self.data["vignette"] = None

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

        locations = self._filter_locations(
            merge_locations(
                self.data.get("locations", {}), npc.data.get("locations", {})
            )
        )

        self.data.update(npc.clean_data())

        self.data["locations"] = locations

    def add_notes(self, notes):
        self.data["notes"] = notes

    def clean_data(self, *keys):
        return dict(
            (k, v)
            for k, v in self.data.items()
            if (v and (len(keys) == 0 or k in keys))
        )

    def to_lua(self, *args, **kwargs):
        return lua.serialize(self.clean_data(*args, **kwargs), key=__keysort)

    def html_decode(self, text):
        return text.replace("&#39;", "'").replace("&#x27;", "'").replace("&quot;", '"')

    def _filter_locations(self, locations):
        if self.id == 32491 and 550 in locations:
            # Time-lost needs to get cleaned up a little, removed from Nagrand
            del locations[550]
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
