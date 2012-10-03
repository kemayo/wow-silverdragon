local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Tooltip", "AceEvent-3.0")
local Debug = core.Debug

local achievements = {
	[1312] = true, -- Bloody Rare (BC mobs)
	[2257] = true, -- Frostbitten (Wrath mobs)
	[7439] = true, -- Glorious! (Pandaria mobs)
}
local achievement_mobs = {
	-- [43819] = false,
}
local mobs_to_achievement = {
	-- [43819] = 2257,
}

module.achievement_mobs = achievement_mobs
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

function module:OnEnable()
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterEvent("CRITERIA_EARNED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function module:PLAYER_ENTERING_WORLD()
	self:LoadAllAchievementMobs()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function module:CRITERIA_EARNED(_, achievement, criteria)
	self:LoadAllAchievementMobs()
end

function module:LoadAllAchievementMobs()
	for achievement in pairs(achievements) do
		self:LoadAchievementMobs(achievement)
	end
end

function module:LoadAchievementMobs(achievement)
	local num_criteria = GetAchievementNumCriteria(achievement)
	for i = 1, num_criteria do
		local description, ctype, completed, _, _, _, _, id = GetAchievementCriteriaInfo(achievement, i)
		if ctype == 0 then
			achievement_mobs[id] = completed
			mobs_to_achievement[id] = achievement
			-- and grab the names/ids, for the heck of it
			globaldb.mob_id[description] = id
			globaldb.mob_name[id] = description
		end
	end
end

function module:UPDATE_MOUSEOVER_UNIT()
	local id = core:UnitID('mouseover')
	if id then
		if self.db.profile.id then
			GameTooltip:AddDoubleLine("id", id, 1, 1, 0, 1, 1, 0)
		end
		local got = achievement_mobs[id]
		if self.db.profile.achievement and got ~= nil then
			local _, name = GetAchievementInfo(mobs_to_achievement[id])
			GameTooltip:AddDoubleLine(name, got and ACTION_PARTY_KILL or NEED,
				1, 1, 0,
				got and 0 or 1, got and 1 or 0, 0
			)
		end
		GameTooltip:Show()
	end
end
