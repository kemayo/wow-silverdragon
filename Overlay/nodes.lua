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
    local function tex(atlas, r, g, b, scale)
        return {
            atlas = atlas,
            r = r, g = g, b = b, a = 0.9,
            scale = scale or 1,
        }
    end
    -- DungeonSkull = skull
    -- VignetteKillElite = Skull with star around it
    -- Islands-AzeriteBoss = more detailed skull
    -- nazjatar-nagaevent = more detailed skull, glowing
    -- WhiteCircle-RaidBlips / PlayerPartyBlip = white circle
    -- WhiteDotCircle-RaidBlips / PlayerRaidBlip = white circle with dot
    -- PlayerDeadBlip = black circle with white X
    -- QuestSkull = gold glowy circle
    -- Warfront-NeutralHero-Silver = silver dragon on gold circle
    -- Five states, and every theme wants all five:
    --   mount        there's a mount on it you'd want
    --   achievement  you haven't finished its achievement
    --   default      something else on it you'd want -- and what an unknown mob gets
    --   nothing      you can still kill it, but there's nothing on it for you
    --   done         it has nothing left to give at all
    -- Grey for "nothing" so it recedes: the others are all saying something, and
    -- this one is saying don't bother.
    local icons = {
        circles = {
            achievement = tex("PlayerPartyBlip", 1, 0.33, 0.33, 1.3), -- red
            default = tex("Warfront-NeutralHero-Silver", 0.5, 1, 1, 1.3), -- cyan dragon
            nothing = tex("PlayerPartyBlip", 0.7, 0.7, 0.7, 1.3), -- grey
            done = tex("PlayerDeadBlip", 0.33, 1, 0.33, 1), -- green
            mount = tex("PlayerRaidBlip", 1, 0.33, 0.33, 1.3), -- red, dotted
        },
        skulls = {
            achievement = tex("Islands-AzeriteBoss", 1, 0.33, 0.33, 1.8), -- red skull
            default = tex("nazjatar-nagaevent", 0.5, 1, 1, 1.8), -- cyan glowing skull
            nothing = tex("Islands-AzeriteBoss", 0.7, 0.7, 0.7, 1.5), -- grey skull
            done = tex("Islands-AzeriteBoss", 0.33, 1, 0.33, 1.5), -- green skull
            mount = tex("VignetteKillElite", 1, 0.33, 0.33, 1.8), -- red shiny skull
        },
        stars = {
            achievement = tex("VignetteKill", 1, 0.33, 1, 1.6), -- magenta star
            default = tex("VignetteLootElite", 0.5, 1, 1, 1.6), -- cyan shiny star
            nothing = tex("VignetteKill", 0.7, 0.7, 0.7, 1.3), -- grey star
            -- was 0,1,1 and labelled green, but that's a cyan too close to the
            -- "something you want" one to tell apart at icon size
            done = tex("VignetteKill", 0.33, 1, 0.33, 1.3), -- green star
            mount = tex("VignetteKillElite", 1, 0.33, 1, 1.8), -- magenta shiny star
        }
    }
    if ns.CLASSIC then
        icons.skulls = {
            achievement = tex("DungeonSkull", 1, 0.33, 0.33, 1.3), -- red skull
            default = tex("VignetteKillElite", 0.5, 1, 1, 1.3), -- cyan glowing skull
            nothing = tex("DungeonSkull", 0.7, 0.7, 0.7, 1.3), -- grey skull
            done = tex("DungeonSkull", 0.33, 1, 0.33, 1), -- green skull
            mount = tex("VignetteKillElite", 1, 0.33, 0.33, 1.8), -- red shiny skull
        }
    end
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
    local function key_for_mob(id)
        local quest, achievement, by_alt = ns:CompletionStatus(id)
        -- The quest goes first for the same reason MobIsNotable gates on it: with
        -- it done the mob can't hand over anything, so whatever it carries is
        -- academic. This is the one thing that means "finished", rather than
        -- "nothing you happen to want".
        if quest then
            return 'done'
        end
        if by_alt and core.db.profile.alts_achievements_count then
            achievement = true
        end
        -- A mount outranks the rest, being the thing people are usually out here
        -- for, and an unfinished achievement outranks ordinary loot -- it's the
        -- thing you can't come back for once the zone empties out.
        if ns.HasNotableMounts(id) then
            return 'mount'
        end
        if achievement == false and ns.db.achievement_notable then
            return 'achievement'
        end
        -- nil from MobIsNotable -- nothing we can judge -- shares the icon with
        -- "something for you", so an unknown mob reads as worth a look rather
        -- than worth skipping.
        if ns.MobIsNotable(id) == false then
            return 'nothing'
        end
        return 'default'
    end
    local function icon_for_mob(id)
        local set = icons[module.db.profile.icon_theme]
        if not ns.mobdb[id] then
            return set.default
        end
        return set[key_for_mob(id)] or set.default
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
