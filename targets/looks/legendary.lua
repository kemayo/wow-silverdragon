local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

function module.Looks:Legendary(popup)
	popup:SetSize(302, 119)

	-- left, right, top, bottom
	popup:SetHitRectInsets(20, 0, 15, 15)

	popup.background:SetSize(276, 96)
	popup.background:SetAtlas("LegendaryToast-background", true)
	popup.background:SetPoint("CENTER")

	popup.close:SetPoint("TOPRIGHT", -18, -24)

	popup.modelbg:SetPoint("TOPLEFT", 48, -32)
	self:SizeModel(popup, 1)

	popup.title:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 11, -16)
	popup.source:SetPoint("BOTTOMRIGHT", -20, 26)

	popup.status:SetSize(160, 22)
	popup.status:SetPoint("TOPLEFT", 107, -26)

	popup.glow:SetSize(298, 109)
	popup.glow:SetPoint("CENTER", 10, 1)

	popup.shine:SetSize(171, 75)
	popup.shine:SetPoint("BOTTOMLEFT", 10, 24)

	popup.raidIcon:SetPoint("BOTTOM", popup.modelbg, "TOP", 0, -8)
	popup.lootIcon:SetPoint("CENTER", popup.modelbg, "BOTTOMLEFT", 0, 0)

	popup.dead:SetAllPoints(popup.modelbg)
end
