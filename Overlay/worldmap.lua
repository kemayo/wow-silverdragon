local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

module.WorldMapDataProvider = CreateFromMixins(MapCanvasDataProviderMixin)

function module.WorldMapDataProvider:OnAdded(owningMap)
    self.owningMap = owningMap

    if not self.poiQuantizer and _G.WorldMapPOIQuantizerMixin then
        self.poiQuantizer = CreateFromMixins(WorldMapPOIQuantizerMixin)
        self.poiQuantizer.size = 75
        self.poiQuantizer:OnLoad(self.poiQuantizer.size, self.poiQuantizer.size)
    end
end

function module.WorldMapDataProvider:RemoveAllData()
    if not self:GetMap() then return end
    self:GetMap():RemoveAllPinsByTemplate("SilverDragonOverlayWorldMapPinTemplate")
    -- routes
    self:GetMap():RemoveAllPinsByTemplate("SilverDragonOverlayRoutePinTemplate")
    if self.connectionPool then
        self.connectionPool:ReleaseAll()
    end
end

local pinsToQuantize = {}
function module.WorldMapDataProvider:RefreshAllData(fromOnShow)
    if not self:GetMap() then return end
    self:RemoveAllData()
    if not self.connectionPool then
        self.connectionPool = CreateFramePool("FRAME", self:GetMap():GetCanvas(), "SilverDragonOverlayRoutePinConnectionTemplate")
    end

    if not module.db.profile.worldmap.enabled then return end

    local uiMapID = self:GetMap():GetMapID()
    if not uiMapID then return end

    if module.db.profile.worldmap.zone_disabled[uiMapID] then return end

    -- Regular nodes
    for coord, mobid, textureData, scale, alpha in module:IterateNodes(uiMapID, false) do
        local x, y = core:GetXY(coord)
        if x and y then
            local pin = self:GetMap():AcquirePin("SilverDragonOverlayWorldMapPinTemplate", mobid, x, y, textureData, scale or 1.0, alpha or 1.0, coord, uiMapID, false)
            ns.Loot.Cache(mobid)
            table.insert(pinsToQuantize, pin)
        end
    end
    if self.poiQuantizer then
        self.poiQuantizer:ClearAndQuantize(pinsToQuantize)
        for _, pin in ipairs(pinsToQuantize) do
            pin:SetPosition(pin.quantizedX or pin.normalizedX, pin.quantizedY or pin.normalizedY)
        end
    end
    wipe(pinsToQuantize)

    -- Routes
    if module.db.profile.worldmap.routes and ns.mobsByZone[uiMapID] and self:GetMap():IsVisible() then
        for mobid, coords in pairs(ns.mobsByZone[uiMapID]) do
            self:AddRoute(uiMapID, mobid)
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

local routePins = {}
function module.WorldMapDataProvider:AddRoute(uiMapID, mobid)
    local data = ns.mobdb[mobid or 0]
    if not data then return end
    if not (data.routes and data.routes[uiMapID]) then return end
    if not (core:IsMobInPhase(mobid, uiMapID) and not core:ShouldIgnoreMob(mobid, uiMapID)) then return end
    if not module.should_show_mob(mobid) then return end
    for _, route in ipairs(data.routes[uiMapID]) do
        for _, node in ipairs(route) do
            local x, y = core:GetXY(node)
            local pin = self:GetMap():AcquirePin("SilverDragonOverlayRoutePinTemplate")
            pin.mobid = mobid
            pin:SetPosition(x, y)
            pin.Icon:Hide()
            pin:Show()
            if routePins[#routePins] then
                self:ConnectPins(routePins[#routePins], pin, mobid, route)
            end
            table.insert(routePins, pin)
        end
        if route.loop and #routePins > 1 then
            self:ConnectPins(routePins[#routePins], routePins[1], mobid, route)
        end
        wipe(routePins)
    end
end

function module.WorldMapDataProvider:ConnectPins(pin1, pin2, mobid, route)
    local connection = self.connectionPool:Acquire()
    connection.mobid = mobid
    connection:Connect(pin1, pin2)
    local r, g, b, a = 1, 1, 1, 0.6
    if route and route.r then
        r, g, b, a = route.r or 1, route.g or 1, route.b or 1, route.a or 0.6
    else
        r, g, b = module.id_to_color(mobid)
    end
    connection.Line:SetVertexColor(r, g, b, a)
    connection:Show()
end

function module.WorldMapDataProvider:OnCanvasSizeChanged()
    if self.poiQuantizer then
        local ratio = self:GetMap():DenormalizeHorizontalSize(1.0) / self:GetMap():DenormalizeVerticalSize(1.0)
        self.poiQuantizer:Resize(math.ceil(self.poiQuantizer.size * ratio), self.poiQuantizer.size)
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

SilverDragonOverlayWorldMapPinMixin = CreateFromMixins(MapCanvasPinMixin, module.SilverDragonOverlayPinMixinBase)

function SilverDragonOverlayWorldMapPinMixin:OnLoad()
    self:UseFrameLevelType("PIN_FRAME_LEVEL_VIGNETTE")
    self:SetScalingLimits(1, 1.0, 1.2)
end

SilverDragonOverlayRoutePinMixin = CreateFromMixins(MapCanvasPinMixin)
function SilverDragonOverlayRoutePinMixin:OnLoad()
    -- This is below normal pins
    self:UseFrameLevelType(ns.CLASSIC and "PIN_FRAME_LEVEL_MAP_LINK" or "PIN_FRAME_LEVEL_EVENT_OVERLAY");
end

SilverDragonOverlayRoutePinConnectionMixin = {}

function SilverDragonOverlayRoutePinConnectionMixin:Connect(pin1, pin2)
    self:SetParent(pin1)
    -- Anchor straight up from the origin
    self:SetPoint("BOTTOM", pin1, "CENTER")
    if not (pin1:GetCenter() and pin2:GetCenter()) then
        -- I'm seeing reports of errors in CalculateAngleBetween which would imply one of the pins
        -- isn't returning a center. I can't reproduce this to test it, but I think aborting here
        -- should avoid errors.
        return
    end
    -- Then adjust the height to be the length from origin to pin
    local length = RegionUtil.CalculateDistanceBetween(pin1, pin2) * pin1:GetEffectiveScale()
    self:SetHeight(length)
    -- And finally rotate all the textures around the origin so they line up
    local quarter = (math.pi / 2)
    local angle = RegionUtil.CalculateAngleBetween(pin1, pin2) - quarter
    self:RotateTextures(angle, 0.5, 0)
    -- self.Line:SetRotation(angle, 0.5, 0)
    self.angle = angle
    pin1.connectionOut = self
    pin2.connectionIn = self

    if ns.CLASSIC then
        -- self.Line:SetTexture("Interface\\TaxiFrame\\UI-Taxi-Line")
        self.Line:SetAtlas("_UI-Taxi-Line-horizontal")
    else
        self.Line:SetAtlas("_AnimaChannel-Channel-Line-horizontal")
    end

    self.Line:SetStartPoint("CENTER", pin1)
    self.Line:SetEndPoint("CENTER", pin2)

    self.Line:SetThickness(20)
end


function module:UpdateWorldMapIcons()
    self.WorldMapDataProvider:RefreshAllData()
end
