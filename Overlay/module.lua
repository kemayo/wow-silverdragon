local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Overlay", "AceEvent-3.0")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

local escapes = core.escapes

module.const = {
    EDGE_NEVER = 0,
    EDGE_FOCUS = 1,
    EDGE_ALWAYS = 2,
    -- flags, so LOOT_BOTH is just the two places at once
    LOOT_NONE = 0,
    LOOT_TOOLTIP = 1,
    LOOT_WINDOW = 2,
    LOOT_BOTH = 3,
}

function module:OnInitialize()
    self.db = core.db:RegisterNamespace("Overlay", {
        profile = {
            worldmap = {
                enabled = true,
                tooltip_help = true,
                loot = module.const.LOOT_BOTH,
                icon_scale = 1,
                icon_alpha = 1,
                routes = true,
                zone_disabled = {},
            },
            minimap = {
                enabled = true,
                tooltip_help = false,
                loot = module.const.LOOT_TOOLTIP,
                icon_scale = 1,
                icon_alpha = 1,
                routes = true,
                edge = module.const.EDGE_FOCUS
            },
            icon_theme = 'skulls', -- circles / skulls
            icon_color = 'completion', -- completion / distinct
            emphasize = false,
            -- What to display, per kind, from ns.MobState. "notable" leaves off
            -- the ones with nothing left; the "also" toggles add a state back.
            -- Unsure ones show by default, as with announcements.
            showMobs = true,
            filter = 'notable', -- notable / everything
            showUnknown = true,
            showNothing = false,
            showDone = false,
            achievementless = true,
            hidden = {},
            showTreasures = true,
            filterTreasure = 'notable',
            showUnknownTreasure = true,
            showNothingTreasure = false,
            showDoneTreasure = false,
            achievementlessTreasure = true,
            hiddenTreasure = {},
        },
    })

    -- migration
    local db = self.db.profile
    if type(db.enabled) == "boolean" or db.icon_scale or db.icon_scale_minimap or db.icon_alpha or db.icon_alpha_minimap then
        local function ifnotnil(t, key, val)
            if val ~= nil then
                t[key] = val
            end
        end
        local enabled = db.enabled
        ifnotnil(db.worldmap, "enabled", enabled)
        ifnotnil(db.worldmap, "tooltip_help", db.tooltip_help)
        ifnotnil(db.worldmap, "tooltip_completion", db.tooltip_completion)
        ifnotnil(db.worldmap, "icon_scale", db.icon_scale)
        ifnotnil(db.worldmap, "icon_alpha", db.icon_alpha)

        enabled = type(db.minimap) == "boolean" and db.minimap or false
        db.minimap = CopyTable(self.db.defaults.profile.minimap)
        ifnotnil(db.minimap, "enabled", enabled)
        ifnotnil(db.minimap, "tooltip_help", db.tooltip_help)
        ifnotnil(db.minimap, "tooltip_completion", db.tooltip_completion)
        ifnotnil(db.minimap, "icon_scale", db.icon_scale_minimap)
        ifnotnil(db.minimap, "icon_alpha", db.icon_alpha_minimap)
        ifnotnil(db.minimap, "edge", db.minimap_edge)

        db.enabled = nil
        db.minimap_edge = nil
        db.tooltip_help = nil
        db.tooltip_completion = nil
        db.tooltip_regularloot = nil
        db.icon_scale = nil
        db.icon_scale_minimap = nil
        db.icon_alpha = nil
        db.icon_alpha_minimap = nil
    end

    -- "completion" and "popout loot window" became one choice of where loot goes,
    -- and regular-loot moved to the Tooltip module. Either of the old pair being
    -- saved means the profile predates this; whichever isn't saved was still at
    -- the default it had back then.
    local wasDefault = {
        worldmap = {completion = true, window = true},
        minimap = {completion = true, window = false},
    }
    for section, old in pairs(wasDefault) do
        local cfg = db[section]
        if cfg.tooltip_completion ~= nil or cfg.tooltip_lootwindow ~= nil then
            local inTooltip = cfg.tooltip_completion
            if inTooltip == nil then inTooltip = old.completion end
            local inWindow = cfg.tooltip_lootwindow
            if inWindow == nil then inWindow = old.window end
            cfg.loot = (inTooltip and inWindow and module.const.LOOT_BOTH)
                or (inTooltip and module.const.LOOT_TOOLTIP)
                or (inWindow and module.const.LOOT_WINDOW)
                or module.const.LOOT_NONE
            cfg.tooltip_completion = nil
            cfg.tooltip_lootwindow = nil
        end
        cfg.tooltip_regularloot = nil
    end

    -- "Show achieved" / "Show quest-complete" became a notability filter plus
    -- "also show" toggles (see ns.MobState). An explicitly-set legacy key is a
    -- choice to carry over; an absent one was the old default, so it gives way
    -- to the new default -- a quieter map that leaves off finished things.
    do
        local function migrate(oldAchieved, oldQuest, filterKey, nothingKey, doneKey)
            if db[oldAchieved] == nil and db[oldQuest] == nil then
                return
            end
            -- "achieved" on, or untouched, meant finished things stayed on the map
            local achieved = db[oldAchieved]
            if achieved == nil then achieved = true end
            if achieved then
                db[nothingKey] = true
                db[doneKey] = true
            else
                db[filterKey] = 'notable'
            end
            -- "quest-complete" only ever added the quest-done pile back
            if db[oldQuest] then
                db[doneKey] = true
            end
            db[oldAchieved] = nil
            db[oldQuest] = nil
        end
        migrate("achieved", "questcomplete", "filter", "showNothing", "showDone")
        migrate("achievedTreasure", "questcompleteTreasure", "filterTreasure", "showNothingTreasure", "showDoneTreasure")
    end

    self.tooltip = ns.Tooltip.Get("OverlayPin")

    GameTooltip:HookScript("OnShow", function(tooltip) self:CleanupTooltip() end)

    self:RegisterConfig()
end

function module:OnEnable()
    WorldMapFrame:RegisterCallback("WorldMapOnHide", self.OnWorldMapHide, self)
    HBD.RegisterCallback(self, "PlayerZoneChanged", "UpdateMinimapIcons")
    core.RegisterCallback(self, "Ready", "Update")
    -- the notability options and the loot ones live on the core profile, and both
    -- decide what our icons look like
    core.RegisterCallback(self, "OptionsChanged", "Update")
    core.RegisterCallback(self, "BrokerMobClick")
    core.RegisterCallback(self, "BrokerMobEnter")
    core.RegisterCallback(self, "BrokerMobLeave")
    core.RegisterCallback(self, "Seen")

    self:RegisterEvent("LOOT_CLOSED", "Update")
end
function module:OnDisable()
    HBD.UnregisterCallback(self, "PlayerZoneChanged")
    core.UnregisterCallback(self, "Ready")
    core.UnregisterCallback(self, "BrokerMobClick")
    core.UnregisterCallback(self, "BrokerMobEnter")
    core.UnregisterCallback(self, "BrokerMobLeave")
    core.UnregisterCallback(self, "Seen")
end

function module:OnWorldMapHide()
    self:CleanupTooltip()
end

function module:BrokerMobClick(_, mobid)
    self:FocusPoint(mobid)
end
function module:BrokerMobEnter(_, mobid)
    self:HighlightPoint(mobid)
end
function module:BrokerMobLeave(_, mobid)
    self:UnhighlightPoint(mobid)
end

function module:Seen(_, id, zone, x, y, dead, source, unit)
    self.last_mob = id
    self.last_mob_time = time()
    if WorldMapFrame:IsShown() then
        self.WorldMapProvider:Ping(id)
    end
end

-- Only one point is focused at a time, but a vignette id can be the same number
-- as an npc id, so the kind has to be part of every comparison.
function module:IsFocused(id, isTreasure)
    if id == nil or id ~= self.focus_id then return false end
    return (isTreasure or false) == (self.focus_treasure or false)
end

function module:HighlightPoint(id, isTreasure)
    if self:IsFocused(id, isTreasure) then return end
    if not WorldMapFrame:IsShown() then return end
    self.WorldMapProvider:Emphasize(id, isTreasure, true)
    self.WorldMapRouteProvider:Emphasize(id, isTreasure, true)
end

function module:UnhighlightPoint(id, isTreasure)
    if self:IsFocused(id, isTreasure) then return end
    if not WorldMapFrame:IsShown() then return end
    self.WorldMapProvider:Emphasize(id, isTreasure, false)
    self.WorldMapRouteProvider:Emphasize(id, isTreasure, false)
end

function module:FocusPoint(id, isTreasure)
    if self:IsFocused(id, isTreasure) then
        self.focus_id = nil
        self.focus_treasure = nil
        self.focus_ping = nil
    else
        self.focus_id = id
        self.focus_treasure = isTreasure or nil
    end
    if WorldMapFrame:IsShown() then
        self.WorldMapProvider:ApplyFocusState()
    else
        self.focus_ping = true
    end
    self:UpdateMinimapIcons()
end

-- /script SilverDragon:GetModule("Overlay"):Update()
function module:Update()
    -- no clear needed: each pass takes its own hold, which starts one
    self:UpdateMinimapIcons()
    self:UpdateWorldMapIcons()
end

local isKnowable = function(item) return item:Obtained() ~= nil end

-- Whether to leave the plain items out. One answer for every tooltip we draw,
-- and it's the Tooltip module's to give.
local function onlyKnowableLoot()
    local tooltips = core:GetModule("Tooltip", true)
    return (tooltips and tooltips:OnlyKnowableLoot()) or false
end
local function lootGoesIn(config, where)
    return bit.band(config.loot, where) ~= 0
end

-- The world map pin hooks borrow Blizzard's tooltip and have no popout window,
-- so any loot the user wants shown at all has to go inline there.
local function pinLootGoesInTooltip()
    local config = module.db.profile.worldmap
    return lootGoesIn(config, module.const.LOOT_TOOLTIP) or lootGoesIn(config, module.const.LOOT_WINDOW)
end

function module:ShowTooltip(pin)
    local tooltip = self.tooltip
    if tooltip:IsShown() and tooltip.pin == pin then
        return
    end
    self:CleanupTooltip()
    tooltip.pin = pin
    if pin:GetCenter() > UIParent:GetCenter() then -- compare X coordinate
        tooltip:SetOwner(pin, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(pin, "ANCHOR_RIGHT")
    end
    local id = pin.id
    local isTreasure = pin.isTreasure
    local data = id and core:GetData(id, isTreasure)
    if data then
        tooltip:AddLine(core:GetLabel(id, isTreasure))
        if not isTreasure then
            -- nothing tracks when a treasure was last seen
            tooltip:AddDoubleLine("Last seen", core:FormatLastSeen(core.db.global.mob_seen[id]))
        end
        ns:UpdateTooltipWithCompletion(tooltip, id, isTreasure)
        if lootGoesIn(pin:Config(), module.const.LOOT_TOOLTIP) then
            ns.Loot.Summary.UpdateTooltip(tooltip, id, onlyKnowableLoot(), isTreasure)
        end
        if data.notes then
            tooltip:AddLine(core:RenderString(data.notes), 1, 1, 1, true)
        end
        if lootGoesIn(pin:Config(), module.const.LOOT_WINDOW) then
            local filter
            if onlyKnowableLoot() then
                filter = isKnowable
            end
            self.lootwindow = ns.Loot.Window.ShowForMob(id, false, isTreasure, filter)
            if self.lootwindow then
                self.lootwindow:SetParent(tooltip)
                if pin:GetCenter() > UIParent:GetCenter() then
                    self.lootwindow:SetPoint("TOPRIGHT", tooltip, "BOTTOMRIGHT")
                else
                    self.lootwindow:SetPoint("TOPLEFT", tooltip, "BOTTOMLEFT")
                end
                self.lootwindow:SetAutoHideDelay(0.25, {pin, tooltip}, function()
                    self:CleanupTooltip()
                    return false -- cleanup will have released the window, so this signals it doesn't need to happen again
                end)
            end
        end
        if data.requires then
            local metRequirements = ns.conditions.check(data.requires)
            local r, g, b = (metRequirements and GREEN_FONT_COLOR or RED_FONT_COLOR):GetRGB()
            tooltip:AddLine(
                core:RenderString(ns.conditions.summarize(data.requires), data),
                r, g, b, true
            )
        end
        if data.active then
            local isActive = ns.conditions.check(data.active)
            local r, g, b = (isActive and GREEN_FONT_COLOR or RED_FONT_COLOR):GetRGB()
            tooltip:AddLine(
                core:RenderString(ns.conditions.summarize(data.active), data),
                r, g, b, true
            )
        end
    else
        tooltip:AddLine(UNKNOWN)
        tooltip:AddDoubleLine("At", pin.uiMapID .. ':' .. pin.coord)
    end

    if core.debuggable then
        tooltip:AddDoubleLine(ID, id)
        tooltip:AddDoubleLine(LOCATION_COLON, ("%s %s"):format(pin.uiMapID, pin.coord))
    end

    if pin:Config().tooltip_help then
        if core:GetModule("TomTom"):CanPointTo(pin.uiMapID) then
            tooltip:AddDoubleLine(ALT_KEY_TEXT .. " + " .. escapes.leftClick, MAP_PIN, 0, 1, 1, 0, 1, 1 )
        end
        tooltip:AddDoubleLine(SHIFT_KEY_TEXT .. " + " .. escapes.leftClick, TRADESKILL_POST, 0, 1, 1, 0, 1, 1 )
        tooltip:AddDoubleLine(SHIFT_KEY_TEXT .. " + " .. escapes.rightClick, HIDE, 0, 1, 1, 0, 1, 1 )
    end

    tooltip:Show()
end

function module:CleanupTooltip()
    if self.lootwindow then
        ns.Loot.Window.Release(self.lootwindow)
        self.lootwindow = nil
    end
    self.tooltip:Hide()
end

local function AddMobToTooltip(tooltip, mobid, name)
    if not (mobid and ns.mobdb[mobid]) then return end
    if name then
        tooltip:AddLine(core:GetMobLabel(mobid))
    end
    ns:UpdateTooltipWithCompletion(tooltip, mobid)
    if pinLootGoesInTooltip() then
        ns.Loot.Summary.UpdateTooltip(tooltip, mobid, onlyKnowableLoot())
    end
    if ns.mobdb[mobid].notes then
        tooltip:AddLine(core:RenderString(ns.mobdb[mobid].notes), 1, 1, 1, true)
    end
    tooltip:Show()
end

local function AddTreasureToTooltip(tooltip, vignetteID)
    if not (vignetteID and ns.vignetteTreasureLookup[vignetteID]) then return end
    ns:UpdateTooltipWithCompletion(tooltip, vignetteID, true)
    if pinLootGoesInTooltip() then
        ns.Loot.Summary.UpdateTooltip(tooltip, vignetteID, onlyKnowableLoot(), true)
    end
    if ns.vignetteTreasureLookup[vignetteID].notes then
        tooltip:AddLine(core:RenderString(ns.vignetteTreasureLookup[vignetteID].notes), 1, 1, 1, true)
    end
    tooltip:Show()
end

do
    -- This is a "only do this update once a tick" gate
    local already
    local gateFrame = CreateFrame("Frame")
    gateFrame:SetScript("OnShow", function() already = true end)
    gateFrame:SetScript("OnHide", function() already = false end)
    gateFrame:SetScript("OnUpdate", function(self) self:Hide() end)

    local function getSubordinateTooltip()
        local subordinate = _G[myname.."SubordinateTooltip"]
        if not subordinate then
            subordinate = CreateFrame("GameTooltip", myname.."SubordinateTooltip", UIParent, "GameTooltipTemplate")
            if _G.GameTooltipDataMixin then Mixin(subordinate, _G.GameTooltipDataMixin) end
            subordinate:SetFrameStrata("TOOLTIP")
            subordinate:SetClampedToScreen(true)
        end
        return subordinate
    end

    local handleWorldMapPin = function(pin)
        if not pin then return end
        if already then return end
        gateFrame:Show()

        -- Appending to a tooltip Blizzard has already inserted widgets into
        -- taints the widget's cached data, which later blocks arithmetic on
        -- its now-secret layout fields. Hang our lines off a separate tooltip
        -- below instead, like the item-comparison one does off the side.
        -- (2026-08, 12.1; mirrors HandyNotes handler commit e12d76a.)
        local tooltip = GameTooltip
        if GameTooltip.insertedFrames and #GameTooltip.insertedFrames > 0 then
            tooltip = getSubordinateTooltip()
            tooltip:SetOwner(GameTooltip, "ANCHOR_NONE")
            tooltip:ClearAllPoints()
            tooltip:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -10)
        elseif _G[myname.."SubordinateTooltip"] then
            _G[myname.."SubordinateTooltip"]:Hide()
        end

        local point
        if pin.vignetteID then
            if ns.vignetteTreasureLookup[pin.vignetteID] then
                AddTreasureToTooltip(tooltip, pin.vignetteID)
            elseif ns.vignetteMobLookup[pin.vignetteID] then
                for mobid in pairs(ns.vignetteMobLookup[pin.vignetteID]) do
                    AddMobToTooltip(tooltip, mobid)
                end
            elseif pin.vignetteInfo and pin.vignetteInfo.name then
                AddMobToTooltip(tooltip, core:IdForMob(pin.vignetteInfo.name))
            end
        elseif pin.worldQuest and pin.questID then
            if not ns.worldQuestMobLookup[pin.questID] then return end
            for mobid in pairs(ns.worldQuestMobLookup[pin.questID]) do
                AddMobToTooltip(tooltip, mobid, true)
            end
        elseif pin.poiInfo and pin.poiInfo.areaPoiID then
            -- point = ns.POIsToPoints[pin.poiInfo.areaPoiID]
        end
    end
    local hideComparison = function()
        -- 10.0.2 doesn't hide this by default any more
        if _G[myname.."ComparisonTooltip"] then _G[myname.."ComparisonTooltip"]:Hide() end
        if _G[myname.."SubordinateTooltip"] then _G[myname.."SubordinateTooltip"]:Hide() end
        gateFrame:Hide()
    end

    hooksecurefunc(AreaPOIPinMixin, "TryShowTooltip", handleWorldMapPin)
    hooksecurefunc(AreaPOIPinMixin, "OnMouseLeave", hideComparison)
    hooksecurefunc(VignettePinBaseMixin or VignettePinMixin, "OnMouseEnter", handleWorldMapPin)
    hooksecurefunc(VignettePinBaseMixin or VignettePinMixin, "OnMouseLeave", hideComparison)
    if _G.TaskPOI_OnEnter then
        hooksecurefunc("TaskPOI_OnEnter", handleWorldMapPin)
        hooksecurefunc("TaskPOI_OnLeave", function(self) hideComparison() end)
    end
    EventRegistry:RegisterCallback("MapLegendPinOnEnter", function(self, pin)
        -- This wants to catch pins like the vignettes on the Dragon Isles,
        -- which appear for events but which aren't a VignettePinMixin.
        -- Regular VignettePinMixin will also trigger this, depending on
        -- client branch, but the gate frame will avoid issues.
        handleWorldMapPin(pin)
    end)
    EventRegistry:RegisterCallback("MapLegendPinOnLeave", hideComparison)
end
