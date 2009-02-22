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
	local zone, x, y = core:GetPlayerLocation()

	tooltip = LibQTip:Acquire("SilverDragonTooltip", 5, "LEFT", "CENTER", "RIGHT", "RIGHT", "RIGHT")
	tooltip:AddHeader("Name", "Level", "Type", "Count", "Last Seen")
	
	local n = 0
	for name in pairs(core.db.global.mobs_byzone[zone]) do
		n = n + 1
		local num_locations, level, elite, creature_type, lastseen, count = core:GetMob(zone, name)
		tooltip:AddLine(name, ("%s%s"):format(level > 0 and level or '?', elite and '+' or ''), BCT[creature_type], count, core:FormatLastSeen(lastseen))
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

