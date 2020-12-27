local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Overlay", "AceEvent-3.0")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

local db
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
            },
            minimap = {
                enabled = true,
                tooltip_help = false,
                tooltip_completion = true,
                tooltip_regularloot = true,
                tooltip_lootwindow = false,
                icon_scale = 1,
                icon_alpha = 1,
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
    db = self.db.profile

    -- migration
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

    -- frame pool for minimap pins (world map is handled by the data provider)
    self.pool = CreateFramePool("FRAME", Minimap, "SilverDragonOverlayMinimapPinTemplate")
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
    self:UpdateMinimapIcons()
    self:UpdateWorldMapIcons()
end

C_Timer.NewTicker(0.5, function(...)
    for pin in pairs(module.minimapPins) do
        pin:UpdateEdge()
    end
end)

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
        if ns.mobdb[id].notes then
            tooltip:AddDoubleLine("Note", ns.mobdb[id].notes)
        end
        tooltip:AddDoubleLine("Last seen", core:FormatLastSeen(core.db.global.mob_seen[id]))
        if pin.config.tooltip_completion then
            ns:UpdateTooltipWithCompletion(tooltip, id)
            ns.Loot.Summary.UpdateTooltip(tooltip, id, not pin.config.tooltip_regularloot)
        end
        if pin.config.tooltip_lootwindow and pin.config.tooltip_regularloot and ns.Loot.HasRegularLoot(id) then
            self.lootwindow = ns.Loot.Window.ShowForMob(id)
            self.lootwindow:SetParent(tooltip)
            if pin:GetCenter() > UIParent:GetCenter() then
                self.lootwindow:SetPoint("TOPRIGHT", tooltip, "BOTTOMRIGHT")
            else
                self.lootwindow:SetPoint("TOPLEFT", tooltip, "BOTTOMLEFT")
            end
            self.lootwindow:SetAutoHideDelay(0.25, {pin, tooltip}, function()
                self:CleanupTooltip()
            end)

            core.events:Fire("LootWindowOpened", self.lootwindow)
        end
    else
        tooltip:AddLine(UNKNOWN)
        tooltip:AddDoubleLine("At", pin.uiMapID .. ':' .. pin.coord)
    end

    if core.debuggable then
        tooltip:AddDoubleLine(ID, id)
        tooltip:AddDoubleLine(LOCATION_COLON, ("%s %s"):format(pin.uiMapID, pin.coord))
    end

    if pin.config.tooltip_help then
        tooltip:AddLine(escapes.keyDown .. ALT_KEY_TEXT .. " + " .. escapes.leftClick .. "  " .. MAP_PIN )
        if C_Map.CanSetUserWaypointOnMap(pin.uiMapID) then
            tooltip:AddLine(escapes.keyDown .. SHIFT_KEY_TEXT .. " + " .. escapes.leftClick .. "  " .. TRADESKILL_POST )
        end
        tooltip:AddLine(escapes.keyDown .. SHIFT_KEY_TEXT .. " + " .. escapes.rightClick .. "  " .. HIDE )
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
