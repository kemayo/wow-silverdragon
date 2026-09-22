local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("History")

local HEADERHEIGHT = 28

-- A flat, dark panel with a hairline border. The look SilverDragon has always had.
function module.Looks:Modern(window)
	window:SetBackdrop({
		edgeFile = [[Interface\Buttons\WHITE8X8]],
		bgFile = [[Interface\Buttons\WHITE8X8]],
		edgeSize = 1,
	})
	window:SetBackdropColor(0, 0, 0, .5)
	window:SetBackdropBorderColor(0, 0, 0, .5)

	window.icon:RemoveMaskTexture(window.portraitMask)
	window.icon:SetDrawLayer("ARTWORK")
	window.icon:ClearAllPoints()
	window.icon:SetSize(24, 24)
	window.icon:SetPoint("TOPLEFT", 2, -2)
	window.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	window.portraitRing:Hide()

	window.title:SetDrawLayer("ARTWORK")
	window.title:ClearAllPoints()
	window.title:SetPoint("TOPLEFT", 0, -8)
	window.title:SetPoint("TOPRIGHT", 0, -8)
	window.title:SetJustifyH("CENTER")

	window.collapseButton:SetPoint("TOPRIGHT", window, "TOPRIGHT", -2, -2)

	window.headerHeight = HEADERHEIGHT
	window.minHeight = HEADERHEIGHT
	window.container:ClearAllPoints()
	window.container:SetPoint("TOPLEFT", window, "TOPLEFT", 0, -window.headerHeight)
	window.container:SetPoint("BOTTOMRIGHT", window)
end

module.LookReset.Modern = function(_, window)
	window:SetBackdrop(nil)
end
