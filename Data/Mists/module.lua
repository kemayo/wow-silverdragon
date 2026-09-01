local myname, ns = ...

if LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_MISTS_OF_PANDARIA or math.huge) then
	ns.BeginDataModule(nil)
	return
end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

ns.BeginDataModule("Mists")

ns.riches = ns.nodeMaker{
	achievement=7997, -- Riches of Pandaria
	atlas="auctioneer",
	minimap=true,
}
ns.treasure = ns.nodeMaker{
	achievement=7284, -- Is Another Man's Treasure
	-- atlas="reagents",
	minimap=true,
}
ns.junk = ns.nodeMaker{
	group="junk",
	minimap=true,
	scale=0.9,
}
