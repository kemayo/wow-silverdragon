local myname, ns = ...

-- This file exists because these systems are kept in sync from my HandyNotes
-- plugins, and I need a minor translation layer to fit in here.

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

-- Keys the rewards system expects from my HandyNotes plugins, but which
-- SilverDragon has no config for. Absent is *not* the same as false here:
-- Reward:Obtained() returns nil rather than false for a quest-gated reward you
-- haven't earned yet, and nil reads downstream as "unknowable", which hides it
-- from the only-knowable tooltips and loot windows entirely.
local fallbacks = {
	-- SilverDragon treats quest completion as knowledge about loot everywhere
	-- else (Loot.Status.Quest, CompletionStatus), so it should do so here too
	quest_notable = true,
	-- these only reach Reward:Notable(), which only reaches the tooltip label
	-- colour, which is gated on show_npcs_emphasizeNotable below -- so they do
	-- nothing at all today, and are here so they won't surprise anyone if that
	-- ever gets turned on
	toy_notable = true,
	mount_notable = true,
	pet_notable = true,
	decor_notable = true,
	-- ...and emphasising notable rewards isn't something we do
	show_npcs_emphasizeNotable = false,
}

ns.db = setmetatable({}, {__index = function(self, key)
    if key == "transmog_notable" then
        local announce = core:GetModule("Announce", true)
        return announce and announce.db.profile.already_transmog
    end
	local value = core.db.profile[key]
	if value == nil then
		return fallbacks[key]
	end
	return value
end})

ns.render_string = function(...) return core:RenderString(...) end

ns.run_caches = {}
ns.ClearRunCaches = function()
	for _, cache in pairs(ns.run_caches) do
		table.wipe(cache)
	end
end

local playerClassLocal, playerClass = UnitClass("player")
ns.playerClass = playerClass
ns.playerClassLocal = playerClassLocal
ns.playerClassColor = RAID_CLASS_COLORS[playerClass]
ns.playerName = UnitName("player")
ns.playerFaction = UnitFactionGroup("player")
ns.playerClassMask = ({
    -- this is 2^(classID - 1)
    WARRIOR = 0x1,
    PALADIN = 0x2,
    HUNTER = 0x4,
    ROGUE = 0x8,
    PRIEST = 0x10,
    DEATHKNIGHT = 0x20,
    SHAMAN = 0x40,
    MAGE = 0x80,
    WARLOCK = 0x100,
    MONK = 0x200,
    DRUID = 0x400,
    DEMONHUNTER = 0x800,
    EVOKER = 0x1000,
})[playerClass] or 0

function ns.GetCriteria(achievement, criteriaid)
    local retOK, criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID, eligible = pcall(criteriaid < 100 and GetAchievementCriteriaInfo or GetAchievementCriteriaInfoByID, achievement, criteriaid, true)
    if not retOK then return end
    return criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID, eligible
end
