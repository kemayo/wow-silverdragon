local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

function module.Looks:Classic(popup)
	-- The <v4 SilverDragon look
	popup:SetSize(190, 70)

	-- popup.background:SetSize(190, 70)
	popup.background:SetTexture([[Interface\AchievementFrame\UI-Achievement-Parchment-Horizontal]])
	popup.background:ClearAllPoints()
	popup.background:SetPoint("BOTTOMLEFT", 3, 3)
	popup.background:SetPoint("TOPRIGHT", -3, -3)
	popup.background:SetTexCoord(0, 1, 0, 0.25)

	popup:SetBackdrop({
		tile = true, edgeSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	})
	popup:SetBackdropBorderColor(0.7, 0.15, 0.05)

	popup.close:SetPoint("TOPRIGHT", -3, -3)

	-- popup.modelbg:SetPoint("BOTTOMLEFT", 3, 3)
	popup.modelbg:SetSize(popup:GetHeight() - 20, popup:GetHeight() - 20)
	popup.modelbg:SetPoint("TOPLEFT", popup.title, "BOTTOMLEFT", 0, -2)
	popup.modelbg:SetPoint("BOTTOMLEFT", popup, "BOTTOMLEFT", 4, 4)
	self:SizeModel(popup, 0, 0)

	popup.title:SetFontObject("GameFontHighlightMedium")
	popup.title:SetHeight(18)
	popup.title:SetPoint("TOPLEFT", popup, "TOPLEFT", 6, -6)
	popup.title:SetPoint("RIGHT", popup, "RIGHT", -20, 0)

	popup.source:SetFontObject("GameFontWhite")
	popup.source:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 3, -3)
	popup.source:SetPoint("RIGHT", 0, 0)
	popup.source:SetJustifyH("CENTER")

	popup.status:SetFontObject("GameFontWhite")
	popup.status:SetPoint("TOPLEFT", popup.source, 0, -12)
	popup.status:SetPoint("RIGHT", 0, 0)
	popup.status:SetJustifyH("CENTER")

	-- popup.glow:SetSize(190, 110)
	popup.glow:SetPoint("TOPLEFT", -20)
	popup.glow:SetPoint("BOTTOMRIGHT", 20)

	popup.shine:SetSize(120, 60)
	popup.shine:SetPoint("TOPLEFT", -10, -3)

	select(3, popup.shine.animIn:GetAnimations()):SetOffset(70, 0)

	popup.raidIcon:SetPoint("BOTTOMRIGHT", popup.background, "TOPLEFT", 12, -12)
	popup.dead:SetAllPoints(popup.modelbg)
end
