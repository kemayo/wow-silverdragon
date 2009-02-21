
local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Announce", "LibSink-2.0")

function module:Seen(callback, zone, name, x, y, dead)
	self:Pour(("Rare seen: %s%s"):format(name, dead and "... but it's dead" or ''))
end
core.RegisterCallback(module, "Seen")

