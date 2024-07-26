local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("VignetteStretch", "AceEvent-3.0")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

local compat_disabled

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("VignetteStretch", {
		profile = {
			enabled = true,
			mystery = true,
			types = {
				vignettekill = true,
				vignettekillelite = true,
				vignetteloot = true,
				vignettelootelite = true,
				vignetteevent = true,
				vignetteeventelite = true,
			},
		},
	})

	compat_disabled = C_AddOns.IsAddOnLoaded("MinimapRangeExtender") or (LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_MISTS_OF_PANDARIA or 999))
	self.compat_disabled = compat_disabled

	self.pool = CreateFramePool("FRAME", Minimap, "SilverDragonVignetteStretchPinTemplate")

	self:RegisterConfig()
end

function module:OnEnable()
	if self.compat_disabled then return end
	self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	self:RegisterEvent("VIGNETTES_UPDATED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "VIGNETTES_UPDATED")

	self:VIGNETTES_UPDATED()
end

function module:GetVignetteID(vignetteGUID, vignetteInfo)
    return vignetteInfo and vignetteInfo.vignetteID or tonumber((select(6, strsplit('-', vignetteGUID))))
end

local vignetteIcons = {
	-- [instanceid] = icon
}

function module:VIGNETTE_MINIMAP_UPDATED(event, instanceid, onMinimap, ...)
	-- Debug("VIGNETTE_MINIMAP_UPDATED", instanceid, onMinimap, ...)
	if not instanceid then
		-- ...just in case
		return
	end

	local icon = vignetteIcons[instanceid]
	if not icon then
		return self:UpdateVignetteOnMinimap(instanceid)
	end

	if onMinimap then
		icon.texture:Hide()
	else
		icon.texture:Show()
	end
end
function module:VIGNETTES_UPDATED()
	local vignetteids = C_VignetteInfo.GetVignettes()
	-- Debug("VIGNETTES_UPDATED", #vignetteids)

	for instanceid, icon in pairs(vignetteIcons) do
		if not tContains(vignetteids, instanceid) or (icon.info and not self.db.profile.types[icon.info.atlasName:lower()]) or (not icon.info and not self.db.profile.mystery) or not self.db.profile.enabled then
			HBDPins:RemoveMinimapIcon(self, icon)
			icon:Hide()
			icon.info = nil
			vignetteIcons[instanceid] = nil
			self.pool:Release(icon)
		end
	end

	for i=1, #vignetteids do
		self:UpdateVignetteOnMinimap(vignetteids[i])
	end
end

function module:UpdateVignetteOnMinimap(instanceid)
	if compat_disabled or not self.db.profile.enabled then
		return
	end
	-- Debug("considering vignette", instanceid)
	local uiMapID = C_Map.GetBestMapForUnit("player")
	if not uiMapID then
		return -- Debug("can't determine current zone")
	end
	local vignetteInfo = C_VignetteInfo.GetVignetteInfo(instanceid)
	if not self.db.profile.mystery and not (vignetteInfo and vignetteInfo.vignetteGUID and vignetteInfo.atlasName) then
		return -- Debug("vignette had no info")
	end
	if vignetteInfo then
		if not self.db.profile.types[vignetteInfo.atlasName:lower()] then
			return -- Debug("vignette type not enabled", vignetteInfo.atlasName)
		end
	end
	local position = C_VignetteInfo.GetVignettePosition(instanceid, uiMapID)
	if not position then
		return -- Debug("vignette had no position")
	end
	local x, y = position:GetXY()
	if self:ShouldHideVignette(instanceid, vignetteInfo, uiMapID, x, y) then
		return
	end

	local icon = vignetteIcons[instanceid]
	if not icon then
		icon = self.pool:Acquire()
		icon.texture:SetAtlas(vignetteInfo and vignetteInfo.atlasName or "poi-nzothvision")
		icon.texture:SetAlpha(vignetteInfo and 1 or 0.7)
		icon.texture:SetDesaturated(true)
		vignetteIcons[instanceid] = icon
		HBDPins:AddMinimapIconMap(self, icon, uiMapID, x, y, false, true)
		-- icon.instanceid = instanceid
		icon.info = vignetteInfo
		icon.coord = core:GetCoord(x, y)
	end

	if vignetteInfo and vignetteInfo.onMinimap then
		icon.texture:Hide()
	else
		icon.texture:Show()
	end

	self:UpdateEdge(icon)
end

do
	-- These show up for glowing highlights on NPCs in-town a lot, which gets in the way
	local inconvenient = {
		-- Valdrakken
		[5473] = true, -- Unatos, Keeper of Renown
		-- Ohn'ahran Plains
		[5472] = true, -- Agari Dotur, Keeper of Renown
		-- Azure Span
		[5435] = true, -- Fishing Gear Crafter
		[5471] = true, -- Murik, Keeper of Renown
		-- Waking Shores
		[5273] = true, -- Expedition Supply Kit
		[5470] = true, -- Cataloger Jakes
		-- Forbidden Reach
		[5670] = true, -- Storykeeper Ashekh (x2, strangely)
		-- Zalarak Cavern
		[5684] = true, -- Mimeep, Keeper of Renown
		-- Emerald Dream
		[5759] = true, -- Amrymn, Keeper of Renown
	}
	function module:ShouldHideVignette(vignetteGUID, vignetteInfo, uiMapID, x, y)
		local vignetteID = self:GetVignetteID(vignetteGUID, vignetteInfo)
		return vignetteID and inconvenient[vignetteID]
	end
end

function module:UpdateEdge(icon)
	icon:SetAlpha(HBDPins:IsMinimapIconOnEdge(icon) and 0.6 or 1)
end

C_Timer.NewTicker(1, function(...)
	for instanceid, icon in pairs(vignetteIcons) do
		module:UpdateEdge(icon)
	end
end)

SilverDragonVignetteStretchPinMixin = {}
function SilverDragonVignetteStretchPinMixin:OnLoad()
	self:SetMouseClickEnabled(false)
end
function SilverDragonVignetteStretchPinMixin:OnMouseEnter()
	-- TODO: see VignettePinMixin for PVP bounty vignettes if I want to handle this?
	-- Debug("OnMouseEnter", self, self.info and self.info.name)
	if self:GetCenter() > UIParent:GetCenter() then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	end
	GameTooltip_SetTitle(GameTooltip, self.info and self.info.name or UNKNOWN)
	if not self.info then
		GameTooltip:AddLine("This mystery vignette has no information available", 1, 1, 1, true)
		if core.debuggable then
			GameTooltip:AddDoubleLine(LOCATION_COLON, self.coord)
		end
	end
	GameTooltip:Show()
end
function SilverDragonVignetteStretchPinMixin:OnMouseLeave()
	GameTooltip:Hide()
end

