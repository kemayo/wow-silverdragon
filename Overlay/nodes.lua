local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

-- Build the nodes, and their icons
-- The following is largely unmodified from the handynotes integration

do
    -- Six states, and every theme wants all six:
    --   mount        there's a mount on it you'd want
    --   achievement  you haven't finished its achievement
    --   something    something else on it you'd want
    --   nothing      you can still kill it, but there's nothing on it for you
    --   done         it has nothing left to give at all
    --   unknown      no quest, no achievement, no loot -- nothing to go on
    -- The themes themselves are in core, next to ns.MobState which decides
    -- between them, because the mob browser draws the same six.
    local icons = ns.MobStateIcons
    local function should_show_mob(id, uiMapID)
        if module.db.profile.hidden[id] or core:ShouldIgnoreMob(id, uiMapID) then
            return false
        end
        if not core:IsMobInPhase(id, uiMapID) then
            return false
        end
        if ns.mobdb[id] and ns.mobdb[id].requires and not ns.conditions.check(ns.mobdb[id].requires) then
            return false
        end
        local quest, achievement, achievement_completed_by_alt = ns:CompletionStatus(id)
        if achievement_completed_by_alt and core.db.profile.alts_achievements_count then
            -- you've said an alt's credit counts, so treat it as earned here too
            achievement = true
        end
        if not module.db.profile.achieved and ns.MobIsNotable(id) == false then
            -- Having nothing left on it you want is as good as having its
            -- achievement: without this a mob whose loot you've collected stays
            -- at full strength on the map forever. Only asked when the toggle is
            -- off, since MobIsNotable drops the reward caches to answer.
            return false
        end
        if achievement ~= nil then
            if quest ~= nil then
                -- we have a quest *and* an achievement; we're going to treat "show achieved" as "show achieved if I can still loot them"
                return (module.db.profile.questcomplete or not quest) and (module.db.profile.achieved or not achievement)
            end
            -- no quest, but achievement
            return module.db.profile.achieved or not achievement
        end
        if module.db.profile.achievementless then
            -- no achievement, but quest
            return module.db.profile.questcomplete or not quest
        end
        return false
    end
    module.should_show_mob = should_show_mob
    local function icon_for_mob(id)
        local set = icons[module.db.profile.icon_theme]
        -- ns.MobState works the states out; the broker's tooltip colours its rows
        -- from the same six, so they stay in step. A mob that isn't in the data at
        -- all comes back "unknown" from there, so it needs no case of its own.
        return set[ns.MobState(id)] or set.unknown
    end
    local icon_cache = {}
    local function distinct_icon_for_mob(id)
        local icon = icon_for_mob(id)
        if not icon_cache[id] then
            icon_cache[id] = {}
        end
        for k,v in pairs(icon) do
            icon_cache[id][k] = v
        end
        local r, g, b = module.id_to_color(id)
        icon_cache[id].r = r
        icon_cache[id].g = g
        icon_cache[id].b = b
        return icon_cache[id]
    end
    local function mobsForZone(uiMapID)
        if not ns.mobsByZone[uiMapID] then return end
        for id, coords in pairs(ns.mobsByZone[uiMapID]) do
            if should_show_mob(id, uiMapID) then
                local icon
                if module.db.profile.icon_color == 'distinct' then
                    icon = distinct_icon_for_mob(id)
                else
                    icon = icon_for_mob(id)
                end
                local alpha = icon.alpha
                if ns.mobdb[id] and ns.mobdb[id].active and not ns.conditions.check(ns.mobdb[id].active) then
                    alpha = alpha and (alpha * 0.6) or 0.6
                end
                for _, coord in ipairs(coords) do
                    coroutine.yield(coord, id, icon, icon.scale, alpha)
                end
            end
        end
    end
    function module:IterateNodes(uiMapID, minimap)
        Debug("Overlay IterateNodes", uiMapID, minimap)
        return coroutine.wrap(function()
            return mobsForZone(uiMapID)
        end)
    end
end
