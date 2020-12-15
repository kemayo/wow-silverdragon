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
    local icons = {
        circles = {
            default = tex("PlayerPartyBlip", 1, 0.33, 0.33, 1.3),
            partial = tex("PlayerPartyBlip", 1, 1, 0.33, 1.3),
            done = tex("PlayerDeadBlip", 0.33, 1, 0.33, 1),
            loot = tex("Warfront-NeutralHero-Silver", 1, 0.33, 0.33, 1.3),
            loot_partial = tex("Warfront-NeutralHero-Silver", 1, 1, 0.33, 1.3),
            loot_done = tex("Warfront-NeutralHero-Silver", 0.33, 1, 0.33, 1),
            mount = tex("PlayerRaidBlip", 1, 0.33, 0.33, 1.3),
            mount_partial = tex("PlayerRaidBlip", 1, 1, 0.33, 1.3),
            mount_done = tex("PlayerDeadBlip", 0.33, 1, 0.33, 1),
        },
        skulls = {
            default = tex("Islands-AzeriteBoss", 1, 0.33, 0.33, 1.8), -- red skull
            partial = tex("Islands-AzeriteBoss", 1, 1, 0.33, 1.8), -- yellow skull
            done = tex("Islands-AzeriteBoss", 0.33, 1, 0.33, 1.5), -- green skull
            loot = tex("nazjatar-nagaevent", 1, 0.33, 0.33, 1.8), -- red glowing skull
            loot_partial = tex("nazjatar-nagaevent", 1, 1, 0.33, 1.8), -- yellow glowing skull
            loot_done = tex("nazjatar-nagaevent", 0.33, 1, 0.33, 1.5), -- green glowing skull
            mount = tex("VignetteKillElite", 1, 0.33, 0.33, 1.3), -- red shiny skull
            mount_partial = tex("VignetteKillElite", 1, 1, 0.33, 1.3), -- yellow shiny skull
            mount_done = tex("VignetteKillElite", 0.33, 1, 0.33, 1), -- green shiny skull
        },
        stars = {
            default = tex("VignetteKill", 1, 0.33, 1, 1.3), -- red star
            partial = tex("VignetteKill", 1, 1, 1, 1.3), -- gold star
            done = tex("VignetteKill", 0, 1, 1), -- green star
            loot = tex("VignetteLootElite", 1, 0.33, 1, 1.3), -- red shiny skull
            loot_partial = tex("VignetteLootElite", 0, 1, 1, 1.3), -- yellow shiny skull
            loot_done = tex("VignetteLootElite", 0, 1, 0, 1), -- green shiny skull
            mount = tex("VignetteKillElite", 1, 0.33, 1, 1.3), -- red shiny skull
            mount_partial = tex("VignetteKillElite", 0, 1, 1, 1.3), -- yellow shiny skull
            mount_done = tex("VignetteKillElite", 0, 1, 0, 1), -- green shiny skull
        }
    }
    local function should_show_mob(id)
        if module.db.profile.hidden[id] or core:ShouldIgnoreMob(id) then
            return false
        end
        local quest, achievement, achievement_completed_by_alt = ns:CompletionStatus(id)
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
        local quest, achievement = ns:CompletionStatus(id)
        local prefix
        if ns.Loot.HasMounts(id) then
            -- a mount is always a mount
            prefix = 'mount'
        elseif ns.Loot.Status.Toy(id) == false or ns.Loot.Status.Pet(id) == false then
            -- but toys and pets are only special until you loot them
            prefix = 'loot'
        end
        local suffix
        if quest or achievement then
            if (quest and achievement) or (quest == nil or achievement == nil) then
                suffix = 'done'
            else
                suffix = 'partial'
            end
        end
        if prefix and suffix then
            return prefix .. '_' .. suffix
        end
        return prefix or suffix
    end
    local function icon_for_mob(id)
        local set = icons[module.db.profile.icon_theme]
        if not ns.mobdb[id] then
            return set.default
        end
        return set[key_for_mob(id)] or set.default
    end
    local function scale(value, currmin, currmax, min, max)
        -- take a value between currmin and currmax and scale it to be between min and max
        return ((value - currmin) / (currmax - currmin)) * (max - min) + min
    end
    local function hasher(value)
        return scale(select(2, math.modf(math.abs(math.tan(value)) * 10000, 1)), 0, 1, 0.3, 1)
    end
    local function id_to_color(id)
        return hasher(id + 1), hasher(id + 2), hasher(id + 3)
    end
    module.id_to_color = id_to_color
    local icon_cache = {}
    local function distinct_icon_for_mob(id)
        local icon = icon_for_mob(id)
        if not icon_cache[id] then
            icon_cache[id] = {}
        end
        for k,v in pairs(icon) do
            icon_cache[id][k] = v
        end
        local r, g, b = id_to_color(id)
        icon_cache[id].r = r
        icon_cache[id].g = g
        icon_cache[id].b = b
        return icon_cache[id]
    end
    local function iter(t, prestate)
        if not t then return nil end
        local state, value = next(t, prestate)
        while state do
            -- Debug("Overlay node", state, value, should_show_mob(value))
            if value and should_show_mob(value) then
                local icon
                if module.db.profile.icon_color == 'distinct' then
                    icon = distinct_icon_for_mob(value)
                else
                    icon = icon_for_mob(value)
                end
                return state, value, icon, icon.scale, icon.alpha
            end
            state, value = next(t, state)
        end
        return nil, nil, nil, nil, nil
    end
    function module:IterateNodes(uiMapID, minimap)
        Debug("Overlay IterateNodes", uiMapID, minimap)
        return iter, self.nodes[uiMapID], nil
    end
end
