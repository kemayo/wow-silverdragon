local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Browser")
local Debug = core.Debug

--[[
A zone map with the rares on it.

Blizzard's MapCanvas is load-on-demand and far more machinery than this needs, so
the art is tiled by hand as Blizzard_MapCanvasDetailLayer does it. Layer 1 is the
lowest resolution, which is the right trade for a panel this size.

Two child frames, and the split matters: the canvas is scaled to fit, and the
pins must not be, or they would shrink with the terrain.

Pin state comes from the list's cache where it has one, since these are the same
mobs its rows ask about.
]]

local LAYER = 1
local PIN_SIZE = 14
local DEFAULT_ASPECT = 1.5

local MapMixin = {}

local hasMapArt = C_Map.GetMapArtID and C_Map.GetMapArtLayers and C_Map.GetMapArtLayerTextures

function module:CreateMapPane(parent)
	local pane = CreateFrame("Frame", nil, parent)
	Mixin(pane, MapMixin)
	pane:Build()
	return pane
end

function MapMixin:Build()
	self:SetClipsChildren(true)

	self.canvas = CreateFrame("Frame", nil, self)
	self.pins = CreateFrame("Frame", nil, self)
	self.pins:SetPoint("CENTER")
	-- above the click-to-deselect background below, or it would eat pin clicks
	self.pins:SetFrameLevel(self:GetFrameLevel() + 5)

	self.tilePool = CreateTexturePool(self.canvas, "BACKGROUND")
	-- explored areas are painted over the base art, which is the unexplored one
	self.overlayPool = CreateTexturePool(self.canvas, "ARTWORK")
	self.pinPool = CreateFramePool("Button", self.pins)

	-- clicking the map away from a pin goes back to the whole zone
	self.background = CreateFrame("Button", nil, self)
	self.background:SetAllPoints()
	self.background:SetFrameLevel(self:GetFrameLevel())
	self.background:SetScript("OnClick", function()
		if self.focusMob then module:SelectZone(self.uiMapID) end
	end)

	self.message = self:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	self.message:SetPoint("CENTER")
	self.message:Hide()

	self:SetScript("OnSizeChanged", function(pane) pane:Layout() end)
	self:SetScript("OnShow", function(pane) pane:Refresh() end)
end

-- Art

local function artFor(uiMapID)
	return (uiMapID and hasMapArt) and C_Map.GetMapArtID(uiMapID) or nil
end

function MapMixin:SetMap(uiMapID)
	if self.uiMapID == uiMapID and self.artID == artFor(uiMapID) then
		return self:RefreshPins()
	end
	self.uiMapID = uiMapID
	self.artID = artFor(uiMapID)
	self.tilePool:ReleaseAll()
	self.overlayPool:ReleaseAll()
	self.pinPool:ReleaseAll()

	if not (uiMapID and hasMapArt) then
		return self:ShowMessage(uiMapID and "No map art for this zone" or "")
	end

	local layers = C_Map.GetMapArtLayers(uiMapID)
	local layer = layers and layers[LAYER]
	local textures = layer and C_Map.GetMapArtLayerTextures(uiMapID, LAYER)
	if not (layer and textures and #textures > 0) then
		-- continent overlays and some instance floors have none
		return self:ShowMessage("No map art for this zone")
	end
	self.message:Hide()

	local cols = math.ceil(layer.layerWidth / layer.tileWidth)
	local rows = math.ceil(layer.layerHeight / layer.tileHeight)
	self.canvas:SetSize(layer.layerWidth, layer.layerHeight)

	local rowStart, previous
	for row = 1, rows do
		previous = nil
		for col = 1, cols do
			local tile = self.tilePool:Acquire()
			-- Deliberately no SetSize, as Blizzard's detail layer also omits: the
			-- last tile of a row or column is often short, and sizing them all
			-- alike stretches the edges of the map.
			tile:SetTexture(textures[((row - 1) * cols) + col])
			tile:ClearAllPoints()
			if previous then
				tile:SetPoint("TOPLEFT", previous, "TOPRIGHT")
			elseif rowStart then
				tile:SetPoint("TOPLEFT", rowStart, "BOTTOMLEFT")
			else
				tile:SetPoint("TOPLEFT", self.canvas)
			end
			if col == 1 then rowStart = tile end
			previous = tile
			tile:Show()
		end
	end

	self:AddExploration(layer)
	self:Layout()
	self:RefreshPins()
	if module.window then module.window:Layout() end
end

-- The tiled art is the *unexplored* map. Explored ground comes back as a separate
-- set of textures to lay over the top.
--
-- Follows Blizzard's MapExplorationDataProvider, where two details are not
-- guessable: the last tile of a row or column sits in a file padded up to the
-- next power of two, so its texture coordinates are not a fraction of the tile
-- size; and the tile size is the art layer's, not a constant.
local function fileExtent(pixels)
	local size = 16
	while size < pixels do
		size = size * 2
	end
	return size
end

function MapMixin:AddExploration(layerInfo)
	if not (C_MapExplorationInfo and C_MapExplorationInfo.GetExploredMapTextures) then return end
	local overlays = C_MapExplorationInfo.GetExploredMapTextures(self.uiMapID)
	if not overlays then return end
	local tileWidth, tileHeight = layerInfo.tileWidth, layerInfo.tileHeight

	for _, info in ipairs(overlays) do
		-- the map's own hover highlights: drawn always, they would show ground
		-- you have not explored
		if not info.isShownByMouseOver then
			local cols = math.ceil(info.textureWidth / tileWidth)
			local rows = math.ceil(info.textureHeight / tileHeight)
			for row = 1, rows do
				local pixelHeight, fileHeight = tileHeight, tileHeight
				if row == rows then
					pixelHeight = info.textureHeight % tileHeight
					if pixelHeight == 0 then pixelHeight = tileHeight end
					fileHeight = fileExtent(pixelHeight)
				end
				for col = 1, cols do
					local pixelWidth, fileWidth = tileWidth, tileWidth
					if col == cols then
						pixelWidth = info.textureWidth % tileWidth
						if pixelWidth == 0 then pixelWidth = tileWidth end
						fileWidth = fileExtent(pixelWidth)
					end
					local texture = self.overlayPool:Acquire()
					texture:SetSize(pixelWidth, pixelHeight)
					texture:SetTexCoord(0, pixelWidth / fileWidth, 0, pixelHeight / fileHeight)
					texture:ClearAllPoints()
					texture:SetPoint("TOPLEFT", self.canvas, "TOPLEFT",
						info.offsetX + (tileWidth * (col - 1)),
						-(info.offsetY + (tileHeight * (row - 1))))
					texture:SetTexture(info.fileDataIDs[((row - 1) * cols) + col], nil, nil, "TRILINEAR")
					texture:Show()
				end
			end
		end
	end
end

function MapMixin:ShowMessage(text)
	self.canvas:SetSize(1, 1)
	self.message:SetText(text)
	self.message:SetShown(text ~= "")
	if module.window then module.window:Layout() end
end

-- The window sizes the map slot from this, so the art spans the full width of
-- the detail column rather than sit letterboxed inside it.
function MapMixin:GetAspect()
	local width, height = self.canvas:GetWidth(), self.canvas:GetHeight()
	if not (width and height) or width <= 1 or height <= 1 then return DEFAULT_ASPECT end
	return width / height
end

function MapMixin:Layout()
	local width, height = self.canvas:GetWidth(), self.canvas:GetHeight()
	if not (width and height) or width <= 1 or height <= 1 then return end
	local scale = math.min(self:GetWidth() / width, self:GetHeight() / height)
	if scale <= 0 then return end

	self.canvas:SetScale(scale)
	self.pins:SetSize(width * scale, height * scale)
	self.canvas:ClearAllPoints()
	-- a zero offset means the same thing whatever the scale, so this is safe
	self.canvas:SetPoint("TOPLEFT", self.pins, "TOPLEFT")

	self:PlacePins()
end

-- Pins

function MapMixin:PinState(id)
	-- returns whether to show it at all, and whether to dim it
	if self.focusMob and id ~= self.focusMob then
		if not module.db.profile.mapShowAll then return false end
		return true, true
	end
	if not module.passesFilter(id) then return false end
	if not core:ShouldShowMob(id, self.uiMapID) then return false end
	-- out of phase, or its area POI is down: still worth showing here, but not
	-- worth claiming it is there now
	return true, not core:IsMobInPhase(id, self.uiMapID)
end

function MapMixin:RefreshPins()
	self.pinPool:ReleaseAll()
	if not (self.uiMapID and ns.mobsByZone[self.uiMapID]) then return end

	local theme = ns.MobStateIcons[module:IconTheme()]
	local placed = {}
	ns.HoldRunCaches()
	for id, coords in pairs(ns.mobsByZone[self.uiMapID]) do
		local show, dim = self:PinState(id)
		if show then
			local icon = theme[module:MobStateFor(id)] or theme.unknown
			for _, coord in ipairs(coords) do
				table.insert(placed, {id = id, coord = coord, icon = icon, dim = dim})
			end
		end
	end
	ns.ReleaseRunCaches()

	for _, entry in ipairs(placed) do
		local pin = self:AcquirePin()
		pin.mobid = entry.id
		pin.coord = entry.coord
		pin.uiMapID = self.uiMapID
		pin.texture:SetAtlas(entry.icon.atlas)
		pin.texture:SetVertexColor(entry.icon.r, entry.icon.g, entry.icon.b, entry.icon.a)
		pin:SetAlpha(entry.dim and 0.4 or 1)
		pin:Show()
	end
	self:PlacePins()
end

function MapMixin:AcquirePin()
	local pin, isNew = self.pinPool:Acquire()
	if isNew then
		pin:SetSize(PIN_SIZE, PIN_SIZE)
		pin.texture = pin:CreateTexture(nil, "OVERLAY")
		pin.texture:SetAllPoints()
		pin:SetScript("OnEnter", function(p)
			core.events:Fire("BrokerMobEnter", p.mobid)
			local tooltip = ns.Tooltip.Get("Browser")
			tooltip:SetOwner(p, "ANCHOR_RIGHT")
			tooltip:AddLine(core:GetMobLabel(p.mobid))
			local x, y = core:GetXY(p.coord)
			tooltip:AddDoubleLine(core.zone_names[p.uiMapID] or UNKNOWN,
				("%.1f, %.1f"):format(x * 100, y * 100))
			if not core:IsMobInPhase(p.mobid, p.uiMapID) then
				tooltip:AddLine("Belongs to a different version of this zone", 1, 0.5, 0.5, true)
			end
			ns.Loot.Summary.UpdateTooltip(tooltip, p.mobid)
			tooltip:Show()
		end)
		pin:SetScript("OnLeave", function(p)
			core.events:Fire("BrokerMobLeave", p.mobid)
			ns.Tooltip.Get("Browser"):Hide()
		end)
		pin:SetScript("OnClick", function(p)
			module:SelectMob(p.mobid, p.uiMapID)
		end)
	end
	return pin
end

function MapMixin:PlacePins()
	local width, height = self.pins:GetWidth(), self.pins:GetHeight()
	if not (width and height) or width <= 0 then return end
	for pin in self.pinPool:EnumerateActive() do
		local x, y = core:GetXY(pin.coord)
		pin:ClearAllPoints()
		pin:SetPoint("CENTER", self.pins, "TOPLEFT", x * width, -y * height)
	end
end

function MapMixin:Refresh()
	self:SetMap(self.uiMapID)
end

function MapMixin:SetFocusMob(id)
	self.focusMob = id
	self:RefreshPins()
end

-- Module-level plumbing

-- Ask only for mobs the list has not already answered for. A pin can be for a
-- mob no row has drawn, so its loot may still need fetching.
function module:MobStateFor(id)
	local known = self.stateCache[id]
	if known then return known end
	self:RequestLoot(id)
	return ns.MobState(id)
end

function module:SetMapZone(uiMapID)
	if not (self.window and self.window.mapPane) then return end
	self.window.mapPane:SetMap(uiMapID)
end

function module:SetMapFocus(id)
	if not (self.window and self.window.mapPane) then return end
	self.window.mapPane:SetFocusMob(id)
end

function module:RefreshMap()
	if not (self.window and self.window.mapPane and self.window:IsShown()) then return end
	self.window.mapPane:Refresh()
end
