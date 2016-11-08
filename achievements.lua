local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

local achievements = {
	[1312] = {}, -- Bloody Rare (BC mobs)
	[2257] = {}, -- Frostbitten (Wrath mobs)
	[7317] = {}, -- One Many Army (Vale)
	[7439] = {}, -- Glorious! (Pandaria mobs)
	[8103] = {}, -- Champions of Lei Shen (Thunder Isle)
	[8714] = {}, -- Timeless Champion (Timeless Isle)
	[9216] = {}, -- High-value targets (Ashran)
	[9216] = {}, -- HighValueTargets
	[9400] = {}, -- Gorgrond Monster Hunter
	[9541] = {}, -- The Song of Silence
	[9571] = {}, -- Broke Back Precipice
	[9617] = {}, -- Making the Cut
	[9633] = {}, -- Cut off the Head (Shatt)
	[9638] = {}, -- Heralds of the Legion (Shatt)
	[9655] = {}, -- Fight the Power (Gorgrond)
	[9678] = {}, -- Ancient No More (Gorgrond)
	[10061] = {}, -- Hellbane (Tanaan)
	[10070] = {}, -- Jungle Stalker (Tanaan)
	[11160] = {}, -- UnleashedMonstrosities
	[11261] = {}, -- AdventurerOfAzsuna
	[11262] = {}, -- AdventurerOfValsharah
	[11263] = {}, -- AdventurerOfStormheim
	[11264] = {}, -- AdventurerOfHighmountain
	[11265] = {}, -- AdventurerOfSuramar
}
local mobs_to_achievement = {
	-- [43819] = 2257,
}
local achievements_loaded = false

function ns:AchievementMobStatus(id)
	if not achievements_loaded then
		self:LoadAllAchievementMobs()
	end
	local achievement = mobs_to_achievement[id]
	if not achievement then
		return
	end
	local criteria = achievements[achievement][id]
	local _, name = GetAchievementInfo(achievement)
	local _, _, completed = GetAchievementCriteriaInfo(achievement, criteria)
	return achievement, name, completed
end

function ns:LoadAllAchievementMobs()
	if achievements_loaded then
		return
	end
	for achievement in pairs(achievements) do
		local num_criteria = GetAchievementNumCriteria(achievement)
		for i = 1, num_criteria do
			local description, ctype, completed, _, _, _, _, id = GetAchievementCriteriaInfo(achievement, i)
			if ctype == 0 then
				-- "kill a mob"
				achievements[achievement][id] = i
				mobs_to_achievement[id] = achievement
			elseif ctype == 27 then
				-- "complete a quest"

			end
			achievements_loaded = true
		end
	end
end
-- return complete, completion_knowable
function ns:IsMobComplete(id)
	local name, questid, vignette, tameable, last_seen, times_seen = core:GetMobInfo(id)
	if questid then
		return IsQuestFlaggedCompleted(questid), true
	end
	if mobs_to_achievement[id] then
		achievement, achievement_name, complete = ns:AchievementMobStatus(id)
		return complete, achievement
	end
end
