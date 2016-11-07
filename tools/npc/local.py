#!/usr/bin/python

import re

from . import NPC, lua


class LocalNPC(NPC):
    def __init__(self, id, data, *args, **kw):
        NPC.__init__(self, id, *args, **kw)
        self.data.update(data)

    def load(self):
        pass

    def _name(self):
        return self.data['name']

    def _creature_type(self):
        return self.data.get('creature_type')

    def _level(self):
        return self.data.get('level')

    def _elite(self):
        return self.data.get('elite')

    def _tameable(self):
        return self.data.get('tameable')

    def _locations(self):
        return self.data.get('locations', [])

    def _vignette(self):
        return self.data.get('vignette')

    def _quest(self):
        return self.data.get('quest')

    def _expansion(self):
        return self.data.get('expansion')


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
