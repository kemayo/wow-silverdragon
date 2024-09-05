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
}

function module:OnInitialize()
    self.db = core.db:RegisterNamespace("Overlay", {
        profile = {
            worldmap = {
                enabled = true,
                tooltip_help = true,
                tooltip_completion = true,
                tooltip_regularloot = true,
                tooltip_lootwindow = true,
                icon_scale = 1,
                icon_alpha = 1,
                routes = true,
                zone_disabled = {},
            },
            minimap = {
                enabled = true,
                tooltip_help = false,
                tooltip_completion = true,
                tooltip_regularloot = true,
                tooltip_lootwindow = false,
                icon_scale = 1,
                icon_alpha = 1,
                routes = true,
                edge = module.const.EDGE_FOCUS
            },
            icon_theme = 'skulls', -- circles / skulls
            icon_color = 'distinct', -- completion / distinct
            achieved = true,
            questcomplete = false,
            achievementless = true,
            hidden = {},
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
        ifnotnil(db.worldmap, "tooltip_regularloot", db.tooltip_regularloot)
        ifnotnil(db.worldmap, "icon_scale", db.icon_scale)
        ifnotnil(db.worldmap, "icon_alpha", db.icon_alpha)

        enabled = type(db.minimap) == "boolean" and db.minimap or false
        db.minimap = CopyTable(self.db.defaults.profile.minimap)
        ifnotnil(db.minimap, "enabled", enabled)
        ifnotnil(db.minimap, "tooltip_help", db.tooltip_help)
        ifnotnil(db.minimap, "tooltip_completion", db.tooltip_completion)
        ifnotnil(db.minimap, "tooltip_regularloot", db.tooltip_regularloot)
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

    self.tooltip = ns.Tooltip.Get("OverlayPin")

    GameTooltip:HookScript("OnShow", function(tooltip) self:CleanupTooltip() end)

    self:RegisterConfig()
end

function module:OnEnable()
    WorldMapFrame:AddDataProvider(self.WorldMapDataProvider)
    WorldMapFrame:RegisterCallback("WorldMapOnHide", self.OnWorldMapHide, self)
    HBD.RegisterCallback(self, "PlayerZoneChanged", "UpdateMinimapIcons")
    core.RegisterCallback(self, "Ready", "Update")
    core.RegisterCallback(self, "BrokerMobClick")
    core.RegisterCallback(self, "BrokerMobEnter")
    core.RegisterCallback(self, "BrokerMobLeave")
    core.RegisterCallback(self, "Seen")

    self:RegisterEvent("LOOT_CLOSED", "Update")
end
function module:OnDisable()
    if WorldMapFrame.dataProviders[self.WorldMapDataProvider] then
        WorldMapFrame:RemoveDataProvider(self.WorldMapDataProvider)
    end
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
    self:FocusMob(mobid)
end
function module:BrokerMobEnter(_, mobid)
    self:HighlightMob(mobid)
end
function module:BrokerMobLeave(_, mobid)
    self:UnhighlightMob(mobid)
end

function module:Seen(_, id, zone, x, y, dead, source, unit)
    self.last_mob = id
    self.last_mob_time = time()
    if WorldMapFrame:IsShown() then
        self.WorldMapDataProvider:Ping(id)
    end
end

function module:HighlightMob(mobid)
    if mobid == self.focus_mob then return end
    if not WorldMapFrame:IsShown() then return end
    for pin in self.WorldMapDataProvider:GetMap():EnumeratePinsByTemplate("SilverDragonOverlayWorldMapPinTemplate") do
        if pin.mobid == mobid then
            pin.emphasis:SetVertexColor(1, 1, 1, 1)
            pin.emphasis:Show()
        end
    end
    if self.WorldMapDataProvider.connectionPool then
        for connection in self.WorldMapDataProvider.connectionPool:EnumerateActive() do
            if connection.mobid == mobid then
                connection.Line:SetThickness(30)
            end
        end
    end
end

function module:UnhighlightMob(mobid)
    if mobid == self.focus_mob then return end
    if not WorldMapFrame:IsShown() then return end
    for pin in self.WorldMapDataProvider:GetMap():EnumeratePinsByTemplate("SilverDragonOverlayWorldMapPinTemplate") do
        if pin.mobid == mobid then
            pin.emphasis:Hide()
        end
    end
    if self.WorldMapDataProvider.connectionPool then
        for connection in self.WorldMapDataProvider.connectionPool:EnumerateActive() do
            if connection.mobid == mobid then
                connection.Line:SetThickness(20)
            end
        end
    end
end

function module:FocusMob(mobid)
    if self.focus_mob == mobid then
        self.focus_mob = nil
        self.focus_mob_ping = nil
    else
        self.focus_mob = mobid
    end
    if WorldMapFrame:IsShown() then
        for pin in self.WorldMapDataProvider:GetMap():EnumeratePinsByTemplate("SilverDragonOverlayWorldMapPinTemplate") do
            pin:ApplyFocusState()
            if pin.mobid == self.focus_mob then
                pin:Ping()
            end
        end
    else
        self.focus_mob_ping = true
    end
    self:UpdateMinimapIcons()
end

-- /script SilverDragon:GetModule("Overlay"):Update()
function module:Update()
    ns.ClearRunCaches()
    self:UpdateMinimapIcons()
    self:UpdateWorldMapIcons()
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
    local id = pin.mobid
    if id and ns.mobdb[id] then
        tooltip:AddLine(core:GetMobLabel(id))
        tooltip:AddDoubleLine("Last seen", core:FormatLastSeen(core.db.global.mob_seen[id]))
        if pin:Config().tooltip_completion then
            ns:UpdateTooltipWithCompletion(tooltip, id)
            ns.Loot.Summary.UpdateTooltip(tooltip, id, not pin:Config().tooltip_regularloot)
        end
        if ns.mobdb[id].notes then
            tooltip:AddLine(core:RenderString(ns.mobdb[id].notes), 1, 1, 1, true)
        end
        if pin:Config().tooltip_lootwindow and pin:Config().tooltip_regularloot and ns.Loot.HasRegularLoot(id) then
            self.lootwindow = ns.Loot.Window.ShowForMob(id)
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
        if ns.mobdb[id].requires then
            local metRequirements = ns.conditions.check(ns.mobdb[id].requires)
            local r, g, b = (metRequirements and GREEN_FONT_COLOR or RED_FONT_COLOR):GetRGB()
            tooltip:AddLine(
                core:RenderString(ns.conditions.summarize(ns.mobdb[id].requires), ns.mobdb[id]),
                r, g, b, true
            )
        end
        if ns.mobdb[id].active then
            local isActive = ns.conditions.check(ns.mobdb[id].active)
            local r, g, b = (isActive and GREEN_FONT_COLOR or RED_FONT_COLOR):GetRGB()
            tooltip:AddLine(
                core:RenderString(ns.conditions.summarize(ns.mobdb[id].active), ns.mobdb[id]),
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
    if module.db.profile.worldmap.tooltip_completion then
        ns:UpdateTooltipWithCompletion(tooltip, mobid)
        ns.Loot.Summary.UpdateTooltip(tooltip, mobid, not module.db.profile.worldmap.tooltip_regularloot)
    end
    if ns.mobdb[mobid].notes then
        tooltip:AddLine(core:RenderString(ns.mobdb[mobid].notes), 1, 1, 1, true)
    end
    tooltip:Show()
end

hooksecurefunc(VignettePinMixin, "OnMouseEnter", function(self)
    -- _G.PIN = self
    if not self.hasTooltip then return end
    local vignetteInfo = self.vignetteInfo
    if vignetteInfo.vignetteID and ns.vignetteMobLookup[vignetteInfo.vignetteID] then
        for mobid in pairs(ns.vignetteMobLookup[vignetteInfo.vignetteID]) do
            AddMobToTooltip(GameTooltip, mobid, true)
        end
        return
    end
    if vignetteInfo.name then
        AddMobToTooltip(GameTooltip, core:IdForMob(vignetteInfo.name))
    end
end)

if _G.TaskPOI_OnEnter then
    hooksecurefunc("TaskPOI_OnEnter", function(self)
        if not self.questID then return end
        if not ns.worldQuestMobLookup[self.questID] then return end
        for mobid in pairs(ns.worldQuestMobLookup[self.questID]) do
            AddMobToTooltip(GameTooltip, mobid, true)
        end
    end)
    hooksecurefunc("TaskPOI_OnLeave", function(self)
        -- 10.0.2 doesn't hide this by default any more
        if _G[myname.."ComparisonTooltip"] then _G[myname.."ComparisonTooltip"]:Hide() end
    end)
end
