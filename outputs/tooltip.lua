local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Tooltip", "AceEvent-3.0")
local Debug = core.Debug

local globaldb
function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Tooltip", {
		profile = {
			achievement = true,
			drop = true,
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
					drop = config.toggle("Drops", "Show if you need a drop from a mob"),
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
-- /script SilverDragon:GetModule('Tooltip'):UpdateTooltip(32491)
function module:UpdateTooltip(id, force_achievement, force_drop, force_id)
	if not id then
		return
	end

	if self.db.profile.achievement or force_achievement == true and not force_achievement == false then
		ns:UpdateTooltipWithCompletion(GameTooltip, id)
	end

	if self.db.profile.drop or force_drop == true and not force_drop == false then
		ns.Loot.Summary.UpdateTooltip(GameTooltip, id)
	end

	if self.db.profile.id or force_id and not force_id == false then
		GameTooltip:AddDoubleLine(ID, id, 1, 1, 0, 1, 1, 0)
	end

	GameTooltip:Show()
end
