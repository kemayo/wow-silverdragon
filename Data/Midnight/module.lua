if LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_MIDNIGHT or math.huge) then return end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

-- Handynotes imports
--[[
minor transformations applied:
s/(?<= ){ -- (.+)$/{\n\t\tlabel="$1",/g",
--]]

-- Stub time!
local ns = {
	RegisterPoints = function(...)
		core:RegisterHandyNotesData("Midnight", ...)
	end,
	rewards = core.rewards,
	conditions = core.conditions,
	MAXLEVEL = core.conditions.Level(90),
	SUPERRARE = function(point)
		local note = "This is a \"super rare\" which can drop higher level loot"
		if point.note then
			point.note = point.note .. "\n" .. note
		else
			point.note = note
		end
		return point
	end,
	atlas_texture = function(atlas, ...) return atlas end,
	nodeMaker = core.NAMESPACE.nodeMaker,
}

ns.QUELTHALAS = 2537
ns.ISLEOFQUELDANAS = 2424
ns.EVERSONGWOODS = 2395
ns.SILVERMOONCITY = 2393
ns.ZULAMAN = 2437
ns.ATALAMAN = 2536
ns.HARANDAR = 2413
ns.VOIDSTORM = 2405
ns.SLAYERSRISE = 2444
ns.VOIDSTORM_VAL = 2599
ns.VOIDSTORM_NAIGTAL = 2600
ns.COILEDISLE = 2512
ns.VAULTSOFATALUTEK = 2509

-- ns.WORLDQUESTS = ns.conditions.QuestComplete(79573)

ns.DRAGONRIDING = ns.conditions.SpellKnown(376777)

ns.FACTION_AMANI = 2696 -- paragon:2705
ns.FACTION_SINGULARITY = 2699 -- paragon:2725
ns.FACTION_HARATI = 2704 -- paragon:2726
ns.FACTION_SILVERMOONCOURT = 2710 -- paragon:2727
-- ns.FACTION_VANGUARDLIGHT = 2709
ns.FACTION_ZULJARRA = 2772
ns.FACTION_CAPTAIN_TOKKA = 2773

ns.CURRENCY_VALORSTONE = 3008
ns.CURRENCY_VOIDLIGHT = 3316
ns.CURRENCY_AMANI = 3354 --  renown:3355
ns.CURRENCY_SINGULARITY = 3389 -- renown:3388
ns.CURRENCY_HARATI = 3370 -- renown:3369
ns.CURRENCY_SILVERMOONCOURT = 3365 -- renown:3371
ns.CURRENCY_ZULJARRA = 3504 -- renown:3471

-- Treasures

local COURT = ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50)
local AMANI = ns.rewards.Currency(ns.CURRENCY_AMANI, 50)
local HARATI = ns.rewards.Currency(ns.CURRENCY_HARATI, 50)
local SINGULARITY = ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50)
local ZULJARRA = ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50)

core:RegisterTreasureData("Midnight", {
	-- Eversong Woods
	[7365] = {
		name="Triple-Locked Safebox", -- Gemmed Eversong Lantern
		achievement=61960, criteria=111472,
		quest=93456,
		loot={{243106, decor=true}, COURT},
		notes="Pick up the torch, and find three keys in the village",
	},
	[7395] = {
		name="Gift of the Phoenix",
		achievement=61960, criteria=111473, quest=93544, -- 93545 for placing
		loot={{263211, decor=true}, COURT}, -- Gilded Eversong Cup
		note="Take {spell:1264567:Sunstrider Vessel}, catch 5x{spell:1264565:Phoenix Cinders}",
	},
	[7424] = {name="Forgotten Ink and Quill", achievement=61960, criteria=111474, quest=93893, loot={{262616, decor=true}, COURT}, notes="Upper floor",},
	[7429] = {name="Gilded Armillary Sphere", achievement=61960, criteria=111475, quest=93908, loot={265828, COURT}, notes="Upper floor",},
	[7364] = {name="Antique Nobleman's Signet Ring", achievement=61960, criteria=111476, quest=93455, loot={265814, COURT}, notes="Ground floor",},
	[7366] = {name="Farstrider's Lost Quiver", achievement=61960, criteria=111477, quest=93457, loot={265816, COURT},},
	[7344] = {name="Stone Vat of Wine", achievement=61960, criteria=111478, quest=93061, loot={{251912, decor=true}, COURT}, notes="On floating platform; pick 10x{item:256232:Bunch of Ripe Grapes}, then get {item:256397:Packet of Instant Yeast} from {npc:251405:Sheri} nearby"},
	[7041] = {name="Burbling Paint Pot", achievement=61960, criteria=111479, quest=91358, loot={{246314, pet=4974}, COURT},},
	[7437] = {
		name="Rookery Cache",
		achievement=61960, criteria=111471, quest=93967, -- 94626 for giving the meat
		loot={{267838, pet=true}, COURT}, -- Sunwing Hatchling
		notes="In floating building; buy {item:265674:Tasty Meat} from {npc:258550:Farstrider Aerieminder}, give it to the {npc:257049:Mischevious Chick}; may need to relog to be able to place it",
	},

	-- Zul'Aman
	[6938] = {name="Abandoned Ritual Skull", --[[achievement=62125, criteria=111854,--]] quest=90794, loot={{257444, mount=true}}, notes="In cave on the lower level; gather 1000x{item:259361:Vile Essence} nearby"},
	[6937] = {
		name="Honored Warrior's Cache",
		achievement=62125, criteria=111855, quest=90793, -- 93560 for interacting with the cache
		loot={{257223, mount=true}}, -- Ancestral War Bear
		notes="Fetch the four tokens",
		related={
			[32698350] = {label="{npc:255171:Nalorakk's Chosen}", loot={259219}, inbag=259219}, -- Bear Tooth
			[34553346] = {label="{npc:255232:Halazzi's Chosen}", loot={259223}, inbag=259223}, -- Lynx Claw
			[54782239] = {label="{npc:255233:Jan'alai's Chosen}", loot={259220}, inbag=259220}, -- Dragonhawk Feather
			-- This one is looting-bugged, and there's no sign of the item on wowhead via https://www.wowhead.com/beta/items?filter=104;0;Honored+Warrior%27s+Cache
			[51588492] = {label="{npc:255231:Akil'zon's Chosen}", loot={}, inbag=nil}, -- Akil'zon's Chosen 255231
			hide_before=ns.conditions.QuestComplete(93560), -- interacted with the cache for the first time
			note="Use the Honored Warrior's Urn",
			minimap=true,
		},
	},
	[7419] = {
		name="Sealed Twilight Blade Bounty",
		achievement=62125, criteria=111856, quest=93871,
		loot={{265362, quest=94570}}, -- Arsenal: Twilight Blade
		notes="Solve the {spell:1270357:Sealing Orb} puzzle in each of the nearby towers",
		related={
			[26098074] = {quest=93916, label="{spell:1270357:Sealing Orb}", color={r=0.5,g=0,b=1}, minimap=true},
			[23957895] = {quest=93917, label="{spell:1270357:Sealing Orb}", color={r=0.5,g=0,b=1}, minimap=true},
			[24027566] = {quest=93918, label="{spell:1270357:Sealing Orb}", color={r=0.5,g=0,b=1}, minimap=true},
			[26097401] = {quest=93919, label="{spell:1270357:Sealing Orb}", color={r=0.5,g=0,b=1}, minimap=true},
		},
	},
	[6939] = {
		name="Bait and Tackle",
		achievement=62125, criteria=111857, quest=90795,
		loot={
			255157, -- Abyss Angler's Fish Log
			241145, -- Lucky Loa Lure
			255688, -- Achor of the Abyss
		},
	},
	[6940] = {name="Burrow Bounty", achievement=62125, criteria=111858, quest=90796, loot={254749}},
	[6941] = {name="Mrruk's Mangy Trove", achievement=62125, criteria=111859, quest=90797, loot={255428}},
	[6942] = {name="Secret Formula", achievement=62125, criteria=111860, quest=90798, loot={256326}},
	[6943] = {name="Abandoned Nest", achievement=62125, criteria=111861, quest=90799, loot={{255008, pet=4906}}, notes="Atop the tree"},

	[6934] = {name="Ruz'avalt's Prized Tackle", quest=90790},

	-- Harandar
	[7308] = {name="Failed Shroom Jumper's Satchel", achievement=61263, criteria=109033, quest=92424, loot={{258963, toy=true}, HARATI}},
	[7309] = {name="Burning Branch of the World Tree", achievement=61263, criteria=109034, quest=92426, loot={258900, ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 150), HARATI}},
	[7311] = {name="Sporelord's Fight Prize", achievement=61263, criteria=109035, quest=92427, loot={263289, HARATI}},
	[7312] = {name="Reliquary's Lost Paintbrush", achievement=61263, criteria=109036, quest=92431, loot={263287, {246416, decor=true}, HARATI}},
	[7313] = {name="Kemet's Simmering Cauldron", achievement=61263, criteria=109037, quest=92436, loot={{258903, pet=true}, HARATI}},
	[7351] = {name="Gift of the Cycle", achievement=61263, criteria=110254, quest=93144, loot={{259084, toy=true}, HARATI}},
	[7394] = {
		name="Impenatrably Sealed Gourd",
		achievement=61263, criteria=110255, quest=93508,
		loot={{260730, pet=true}, HARATI}, -- Perturbed Sporebat
		notes="Collect {item:260250:Mysterious Purple Fluid}, {item:260251:Mysterious Red Fluid}, combine in the Durable Vase, use to open the Gourd",
	},
	[7411] = {name="Sporespawned Cache", achievement=61263, criteria=110256, quest=93650, loot={{256423, mount=true}, HARATI}},
	[7410] = {name="Peculiar Cauldron", achievement=61263, criteria=110257, quest=93587, loot={{252017, mount=true}, HARATI}, notes="Gather 150x {item:260531:Crystallized Resin Fragment} in the water nearby"},

	-- Voidstorm
	[7355] = {
		name="Final Clutch of Predaxas",
		achievement=62126, criteria=111863, quest=93237,
		loot={{257446, mount=true}, SINGULARITY}, -- Reins of the Insatiable Shredclaw
		path=48927833
	},
	[7498] = {
		name="Void-Shielded Tomb",
		achievement=62126, criteria=111864, quest=92414,
		loot={246951, SINGULARITY}, -- Stormarion Core x20
		notes="Drink the potion, then fetch {item:251519:Key of Fused Darkness} from the adjacent building",
		nearby={25976863, worldmap=false, label="{item:251519:Key of Fused Darkness}"},
	},
	[7359] = {
		name="Forgotten Oubliette", -- then 7360 Bloody Sack
		achievement=62126, criteria=111866, quest=93431,
		loot={{267139, toy=true}, SINGULARITY}, -- Hungry Black Hole
		notes="Feed it meat",
	},
	[7418] = {
		name="Malignant Chest",
		achievement=62126, criteria=111867, quest=93840,
		loot={{264482, decor=true}},
		related={
			[53474321] = {quest=93812}, -- 1
			[52944333] = {quest=93813, hide_before=ns.conditions.QuestComplete(93812)}, -- 2
			[53534388] = {quest=93814, hide_before=ns.conditions.QuestComplete(93813)}, -- 3
			[53234271] = {quest=93815, hide_before=ns.conditions.QuestComplete(93814)}, -- 4
			texture=ns.atlas_texture("playerpartyblip", {r=0.4, g=0, b=1}), worldmap=false, minimap=true,
		},
	},
	[7397] = {name="Embedded Spear", achievement=62126, criteria=111871, quest=93553, loot={266075, SINGULARITY}},
	[7393] = {name="Quivering Egg", achievement=62126, criteria=111872, quest=93500, loot={{266076, pet=true}, SINGULARITY}},
	[7392] = {name="Exaliburn", achievement=62126, criteria=111873, quest=93498, loot={266099, SINGULARITY}, notes="Drink the potion, loot the sword"},
	[7391] = {name="Discarded Energy Pike", achievement=62126, criteria=111874, quest=93496, loot={266100, SINGULARITY}},
	[7368] = {name="Slain Scout's Quiver", achievement=62126, criteria=111875, quest=93493, loot={266098, SINGULARITY}},
	[7367] = {name="Half-Digested Viscera", achievement=62126, criteria=111876, quest=93467, loot={{264303, pet=true}, SINGULARITY}, path=38076874, notes="In cave; on upper level"},
	[7455] = {name="Forgotten Researcher's Cache", achievement=62126, criteria=111869, quest=94454, loot={{250319, toy=true}, SINGULARITY}},
	[7441] = {
		name="Stellar Stash",
		achievement=62126, criteria=111868, quest=93996, -- 94005 after pulling out
		loot={{262467, decor=true}, SINGULARITY}, -- Void Elf Round Table
		notes="Inside the building; drag objects out 3x",
	},
	[7447] = {name="Scout's Pack", achievement=62126, criteria=111870, quest=94387, loot={266101, SINGULARITY}},

	-- Junk
	-- Technically these contain some healing potions, grey gear, profession knowledge weekly items, and housing dyes
	-- Eversong
	[6931] = {name="Misplaced Tome", loot={}},
	[7438] = {name="Dead Drop", loot={}},
	[7439] = {name="Coalesced Light", loot={}},
	[7440] = {name="Ranger's Cache", loot={}},
	-- Zul'Aman
	[7044] = {name="Forgotten Amani Cache", loot={}},
	[7336] = {name="Spiritpaw Satchel", loot={}},
	[7337] = {name="Twilight Ordinance", loot={}},
	[7338] = {name="Maisara Vilevessel", loot={}},
	[7339] = {name="Stonewash Supplies", loot={}},
	[7348] = {name="Giant Grab Bag", loot={}},
	[7349] = {name="Shabby Stockpile", loot={}},
	-- Harandar
	[7317] = {name="Fungalcap Crock", loot={}},
	[7318] = {name="Budding Barrel", loot={}},
	[7320] = {name="Leaf-Wrapped Package", loot={}},
	-- Voidstorm
	[7342] = {name="Stashed Singularity Supplies", loot={}},
	[7343] = {name="Mysterious Domanaar Vessel", loot={}},
	-- Naigtal
	[7706] = {name="Hal'hadar Pocket-Storage", loot={}},
	-- Val
	[7707] = {name="Domanaar Storage Vessel", loot={}},
	-- Coiled Isle
	[7704] = {name="Decrepit Cache", loot={}},
	[7705] = {name="Cracked Canopic Jar", loot={}},
	[7712] = {name="Venom-Clotted Bauble", loot={}},
	[7713] = {name="Singing Shell", loot={}},
	-- Vaults of Atal'Utek
	[7654] = {name="Soulcoiler's Cache", loot={}},
	[7655] = {name="Soulcoiler's Trove", loot={}},
}, true)

local moth = {name="Glowing Moth", achievement=61052, loot={ns.rewards.Currency(3385)}}
local moths = {}
for i=7173,7293 do
	moths[i] = moth
end
core:RegisterTreasureData("Midnight", moths, true)

-- Rares

core:RegisterMobData("Midnight", {
	-- World bosses
	[244762] = {
		name="Lu'ashal",
		quest=92560,
		worldquest=92560,
		locations={[ns.EVERSONGWOODS]={}}, -- 45245997
		loot={
			250447, -- Radiant Eversong Scepter
			250451, -- Dawncrazed Beast Cleaver
			250453, -- Scepter of the Unbound Light
			250456, -- Wretched Scholar's Gilded Robe
			250457, -- Devouring Outrider's Chausses
			250458, -- Host Commander's Casque
			250459, -- Bramblestalker's Feathered Cowl
			250462, -- Forgotten Farstrider's Insignia
		},
	},
	[244424] = {
		name="Cragpine",
		quest=92123,
		worldquest=92123,
		locations={[ns.ZULAMAN]={}}, -- 45244790
		loot={
			250446, -- Cragtender Bulwark
			250450, -- Forest Sentinel's Savage Longbow
			250456, -- Wretched Scholar's Gilded Robe
			250457, -- Devouring Outrider's Chausses
			250458, -- Host Commander's Casque
			250459, -- Bramblestalker's Feathered Cowl
			250461, -- Chain of the Ancient Watcher
			250462, -- Forgotten Farstrider's Insignia
		},
	},
	[249776] = {
		name="Thorm'belan",
		quest=92034,
		worldquest=92034,
		locations={[ns.HARANDAR]={}}, -- 39026691
		loot={
			250449, -- Skulking Nettledirk
			250452, -- Blooming Thornblade
			250455, -- Beastly Blossombarb
			250456, -- Wretched Scholar's Gilded Robe
			250457, -- Devouring Outrider's Chausses
			250458, -- Host Commander's Casque
			250459, -- Bramblestalker's Feathered Cowl
			250462, -- Forgotten Farstrider's Insignia
		},
	},
	[248864] = {
		name="Predaxas",
		quest=92636,
		worldquest=92636,
		locations={[ns.VOIDSTORM]={}}, -- 49078651
		loot={
			250448, -- Voidbender's Spire
			250454, -- Devouring Vanguard's Soulcleaver
			250456, -- Wretched Scholar's Gilded Robe
			250457, -- Devouring Outrider's Chausses
			250458, -- Host Commander's Casque
			250459, -- Bramblestalker's Feathered Cowl
			250460, -- Encroaching Shadow Signet
			250462, -- Forgotten Farstrider's Insignia
		},
	},

	[252959] = {
		name="Nymrissa Wavecaller",
		quest=97128,
		worldquest=97128,
		-- areaPoi=8896,
		locations={[ns.COILEDISLE]={}}, -- 59996622
		loot={
			268199, -- Tidepiercer's Bubble Popper
			268217, -- Rising Tide Wristguards
			268221, -- Tidebound Sorcereress's Robes
			268226, -- Swelling Sea Spaulders
			268232, -- Cincture of the Abyssal Grotto
			268238, -- Grips of Swirling Fury
			268244, -- Forgotten Grotto Girdle
			268247, -- Breakwater Boots
			268262, -- Bubblefin Splash Guard
			268263, -- Frostscale's Mystic Frond
			268266, -- Alluring Bubbleband
			270167, -- Wavecaller's Seastone
			{279112, decor=true}, -- Clumped Asteroidea
		},
	},

	-- Prepatch, Twilight Highlands / Two Minutes to Midnight
	-- rotation rares:
	-- listen to Umbric gets 92103
	-- first kill seems to get 91468
	[237853] = {name="Berg the Spellfist", locations={[241]={57537539}}, achievement=42300, criteria=105727, vignette=6755, poi={241, 8244}, notes="Next up: {npc:237997}"},
	[237997] = {name="Corla, Herald of Twilight", locations={[241]={70973060}}, achievement=42300, criteria=105730, vignette=6761, poi={241, 8244}, notes="Next up: {npc:246272}"},
	[246272] = {name="Void Zealot Devinda", locations={[241]={46802511}}, achievement=42300, criteria=105733, vignette=6988, poi={241, 8244}, notes="Next up: {npc:246343}"},
	[246343] = {name="Asira Dawnslayer", locations={[241]={45414908}}, achievement=42300, criteria=105737, vignette=6994, poi={241, 8244}, notes="Next up: {npc:246462}"},
	[246462] = {name="Archbishop Benedictus", locations={[241]={42581723}}, achievement=42300, criteria=105740, vignette=6996, poi={241, 8244}, notes="Next up: {npc:246577}"},
	[246577] = {name="Nedrand the Eyegorger", locations={[241]={64905253}}, achievement=42300, criteria=105743, vignette=7008, poi={241, 8244}, notes="Next up: {npc:246840}"},
	[246840] = {name="Executioner Lynthelma", locations={[241]={57537539}}, achievement=42300, criteria=105728, vignette=7042, poi={241, 8244}, notes="Next up: {npc:246565}"},
	[246565] = {name="Gustavan, Herald of the End", locations={[241]={70973060}}, achievement=42300, criteria=105731, vignette=7005, poi={241, 8244}, notes="Next up: {npc:246578}"},
	[246578] = {name="Voidclaw Hexathor", locations={[241]={46812510}}, achievement=42300, criteria=105734, vignette=7009, poi={241, 8244}, notes="Next up: {npc:246566}"},
	[246566] = {name="Mirrorvise", locations={[241]={45414908}}, achievement=42300, criteria=105738, vignette=7006, poi={241, 8244}, notes="Next up: {npc:246558}"},
	[246558] = {name="Saligrum the Observer", locations={[241]={42581723}}, achievement=42300, criteria=105741, vignette=7003, poi={241, 8244}, notes="Next up: {npc:246572}"},
	[246572] = {name="Redeye the Skullchewer", locations={[241]={64905253}}, achievement=42300, criteria=105744, vignette=7007, poi={241, 8244}, notes="Next up: {npc:246844}"},
	[246844] = {name="T'aavihan the Unbound", locations={[241]={57537539}}, achievement=42300, criteria=105729, vignette=7043, poi={241, 8244}, notes="Next up: {npc:246460}"},
	[246460] = {name="Ray of Putrescence", locations={[241]={70973060}}, achievement=42300, criteria=105732, vignette=6995, poi={241, 8244}, notes="Next up: {npc:246471}"},
	[246471] = {name="Ix the Bloodfallen", locations={[241]={46802511}}, achievement=42300, criteria=105736, vignette=6997, poi={241, 8244}, notes="Next up: {npc:246478}"},
	[246478] = {name="Commander Ix'vaarha", locations={[241]={45414908}}, achievement=42300, criteria=105739, vignette=6998, poi={241, 8244}, notes="Next up: {npc:246559}"},
	[246559] = {name="Sharfadi, Bulwark of the Night", locations={[241]={42581723}}, achievement=42300, criteria=105742, vignette=7004, poi={241, 8244}, notes="Next up: {npc:246549}"},
	[246549] = {name="Ez'Haadosh the Liminality", locations={[241]={64905253}}, achievement=42300, criteria=105745, vignette=7001, poi={241, 8244}, notes="Next up: {npc:237853}"},
	-- ephemeral void:
	[253378] = {name="Voice of the Eclipse", locations={[241]={56537321,40051423,48692396,69122952,66975337,47194500,}}, achievement=42300, criteria=109583, vignette=7340, poi={241, 8244},},

	-- Ignored
	[250788] = {name="Lovely Sunflower", hidden=true}, -- Waverly's spawn
	[209781] = {name="Empowered Restoration Stone", hidden=true},
}, true)

ns.RegisterPoints(ns.ISLEOFQUELDANAS, {
	[55712913] = {
		label="Tarhu the Ransacker",
		quest=95011,
		npc=252465,
		loot={
			267271, -- Nethersteel Deflectors
			267267, -- Ransacker's Netherhide Mask
		},
		vignette=7325,
	},
	[37093830] = {
		label="Dripping Shadow",
		quest=95010,
		npc=239864,
		loot={
			267268, -- Dripping Silk Footwraps
			267270, -- Shadow-Drenched Legguards
		},
		vignette=7155,
	},
})

-- A Bloody Song
ns.RegisterPoints(ns.EVERSONGWOODS, {
	[51397502] = {
		label="Warden of Weeds",
		criteria=110166, quest=91280,
		npc=246332,
		loot={
			264520, -- Warden's Leycrook
			264613, -- Steelbark Bulwark
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94681}),
		},
		vignette=7363,
		note="Wanders",
	},
	[44767846] = {
		label="Harried Hawkstrider",
		criteria=110167, quest=91315,
		npc=246633,
		loot={
			264521, -- Striderplume Focus
			264522, -- Striderplume Armbands
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94682}),
		},
		vignette=7002,
		note="Runs around nearby",
	},
	[54716019] = {
		label="Overfester Hydra",
		criteria=110168, quest=92392,
		npc=240129,
		loot={
			264523, -- Hydrafang Blade
			264524, -- Lightblighted Verdant Vest
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94684}),
		},
		vignette=7300, -- Dormant Lightbloom Hydra
	},
	[36566407] = {
		label="Bloated Snapdragon",
		criteria=110169, quest=92366,
		npc=250582,
		loot={
			264543, -- Snapdragon Pantaloons
			264560, -- Sharpclaw Gauntlets
			260647, -- Digested Human Hand
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94685}),
		},
		vignette=7294,
	},
	[62964878] = {
		label="Cre'van",
		criteria=110170, quest=92391,
		npc=250719,
		loot={
			264573, -- Taskmaster's Sadistic Shoulderguards
			264647, -- Cre'van's Punisher
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94686}), --v
		},
		vignette=7299, -- Cre'van, Cruel Taskmaster
		note="Wanders the camp a bit",
	},
	[36333636] = {
		label="Coralfang",
		criteria=110171, quest=92389,
		npc=250683,
		loot={
			264602, -- Abyss Coral Band
			264629, -- Coralfang's Hefty Fin
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94687}),
		},
		vignette=7298,
	},
	[36657719] = {
		label="Lady Liminus",
		criteria=110172, quest=92393,
		npc=250754,
		loot={
			264612, -- Tarnished Gold Locket
			264645, -- Aged Farstrider Bow
			260655, -- Decaying Humanoid Flesh
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94688}),
		},
		vignette=7301,
	},
	[40408532] = {
		label="Terrinor",
		criteria=110173, quest=92409,
		npc=250876,
		loot={
			264537, -- Winged Terror Gloves
			264546, -- Bat Fur Boots
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94689}), --v
		},
		vignette=7306,
	},
	[49048777] = {
		label="Bad Zed",
		criteria=110174, quest=92404,
		npc=250841,
		loot={
			264536, -- Zedling Summoning Collar
			264621, -- Bad Zed's Worst Channeler
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94690}),
		},
		vignette=7305,
	},
	[34812098] = {
		label="Waverly",
		criteria=110175, quest=92395,
		npc=250780, -- 250788 for Lovely Sunflower
		loot={
			264608, -- String of Lovely Blossoms
			264910, -- Shell-Cleaving Poleaxe
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94691}), --v
		},
		vignette=7302,
	},
	[56427760] = {
		label="Banuran",
		criteria=110176, quest=92403,
		npc=250826,
		loot={
			264526, -- Supremely Slimy Sash
			264552, -- Frogskin Grips
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94692}),
		},
		vignette=7304,
	},
	[59107924] = {
		label="Lost Guardian",
		criteria=110177, quest=92399,
		npc=250806,
		loot={
			264555, -- Splintered Hexwood Clasps
			264575, -- Hexwood Helm
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94693}),
		},
		vignette=7303,
	},
	[42436906] = {
		label="Duskburn",
		criteria=110178, quest=93550,
		npc=255302,
		loot={
			264569, -- Void-Gorged Kickers
			264594, -- Netherscale Cloak
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94694}),
		},
		vignette=7396,
	},
	[51694601] = {
		label="Malfunctioning Construct",
		criteria=110179, quest=93555,
		npc=255329,
		loot={
			264584, -- Stonecarved Smashers
			264603, -- Guardian's Gemstone Loop
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94695}), --v
		},
		vignette=7399,
	},
	[45873904] = {
		label="Dame Bloodshed",
		criteria=110180, quest=93561,
		npc=255348,
		loot={
			{265609, pet=true}, -- Princess Bloodshed
			264595, -- Lynxhide Shawl
			264624, -- Fang of the Dame
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94696}),
		},
		note="Wanders",
		vignette=7404,
	},
}, {
	achievement=61507,
	loot_shared={
		251788, -- Gift of Light
		251791, -- Holy Retributor's Order
		{257147, mount=true}, -- Cobalt Dragonhawk
		{257156, mount=true}, -- Cerulean Hawkstrider
	},
})


do
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
		[34393304] = {
			label="Necrohexxer Raz'ka",
			criteria=111839, quest=89569,
			npc=242023,
			loot={
				264527, -- Vile Hexxer's Mantle
				264611, -- Pendant of Siphoned Vitality
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94683}),
			},
			vignette=6895,
		},
		[51881875] = {
			label="The Snapping Scourge",
			criteria=111840, quest=89570,
			npc=242024,
			loot={
				264585, -- Snapper Steppers
				264617, -- Scourge's Spike
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94697}),
			},
			vignette=6896,
		},
		[51847292] = {
			label="Skullcrusher Harak",
			criteria=111841, quest=89571,
			npc=242025,
			loot={
				264542, -- Skullcrusher's Mantle
				264631, -- Harak's Skullcutter
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94698}),
			},
			vignette=6897,
		},
		[28832450] = {
			label="Lightwood Borer",
			criteria=111842, quest=89575,
			npc=242028,
			loot={
				264557, -- Borerplate Pauldrons
				264640, -- Sharpened Borer Claw
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94699}),
			},
			vignette=6900,
		},
		[50866517] = {
			label="Mrrlokk",
			criteria=111843, quest=91174,
			npc=245975,
			loot={
				264570, -- Reinforced Chainmrrl
				264580, -- Mrrlokk's Mrgl Grrdle
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94700}),
			},
			vignette=6977,
		},
		[30574456] = {
			label="Spinefrill",
			criteria=111845, quest=89578,
			npc=242031,
			loot={
				264554, -- Frilly Leather Vest
				264620, -- Pufferspine Spellpierce
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94702}),
			},
			vignette=6903,
		},
		[46555127] = {
			label="Oophaga",
			criteria=111846, quest=89579,
			npc=242032,
			loot={
				264528, -- Goop-Coated Leggings
				264541, -- Egg-Swaddling Sash
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94703}),
			},
			vignette=6904,
		},
		[47763435] = {
			label="Tiny Vermin",
			criteria=111847, quest=89580,
			npc=242033,
			loot={
				264648, -- Verminscale Gavel
				264597, -- Leechtooth Band
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94704}),
			},
			vignette=6905,
		},
		[21547051] = {
			label="Voidtouched Crustacean",
			criteria=111848, quest=89581,
			npc=242034,
			loot={
				264564, -- Crab Wrangling Harness
				264586, -- Crustacean Carapace Chestguard
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94705}),
			},
			vignette=6906,
		},
		[39592097] = {
				label="The Devouring Invader",
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
		[33688897] = {
			label="Elder Oaktalon",
			criteria=111850, quest=89572,
			npc=242026,
			loot={
				264547, -- Worn Furbolg Bindings
				264529, -- Cover of the Furbolg Elder
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94707}),
			},
			vignette=6898,
		},
		[47662052] = {
			label="Depthborn Eelamental",
			criteria=111851, quest=89573,
			npc=242027,
			loot={
				264598, -- Eelectrum Signet
				264618, -- Strangely Eelastic Blade
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94708}),
			},
			vignette=6899,
		},
		[46394339] = {
			label="The Decaying Diamondback",
			criteria=111852, quest=91072,
			npc=245691,
			loot={
				264525, -- Wrapped Antenna Cuffs
				264582, -- Diamondback-Scale Legguards
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94709}),
			},
			vignette=6971,
		},
		[45284171] = {
			label="Ash'an the Empowered",
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
		[82972145] = {
			label="Poacher Rav'ik",
			criteria=111844, quest=91634,
			npc=247976,
			loot={
				264627, -- Rav'ik's Spare Hunting Spear
				264911, -- Forest Hunter's Arc
				ns.rewards.Currency(ns.CURRENCY_AMANI, 50, {quest=94701}),
			},
			vignette=7117,
		},
	}, {
		achievement=62122,
		parent=true,
		loot_shared=loot_shared,
	})
end


-- Leaf None Behind
ns.RegisterPoints(ns.HARANDAR, {
	[51174530] = {
		label="Rhazul",
		criteria=109039, quest=91832,
		npc=248741,
		loot={
			264530, -- Grimfur Mittens
			264622, -- Grimfang Shank
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94712}),
		},
		vignette=7139,
	},
	[68014033] = {
		label="Chironex",
		criteria=109040, quest=92137,
		npc=249844,
		loot={
			264538, -- Translucent Membrane Slippers
			264544, -- Grounded Death Cap
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94713}),
		},
		vignette=7156,
	},
	[67696228] = {
		label="Ha'kalawe",
		criteria=109041, quest=92142,
		npc=249849,
		loot={
			264553, -- Deepspore Leather Galoshes
			264592, -- Ha'kalawe's Flawless Wing
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94714}),
		},
		note="Wanders",
		vignette=7157,
	},
	[72636926] = {
		label="Tallcap the Truthspreader",
		criteria=109042, quest=92148,
		npc=249902,
		loot={
			264532, -- Robes of Flowing Truths
			264650, -- Truthspreader's Truth Spreader
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94715}),
		},
		vignette=7158,
	},
	[60104701] = {
		label="Queen Lashtongue",
		criteria=109043, quest=92154,
		npc=249962,
		loot={
			264566, -- Lashtongue's Leaffroggers
			264571, -- Ironleaf Wristguards
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94716}),
		},
		vignette=7159,
	},
	[64894814] = {
		label="Chlorokyll",
		criteria=109044, quest=92161,
		npc=249997,
		loot={
			264604, -- Sludgy Verdant Signet
			264626, -- Scepter of Radiant Conversion
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94717}),
		},
		vignette=7161,
	},
	[65653279] = {
		label="Stumpy",
		criteria=109045, quest=92168,
		npc=250086,
		loot={
			264635, -- Stumpy's Stump
			264578, -- Stumpy's Terrorplate
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94718}), --v
		},
		vignette=7162,
	},
	[56783422] = {
		label="Serrasa",
		criteria=109046, quest=92170,
		npc=250180,
		loot={
			264568, -- Serrated Scale Gauntlets
			264639, -- Razorfang Hacker
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94719}), --v
		},
		vignette=7163,
	},
	[46353284] = {
		label="Mindrot",
		criteria=109047, quest=92172,
		npc=250226,
		loot={
			264550, -- Fungal Stalker's Stockings
			264649, -- Mindrot Claw-Hammer
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94720}),
		},
		vignette=7164,
	},
	[40654299] = {
		label="Dracaena",
		criteria=109048, quest=92176,
		npc=250231,
		loot={
			264562, -- Plated Grove Vest
			264644, -- Crawler's Mindscythe
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94721}),
		},
		vignette=7165,
	},
	[36597516] = {
		label="Treetop",
		criteria=109049, quest=92183,
		npc=250246,
		loot={
			264633, -- Treetop Battlestave
			264581, -- Bloombark Spaulders
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94722}),
		},
		vignette=7166,
	},
	[28118181] = {
		label="Oro'ohna",
		criteria=109050, quest=92190,
		npc=250317,
		loot={
			264591, -- Radiant Petalwing's Feather
			264616, -- Lightblighted Sapdrinker
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94723}), --v
		},
		vignette=7167,
	},
	[27197021] = {
		label="Pterrock",
		criteria=109051, quest=92191,
		npc=250321,
		loot={
			264567, -- Rockscale Hood
			264576, -- Slatescale Grips
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94724}),
		},
		vignette=7168,
	},
	[39696070] = {
		label="Ahl'ua'huhi",
		criteria=109052, quest=92193,
		npc=250347,
		loot={
			264534, -- Bogvine Shoulderguards
			264540, -- Mirevine Wristguards
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94725}),
		},
		vignette=7171,
	},
	[44501610] = {
		label="Annulus the Worldshaker",
		criteria=109053, quest=92194,
		npc=250358,
		loot={
			264607, -- Spore-Laden Choker
			264614, -- Fungal Cap Guard
		},
		vignette=7172,
	},
}, {
	achievement=61264,
	loot_shared={
		251782, -- Withered Saptor's Paw
		255826, -- Mysterious Skyshards
		{246735, mount=true}, -- Rootstalker Grimlynx
		{252012, mount=true}, -- Vibrant Petalwing
	}
})


do
	local loot_shared = {
		-- 246951, -- Stormarion Core
		251786, -- Ever-Collapsing Void Fissure
		264694, -- Ultradon Cuirass
		264701, -- Cosmic Bell
		{257085, mount=true,}, -- Augmented Stormray
		{260635, mount=true,}, -- Sanguine Harrower
	}

	-- The Ultimate Predator
	ns.RegisterPoints(ns.VOIDSTORM, {
		[29515008] = { -- Sundereth the Caller
			criteria=111877, quest=90805,
			npc=244272,
			loot={
				264619, -- Nethersteel Spellblade
				264539, -- Robes of the Voidcaller
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94728}),
			},
			vignette=6949,
		},
		[34028218] = { -- Territorial Voidscythe
			criteria=111878, quest=91050,
			npc=238498,
			loot={
				264565, -- Voidscale Shoulderpads
				264642, -- Carving Voidscythe
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94729}),
			},
			vignette=6961,
		},
		[36308373] = { -- Tremora
			criteria=111879, quest=91048,
			npc=241443,
			loot={
				264610, -- Escaped Specimen's ID Tag
				264646, -- Specimen Sinew Longbow
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94730}),
			},
			path=37498452, -- or 35678113
			note="In the tunnel",
			vignette=6962,
		},
		[43685151] = { -- Screammaxa the Matriarch
			criteria=111880, quest=93966,
			npc=256922,
			loot={
				264545, -- Harrower-Claw Grips
				264583, -- Barbute of the Winged Hunter
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94731}),
			},
			vignette=7436,
		},
		[47058063] = { -- Bane of the Vilebloods
			criteria=111881, quest=93946,
			npc=256923,
			loot={
				264558, -- Vileblood Resistant Sabatons
				264572, -- Netherplate Clasp
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94732}),
			},
			note="In cave",
			vignette=7433,
		},
		[39246394] = { -- Aeonelle Blackstar
			criteria=111882, quest=93944,
			npc=256924,
			loot={
				264549, -- Ever-Devouring Shoulderguards
				264637, -- Cosmic Hunter's Glaive
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94751}),
			},
			note="In cave at lowest level",
			vignette=7432,
		},
		[37887178] = { -- Lotus Darkblossom
			criteria=111883, quest=93947,
			npc=256925,
			loot={
				264632, -- Darkblossom's Crook
				264548, -- Sash of Cosmic Tranquility
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94758}),
			},
			vignette=7434,
		},
		[55727945] = { -- Queen o' War
			criteria=111884, quest=93934,
			npc=256926,
			loot={
				264533, -- Queen's Tentacle Sash
				264601, -- Queen's Eye Band
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94761}),
			},
			note="Use the Crown",
			vignette=7430,
		},
		[48815317] = { -- Ravengerus
			criteria=111885, quest=93895,
			npc=256808,
			loot={
				264535, -- Leggings of the Cosmic Harrower
				264589, -- Voidfused Wing Cloak
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94763}),
			},
			vignette=7426,
		},
		[35485023] = { -- Bilemaw the Gluttonous
			criteria=111887, quest=93884,
			npc=256770,
			loot={
				264579, -- Hungering Wristplates
				264623, -- Shredding Fang
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94752}),
			},
			path=35604931,
			vignette=7422,
		},
		[40154119] = { -- Nightbrood
			criteria=111889, quest=91051,
			npc=245044,
			loot={
				264551, -- Nightbrood's Jaw
				264574, -- Netherterror's Legplates
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94759}),
			},
			vignette=6964,
		},
		[53946272] = { -- Far'thana the Mad
			criteria=111890, quest=93896,
			npc=256821,
			loot={
				264912, -- Void-Channeler's Spire
				264913, -- Focused Netherslicer
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94755}),
			},
			vignette=7428,
		},
	}, {
		achievement=62130,
		loot_shared=loot_shared,
	})

	ns.RegisterPoints(ns.SLAYERSRISE, {
		[41268981] = { -- Eruundi
			criteria=111888, quest=91047,
			npc=245182,
			loot={
				264563, -- Eruundi's Wristguards
				264600, -- Ancient Argussian Band
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94754}),
			},
			vignette=6963, -- vignette position APIs don't work on this one...
		},
		[46384093] = { -- Rakshur the Bonegrinder
			criteria=111886, quest=93953,
			npc=257027,
			loot={
				264561, -- Primal Bonestompers
				264630, -- Colossal Voidsunderer
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94762}),
			},
			vignette=7435,
		},
	}, {
		achievement=62130,
		parent=true,
		loot_shared=loot_shared,
	})

	ns.RegisterPoints(ns.VOIDSTORM, {
		[30066921] = { -- Voidseer Orivane
			quest=94459,
			npc=248791,
			loot={
				264556, -- Voidforged Cinch
				264628, -- Spear of Nothingness
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94765}),
			},
			vignette=7140,
		},
		[28827024] = { -- The Many-Broken
			quest=94458,
			npc=248459, -- 248461, 248462
			loot={
				264577, -- Crystalforged Boots
				264651, -- Resonating Traumatizer
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94764}),
			},
			vignette=7133,
		},
		[28156593] = { -- Abysslick
			quest=94462,
			npc=248700,
			loot={
				264596, -- Voidthread Veil
				264634, -- Spire of Flowing Void
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94750}),
			},
			vignette=7138,
		},
		[29796799] = { -- Nullspiral
			quest=94460,
			npc=248068,
			loot={
				264531, -- Shadowthread Slippers
				264588, -- Shawl of Cosmic Whispers
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94760}),
			},
			vignette=7129,
		},
		[24736793] = { -- Blackcore
			quest=94463,
			npc=248823,
			loot={
				264519, -- Repurposed Voidwalker's Chestplate
				264606, -- Netherlocus Amulet
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94753}),
			},
			note="Gather 3x {item:248680:Unstable Focusing Crystal} from chests and {npc:248483:Crystal Fragment} to the east",
			related={
				[28257044]={label="{npc:248483:Crystal Fragment}", loot={248680}},
			},
			vignette=7142,
		},
	}, {
		loot_shared=loot_shared,
	})

	ns.RegisterPoints(ns.SLAYERSRISE, {
		[28465684] = { -- Hardin Steellock
			quest=94461, -- v
			npc=257199,
			loot={
				-- 264364, -- Hardin Steellock's Head
				264599, -- Kul'Tiran Signet Ring
				264615, -- Hardin's Backup Blade
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94757}),
			},
			faction="Horde",
			vignette=7442,
		},
		[69687730] = { -- Gar'chak Skullcleave
			quest=94461,
			npc=257231,
			loot={
				-- 264363, -- Gar'chak Skullcleave's Head
				264609, -- Gar'chak's Mark of Honor
				264641, -- Sharpened Skullcleaver
				ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94756}),
			},
			faction="Alliance",
			vignette=7445,
		},
	}, {
		parent=true,
		loot_shared=loot_shared,
	})
end


-- Invasions

ns.RegisterPoints(ns.VOIDSTORM_NAIGTAL, {
	[29106290] = { -- Auredar's Chassis
		criteria=114009,
		quest=96316, -- v
		npc=264569,
		loot={
			274873, -- Funeral Attendant's Spire
			275143, -- Draeni Ceremonial Cuffs
			275159, -- Construct Manipulator Bracers
			275167, -- Intact Construct Plates
			274827, -- Draenic Drive Chain
			-- 278116, -- Player Experience
		},
		vignette=7668,
	},
	[76203960] = { -- Swalewing Matriarch
		criteria=114007,
		quest=96207, -- v
		npc=263954,
		loot={
			274874, -- Flickering Wing Separator
			275137, -- Flickering Soft-Steppers
			275153, -- Flickering Scale Sabatons
			275145, -- Swalewing Skin Footpads
			275161, -- Swamp-Resistant Stompers
			-- 276288, -- Forgotten Sword of Vilaldoun
		},
		vignette=7660,
	},
	[39904270] = { -- Broxion
		-- [39904270, 41304680, 42004830, 42604800, 44905440, 45505340, 45805370, 46205600]
		criteria=114006,
		quest=96206, -- v
		npc=263950,
		loot={
			275138, -- Spore-Handler's Handwraps
			275146, -- Spore-Membrane Gloves
			275154, -- Swamp Trekker's Grips
			275162, -- Spore-Shined Gloves
			274890, -- Enchanted Spore
			-- 276288, -- Forgotten Sword of Vilaldoun
			-- 278116, -- Player Experience
		},
		vignette=7659,
	},
	[39516103] = { -- Interminable Uarn
		criteria=114005,
		quest=96205,
		npc=263947,
		loot={
			274862, -- Corrupted Draenei Priest's Kris
			275139, -- Crown of Fungal Spores
			275147, -- Bioluminescent Swamp Mask
			275155, -- Interminable Fungal Helmet
			-- no plate helm?
			274876, -- Reinforced Fungalhide Bulwark
		},
		vignette=7658,
	},
	[68546229] = { -- Lomelith
		criteria=114008,
		quest=96208,
		npc=263955,
		loot={
			274860, -- Ancient Spore-Coated Axe
			274819, -- Fungal Fold Frock
			274823, -- Spongy Gill Loop
			-- 278116, -- Player Experience
		},
		vignette=7661,
	},
	[69407720] = { -- Warp Agent Xi'grivr
		criteria=114010,
		quest=96319, -- v
		npc=264574,
		loot={
			274870, -- Assassin's Void-String Bow
			274821, -- Drape of the Hal'hadar Assassin
			274825, -- Hal'hadar Assassin's Signet
		},
		vignette=7670,
	},
	[54206240] = { -- Slaipaan
		criteria=114012,
		quest=96320, -- v
		npc=264576,
		loot={
			274871, -- Giant Worm Piercer
			275136, -- Leaf-Woven Blouse
			275144, -- Leafy-Hide Coat
			275152, -- Burrower's Linked Hauberk
			275160, -- Slaipaan's Carapace
			-- 276288, -- Forgotten Sword of Vilaldoun
		},
		vignette=7671,
	},
	[48006880] = { -- Indomitable Mk XII
		criteria=114011,
		quest=96317, -- v
		npc=264571,
		loot={
			276298, -- Forgotten Fel-Shard Talon
			275140, -- Leggings of Tainted Stuffing
			275148, -- Reaver's Padded Trousers
			275156, -- Gear-Linked Leggings
			275164, -- Indomitable Mechanized Legplates
			274891, -- Mk XII Gear Drive
			-- 276288, -- Forgotten Sword of Vilaldoun
			-- 278116, -- Player Experience
		},
		routes={{48006880, 49006576, 49005920, 52425751, 53215440, 53534842, 54254436}},
		vignette=7669,
	},
}, {
	achievement=62883, -- Showdown Slugger: Naigtal
})
ns.RegisterPoints(2646, { -- Naigral (Vilaldoun)
	[73608020] = { -- Auredar's Chassis
		criteria=114009,
		quest=96316, -- v
		npc=264569,
		loot={
			274873, -- Funeral Attendant's Spire
			275143, -- Draeni Ceremonial Cuffs
			275159, -- Construct Manipulator Bracers
			275167, -- Intact Construct Plates
			274827, -- Draenic Drive Chain
			-- 278116, -- Player Experience
		},
		vignette=7668,
	},
}, {
	achievement=62883, -- Showdown Slugger: Naigtal
})
ns.RegisterPoints(ns.VOIDSTORM_NAIGTAL, {
	[29751928] = { -- Warbringer Thal'kuur
		quest=97014,
		npc=267422,
		loot={
			276298, -- Forgotten Fel-Shard Talon
			274864, -- Sporebloom Gavel
			275141, -- Spore-Speckled Shoulderpads
			275149, -- Fungal Draped Epaulets
			275157, -- Swampwalker's Spaulders
			275165, -- Petrified Mushroom Shoulderplates
		},
		vignette=7744,
	},
	[48404760] = { -- Voidwarped Sporebat
		quest=96566, -- v
		npc=265698,
		loot={
			274866, -- Voidwarped Edge
			275142, -- Voidwarped Sash
			275150, -- Sporebat Leather Belt
			275158, -- Voidwarped Scale Girdle
			275166, -- Voidwarped Greatbelt
			-- 278116, -- Player Experience
		},
		vignette=7699,
	},
	[68235161] = { -- Sleepy Mandrake
		label="{npc:267910:Sleepy Mandrake}",
		loot={
			{262768, pet=true}, -- Sleepy Mandrake
		},
		note=function()
			local function done(q) return C_QuestLog.IsQuestFlaggedCompletedOnAccount(q) and "{a:common-icon-checkmark}" or "{a:common-icon-redx}" end
			return "Feed five mushrooms:\n"..
				done(97091).." {item:276365:Highland Redcap}\n"..
				done(97092).." {item:276366:Dusty Redcap}\n"..
				done(97093).." {item:276367:Marshy Redcap}\n"..
				done(97094).." {item:276368:Partially-Digested Redcap} (mob drop)\n"..
				done(97095).." {item:276369:Airy Redcap}"
		end,
		related={
			[28906176] = { -- Highland Redcap
				quest=97091, loot={276365}, label="{item:276365}",
				path={28906176, 29786262, 30156525, 30426609, 32676921, 33417072, 36217266, 36637216, 36407136, 31146332, 31316254, 31816023, 33475950},
			},
			[27914996] = {quest=97092, loot={276366}, label="{item:276366}", note="In the crypts"}, -- Dusty Redcap
			[71423705] = {quest=97093, loot={276367}, label="{item:276367}", path=75643814}, -- Marshy Redcap
			-- [] = {quest=97094, loot={276368}}, -- Partially-Digested Redcap
			[95092667] = {quest=97095, loot={276369}, label="{item:276369}", path=88812597, note="On top of the tallest mushroom, bounce up"}, -- Airy Redcap
			atlas="TeleportationNetwork-Ardenweald-32x32", minimap=true,
		},
		path=67505416,
		atlas="VignetteLootElite", scale=1.1, minimap=true,
	},
})


ns.RegisterPoints(ns.VOIDSTORM_VAL, {
	[33005700] = {
		label="Nelgothar",
		criteria=114002,
		quest=96374, -- v
		npc=264869,
		loot={
			276298, -- Forgotten Fel-Shard Talon
			274840, -- Pants of the Lost Legion
			274832, -- Fel-Tainted Trousers
			274848, -- Legguards of Fel-Corruption
			274856, -- Felguard's Frozen Greaves
			274892, -- Resilient Felblood Vial
			-- 276354, -- Frozen Fel Core
			-- 278116, -- Player Experience
		},
		vignette=7679,
	},
	[54006700] = {
		label="Sleet-Rune",
		criteria=113995,
		quest=95939, -- v
		npc=261965,
		loot={
			274869, -- Void-Iced Warglaives
			274828, -- Domanaar Subjugator's Vestments
			274836, -- Sleet-Resistant Jerkin
			274844, -- Sleetlink Hauberk
			274852, -- Sleetstone Chestplate
		},
		vignette=7605,
	},
	[23004100] = {
		label="The Horror Below",
		criteria=114003,
		quest=96375, -- v
		npc=264870,
		loot={
			274872, -- Darkness' Horrific Barb
			274826, -- Coiling Smoke Chain
			274818, -- Drape of Intense Darkness
		},
		vignette=7680,
	},
	[37007600] = {
		label="Atomus",
		criteria=113996,
		quest=95940, -- v
		npc=262421,
		loot={
			274868, -- Portal Master's Shortblade
			274831, -- Portal Shaper's Circlet
			274839, -- Cold-World Cover
			274847, -- Atomus's Headcover
			274855, -- Portal-Keeper's Helm
		},
		vignette=7606,
	},
	[49007800] = {
		label="Mercilus",
		criteria=113998,
		quest=96371, -- v
		npc=264865,
		loot={
			274867, -- Inscribed Domanaar's Sword
			274834, -- Cord of Domineering Resolve
			274842, -- Gatekeeper's Leather Waistguard
			274850, -- Mercilus's Chain Waistguard
			274858, -- Domanaar Battle Belt
		},
		vignette=7676,
	},
	[28007300] = {
		label="Xirah",
		criteria=113999,
		quest=96370, -- v
		npc=264864,
		loot={
			274875, -- Riftwalker's Lanter
			274820, -- Cloak of the Voracious Gorge
			274824, -- Worldeater's Bone Ring
		},
		vignette=7675,
	},
	[33004200] = {
		label="Opprimius",
		criteria=114001,
		quest=96373, -- v
		npc=264868,
		loot={
			274863, -- Cudgel of the Twisted Reaper
			274829, -- Creature Corruptor Slippers
			274837, -- Corrupted Hide Boots
			274845, -- Greaves of Corrupted Scale
			274853, -- Creature Crushers
			-- 278116, -- Player Experience
		},
		vignette=7678,
	},
	[44005840] = {
		label="Krilkan",
		criteria=114000,
		quest=96372, -- v
		npc=264866,
		loot={
			274835, -- Bands of Pincher Sinew
			274843, -- Pincher-Proof Wristguards
			274851, -- Glittering Frostscale Wraps
			274859, -- Klaxid Plate Vambraces
			274893, -- Frosty Klaxid Stinger
			-- 278116, -- Player Experience
		},
		vignette=7677,
	},
	[67104180] = {
		label="Glacial Broodmother",
		criteria=113997,
		quest=95559, -- v
		npc=261716,
		loot={
			274861, -- Frosty Broodmother's Fang
			274833, -- Icy Spidersilk Mantle
			274841, -- Frigid Cavedweller's Shoulderpads
			274849, -- Frostscale Spider's Monnion
			274857, -- Chitonous Broodmother's Spaulders
		},
		vignette=7558,
	},
	-- Unknown location, displayed to the side
	[11001700] = {
		label="Shadowguard Destroyer",
		criteria=114004,
		quest=96465, -- v
		npc=265269,
		loot={
			274865, -- Destroyer's Drop Hammer
			274830, -- Ice-Glazed Gloves
			274854, -- Shadowguard Plate Gauntlets
		},
		vignette=7690,
		note="Seems to spawn after other rares are killed",
	},
}, {
	achievement=62881, -- Showdown Slugger: Val
})

if select(4, GetBuildInfo()) < 120100 then
	return
end

-- Coiled Isle

-- Treasures

ns.RegisterPoints(ns.COILEDISLE, {
	[71886666] = { -- Amani Privateer's Cache
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
		atlas="VignetteLootElite", scale=1.1,
	},
	[45916628] = {criteria=115313, quest=95938, loot={281571, ZULJARRA}, vignette=7604}, -- Fangbound Sack, Focus of Fangs
	[65440560] = { -- Sunken Diver's Chest
		criteria=115290, quest=95907,
		loot={
			{279052, toy=true}, -- Ancient Amani Mask
			ZULJARRA,
		},
		note="Kill nearby {npc:263081:Glittering Grouper Brintail} for {item:271424:Diver's Key Fragment}x3",
		vignette=7599,
		atlas="VignetteLootElite", scale=1.1,
	},
	[67264846] = { -- Grave of Someone Forgotten
		criteria=115291, quest=95956,
		loot={
			{279021, toy=true}, -- Forgotten Memento
			ZULJARRA
		},
		note="Read the Nameless Grave, find other nearby ghosts that you can ask about the name, return to the grave",
		related={
			-- extreme lack of helpful quest progression here; they just stand up and walk away
			[69045270] = {label="{npc:263241:Zuzan}"},
			-- [70405840] = {label="{npc:263242:Zan'ja}"}, -- wowhead swears, but I didn't talk to this one...
			[66425725] = {label="{npc:263243:Ru'ko}"},
			minimap=true, worldmap=true,
		},
		vignette=7608,
		atlas="VignetteLootElite", scale=1.1,
	},
	[43646738] = { -- Profane Ritual Spoils (Ritual Chest)
		criteria=115292, quest=95941,
		loot={
			281567, -- Profane Ritual Staff
			ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 250),
			ZULJARRA,
		},
		note="Use {npc:263202:Mysterious Trinket}: upper right, upper left, bottom right, bottom left",
		vignette=7607, -- Ritual Chest
		atlas="VignetteLootElite", scale=1.1,
	},
	[70637663] = { -- Brine-Crusted Chest
		criteria=115294, quest=95995, -- 96001 pearl dropped, 96002 key dropped
		loot={{274921, toy=true}, ZULJARRA}, -- Pearl of Jubilation
		note="Find a Bubbling Clam underwater outside the cave; bring a {item:271815:Luminescent Pearl} and put it down for {npc:263347:Nacretta}; take the {item:271881:Dropped Key}; open the chest",
		vignette=7627, -- Ancient Amani Chest
		atlas="VignetteLootElite", scale=1.1,
	},
	[31438349] = {criteria=115295, quest=96985, loot={279051, ZULJARRA}, vignette=7743}, -- Possessed Vase
	[75376833] = {criteria=115306, quest=95164, loot={{268504, toy=true}, ZULJARRA}, vignette=7532}, -- Malfunctioning Staff
	[55213796] = {criteria=115307, quest=95563, loot={275920, ZULJARRA}, vignette=7559}, -- Tarnished Amani Glaive
	[60435946] = {criteria=115309, quest=95566, loot={{277954, toy=true}, ZULJARRA}, vignette=7560}, -- Jaktu's Cursed Blade
	[68056590] = { -- Lost Spirit (A Mysterious Urn, then the spirit)
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
	[53094310] = { -- Stinking Vessel
		criteria=115300, quest=95841,
		loot={
			{281580, decor=true}, -- Pungent Atal'Utek Shroom
			ns.rewards.Item(260290, 5), -- Quel'Thalas Cheese
			ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 100),
			ZULJARRA,
		},
		vignette=7590, -- Intact Vase
	},
	[49483198] = { -- Waterlogged Basket
		criteria=115301, quest=95854,
		loot={
			281569, -- Quiver of the Drowned Marksman
			ns.rewards.Item(258138, 5), -- Potent Healing Potion
			ZULJARRA,
		},
		vignette=7591,
	},
	[29546723] = {criteria=115302, quest=95855, loot={281570, ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 100), ZULJARRA}, vignette=7592}, -- Smoldering Incense, Amani Incense Stick
	[73485654] = { -- Crumbling Urn
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
	[58194572] = { -- Vul'zahn's Smuggled Treasure
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
		atlas="VignetteLootElite", scale=1.1,
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

-- Rares
do
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
		[53777203] = { -- Farthik the Plunderer
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
		[50006907] = { -- Siltmouth
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
		[24897354] = { -- Kari'zah the Forgotten
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
		[31645677] = { -- Lockjaw
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
		[43855086] = { -- Hisstara
			criteria=115281, quest=96464,
			npc=265262,
			loot={
				280691, -- Dagger of the Slithering Ritual
				280702, -- Mantle of the Riser
				ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=98348}),
			},
			vignette=7689,
		},
		[69514483] = { -- Garsecg
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
		[57326610] = { -- Coin-Eye Skully
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
		[70036344] = { -- Big Mon
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
		[57334045] = { -- Sss'alik
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
		[52053229] = { -- Destra
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
		[71303138] = { -- Ss'akrithos (Ski'thari @ 70913197)
			criteria=115370, quest=93715, --todo: 93715 + 96968 triggered
			npc=258254,
			loot={
				276168, -- Fang of Ss'akrithos
				276171, -- Ophidian Circle
				-- 279477, -- Ss'akrithos's Forked Tongue
				ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=96968}),
			},
			vignette={7764, 7413}, -- Soucaller Ski'thari / Ss'akrithos
			areaPoi=8889, -- murloc sacrifice event
		},
		[26406480] = { -- Looming Mutagenitor
			criteria=115368, quest=93718,
			npc=255088,
			loot={
				276166, -- Twin-Headed Twinblade
				276172, -- Headdress of Mutagenesis
				-- 279475, -- Mutagenitor's Feather
				ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=96966}),
			},
			vignette={7414, 7686},
		},
		[44702593] = { -- Vassti, the Exalted Broodmother
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
		},
		[46996223] = { -- Malformed Leviathan
			criteria=111353, quest=93673,
			npc=255087,
			loot={
				276169, -- Malformed Barrier
				276174, -- Leviathan's Oozing Scalemail
				-- 279479, -- Leviathan's Eye
				ns.rewards.Currency(ns.CURRENCY_ZULJARRA, 50, {quest=96970}),
			},
			areaPoi=8891,
			vignette={7412, 7453}, -- only saw the former
		},
		[67167752] = { -- Venom Lancer Ori'kassi
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
			areaPoi=8890,
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
end
