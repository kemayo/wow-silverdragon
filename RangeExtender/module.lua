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

	compat_disabled = IsAddOnLoaded("MinimapRangeExtender")
	self.compat_disabled = compat_disabled

	self.pool = CreateFramePool("FRAME", Minimap, "SilverDragonVignetteStretchPinTemplate")

	self:RegisterConfig()
end

function module:OnEnable()
	self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	self:RegisterEvent("VIGNETTES_UPDATED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "VIGNETTES_UPDATED")

	self:VIGNETTES_UPDATED()
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

	local icon = vignetteIcons[instanceid]
	if not icon then
		icon = self.pool:Acquire()
		icon.texture:SetAtlas(vignetteInfo and vignetteInfo.atlasName or "poi-nzothvision")
		icon.texture:SetDesaturated(true)
		vignetteIcons[instanceid] = icon
		HBDPins:AddMinimapIconMap(self, icon, uiMapID, x, y, false, true)
		-- icon.instanceid = instanceid
		icon.info = vignetteInfo
	end

	if vignetteInfo and vignetteInfo.onMinimap then
		icon.texture:Hide()
	else
		icon.texture:Show()
	end

	self:UpdateEdge(icon)
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
	end
	GameTooltip:Show()
end
function SilverDragonVignetteStretchPinMixin:OnMouseLeave()
	GameTooltip:Hide()
end

