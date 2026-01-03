local myname, ns = ...

-- This file exists because these systems are kept in sync from my HandyNotes
-- plugins, and I need a minor translation layer to fit in here.

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

ns.db = setmetatable({}, {__index = function(self, key)
	return core.db.profile[key]
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
