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
    -- Each display toggle has a treasure twin, so the two kinds can be filtered
    -- separately. Spelled out rather than built from a suffix per call, which
    -- this is far too hot for.
    local display = {
        mob = {
            show = "showMobs",
            hidden = "hidden",
            achieved = "achieved",
            questcomplete = "questcomplete",
            achievementless = "achievementless",
        },
        treasure = {
            show = "showTreasures",
            hidden = "hiddenTreasure",
            achieved = "achievedTreasure",
            questcomplete = "questcompleteTreasure",
            achievementless = "achievementlessTreasure",
        },
    }
    local function should_show_point(id, uiMapID, isTreasure)
        local profile = module.db.profile
        local option = display[isTreasure and "treasure" or "mob"]
        if not profile[option.show] then
            return false
        end
        if profile[option.hidden][id] then
            return false
        end
        if isTreasure then
            -- the only ignore list treasures have; the scanner owns it
            local vignettes = core:GetModule("Scan_Vignettes", true)
            if vignettes and vignettes:ShouldIgnoreVignette(id) then
                return false
            end
        elseif core:ShouldIgnoreMob(id, uiMapID) then
            return false
        end
        if not core:IsMobInPhase(id, uiMapID, isTreasure) then
            return false
        end
        local data = core:GetData(id, isTreasure)
        if data and data.requires and not ns.conditions.check(data.requires) then
            return false
        end
        local quest, achievement, achievement_completed_by_alt = ns:CompletionStatus(id, isTreasure)
        if achievement_completed_by_alt and core.db.profile.alts_achievements_count then
            -- you've said an alt's credit counts, so treat it as earned here too
            achievement = true
        end
        if not profile[option.achieved] and ns.MobIsNotable(id, isTreasure) == false then
            -- Having nothing left on it you want is as good as having its
            -- achievement: without this a mob whose loot you've collected stays
            -- at full strength on the map forever. Only asked when the toggle is
            -- off, since MobIsNotable drops the reward caches to answer.
            return false
        end
        if achievement ~= nil then
            if quest ~= nil then
                -- we have a quest *and* an achievement; we're going to treat "show achieved" as "show achieved if I can still loot them"
                return (profile[option.questcomplete] or not quest) and (profile[option.achieved] or not achievement)
            end
            -- no quest, but achievement
            return profile[option.achieved] or not achievement
        end
        if profile[option.achievementless] then
            -- no achievement, but quest
            return profile[option.questcomplete] or not quest
        end
        return false
    end
    module.should_show_point = should_show_point
    local function icon_for_mob(id)
        local set = icons[module.db.profile.icon_theme]
        -- ns.MobState works the states out; the broker's tooltip colours its rows
        -- from the same six, so they stay in step. A mob that isn't in the data at
        -- all comes back "unknown" from there, so it needs no case of its own.
        return set[ns.MobState(id)] or set.unknown
    end
    -- Treasures skip MobState entirely. Its six states rank what a rare still has
    -- left to give, which needs a target you can go back to; a treasure is looted
    -- once and gone, so one that's still drawing always has the same answer. The
    -- import can name its own atlas instead, which plenty of them do.
    local defaultTreasureIcon = {atlas = "VignetteLoot", r = 1, g = 1, b = 1, a = 0.9, scale = 1}
    local treasure_icons = {}
    local function icon_for_treasure(data)
        if not (data and data.atlas) then
            return defaultTreasureIcon
        end
        -- keyed by look rather than by id, so the many treasures sharing an atlas
        -- share one table
        local scale = data.scale or 1
        if not treasure_icons[data.atlas] then
            treasure_icons[data.atlas] = {}
        end
        if not treasure_icons[data.atlas][scale] then
            treasure_icons[data.atlas][scale] = {
                atlas = data.atlas,
                r = 1, g = 1, b = 1, a = 0.9,
                scale = scale,
            }
        end
        return treasure_icons[data.atlas][scale], true
    end
    -- Keyed by kind as well as id: the two number spaces overlap, and the world
    -- map holds onto these tables until its next refresh, so a shared one would
    -- let a treasure recolour a mob's icon out from under an already-queued node.
    local icon_cache = {mob = {}, treasure = {}}
    local function distinct_icon(pointType, id, icon)
        local cache = icon_cache[pointType]
        if not cache[id] then
            cache[id] = {}
        end
        for k,v in pairs(icon) do
            cache[id][k] = v
        end
        local r, g, b = module.id_to_color(id)
        cache[id].r = r
        cache[id].g = g
        cache[id].b = b
        return cache[id]
    end
    local function pointsForZone(uiMapID, byZone, pointType)
        if not byZone[uiMapID] then return end
        local isTreasure = pointType == "treasure"
        for id, coords in pairs(byZone[uiMapID]) do
            if should_show_point(id, uiMapID, isTreasure) then
                local data = core:GetData(id, isTreasure)
                local icon, custom
                if isTreasure then
                    icon, custom = icon_for_treasure(data)
                else
                    icon = icon_for_mob(id)
                end
                -- an atlas the data picked is deliberate art, so leave it alone
                if not custom and module.db.profile.icon_color == 'distinct' then
                    icon = distinct_icon(pointType, id, icon)
                end
                -- dimmed while it isn't up; nil leaves the pin at its own default
                local alpha
                if data and data.active and not ns.conditions.check(data.active) then
                    alpha = 0.6
                end
                for coord in pairs(coords) do
                    coroutine.yield(coord, pointType, id, icon, icon.scale, alpha)
                end
            end
        end
    end
    -- Work the whole zone out under one hold, then hand the points over. MobState
    -- drops the reward caches on each call, so one at a time makes every one of
    -- them redo the item lookups the last had just paid for.
    local function nodesForZone(uiMapID)
        ns.HoldRunCaches()
        pointsForZone(uiMapID, ns.mobsByZone, "mob")
        pointsForZone(uiMapID, ns.treasureByZone, "treasure")
        ns.ReleaseRunCaches()
    end
    -- Iterates over all nodes in a zone, giving `coord, pointType, id, icon, scale, alpha`
    -- Callers MUST NOT break out of iterating this early, or must manually call
    -- ReleaseRunCaches themselves if they do.
    function module:IterateNodes(uiMapID, minimap)
        Debug("Overlay IterateNodes", uiMapID, minimap)
        return coroutine.wrap(function() nodesForZone(uiMapID) end)
    end
end
