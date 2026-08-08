local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Browser")

-- The history window's look: a compact, flat dark panel with a hairline border.

local ROW2 = 28 -- top of the search / dropdown / filter row

function module.Looks:Minimal(window)
	window.headerHeight = ROW2 + 22 + 6
	window.rowHeight = 22
	window.insetLeft, window.insetRight, window.insetBottom = 0, 0, 0

	window:SetBackdrop({
		edgeFile = [[Interface\Buttons\WHITE8X8]],
		bgFile = [[Interface\Buttons\WHITE8X8]],
		edgeSize = 1,
	})
	window:SetBackdropColor(0, 0, 0, 0.85)
	window:SetBackdropBorderColor(0, 0, 0, 0.5)

	window.icon:SetSize(20, 20)
	window.icon:ClearAllPoints()
	window.icon:SetPoint("TOPLEFT", 4, -4)
	window.icon:Show()

	window.title:SetFontObject("GameFontHighlight")
	window.title:ClearAllPoints()
	window.title:SetPoint("LEFT", window.icon, "RIGHT", 6, 0)
	window.title:SetPoint("RIGHT", window.close, "LEFT", -4, 0)

	window.close:ClearAllPoints()
	window.close:SetPoint("TOPRIGHT", 2, 2)

	-- Second row of the header: search over the nav, dropdown and filter right.
	-- All three share a top edge and a height, so they line up. The search width
	-- comes from Layout, which knows how wide the nav currently is.
	window.search:ClearAllPoints()
	window.search:SetPoint("TOPLEFT", 10, -ROW2)

	window.filter:ClearAllPoints()
	window.filter:SetPoint("TOPRIGHT", -6, -ROW2)

	window.grouping:ClearAllPoints()
	window.grouping:SetPoint("TOPRIGHT", window.filter, "TOPLEFT", -4, 0)

	window.splitter.texture:SetColorTexture(1, 1, 1, 0.08)

	window:Layout()
	window.search:SetWidth(math.max(80, module.NAV_WIDTH - 24))
end

module.LookReset.Minimal = function(_, window)
	window:SetBackdrop(nil)
end
