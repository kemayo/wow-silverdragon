local myname, ns = ...

-- During Abyss Anglers: 89044 is complete
-- Zul'jan's rant during Broken Bridges: 92108

--[[ TODO:
A Most Violent Loa: 62267
]]

local AMANI = ns.rewards.Currency(ns.CURRENCY_AMANI, 50)

ns.RegisterPoints(ns.ZULAMAN, {
	[46838186] = { label="Honored Warrior's Cache",
		criteria=111855, quest=90793, -- 93560 for interacting with the cache
		loot={{257223, mount=true}}, -- Ancestral War Bear
		note="Fetch the four tokens",
		related={
			[32698350] = {label="{npc:255171:Nalorakk's Chosen}", loot={259219}, inbag=259219}, -- Bear Tooth
			[54782239] = {label="{npc:255233:Jan'alai's Chosen}", loot={259220}, inbag=259220}, -- Dragonhawk Feather
			[51588492] = {label="{npc:255231:Akil'zon's Chosen}", loot={259221}, inbag=259221}, -- Eagle Talon
			[34553346] = {label="{npc:255232:Halazzi's Chosen}", loot={259223}, inbag=259223}, -- Lynx Claw
			hide_before=ns.conditions.QuestComplete(93560), -- interacted with the cache for the first time
			note="Use the Honored Warrior's Urn",
			minimap=true,
		},
		vignette=6937,
		atlas="VignetteLootElite", scale=1.3,
	},
	[21897738] = { label="Sealed Twilight Blade Bounty",
		criteria=111856, quest=93871,
		loot={{265362, quest=94570}}, -- Arsenal: Twilight Blade
		note="Solve the {spell:1270357:Sealing Orb} puzzle in each of the nearby towers",
		related={
			[26098074] = {quest=93916, label="{spell:1270357:Sealing Orb}"},
			[23957895] = {quest=93917, label="{spell:1270357:Sealing Orb}"},
			[24027566] = {quest=93918, label="{spell:1270357:Sealing Orb}"},
			[26097401] = {quest=93919, label="{spell:1270357:Sealing Orb}"},
			color={r=0.5,g=0,b=1}, minimap=true,
		},
		vignette=7419,
		atlas="VignetteLootElite", scale=1.3,
	},
	[20846654] = { label="Bait and Tackle",
		criteria=111857, quest=90795,
		loot={
			255157, -- Abyss Angler's Fish Log
			241145, -- Lucky Loa Lure
			255688, -- Achor of the Abyss
		},
		vignette=6939,
	},
	[41994778] = {criteria=111858, quest=90796, loot={254749}, vignette=6940}, -- Burrow Bounty, Phial of Burrow Balm
	[52336599] = {criteria=111859, quest=90797, loot={255428}, vignette=6941}, -- Mrruk's Mangy Trove, Tolbani's Medicine Satchel
	[40483596] = {criteria=111860, quest=90798, loot={256326}, vignette=6942}, -- Secret Formula, Fetid Dartfrog Idol
	[42645244] = {criteria=111861, quest=90799, loot={{255008, pet=4906}}, vignette=6943, note="Atop the tree"}, -- Abandoned Nest, Weathered Eagle Egg
}, {
	achievement=62125,
})

ns.RegisterPoints(ns.ZULAMAN, {
	-- This was removed from the treasures achievement around 20260305:
	[44724410] = { label="Abandoned Ritual Skull, Hexed Vilefeather Eagle",
		-- criteria=111854,
		label="Abandoned Ritual Skull",
		quest=90794,
		loot={{257444, mount=true}},
		vignette=6938,
		note="In cave on the lower level; gather 1000x{item:259361:Vile Essence} nearby",
		atlas="VignetteLootElite", scale=1.3,
	},
})

-- ns.RegisterPoints(ns.ATALAMAN, {})

-- ns.RegisterPoints(ns.ZULAMAN, {
-- 	-- TODO: this wasn't interactable when I went by on 12/24, so need to check what's in it
-- 	[44325620] = { -- Ruz'avalt's Prized Tackle
-- 		label="Ruz'avalt's Prized Tackle",
-- 		quest=90790,
-- 		vignette=6934,
-- 	},
-- })

-- Spiritpaw Marathon
ns.RegisterPoints(ns.ZULAMAN, {
	[32292239] = {
		achievement=62202,
		note="Talk to {npc:258938:Feeva}, then pick up {npc:261115:Kapara Pup}. With {spell:1285642:Escorting Kapara Pup}, run to {area:16204:Shrine of Filo}. {gc:red:You cannot mount up}.",
		texture=ns.atlas_texture("WildBattlePetCapturable", {r=0.8,g=0,b=1}),
		minimap=true,
		path={
			32282239, 32572344, 32652387, 32932442, 32882488, 33152497, 33992603, 35542652, 38903019, 39323142, 40273265, 41903311, 43303282, 44503333, 44893368, 45363365, 46363472, 48783528, 49933455, 50423397, 50873380, 51363293,
			r=0.8, g=0, b=1,
			atlas="Vehicle-TempleofKotmogu-GreenBall", label="Destination",
		},
	},
})

-- Shadowpine Scattered
ns.RegisterPoints(ns.ZULAMAN, {
	[52687933] = {criteria=109749, label="{npc:254808:Songseeker Baz'wa}", requires=ns.conditions.Achievement(41803)}, -- Temple's only restored after [For Zul'Aman!]
	[47328190] = {criteria=109750, label="{npc:254807:Songseeker Far'lan}"},
	[31624653] = {
		criteria=109751, label="{npc:254840:Songseeker Jebanda}",
		routes={{31624653, 33074390, 33204354, 33184061, 33214041, 33184004, 33023952, 32943936, 32613903, 32493896, 32363893, 32293875, 31973841, 31893824, 31763817, 31623813}},
	},
	[39175638] = {criteria=109752, label="{npc:254839:Songseeker Dova}", translate={[ns.ATALAMAN]=true}},
	[55031798] = {criteria=109753, label="{npc:254841:Songseeker Ikaja}"},
}, {
	achievement=61455,
	texture=ns.atlas_texture("AncientMana", {r=0, g=0, b=1}),
	minimap=true,
})

-- The Frog and the Princesses
local FROG = {
	achievement=62201,
	texture=ns.atlas_texture("AncientMana", {r=0, g=1, b=0}),
	minimap=true,
	note=EMOTE59_CMD1,
}
ns.RegisterPoints(ns.ZULAMAN, {
	[31702263] = {criteria=112041, label="{npc:258937:Princess Fita}"},
	[68281931] = {criteria=112445, label="{npc:259684:Princess Gabiku}"},
	[53945957] = {criteria=112447, label="{npc:259683:Princess Tafiki}"},
	[29827915] = {criteria=112448, label="{npc:259685:Princess Zambina}"},
}, FROG)
ns.RegisterPoints(ns.ATALAMAN, {
	[27514003] = {criteria=112446, label="{npc:259682:Princess Jakobu}", parent=true},
}, FROG)

-- Put a Pin in It
ns.RegisterPoints(ns.ZULAMAN, {
	[59247107] = {
		quest=95005,
		label="{npc:258933:Chu'ke}",
		note="Talk, then go to {npc:258884:Kalika} in {area:16186:Temple of Halazzi}",
	},
	[38662378] = {
		quest=95045,
		label="{npc:258884:Kalika}",
		hide_before=ns.conditions.QuestComplete(95005),
		note="Talk, pick up the Forgotten Button she points out, then go to {npc:258933:Chu'ke} in {area:16196:Funerary Coast}",
	},
	[37809011] = {
		quest=95046,
		label="{npc:258933:Chu'ke}",
		hide_before=ns.conditions.QuestComplete(95045),
		note="Give him the button. It'll be fine.",
	},
}, {
	achievement=62199,
	atlas="BuildanAbomination-32x32",
})

-- Gnome Alone
ns.RegisterPoints(ns.ZULAMAN, {
	[54873240] = {criteria=112039, --[[object=258936,]]}, -- Message in a Bottle
	[46364135] = {criteria=112845, --[[object=260878,]] note="Behind the hut"}, -- Hastily-Scribbled Note
	[54312061] = {criteria=112846, --[[object=260879,]] note="Behind the pillar"}, -- Scrap of Singed Paper
	[35682520] = {criteria=112844, --[[object=260880,]] note="Under the hammock"}, -- Moldy Diary Found
	[45906599] = {criteria=112847, --[[object=260881,]] note="Under the building"}, -- Discarded Scroll
	[34791716] = {criteria=112848, --[[object=260882,]]}, -- Parting Note
}, {
	achievement=62200,
	atlas="poi-workorders",
	minimap=true,
})

-- Rares

local loot_shared = {
	251783, -- Lost Idol of the Hash'ey
	251784, -- Sylvan Wakrapuku
	265543, -- Tempered Amani Spearhead
	265554, -- Reinforced Amani Haft
	265560, -- Toughened Amani Leather Wrap
	265562, -- Combine into: Amani Warrior's Spear
	{257152, mount=true}, -- Amani Sharptalon
	{257200, mount=true}, -- Escaped Witherbark Pango
}

-- Tallest Tree in the Forest
ns.RegisterPoints(ns.ZULAMAN, {
	[34393304] = { label="Necrohexxer Raz'ka",
		criteria=111839, quest=89569,
		npc=242023,
		loot={
			264527, -- Vile Hexxer's Mantle
			264611, -- Pendant of Siphoned Vitality
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94683}),
		},
		vignette=6895,
	},
	[51881875] = { label="The Snapping Scourge",
		criteria=111840, quest=89570,
		npc=242024,
		loot={
			264585, -- Snapper Steppers
			264617, -- Scourge's Spike
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94697}),
		},
		vignette=6896,
	},
	[51847292] = { label="Skullcrusher Harak",
		criteria=111841, quest=89571,
		npc=242025,
		loot={
			264542, -- Skullcrusher's Mantle
			264631, -- Harak's Skullcutter
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94698}),
		},
		vignette=6897,
	},
	[28832450] = { label="Lightwood Borer",
		criteria=111842, quest=89575,
		npc=242028,
		loot={
			264557, -- Borerplate Pauldrons
			264640, -- Sharpened Borer Claw
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94699}),
		},
		vignette=6900,
	},
	[50866517] = { label="Mrrlokk",
		criteria=111843, quest=91174,
		npc=245975,
		loot={
			264570, -- Reinforced Chainmrrl
			264580, -- Mrrlokk's Mrgl Grrdle
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94700}),
		},
		vignette=6977,
	},
	[30574456] = { label="Spinefrill",
		criteria=111845, quest=89578,
		npc=242031,
		loot={
			264554, -- Frilly Leather Vest
			264620, -- Pufferspine Spellpierce
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94702}),
		},
		vignette=6903,
	},
	[46555127] = { label="Oophaga",
		criteria=111846, quest=89579,
		npc=242032,
		loot={
			264528, -- Goop-Coated Leggings
			264541, -- Egg-Swaddling Sash
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94703}),
		},
		vignette=6904,
	},
	[47763435] = { label="Tiny Vermin",
		criteria=111847, quest=89580,
		npc=242033,
		loot={
			264648, -- Verminscale Gavel
			264597, -- Leechtooth Band
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94704}),
		},
		vignette=6905,
	},
	[21547051] = { label="Voidtouched Crustacean",
		criteria=111848, quest=89581,
		npc=242034,
		loot={
			264564, -- Crab Wrangling Harness
			264586, -- Crustacean Carapace Chestguard
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94705}),
		},
		vignette=6906,
	},
	[39592097] = { label="The Devouring Invader",
		criteria=111849, quest=89583,
		npc=242035,
		loot={
			264559, -- Devourer's Visage
			264638, -- Fangs of the Invader
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94706}),
		},
		note="In cave at the bottom of the chasm",
		vignette=6907,
	},
	[33688897] = { label="Elder Oaktalon",
		criteria=111850, quest=89572,
		npc=242026,
		loot={
			264547, -- Worn Furbolg Bindings
			264529, -- Cover of the Furbolg Elder
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94707}),
		},
		vignette=6898,
	},
	[47662052] = { label="Depthborn Eelamental",
		criteria=111851, quest=89573,
		npc=242027,
		loot={
			264598, -- Eelectrum Signet
			264618, -- Strangely Eelastic Blade
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94708}),
		},
		vignette=6899,
	},
	[46394339] = { label="The Decaying Diamondback",
		criteria=111852, quest=91072,
		npc=245691,
		loot={
			264525, -- Wrapped Antenna Cuffs
			264582, -- Diamondback-Scale Legguards
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94709}),
		},
		vignette=6971,
	},
	[45284171] = { label="Ash'an the Empowered",
		criteria=111853, quest=91073,
		npc=245692,
		loot={
			264593, -- Warcloak of the Butcher
			264643, -- Ash'an's Spare Cleaver
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94710}),
		},
		vignette=6972,
	},
}, {
	achievement=62122,
	loot_shared=loot_shared,
})

ns.RegisterPoints(ns.ATALAMAN, {
	[81982200] = { label="Poacher Rav'ik",
		criteria=111844, quest=91634,
		npc=247976,
		loot={
			264627, -- Rav'ik's Spare Hunting Spear
			264911, -- Forest Hunter's Arc
			ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94701}),
		},
		vignette=7117,
		note="Walk into the trap",
	},
}, {
	achievement=62122,
	parent=true,
	loot_shared=loot_shared,
})
