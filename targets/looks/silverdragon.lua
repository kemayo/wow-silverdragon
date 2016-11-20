local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

function module.Looks:SilverDragon(popup)
	-- The "zomg legendary, but a bit more silver" look
	self.Looks.Legendary(self, popup)
	popup.background:SetDesaturated(true)
end
