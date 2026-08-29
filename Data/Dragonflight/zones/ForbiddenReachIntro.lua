local myname, ns = ...

-- Dracthyr intro:

ns.RegisterPoints(ns.FORBIDDENREACHINTRO, {
	-- treasures
	[42113436] = { label="Bag of Enchanted Winds",
		quest=65909,
		loot={
			193840, -- Bag of Enchanted Winds,
		},
		spell=375497,
		note="{spell:369536:Soar}",
		vignette=5042,
	},
	[41842306] = { label="Eviscerated Argali",
		quest=67013,
		label="{npc:191992:Eviscerated Argali}",
		loot={
			194511,
		},
		spell=377087,
		vignette=5137,
	},
	[46212173] = { label="Abandoned Weapon Rack",
		quest=66965,
		label="Abandoned Weapon Rack",
		loot={
			194073, -- Distinguished Dracthyr's Implement
			194888, -- Dracthyr's Inscribed Blade
		},
		vignette=5128,
	},
	[35596967] = { label="Hessethiash's Poorly Hidden Treasure",
		quest=66876,
		label="Hessethiash's Poorly Hidden Treasure",
		loot={
			195885, -- Black Dragon's Scale Cloak
		},
		path=37995806,
		vignette=5117,
	},
	[30536442] = { label="Lost Draconic Hourglass",
		quest=66974,
		loot={
			194720, -- Lost Draconic Hourglass
		},
		spell=377781,
		vignette=5134,
	},
	[62184311] = { label="Suspicious Bottle",
		quest=65908,
		loot={
			195580, -- Suspicious Bottle
		},
		path=63384539,
		vignette=5041,
	},
	[14336057] = { label="A mailbox",
		-- ...I'm including this solely because it's the only way to send your new character anything before they reach their faction capital
		label=MINIMAP_TRACKING_MAILBOX,
		atlas="mailbox",
	},
	-- rares
	[32884100] = { label="Deathrip",
		quest=66966,
		npc=191729,
		loot={
			197725, -- Deathrip's Curled Claw
		},
		vignette=5129,
	},
	[28473653] = { label="Scytherin",
		quest=66967,
		npc=191713,
		loot={
			196435, -- Scytherin's Barbed Necklace
		},
		path=33553370,
		vignette=5130,
	},
	[56496548] = { label="Ketess the Pillager",
		quest=66975,
		npc=191746,
		loot={
			194741, -- Earthbound Tome
		},
		vignette=5133,
	},
	[79567443] = { label="Tazenrath",
		quest=66973,
		npc=182280,
		loot={
			194883, -- Runic Wing
		},
	},
	[56004437] = { label="Stormspine",
		quest=64859,
		npc=181427,
		loot={
			194084, -- Charged Storm Crystal
		},
		spell=376238,
		vignette=4904,
	},
	[71233781] = { label="Shimmermaw",
		quest=64971,
		npc=181833,
		loot={
			--194074, -- Gilded Key
			--194037, -- Heavy Chest
			194035, -- Glittering Diamonds
			194036, -- Exquisite Necklace
			194038, -- Gilded Blade
			194071, -- Gold Ring
			194072, -- Sack of Gold
		},
		vignette=4906,
	},
})

ns.RegisterPoints(2109, { -- War Creche
	[38127448] = {
		quest=66010,
		spell=375607,
		loot={
			193861, -- Blue Magic Wand
		},
	},
})
