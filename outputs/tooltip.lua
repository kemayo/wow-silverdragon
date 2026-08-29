local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Tooltip", "AceEvent-3.0")
local Debug = core.Debug

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Tooltip", {
		profile = {
			achievement = true,
			drop = true,
			id = false,
			combatdrop = false,
			regularloot = true,
		},
	})

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.general.plugins.tooltip = {
			tooltip = {
				type = "group",
				name = "Tooltips",
				order = 93,
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					about = config.desc("SilverDragon can put some information about mobs into their tooltips. For rares, that can include whether you actually need to kill them for an achievement.", 0),
					achievement = config.toggle("Achievements", "Show if you need a rare mob for an achievement", 1),
					drop = config.toggle("Drops", "Show if you need a drop from a mob", 2),
					combatdrop = config.toggle("...in combat", "Show the drops while you're in combat", 3),
					regularloot = config.toggle("...including regular loot", "List plain items too, not just the ones we can tell whether you have, like mounts and toys. The map overlay asks this as well", 4),
					id = config.toggle("Unit IDs", "Show mob ids in tooltips", 5),
				},
			},
		}
	end
end

function module:OnEnable()
	if _G.C_TooltipInfo then
		-- Cata-classic has TooltipDataProcessor, but doesn't actually use the new tooltips
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip, tooltipData)
			if tooltip ~= GameTooltip then return end
			module:UpdateTooltip(ns.IdFromGuid(tooltipData and tooltipData.guid))
		end)
	else
		GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
			local name, unit = tooltip:GetUnit()
			if unit then
				module:UpdateTooltip(core:UnitID(unit))
			end
		end)
	end
end

-- Whether to leave out the plain items and list only the things we can tell
-- whether you already have. The map overlay's tooltips ask this too, so the
-- answer lives here rather than being set up again per-map.
function module:OnlyKnowableLoot()
	return not self.db.profile.regularloot
end

-- This is split out entirely so I can test this without having to actually hunt down a rare:
-- /script SilverDragon:GetModule('Tooltip'):UpdateTooltip(51059)
-- /script SilverDragon:GetModule('Tooltip'):UpdateTooltip(32491)
function module:UpdateTooltip(id, force_achievement, force_drop, force_id)
	if not id then
		return
	end

	if force_achievement or (self.db.profile.achievement and force_achievement ~= false) then
		ns:UpdateTooltipWithCompletion(GameTooltip, id)
	end

	if force_drop or ((self.db.profile.drop and (self.db.profile.combatdrop or not InCombatLockdown())) and force_drop ~= false) then
		ns.Loot.Summary.UpdateTooltip(GameTooltip, id, self:OnlyKnowableLoot())
	end

	if ns.mobdb[id] and ns.mobdb[id].notes then
		GameTooltip:AddLine(core:RenderString(ns.mobdb[id].notes), 1, 1, 1, true)
	end

	if core:ShouldIgnoreMob(id) then
		GameTooltip:AddLine("SilverDragon is ignoring this mob", 1, 0.5, 0)
	end

	if force_id or (self.db.profile.id and force_id ~= false) then
		GameTooltip:AddDoubleLine(ID, id, 1, 1, 0, 1, 1, 0)
	end

	GameTooltip:Show()
end
