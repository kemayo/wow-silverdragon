local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

function module.Looks:StoreSilver(popup)
    self.Looks.Store(self, popup)
    popup.background:SetDesaturated(true)
    popup.modelhighlight:SetDesaturated(true)
end
