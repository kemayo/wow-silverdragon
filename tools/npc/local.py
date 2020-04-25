#!/usr/bin/python

import re

from . import NPC, lua


class LocalNPC(NPC):
    def __init__(self, id, data, *args, **kw):
        NPC.__init__(self, id, *args, **kw)
        if "locations" in data:
            try:
                data["locations"] = self._filter_locations(data["locations"])
            except Exception as e:
                print("FAILED", id, data)
                raise e
        self.data.update(data)

    # This was used to remap zone ids, once, and is kept against that future need
    # def _filter_locations(self, locations):
    #     global mapmap
    #     if not mapmap:
    #         import csv
    #         mapmap = {}
    #         with open('UIMapIDToWorldMapAreaID.csv', newline='') as csvfile:
    #             reader = csv.DictReader(csvfile)
    #             for row in reader:
    #                 if not row['DungeonMapID'] or row['DungeonFloor'] == '1':
    #                     mapmap[int(row['WorldMapAreaID'])] = int(row['UiMapID'])
    #     cleaned = {}
    #     for zone, coords in locations.items():
    #         cleaned[mapmap[zone]] = coords
    #     return NPC._filter_locations(self, cleaned)

    def load(self):
        pass


def load(filename):
    npcdata = {}
    with open(filename, "r") as f:
        for line in f:
            m = re.match(r"^\s+\[(\d+)\]\s*=\s*(\{.+\}),$", line)
            if m:
                npcid = int(m.group(1))
                # print(m.groups())
                data = lua.loadtable(m.group(2))
                if data:
                    data["name"] = data["name"].replace("\\", "")
                    if "locations" in data and type(data["locations"]) == list:
                        # lua table parser treats {[1]='a',[2]='b'} as equivalent to {'a','b'}
                        # In this case we know that's wrong, so:
                        locations = {}
                        for i, v in enumerate(data["locations"], 1):
                            locations[i] = v
                        data["locations"] = locations
                    npcdata[npcid] = LocalNPC(npcid, data)
    return npcdata
