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

--

function module:UpdateMinimapIcons()
    self.MiniMapDataProvider:RefreshAllData()
end
