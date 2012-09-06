local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Targets", "AceEvent-3.0")

function module:OnInitialize()
	core.RegisterCallback(self, "Scan")
end

local units_to_scan = {'targettarget', 'party1target', 'party2target', 'party3target', 'party4target', 'party5target'}
function module:Scan(callback, zone)
	if not (core.db.profile.targets and IsInGroup()) then
		return
	end
	for _, unit in ipairs(units_to_scan) do
		core:ProcessUnit(unit, 'grouptarget')
	end
end
