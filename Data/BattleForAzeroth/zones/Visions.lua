local myname, ns = ...

local ORGRIMMAR = 1469
local STORMWIND = 1470

-- Mail Muncher
local mail = {
	npc=160708,
	loot={
		{174653, mount=1315},
	},
	atlas="mailbox",
	minimap=true,
	group="Visions",
}
ns.RegisterPoints(STORMWIND, {
	[50208660] = {},
	[55005700] = {},
	[61807560] = {},
	[62103200] = {},
	[75606420] = {},
}, mail)
ns.RegisterPoints(ORGRIMMAR, {
	[39604840] = {},
	[40007840] = {},
	[52607600] = {},
	[60005180] = {},
	[67803920] = {},
}, mail)

-- Toys
ns.RegisterPoints(STORMWIND, {
	[58905290] = {
		loot={{174921, toy=true}}, -- Void-Touched Skull
	},
}, {
	group="Visions",
	minimap=true,
})
ns.RegisterPoints(ORGRIMMAR, {
	[40706030] = {
		loot={{174920, toy=true}}, -- Coifcurl's Close Shave Kit
	},
}, {
	minimap=true,
	group="Visions",
})

-- Black Empire Cache
-- local cache = {
-- 	label="Dark Coffer"
-- 	minimap=true,
-- 	group="Visions",
-- }
-- ns.RegisterPoints(STORMWIND, {
-- }, cache)

-- Odd Crystals
local odd = {
	label="Odd Crystal",
	atlas="MantidTower",
	minimap=true,
	group="Visions",
	note="Possible location",
}
ns.RegisterPoints(STORMWIND, {
	-- Cathedral Square
	[54605940] = {},
	[53005190] = {},
	[58405510] = {},
	-- Dwarven District
	[64603090] = {},
	[62703700] = {},
	[63404170] = {},
	[67304470] = {},
	-- Trade District
	[69007310] = {},
	[62007690] = {},
	[66107570] = {},
	[60406880] = {},
	-- Old Town
	[75605340] = {},
	[75606460] = {},
	[74605920] = {},
	[76506850] = {},
	-- Mage Quarter
	[47408160] = {},
	[44208790] = {},
	[47708940] = {},
	[52408340] = {},
}, odd)
ns.RegisterPoints(ORGRIMMAR, {
	-- Valley of Strength
	[53508200] = {},
	[49406870] = {},
	[48708380] = {},
	-- The Drag
	[57706510] = {},
	[57605860] = {},
	[60405510] = {},
	[57904860] = {},
	-- Valley of Spirits
	[33406570] = {},
	[35406940] = {},
	[37908450] = {},
	[38508070] = {},
	-- Valley of Honor
	[65805060] = {},
	[68204290] = {},
	[67003740] = {},
	[63903040] = {},
	-- Valley of Wisdom
	[38904990] = {},
	[41704480] = {},
	[48404410] = {},
	[51004520] = {},
}, odd)
