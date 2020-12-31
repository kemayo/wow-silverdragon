# This is being lazy about dragging data in from my handynotes addons
# It could be better if I actually parsed the lua for the input file...

import os
import re
import sys

from npc import lua, __keysort


def transfer(inf, outf):
    print("Transferring", inf, outf)
    output = []
    with open(inf, 'r') as infile, open(outf, 'r') as outfile:
        npc_loot = {}
        for line in infile:
            # This is attempting to filter for a single-line table. I think
            # the parser could handle a multi-line one, but I'd need to write
            # more complex code to extract them... and overhaul the serializer
            # to pretty-print it.
            if "npc=" in line and "loot=" in line:
                tables = re.search(r"\[\d+\]\s*=\s*(\{.+\}),(?: --)?", line).group(1)
                table = lua.loadtable(tables)
                if table.get("loot"):
                    # *could* have the key but be nil
                    npc_loot[table['npc']] = table['loot']
        print("loot input", len(npc_loot))

        for line in outfile:
            match = re.search(r"\[(\d+)\] = ({.+}),$", line)
            if not match:
                output.append(line)
                continue

            npcid = int(match.group(1))
            if npcid in npc_loot:
                tables = match.group(2)
                table = lua.loadtable(tables)
                if oldloot := table.get('loot', None):
                    print("replacing loot for", npcid, oldloot, npc_loot[npcid])
                else:
                    print("adding loot for", npcid, npc_loot[npcid])
                table['loot'] = npc_loot[npcid]
                output.append(line[:match.start(2)] + lua.serialize(table, key=__keysort, trailingcomma=True) + line[match.end(2):])
                # output.append(re.sub(r"\[(\d+)\] = ({.+}),$", r"[$1] = ", line))
            else:
                output.append(line)
    with open(outf, 'w') as outfile:
        outfile.writelines(output)

if __name__ == '__main__':
    if os.path.isdir(sys.argv[1]):
        for f in os.listdir(sys.argv[1]):
            if f.endswith('.lua'):
                transfer(os.path.join(sys.argv[1], f), sys.argv[2])
    else:
        transfer(sys.argv[1], sys.argv[2])
