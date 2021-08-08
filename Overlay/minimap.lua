local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

local f = CreateFrame("Frame", myname .. "MiniMapDataProviderFrame")
local dataProvider = {
    pins = {},
    pinPools = {},
    -- pool = CreateFramePool("FRAME", Minimap, "SilverDragonOverlayMinimapPinTemplate"),
}
module.MiniMapDataProvider = dataProvider

function dataProvider:RefreshAllData()
    HBDPins:RemoveAllMinimapIcons(self)
    self:ReleaseAllPins()

    if not module.db.profile.minimap.enabled then return end

    local uiMapID = HBD:GetPlayerZone()
    if not uiMapID then return end

    for coord, mobid, textureData, scale, alpha in module:IterateNodes(uiMapID, true) do
        local x, y = core:GetXY(coord)
        local pin = self:AcquirePin("SilverDragonOverlayMinimapPinTemplate", mobid, x, y, textureData, scale or 1.0, alpha or 1.0, coord, uiMapID, true)

        local edge = module.db.profile.minimap.edge == module.const.EDGE_ALWAYS
        if module.db.profile.minimap.edge == module.const.EDGE_FOCUS then
            edge = mobid == module.focus_mob
        end

        self.pins[pin] = pin
        HBDPins:AddMinimapIconMap(self, pin, uiMapID, x, y, false, edge)

        pin:UpdateEdge()
    end

    if module.db.profile.minimap.routes and ns.mobsByZone[uiMapID] then
        for mobid, coords in pairs(ns.mobsByZone[uiMapID]) do
            self:AddRoute(uiMapID, mobid)
        end
    end
end

local function OnPinReleased(pinPool, pin)
    FramePool_HideAndClearAnchors(pinPool, pin)
    pin:OnReleased()

    pin.pinTemplate = nil
    pin.provider = nil
end
function dataProvider:AcquirePin(pinTemplate, ...)
    if not self.pinPools[pinTemplate] then
        self.pinPools[pinTemplate] = CreateFramePool("FRAME", Minimap, pinTemplate, OnPinReleased)
    end
    local pin, newPin = self.pinPools[pinTemplate]:Acquire()

    pin.pinTemplate = pinTemplate
    pin.provider = self

    if newPin then
        pin:OnLoad()
    end

    pin:Show()
    pin:OnAcquired(...)

    return pin
end

function dataProvider:ReleaseAllPins()
    for _, pool in pairs(self.pinPools) do
        pool:ReleaseAll()
    end
end

C_Timer.NewTicker(0.5, function(...)
    for pin in pairs(dataProvider.pins) do
        pin:UpdateEdge()
    end
end)

function dataProvider:AddRoute(uiMapID, mobid)
    local data = ns.mobdb[mobid or 0]
    if not data then return end
    if not (data.routes and data.routes[uiMapID]) then return end
    if not (core:IsMobInPhase(mobid, uiMapID) and not core:ShouldIgnoreMob(mobid, uiMapID)) then return end
    if not module.should_show_mob(mobid) then return end
    for _, route in ipairs(data.routes[uiMapID]) do
        for i=1, #route - 1 do
            self:DrawSegment(route[i], route[i+1], uiMapID, mobid, route)
        end
        if route.loop and #route > 1 then
            self:DrawSegment(route[1], route[#route], uiMapID, mobid, route)
        end
    end
end

local segmented = {}
function dataProvider:DrawSegment(coord1, coord2, ...)
    wipe(segmented)
    local x1, y1 = core:GetXY(coord1)
    local x2, y2 = core:GetXY(coord2)

    -- find an appropriate number of segments
    local distance = math.sqrt(((x2-x1) * 1.85)^2 + (y2-y1)^2)
    local segments = floor(distance / 0.015)

    for i=0, segments do
        segmented[#segmented + 1] = core:GetCoord(
            x1 + (x2-x1) / segments * i,
            y1 + (y2-y1) / segments * i
        )
    end
    for i=1, #segmented - 1 do
        self:AcquirePin("SilverDragonOverlayMinimapRoutePinTemplate", segmented[i], segmented[i + 1], ...)
    end
end

--

SilverDragonOverlayMinimapPinMixin = CreateFromMixins(module.SilverDragonOverlayPinMixinBase)

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
    local alpha = (HBDPins:IsMinimapIconOnEdge(self) and 0.6 or 1) * self.config.icon_alpha
    self:SetAlpha(alpha)
end

SilverDragonOverlayMinimapRoutePinMixin = {}
function SilverDragonOverlayMinimapRoutePinMixin:OnLoad()
    self:SetParent(Minimap)
    self:SetFrameStrata(Minimap:GetFrameStrata())
    self:SetFrameLevel(Minimap:GetFrameLevel() + 3)
    -- self.texture:SetTexture("Interface\\TaxiFrame\\UI-Taxi-Line")
    self.texture:SetAtlas("_AnimaChannel-Channel-Line-horizontal")

    self.minimap = true
    self.config = module.db.profile.minimap
end

function SilverDragonOverlayMinimapRoutePinMixin:OnAcquired(coord1, coord2, uiMapID, mobid, route)
    -- print("OnAcquired", coord1, coord2, uiMapID)
    local x1, y1 = core:GetXY(coord1)
    local x2, y2 = core:GetXY(coord2)

    local wx1, wy1 = HBD:GetWorldCoordinatesFromZone(x1, y1, uiMapID)
    local wx2, wy2 = HBD:GetWorldCoordinatesFromZone(x2, y2, uiMapID)
    local wmapDistance = math.sqrt((wx2-wx1)^2 + (wy2-wy1)^2)
    local mmapDiameter = C_Minimap:GetViewRadius() * 2
    local length = Minimap:GetWidth() * (wmapDistance / mmapDiameter)
    self.rotation = -math.atan2(wy2-wy1, wx2-wx1)

    self:SetSize(length, 30)
    self.texture:SetRotation(self.rotation)

    local r, g, b, a = 1, 1, 1, 0.6
    if route and route.r then
        r, g, b, a = route.r or 1, route.g or 1, route.b or 1, route.a or 0.6
    else
        r, g, b = module.id_to_color(mobid)
    end
    self.texture:SetVertexColor(r, g, b, a * self.config.icon_alpha)

    local x, y = (x1+x2)/2, (y1+y2)/2
    HBDPins:AddMinimapIconMap(dataProvider, self, uiMapID, x, y)
end
function SilverDragonOverlayMinimapRoutePinMixin:OnReleased()
    self.texture:SetRotation(0)
    self.texture:SetTexCoord(0, 1, 0, 1)
    self.texture:SetVertexColor(1, 1, 1, 1)
    self.rotation = nil
    self:SetAlpha(1)
    if self.SetScalingLimits then -- world map
        self:SetScalingLimits(nil, nil, nil)
    end
end

--

function module:UpdateMinimapIcons()
    self.MiniMapDataProvider:RefreshAllData()
end
