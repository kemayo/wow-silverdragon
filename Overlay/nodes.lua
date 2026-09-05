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
    --   nothing      you can still get to it, but there's nothing on it for you
    --   done         it has nothing left to give at all
    --   unknown      no quest, no achievement, no loot -- nothing to go on
    -- ns.MobState decides between them, for treasures as well as mobs; the themes
    -- and the mob browser draw the same six.
    local icons = ns.MobStateIcons
    -- Each key has a treasure twin, so the two kinds filter separately. Spelled
    -- out rather than built from a suffix per call, which this is far too hot for.
    local display = {
        mob = {
            show = "showMobs",
            hidden = "hidden",
            filter = "filter",
            alsoUnknown = "showUnknown",
            alsoNothing = "showNothing",
            alsoDone = "showDone",
            achievementless = "achievementless",
        },
        treasure = {
            show = "showTreasures",
            hidden = "hiddenTreasure",
            filter = "filterTreasure",
            alsoUnknown = "showUnknownTreasure",
            alsoNothing = "showNothingTreasure",
            alsoDone = "showDoneTreasure",
            achievementless = "achievementlessTreasure",
        },
    }
    -- The states each filter level shows by itself; the "also show" toggles add
    -- the others back. "Notable" asks what the announcement filter asks.
    local filterStates = {
        everything = {mount = true, achievement = true, something = true, unknown = true, nothing = true, done = true},
        notable = {mount = true, achievement = true, something = true},
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
        -- "Not tied to any achievement" is a separate question from how far
        -- along you are, so it gates before the state filter rather than through it.
        if not profile[option.achievementless] then
            local _, achievement = ns:CompletionStatus(id, isTreasure)
            if achievement == nil then
                return false
            end
        end
        local state = ns.MobState(id, isTreasure)
        local allowed = filterStates[profile[option.filter]] or filterStates.notable
        if allowed[state]
            or (state == "unknown" and profile[option.alsoUnknown])
            or (state == "nothing" and profile[option.alsoNothing])
            or (state == "done" and profile[option.alsoDone])
        then
            return true, state
        end
        return false
    end
    module.should_show_point = should_show_point
    local function icon_for_mob(id, state)
        local set = icons[module.db.profile.icon_theme]
        -- ns.MobState works the states out; the broker's tooltip colours its rows
        -- from the same six, so they stay in step. Anything not in the data at all
        -- comes back "unknown" from there, so it needs no case of its own.
        return set[state or ns.MobState(id)] or set.unknown
    end
    -- A treasure keeps its own icon shape: the chest, or art from the import's
    -- `texture` spec or `atlas`. Only the plain fallback takes a completion tint
    -- (below) -- deliberate art keeps the colour it was drawn with.
    local defaultTreasureIcon = {atlas = "VignetteLoot", r = 1, g = 1, b = 1, a = 0.9, scale = 1}
    local treasure_icons = {}
    local function icon_for_treasure(data)
        -- A ready-made texture spec from the plugin data: already the shape the
        -- pin wants, and shared between points, so hand it straight back.
        if data and type(data.texture) == "table" then
            return data.texture, true
        end
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
    -- As distinct_icon, but coloured by how far along you are. MobStateColor has
    -- no "unknown" -- that state makes no claim, so its icon keeps its colour.
    local function completion_icon(pointType, id, icon, state)
        local color = ns.MobStateColor[state]
        if not color then
            return icon
        end
        local cache = icon_cache[pointType]
        if not cache[id] then
            cache[id] = {}
        end
        for k, v in pairs(icon) do
            cache[id][k] = v
        end
        cache[id].r, cache[id].g, cache[id].b = color[1], color[2], color[3]
        return cache[id]
    end
    local function pointsForZone(uiMapID, byZone, pointType)
        if not byZone[uiMapID] then return end
        local isTreasure = pointType == "treasure"
        for id, coords in pairs(byZone[uiMapID]) do
            local show, state = should_show_point(id, uiMapID, isTreasure)
            if show then
                local data = core:GetData(id, isTreasure)
                local icon, custom
                if isTreasure then
                    icon, custom = icon_for_treasure(data)
                else
                    icon = icon_for_mob(id, state)
                end
                -- art the data picked is deliberate, so leave its colour be;
                -- otherwise colour by the option. Mobs leave icon_for_mob already
                -- state-coloured, so only treasures reach completion_icon.
                if not custom then
                    if module.db.profile.icon_color == 'distinct' then
                        icon = distinct_icon(pointType, id, icon)
                    elseif isTreasure then
                        icon = completion_icon(pointType, id, icon, state)
                    end
                end
                -- dimmed while it isn't up; nil leaves the pin at its own default
                local alpha
                if data and data.active and not ns.conditions.check(data.active) then
                    alpha = 0.6
                end
                -- make the ones with something left on them stand out, whatever
                -- else shares the map
                local scale = icon.scale
                if module.db.profile.emphasize and filterStates.notable[state] then
                    scale = (scale or 1) * 1.3
                end
                for coord in pairs(coords) do
                    if core:CoordGateMet(data, uiMapID, coord) then
                        coroutine.yield(coord, pointType, id, icon, scale, alpha)
                    end
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
