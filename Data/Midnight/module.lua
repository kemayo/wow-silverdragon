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
	nodeMaker = function(defaults)
		local meta = {__index = defaults}
		return function(details)
			details = details or {}
			if details.note and defaults.note then
				details.note = details.note .. "\n" .. defaults.note
			end
			local meta2 = getmetatable(details)
			if meta2 and meta2.__index then
				return setmetatable(details, {__index = MergeTable(CopyTable(defaults), meta2.__index)})
			end
			return setmetatable(details, meta)
		end
	end,
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

-- ns.WORLDQUESTS = ns.conditions.QuestComplete(79573)

ns.DRAGONRIDING = ns.conditions.SpellKnown(376777)

ns.FACTION_AMANI = 2696 -- paragon:2705
ns.FACTION_SINGULARITY = 2699 -- paragon:2725
ns.FACTION_HARATI = 2704 -- paragon:2726
ns.FACTION_SILVERMOONCOURT = 2710 -- paragon:2727
-- ns.FACTION_VANGUARDLIGHT = 2709

ns.CURRENCY_VALORSTONE = 3008
ns.CURRENCY_VOIDLIGHT = 3316
ns.CURRENCY_AMANI = 3354 --  renown:3355
ns.CURRENCY_SINGULARITY = 3389 -- renown:3388
ns.CURRENCY_HARATI = 3370 -- renown:3369
ns.CURRENCY_SILVERMOONCOURT = 3365 -- renown:3371

-- Treasures

local COURT = ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50)
local AMANI = ns.rewards.Currency(ns.CURRENCY_AMANI, 50)
local HARATI = ns.rewards.Currency(ns.CURRENCY_HARATI, 50)
local SINGULARITY = ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50)

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
	[6938] = {name="Abandoned Ritual Skull", achievement=62125, criteria=111854, quest=90794, loot={{257444, mount=true}}, notes="In cave on the lower level; gather 1000x{item:259361:Vile Essence} nearby"},
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
	[7312] = {name="Reliquary's Lost Paintbrush", achievement=61263, criteria=109036, quest=92431, loot={263287, HARATI}},
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
}, true)

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

	-- Prepatch, Twilight Highlands / Two Minutes to Midnight
	-- rotation rares:
	[237853] = {name="Berg the Spellfist", locations={[241]={57607560}}, achievement=42300, criteria=105727, vignette=6755, poi={241, 8244}, notes="Next up: {npc:237997}"},
	[237997] = {name="Corla, Herald of Twilight", locations={[241]={71202990}}, achievement=42300, criteria=105730, vignette=6761, poi={241, 8244}, notes="Next up: {npc:246272}"},
	[246272] = {name="Void Zealot Devinda", locations={[241]={46702520}}, achievement=42300, criteria=105733, vignette=6988, poi={241, 8244}, notes="Next up: {npc:246343}"},
	[246343] = {name="Asira Dawnslayer", locations={[241]={45204920}}, achievement=42300, criteria=105737, vignette=6994, poi={241, 8244}, notes="Next up: {npc:246462}"},
	[246462] = {name="Archbishop Benedictus", locations={[241]={41801650}}, achievement=42300, criteria=105740, vignette=6996, poi={241, 8244}, notes="Next up: {npc:246577}"},
	[246577] = {name="Nedrand the Eyegorger", locations={[241]={65205220}}, achievement=42300, criteria=105743, vignette=7008, poi={241, 8244}, notes="Next up: {npc:246840}"},
	[246840] = {name="Executioner Lynthelma", locations={[241]={57607560}}, achievement=42300, criteria=105728, vignette=7042, poi={241, 8244}, notes="Next up: {npc:246565}"},
	[246565] = {name="Gustavan, Herald of the End", locations={[241]={71202990}}, achievement=42300, criteria=105731, vignette=7005, poi={241, 8244}, notes="Next up: {npc:246578}"},
	[246578] = {name="Voidclaw Hexathor", locations={[241]={46702520}}, achievement=42300, criteria=105734, vignette=7009, poi={241, 8244}, notes="Next up: {npc:246566}"},
	[246566] = {name="Mirrorvise", locations={[241]={45204920}}, achievement=42300, criteria=105738, vignette=7006, poi={241, 8244}, notes="Next up: {npc:246558}"},
	[246558] = {name="Saligrum the Observer", locations={[241]={41801650}}, achievement=42300, criteria=105741, vignette=7003, poi={241, 8244}, notes="Next up: {npc:246572}"},
	[246572] = {name="Redeye the Skullchewer", locations={[241]={65005260}}, achievement=42300, criteria=105744, vignette=7007, poi={241, 8244}, notes="Next up: {npc:246844}"},
	[246844] = {name="T'aavihan the Unbound", locations={[241]={57607560}}, achievement=42300, criteria=105729, vignette=7043, poi={241, 8244}, notes="Next up: {npc:246460}"},
	[246460] = {name="Ray of Putrescence", locations={[241]={71003080}}, achievement=42300, criteria=105732, vignette=6995, poi={241, 8244}, notes="Next up: {npc:246471}"},
	[246471] = {name="Ix the Bloodfallen", locations={[241]={46702520}}, achievement=42300, criteria=105736, vignette=6997, poi={241, 8244}, notes="Next up: {npc:246478}"},
	[246478] = {name="Commander Ix'vaarha", locations={[241]={45204880}}, achievement=42300, criteria=105739, vignette=6998, poi={241, 8244}, notes="Next up: {npc:246559}"},
	[246559] = {name="Sharfadi, Bulwark of the Night", locations={[241]={41801650}}, achievement=42300, criteria=105742, vignette=7004, poi={241, 8244}, notes="Next up: {npc:246549}"},
	[246549] = {name="Ez'Haadosh the Liminality", locations={[241]={65205220}}, achievement=42300, criteria=105745, vignette=7001, poi={241, 8244}, notes="Next up: {npc:237853}"},
	-- ephemeral void:
	[253378] = {name="Voice of the Eclipse", locations={[241]={56507320,40101420,48702400,69102950,67005320,47204560,}}, achievement=42300, criteria=109583, vignette=7340, poi={241, 8244},},

	-- Ignored
	[250788] = {name="Lovely Sunflower", hidden=true}, -- Waverly's spawn
}, true)

ns.RegisterPoints(ns.ISLEOFQUELDANAS, {
	[55712913] = {
		label="Tarhu the Ransacker",
		quest=95011,
		npc=252465,
		loot={
			267271, -- Nethersteel Deflectors
		},
		vignette=7325,
	},
	[37093830] = {
		label="Dripping Shadow",
		quest=95010,
		npc=239864,
		loot={
			267270, -- Shadow-Drenched Legguards
		},
		vignette=7155,
	},
})

-- A Bloody Song
ns.RegisterPoints(ns.EVERSONGWOODS, {
	[52627532] = {
		label="Warden of Weeds",
		criteria=110166, quest=91280, -- 94681
		npc=246332,
		loot={
			264520, -- Warden's Leycrook
			264613, -- Steelbark Bulwark
		},
		vignette=7363,
	},
	[45097760] = {
		label="Harried Hawkstrider",
		criteria=110167, quest=91315,
		npc=246633,
		loot={
			-- 251791, -- Holy Retributor's Order
			264521, -- Striderplume Focus
			264522, -- Striderplume Armbands
			258912, -- Tarnished Dawnlit Spellbinder's Robe
		},
		vignette=7002,
		note="Runs around nearby",
	},
	[54806020] = {
		label="Overfester Hydra",
		criteria=110168, quest=92392,
		npc=240129,
		loot={
			-- 251791, -- Holy Retributor's Order
			264523, -- Hydrafang Blade
			264524, -- Lightblighted Verdant Vest
		},
	},
	[36566407] = {
		label="Bloated Snapdragon",
		criteria=110169, quest=92366, -- 94685
		npc=250582,
		loot={
			-- 251788, -- Gift of Light
			264543, -- Snapdragon Pantaloons
			264560, -- Sharpclaw Gauntlets
			260647, -- Digested Human Hand
		},
		vignette=7294,
	},
	[62964878] = {
		label="Cre'van",
		criteria=110170, quest=92391,
		npc=250719,
		loot={
			-- 251791, -- Holy Retributor's Order
			264573, -- Taskmaster's Sadistic Shoulderguards
			264647, -- Cre'van's Punisher
			265803, -- Bazaar Bites
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
		},
		vignette=7298,
	},
	[36657719] = {
		label="Lady Liminus",
		criteria=110172, quest=92393, -- 94688
		npc=250754,
		loot={
			-- 251791, -- Holy Retributor's Order
			264612, -- Tarnished Gold Locket
			264645, -- Aged Farstrider Bow
			260655, -- Decaying Humanoid Flesh
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
		},
		vignette=7306,
	},
	[49048777] = {
		label="Bad Zed",
		criteria=110174, quest=92404, -- 94690
		npc=250841,
		loot={
			-- 251791, -- Holy Retributor's Order
			-- 251788, -- Gift of Light
			264621, -- Bad Zed's Worst Channeler
			265803, -- Bazaar Bites
		},
		vignette=7305,
	},
	[34812098] = {
		label="Waverly",
		criteria=110175, quest=92395,
		npc=250780, -- 250788 for Lovely Sunflower
		loot={
			-- 251788, -- Gift of Light
			260694, -- Foul Kelp
			264608, -- String of Lovely Blossoms
			264910, -- Shell-Cleaving Poleaxe
		},
		vignette=7302,
	},
	[56427760] = {
		label="Banuran",
		criteria=110176, quest=92403, -- 94692
		npc=250826,
		loot={
			-- 251788, -- Gift of Light
			264526, -- Supremely Slimy Sash
			264552, -- Frogskin Grips
			-- 265027, -- Lucky Lynx Locket
		},
		vignette=7304,
	},
	[59107924] = {
		label="Lost Guardian",
		criteria=110177, quest=92399, -- 94693
		npc=250806,
		loot={
			264555, -- Splintered Hexwood Clasps
			264575, -- Hexwood Helm
		},
		vignette=7303,
	},
	[42176897] = {
		label="Duskburn",
		criteria=110178, quest=93550, -- 94694
		npc=255302,
		loot={
			264569, -- Void-Gorged Kickers
			264594, -- Netherscale Cloak
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
		},
		vignette=7399,
	},
	[44573817] = {
		label="Dame Bloodshed",
		criteria=110180, quest=93561, -- 94696
		npc=255348,
		loot={
			-- 251788, -- Gift of Light
			-- 251791, -- Holy Retributor's Order
			264595, -- Lynxhide Shawl
			264624, -- Fang of the Dame
		},
		note="Wanders",
		vignette=7404,
	},
}, {
	achievement=61507,
})

-- Tallest Tree in the Forest
ns.RegisterPoints(ns.ZULAMAN, {
	[34393304] = {
		label="Necrohexxer Raz'ka",
		criteria=111839, quest=89569, -- 94683
		npc=242023,
		loot={
			251783, -- Lost Idol of the Hash'ey
			264527, -- Vile Hexxer's Mantle
			264611, -- Pendant of Siphoned Vitality
			265543, -- Tempered Amani Spearhead
		},
		vignette=6895,
	},
	[51881875] = {
		label="The Snapping Scourge",
		criteria=111840, quest=89570, -- 94697
		npc=242024,
		loot={
			264585, -- Snapper Steppers
			264617, -- Scourge's Spike
		},
		vignette=6896,
	},
	[51847292] = {
		label="Skullcrusher Harak",
		criteria=111841, quest=89571, -- 94698
		npc=242025,
		loot={
			251783, -- Lost Idol of the Hash'ey
			251784, -- Sylvan Wakrapuku
			264542, -- Skullcrusher's Mantle
			264631, -- Harak's Skullcutter
			265560, -- Toughened Amani Leather Wrap
		},
		vignette=6897,
	},
	[28832450] = {
		label="Lightwood Borer",
		criteria=111842, quest=89575, -- 94699
		npc=242028,
		loot={
			251784, -- Sylvan Wakrapuku
			264640, -- Sharpened Borer Claw
		},
		vignette=6900,
	},
	[50866517] = {
		label="Mrrlokk",
		criteria=111843, quest=91174, -- 94700
		npc=245975,
		loot={
			251783, -- Lost Idol of the Hash'ey
			264570, -- Reinforced Chainmrrl
			264580, -- Mrrlokk's Mrgl Grrdle
			265543, -- Tempered Amani Spearhead
		},
		vignette=6977,
	},
	[30574456] = {
		label="Spinefrill",
		criteria=111845, quest=89578, -- 94702
		npc=242031,
		loot={
			264554, -- Frilly Leather Vest
			264620, -- Pufferspine Spellpierce
		},
		vignette=6903,
	},
	[46555127] = {
		label="Oophaga",
		criteria=111846, quest=89579, -- 94703
		npc=242032,
		loot={
			264528, -- Goop-Coated Leggings
			264541, -- Egg-Swaddling Sash
		},
		vignette=6904,
	},
	[47763435] = {
		label="Tiny Vermin",
		criteria=111847, quest=89580,
		npc=242033,
		loot={
			251784, -- Sylvan Wakrapuku
			264648, -- Verminscale Gavel
			264597, -- Leechtooth Band
		},
		vignette=6905,
	},
	[21547051] = {
		label="Voidtouched Crustacean",
		criteria=111848, quest=89581, --94705
		npc=242034,
		loot={
			264586, -- Crustacean Carapace Chestguard
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
		},
		note="In cave at the bottom of the chasm",
		vignette=6907,
	},
	[33688897] = {
		label="Elder Oaktalon",
		criteria=111850, quest=89572, -- 94707
		npc=242026,
		loot={
			264547, -- Worn Furbolg Bindings
			264529, -- Cover of the Furbolg Elder
		},
		vignette=6898,
	},
	[47662052] = {
		label="Depthborn Eelamental",
		criteria=111851, quest=89573, -- 94708
		npc=242027,
		loot={
			251784, -- Sylvan Wakrapuku
			264618, -- Strangely Eelastic Blade
		},
		vignette=6899,
	},
	[46394339] = {
		label="The Decaying Diamondback",
		criteria=111852, quest=91072,
		npc=245691,
		vignette=6971,
	},
	[45284171] = {
		label="Ash'an the Empowered",
		criteria=111853, quest=91073,
		npc=245692,
		vignette=6972,
	},
}, {
	achievement=62122,
})

ns.RegisterPoints(ns.ATALAMAN, {
	[82972145] = {
		label="Poacher Rav'ik",
		criteria=111844, quest=91634, -- 94701
		npc=247976,
		loot={
			264627, -- Rav'ik's Spare Hunting Spear
			264911, -- Forest Hunter's Arc
		},
		vignette=7117,
	},
}, {
	achievement=62122,
	parent=true,
})


-- Leaf None Behind
ns.RegisterPoints(ns.HARANDAR, {
	[51174530] = {
		label="Rhazul",
		criteria=109039, quest=91832, -- 94712
		npc=248741,
		loot={
			264530, -- Grimfur Mittens
		},
		vignette=7139,
	},
	[68014033] = {
		label="Chironex",
		criteria=109040, quest=92137, -- 94713
		npc=249844,
		loot={
			264538, -- Translucent Membrane Slippers
		},
		vignette=7156,
	},
	[67696228] = {
		label="Ha'kalawe",
		criteria=109041, quest=92142, -- 94714
		npc=249849,
		loot={
			252957, -- Tangle of Vibrant Vines
			264553, -- Deepspore Leather Galoshes
			264592, -- Ka'kalawe's Flawless Wing
		},
		note="Wanders",
		vignette=7157,
	},
	[72636926] = {
		label="Tallcap the Truthspreader",
		criteria=109042, quest=92148, -- 94715
		npc=249902,
		loot={
			264650, -- Truthspreader's Truth Spreader
		},
		vignette=7158,
	},
	[60104701] = {
		label="Queen Lashtongue",
		criteria=109043, quest=92154, -- 94716
		npc=249962,
		loot={
			251782, -- Withered Saptor's Paw
			264895, -- Trials of the Florafaun Hunter
		},
		vignette=7159,
	},
	[64904810] = {
		label="Chlorokyll",
		criteria=109044, quest=92161, -- 94717
		npc=249997,
		loot={
			264626, -- Scepter of Radiant Conversion
		},
		vignette=7161,
	},
	[65653279] = {
		label="Stumpy",
		criteria=109045, quest=92168,
		npc=250086,
		vignette=7162,
	},
	[56783422] = {
		label="Serrasa",
		criteria=109046, quest=92170,
		npc=250180,
		loot={
			264568, -- Serrated Scale Gauntlets
		},
		vignette=7163,
	},
	[46353284] = {
		label="Mindrot",
		criteria=109047, quest=92172, -- 94720
		npc=250226,
		loot={
			264649, -- Mindrot Claw-Hammer
		},
		vignette=7164,
	},
	[40654299] = {
		label="Dracaena",
		criteria=109048, quest=92176, -- 94721
		npc=250231,
		loot={
			264562, -- Plated Grove Vest
			264644, -- Crawler's Mindscythe
		},
		vignette=7165,
	},
	[36597516] = {
		label="Treetop",
		criteria=109049, quest=92183, -- 94722
		npc=250246,
		loot={
			-- {246735,mount=true,}, -- Rootstalker Grimlynx (all zone rares?)
			264633, -- Treetop Battlestave
			264968, -- Telluric Leyblossom
			264581, -- Bloombark Spaulders
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
		},
		vignette=7167,
	},
	[27197021] = {
		label="Pterrock",
		criteria=109051, quest=92191, -- 94724
		npc=250321,
		loot={
			259896, -- Bark of the Guardian Tree
			264576, -- Slatescale Grips
		},
		vignette=7168,
	},
	[39696070] = {
		label="Ahl'ua'huhi",
		criteria=109052, quest=92193, -- 94725
		npc=250347,
		loot={
			264534, -- Bogvine Shoulderguards
			264540, -- Mirevine Wristguards
		},
		vignette=7171,
	},
	[44501610] = {
		label="Annulus the Worldshaker",
		criteria=109053, quest=92194,
		npc=250358,
		vignette=7172,
	},
}, {
	achievement=61264,
})

-- The Ultimate Predator
ns.RegisterPoints(ns.VOIDSTORM, {
	[29515008] = {
		label="Sundereth the Caller",
		criteria=111877, quest=90805, -- 94728
		npc=244272,
		loot={
			264619, -- Nethersteel Spellblade
			264539, -- Robes of the Voidcaller
		},
		vignette=6949,
	},
	[34028218] = {
		label="Territorial Voidscythe",
		criteria=111878, quest=91050, -- 94729
		npc=238498,
		loot={
			264565, -- Voidscale Shoulderpads
			264642, -- Carving Voidscythe
		},
		vignette=6961,
	},
	[36308373] = {
		label="Tremora",
		criteria=111879, quest=91048, -- 94730
		npc=241443,
		loot={
			251786, -- Ever-Collapsing Void Fissure
		},
		path=37498452, -- or 35678113
		note="In the tunnel",
		vignette=6962,
	},
	[43685151] = {
		label="Screammaxa the Matriarch",
		criteria=111880, quest=93966, -- 94731
		npc=256922,
		loot={
			264583, -- Barbute of the Winged Hunter
		},
		vignette=7436,
	},
	[47058063] = {
		label="Bane of the Vilebloods",
		criteria=111881, quest=93946, -- 94732
		npc=256923,
		loot={
			264572, -- Netherplate Clasp
		},
		note="In cave",
		vignette=7433,
	},
	[39246394] = {
		label="Aeonelle Blackstar",
		criteria=111882, quest=93944, -- 94751
		npc=256924,
		loot={
			264549, -- Ever-Devouring Shoulderguards
			264637, -- Cosmic Hunter's Glaive
		},
		note="In cave at lowest level",
		vignette=7432,
	},
	[37887178] = {
		label="Lotus Darkblossom",
		criteria=111883, quest=93947, -- 94758
		npc=256925,
		loot={
			251786, -- Ever-Collapsing Void Fissure
			264632, -- Darkblossom's Crook
			264548, -- Sash of Cosmic Tranquility
		},
		vignette=7434,
	},
	[55727945] = {
		label="Queen o' War",
		criteria=111884, quest=93934, -- 94761
		npc=256926,
		loot={
			251786, -- Ever-Collapsing Void Fissure
			264533, -- Queen's Tentacle Sash
			264601, -- Queen's Eye Band
		},
		note="Use the Crown",
		vignette=7430,
	},
	[48815317] = {
		label="Ravengerus",
		criteria=111885, quest=93895, -- 94763
		npc=256808,
		loot={
			264535, -- Leggings of the Cosmic Harrower
		},
		vignette=7426,
	},
	[35485023] = {
		label="Bilemaw the Gluttonous",
		criteria=111887, quest=93884, -- 94752
		npc=256770,
		loot={
			264623, -- Shredding Fang
		},
		path=35604931,
		vignette=7422,
	},
	[40154119] = {
		label="Nightbrood",
		criteria=111889, quest=91051, -- 94759
		npc=245044,
		loot={
			251786, -- Ever-Collapsing Void Fissure
			264574, -- Netherterror's Legplates
		},
		vignette=6964,
	},
	[53946272] = {
		label="Far'thana the Mad",
		criteria=111890, quest=93896, -- 94755
		npc=256821,
		loot={
			251786, -- Ever-Collapsing Void Fissure
		},
		vignette=7428,
	},
}, {
	achievement=62130,
})

ns.RegisterPoints(ns.SLAYERSRISE, {
	[41268981] = {
		label="Eruundi",
		criteria=111888, quest=91047, -- 94754
		npc=245182,
		loot={
			264701, -- Cosmic Bell
		},
		vignette=6963, -- vignette position APIs don't work on this one...
	},
	[46384093] = {
		label="Rakshur the Bonegrinder",
		criteria=111886, quest=93953, -- 94762
		npc=257027,
		loot={
			264630, -- Colossal Voidsunderer
		},
		vignette=7435,
	},
}, {
	achievement=62130,
	parent=true,
})

ns.RegisterPoints(ns.VOIDSTORM, {
	[30576661] = {
		label="Voidseer Orivane",
		quest=94459, -- v
		npc=248791,
		loot={},
		vignette=7140,
	},
	[28827024] = {
		label="The Many-Broken",
		quest=94458, -- v
		npc=248459, -- 248461, 248462
		loot={},
		vignette=7133,
	},
	[28156593] = {
		label="Abysslick",
		quest=94462, -- v
		npc=248700,
		loot={},
		vignette=7138,
	},
	[29806787] = {
		label="Nullspiral",
		quest=94460, -- v
		npc=248068,
		loot={},
		vignette=7129,
	},
})

ns.RegisterPoints(ns.SLAYERSRISE, {
	[28465684] = {
		label="Hardin Steellock",
		quest=94461, -- v
		npc=257199,
		loot={
			264615, -- Hardin's Backup Blade
		},
		faction="Horde",
		vignette=7442,
	},
	[69687730] = {
		label="Gar'chak Skullcleave",
		quest=94461, -- v
		npc=257231,
		loot={
			264609, -- Gar'chak's Mark of Honor
		},
		faction="Alliance",
		vignette=7445,
	},
}, {
	parent=true,
})
