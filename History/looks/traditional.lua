local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("History")

-- The Blizzard panel look, minus the portrait: that corner art doesn't cope
-- with this window's resizing. ButtonFrameTemplateNoPortrait is registered on
-- every supported client; Dialog is the last resort if that ever changes.
local PREFERRED_LAYOUTS = {"ButtonFrameTemplateNoPortrait", "Dialog"}

local function bestLayout()
	if not (_G.NineSliceUtil and NineSliceUtil.GetLayout) then return end
	for _, name in ipairs(PREFERRED_LAYOUTS) do
		if NineSliceUtil.GetLayout(name) then
			return name
		end
	end
end

-- ButtonFrameTemplateNoPortrait has no portrait corner to draw one over, so
-- one is faked instead: the icon masked round, with this ring over it.
local RING = "hud-PlayerFrame-portraitring-large"
local RING_SIZE = 30 -- bigger than the plain icon, so the ring's bezel isn't clipped

-- the left corner/edge pieces overhang the frame's own left edge, so the fill
-- and everything in it needs to start a little further right to sit inside the
-- border instead of showing a gap under it
local LEFT_NUDGE = 4

-- same idea at the bottom: without this, rows scroll out under the border
-- instead of stopping above it
local BOTTOM_NUDGE = 4

local function haveRingAtlas()
	return C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(RING) and true or false
end

-- Shorter than Modern's: the border needs less clearance than a plain flat
-- header does, and this is also what the window shrinks to when collapsed, so
-- it doubles as where the collapse mask below cuts the border off.
local HEADERHEIGHT = 23

-- "Grow to max height" can shrink the window down to just headerHeight, same
-- as collapsing it, but without the LookCollapse hiding to go with it: the
-- border ends up with the same corners-overlapping-themselves problem. Floor
-- it at a height tall enough for the full border to render without doing that.
local MINHEIGHT = 95

-- Collapsed, the window is only as tall as the titlebar, too short for the
-- rest of the border: the bottom corners end up overlapping the top ones. So
-- everything but the top row is hidden, rather than trying to squeeze it in.
local SIDES_AND_BOTTOM = {"BottomLeftCorner", "BottomRightCorner", "BottomEdge", "LeftEdge", "RightEdge"}
local TOP_ROW = {"TopLeftCorner", "TopRightCorner", "TopEdge"}

-- Even the top corners are taller than the collapsed window: they're drawn
-- above the frame's own top edge by design (so the border has something to
-- curve into when expanded), and that art runs on past the collapsed bottom
-- edge too. Clip it to a box tall enough to keep the intentional overhang
-- above the window but cut off there instead of continuing past the bottom.
local TOP_OVERHANG = 0

module.LookCollapse.Traditional = function(_, window, collapsed)
	local nineSlice = window.nineSlice
	if not nineSlice then return end

	for _, piece in ipairs(SIDES_AND_BOTTOM) do
		local region = nineSlice[piece]
		if region then
			region:SetShown(not collapsed)
		end
	end

	local mask = window.collapseMask
	if collapsed then
		mask:ClearAllPoints()
		mask:SetPoint("TOPLEFT", window, "TOPLEFT", 0, TOP_OVERHANG)
		mask:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT")
	end
	for _, piece in ipairs(TOP_ROW) do
		local region = nineSlice[piece]
		if region then
			if collapsed then
				region:AddMaskTexture(mask)
			else
				region:RemoveMaskTexture(mask)
			end
		end
	end
end

function module.Looks:Traditional(window)
	-- the nine-slice pieces are just a border; something has to fill behind
	-- them, but a solid tile would be heavier than this window needs
	window:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8X8]],
		insets = {left = 3 + LEFT_NUDGE, right = 3, top = 3, bottom = 3},
	})
	window:SetBackdropColor(0, 0, 0, 0.6)

	local layout = window.nineSlice and bestLayout()
	if layout then
		window.nineSlice.layoutType = layout
		window.nineSlice:OnLoad()
		window.nineSlice:Show()
	end

	-- the nine-slice border pieces are drawn OVERLAY; anything that should sit
	-- above them, rather than under, has to be OVERLAY too
	window.icon:SetDrawLayer("OVERLAY", 1)
	window.icon:ClearAllPoints()
	window.icon:SetSize(24, 24)
	window.icon:SetPoint("TOPLEFT", 2, -1)
	window.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	window.icon:AddMaskTexture(window.portraitMask)
	window.portraitMask:ClearAllPoints()
	window.portraitMask:SetPoint("TOPLEFT", window.icon, 1, -1)
	window.portraitMask:SetPoint("BOTTOMRIGHT", window.icon, -1, 1)

	if haveRingAtlas() then
		window.portraitRing:SetAtlas(RING)
		window.portraitRing:SetSize(RING_SIZE, RING_SIZE)
		window.portraitRing:ClearAllPoints()
		window.portraitRing:SetPoint("CENTER", window.icon, "CENTER")
		window.portraitRing:Show()
	else
		window.portraitRing:Hide()
	end

	window.title:SetDrawLayer("OVERLAY", 1)
	window.title:ClearAllPoints()
	window.title:SetPoint("TOPLEFT", 0, -6)
	window.title:SetPoint("TOPRIGHT", 0, -6)
	window.title:SetJustifyH("CENTER")

	window.collapseButton:ClearAllPoints()
	window.collapseButton:SetPoint("TOPRIGHT", window, "TOPRIGHT", unpack(window.closeDefault or {0, 0}))

	window.headerHeight = HEADERHEIGHT
	window.minHeight = MINHEIGHT
	window.container:ClearAllPoints()
	window.container:SetPoint("TOPLEFT", window, "TOPLEFT", LEFT_NUDGE, -window.headerHeight)
	window.container:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 0, BOTTOM_NUDGE)
end

module.LookReset.Traditional = function(_, window)
	if window.nineSlice then
		for _, piece in ipairs(TOP_ROW) do
			local region = window.nineSlice[piece]
			if region then
				region:RemoveMaskTexture(window.collapseMask)
			end
		end
		window.nineSlice:Hide()
	end
	window:SetBackdrop(nil)
	window.icon:RemoveMaskTexture(window.portraitMask)
	window.portraitRing:Hide()
end
