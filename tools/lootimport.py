# This is being lazy about dragging data in from my handynotes addons
# It could be better if I actually parsed the lua for the input file...

import re
import sys

def main(inf, outf):
    output = []
    with open(inf, 'r') as infile, open(outf, 'r') as outfile:
        npc_loot = {}
        for line in infile:
            if "npc=" in line and "loot=" in line:
                npcid = re.search(r"npc=(\d+)", line).group(1)
                loot = re.search(r"loot={(.+?)},", line).group(1)
                npc_loot[npcid] = loot
        # print(npc_loot)
        print("loot input", len(npc_loot))

        for line in outfile:
            match = re.search(r"\[(\d+)\] = {name", line)
            if not match:
                output.append(line)
                continue
            npcid = match.group(1)
            if npcid in npc_loot:
                # print("loot for", npcid, npc_loot[npcid])
                if "loot=" in line:
                    # replace existing loot
                    output.append(re.sub(r"loot={.+},quest", f"loot={{{npc_loot[npcid]}}},quest", line))
                    print("replaced loot for", npcid, npc_loot[npcid])
                else:
                    output.append(line.replace(",quest", f",loot={{{npc_loot[npcid]}}},quest"))
                    print("added loot for", npcid, npc_loot[npcid])
            else:
                output.append(line)
    with open(outf, 'w') as outfile:
        outfile.writelines(output)

if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
