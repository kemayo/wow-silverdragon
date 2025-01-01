if LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_WAR_WITHIN or math.huge) then return end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

-- Handynotes imports
--[[
minor transformations applied:
s/(?<= ){ -- (.+)$/{\n\t\tlabel="$1",/g",
--]]

-- Stub time!
local ns = {
	RegisterPoints = function(...)
		core:RegisterHandyNotesData("WarWithin", ...)
	end,
	rewards = core.rewards,
	conditions = core.conditions,
	MAXLEVEL = core.conditions.Level(80),
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

ns.KHAZALGAR = 2274
ns.DORNOGAL = 2339
ns.ISLEOFDORN = 2248
ns.RINGINGDEEPS = 2214
ns.HALLOWFALL = 2215
ns.AZJKAHET = 2255
ns.AZJKAHETLOWER = 2256
ns.CITYOFTHREADS = 2213
ns.CITYOFTHREADSLOWER = 2216
ns.SIRENISLE = 2369
ns.FORGOTTENVAULT = 2375

ns.WORLDQUESTS = ns.conditions.QuestComplete(79573)
-- ns.MAXLEVEL = {ns.conditions.QuestComplete(67030), ns.conditions.Level(70)}
-- ns.DRAGONRIDING = ns.conditions.SpellKnown(376777)

ns.FACTION_DORNOGAL = 2590
ns.FACTION_ARATHI = 2570
ns.FACTION_ASSEMBLY = 2594
ns.FACTION_SEVERED = 2600
ns.FACTION_SEVERED_WEAVER = 2601
ns.FACTION_SEVERED_GENERAL = 2605
ns.FACTION_SEVERED_VIZIER = 2607

ns.CURRENCY_DORNOGAL = 2897
ns.CURRENCY_ARATHI = 2899
ns.CURRENCY_ASSEMBLY = 2902
ns.CURRENCY_SEVERED = 2903
ns.CURRENCY_SEVERED_WEAVER = 3002
ns.CURRENCY_SEVERED_GENERAL = 3003
ns.CURRENCY_SEVERED_VIZIER = 3004
ns.CURRENCY_RESONANCE = 2815

ns.PROF_WW_ALCHEMY = 2871 -- spell:
ns.PROF_WW_BLACKSMITHING = 2872 -- spell:423332
ns.PROF_WW_COOKING = 2873 -- spell:
ns.PROF_WW_ENCHANTING = 2874 -- spell:
ns.PROF_WW_ENGINEERING = 2875 -- spell:
ns.PROF_WW_FISHING = 2876
ns.PROF_WW_HERBALISM = 2877
ns.PROF_WW_INSCRIPTION = 2878 -- spell:
ns.PROF_WW_JEWELCRAFTING = 2879 -- spell:
ns.PROF_WW_LEATHERWORKING = 2880 -- spell:
ns.PROF_WW_MINING = 2881
ns.PROF_WW_SKINNING = 2882
ns.PROF_WW_TAILORING = 2883 -- spell:

local addThreadsRep = function(amount, quest, loot, append)
	local extra = quest and {quest=quest}
	table.insert(loot, append and #loot+1 or 1, ns.rewards.Currency(ns.CURRENCY_SEVERED_WEAVER, amount, extra))
	table.insert(loot, append and #loot+1 or 2, ns.rewards.Currency(ns.CURRENCY_SEVERED_GENERAL, amount, extra))
	table.insert(loot, append and #loot+1 or 3, ns.rewards.Currency(ns.CURRENCY_SEVERED_VIZIER, amount, extra))
	return loot
end

-- Treasures

core:RegisterTreasureData("WarWithin", {
	-- Isle of Dorn
	[6210] = {
		name="Tree's Treasure",
		achievement=40434, criteria=68197,
		quest=83242, -- 82160 when treasure appears
		loot={{224585, toy=true}}, -- Hanna's Locket
		notes="In cave; talk to {npc:222940:Freysworn Letitia} for a {item:224185:Crab-Guiding Branch}, then go find {npc:222941:Pearlescent Shellcrab} around the zone",
	},
	[6224] = {
		name="Magical Treasure Chest",
		achievement=40434, criteria=68199,
		quest=83243, -- 82212 for giving Lionel crabs
		loot={{224579, pet=3362}}, -- Sapphire Crab
		notes="Push {npc:223104:Lionel} into the water, talk to it, then go gather 5x {item:223159:Plump Snapcrab} nearby",
	},
	[6208] = {
		name="Mysterious Orb",
		achievement=40434, criteria=68201,
		quest=83244, -- 82047 after talking, 82134 after giving, also 82252 when looted
		loot={224373}, -- Waterlord's Iridescent Gem
		notes="Talk to {npc:222847:Weary Water Elemental}, then go fetch its {item:221504:Elemental Pearl}",
	},
	[6209] = {
		name="Mushroom Cap",
		achievement=40434, criteria=68202,
		quest=83245, -- 82142 after giving cap, 82253 as well on loot
		loot={210796}, -- Mycobloom
		notes="Talk to {npc:222894:U'llort the Self-Exiled} then fetch a {item:221550:Boskroot Cap} from the nearby woods",
	},
	[6236] = {
		name="Thak's Treasure",
		achievement=40434, criteria=68203,
		quest=82246,
		loot={
			212498, -- Ambivalent Amber
			212511, -- Ostentatious Onyx
		},
		notes="Talk to {npc:223227:One-Eyed Thak} and follow him to the treasure",
	},
	[6212] = {
		name="Lost Mosswool (Mosswool Flower)",
		achievement=40434, criteria=68204,
		quest=82145, -- when flower spawns
		loot={{224450, pet=4527}}, -- Lil' Moss Rosy
		notes="Chase {npc:222956:Lost Mosswool} to the flower",
	},
	[6238] = {
		name="Mosswool Flower",
		achievement=40434, criteria=68204,
		quest=83246, -- 82251 also when looted
		loot={{224450, pet=4527}}, -- Lil' Moss Rosy
		requires=ns.conditions.QuestComplete(82145),
		notes="Chase {npc:222956:Lost Mosswool} to the flower; if another player has recently looted if you may have to wait for it to appear",
	},
	[6273] = {
		name="Kobold Pickaxe",
		achievement=40434, criteria=68205,
		quest=82325,
		loot={223484}, -- Kobold Mastermind's "Pivel"
		notes="Despawns for a while after someone loots it, so you might need to wait around",
	},
	[6262] = {
		name="Jade Pearl",
		achievement=40434, criteria=68206,
		quest=82287,
		loot={223280}, -- Jade Pearl
		note="Despawns for a while after someone loots it, so you might need to wait around",
	},
	[6274] = {
		name="Shimmering Opal Lily",
		achievement=40434, criteria=68207,
		quest=82326,
		loot={
			213197, -- Null Lotus
			210800, -- Luredrop
		},
		path=47316149,
		notes="At the bottom of the cave; despawns for a while after someone loots it, so you might need to wait around",
	},
	[6292] = {
		name="Infused Cinderbrew",
		achievement=40434, criteria=68208,
		quest=82714,
		loot={224263}, -- Infused Fire-Honey Milk
		notes="On the desk; despawns for a while after someone loots it, so you might need to wait around"
	},
	[6293] = {
		name="Web-Wrapped Axe",
		achievement=40434, criteria=68209,
		quest=82715,
		loot={224290}, -- Storm Defender's Axe
		notes="Inside the building; despawns for a while after someone loots it, so you might need to wait around",
	},

	-- Turtle's Thanks
	[6244] = {
		name="Dalaran Sewer Turtle",
		achievement=40434, criteria=68198,
		quest=79585, -- pike
		loot={{224549,pet=4594}}, -- Sewer Turtle Whistle
		notes="Give {npc:223338:Dalaran Sewer Turtle} 5x {item:220143:Dornish Pike}, then leave the area and return to give it 1x {item:222533:Goldengill Trout}. Then go find it again in Dornegal.",
		active=ns.conditions.Item(220143, 5),
	},
	[6245] = {
		name="Dalaran Sewer Turtle",
		achievement=40434, criteria=68198,
		quest=79586, -- trout
		loot={{224549,pet=4594}}, -- Sewer Turtle Whistle
		note="Give {npc:223338:Dalaran Sewer Turtle} 1x {item:222533:Goldengill Trout}. Then go find it again in Dornegal.",
		active=ns.conditions.Item(222533),
	},
	[6246] = {
		name="Dalaran Sewer Turtle",
		achievement=40434, criteria=68198,
		quest=82255,
		loot={{224549,pet=4594}}, -- Sewer Turtle Whistle
		requires=ns.conditions.QuestComplete(79586), -- moves here
		notes="Talk to the turtle to spawn the treasure",
	},
	[6579] = {
		name="Turtle's Thanks",
		achievement=40434, criteria=68198,
		quest=82716, -- final!, also  when treasure spawns
		loot={{224549,pet=4594}}, -- Sewer Turtle Whistle
		requires=ns.conditions.QuestComplete(79586), -- moves here
		notes="Talk to the turtle to spawn the treasure",
	},

	-- Ringing Deeps
	[6286] = {
		name="Dusty Prospector's Chest",
		achievement=40724, criteria=69312,
		quest=82464,
		loot={212495, 212505, 212508}, -- some gems
		requires={ns.conditions.Level(71), ns.conditions.Item(223878), ns.conditions.Item(223879), ns.conditions.Item(223880), ns.conditions.Item(223881), ns.conditions.Item(223882)},
		notes="At the back of the inn; gather the five shards first",
	},
	[5994] = {
		name="Webbed Knapsack",
		achievement=40724, criteria=69280,
		quest=79308,
		loot={
			213254, -- Big Gold Nugget
			213251, -- Cinderbee Wax Jar
			213250, -- Cracked Gem
			213253, -- Gilded Candle
			213255, -- Wax Canary
			213252, -- Stolen Earthen Contraption
			213257, -- Wax Shovel
		},
		level=71,
		notes="In cave",
	},
	[6232] = {
		name="Cursed Pickaxe",
		achievement=40724, criteria=69281,
		quest=82230,
		loot={224837}, -- Cursed Pickaxe
		level=71,
	},
	[6233] = {
		name="Munderut's Forgotten Stash",
		achievement=40724, criteria=69282,
		quest=82235,
		loot={212498}, -- Ambivalent Amber + commendations
		level=71,
	},
	[6235] = {
		name="Discarded Toolbox",
		achievement=40724, criteria=69283,
		quest=82239,
		loot={224644}, -- Lava-Forged Cogwhee
		level=73,
	},
	[6356] = {
		name="Waterlogged Refuse",
		achievement=40724, criteria=69304,
		quest=83030,
		loot={213250, 213255, 213253, 213254}, -- various grays
		level=71,
	},
	[6277] = {
		name="Scary Dark Chest",
		achievement=40724, criteria=69307,
		quest=82818,
		loot={{224439, pet=4470}}, -- Oop'lajax
		level=71,
	},
	[6241] = {
		name="Kaja'Cola Machine",
		achievement=40724, criteria=69308,
		quest=82819,
		loot={220774}, -- Goblin Mini Fridge
		notes="Order four drinks in the right order: Bluesberry, Orange, Oyster, Mangoro (BOOM!)",
	},
	[6284] = {
		name="Dislodged Blockage",
		achievement=40724, criteria=69311,
		quest=82820,
		loot={{221548, pet=4536}}, -- Blightbud
		notes="Solve a sliding-tiles puzzle",
		level=71, -- can solve the puzzle, but not loot the chest
	},
	[6074] = {
		name="Forgotten Treasure",
		achievement=40724, criteria=69313,
		quest=80485, -- chests: 80488, 80489, 80490, 80487
		loot={{224783, toy=true}},
		notes="Cave behind the waterfall; open chests until you find the key",
		level=71,
	},

	-- Hallowfall
	[6367] = {
		name="Caesper",
		achievement=40848, criteria=69692,
		quest=83263,
		loot={
			225639, -- Recipe: Exquisitely Eviscerated Muscle
			225592, -- Exquisitely Eviscerated Muscle
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		notes="Bring {item:225238:Meaty Haunch} from {npc:217645:Torran Dellain}, give to {npc:225948:Caesper}, follow to the treasure",
		level=73,
	},
	[6366] = {hidden=true}, -- Disturbed Lynx Treasure
	[6368] = {hidden=true}, -- Caesper post-feeding
	[6370] = {
		name="Smuggler's Treasure",
		achievement=40848, criteria=69693,
		quest=83273,
		loot={
			226021, -- Jar of Pickles
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		notes="Get the key from the {npc:226025:Dead Arathi} below",
		level=73,
	},
	[6372] = {
		name="Dark Ritual",
		achievement=40848, criteria=69694,
		quest=83284,
		loot={
			225693, -- Shadowed Essence
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		notes="In cave; use the book, defeat the summoned monsters",
		level=73,
	},
	[6371] = {hidden=true}, -- post-defeat
	[6373] = {
		name="Arathi Loremaster",
		achievement=40848, criteria=69695,
		quest=83298, -- questions trip 83300, 83301, 83302, 83303, 83304, 83305
		loot={
			{225659, toy=true}, -- Arathi Book Collection
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		notes="Answer riddles from {npc:221630:Ryfus Sacredpyr}; you need to find the books for {achievement:40622:Biblo Archivist} for the correct answers to appear",
		level=73, -- not to talk to him, but to get any of the books for answers...
	},
	[6174] = {
		name="Jewel of the Cliffs",
		achievement=40848, criteria=69697,
		quest=81971,
		loot={
			224580, -- Massive Sapphire Chunk
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		notes="High up on the rocks",
		level=75,
	},
	[6175] = {
		name="Priory Satchel",
		achievement=40848, criteria=69698,
		quest=81972,
		loot={
			224578, -- Arathor Courier's Satchel
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		level=75,
		notes="Hanging from the cathedral",
	},
	[6177] = {
		name="Lost Necklace", -- Lost Memento
		achievement=40848, criteria=69699,
		quest=81978,
		loot={
			224575, -- Lightbearer's Pendant
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		level=75,
	},
	[6098] = {
		name="Illuminated Footlocker",
		achievement=40848, criteria=69701,
		quest=81468,
		loot={
			{224552, toy=true}, -- Cave Spelunker's Torch
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		notes="In cave. Catch falling glimmers from {npc:220703:Starblessed Glimmerfly} until you get {spell:442529:Glimmering Illumination}",
		level=73,
	},
	[5989] = {
		name="Spore-covered Coffer",
		achievement=40848, criteria=69702,
		quest=79275,
		loot={
			-- alchemy mats
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		notes="In cave",
		level=73,
	},
	[6181] = {
		name="Sky-Captains' Sunken Cache",
		achievement=40848, criteria=69700,
		quest=82005,
		loot={
			{224554, toy=true}, -- Silver Linin' Scepter
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		active={ns.conditions.QuestComplete(82012), ns.conditions.QuestComplete(82026), ns.conditions.QuestComplete(82024), ns.conditions.QuestComplete(82025)},
		notes="Talk to four skyship captains flying around the zone to make this appear",
	},

	-- Hallowfall (non-achievement)
	[6537] = {
		label="Crabber Supplies",
		quest=84342,
		loot={
			226018, -- Darkened Arathi Cape (cosmetic)
			206350, -- Radiant Remnant
			ns.rewards.Currency(ns.CURRENCY_RESONANCE, 5),
		},
		locations={[ns.HALLOWFALL]={62551633}},
	},
	[6103] = {
		label="Fisherman's Pouch",
		quest=81518,
		loot={
			206350, -- Radiant Remnant
			ns.rewards.Currency(ns.CURRENCY_RESONANCE, 3),
		},
		locations={[ns.HALLOWFALL]={56091455}},
	},

	-- Azj-Kahet
	[6288] = {
		name="Concealed Contraband",
		achievement=40828, criteria=70381,
		quest=82525,
		loot=addThreadsRep(50, false, {
			220228, -- Quartz Growth
			220237, -- Shining Amethyst Cluster
			220224, -- Iridescent Integument
		}, true),
		level=74,
		path={33846068, 33796026, 34015980, 34365949, 35555918},
	},
	[6289] = {
		name="\"Weaving Supplies\"",
		achievement=40828, criteria=69643,
		quest=82527,
		loot=addThreadsRep(50, false, {{225347, toy=true}}, true), -- Web-Vandal's Spinning Wheel
		level=74,
		notes="Collect {item:223901:Violet Silk Scrap}, {item:223902:Crimson Silk Scrap}, {item:223903:Gold Silk Scrap} from the edges of the nearby platform to unlock",
		nearby={
			74794282, -- Violet Silk Scrap
			72683967, -- Crimson Silk Scrap
			74183772, -- Gold Silk Scrap
		},
	},
	[6291] = {
		name="Nest Egg",
		achievement=40828, criteria=69645,
		quest=82529,
		loot=addThreadsRep(50, false, {{221760, pet=4513}}, true), -- Bonedrinker
		level=74,
		notes="Webbed to the ceiling",
	},
	[6280] = {
		name="Disturbed Soil",
		achievement=40828, criteria=69646,
		quest=82718,
		loot=addThreadsRep(50, false, {224816}, true), -- Nerubian Almanac
	},
	[6283] = {
		name="Missing Scout's Pack",
		achievement=40828, criteria=69650,
		quest=82722,
		loot=addThreadsRep(50, false, {
			220222, -- Everburning Lump
			211879, -- Algari Healing Potion
		}, true), -- grays and commendations
	},
	[6282] = {
		name="Niffen Stash",
		-- didn't appear until after I hit 73? Could just be a despawn-when-looted though...
		achievement=40828, criteria=69649,
		quest=82721,
		loot=addThreadsRep(50, false, {
			204730, -- Grub Grub
			204790, -- Strong Sniffin' Soup for Niffen
			204838, -- Discarded Toy
			204842, -- Red Sparklepretty
			213261, -- Niffen Smell Pouch
		}, true),
		notes="Hanging under the bridge",
	},
	[6285] = {
		name="Silk-spun Supplies",
		-- Wasn't around for ages; despawn-when-looted?
		achievement=40828, criteria=69647,
		quest=82719,
		loot=addThreadsRep(50, false, {
			224828, -- Weavercloth
			224441, -- Weavercloth Bandage
		}, true),
		path={67462755, 66882761, 66692773, 66342805, 66142810, 65582772},
	},

	-- Azj-Kahet (Lower)
	[6287] = {
		name="Memory Cache",
		achievement=40828, criteria=69615,
		quest=82520,
		loot=addThreadsRep(50, false, {{225544, pet=4599}}, true), -- Mind Slurp
		notes="Get {spell:420847:Unseeming Shift} from a nearby Extractor Storage, then kill {npc:223908:Corrupted Memory} here for a {item:223870:Cache Key}",
	},

	-- City of Threads
	[6290] = {
		name="Trapped Trove",
		achievement=40828, criteria=69644,
		quest=82727,
		loot=addThreadsRep(50, false, {{222966, pet=4473}}, true), -- Spinner
		level=74,
		notes="In the hanging building; navigate through the web traps",
	},
	[6281] = {
		name="Nerubian Offerings",
		achievement=40828, criteria=69648,
		quest=82720,
		loot=addThreadsRep(50, false, {
			225543, -- Bloodied Idol
			220236, -- Sanguineous Sac
			223899, -- Shadowed Appendage
		}, true),
		notes="In a nook beneath the platform",
	},

	-- Siren Isle
	[6683] = {
		name="Bilge Rat Supply Chest",
		quest=84529, -- 84873
		notes="Get the {item:228621:Bilge Rat Supply Key} from {npc:228582:First Mate Shellshock}",
	},
}, true)

-- Hallowfall treasures with shared loot:
do
	local standard = {
		loot={
			226019, -- Darkened Arathi Shoulderguards (cosmetic)
			206350, -- Radiant Remnant
			ns.rewards.Currency(ns.CURRENCY_RESONANCE, 3),
		},
		notes="Only visible with a light source ({item:211872:Patrol Torch}, {item:220756:Flickering Torch}, {item:217344:Sentry Flare Launcher}, etc)",
		hide_before=ns.WORLDQUESTS,
	}
	local function point(data)
		MergeTable(data, standard)
		return data
	end
	core:RegisterTreasureData("WarWithin", {
		[6352] = point{
			label="Hillhelm Lunchbox",
			quest=82996,
			locations={[ns.HALLOWFALL]={62013176, 65193399}},
		},
		[6536] = point{
			label="Surveyor's Box",
			quest=34341,
			locations={[ns.HALLOWFALL]={65432715}},
		},
		[6071] = point{
			label="Harvest Box",
			quest=80420,
			locations={[ns.HALLOWFALL]={65652946}},
		},
		[6533] = point{
			label="Fieldhand Stash",
			quest=84337,
			locations={[ns.HALLOWFALL]={64492879}},
		},
	}, true)
end
do
	local standard = {
		loot={
			226016, -- Darkened Tabard of the Arathi (cosmetic)
			206350, -- Radiant Remnant
			ns.rewards.Currency(ns.CURRENCY_RESONANCE, 3),
		},
		note="Only visible with a light source ({item:211872:Patrol Torch}, {item:220756:Flickering Torch}, {item:217344:Sentry Flare Launcher}, etc)",
		hide_before=ns.WORLDQUESTS,
	}
	local function point(data)
		MergeTable(data, standard)
		return data
	end
	core:RegisterTreasureData("WarWithin", {
		[6108] = point{
			label="Captain Lancekat's Discretionary Funds",
			quest=81612,
			path=66011863,
			locations={[ns.HALLOWFALL]={66561514}},
		},
		[6092] = point{
			label="Farmhand Stash",
			quest=80590,
			locations={[ns.HALLOWFALL]={61633265, 63073074}},
		},
		[6534] = point{
			label="Old Rotting Crate",
			quest=84339,
			locations={[ns.HALLOWFALL]={64513159, 64903330}},
		},
	}, true)
end

-- Rares

local LOC_allkhazalgar = {[ns.KHAZALGAR]={},[ns.DORNOGAL]={},[ns.ISLEOFDORN]={},[ns.RINGINGDEEPS]={},[ns.HALLOWFALL]={},[ns.AZJKAHET]={},}

core:RegisterMobData("WarWithin", {
	-- World Bosses
	[229334] = {
		name="Kordac",
		quest=81630, -- This is the world quest
		worldquest=81630,
		locations={
			-- [ns.ISLEOFDORN]={50005880},
			[ns.ISLEOFDORN]={},
		},
		loot={
			225730, -- Stone Gaze Ceinture
			225731, -- Lightseeker's Robes
			225732, -- Deep Dweller's Tabi
			225733, -- Abyssal Tendril Tights
			225734, -- Sturdy Chitinous Striders
			225735, -- Dornish Warden's Coat
			225745, -- Crystal Star Cuisses
			225746, -- Girdle of the Gleaming Dawn
			225748, -- Seal of the Silent Vigil
		},
	},
	[220999] = {
		name="Aggregation of Horrors",
		quest=83466,
		worldquest=82653,
		locations={
			-- [ns.RINGINGDEEPS]={65008760},
			[ns.RINGINGDEEPS]={},
		},
		loot={
			225730, -- Stone Gaze Ceinture
			225731, -- Lightseeker's Robes
			225732, -- Deep Dweller's Tabi
			225733, -- Abyssal Tendril Tights
			225734, -- Sturdy Chitinous Striders
			225735, -- Dornish Warden's Coat
			225745, -- Crystal Star Cuisses
			225746, -- Girdle of the Gleaming Dawn
			225749, -- Seal of the Void-Touched
		},
	},
	[221224] = {
		name="Shurrai",
		quest=83467,
		worldquest=81653,
		locations={
			-- [ns.HALLOWFALL]={45401740},
			[ns.HALLOWFALL]={},
		},
		loot={
			225730, -- Stone Gaze Ceinture
			225731, -- Lightseeker's Robes
			225732, -- Deep Dweller's Tabi
			225733, -- Abyssal Tendril Tights
			225734, -- Sturdy Chitinous Striders
			225735, -- Dornish Warden's Coat
			225745, -- Crystal Star Cuisses
			225746, -- Girdle of the Gleaming Dawn
			225750, -- Seal of the Abyssal Terror
		},
	},
	[221067] = {
		name="Orta",
		quest=81624, -- this is the worldquest; a separate one didn't trip
		worldquest=81624,
		locations={
			-- [ns.CITYOFTHREADS]={17103340},
			[ns.CITYOFTHREADS]={},
			[ns.AZJKAHET]={},
			[ns.AZJKAHETLOWER]={},
			[ns.CITYOFTHREADSLOWER]={},
		},
		loot={
			225730, -- Stone Gaze Ceinture
			225731, -- Lightseeker's Robes
			225732, -- Deep Dweller's Tabi
			225733, -- Abyssal Tendril Tights
			225734, -- Sturdy Chitinous Striders
			225735, -- Dornish Warden's Coat
			225745, -- Crystal Star Cuisses
			225746, -- Girdle of the Gleaming Dawn
			225751, -- Seal of the Broken Mountain
		},
	},

	-- Xal'atath appears sometimes to monologue at you, but she's just a non-interactable story/dungeon element:
	[229244] = {name="Xal'atath", hidden=true},
	[229536] = {name="Xal'atath", hidden=true},
	[229635] = {name="Xal'atath", hidden=true},
	[230937] = {name="Xal'atath", hidden=true},
}, true)

-- Isle of Dorn

ns.RegisterPoints(ns.ISLEOFDORN, {
	[22985829] = {
		label="Alunira",
		criteria=68225,
		quest=82196,
		npc=219281,
		loot={{223270, mount=2176}},
		active={ns.conditions.Item(224025, 10), ns.conditions.Item(224026)},
		note="Get 10x {item:224025:Crackling Shard} from zone mobs, combine into {item:224026:Storm Vessel}, use to break the shield",
		vignette=6055,
		--route={16606120,23205840},
	},
	[72043881] = {
		label="Tephratennae",
		criteria=68229,
		quest=81923, -- 84037
		npc=221126,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84037}),
			223922, -- Cinder Pollen Cloak
			223937, -- Honey Deliverer's Leggings
		},
		-- tameable=true, -- wasp
		vignette=6112,
	},
	[57003460] = {
		label="Warphorn",
		criteria=68213,
		quest=81894,
		npc=219263,
		loot={
			223341, -- Warphorn's Resilient Mane
			223342, -- Warphorn's Resilient Chestplate
			223343, -- Warphorn's Resilient Chainmail
			223344, -- Warphorn's Resilient Vest
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
		},
		route={57003460, 58403560, 58403680, 57803780, 56603840, 56003780, 56403660, loop=true,},
		vignette=6044,
	},
	[48202703] = {
		label="Kronolith, Might of the Mountain",
		criteria=68220,
		quest=81902, -- 84031
		npc=219270,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84031}),
			221210, -- Grips of the Earth
			221254, -- Earthshatter Lance
			221507, -- Earth Golem's Wrap
		},
		vignette=6051,
	},
	[74082756] = {
		label="Shallowshell the Clacker",
		criteria=68221,
		quest=81903, -- 84032
		npc=219278,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84032}),
			221224, -- Bouldershell Waistguard
			221233, -- Deephunter's Bloody Hook
			221255, -- Sharpened Scalepiercer
			221234, -- Tidal Pendant
			221248, -- Deep Terror Carver
		},
		vignette=6052,
	},
	[41137679] = {
		label="Bloodmaw",
		criteria=68214,
		quest=81893,
		npc=219264,
		loot={
			223349, -- Wolf Packleader's Cowl
			223350, -- Wolf Packleader's Helm
			223351, -- Wolf Packleader's Hood
			223370, -- Wolf Packleader's Visor
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
		},
		vignette=6045,
	},
	[58766068] = {
		label="Springbubble",
		criteria=68212,
		quest=81892,
		npc=219262,
		loot={
			223356, -- Shoulderpads of the Steamsurger
			223357, -- Spaulders of the Steamsurger
			223358, -- Mantle of the Steamsurger (name matches, but not listed?)
			223359, -- Epaulets of the Steamsurger
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
		},
		vignette=6043,
	},
	[62776842] = {
		label="Sandres the Relicbearer",
		criteria=68211,
		quest=79685,
		npc=217534,
		loot={
			223376, -- Band of the Relic Bearer
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
		},
		vignette=6026,
	},
	[55712727] = {
		label="Clawbreaker K'zithix",
		criteria=68224,
		quest=81920, -- 84036
		npc=221128,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84036}),
			223140, -- Formula: Enchant Cloak - Chant of Burrowing Rapidity
		},
		vignette=6115,
	},
	[47946014] = {
		label="Emperor Pitfang",
		criteria=68215,
		quest=81895,
		npc=219265,
		loot={
			223345, -- Viper's Stone Grips
			223346, -- Viper's Stone Handguards
			223347, -- Viper's Stone Mitts
			223348, -- Viper's Stone Gauntlets
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
		},
		vignette=6046,
		note="At the bottom of the cave",
	},
	[25784503] = {
		label="Escaped Cutthroat",
		criteria=68218,
		quest=81907, -- 84029
		npc=219266,
		vignette=6049,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84029}),
			221208, -- Unseen Cutthroat's Tunic
			221235, -- Dark Agent's Cloak
		},
	},
	[73004010] = {
		label="Matriarch Charfuria",
		criteria=68231,
		quest=81921, -- 84039
		npc=220890,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84039}),
			223948, -- Stubborn Wolf's Greathelm
			221247, -- Cavernous Critter Shooter
			221251, -- Bestial Underground Cleaver
			221265, -- Charm of the Underground Beast
			221246, -- Fierce Beast Staff
		},
		vignette=6114,
	},
	[57461625] = {
		label="Tempest Lord Incarnus",
		criteria=68219,
		quest=81901,
		npc=219269,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84030}),
			221230, -- Storm Bindings
			221236, -- Stormbreaker's Shield
		},
		vignette=6050,
	},
	[53348006] = {
		label="Gar'loc",
		criteria=68217,
		quest=81899, -- 84028
		npc=219268,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84028}),
			221222, -- Water-Imbued Spaulders
			221234, -- Tidal Pendant
			221248, -- Deep Terror Carver
			221255, -- Sharpened Scalepiercer
			221233, -- Deephunter's Bloody Hook
		},
		vignette=6048,
	},
	[57072279] = {
		label="Twice-Stinger the Wretched",
		criteria=68222,
		quest=81904, -- 84033
		npc=219271,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84033}),
			221219, -- Silkwing Trousers
			221239, -- Spider Blasting Blunderbuss
			221506, -- Arachnid's Web-Sown Guise
		},
		-- tameable=true, -- blood beast
		vignette=6053,
	},
	[36477505] = {
		label="Rustul Titancap",
		criteria=68210,
		quest=78619,
		npc=213115,
		loot={
			223364, -- Wristwraps of the Titancap
			223365, -- Wristguards of the Titancap
			223366, -- Bracers of the Titancap
			223367, -- Cuffs of the Titancap
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
		},
		vignette=5959,
		note="Wanders the quarry",
	},
	[63994055] = {
		label="Flamekeeper Graz",
		criteria=68223,
		quest=81905, -- 84034
		npc=219279,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84034}),
			221244, -- Flamekeeper's Footpads
			221249, -- Kobold Rodent Squasher
		},
		vignette=6054,
	},
	[50876984] = {
		label="Plaguehart",
		criteria=68216,
		quest=81897, -- 84026
		npc=219267,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84026}),
			221213, -- Shawl of the Plagued
			221265, -- Charm of the Underground Beast
			221246, -- Fierce Beast Staff
			221251, -- Bestial Underground Cleaver
			221247, -- Cavernous Critter Shooter
		},
		--tameable=true, -- stag
		vignette=6047,
	},
	[69853847] = {
		label="Sweetspark the Oozeful",
		criteria=68230,
		quest=81922, -- 84038
		npc=220883,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84038}),
			223929, -- Honey Sweetener's Squeezers
			223921, -- Ever-Oozing Signet
			223920, -- Slime Deflecting Stopper
		},
		vignette=6113,
	},
	-- Violet Hold prisoners:
	-- These all technically spawn exactly at 30915238
	[29915238] = {
		label="Kereke",
		criteria=68227,
		quest=82204, -- 85160
		npc=222378,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=85160}),
			226111, -- Arakkoan Ritual Staff
			226113, -- Kereke's Flourishing Sabre
			226114, -- Windslicer's Lance
		},
		vignette=6215,
		note="Violet Hold Prisoner",
	},
	[30915238] = {
		label="Zovex",
		criteria=68226,
		quest=82203,
		npc=219284,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=85159}),
			226117, -- Dalaran Guardian's Arcanotool
			226118, -- Arcane Prisoner's Puncher
			226119, -- Arcane Sharpshooter's Crossbow
		},
		vignette=6058,
		note="Violet Hold Prisoner",
	},
	[31915238] = {
		label="Rotfist",
		criteria=68228,
		quest=82205,
		npc=222380,
		loot={
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=85161}),
			226112, -- Rotfist Flesh Carver
			226115, -- Contaminating Cleaver
			226116, -- Coagulating Phlegm Churner
		},
		vignette=6216,
		note="Violet Hold Prisoner",
	},
}, {
	achievement=40435, -- Adventurer
})

ns.RegisterPoints(ns.ISLEOFDORN, {
	[31495529] = {
		label="Malfunctioning Spire",
		quest=81891,
		npc=220068,
		loot={
			210931, -- Bismuth
			210934, -- Aqirite
			210937, -- Ironclaw Ore
			210939, -- Null Stone
			ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
		},
		vignette=6073,
	},
	-- [46003180] = {
	--     label="Rowdy Rubble",
	--     quest=81515,
	--     npc=220846,
	--     vignette=6102,
	-- },
	[69204960] = {
		label="Elusive Ironhide Maelstrom Wolf",
		quest=nil,
		npc=224515,
		requires=ns.conditions.Profession(ns.PROF_WW_SKINNING),
		active=ns.conditions.Item(219007), -- Elusive Creature Lure
	},
})

-- Ringing Deeps

ns.RegisterPoints(ns.RINGINGDEEPS, {
	[52591991] = {
		label="Automaxor",
		criteria=69634,
		quest=81674, -- 84046
		npc=220265,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84046}),
			221218, -- Reinforced Construct's Greaves
			221238, -- Pillar of Constructs
		},
		vignette=6128,
	},
	[41361692] = {
		label="Charmonger",
		criteria=69632,
		quest=81562, -- 84044
		npc=220267,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84044}),
			221209, -- Flame Trader's Gloves
			221249, -- Kobold Rodent Squasher
		},
		vignette=6104,
	},
	[42773508] = {
		label="King Splash",
		criteria=69624,
		quest=80547,
		npc=220275,
		loot={
			223352, -- Waterskipper's Legplates
			223353, -- Waterskipper's Trousers
			223354, -- Waterskipper's Chain Leggings
			223355, -- Waterskipper's Leggings
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150),
		},
		--tameable=true, -- hopper
		vignette=6088,
	},
	[66002840] = {
		label="Candleflyer Captain",
		criteria=69623,
		quest=80505,
		npc=220276,
		loot={
			223360, -- Flying Kobold's Seatbelt (plate)
			223361, -- Flying Kobold's Seatbelt (cloth)
			223362, -- Flying Kobold's Seatbelt (mail)
			223363, -- Flying Kobold's Seatbelt (leather)
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150),
		},
		note="Patrols the area",
		vignette=6080,
	},
	[50864651] = {
		label="Cragmund",
		criteria=69630,
		quest=80560, -- 84042
		npc=220269,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84042}),
			221205, -- Vest of the River
			221254, -- Earthshatter Lance
			221507, -- Earth Golem's Wrap
		},
		vignette=6090,
	},
	[55060843] = {
		label="Deepflayer Broodmother",
		criteria=69636,
		quest=80536, -- 85162
		npc=220286,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=85162}),
			221254, -- Earthshatter Lance
			221507, -- Earth Golem's Wrap
			225999, -- Earthen Adventurer's Tabard
		},
		note="Flys around anticlockwise",
		route={
			55060843, 53000880, 49560836, 49121007, 45290955, 43790822, 42650871, 44220973, 44331083, 45151312,
			43171750, 48681919, 53022244, 53751761, 56091023,
			loop=true,
		},
		vignette=6082,
	},
	[49556619] = {
		label="Aquellion",
		criteria=69625,
		quest=80557,
		npc=220274,
		loot={
			223340, -- Footguards of Shallow Waters
			223371, -- Slippers of Shallow Waters
			223372, -- Sabatons of Shallow Waters
			223373, -- Treads of Shallow Waters
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150),
		},
		vignette=6089,
	},
	[52022657] = {
		label="Zilthara",
		criteria=69629,
		quest=80506, -- 84041
		npc=220270,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84041}),
			221220, -- Basilisk Scale Pauldrons
			221246, -- Fierce Beast Staff
			221247, -- Cavernous Critter Shooter
			221251, -- Bestial Underground Cleaver
			221265, -- Charm of the Underground Beast
		},
		vignette=6079,
	},
	[57903813] = {
		label="Coalesced Monstrosity",
		criteria=69633,
		quest=81511, -- 84045
		npc=220266,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84045}),
			221226, -- Voidtouched Waistguard
			223006, -- Signet of Dark Horizons
		},
		vignette=6101,
	},
	[46701209] = {
		label="Terror of the Forge",
		criteria=69628,
		quest=80507, -- 84040
		npc=220271,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84040}),
			221233, -- Deephunter's Bloody Hook
			221234, -- Tidal Pendant
			221242, -- Forgeborn Helm
			221248, -- Deep Terror Carver
			221255, -- Sharpened Scalepiercer
		},
		vignette=6081,
		note="Walking in the lava",
	},
	[47224696] = {
		label="Kelpmire",
		criteria=69635,
		quest=81485, -- 84047
		npc=220287,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84047}),
			221204, -- Spore Giant's Stompers
			221250, -- Creeping Lasher Machete
			221253, -- Cultivator's Plant Puncher
			221264, -- Fungarian Mystic's Cluster
			223005, -- String of Fungal Fruits
		},
		vignette=6099,
	},
	[57025480] = {
		label="Rampaging Blight",
		criteria=69626,
		quest=81563,
		npc=220273,
		loot={
			223401, -- Corrupted Earthen Wristwraps
			223402, -- Corrupted Earthen Wristguards
			223403, -- Corrupted Earthen Binds
			223404, -- Corrupted Earthen Cuffs
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150),
		},
		vignette=6105,
	},
	[71654629] = {
		label="Trungal",
		criteria=69631,
		quest=80574, -- 84043
		npc=220268,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84043}),
			221228, -- Infested Fungal Wristwraps
			221250, -- Creeping Lasher Machete
			221253, -- Cultivator's Plant Puncher
			221264, -- Fungarian Mystic's Cluster
			223005, -- String of Fungal Fruits
		},
		note="Kill the {npc:220615:Root of Trungal} to spawn",
		path={72534569, 72844444},
		vignette=6126,
	},
	[68404754] = {
		label="Spore-infused Shalewing",
		criteria=69638,
		quest=81652, -- 84049
		npc=221217,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84049}),
			223918, -- Specter Stalker's Shotgun
			223919, -- Abducted Lawman's Gavel
			223942, -- Spore-Encrusted Ribbon
		},
		vignette=6121,
		note="Flies around clockwise",
		route={
			68604852, 68735012, 68675047, 68215137, 68055156, 67745171, 67535176, 67225176, 67075174, 66585120, 66244896,
			66264870, 66404840, 66234817, 65724779, 65564760, 65474737, 65534711, 65724669, 65834655, 66044644, 66944640,
			67624608, 67774620, 68094659, 68214680, 68404754,
			loop=true,
		},
	},
	[65364949] = {
		label="Hungerer of the Deeps",
		criteria=69639,
		quest=81648, -- 84048
		npc=221199,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84048}),
			221233, -- Deephunter's Bloody Hook
			221234, -- Tidal Pendant
			221248, -- Deep Terror Carver
			221255, -- Sharpened Scalepiercer
			223949, -- Dark Depth Stompers
		},
		vignette=6119,
	},
	[67085262] = {
		label="Disturbed Earthgorger",
		criteria=69640,
		quest=80003,
		npc=218393,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=84050}),
			221237, -- Lamentable Vagrant's Lantern
			223926, -- Earthgorger's Chain Bib
			223943, -- Cord of the Earthbreaker
		},
		note="Stand in the dust cloud and use {spell:437003:Stomp} several times",
		vignette=6031,
	},
	[66716881] = {
		label="Deathbound Husk",
		criteria=69627,
		quest=81566,
		npc=220272,
		loot={
			223368, -- Twisted Earthen Signet
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150),
		},
		vignette=6106,
		note="In cave",
		path=67056796,
	},
	[60887682] = {
		label="Lurker of the Deeps",
		criteria=69637,
		quest=81633, -- 85163
		npc=220285,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ASSEMBLY, 150, {quest=85163}),
			{223501, mount=2205}, -- Regurgitated Mole Reins
			221233, -- Deephunter's Bloody Hook
			221234, -- Tidal Pendant
			221248, -- Deep Terror Carver
			221255, -- Sharpened Scalepiercer
		},
		vignette=6110,
		note="Pull 5 levers across the zone at the same time to summon; they stay activated for ~10 seconds, so you'll need a group",
		related={
			[49470882] = {label="Inconspicuous Lever", note="Pull all 5 levers simultaneously to summon {npc:220285:Lurker of the Deeps}"},
			[53912530] = {label="Inconspicuous Lever", note="Pull all 5 levers simultaneously to summon {npc:220285:Lurker of the Deeps}"},
			[57612358] = {label="Inconspicuous Lever", note="Pull all 5 levers simultaneously to summon {npc:220285:Lurker of the Deeps}"},
			[59079239] = {label="Inconspicuous Lever", note="Pull all 5 levers simultaneously to summon {npc:220285:Lurker of the Deeps}"},
			[62854464] = {label="Inconspicuous Lever", note="Pull all 5 levers simultaneously to summon {npc:220285:Lurker of the Deeps}"},
		},
	},
}, {
	achievement=40837, -- Adventurer
})

ns.RegisterPoints(ns.RINGINGDEEPS, {
	[62805000] = {
		label="Slatefang",
		quest=nil,
		npc=228439,
		requires=ns.conditions.Profession(ns.PROF_WW_SKINNING),
		active=ns.conditions.Item(219008), -- Supreme Beast Lure
	},
})

-- Hallowfall

local ShadowPhase = ns.conditions._Condition:extends{classname="ShadowPhase"}
function ShadowPhase:Label()
	local shadowed = "{spell:131233:Shadowed}"
	if self:Matched() then
		return shadowed .. " " .. GARRISON_MISSION_TIMELEFT:format(self:Duration(self:NextSpawn() - (3600 * 2.5)))
	else
		-- "%s in %s"
		return WARDROBE_TOOLTIP_ENCOUNTER_SOURCE:format(shadowed, self:Duration(self:NextSpawn()))
	end
end
function ShadowPhase:Matched()
	-- if it's more than 2.5 hours away, we must be during the current event
	return self:NextSpawn() > (3600 * 2.5)
end
function ShadowPhase:NextSpawn()
	-- Shadow phase starts one hour and one minute after the daily reset, then
	-- repeating every three hours; each time it lasts for 30 minutes.
	-- (Well, the shift starts about 45 seconds after, and takes about 15
	-- seconds to play.)
	return (GetQuestResetTime() + 3600 + 60) % 10800
end
function ShadowPhase:Duration(seconds)
	if seconds > 3600 then
		return COOLDOWN_DURATION_HOURS:format(floor(seconds / 3600)) .. " " .. COOLDOWN_DURATION_MIN:format(floor((seconds % 3600) / 60))
	end
	return COOLDOWN_DURATION_MIN:format(floor(seconds / 60))
end

local SHADOWPHASE = ShadowPhase()

ns.RegisterPoints(ns.HALLOWFALL, {
	[23005922] = {
		label="Lytfang the Lost",
		criteria=69710,
		quest=81756, -- 84063
		npc=221534,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84063}),
			221207, -- Den Mother's Chestpiece
			221246, -- Fierce Beast Staff
			221251, -- Bestial Underground Cleaver
			221265, -- Charm of the Underground Beast
		},
		vignette=6145,
	},
	[63452859] = {
		label="Moth'ethk",
		criteria=69719,
		quest=82557, -- 84051
		npc=206203,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84051}),
			221240, -- Nerubian Stagshell Gouger
			221252, -- Nerubian Slayer's Claymore
			221263, -- Nerubian Venom-Tipped Dart
			223924, -- Chitin-Inscribed Vest
		},
		vignette=5958,
		note="Objective of {questname:76588}",
	},
	[44011639] = {
		label="The Perchfather",
		criteria=69711,
		quest=81791, -- 84064
		npc=221648,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84064}),
			221229, -- Perchfather's Cuffs
			221246, -- Fierce Beast Staff
			221247, -- Cavernous Critter Shooter
			221251, -- Bestial Underground Cleaver
			221265, -- Charm of the Underground Beast
		},
		vignette=6151,
	},
	[56466897] = {
		label="The Taskmaker",
		criteria=69708,
		quest=80009, -- 84061
		npc=218444,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84061}),
			221215, -- Taskmaster's Mining Cap
			221240, -- Nerubian Stagshell Gouger
			221252, -- Nerubian Slayer's Claymore
			221263, -- Nerubian Venom-Tipped Dart
		},
		vignette=6033,
	},
	[31205464] = {
		label="Grimslice",
		criteria=69706,
		quest=81761,
		npc=221551,
		loot={
			223397, -- Abyssal Hunter's Girdle
			223398, -- Abyssal Hunter's Sash
			223399, -- Abyssal Hunter's Chain
			223400, -- Abyssal Hunter's Cinch
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		route={
			31205464, 33235598, 32725814, 34135728, 34525751, 35085894, 35655746, 36495657, 36945464,
			36555280, 35625156, 35055029, 34555186, 34135204, 32725119, 33235334,
			r=0, g=1, b=1,
			loop=true,
		},
		vignette=6146,
		note="Patrols clockwise",
	},
	[43622993] = {
		label="Strength of Beledar",
		criteria=69713,
		quest=81849, -- 84066
		npc=221690,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84066}),
			221216, -- Bruin Strength Legplates
			221246, -- Fierce Beast Staff
			221247, -- Cavernous Critter Shooter
			221251, -- Bestial Underground Cleaver
			221265, -- Charm of the Underground Beast
			221508, -- Pelt of Beledar's Strength
		},
		vignette=6153,
	},
	[57046436] = {
		label="Ixlorb the Spinner",
		criteria=69704,
		quest=80006,
		npc=218426,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
			223374, -- Nerubian Weaver's Gown
			223379, -- Nerubian Weaver's Chestplate
			223380, -- Nerubian Weaver's Chainmail
			223381, -- Nerubian Weaver's Vest
			223100, -- Pattern: Vambraces of Deepening Darkness
		},
		vignette=6032, -- Ixlorb the Weaver
	},
	[62401320] = {
		label="Murkspike",
		criteria=69728,
		quest=82565, -- 84060
		npc=220771,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84060}),
			221233, -- Deephunter's Bloody Hook
			221234, -- Tidal Pendant
			221248, -- Deep Terror Carver
			221255, -- Sharpened Scalepiercer
			223934, -- Makrura's Foreboding Legplates
		},
		vignette=6123,
		note="Objective of {questname:76588}",
	},
	[64663172] = {
		label="Deathpetal",
		criteria=69721,
		quest=82559, -- 84053
		npc=206184,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84053}),
			221250, -- Creeping Lasher Machete
			221253, -- Cultivator's Plant Puncher
			221264, -- Fungarian Mystic's Cluster
			223005, -- String of Fungal Fruits
			223927, -- Vinewrapped Leather Tunic
		},
		vignette=6078,
		note="Objective of {questname:76588}",
	},
	[72136436] = {
		label="Deepfiend Azellix",
		criteria=69703,
		quest=80011,
		npc=218458,
		loot={
			223393, -- Deepfiend Spaulders
			223394, -- Deepfiend Pauldrons
			223395, -- Deepfiend Shoulderpads
			223396, -- Deepfiend Shoulder Shells
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		vignette=6035,
	},
	[64051911] = {
		label="Duskshadow",
		criteria=69724,
		quest=82562, -- 84056
		npc=221179,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84056}),
			223918, -- Specter Stalker's Shotgun
			223919, -- Abducted Lawman's Gavel
			223936, -- Shadow Bog Trousers
		},
		vignette=6122,
		note="Objective of {questname:76588}",
	},
	[36807210] = {
		label="Funglour",
		criteria=69707,
		quest=81881,
		npc=221767,
		loot={
			223377, -- Ancient Fungarian's Fingerwrap
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		vignette=6157,
	},
	[35953546] = {
		label="Sir Alastair Purefire",
		criteria=69714,
		quest=81853, -- 84067
		npc=221708,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84067}),
			221241, -- Priestly Agent's Knife
			221245, -- Righteous Path Treads
		},
		vignette=6154,
	},
	[43410990] = {
		label="Horror of the Shallows",
		criteria=69712,
		quest=81836, -- 84065
		npc=221668,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84065}),
			221211, -- Grasp of the Shallows
			221233, -- Deephunter's Bloody Hook
			221234, -- Tidal Pendant
			221248, -- Deep Terror Carver
			221255, -- Sharpened Scalepiercer
		},
		vignette=6152,
		note="Very long patrol",
		route={
			43410990, 43870879, 44520774, 45250767, 45970726, 45540662, 44870677, 44270749, 43710858, 41631452,
			41391580, 41051714, 40501821, 39731909, 36652173, 33992545, 33422650, 32912763, 31783130, 30933154,
			29993162, 29123191, 28213204, 27343238, 26553287, 26513416, 26813550, 27983757, 28633853, 29403934,
			30173998, 30764092, 30984221, 30594339, 29814381, 27194486, 26364534, 25664611, 24954700, 23314830,
			23274858, 22464885, 20774968, 19904976, 19565105, 20285138, 20865040, 21614971, 22474926,
			r=0,g=0,b=1,
		},
	},
	[73405259] = {
		label="Sloshmuck",
		criteria=69709,
		quest=79271, -- 84062
		npc=215805,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84062}),
			221223, -- Bog Beast Mantle
			221250, -- Creeping Lasher Machete
			221253, -- Cultivator's Plant Puncher
			221264, -- Fungarian Mystic's Cluster
			223005, -- String of Fungal Fruits
		},
		vignette=5988,
	},
	[52132682] = {
		label="Murkshade",
		criteria=69705,
		quest=80010,
		npc=218452,
		loot={
			223382, -- Murkshade Grips
			223383, -- Murkshade Handguards
			223384, -- Murkshade Gloves
			223385, -- Murkshade Gauntlets
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
		},
		vignette=6034,
		note="Underwater",
	},
	[67562316] = {
		label="Croakit",
		criteria=69722,
		quest=82560, -- 84054
		npc=214757,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84054}),
			221246, -- Fierce Beast Staff
			221247, -- Cavernous Critter Shooter
			221251, -- Bestial Underground Cleaver
			221265, -- Charm of the Underground Beast
			223938, -- Marsh Hopper's Spaulders
		},
		vignette=6125,
		--tameable=true, -- hopper
		note="Fish up 10x{item:211474:Shadowblind Grouper} and throw them to fill the {spell:437124:Craving} bar. Objective of {questname:76588}.",
	},
	[57304858] = {
		label="Pride of Beledar",
		criteria=69715,
		quest=81882, -- 84068
		npc=221786,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84068}),
			221225, -- Benevolent Hornstag Cinch
			221246, -- Fierce Beast Staff
			221247, -- Cavernous Critter Shooter
			221251, -- Bestial Underground Cleaver
			221265, -- Charm of the Underground Beast
			223007, -- Lance of Beledar's Pride
		},
		vignette=6159,
		-- tameable=true, -- stag
	},
	[67182424] = {
		label="Toadstomper",
		criteria=69723,
		quest=82561, -- 84055
		npc=207803,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84055}),
			223920, -- Slime Deflecting Stopper
			223921, -- Ever-Oozing Signet
			223933, -- Slime Goliath's Cap
		},
		vignette=6084,
		note="Objective of {questname:76588}",
	},
	[64802920] = {
		label="Crazed Cabbage Smacker",
		criteria=69720,
		quest=82558, -- 84052
		npc=206514,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84052}),
			211968, -- Blueprint Bundle
			221238, -- Pillar of Constructs
			223928, -- Crop Cutter's Gauntlets
			223935, -- Cabbage Harvester's Pantaloons
		},
		vignette=6120,
		note="Objective of {questname:76588}",
	},
	[60201860] = {
		label="Finclaw Bloodtide",
		criteria=69727,
		quest=82564, -- 84059
		npc=207780, -- also 220492, the mount
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84059}),
			221233, -- Deephunter's Bloody Hook
			221234, -- Tidal Pendant
			221248, -- Deep Terror Carver
			223925, -- Blood Hungerer's Chestplate
		},
		vignette=6085,
		note="Objective of {questname:76588}",
	},
	[62033212] = {
		label="Ravageant",
		criteria=69726,
		quest=82566, -- 84058
		npc=207826,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84058}),
			221240, -- Nerubian Stagshell Gouger
			221252, -- Nerubian Slayer's Claymore
			221263, -- Nerubian Venom-Tipped Dart
			223932, -- Scarab's Carapace Cap
		},
		vignette=6124,
		note="Objective of {questname:76588}",
	},
	[61623277] = {
		label="Parasidious",
		criteria=69725,
		quest=82563,
		npc=206977, -- Disturbed Dirt (206978) > Fungus Growth (206980) > Fungus Mound (206981) > Fungal Mass (206993) > Parasidious
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84057}),
			221250, -- Creeping Lasher Machete
			221264, -- Fungarian Mystic's Cluster
			223005, -- String of Fungal Fruits
			223940, -- Deranged Fungarian's Epaulets
		},
		vignette=6361,
		note="Objective of {questname:76588}. Buy {item:206670:Darkroot Grippers} from {npc:206533:Chef Dinaire}, and use them to pull {npc:206870:Shadowrooted Vine} until this spawns.",
		related={
			[64403100] = {
				label="{npc:206533:Chef Dinaire}",
				loot={206670}, -- Darkroot Grippers
				atlas="banker", minimap=true,
				note="Feed the keyflame if he's not there",
			},
		},
	},
	-- UNKNOWN LOCATION
	--[[
	[] = {
		label="Brineslash",
		criteria=69718,
		quest=80486,
		npc=220159,
		vignette=6075,
	},
	--]]
}, {
	achievement=40851,
})
-- Beledar's Spawn
ns.RegisterPoints(ns.HALLOWFALL, {
	[25825754] = {},
	[32673962] = {},
	[37207191] = {},
	[37744585] = {},
	[38382474] = {},
	[42733133] = {},
	[45252569] = {},
	[47015504] = {},
	[48853197] = {},
	[50514857] = {},
	[51427080] = {},
	[54833679] = {},
	[58034885] = {},
	[60451862] = {},
	[61380753] = {},
	[62823857] = {},
	[68123014] = {},
	[72804152] = {},
}, {
	label="Beledar's Spawn",
	achievement=40851,
	criteria=69716,
	quest=81763, -- 85164
	npc=207802,
	loot={
		ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=85164}),
		{223315, mount=2192,}, -- Beledar's Spawn
		223006, -- Signet of Dark Horizons
	},
	active={SHADOWPHASE},
	note="Spawns during the shadow event, which happens every 3 hours.\nBuy and use {item:224553:Beledar's Attunement} from {majorfaction:2570:Hallowfall Arathi} to see which spawn is active.",
	atlas="worldquest-icon-boss-zhCN",
	group="beledarspawn",
	vignette=6359, -- also 6118? That was the close-up one...
})

-- Deathtide
ns.RegisterPoints(ns.HALLOWFALL, {
	[44744241] = {
		label="Deathtide",
		achievement=40851, criteria=69717,
		quest=81880,
		npc=221753,
		loot={
			ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=85165}),
			223920, -- Slime Deflecting Stopper
			223921, -- Ever-Oozing Signet
			225997, -- Earthen Adventurer's Spaulders
		},
		vignette=6156,
		active=ns.conditions.Item(220123), -- Ominous Offering
		note="Create an {item:220123:Ominous Offering} from {item:220124:Jar of Mucus} (|A:playerpartyblip:::::0:255:127|a) + {item:220122} (|A:playerpartyblip:::::0:0:255|a) to summon",
	},
})

-- ns.RegisterPoints(ns.HALLOWFALL, {
--     [62650611] = {
--         label="Radiant-Twisted Mycelium",
--         quest=nil, -- confirmed, this has a vignette and is rare-flagged, but no quest or rep rewards
--         npc=214905,
--         vignette=5984,
--         note="Objective of {questname:76588}",
--         additional={61953305},
--     },
-- })

-- Azj-Kahet

ns.RegisterPoints(ns.AZJKAHET, {
	[61712962] = {
		label="Kaheti Silk Hauler",
		criteria=69659,
		quest=81702,
		npc=221327,
		loot=addThreadsRep(50, 84071, {
			221206, -- Reinforced Chitin Chestpiece
			221240, -- Nerubian Stagshell Gouger
			221252, -- Nerubian Slayer's Claymore
			221263, -- Nerubian Venom-Tipped Dart
		}),
		vignette=6134,
		route={65201896, 65142033, 63122532, 62492877, 61712962},
		note="Slowly wanders back and forth",
	},
	[76585780] = {
		label="XT-Minecrusher 8700",
		criteria=69660,
		quest=81703,
		npc=216034,
		loot=addThreadsRep(50, 84072, {
			221231, -- Steam-Powered Wristwatch
			221232, -- Polished Goblin Bling
		}),
		vignette=6131,
	},
	[45863916] = {
		label="Abyssal Devourer",
		criteria=69651,
		quest=81695,
		npc=216031,
		loot=addThreadsRep(50, false, {
			223389, -- Legplates of Dark Hunger
			223390, -- Leggings of Dark Hunger
			223391, -- Legguards of Dark Hunger
			223392, -- Trousers of Dark Hunger
		}, true),
		vignette=6129,
	},
	[66536946] = {
		label="Maddened Siegebomber",
		criteria=69663,
		quest=81706, -- 84075
		npc=216044,
		loot=addThreadsRep(50, 84075, {
			221217, -- Nerubian Bomber's Leggings
			221240, -- Nerubian Stagshell Gouger
			221252, -- Nerubian Slayer's Claymore
			221263, -- Nerubian Venom-Tipped Dart
		}),
		vignette=6138,
		route={
			66536946, 66056803, 65616706, 65096620, 64446559, 63706526, 62926513, 62146530,
			61486584, 61396696, 61826791, 62536809, 63166813, 63746786, 64146720, 65386409,
			65706345, 66026301, 66606247, 67206246, 67696278, 68086319, 68356370, 68806483,
			69006550, 69096626, 69076707, 68876785, 68436846, 67866891,
			loop=true,
		},
		note="Patrols around the area, fighting other mobs",
	},
	[34574106] = {
		label="Vilewing",
		-- [36004480, 36204400, 36404580, 36604660, 36804320, 36804580, 37004540]
		criteria=69656,
		quest=81700,
		npc=216037,
		loot=addThreadsRep(50, false, {
			223386, -- Vilewing Crown
			223387, -- Vilewing Chain Helm
			223388, -- Vilewing Cap
			223405, -- Vilewing Visor
		}),
		vignette=6132,
	},
	[61242731] = {
		label="Webspeaker Grik'ik",
		criteria=69655,
		quest=81699,
		npc=216041,
		loot=addThreadsRep(50, false, {
			223369, -- Webspeaker's Spiritual Cloak
		}, true),
		vignette=6135,
	},
	[70732146] = {
		label="Cha'tak",
		criteria=69661,
		quest=81704, -- 84073
		npc=216042,
		loot=addThreadsRep(50, 84073, {
			221212, -- Death Burrower Handguards
			221237, -- Lamentable Vagrant's Lantern
		}),
		vignette=6136,
		note="Cave behind the waterfall",
	},
	[58056233] = {
		label="Enduring Gutterface",
		criteria=69664,
		quest=81707, -- 84076
		npc=216045,
		loot=addThreadsRep(50, 84076, {
			221233, -- Deephunter's Bloody Hook
			221234, -- Tidal Pendant
			221243, -- Slippers of Delirium
			221248, -- Deep Terror Carver
			221255, -- Sharpened Scalepiercer
		}),
		vignette=6139,
	},
	[69996920] = {
		label="Monstrous Lasharoth",
		criteria=69662,
		quest=81705, -- 84074
		npc=216043,
		loot=addThreadsRep(50, 84074, {
			221227, -- Monstrous Fungal Cord
			221250, -- Creeping Lasher Machete
			221253, -- Cultivator's Plant Puncher
			221264, -- Fungarian Mystic's Cluster
			223005, -- String of Fungal Fruits
		}),
		vignette=6137,
	},
	[44803980] = {
		label="Khak'ik",
		criteria=69653,
		quest=81694,
		npc=216032,
		loot=addThreadsRep(50, false, {
			223378, -- Footguards of the Nerubian Twins
			223406, -- Slippers of the Nerubian Twins
			223407, -- Sabatons of the Nerubian Twins
			223408, -- Treads of the Nerubian Twins
		}, true),
		vignette=6130,
		note="Patrols with {npc:221032:Rhak'ik}",
	},
	--[[ -- with Khak'ik:
	[43763953] = {
		label="Rhak'ik",
		-- [44803880, 44803980, 45204440]
		criteria=69653,
		quest=81694,
		npc=221032,
		vignette=6130, -- Stronghold Scouts
		note="Patrols with {npc:216032:Khak'ik}",
	},
	--]]
	[37944285] = {
		label="Ahg'zagall",
		criteria=69654,
		quest=78905,
		npc=214151,
		loot=addThreadsRep(50, false, {
			223375, -- Clattering Chitin Necklace
		}, true),
		vignette=5973,
	},
	[64600352] = {
		label="Umbraclaw Matra",
		criteria=69668,
		quest=82037,
		npc=216051,
		loot=addThreadsRep(50, 84080, {
			221240, -- Nerubian Stagshell Gouger
			221252, -- Nerubian Slayer's Claymore
			221263, -- Nerubian Venom-Tipped Dart
			223930, -- Monstrous Chain Pincers
		}),
		vignette=6186,
	},
	[62940509] = {
		label="Kaheti Bladeguard",
		criteria=69670,
		quest=82078,
		npc=216052, -- Skirmisher Sa'zryk
		loot=addThreadsRep(50, 84082, {
			223915, -- Nerubian Orator's Stiletto
			223916, -- Nerubian Cutthroat's Reach
			223917, -- Nerubian Covert's Cloak
			223939, -- Esteemed Nerubian's Mantle
		}),
		vignette=6204,
		note="Spawns at the top, teleports to the bottom of the path, walks back to the top, then repeats",
		route={62940509, 62430707, 62270757, 61930840, 61740856, 61520848, 61330831, 61210803, 61210771},
	},
	[64590667] = {
		label="Deepcrawler Tx'kesh",
		criteria=69669,
		quest=82077,
		npc=222624,
		loot=addThreadsRep(50, 84081, {
			223915, -- Nerubian Orator's Stiletto
			223916, -- Nerubian Cutthroat's Reach
			223917, -- Nerubian Covert's Cloak
			223923, -- Gilded Cryptlord's Sabatons
		}),
		vignette=6203,
	},
}, {
	achievement=40840, -- Adventurer
	levels=true,
})

-- Azj-Kahet Lower
ns.RegisterPoints(2256, {
	[65688051] = {
		label="Harvester Qixt",
		criteria=69667,
		quest=82036, -- 84079
		npc=216050,
		loot=addThreadsRep(50, 84079, {
			223915, -- Nerubian Orator's Stiletto
			223916, -- Nerubian Cutthroat's Reach
			223917, -- Nerubian Covert's Cloak
			223941, -- Nerubian Cultivator's Girdle
		}),
		route={
			-- 65318052, 65098306, 64908333, 64898331, 64868391, 64468542, 64478571, 64798646, 64888682,
			-- 64698716, 64478728, 64258727, 63448621, 63618636, 62418558
			62418558, 63228614, 63608652, 64218736, 64618723, 64828700, 64718638, 64458568, 64598484,
			64548512, 65208295, 65238270, 65268127, 65358100, 65688051,
		},
		vignette=6185,
	},
	[61938973] = {
		label="The Oozekhan",
		criteria=69666,
		quest=82035,
		npc=216049,
		loot=addThreadsRep(50, 84078, {
			223006, -- Signet of Dark Horizons
			223931, -- Black Blood Cowl
		}),
		vignette=6184,
	},
	[67458318] = {
		label="Jix'ak the Crazed",
		criteria=69665,
		quest=82034,
		npc=216048,
		loot=addThreadsRep(50, 84077, {
			223915, -- Nerubian Orator's Stiletto
			223916, -- Nerubian Cutthroat's Reach
			223917, -- Nerubian Covert's Cloak
			223950, -- Corruption Sifter's Treads
		}),
		vignette=6183,
	},
}, {
	achievement=40840, -- Adventurer
	levels=true,
})

ns.RegisterPoints(ns.AZJKAHET, {
	[63409500] = {
		label="The One Left",
		quest=82290,
		npc=216047,
		loot=addThreadsRep(50, 85167, {
			221246, -- Fierce Beast Staff
			221247, -- Cavernous Critter Shooter
			221251, -- Bestial Underground Cleaver
			221265, -- Charm of the Underground Beast
			225998, -- Earthen Adventurer's Cloak
		}),
		path={63489512, 63959536, 64129539, 65349489, 65429466, 65279345},
		vignette=6266,
	},
}, {levels=true})

ns.RegisterPoints(ns.CITYOFTHREADS, {
	[30975607] = {
		label="Chitin Hulk",
		criteria=69657,
		quest=81634, -- 84069
		npc=216038, -- The Groundskeeper
		loot=addThreadsRep(50, 84069, {
			221214, -- Chitin Chain Headpiece
			221240, -- Nerubian Stagshell Gouger
			221252, -- Nerubian Slayer's Claymore
			221263, -- Nerubian Venom-Tipped Dart
		}),
		vignette=6111,
	},
	[67165840] = {
		label="Xishorr",
		criteria=69658,
		quest=81701, -- 84070
		npc=216039,
		loot=addThreadsRep(50, 84070, {
			221221, -- Venomous Lurker's Greathelm
			221239, -- Spider Blasting Blunderbuss
			221506, -- Arachnid's Web-Sown Guise
		}),
		vignette=6133,
	},
}, {
	achievement=40840, -- Adventurer
	parent=true, levels=true, translate={[2256]=true},
})

ns.RegisterPoints(ns.AZJKAHET, {
	[62796618] = {
		label="Tka'ktath",
		quest=82289,
		npc=216046,
		loot=addThreadsRep(50, 85166, {
			ns.rewards.Item(225952, {quest=83627, requires=ns.conditions.Level(80)}), -- Vial of Tka'ktath's Bloo
			-- {224150, mount=2222}, -- Siesbarg
			221240, -- Nerubian Stagshell Gouger
			221252, -- Nerubian Slayer's Claymore
			221263, -- Nerubian Venom-Tipped Dart
		}),
		vignette=6265,
		note="Begins a quest chain leading to the mount {item:224150:Siesbarg}, item won't drop until you're level 80. Seems to spawn shortly after the daily quest reset.",
	},
	[39804100] = {
		label="Elusive Razormouth Steelhide",
		quest=nil,
		npc=226232,
		requires=ns.conditions.Profession(ns.PROF_WW_SKINNING),
		active=ns.conditions.Item(219007), -- Elusive Creature Lure
	},
}, {levels=true,})

ns.RegisterPoints(ns.SIRENISLE, {
	-- Always
	[35791339] = {
		label="Grimgull",
		criteria=70797,
		quest=84796,
		npc=228155,
		loot={
			229040, -- Earthen Landlubber's Helm
		},
		vignette=6529,
	},
	[53323381] = {
		label="Ghostmaker",
		criteria=70796,
		quest=84801,
		npc=228601,
		loot={
			231118, -- Runecaster's Stormbound Rune
		},
		vignette=6531,
	},
	[67222763] = {
		label="Snacker",
		criteria=70799,
		quest=86933,
		npc=231090,
		vignette=6607,
	},
	[46847808] = {
		label="Wreckwater",
		criteria=70800,
		quest=84794,
		npc=228151,
		vignette=6526,
	},
	[31757154] = {
		label="Bloodbrine",
		criteria=70794,
		quest=84795, -- 84875
		npc=228154,
		vignette=6530,
	},
	-- Project quests
	[37105499] = {
		label="Stalagnarok",
		criteria=70793,
		quest=85437,
		npc=229992,
		loot={
			229037, -- Earthen Landlubber's Breastplate
			229051, -- Scurvy Sailor's Ring
			231118, -- Runecaster's Stormbound Rune
		},
		vignette=6610,
		path=44195630,
	},
	[26236548] = {
		label="Nerathor",
		criteria=70791,
		quest=85938, -- also 85760 (drowned lair); second time 84845 + 85762 (drowned lair)
		npc=229982,
		loot={
			231118, -- Runecaster's Stormbound Rune
		},
		vignette=6754,
		path=32456476,
	},
	[55206840] = {
		label="Gravesludge (The Drain)",
		criteria=70792,
		quest=85937, -- 84753 the drain
		npc=228201,
		loot={
			229052, -- Moneyed Mariner's Pendant
			231118, -- Runecaster's Stormbound Rune
		},
		vignette=6517,
		path=62607519,
	},
	-- Storm
	[32327408] = {
		label="Ikir the Flotsurge",
		criteria=70805,
		quest=84792, -- 84847
		npc=227545,
		loot={
			231117, -- Darktide Wavebender's Orb
			231118, -- Runecaster's Stormbound Rune
		},
		vignette=6525,
	},
	-- Vrykul phase
	[63938735] = {
		label="Asbjorn the Bloodsoaked",
		criteria=70806,
		quest=84805, -- 84839 first time?
		npc=230137,
		loot={
			234972, -- Bloodwake Missive
		},
		vignette=6590,
	},
	-- Naga phase
	[61708967] = {
		label="Coralweaver Calliso",
		criteria=70801,
		quest=84802,
		npc=229852,
		vignette=6581,
	},
	[55808381] = {
		label="Siris the Sea Scorpion",
		criteria=70802,
		quest=84803,
		npc=229853,
		vignette=6582,
	},
	-- Pirate phase
	[66128506] = {
		label="Chef Chum Platter",
		criteria=70803,
		quest=84800,
		npc=228583,
		loot={
			{166358, pet=true}, -- Proper Parrot
		},
		vignette=6580,
	},
	[60568904] = {
		label="Plank-Master Bluebelly",
		criteria=70804,
		quest=84799,
		npc=228580,
		loot={
			{166358, pet=true}, -- Proper Parrot
		},
		vignette=6577,
	},
}, {
	achievement=41046, -- Clean Up On Isle Siren
})

ns.RegisterPoints(ns.SIRENISLE, {
	[33007320] = {
		label="Zek'ul the Shipbreaker",
		-- [33007320, 33007360]
		quest=nil,
		npc=231357, -- also 236083
		loot={
			234328, -- Torrential Fragment
		},
		vignette=6617,
	},
	[31605900] = {
		label="Tempest Talon",
		-- [31605900, 32607080, 33007320, 33205820, 33207160, 33406940, 33606940, 33807000, 33807360, 34005800, 34007120, 34205720, 34205900, 34206720, 34405980, 34407200, 34605860, 34606040, 34806700, 35007180, 35205760, 35206100, 35206820, 35207020, 35406920, 35407120, 35606620, 35805960, 35806120, 35806160, 35806760, 36005760, 36005900, 36006740, 36006860, 36007020, 36206420, 36206520, 36207200, 36405620, 36405700, 36407060, 36606900, 36607180, 36607360, 36805560, 36805780, 36806180, 37005720, 37006140, 37006420, 37006580, 37006800, 37007320, 37205540, 37205880, 37206340, 37207040, 37207060, 37406540, 37406720, 37605820, 37606140, 37606200, 37606340, 37606440, 37606520, 37805560, 37806620, 37806900, 37807100, 37807400, 38005860, 38007200, 38206680, 38207020, 38405400, 38406820, 38407300, 38605820, 38606040, 38606060, 38607340, 38806940, 38807240, 39007000, 39007140, 39007620, 39206200, 39207480, 39405900, 39406380, 39407400, 39606400, 39806460, 39807140, 40005960, 40007320, 40205880, 40207160, 40405740, 40405760, 40406060, 40406160, 40406300, 40407040, 40407380, 40407860, 40605780, 40606040, 40607060, 40607380, 40607460, 40607580, 40805420, 40805740, 40805900, 40806140, 41006200, 41007180, 41007260, 41206300, 41206660, 41405520, 41405620, 41406400, 41406520, 41406620, 41606140, 41606300, 41607440, 41607820, 41805940, 41806220, 41806420, 41806520, 41807080, 41807160, 41807340, 42005980, 42006580, 42206980, 42406720, 42406780, 42606700, 42606800, 42806120, 42806160, 42806340, 42806640, 43006360, 43006500, 43007260, 43207220, 43207380, 43407140, 43606660, 43607240, 43607420, 43807320, 44206280, 44206380, 44206620, 44406180, 44406540, 44606480, 44806580, 44806860, 45006380, 45206740, 45207620, 45406320, 45406820, 45407460, 45605740, 45606800, 45807420, 46206200, 46206480, 46206720, 46406420, 46406560, 46407240, 46606440, 46606800, 46806340, 46807160, 47006500, 47007040, 47206720, 48206800, 50807280]
		quest=nil,
		npc=231353,
		vignette=6615,
	},
	[31608680] = {
		label="Slaughtershell",
		-- [31608680, 31808160, 32207780, 32207900, 32407700, 32408040, 32408500, 32807360, 32808220, 32808360, 33008540, 33207000, 33207340, 33207520, 33208040, 33208560, 33208720, 33407160, 33407660, 33407780, 33408120, 33408300, 33607640, 33608520, 33807300, 33807840, 33808120, 34006960, 34007160, 34007360, 34007460, 34007880, 34008280, 34008440, 34208180, 34208580, 34407680, 34408040, 34607480, 34607920, 34608020, 34608200, 34807420, 34807700, 34808060, 35008520, 35207760, 35208360, 35407260, 35407640, 35607760, 35807520, 36202120, 36207660, 36207920, 36208080, 36208380, 36402200, 36407220, 36407600, 36407960, 36602060, 36606760, 36607480, 36607920, 36807620, 37002360, 37002580, 37007420, 37008020, 37008380, 37202220, 37202300, 37202700, 37207340, 37208460, 37402460, 37407700, 37407840, 37602040, 37602600, 37607340, 37607820, 37801940, 37807400, 37807720, 38007480, 38007940, 38008560, 38202120, 38202660, 38401720, 38402220, 38607860, 39002040, 39002080, 39002180, 39002780, 39002980, 39201780, 39201920, 39202540, 39202680, 39207360, 39207720, 39402260, 39402440, 39402580, 39602600, 39801860, 39802160, 39802280, 39802660, 39807120, 39807640, 40001760, 40002080, 40007040, 40007500, 40202020, 40207340, 40207680, 40207960, 40402400, 40402520, 40403000, 40601740, 40601820, 40603000, 40607840, 40801920, 40802440, 41002500, 41002760, 41007400, 41007720, 41202700, 41203100, 41207320, 41402240, 41402320, 41402620, 41802660, 41802760, 41803120, 41803480, 41807320, 41807560, 41807680, 42002320, 42002460, 42002580, 42003340, 42207160, 42402400, 42402860, 42403000, 42403360, 42406740, 42407080, 42407440, 42407540, 42602480, 42607140, 42607280, 42802440, 42802560, 42802760, 42803140, 42803260, 42807420, 43003220, 43007160, 43007500, 43007620, 43202680, 43202940, 43203020, 43403360, 43404020, 43404100, 43407680, 43603340, 43603420, 43603640, 43603740, 43603820, 43603880, 43607320, 43802680, 43802960, 43803240, 43803500, 43804280, 43806460, 43807020, 43807140, 43807720, 44002920, 44003140, 44004040, 44006560, 44007160, 44204140, 44404180, 44603760, 44603900, 44607000, 45003000, 45004140, 45007100, 45204040, 45204340, 45206940, 45404200, 45406800, 45604260, 45606700, 45607020, 45607800, 45803780, 45804420, 45804460, 45806780, 46004240, 46006620, 46006940, 46204000, 46404080, 46405960, 46604260, 46606780, 46806940, 47204220, 47204540, 47204880, 47403960, 47604360, 47804780, 47806740, 48004180, 48006760, 48006880, 48204120, 48204500, 48604680, 48805300, 48806820, 49004340, 49006860, 49204440, 49204500, 49404840, 49406600, 49406680, 49407340, 49604720, 49605100, 49605620, 49606820, 49804420, 49804500, 50206940, 50207380, 50406640, 50406960, 50407080, 50605200, 50806920, 50807140, 51004540, 51004740, 51005260, 51005540, 51006560, 51007560, 51204060, 51207040, 51404560, 51406700, 51605400, 51606860, 52004620, 52205460, 52207000, 52406620, 52407520, 52605780, 52606280, 52607480, 52804560, 52804700, 52805880, 52806360, 52807620, 53005740, 53205360, 53205640, 53206240, 53207680, 53605420, 53605840, 53804600, 53805740, 53806040, 53806180, 53806260, 53807680, 54206360, 54606260, 54607800, 55007940, 55404740, 55407420, 55407500, 55807540, 55807580, 56006720, 56204740, 56206380, 56206540, 56206640, 56206840, 56206940, 56207400, 56208000, 56407020, 56408060, 56408160, 56604740, 56606720, 56607040, 56607240, 56607300, 56608220, 56808020, 56808420, 57004820, 57006500, 57006900, 57007120, 57007360, 57008480, 57207900, 57605220, 57606560, 57804860, 57806980, 58007120, 58007320, 58204960, 58207180, 58207440, 58208320, 58407500, 58608320, 58807120, 58807280, 59004820, 59007160, 59204860, 59404980, 59407460, 59607420, 59608320, 59804900, 59807120, 60005060, 60006980, 60208840, 60407300, 60407520, 60408360, 60408940, 60604940, 60607540, 60807040, 60807420, 60807620, 61004980, 61007280, 61007660, 61008360, 61008840, 61208320, 61208860, 61408240, 61607200, 61607620, 61608260, 61609080, 61807760, 61808860, 61809040, 62204820, 62204880, 62207140, 62208220, 62208440, 62208660, 62208760, 62408100, 62408460, 62408580, 62607240, 62608100, 62608320, 62608460, 62608800, 62805160, 62807940, 62807980, 62808420, 62808640, 62808660, 63005360, 63007720, 63206980, 63407800, 63408200, 63605340, 63607860, 63608540, 63807560, 63808680, 64005400, 64007960, 64008820, 64207660, 64207840, 64208600, 64408280, 64605460, 64805680, 64807580, 65004900, 65608660, 66005380, 66005460, 66205260, 66208640, 66408460, 66605360, 66805480, 67005300, 67605320, 67608720, 68205100, 68604920, 72605680, 75205840, 81406020]
		quest=nil,
		npc=228547,
		loot={
			234328, -- Torrential Fragment
		},
		vignette=6524,
	},
	[53207660] = {
		label="Brinebough",
		-- [53207660, 54008120, 54208000, 54407760, 54408420, 54408500, 54608060, 54807920, 55007820, 55208040, 55208340, 55208540, 55408240, 55408360, 55408560, 55608000, 55608440, 55608460, 55808080, 55808580, 56208200, 56408280, 56607960, 56608400, 56608480, 56808120, 57008200, 57207820, 57207880, 57208280, 57208660, 57608240, 57608260, 58208380, 59008300, 59608360, 60208340]
		quest=nil,
		npc=231356,
		vignette=6616,
	},
	--[[
	[0] = {
		label="Gritstorm",
		quest=nil,
		npc=228150,
		vignette=6528,
	},
	[0] = {
		label="Nickel Back",
		quest=85407,
		npc=231366,
		vignette=6618,
	},
	[0] = {
		label="Restless Odek",
		quest=nil,
		npc=229970,
		vignette=6591,
	},
	[0] = {
		label="Restless Rex",
		quest=nil,
		npc=228202,
	},
	[0] = {
		label="Stormtouched Restless Death",
		quest=nil,
		npc=231369,
	},
	[0] = {
		label="[DNT] Test NPC",
		quest=nil,
		npc=230673,
	},
	--]]
})

ns.RegisterPoints(ns.FORGOTTENVAULT, {
	[26402300] = {
		label="Shardsong",
		criteria=70795,
		quest=nil,
		npc=227550,
		loot={
			{235017,toy=true,}, -- Glittering Vault Shard
		},
		vignette=6666,
	},
	[64805460] = {
		label="Gunnlod the Sea-Drinker",
		criteria=70798,
		quest=nil,
		npc=228159,
		loot={
			229019, -- Earthen Deckhand's Cape
			229023, -- Earthen Deckhand's Breeches
			229034, -- Earthen Islander's Cinch
			229051, -- Scurvy Sailor's Ring
			229167, -- Earthen Deckhand's Cleaver
			229174, -- Earthen Landlubber's Shield
			229180, -- Earthen Landlubber's Hammer
			231116, -- Cursed Pirate Skull
			231118, -- Runecaster's Stormbound Rune
			{235017,toy=true,}, -- Glittering Vault Shard
		},
		vignette=6527,
	},
}, {
	achievement=41046, -- Clean Up On Isle Siren
})
ns.RegisterPoints(ns.FORGOTTENVAULT, {
	[39807460] = {
		label="Ksvir the Forgotten",
		quest=nil,
		npc=231368,
		loot={
			232571, -- Whirling Runekey
			{235017,toy=true,}, -- Glittering Vault Shard
		},
		vignette=6619,
	},
})
