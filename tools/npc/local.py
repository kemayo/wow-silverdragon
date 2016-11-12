#!/usr/bin/python

import re

from . import NPC, lua


class LocalNPC(NPC):
    def __init__(self, id, data, *args, **kw):
        NPC.__init__(self, id, *args, **kw)
        self.data.update(data)

    def load(self):
        pass


def load(filename):
    npcdata = {}
    with open(filename, 'r') as f:
        for line in f:
            m = re.match(r'^\s+\[(\d+)\]\s*=\s*(\{.+\}),$', line)
            if m:
                npcid = int(m.group(1))
                # print(m.groups())
                data = lua.loadtable(m.group(2))
                if data:
                    data['name'] = data['name'].replace('\\', '')
                    # print(data)
                    npcdata[npcid] = LocalNPC(npcid, data)
    return npcdata
