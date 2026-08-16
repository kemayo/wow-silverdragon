local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local ns = core.NAMESPACE

ns.MapSystem = {}

ns.MapSystem.GetWorldMapFrameLevelByType = function(levelType, levelIndex)
    return WorldMapFrame.ScrollContainer:GetMap():GetPinFrameLevelsManager():GetValidFrameLevel(levelType, levelIndex)
end

-- This is largely copied from p3lim's work, with permission

local overlay = CreateFrame("Frame", nil, WorldMapFrame:GetCanvas())
overlay:SetAllPoints()
overlay:EnableMouse(false)
overlay:SetFrameStrata("MEDIUM")

local pinMixin = {}
function pinMixin:SetNormalAtlas(atlas)
    self.Texture:SetAtlas(atlas)
end

function pinMixin:SetHighlightAtlas(atlas, blendMode)
    self.Highlight:SetAtlas(atlas)
    self.Highlight:SetBlendMode(blendMode or "ADD")
end

function pinMixin:Raise()
    self:SetFrameLevel(self:GetFrameLevel() + 1)
end

function pinMixin:Lower()
    self:SetFrameLevel(self:GetFrameLevel() - 1)
end

function pinMixin:OnEnter(...)
    if self.provider.OnPinEnter then
        self.provider.OnPinEnter(self, ...)
    end
end

function pinMixin:OnLeave(...)
    if self.provider.OnPinLeave then
        self.provider.OnPinLeave(self, ...)
    end
end

function pinMixin:OnMouseDown(button)
    if self.provider.OnPinClick then
        self.provider.OnPinClick(self, button, true)
    end
end

function pinMixin:OnMouseUp(button)
    if self.provider.OnPinClick then
        self.provider.OnPinClick(self, button, false)
    end
end

function pinMixin:SetPosition(mapID, x, y)
    local currentMapID = WorldMapFrame:GetMapID()
    if currentMapID ~= mapID then
        -- current map does not match the data, try to translate positions
        local continentID, continentPos = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(x, y))
        local _, pos = C_Map.GetMapPosFromWorldPos(continentID, continentPos, currentMapID)
        if pos then
            x, y = pos:GetXY()
        else
            return
        end
    end

    self.x = x
    self.y = y
    return true
end

function pinMixin:SetScalingLimits(scaleFactor, startScale, endScale)
    self.scaleFactor = scaleFactor or 1
    self.startScale = startScale and math.max(startScale, .01) or nil
    self.endScale = endScale and math.max(endScale, .01) or nil
end

function pinMixin:GetCurrentScale()
    local canvasZoom = WorldMapFrame:GetCanvasZoomPercent()
    local canvasScaleFactor = 1 / WorldMapFrame:GetCanvasScale()
    if self.startScale and self.endScale then
        return canvasScaleFactor * Lerp(self.startScale, self.endScale, Saturate(self.scaleFactor * canvasZoom))
    end
    return canvasScaleFactor
end


local function CreateProviderPool(provider)
    return CreateObjectPool(function()
        local pin = Mixin(CreateFrame("Frame", nil, overlay, provider.template), pinMixin)
        pin:SetScript("OnEnter", pin.OnEnter)
        pin:SetScript("OnLeave", pin.OnLeave)
        pin:SetScript("OnMouseUp", pin.OnMouseUp)
        pin:SetScript("OnMouseDown", pin.OnMouseDown)

        if provider.OnPinCreated then
            provider.OnPinCreated(pin)
        else
            pin.Texture = pin:CreateTexture()
            pin.Texture:SetAllPoints()

            pin.Highlight = pin:CreateTexture(nil, "HIGHLIGHT")
            pin.Highlight:SetAllPoints()
        end

        return pin
    end, function(pool, pin)
        (_G.FramePool_HideAndClearAnchors or _G.Pool_HideAndClearAnchors)(pool, pin)
        pin:SetFrameLevel(5) -- this is the default
        pin:SetScale(1)

        if provider.OnPinReset then
            provider.OnPinReset(pin)
        end

        pin.x = nil
        pin.y = nil

        -- ns.MapSystem:ReleaseArrow(pin)
    end)
end

local providerMixin = {}
function providerMixin:RefreshData()
    if #self.data == 0 or (self.notInCombat and InCombatLockdown()) then
        return
    end

    for _, data in next, self.data do
        if self.HandleData then
            self:HandleData(data)
        elseif self.OnPinAcquire then
            local pin = self:AcquirePin()

            local mapID, x, y = self.OnPinAcquire(pin, data)
            if mapID and pin:SetPosition(mapID, x, y) then
                pin:Show()
            else
                self:ReleasePin(pin)
            end
        end
    end
end

function providerMixin:AcquirePin(mapID, x, y)
    local pin, isNew = self.pool:Acquire()
    pin.provider = self
    return pin, isNew
end
function providerMixin:ReleasePin(pin)
    self.pool:Release(pin)
end

function providerMixin:GetPinByID(id)
    for pin in self.pool:EnumerateActive() do
        if pin:GetID() == id then
            return pin
        end
    end
end

function providerMixin:EnumeratePins()
    return self.pool:EnumerateActive()
end

local providers = {}
function ns.MapSystem:AddProvider(mixin)
    if not providers[mixin] then
        providers[mixin] = CreateFromMixins(providerMixin, mixin)
        providers[mixin].pool = CreateProviderPool(providers[mixin])
    end
    -- the mixin isn't the provider, so hand back the thing with the pool on it
    return providers[mixin]
end

function ns.MapSystem:RemoveProvider(mixin)
    if providers[mixin] then
        providers[mixin] = nil
    end
end

function ns.MapSystem:ProxyEvent(event, ...)
    -- pass through a core handynotes point event
    for _, provider in next, providers do
        if provider.Proxy and provider.Proxy[event] then
            provider.Proxy[event](provider, event, ...)
        end
    end
end

local function updatePinSize()
    for _, provider in next, providers do
        for pin in provider.pool:EnumerateActive() do
            local scale = pin:GetCurrentScale()
            local posX = (overlay:GetWidth() * pin.x) / scale
            local posY = (overlay:GetHeight() * pin.y) / scale

            pin:SetScale(scale)
            pin:SetPoint("CENTER", overlay, "TOPLEFT", posX, -posY)
        end
    end
end

local function updateProviders()
    ns.MapSystem:ReleaseLines()
    for _, provider in next, providers do
        if provider.OnRefresh then provider:OnRefresh() end
        provider.pool:ReleaseAll()
        provider:RefreshData()
        if provider.AfterRefresh then provider:AfterRefresh() end
    end
    -- a refresh takes fresh pins out of the pool with their anchors cleared, and
    -- nothing else places them until the canvas next changes scale
    updatePinSize()
end

WorldMapFrame:HookScript("OnHide", function()
    for _, provider in next, providers do
        provider.pool:ReleaseAll()
        if provider.OnMapHide then
            provider:OnMapHide()
        end
    end
end)

function ns.MapSystem:UpdateProviders()
    updateProviders()
end

-- these two hook are sufficient for acquire/release logic
hooksecurefunc(WorldMapFrame, "RefreshAll", updateProviders)
hooksecurefunc(WorldMapFrame, "OnMapChanged", updateProviders)

-- this hook is needed to correctly set pin position and scale
hooksecurefunc(WorldMapFrame, "OnCanvasScaleChanged", updatePinSize)

-- catch the map being open while combat-transitions occur
overlay:SetScript("OnEvent", updateProviders)
overlay:RegisterEvent("PLAYER_REGEN_ENABLED")
overlay:RegisterEvent("PLAYER_REGEN_DISABLED")
