local BCTR = LibStub("LibBabble-CreatureType-3.0"):GetReverseLookupTable()

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Data")

function module:OnInitialize()
	core:RegisterMobData("All", module:GetDefaults())
end
