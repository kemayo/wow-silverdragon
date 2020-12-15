local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

local minimapPins = {}
module.minimapPins = minimapPins
function module:UpdateMinimapIcons()
    HBDPins:RemoveAllMinimapIcons(self)
    for _, pin in pairs(minimapPins) do
        pin:Hide()
        minimapPins[pin] = nil
        self.pool:Release(pin)
    end

    if not module.db.profile.minimap.enabled then return end

    local uiMapID = HBD:GetPlayerZone()
    if not uiMapID then return end

    for coord, mobid, textureData, scale, alpha in module:IterateNodes(uiMapID, true) do
        local x, y = core:GetXY(coord)
        local pin, newPin = self.pool:Acquire()
        if newPin then
            pin:OnLoad()
        end
        pin:OnAcquired(mobid, x, y, textureData, scale or 1.0, alpha or 1.0, coord, uiMapID, true)

        local edge = module.db.profile.minimap.edge == module.const.EDGE_ALWAYS
        if module.db.profile.minimap.edge == module.const.EDGE_FOCUS then
            edge = mobid == module.focus_mob
        end

        minimapPins[pin] = pin
        HBDPins:AddMinimapIconMap(self, pin, uiMapID, x, y, false, edge)

        pin:UpdateEdge()
    end
end

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
    self:SetAlpha(HBDPins:IsMinimapIconOnEdge(self) and 0.6 or 1)
end