local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

local frameLevelType = ns.CLASSIC and "PIN_FRAME_LEVEL_WORLD_QUEST" or "PIN_FRAME_LEVEL_VIGNETTE"

-- Mobs

local mobs = {
    template = "SilverDragonOverlayWorldMapPinTemplate",
    data = {},
}

-- IterateNodes works the whole zone out under one cache hold, so its results
-- have to be carried rather than looked up again per-pin. These are reused by
-- index to keep a refresh from allocating.
local nodecache = {}
function mobs:OnRefresh()
    wipe(self.data)

    -- if we're here really early for some reason
    if not module.db then return end
    if not module.db.profile.worldmap.enabled then return end

    local uiMapID = WorldMapFrame:GetMapID()
    if not uiMapID then return end
    if module.db.profile.worldmap.zone_disabled[uiMapID] then return end

    for coord, mobid, icon, scale, alpha in module:IterateNodes(uiMapID, false) do
        ns.Loot.Cache(mobid)
        local index = #self.data + 1
        local node = nodecache[index]
        if not node then
            node = {}
            nodecache[index] = node
        end
        node.coord, node.mobid, node.icon = coord, mobid, icon
        node.scale, node.alpha, node.uiMapID = scale or 1, alpha or 1, uiMapID
        self.data[index] = node
    end
end

function mobs.OnPinCreated(pin)
    pin:OnLoad()
end

function mobs.OnPinAcquire(pin, node)
    -- the pool resets the frame level on release, so this can't live in OnLoad
    pin:SetFrameLevel(ns.MapSystem.GetWorldMapFrameLevelByType(frameLevelType))
    pin:OnAcquired(node.mobid, node.icon, node.scale, node.alpha, node.coord, node.uiMapID, false)
    return node.uiMapID, core:GetXY(node.coord)
end

function mobs.OnPinReset(pin)
    -- the quantizer prefers whatever it last wrote to the pin's new position
    pin.quantizedX, pin.quantizedY = nil, nil
    if pin.OnReleased then
        -- pins only have the mixin once they've been created
        pin:OnReleased()
    end
end

function mobs.OnPinEnter(pin)
    pin:OnMouseEnter()
end

function mobs.OnPinLeave(pin)
    pin:OnMouseLeave()
end

function mobs.OnPinClick(pin, button, down)
    if down then return end
    pin:OnClick(button)
end

local quantizer
if _G.WorldMapPOIQuantizerMixin then
    quantizer = CreateFromMixins(WorldMapPOIQuantizerMixin)
    quantizer.size = 75
    quantizer:OnLoad(quantizer.size, quantizer.size)
end

local pinsToQuantize = {}
function mobs:AfterRefresh()
    if quantizer then
        wipe(pinsToQuantize)
        for pin in self:EnumeratePins() do
            table.insert(pinsToQuantize, pin)
        end
        -- the quantizer reads x/y off the pins and writes quantizedX/Y back
        local ratio = WorldMapFrame:DenormalizeHorizontalSize(1.0) / WorldMapFrame:DenormalizeVerticalSize(1.0)
        quantizer:Resize(math.ceil(quantizer.size * ratio), quantizer.size)
        quantizer:ClearAndQuantize(pinsToQuantize)
        for _, pin in ipairs(pinsToQuantize) do
            pin.x = pin.quantizedX or pin.x
            pin.y = pin.quantizedY or pin.y
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

-- /script SilverDragon:GetModule("Overlay").WorldMapProvider:Ping(32487)
function mobs:Ping(mobid)
    for pin in self:EnumeratePins() do
        if pin.mobid == mobid then
            pin:Ping()
        end
    end
end

function mobs:Emphasize(mobid, state)
    for pin in self:EnumeratePins() do
        if pin.mobid == mobid then
            pin.emphasis:SetVertexColor(1, 1, 1, 1)
            pin.emphasis:SetShown(state)
        end
    end
end

function mobs:ApplyFocusState()
    for pin in self:EnumeratePins() do
        pin:ApplyFocusState()
        if pin.mobid == module.focus_mob then
            pin:Ping()
        end
    end
end

module.WorldMapProvider = ns.MapSystem:AddProvider(mobs)

-- Routes

local routes = {
    data = {},
}

local routecache = {}
function routes:OnRefresh()
    wipe(self.data)

    if not module.db then return end
    if not (module.db.profile.worldmap.enabled and module.db.profile.worldmap.routes) then return end

    local uiMapID = WorldMapFrame:GetMapID()
    if not uiMapID then return end
    if module.db.profile.worldmap.zone_disabled[uiMapID] then return end
    if not ns.mobsByZone[uiMapID] then return end

    for mobid in pairs(ns.mobsByZone[uiMapID]) do
        local data = ns.mobdb[mobid]
        if data and data.routes and data.routes[uiMapID] and module.should_show_mob(mobid, uiMapID) then
            for _, route in ipairs(data.routes[uiMapID]) do
                if not routecache[route] then
                    routecache[route] = {route = route, mobid = mobid, uiMapID = uiMapID}
                end
                table.insert(self.data, routecache[route])
            end
        end
    end
end

function routes.OnPinCreated(pin)
    pin:EnableMouse(false)
end

function routes.OnPinReset(pin)
    pin.mobid = nil
    pin.line = nil
end

function routes:Connect(pin1, pin2, routedata)
    local route = routedata.route
    local r, g, b, a = 1, 1, 1, 0.6
    if route.r then
        r, g, b, a = route.r or 1, route.g or 1, route.b or 1, route.a or 0.6
    else
        r, g, b = module.id_to_color(routedata.mobid)
    end
    local line = ns.MapSystem:AttachLine(pin1, pin2)
    line.baseThickness = line:GetThickness()
    line:SetVertexColor(r, g, b, a)
    return line
end

function routes:HandleData(routedata)
    local firstPin, prevPin
    for _, coord in ipairs(routedata.route) do
        local pin = self:AcquirePin()
        pin:SetSize(1, 1) -- needs a size or the route can't connect
        pin.mobid = routedata.mobid
        if pin:SetPosition(routedata.uiMapID, core:GetXY(coord)) then
            pin:Show()
            if prevPin then
                pin.line = self:Connect(prevPin, pin, routedata)
            end
            prevPin = pin
            firstPin = firstPin or pin
        else
            self:ReleasePin(pin)
        end
    end
    if routedata.route.loop and firstPin and prevPin ~= firstPin then
        firstPin.line = self:Connect(prevPin, firstPin, routedata)
    end
end

function routes:Emphasize(mobid, state)
    for pin in self:EnumeratePins() do
        if pin.line and pin.mobid == mobid then
            pin.line:SetThickness(pin.line.baseThickness * (state and 1.5 or 1))
        end
    end
end

module.WorldMapRouteProvider = ns.MapSystem:AddProvider(routes)

-- Pin mixin

SilverDragonOverlayWorldMapPinMixin = CreateFromMixins(module.SilverDragonOverlayPinMixinBase)

function SilverDragonOverlayWorldMapPinMixin:OnLoad()
    self:SetScalingLimits(1, 1.0, 1.2)
    self:EnableMouse(true)
    self:SetMouseClickEnabled(true)
    self:SetMouseMotionEnabled(true)
end

function module:UpdateWorldMapIcons()
    ns.MapSystem:UpdateProviders()
end
