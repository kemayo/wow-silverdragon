local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Tooltip", "AceEvent-3.0")
local Debug = core.Debug

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
				order = 93,
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
		local achievement, name, completed = ns:AchievementMobStatus(id)
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
