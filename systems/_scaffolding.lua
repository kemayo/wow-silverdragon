local myname, ns = ...

-- This file exists because these systems are kept in sync from my HandyNotes
-- plugins, and I need a minor translation layer to fit in here.

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

-- The notability keys live in core.db.profile under the same names the plugins
-- use, so they need no translation. Only keys SilverDragon has no equivalent of
-- have to be answered here.
ns.db = setmetatable({}, {__index = function(self, key)
	if key == "show_npcs_emphasizeNotable" then
		-- The plugins have an option for this because it's tied to their map pins;
		-- here it only colours reward labels in tooltips and the loot window, and
		-- now that you can say what counts as notable there's no reason not to
		-- point it out. Deliberately not tied to the announcement filter: the
		-- notability options apply whatever that's set to, so having the tooltips
		-- go quiet because you'd chosen to hear about every rare would be a very
		-- odd thing to have to work out.
		return true
	end
	return core.db.profile[key]
end})

-- Fallback names for the {covenant:} token when C_Covenants has no data
ns.covenants = ns.covenants or {
	[Enum.CovenantType.Kyrian] = "Kyrian",
	[Enum.CovenantType.Necrolord] = "Necrolords",
	[Enum.CovenantType.NightFae] = "NightFae",
	[Enum.CovenantType.Venthyr] = "Venthyr",
}

ns.run_caches = {}
local held = 0
local function wipeRunCaches()
	for _, cache in pairs(ns.run_caches) do
		table.wipe(cache)
	end
end
ns.ClearRunCaches = function()
	-- somebody's asked for one consistent run, so it's not ours to end
	if held > 0 then return end
	wipeRunCaches()
end

-- MobIsNotable clears the caches every time it's called, which is right for one
-- mob and wasteful for a list of them: each mob throws away the item lookups the
-- one before it just paid for, and mobs sharing loot pay again and again. Take a
-- hold around a batch and they all share one set of answers instead.
--
-- Balance every Hold with a Release, including on the paths that give up early.
ns.HoldRunCaches = function()
	if held == 0 then
		wipeRunCaches()
	end
	held = held + 1
end
ns.ReleaseRunCaches = function()
	held = math.max(held - 1, 0)
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

ns.nodeMaker = function(defaults)
    local meta = {__index = defaults}
    return function(details)
        details = details or {}
        if details.note and defaults.note then
            details.note = details.note .. "\n" .. defaults.note
        end
        local meta2 = getmetatable(details)
        if meta2 and meta2.__index then
            return setmetatable(details, {__index = ns.merge(CopyTable(defaults, true), meta2.__index)})
        end
        return setmetatable(details, meta)
    end
end
