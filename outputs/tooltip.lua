local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Tooltip", "AceEvent-3.0")
local Debug = core.Debug

local achievements = {
	[1312] = {}, -- Bloody Rare (BC mobs)
	[2257] = {}, -- Frostbitten (Wrath mobs)
	[7439] = {}, -- Glorious! (Pandaria mobs)
	[8103] = {}, -- Champions of Lei Shen (Thunder Isle)
	[8714] = {}, -- Timeless Champion (Timeless Isle)
	[7317] = {}, -- One Many Army (Vale)
	[9400] = {}, -- Gorgrond Monster Hunter
	[9541] = {}, -- The Song of Silence
	[9571] = {}, -- Broke Back Precipice
	[9617] = {}, -- Making the Cut
	[9633] = {}, -- Cut off the Head (Shatt)
	[9638] = {}, -- Heralds of the Legion (Shatt)
	[9655] = {}, -- Fight the Power (Gorgrond)
	[9678] = {}, -- Ancient No More (Gorgrond)
	[9216] = {}, -- High-value targets (Ashran)
	[10061] = {}, -- Hellbane (Tanaan)
	[10070] = {}, -- Jungle Stalker (Tanaan)
}
local mobs_to_achievement = {
	-- [43819] = 2257,
}
local achievements_loaded = false

module.mobs_to_achievement = mobs_to_achievement

local globaldb
function module:OnInitialize()
	globaldb = core.db.global

	self.db = core.db:RegisterNamespace("Tooltip", {
		profile = {
			achievement = true,
			id = false,
		},
	})

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.tooltip = {
			tooltip = {
				type = "group",
				name = "Tooltips",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					about = config.desc("SilverDragon can put some information about mobs into their tooltips. For rares, that can include whether you actually need to kill them for an achievement.", 0),
					achievement = config.toggle("Achievements", "Show if you need a rare mob for an achievement"),
					id = config.toggle("Unit IDs", "Show mob ids in tooltips"),
				},
			},
		}
	end
end

function module:AchievementMobStatus(id)
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

function module:OnEnable()
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function module:LoadAllAchievementMobs()
	for achievement in pairs(achievements) do
		self:LoadAchievementMobs(achievement)
	end
end

function module:LoadAchievementMobs(achievement)
	Debug("LoadAchievementMobs", achievement)
	local num_criteria = GetAchievementNumCriteria(achievement)
	for i = 1, num_criteria do
		local description, ctype, completed, _, _, _, _, id = GetAchievementCriteriaInfo(achievement, i)
		if ctype == 0 then
			achievements[achievement][id] = i
			mobs_to_achievement[id] = achievement
			achievements_loaded = true
		end
	end
end

function module:UPDATE_MOUSEOVER_UNIT()
	self:UpdateTooltip(core:UnitID('mouseover'))
end

-- This is split out entirely so I can test this without having to actually hunt down a rare:
-- /script SilverDragon:GetModule('Tooltip'):UpdateTooltip(51059)
function module:UpdateTooltip(id)
	if not id then
		return
	end

	if self.db.profile.id then
		GameTooltip:AddDoubleLine("id", id, 1, 1, 0, 1, 1, 0)
	end

	if self.db.profile.achievement then
		local achievement, name, completed = self:AchievementMobStatus(id)
		if achievement then
			GameTooltip:AddDoubleLine(name, completed and ACTION_PARTY_KILL or NEED,
				1, 1, 0,
				completed and 0 or 1, completed and 1 or 0, 0
			)
		end
		local _, questid = core:GetMobInfo(id)
		if questid then
			completed = IsQuestFlaggedCompleted(questid)
			GameTooltip:AddDoubleLine(
				QUESTS_COLON,
				completed and COMPLETE or INCOMPLETE,
				1, 1, 0,
				completed and 0 or 1, completed and 1 or 0, 0
			)
		end
	end

	GameTooltip:Show()
end
