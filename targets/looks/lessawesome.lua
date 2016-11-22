local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

function module.Looks:LessAwesome(popup)
	-- The "loot, not an upgrade" look
	popup:SetSize(276, 96)

	popup.background:SetSize(276, 96)
	popup.background:SetAtlas("LootToast-LessAwesome", true)
	popup.background:SetPoint("CENTER")

	popup.close:SetPoint("TOPRIGHT", -12, -18)

	popup.modelbg:SetPoint("LEFT", 20, 0)
	self:SizeModel(popup, 7)

	popup.title:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 10, -7)
	popup.source:SetPoint("BOTTOMRIGHT", -20, 20) -- (-14, 4) is a better outside position

	popup.status:SetFontObject("GameFontNormalSmallLeft")
	popup.status:SetSize(157, 10)
	popup.status:SetPoint("TOPLEFT", popup.title, "TOPLEFT", 0, 3)

	popup.glow:SetSize(266, 109)
	popup.glow:SetPoint("TOPLEFT", -10)
	popup.glow:SetPoint("BOTTOMRIGHT", 10)

	popup.shine:SetSize(171, 60)
	popup.shine:SetPoint("BOTTOMLEFT", -10, 12)

	popup.raidIcon:SetPoint("BOTTOM", popup.modelbg, "TOP", 0, -8)
	popup.dead:SetAllPoints(popup.modelbg)
end
