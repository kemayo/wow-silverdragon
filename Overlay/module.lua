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
            worldmap = true,
            minimap = true,
            minimap_edge = module.const.EDGE_FOCUS,
            icon_theme = 'skulls', -- circles / skulls
            icon_color = 'distinct', -- completion / distinct
            icon_scale = 1,
            icon_alpha = 1,
            icon_scale_minimap = 1,
            icon_alpha_minimap = 1,
            achieved = true,
            questcomplete = false,
            achievementless = true,
            tooltip_help = true,
            tooltip_completion = true,
            tooltip_regularloot = true,
            hidden = {},
        },
    })
    db = self.db.profile

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
    core.RegisterCallback(self, "Ready", "BuildNodeList")
    core.RegisterCallback(self, "BrokerMobClick")
    core.RegisterCallback(self, "BrokerMobEnter")
    core.RegisterCallback(self, "BrokerMobLeave")
    core.RegisterCallback(self, "Seen")

    self:RegisterEvent("LOOT_CLOSED", "Update")
    self:BuildNodeList()
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

module.nodes = {}
function module:BuildNodeList()
    wipe(self.nodes)
    for zone, mobs in pairs(ns.mobsByZone) do
        self.nodes[zone] = {}
        for id, locs in pairs(mobs) do
            if core:IsMobInPhase(id, zone) and not core:ShouldIgnoreMob(id, zone) then
                for _, loc in ipairs(locs) do
                    self.nodes[zone][loc] = id
                end
            end
        end
    end
    self:Update()
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
end

function module:UnhighlightMob(mobid)
    if mobid == self.focus_mob then return end
    if not WorldMapFrame:IsShown() then return end
    for pin in self.WorldMapDataProvider:GetMap():EnumeratePinsByTemplate("SilverDragonOverlayWorldMapPinTemplate") do
        if pin.mobid == mobid then
            pin.emphasis:Hide()
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
        if db.tooltip_completion then
            ns:UpdateTooltipWithCompletion(tooltip, id)
            ns.Loot.Summary.UpdateTooltip(tooltip, id, true)
        end
        if db.tooltip_regularloot and ns.Loot.HasRegularLoot(id) then
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

    if db.tooltip_help then
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


-- Pin mixin

local SilverDragonOverlayPinMixinBase = {}

function SilverDragonOverlayPinMixinBase:OnAcquired(mobid, x, y, textureInfo, scale, alpha, originalCoord, originalMapID, minimap)
    self.mobid = mobid
    self.coord = originalCoord
    self.uiMapID = originalMapID
    self.minimap = minimap

    if not minimap then
        self:SetPosition(x, y)
    end

    local size, inset
    if minimap then
        size = 12
        scale = db.icon_scale_minimap * scale
        alpha = db.icon_alpha_minimap * alpha
    else
        size = 12
        scale = db.icon_scale * scale
        alpha = db.icon_alpha * alpha
    end
    size = size * scale
    self:SetSize(size, size)
    inset = 3 * scale
    self:SetHitRectInsets(inset, inset, inset, inset)
    self:SetAlpha(alpha)

    if textureInfo.r then
        self.texture:SetVertexColor(textureInfo.r, textureInfo.g, textureInfo.b, textureInfo.a)
    else
        self.texture:SetVertexColor(1, 1, 1, 1)
    end
    if textureInfo.atlas then
        self.texture:SetAtlas(textureInfo.atlas)
    else
        if textureInfo.tCoordLeft then
            self.texture:SetTexCoord(textureInfo.tCoordLeft, textureInfo.tCoordRight, textureInfo.tCoordTop, textureInfo.tCoordBottom)
        else
            self.texture:SetTexCoord(0, 1, 0, 1)
        end
        self.texture:SetTexture(textureInfo.icon)
    end

    self.DriverAnimation:Finish()

    self:ApplyFocusState()
end

function SilverDragonOverlayPinMixinBase:OnMouseEnter()
    if not self.minimap then
        module:HighlightMob(self.mobid)
    end
    module:ShowTooltip(self)
end

function SilverDragonOverlayPinMixinBase:OnMouseLeave()
    if not self.minimap then
        module:UnhighlightMob(self.mobid)
    end

    if module.lootwindow then return end

    module:CleanupTooltip()
end

function SilverDragonOverlayPinMixinBase:OnMouseDown(button)
end

function SilverDragonOverlayPinMixinBase:OnMouseUp(button)
    local targets = core:GetModule("ClickTarget", true)
    if button == "RightButton" then
        if IsShiftKeyDown() then
            db.hidden[self.mobid] = true
            module:Update()
        else
            module:ShowPinDropdown(self, self.uiMapID, self.coord)
        end
        return
    end
    if button == "LeftButton" then
        if IsAltKeyDown() then
           module.CreateWaypoint(self, self.uiMapID, self.coord)
           return
        end
        if IsShiftKeyDown() then
            if targets then
                local x, y = core:GetXY(self.coord)
                if x and y then
                    targets:SendLinkToMob(self.mobid, self.uiMapID, x, y)
                end
            end
            return
        end
        if not self.minimap then
            module:FocusMob(self.mobid)
        end
    end
end

function SilverDragonOverlayPinMixinBase:Ping()
    self.DriverAnimation:Play()
    self.ScaleAnimation:Play()
end

function SilverDragonOverlayPinMixinBase:ApplyFocusState()
    if self.mobid == module.focus_mob then
        self.emphasis:Show()
        self.emphasis:SetVertexColor(0, 1, 1, 1)
    else
        if not MouseIsOver(self) then
            self.emphasis:Hide()
        end
        self.emphasis:SetVertexColor(1, 1, 1, 1)
    end
end

-- World map

module.WorldMapDataProvider = CreateFromMixins(MapCanvasDataProviderMixin)

function module.WorldMapDataProvider:RemoveAllData()
    if not self:GetMap() then return end
    self:GetMap():RemoveAllPinsByTemplate("SilverDragonOverlayWorldMapPinTemplate")
end

function module.WorldMapDataProvider:RefreshAllData(fromOnShow)
    if not self:GetMap() then return end
    self:RemoveAllData()

    if not db.worldmap then return end

    local uiMapID = self:GetMap():GetMapID()
    if not uiMapID then return end

    for coord, mobid, textureData, scale, alpha in module:IterateNodes(uiMapID, false) do
        local x, y = core:GetXY(coord)
        if x and y then
            self:GetMap():AcquirePin("SilverDragonOverlayWorldMapPinTemplate", mobid, x, y, textureData, scale or 1.0, alpha or 1.0, coord, uiMapID, false)
            ns.Loot.Cache(mobid)
        end
    end

    if module.last_mob and time() < (module.last_mob_time + 30) then
        self:Ping(module.last_mob)
    end
    if module.focus_mob_ping then
        self:Ping(module.focus_mob)
        module.focus_mob_ping = nil
    end
end

-- /script SilverDragon:GetModule("Overlay").WorldMapDataProvider:Ping(32487)
function module.WorldMapDataProvider:Ping(mobid)
    for pin in self:GetMap():EnumeratePinsByTemplate("SilverDragonOverlayWorldMapPinTemplate") do
        if pin.mobid == mobid then
            pin:Ping()
        end
    end
end

SilverDragonOverlayWorldMapPinMixin = CreateFromMixins(MapCanvasPinMixin, SilverDragonOverlayPinMixinBase)

function SilverDragonOverlayWorldMapPinMixin:OnLoad()
    self:UseFrameLevelType("PIN_FRAME_LEVEL_VIGNETTE")
    self:SetScalingLimits(1, 1.0, 1.2)
end

function SilverDragonOverlayWorldMapPinMixin:OnReleased()
    self:Hide()
end

SilverDragonOverlayMapPinPingDriverAnimationMixin = {}

function SilverDragonOverlayMapPinPingDriverAnimationMixin:OnPlay()
    self.loops = 0
    self:GetParent().Expand:Show()
end

function SilverDragonOverlayMapPinPingDriverAnimationMixin:OnLoop()
    self.loops = self.loops + 1
    if self.loops >= 2 then
        self:Finish()
    end
end

function SilverDragonOverlayMapPinPingDriverAnimationMixin:OnFinished()
    local pin = self:GetParent()
    pin.ScaleAnimation:Stop()
    pin.Expand:Hide()
end

function module:UpdateWorldMapIcons()
    self.WorldMapDataProvider:RefreshAllData()
end

-- Minimap

local minimapPins = {}
module.minimapPins = minimapPins
function module:UpdateMinimapIcons()
    HBDPins:RemoveAllMinimapIcons(self)
    for _, pin in pairs(minimapPins) do
        pin:Hide()
        minimapPins[pin] = nil
        self.pool:Release(pin)
    end

    local uiMapID = HBD:GetPlayerZone()
    if not uiMapID then return end

    for coord, mobid, textureData, scale, alpha in module:IterateNodes(uiMapID, true) do
        local x, y = core:GetXY(coord)
        local pin, newPin = self.pool:Acquire()
        if newPin then
            pin:OnLoad()
        end
        pin:OnAcquired(mobid, x, y, textureData, scale or 1.0, alpha or 1.0, coord, uiMapID, true)

        local edge = db.minimap_edge == module.const.EDGE_ALWAYS
        if db.minimap_edge == module.const.EDGE_FOCUS then
            edge = mobid == module.focus_mob
        end

        minimapPins[pin] = pin
        HBDPins:AddMinimapIconMap(self, pin, uiMapID, x, y, false, edge)

        pin:UpdateEdge()
    end
end

SilverDragonOverlayMinimapPinMixin = CreateFromMixins(SilverDragonOverlayPinMixinBase)

function SilverDragonOverlayMinimapPinMixin:OnLoad()
    self:SetParent(Minimap)
    self:SetFrameStrata(Minimap:GetFrameStrata())
    self:SetFrameLevel(Minimap:GetFrameLevel() + 5)
    self:EnableMouse()

    self:SetScript("OnEnter", self.OnMouseEnter)
    self:SetScript("OnLeave", self.OnMouseLeave)
    self:SetScript("OnMouseUp", self.OnMouseUp)

    self:SetMouseClickEnabled(true)
    self:SetMouseMotionEnabled(true)
end

function SilverDragonOverlayMinimapPinMixin:UpdateEdge()
    self:SetAlpha(HBDPins:IsMinimapIconOnEdge(self) and 0.6 or 1)
end

-- Dropdown setup

do
    local clicked_zone, clicked_coord

    local function hideMob(button, mobid)
        if mobid then
            db.hidden[mobid] = true
            module:Update()
        end
    end

    function module.CreateWaypoint(button, uiMapID, coord)
        -- point to it, without a timeout, and ignoring whether it'll be replacing an existing waypoint
        local id, name = core:GetMobByCoord(uiMapID, coord)
        local x, y = core:GetXY(coord)
        core:GetModule("TomTom"):PointTo(id, uiMapID, x, y, 0, true)
    end

    local function createWaypointForAll(button, uiMapID, mobid)
        if not TomTom then return end
        if not (ns.mobsByZone[uiMapID] and ns.mobsByZone[uiMapID][mobid]) then return end
        for _, mob_coord in ipairs(ns.mobsByZone[uiMapID][mobid]) do
            local x, y = core:GetXY(mob_coord)
            TomTom:AddWaypoint(uiMapID, x, y, {
                title = core:GetMobLabel(mobid),
                persistent = nil,
                minimap = true,
                world = true
            })
        end
    end

    local dropdown = CreateFrame("Frame", nil, UIParent, "UIDropDownMenuTemplate")
    dropdown.displayMode = "MENU"

    dropdown.initialize = function(button, level)
        if (not level) then return end
        local info = UIDropDownMenu_CreateInfo()
        if (level == 1) then
            -- Create the title of the menu
            info.isTitle      = 1
            info.text         = "SilverDragon Overlay"
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, level)

            -- Waypoint menu item
            info.disabled     = nil
            info.isTitle      = nil
            info.notCheckable = nil
            info.text = "Create waypoint"
            info.icon = nil
            info.func = module.CreateWaypoint
            info.arg1 = button.uiMapID
            info.arg2 = button.coord
            UIDropDownMenu_AddButton(info, level)

            info.disabled = not TomTom
            info.isTitle = nil
            info.notCheckable = nil
            info.text = "Create waypoint for all locations"
            info.icon = nil
            info.func = createWaypointForAll
            info.arg1 = button.uiMapID
            info.arg2 = button.mobid
            UIDropDownMenu_AddButton(info, level)

            -- Hide menu item
            info.disabled     = nil
            info.isTitle      = nil
            info.notCheckable = nil
            info.text = "Hide mob"
            info.icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01"
            info.func = hideMob
            info.arg1 = button.mobid
            UIDropDownMenu_AddButton(info, level)

            -- Close menu item
            info.text         = "Close"
            info.icon         = nil
            info.func         = function() CloseDropDownMenus() end
            info.arg1         = nil
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, level)
        end
    end

    function module:ShowPinDropdown(pin, uiMapID, coord)
        dropdown.uiMapID = uiMapID
        dropdown.coord = coord
        dropdown.mobid = pin.mobid
        ToggleDropDownMenu(1, nil, dropdown, pin, 0, 0)
    end
end

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
        if db.hidden[id] or core:ShouldIgnoreMob(id) then
            return false
        end
        if not db.mountcomplete and ns.Loot.HasMounts(id) then
            --check if mount is collected, if so hide pin
            if ns.Loot.Status.Mount(id) then
                return false
            end
        end
        local quest, achievement, achievement_completed_by_alt = ns:CompletionStatus(id)
        if achievement ~= nil then
            if quest ~= nil then
                -- we have a quest *and* an achievement; we're going to treat "show achieved" as "show achieved if I can still loot them"
                return (db.questcomplete or not quest) and (db.achieved or not achievement)
            end
            -- no quest, but achievement
            return db.achieved or not achievement
        end
        if db.achievementless then
            -- no achievement, but quest
            return db.questcomplete or not quest
        end
        return false
    end
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
        local set = icons[db.icon_theme]
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
                if db.icon_color == 'distinct' then
                    icon = distinct_icon_for_mob(value)
                else
                    icon = icon_for_mob(value)
                end
                return state, value, icon, icon.scale, db.icon_alpha
            end
            state, value = next(t, state)
        end
        return nil, nil, nil, nil, nil
    end
    function module:IterateNodes(uiMapID, minimap)
        Debug("Overlay IterateNodes", uiMapID, minimap)
        if minimap and not db.minimap then
            return iter, {}, nil
        end
        return iter, self.nodes[uiMapID], nil
    end
end
