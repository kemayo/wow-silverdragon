local BCTR = LibStub("LibBabble-CreatureType-3.0"):GetReverseLookupTable()

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Data")

function module:Import(callback)
	if not self.GetDefaults then return end
	local defaults = self:GetDefaults()
	local mob_count = 0
	for id, info in pairs(defaults) do
		if (not callback) or callback(id, info) then
			self:ImportMob(id, info)
			mob_count = mob_count + 1
		end
	end
	defaults = nil
	return mob_count
end

function module:ImportAchievementMobs(...)
	local mobs = {}
	for i=1, select('#', ...) do
		local achievement = select(i, ...)
		local num_criteria = GetAchievementNumCriteria(achievement)
		for i = 1, num_criteria do
			local description, ctype, completed, _, _, _, _, id = GetAchievementCriteriaInfo(achievement, i)
			if ctype == 0 then
				mobs[id] = true
			end
		end
	end
	return self:Import(function(id, info)
		return mobs[id]
	end)
end

function module:ImportMob(id, info)
	local gdb = core.db.global
	local name = info.name
	gdb.mob_id[name] = id
	gdb.mob_name[id] = name
	gdb.mob_level[id] = info.level
	gdb.mob_type[id] = BCTR[info.creature_type]
	gdb.mob_tameable[id] = info.tameable
	gdb.mob_elite[id] = info.elite
	gdb.mob_notes[id] = info.notes
	gdb.mob_quests[id] = info.quest
	if info.vignette then
		if gdb.mob_vignettes[info.vignette] and gdb.mob_vignettes[info.vignette] ~= id then
			core.Debug("Duplicate vignette import", info.vignette, id, gdb.mob_vignettes[info.vignette])
		end
		gdb.mob_vignettes[info.vignette] = id
	end
	if not gdb.mob_seen[id] then gdb.mob_seen[id] = 0 end
	if not info.locations then
		return
	end
	for zone,coords in pairs(info.locations) do
		if not gdb.mobs_byzoneid[zone][id] then
			gdb.mobs_byzoneid[zone][id] = {} -- never seen
			for _, loc in pairs(coords) do
				table.insert(gdb.mobs_byzoneid[zone][id], loc)
			end
		else
			for _, loc in pairs(coords) do
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
