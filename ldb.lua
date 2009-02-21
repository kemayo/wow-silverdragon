local BZR = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()
local BCT = LibStub("LibBabble-CreatureType-3.0"):GetUnstrictLookupTable()
local BCTR = LibStub("LibBabble-CreatureType-3.0"):GetReverseLookupTable()

local LibQTip = LibStub("LibQTip-1.0")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

local dataobject = LibStub("LibDataBroker-1.1"):NewDataObject("SilverDragon", {
	type = "data source",
	icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01",
	label = "Rares",
	text = "None",
})

local tooltip
function dataobject:OnEnter()
	local zone, subzone = GetRealZoneText(), GetSubZoneText()

	tooltip = LibQTip:Acquire("SilverDragonTooltip", 3, "LEFT", "CENTER", "RIGHT")
	tooltip:AddHeader("Name", "Level", "Last Seen")
	
	local n = 0
	for name, mob in pairs(core.db.profile.mobs[BZR[zone]]) do
		n = n + 1
		tooltip:AddLine(name, ("%s%s"):format(mob.level > 0 and mob.level or '?', mob.elite and '+' or ''), core:FormatLastSeen(mob.lastseen))
	end
	if n == 0 then
		tooltip:AddLine("None")
	end

	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end

function dataobject:OnLeave()
	LibQTip:Release(tooltip)
	tooltip = nil
end

core.RegisterCallback("LDB", "Seen", function(callback, zone, name)
	dataobject.text = name
end)

