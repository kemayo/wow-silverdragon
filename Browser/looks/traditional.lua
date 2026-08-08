local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Browser")

-- The Blizzard panel look, so this sits happily beside the adventure guide.
--
-- A frame can only inherit PortraitFrameTemplate at creation, and this window
-- changes look at runtime, so the gold border is applied in code instead.
-- NineSliceCodeTemplate is the supported way to do that, but which layouts are
-- registered varies by client -- see bestLayout.

-- Straight off PortraitFrameBaseTemplate: a 62x62 texture hung at (-5, 7) from
-- the frame's top-left, rounded with a mask inset 2px on each side and 4px up
-- from the bottom. The metal ring comes from the nine-slice corner.
local PORTRAIT_SIZE = 62
-- Without that ring there is nothing for a portrait to sit in, so the icon
-- becomes an ordinary one inside the frame.
local ICON_SIZE = 16
local ROW2 = 28 -- top of the search / dropdown / filter row

-- Which layouts a client registers varies: classic has no PortraitFrameTemplate,
-- and stops at ButtonFrameTemplateNoPortrait. Ask for the layout rather than for
-- the template, or the border silently comes out empty on the ones that lack it.
-- Dialog is the last resort, and every supported version has it.
local PREFERRED_LAYOUTS = {"PortraitFrameTemplate", "ButtonFrameTemplateNoPortrait", "Dialog"}

local function bestLayout()
	if not (_G.NineSliceUtil and NineSliceUtil.GetLayout) then return end
	for _, name in ipairs(PREFERRED_LAYOUTS) do
		if NineSliceUtil.GetLayout(name) then
			return name
		end
	end
end

function module.Looks:Traditional(window)
	window.headerHeight = ROW2 + 22 + 8
	window.rowHeight = 26
	window.insetLeft, window.insetRight, window.insetBottom = 12, 12, 10

	window:SetBackdrop(nil)
	window.background:SetTexture([[Interface\FrameGeneral\UI-Background-Rock]], "REPEAT", "REPEAT")
	window.background:SetHorizTile(true)
	window.background:SetVertTile(true)
	window.background:Show()

	local layout = window.nineSlice and bestLayout()
	if layout then
		window.nineSlice.layoutType = layout
		window.nineSlice:OnLoad()
		window.nineSlice:Show()
	end

	window.close:ClearAllPoints()

	local portrait = layout == "PortraitFrameTemplate"
	window.icon:ClearAllPoints()
	window.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	window.icon:Show()
	if portrait then
		window.icon:SetSize(PORTRAIT_SIZE, PORTRAIT_SIZE)
		window.icon:SetPoint("TOPLEFT", -5, 7)
		window.portraitMask:ClearAllPoints()
		window.portraitMask:SetPoint("TOPLEFT", window.icon, "TOPLEFT", 4, -2)
		window.portraitMask:SetPoint("BOTTOMRIGHT", window.icon, "BOTTOMRIGHT", -6, 6)
		window.icon:AddMaskTexture(window.portraitMask)
		window.close:SetPoint("TOPRIGHT", 0, 0)
	else
		window.icon:SetSize(ICON_SIZE, ICON_SIZE)
		window.icon:SetPoint("TOPLEFT", 8, -4)
		window.close:SetPoint("TOPRIGHT", 4, 4)
	end

	window.title:SetFontObject("GameFontNormal")
	window.title:ClearAllPoints()
	window.title:SetPoint("TOP", 0, -6)
	window.title:SetJustifyH("CENTER")

	-- clear of the portrait, which overhangs the frame's corner
	local iconWidth = portrait and PORTRAIT_SIZE or (ICON_SIZE + 12)
	window.search:ClearAllPoints()
	window.search:SetPoint("TOPLEFT", iconWidth + 6, -ROW2)

	window.filter:ClearAllPoints()
	window.filter:SetPoint("TOPRIGHT", -12, -ROW2)

	window.grouping:ClearAllPoints()
	window.grouping:SetPoint("TOPRIGHT", window.filter, "TOPLEFT", -4, 0)

	window.navInset:SetColorTexture(0, 0, 0, 0.4)
	window.navInset:Show()
	window.detailInset:SetColorTexture(0, 0, 0, 0.25)
	window.detailInset:Show()

	window.splitter.texture:SetColorTexture(0, 0, 0, 0.6)

	window:Layout()
	window.search:SetWidth(math.max(80, module.NAV_WIDTH - iconWidth + 4))
end

module.LookReset.Traditional = function(_, window)
	if window.nineSlice then
		window.nineSlice:Hide()
	end
	window:SetBackdrop(nil)
	window.background:Hide()
	window.background:SetHorizTile(false)
	window.background:SetVertTile(false)
	window.icon:RemoveMaskTexture(window.portraitMask)
	window.navInset:Hide()
	window.detailInset:Hide()
	window.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	window.title:SetJustifyH("LEFT")
	window.insetLeft, window.insetRight, window.insetBottom = 0, 0, 0
end
