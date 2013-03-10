
import npc.wowhead, npc.wowdb

war_head = npc.wowhead.WowheadNPC(69841)
war_db = npc.wowdb.WowdbNPC(69841)

print("Wowhead", war_head.to_lua())
print("Wowdb", war_db.to_lua())

war_db.extend(war_head)
print("merged", war_db.to_lua())