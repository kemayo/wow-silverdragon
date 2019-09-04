local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("VignetteStretch", "AceEvent-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

local compat_disabled

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("VignetteStretch", {
		profile = {
			enabled = true,
		},
	})

	compat_disabled = IsAddOnLoaded("MinimapRangeExtender")

	self.pool = CreateFramePool("FRAME", Minimap, "SilverDragonVignetteStretchPinTemplate")

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.outputs.plugins.vignettes = {
			vignettes = {
				type = "group",
				name = "Vignettes",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					about = config.desc("Extend the range at which minimap vignettes will appear on the minimap.", 0),
					enabled = config.toggle("Enabled", "Extend the range at which minimap vignettes will appear on the minimap.", 10),
				},
			},
		}
		if compat_disabled then
			config.options.args.outputs.plugins.vignettes.vignettes.args.enabled.disabled = true
			config.options.args.outputs.plugins.vignettes.vignettes.args.disabled = config.desc("Disabled because MinimapRangeExtender is installed and loaded, which does the same thing", 15)
		end
	end
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
		Debug("No Vignette instanceid")
		return
	end

	local icon = vignetteIcons[instanceid]
	if not icon then
		return module:UpdateVignetteOnMinimap(instanceid)
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
		if not tContains(vignetteids, instanceid) then
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
	local uiMapID = HBD:GetPlayerZone()
	if not uiMapID then
		return Debug("can't determine current zone")
	end
	local vignetteInfo = C_VignetteInfo.GetVignetteInfo(instanceid)
	if not (vignetteInfo and vignetteInfo.vignetteGUID and vignetteInfo.atlasName) then
		return Debug("vignette had no info")
	end
	if vignetteInfo.type ~= Enum.VignetteType.Normal then
		return Debug("vignette isn't normal")
	end
	local position = C_VignetteInfo.GetVignettePosition(vignetteInfo.vignetteGUID, uiMapID)
	if not position then
		return Debug("vignette had no position")
	end
	local x, y = position:GetXY()

	local icon = vignetteIcons[instanceid]
	if not icon then
		icon = self.pool:Acquire()
		icon.texture:SetAtlas(vignetteInfo.atlasName)
		icon.texture:SetDesaturated(true)
		vignetteIcons[instanceid] = icon
		HBDPins:AddMinimapIconMap(self, icon, uiMapID, x, y, false, true)
		icon.info = vignetteInfo
	end

	if vignetteInfo.onMinimap then
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
	-- self:SetMovable(true)
	-- self:RegisterForClicks("AnyUp", "AnyDown")
	-- Debug("OnLoad")
end
function SilverDragonVignetteStretchPinMixin:OnMouseEnter()
	-- TODO: see VignettePinMixin for PVP bounty vignettes if I want to handle this?
	-- Debug("OnMouseEnter", self)
	if not (self.info and self.info.name) then return end
	if self:GetCenter() > UIParent:GetCenter() then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	end
	GameTooltip_SetTitle(GameTooltip, self.info.name)
end
function SilverDragonVignetteStretchPinMixin:OnMouseLeave()
	GameTooltip:Hide()
end

