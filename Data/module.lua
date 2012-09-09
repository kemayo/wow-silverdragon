local BCTR = LibStub("LibBabble-CreatureType-3.0"):GetReverseLookupTable()

local R = LibStub("AceLocale-3.0"):GetLocale("SilverDragon_Rares")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Data")

function module:Import()
	if not self.GetDefaults then return end
	local defaults = self:GetDefaults()
	local gdb = core.db.global
	local mob_count = 0
	for zone, mobs in pairs(defaults) do
		for id, info in pairs(mobs) do
			local name = R[info.name] -- gets it into the local language
			mob_count = mob_count + 1
			gdb.mob_id[name] = id
			gdb.mob_name[id] = name
			gdb.mob_level[id] = info.level
			gdb.mob_type[id] = BCTR[info.creature_type]
			gdb.mob_tameable[id] = info.tameable
			gdb.mob_elite[id] = info.elite
			if not gdb.mob_seen[id] then gdb.mob_seen[id] = 0 end
			if not gdb.mobs_byzoneid[zone][id] then
				gdb.mobs_byzoneid[zone][id] = {} -- never seen
				for _, loc in pairs(info.locations) do
					table.insert(gdb.mobs_byzoneid[zone][id], loc)
				end
			else
				for _, loc in pairs(info.locations) do
					local new_x, new_y = core:GetXY(loc)
					local newloc = true
					for _, oldloc in pairs(gdb.mobs_byzoneid[zone][id]) do
						local old_x, old_y = core:GetXY(loc)
						if math.abs(new_x - old_x) < 0.05 and math.abs(new_y - old_y) < 0.05 then
							newloc = false
							break
						end
					end
					if newloc then
						table.insert(gdb.mobs_byzoneid[zone][id], loc)
					end
				end
			end
		end
	end
	defaults = nil
	return mob_count
end

