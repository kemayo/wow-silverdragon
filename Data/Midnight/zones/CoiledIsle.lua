local myname, ns = ...

--[[
TODO:
63382 It's Definitely Something
--]]

local ZULJARRA = ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50)

-- Treasures

ns.RegisterPoints(ns.COILEDISLE, {
	[71886666] = { label="Amani Privateer's Cache",
		criteria=115289, quest=94569,
		loot={
			{279054, toy=true}, -- Idol of Blue Water and Blue Sky
			ZULJARRA
		},
		note="Fish up a {item:265525:Grisly Morsel}, give it to the {npc:258076:Hungry Dolphin}, find the two halves of the key and make the {item:265602:Amani Privateer's Key}",
		related={
			[73426614] = {label="Grisly Cod Pool", atlas="Professions_Tracking_Fish_Special", loot={265525}},
			[72516723] = {label="{npc:258076:Hungry Dolphin}", note="Give the {item:265525:Grisly Morsel}", hide_before=ns.conditions.Item(265525)},
			[72416841] = {label="Broken Urn", loot={265603}, hide_before=ns.conditions.AuraActive(1275730)},
			[73096698] = {label="Waterlogged Crate", loot={265610}, hide_before=ns.conditions.AuraActive(1275730)},
			minimap=true, worldmap=false,
		},
		vignette=7480, -- Privateer's Cache
		atlas="VignetteLootElite", scale=1.3,
	},
	[45916628] = {criteria=115313, quest=95938, loot={281571, ZULJARRA}, vignette=7604}, -- Fangbound Sack, Focus of Fangs
	[65440560] = { label="Sunken Diver's Chest",
		criteria=115290, quest=95907,
		loot={
			{279052, toy=true}, -- Ancient Amani Mask
			ZULJARRA,
		},
		note="Kill nearby {npc:263081:Glittering Grouper Brintail} for {item:271424:Diver's Key Fragment}x3",
		vignette=7599,
		atlas="VignetteLootElite", scale=1.3,
	},
	[67264846] = { label="Grave of Someone Forgotten",
		criteria=115291, quest=95956,
		loot={
			{279021, toy=true}, -- Forgotten Memento
			ZULJARRA
		},
		note="Read the Nameless Grave, find other nearby ghosts that you can ask about the name, return to the grave",
		related={
			-- extreme lack of helpful quest progression here; they just stand up and walk away
			[69045270] = {label="{npc:263241:Zuzan}"},
			[70425839] = {label="{npc:263242:Zan'ja}"},
			[66425725] = {label="{npc:263243:Ru'ko}"},
			minimap=true, worldmap=true,
		},
		vignette=7608,
		atlas="VignetteLootElite", scale=1.3,
	},
	[43646738] = { label="Profane Ritual Spoils (Ritual Chest)",
		criteria=115292, quest=95941,
		loot={
			281567, -- Profane Ritual Staff
			ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 250),
			ZULJARRA,
		},
		note="Use {npc:263202:Mysterious Trinket}: upper right, upper left, bottom right, bottom left",
		vignette=7607, -- Ritual Chest
		atlas="VignetteLootElite", scale=1.3,
	},
	[70637663] = { label="Brine-Crusted Chest",
		criteria=115294, quest=95995, -- 96001 pearl dropped, 96002 key dropped
		loot={{274921, toy=true}, ZULJARRA}, -- Pearl of Jubilation
		note="Find a Bubbling Clam underwater outside the cave; bring a {item:271815:Luminescent Pearl} and put it down for {npc:263347:Nacretta}; take the {item:271881:Dropped Key}; open the chest",
		vignette=7627, -- Ancient Amani Chest
		atlas="VignetteLootElite", scale=1.3,
	},
	[31438349] = {criteria=115295, quest=96985, loot={279051, ZULJARRA}, vignette=7743}, -- Possessed Vase
	[75376833] = {criteria=115306, quest=95164, loot={{268504, toy=true}, ZULJARRA}, vignette=7532}, -- Malfunctioning Staff
	[55213796] = {criteria=115307, quest=95563, loot={275920, ZULJARRA}, vignette=7559}, -- Tarnished Amani Glaive
	[60435946] = {criteria=115309, quest=95566, loot={{277954, toy=true}, ZULJARRA}, vignette=7560}, -- Jaktu's Cursed Blade
	[68056590] = { label="Lost Spirit (A Mysterious Urn, then the spirit)",
		criteria=115310, quest=95571, -- 95574 after giving trinket
		loot={
			274493, -- Effigy of Ula'tek's Faithful
			{244345, decor=true}, -- Forgotten Amani Urn
			ZULJARRA,
		},
		vignette={7696, 7561}, -- Lost Spirit, Mysterious Urn
		related={
			[70226447] = {label="{item:269935:Forgotten Trinket}", note="Bring to the Lost Spirit", minimap=true},
		},
	},
	[58144355] = {criteria=115312, quest=95594, loot={278031, ZULJARRA}, vignette=7563}, -- Cracked Skull, Cracked Amani Skull
	[44862957] = {criteria=115296, quest=95596, loot={278032, ZULJARRA}, vignette=7564}, -- Damaged Loa Trinket
	[64723664] = {criteria=115298, quest=95835, loot={279011, {271175, decor=true}, ZULJARRA}, vignette=7587}, -- Venomjade Necklace (both of them)
	[66952803] = {criteria=115299, quest=95836, loot={278035, ZULJARRA}, vignette=7589}, -- Ornate Bottle, Ornate Healing Potion (Potent x5)
	[53094310] = { label="Stinking Vessel",
		criteria=115300, quest=95841,
		loot={
			{281580, decor=true}, -- Pungent Atal'Utek Shroom
			ns.rewards.Item(260290, 5), -- Quel'Thalas Cheese
			ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 100),
			ZULJARRA,
		},
		vignette=7590, -- Intact Vase
	},
	[49483198] = { label="Waterlogged Basket",
		criteria=115301, quest=95854,
		loot={
			281569, -- Quiver of the Drowned Marksman
			ns.rewards.Item(258138, 5), -- Potent Healing Potion
			ZULJARRA,
		},
		vignette=7591,
	},
	[29546723] = {criteria=115302, quest=95855, loot={281570, ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 100), ZULJARRA}, vignette=7592}, -- Smoldering Incense, Amani Incense Stick
	[73485654] = { label="Crumbling Urn",
		criteria=115308, quest=95558,
		loot={
			{281582, decor=true}, -- Atal'Utek Ivy
			269861, -- A Tattered Amani Scroll
			269868, -- Miniature Hand-Crafted Mask
			ZULJARRA,
		},
		vignette=7557, -- Broken Amani Urn
	},
	[64917889] = {criteria=115314, quest=95591, loot={278003, ZULJARRA}, vignette=7562}, -- Forgotten Mask
	[58194572] = { label="Vul'zahn's Smuggled Treasure",
		criteria=115293, quest=95976,
		loot={
			281568, -- Vul'zahn's Smuggled Spear
			ns.rewards.Item(258138, 10), -- Potent Healing Potion
			ZULJARRA
		},
		note="{npc:263265:Vul'zahn} wants food; get medicine from {npc:253837:Apothecary Dezi}, give to {npc:262204:Witherbark Cook}, bring food back",
		related={
			[57204846] = {label="{npc:253837:Apothecary Dezi}", loot={271791}}, -- Potion of Headache Relief
			[58004880] = {label="{npc:262204:Witherbark Cook}", loot={271788}, hide_before=ns.conditions.Item(271791)}, -- Snuffling Boar Stew
			minimap=true, worldmap=true,
		},
		vignette=7610,
		atlas="VignetteLootElite", scale=1.3,
	},
	[43952649] = {criteria=115297, quest=95727, loot={281566, ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 150), ZULJARRA}, vignette=7577}, -- Zul'jan's Stash, Amani Warrior's Cleaver
}, {
	achievement=63359, -- Treasures of the Coiled Isle
})

ns.RegisterPoints(ns.COILEDISLE, {
	[51644978] = {
		label="{npc:257598:Second Mate Sluggs}",
		loot={
			281022, -- Eerie Lure
			{275653, mount=true, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 5)}, -- Sea-Dwelling Isle Serpent
			{274796, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 5)}, -- Envenomed Deathblade
			{274814, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 5)}, -- Envenomed Game Ripper
			{274802, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 5)}, -- Envenomed Gavel
			-- 262792, -- Shredded Bloomline
			-- 262797, -- Shredded Glimmerline
			{275012, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 4)}, -- Recipe: Tokka's Multi-Ward
			{275020, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 4)}, -- Venom Elemental
			{271891, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 3)}, -- Recipe: Alluring Nostrum
			{275318, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 3)}, -- Schematic: Proudmoore Ship-in-a-Bottle
			{275336, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 3)}, -- Pattern: Mounted Moby
			{275693, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 3)}, -- Design: Opalescent Amani Peridot
			{275018, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 3)}, -- Recipe: Coiled Stargorger Lure
			{278332, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 2)}, -- Recipe: Puffer Plate
			{275301, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 4)}, -- Recipe: Feast of Knowledge
			{278391, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 4)}, -- Eerie Bauble
			{277923, decor=true, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 2)}, -- Aged Tortollan Scroll Case
			{277931, decor=true, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 3)}, -- Hanging Yellowed Kelp
			{277927, decor=true, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 2)}, -- Yellowed Kelp Pile
			{277929, decor=true, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 4)}, -- Rustic Fishing Rack
			{277925, decor=true, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 4)}, -- Blue Tortollan Signpost
			{277921, decor=true, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 5)}, -- Traditional Tortollan Tent
			{244790, requires=ns.conditions.Faction(ns.FACTION_CAPTAIN_TOKKA, 5)}, -- The Coiled Huntress
		},
	},
}, {
	texture=ns.atlas_texture("Banker", {r=0.2, g=1, b=1}), scale=1.2,
	minimap=true,
	note="Quartermaster",
	showallloot=true,
})

-- Mysterious Mix Master
ns.RegisterPoints(ns.COILEDISLE, {
	[57404860] = {
		achievement=63432,
		note=function()
			local function done(c)
				return select(3, ns.GetCriteria(63432, c)) and "{a:common-icon-checkmark}" or "{a:common-icon-redx}"
			end
			local PEARL = "{item:276117:Clouded Blood-Pearl}"
			local KNUCKLEBONE = "{item:276124:Ancient Knucklebone}"
			local FEATHER = "{item:276126:Serpent's Feather}"
			return "Create the following:\n" ..
				done(115810).." {item:277946:Choleric Offering}: 3x"..PEARL.."\n"..
				done(115811).." {item:277938:Virulent Offering}: 1x"..FEATHER.." 2x"..PEARL.."\n"..
				done(115812).." {item:277939:Volatile Offering}: 1x"..KNUCKLEBONE.." 2x"..PEARL.."\n"..
				done(115815).." {item:277944:Phlegmatic Offering}: 3x"..FEATHER.."\n"..
				done(115814).." {item:277942:Odious Offering}: 2x"..FEATHER.." 1x"..PEARL.."\n"..
				done(115816).." {item:277943:Pestilent Offering}: 1x"..KNUCKLEBONE.." 2x"..FEATHER.."\n"..
				done(115819).." {item:277945:Melancholic Offering}: 3x"..KNUCKLEBONE.."\n"..
				done(115817).." {item:277940:Fragile Offering}: 2x"..KNUCKLEBONE.." 1x"..PEARL.."\n"..
				done(115818).." {item:277941:Eerie Offering}: 2x"..KNUCKLEBONE.." 1x"..FEATHER.."\n"..
				done(115813).." {item:277937:Balanced Offering}: 1x"..KNUCKLEBONE.." 1x"..FEATHER.." 1x"..PEARL
		end,
		hide_before={
			ns.conditions.MajorFaction(ns.FACTION_ZULJARRA, 3),
			ns.conditions.Trait(1191, 110460), -- Ofi's Offerings
			ns.conditions.QuestComplete(97026), -- Esoteric Ingredients
			-- ns.conditions.QuestLineCompleteByQuest(93393, ns.COILEDISLE), -- Strange Friends in Odd Places, via A Little Kindness?
		},
		atlas="BuildanAbomination-32x32", scale=1.1,
	},
})

-- Rares

local loot_shared = {
	{276549, mount=true}, -- Topaz Skyfang
	{276803, mount=true}, -- Ruby Writhe
	-- weapons
	276042, -- Templetusk Shield
	276043, -- Vilefang Censer
	276044, -- Loa-Infused Battlestaff
	276045, -- Trailblazing Soulblade
	276046, -- Superclutch Smasher
	276047, -- Swamp Whomper
	276048, -- Vipersbane Dagger
	276049, -- Snakeslayer's Claymore
	276052, -- Venomshot Greatbow
	276054, -- Serpentvine Machete
	276055, -- Soulweaver's Curseblade
	276057, -- Cryptbound Scepter
	276058, -- Ruinous Slitherslicer
	276059, -- Headhunter's Hacker
	276060, -- Hexxer's Blastin' Rod
	276061, -- Witch Doctor's Bloodletter
	276062, -- Hydra Neckchopper
	-- plate
	276000, -- Stonehide Vambraces
	276004, -- Stonehide Sabatons
	276008, -- Stonehide Gauntlets
	276012, -- Stonehide Chestguard
	276016, -- Stonehide Casque
	276020, -- Stonehide Pauldrons
	276024, -- Stonehide Greaves
	276028, -- Stonehide Girdle
	276041, -- Stonehide Cape
	-- mail
	276001, -- Skytalon Armguards
	276005, -- Skytalon Treads
	276009, -- Skytalon Gloves
	276013, -- Skytalon Hauberk
	276017, -- Skytalon Helmet
	276021, -- Skytalon Spaulders
	276025, -- Skytalon Breeches
	276029, -- Skytalon Belt
	276038, -- Skytalon Cloak
	-- leather
	276002, -- Shadowclaw Wristguards
	276006, -- Shadowclaw Footpads
	276010, -- Shadowclaw Handguards
	276014, -- Shadowclaw Jerkin
	276018, -- Shadowclaw Headdress
	276022, -- Shadowclaw Shoulderpads
	276026, -- Shadowclaw Legguards
	276030, -- Shadowclaw Sash
	276040, -- Shadowclaw Shroud
	-- cloth
	276003, -- Flamebeak Bracers
	276007, -- Flamebeak Sandals
	276011, -- Flamebeak Grips
	276015, -- Flamebeak Robes
	276019, -- Flamebeak Crown
	276023, -- Flamebeak Mantle
	276027, -- Flamebeak Leggings
	276031, -- Flamebeak Cord
	276039, -- Flamebeak Drape
	-- jewelery
	-- 276032, -- Bad Juju Necklace
	-- 276033, -- Loa Watcher's Pendant
	-- 276034, -- Entangling Brood Ring
	-- 276035, -- Soulcoiler's Signet
	-- 276036, -- Ever-Constricting Band
	-- 276037, -- Counter-Curse Circlet
	-- trinkets
	-- 274494, -- Chiral Marrowgrafter
	-- 274495, -- Pulse Seeker's Oculus
	-- 274496, -- Ophidian Bone Whistle
	-- 274497, -- Spirit-Rending Poison
	-- 274498, -- Spirit Ward
	-- 274499, -- Toxiferous Transfusion
	-- 276043, -- Vilefang Censer
	-- 280047, -- Feathered Bell
	-- 280091, -- Latent Purifier
	-- 280123, -- Sharp Axe Holster
	-- 280376, -- Shadow Shard Sliver
	-- 280377, -- Breath of Jan'alai
}

-- Coiled to Strike
ns.RegisterPoints(ns.COILEDISLE, {
	[53777203] = { label="Farthik the Plunderer",
		criteria=115279, quest=96491,
		npc=264854,
		loot={
			280692, -- Plunderer's Pummeler
			280717, -- Farthik's Precious Pendant
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98344}),
		},
		vignette=7694,
		note="Unguarded...",
	},
	[50006907] = { label="Siltmouth",
		criteria=115280, quest=97112,
		npc=268049,
		loot={
			280704, -- Siltmouth's Venom Waders
			280718, -- Unflappable Flapping Cape
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98345}),
			-- 276051, -- Fangmouth Warspear
		},
		vignette=7756,
	},
	[24897354] = { label="Kari'zah the Forgotten",
		criteria=115784, quest=97122,
		npc=268090,
		loot={
			280694, -- Blade of the Forgotten
			280711, -- Pitted Specter Shackles
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98346}),
			-- 280376, -- Shadow Shard Sliver
		},
		vignette=7757,
		translate={[ns.ZULAMAN]=true},
	},
	[31645677] = { label="Lockjaw",
		criteria=115284, quest=96456,
		npc=265237,
		loot={
			280690, -- Bow of the Snapper
			280708, -- Venom-Shelled Sash
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98347}),
			-- 276031, -- Flamebeak Cord
		},
		vignette=7688,
	},
	[43855086] = { label="Hisstara",
		criteria=115281, quest=96464,
		npc=265262,
		loot={
			280691, -- Dagger of the Slithering Ritual
			280702, -- Mantle of the Riser
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98348}),
		},
		vignette=7689,
	},
	[69514483] = { label="Garsecg",
		criteria=110172, quest=94856,
		npc=258916,
		loot={
			280710, -- Garsecg's Barnacled Girdle
			280714, -- Hull Render Hauberk
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98350}),
			-- 276039, -- Flamebeak Drape
			-- 276047, -- Swamp Whomper
		},
		vignette=7500,
	},
	[57326610] = { label="Coin-Eye Skully",
		criteria=115285, quest=94619,
		npc=257906,
		loot={
			280695, -- Skully's Skullcleaver
			280715, -- Eye of Skully
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98352}),
			-- 276023, -- Flamebeak Mantle
		},
		note="Swims around the ship",
		vignette=7484,
	},
	[70036344] = { label="Big Mon",
		criteria=115286, quest=93829,
		npc=256631,
		loot={
			{280540, pet=true}, -- Lil' Mon
			280689, -- Big Mon's Big Spear
			280713, -- Big Mon's Buckle
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98353}),
			-- 274499, -- Toxiferous Transfusion
			-- 276037, -- Counter-Curse Circlet
			-- 276041, -- Stonehide Cape
			-- 276054, -- Serpentvine Machete
		},
		vignette=7417,
	},
	[57334045] = { label="Sss'alik",
		criteria=115287, quest=95447,
		npc=261109,
		loot={
			280700, -- Armbands of the Rotten Claw
			280706, -- Sss'alik's Rotting Claws
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98354}),
			-- 276037, -- Counter-Curse Circlet
			-- 276047, -- Swamp Whomper
		},
		note="Patrols",
		vignette=7548,
	},
	[52053229] = { label="Destra",
		criteria=115288, quest=95452,
		npc=261142,
		loot={
			280709, -- Triple Threat Pauldrons
			280712, -- Bracers of the Sleeping Hydra
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98355}),
		},
		vignette=7550,
	},
}, {
	achievement=63358, -- Coiled to Strike
	loot_shared=loot_shared,
})
local NARZIRA = { -- Nar'zira
	achievement=63358, -- Coiled to Strike
	criteria=115283, quest=94860,
	npc=258920,
	loot={
		280716, -- Locket of the Omnilegent
		280693, -- Staff of All-Knowing
		ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98351}),
		-- 276020, -- Stonehide Pauldrons
	},
	loot_shared=loot_shared,
	vignette=7501,
}
ns.RegisterPoints(ns.COILEDISLE, {
	[52364308] = NARZIRA, -- vignette's at 52054488, this is the entrance
})
ns.RegisterPoints(2642, { -- Tomb of the Lost Priest
	[64826092] = NARZIRA,
})

-- Deeply nested...
local SZARITH = ns.nodeMaker{ -- Szarith the Fanged
	achievement=63358, -- Coiled to Strike
	criteria=115282, quest=96030,
	npc=263456,
	loot={
		280698, -- Szarith's Underbelly Slicer
		280047, -- Feathered Bell
		ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98349}),
		ns.rewards.Achievement(62601, 113661), -- Soft Underbelly
		-- 276025, -- Skytalon Breeches
	},
	loot_shared=loot_shared,
	vignette=7629,
}
ns.RegisterPoints(ns.VAULTSOFATALUTEK, {
	[47300640] = SZARITH{parent=true},
})
ns.RegisterPoints(2613, { -- The Underbelly
	[37681723] = SZARITH{},
})

-- Turn the Surge
ns.RegisterPoints(ns.COILEDISLE, {
	[71303138] = { label="Ss'akrithos (Ski'thari @ 70913197)",
		criteria=115370, quest=93715, --todo: 93715 + 96968 triggered
		npc=258254,
		loot={
			276168, -- Fang of Ss'akrithos
			276171, -- Ophidian Circle
			-- 279477, -- Ss'akrithos's Forked Tongue
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=96968}),
		},
		vignette={7764, 7413}, -- Soucaller Ski'thari / Ss'akrithos
		areaPoi={8889, 8939}, -- murloc sacrifice event
	},
	[26646489] = { label="Looming Mutagenitor",
		criteria=115368, quest=93718,
		npc=255088,
		loot={
			276166, -- Twin-Headed Twinblade
			276172, -- Headdress of Mutagenesis
			-- 279475, -- Mutagenitor's Feather
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=96966}),
		},
		vignette={7414, 7686},
		areaPoi={8887, 8936},
	},
	[46192717] = { label="Vassti, the Exalted Broodmother",
		criteria=115369, quest=93676,
		npc=257863,
		loot={
			276173, -- Clutchguard Sandals
			276175, -- Broodmother's Embrace
			-- 279476, -- Vassti's Claw
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=96967}),
			-- 273000, -- Corrosive Soul
		},
		vignette=7763,
		areaPoi={8938},
	},
	[46996223] = { label="Malformed Leviathan",
		criteria=111353, quest=93673,
		npc=255087,
		loot={
			276169, -- Malformed Barrier
			276174, -- Leviathan's Oozing Scalemail
			-- 279479, -- Leviathan's Eye
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=96970}),
		},
		vignette={7412, 7453}, -- only saw the former
		areaPoi={8891, 8940},
	},
	[67167752] = { label="Venom Lancer Ori'kassi",
		criteria=115371, quest=93722,
		npc=255927,
		loot={
			276167, -- Ori'kassi's Lance
			276178, -- Venom Lancer's Gauntlets
			-- 279478, -- Ori'kassi's Barbed Tail
			ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=96969}),
			-- 274496, -- Ophidian Bone Whistle
			-- 273000, -- Corrosive Soul
			-- 276009, -- Skytalon Gloves
		},
		areaPoi={8890, 8937},
		vignette=7415,
	},
}, {
	achievement=63390, -- Turn the Surge
	atlas="poi-torghast", scale=1.1,
	loot_shared=loot_shared,
})

-- Vaults of Atal'Utek

--[[
TODO:
62604 Dance While Everyone Watches
]]

ns.RegisterPoints(ns.VAULTSOFATALUTEK, {
	[47210382] = ns.mapLink{link=2613}, -- The Underbelly
})
ns.RegisterPoints(2613, {
	[52739720] = ns.mapLink{link=ns.VAULTSOFATALUTEK, atlas="CaveUnderground-Up"}, -- The Underbelly
})

ns.RegisterPoints(ns.VAULTSOFATALUTEK, {
	-- [] = {criteria=113661, quest=96030, npc=263456, vignette=7629}, -- Szarith the Fanged
	-- These ones don't have a match in vignettes.db2
	-- [] = {criteria=113558, quest=nil, npc=263371, vignette=nil}, -- Priest of the First Rattle
	-- [] = {criteria=113557, quest=nil, npc=263322, vignette=nil}, -- Champion of the Scale
	-- [] = {criteria=113556, quest=nil, npc=263335, vignette=nil}, -- Guardian of the Sacrifice
	-- [] = {criteria=113662, quest=nil, npc=263851, vignette=nil}, -- Vserix the Sneaky
}, {
	achievement=62601, -- Soft Underbelly
	loot_shared=loot_shared,
})

local HONOREDDEAD = ns.nodeMaker{
	achievement=63610,
	atlas="animachannel-icon-necrolord-map", scale=1.2,
	minimap=true, -- they don't appear until you're close
}
ns.RegisterPoints(ns.VAULTSOFATALUTEK, {
	-- The Honored Dead
	[49535654] = {criteria=116407, quest=98029, vignette=7872}, -- To a daughter.
	[52214512] = {criteria=116408, quest=98030, vignette=7873}, -- To a lover.
	[55634070] = {criteria=116410, quest=98032, vignette=7875}, -- To a dream.
	[52893386] = {criteria=116411, quest=98033, vignette=7876}, -- To a captain.
	[42913993] = {criteria=116412, quest=98034, vignette=7877}, -- To sons.
	[45846175] = {criteria=116413, quest=98035, vignette=7878}, -- To failure.
	[47252877] = {criteria=116414, quest=98036, vignette=7879, note="Lower level"}, -- To a father.
	[46790751] = {criteria=116415, quest=98037, vignette=7880}, -- To a sister.
	[42513309] = {criteria=116417, quest=98039, vignette=7882, note="Lower level"}, -- To a stranger.
	[56492288] = {criteria=116418, quest=98040, vignette=7883}, -- To a shield-bearer.
}, HONOREDDEAD{})
ns.RegisterPoints(2636, { -- Vault of Restless Bones
	[76713465] = {criteria=116416, quest=98038, vignette=7881}, -- To comrades.
}, HONOREDDEAD{parent=true})
ns.RegisterPoints(2638, { -- Profaned Mausoleum
	[12666418] = {criteria=116409, quest=98031, vignette=7874}, -- To parents.
}, HONOREDDEAD{parent=true})
