local myname, ns = ...

local PHASEDIVING = ns.conditions.AuraActive(1214374) -- Phase Diving
-- Under Her Power (spell:1219699) also counts
local TRAIT_WHATLIESBEYOND = ns.conditions.Trait(1115, 105870)
local TRAIT_SECRETSOFTHEDEPTHS = ns.conditions.Trait(1115, 105872)

--[[
notes:
91812: either world quests or Reshii Wraps acquisition (after The Tabiqa 84910)
90955: first Reshii Wraps ability unlock
89380: after Another World, primary Phase Conduit (6784) appears on zone map
84901: after Shadow Point / Like A Knife Through Aether (84900)
85037: That's a Wrap, unlocks Warrants
--]]

-- Treasures
-- These mostly have a learn-cosmetic item, and a grey equivalent if you already know it
ns.RegisterPoints(ns.KARESH, {
	[76114526] = { label="Gift of the Brothers",
		criteria=106270,
		quest=85959, -- Brothers are 86065, 86066, 86067; turning it in is 85958
		loot={
			248199, -- The Brothers' Final Gift
			248200, -- The Brothers' Not-So-Final Present
		},
		related={
			[75453979] = {label="{npc:234075:Sahra}", minimap=true, requires=ns.conditions.AuraActive(471549), quest=86065},
			[68304530] = {label="{npc:234112:Naji}", minimap=true, requires=ns.conditions.AuraActive(471549), quest=86066},
			[69806050] = {label="{npc:234113:M'alim}", minimap=true, requires=ns.conditions.AuraActive(471549), quest=86067},
			color={r=0.6,g=0.6,b=1},
		},
		note="Get {spell:471549:Flickering Lantern} and find the three brothers",
		vignette=6682, -- Flickering Lantern, then 6681 Gift of the Brothers
	},
	[60903835] = { label="Ancient Coffer",
		criteria=106271,
		quest=86416,
		loot={
			{245269, pet=true}, -- Mr. Long-Legs
		},
		related={
			[66564478] = {loot={233794}, inbag=233794, minimap=true}, -- Battered Book (quest 86415 tripped?)
			[76233122] = {loot={233799}, inbag=233799, minimap=true}, -- Submerged Bottle
		},
		note="Bring the {item:233794} and {item:233799}",
		vignette=6702,
	},
	[69745231] = { label="Forlorn Wind Chime",
		criteria=106272,
		quest=85837,
		loot={
			243144, -- Reshii Crystal Fragments
			-- ns.rewards.Currency(ns.CURRENCY_VALORSTONE, 5), ns.rewards.Currency(ns.CURRENCY_RESONANCE, 4),
		},
		vignette=6675,
	},
	[64104398] = { label="Ixthar's Favorite Crystal",
		criteria=106244,
		quest=86492,
		loot={
			ns.rewards.Achievement(42736, 106244), -- Ixthar's Legacy
			243144, -- Reshii Crystal Fragments
			-- ns.rewards.Currency(ns.CURRENCY_VALORSTONE, 5), ns.rewards.Currency(ns.CURRENCY_RESONANCE, 3),
		},
		vignette=6724
	},
	[60544213] = { label="Wastelander Stash",
		criteria=106274,
		quest=86301,
		loot={
			243145, -- Well-Preserved Wrappings
			-- ns.rewards.Currency(ns.CURRENCY_VALORSTONE, 5), ns.rewards.Currency(ns.CURRENCY_RESONANCE, 4),
		},
		vignette=6690,
	},
	[65346362] = { label="Tumbled Package",
		criteria=106275,
		quest=86304,
		loot={
			ns.rewards.Item(238201, 10), -- Desolate Talus
			243160, -- Tazavesh Shipping Manifest
			-- ns.rewards.Currency(ns.CURRENCY_VALORSTONE, 5), ns.rewards.Currency(ns.CURRENCY_RESONANCE, 4),
		},
		vignette=6692,
	},
	[70204773] = { label="Rashaal's Vase",
		criteria=106276,
		quest=86306,
		loot={
			ns.rewards.Item(239690, 10), -- Phantom Bloom
			243161, -- Long-Pressed Flowers
			-- ns.rewards.Currency(ns.CURRENCY_RESONANCE, 5),
		},
		vignette=6693, -- Tumbled Package
		path=68834794,
	},
	[75065534] = { label="Shattered Crystals",
		criteria=108722,
		quest=86308,
		loot={
			243144, -- Reshii Crystal Fragments
			-- ns.rewards.Currency(ns.CURRENCY_VALORSTONE, 5), ns.rewards.Currency(ns.CURRENCY_RESONANCE, 4),
		},
		vignette=6695,
	},
	[77782787] = { label="Skeletal Tail Bones",
		criteria=106277,
		quest=86322,
		loot={
			{243158, pet=true}, -- Ixthal the Observling
			-- ns.rewards.Currency(ns.CURRENCY_VALORSTONE, 5), ns.rewards.Currency(ns.CURRENCY_RESONANCE, 5),
		},
		vignette=6696,
	},
	[58653434] = { label="Crudely Stitched Sack",
		criteria=106278,
		quest=86323,
		loot={
			246295, -- Tazavesh Lookout's Mace
			246296, -- Off-Balance Mace of the Tazavesh Lookout
			-- ns.rewards.Currency(ns.CURRENCY_VALORSTONE, 5), ns.rewards.Currency(ns.CURRENCY_RESONANCE, 4),
		},
		vignette=6697,
	},
	[59755370] = { label="Abandoned Lockbox (multiple spawn points?)",
		criteria=108723,
		quest=92348,
		loot={
			246299, -- Blade of Lost Hope
			246301, -- Pitted Blade of Lost Hope
			-- ns.rewards.Currency(ns.CURRENCY_VALORSTONE, 5), ns.rewards.Currency(ns.CURRENCY_RESONANCE, 5),
		},
		vignette=6673,
	},
	[55716411] = { label="Lightly-Dented Luggage (multiple spawn points? 53706400)",
		criteria=106279,
		quest=91352,
		loot={},
		vignette=6674,
	},
	[54462441] = { label="Sand-Worn Coffer",
		criteria=106280,
		quest=85840,
		loot={
			246297, -- Desperate Defender's Bladed Staff
			246298, -- Cracked Staff of the Desperate Defender
			-- ns.rewards.Currency(ns.CURRENCY_VALORSTONE, 5), ns.rewards.Currency(ns.CURRENCY_RESONANCE, 5),
		},
		vignette=6676,
	},
}, {
	achievement=42741, -- Treasures of K'aresh
	requires=ns.conditions.QuestComplete(84967), -- The Shadowguard Shattered
})
ns.RegisterPoints(ns.KARESH_TAZAVESH, {
	[47766265] = { label="Mailroom Distribution",
		criteria=106273,
		quest=86467,
		loot={{245970, toy=true}}, -- P.O.S.T. Master's Express Hearthstone
		vignette=6712, -- then 6709
	},
}, {
	achievement=42741, -- Treasures of K'aresh
	parent=true,
	requires=ns.conditions.QuestComplete(84967), -- The Shadowguard Shattered
})
-- Phased:
ns.RegisterPoints(ns.KARESH, {
	[52006840] = { label="Ethereal Voidforged Container",
		criteria=106224,
		quest=89378,
		loot={
			246293, -- Buckler of the Last Stand
			246294, -- Shattered Buckler of the Last Stand
		},
		vignette=6889, --
	},
	[52504677] = { label="Light-Soaked Cleaver",
		criteria=106281,
		quest=90511,
		loot={
			243002, -- Light-Soaked Cleaver
			243014, -- Light-Dimmed Cleaver
		},
		vignette=6919,
	},
	[77994894] = { label="Efrat's Forgotten Bulwark",
		criteria=106283,
		quest=90514,
		loot={
			243004, -- Efrat's Forgotten Bulwark
			243016, -- Efrat's Totally Abandonded Bulwark
		},
		vignette=6921,
	},
	[51056509] = { label="Tulwar of the Golden Guard",
		criteria=106284,
		quest=90522,
		loot={
			243005, -- Tulwar of the Golden Guard
			243017, -- Tulwar of the Pyrite Guard
		},
		vignette=6925,
	},
	[78306150] = { label="Petrified Branch of Janaa",
		criteria=106285,
		quest=90515,
		loot={
			243006, -- Petrified Branch of Janaa
			243018, -- Petrified Twig of the Fennad
		},
		vignette=6922, --
	},
	[49201805] = { label="Shadowguard Crusher",
		criteria=106286,
		quest=90527,
		loot={
			243008, -- Shadowguard Crusher
			243021, -- Shadowguard Bonker
		},
		vignette=6926,
	},
	[80725267] = { label="Sufaadi Skiff Lantern",
		criteria=106287,
		quest=90521,
		loot={
			243009, -- Sufaadi Skiff Lantern
			243022, -- Sufaadi Skiff Candle
		},
		vignette=6923,
	},
	[64434269] = { label="Korgorath's Talon",
		criteria=106288,
		quest=90532,
		loot={
			243153, -- Korgorath's Talon
			243154, -- Korgorath's Broken Nail
		},
		vignette=6927,
	},
	[58432259] = { label="Warglaive of the Audacious Hunter",
		criteria=106289,
		quest=91055,
		loot={
			245667, -- Warglaive of the Audacious Hunter
			245668, -- Warglaive of the Subdued Tracker
		},
		vignette=6965,
		path=56802410,
	},
	[50823534] = { label="Phaseblade of the Void Marches",
		criteria=106291,
		quest=91057,
		loot={
			245671, -- Phaseblade of the Void Marches
			245672, -- Blade of the Void Swamp
		},
		vignette=6967,
	},
	[70007090] = { label="Bladed Rifle of Unfettered Momentum",
		criteria=106292,
		quest=91058,
		loot={
			245673, -- Bladed Rifle of Unfettered Momentum
			245674, -- Rifle of Leaden Movement
		},
		vignette=6968, --
	},
}, {
	achievement=42741, -- Treasures of K'aresh
	requires=ns.conditions.QuestComplete(84967), -- The Shadowguard Shattered
	hide_before={PHASEDIVING, TRAIT_WHATLIESBEYOND},
})
ns.RegisterPoints(ns.KARESH_TAZAVESH, {
	[23704680] = { label="Spear of Fallen Memories",
		criteria=106296,
		quest=90512,
		loot={
			243003, -- Spear of Fallen Memories
			243015, -- Spear of Forgotten Memories
		},
		vignette=6920, --
	},
	[66048299] = { label="P.O.S.T. Master's Prototype Parcel and Postage Presser",
		criteria=106290,
		quest=91056,
		loot={
			245669, -- P.O.S.T. Master's Prototype Parcel and Postage Presser
			245670, -- P.O.S.T. Employee's Backup Stamp
		},
		vignette=6966,
	},
}, {
	achievement=42741, -- Treasures of K'aresh
	parent=true,
	requires=ns.conditions.QuestComplete(84967), -- The Shadowguard Shattered
	hide_before={PHASEDIVING, TRAIT_WHATLIESBEYOND},
})

-- Dangerous Prowlers of K'aresh (42729)
local prowlers = ns.nodeMaker{
	achievement=42729,
	note=EMOTE410_CMD1,
	texture=ns.atlas_texture("WildBattlePetCapturable", {r=1, g=0.4, b=1}),
	minimap=true,
}
ns.RegisterPoints(ns.KARESH, {
	[47916135] = {criteria=106220, npc=245387, note="Patrols"}, -- C.T.
	[73172374] = {criteria=106225, npc=248062, note="Up on the ledge"}, -- Empurror
	[70255423] = {criteria=106226, npc=248067, note="Phases in and out, up in the tree"}, -- K'aresh'ire
	[50345921] = {criteria=106221, npc=248056, note="Phases in and out"}, -- Little Ms. Phaser
	[47613738] = {criteria=106223, npc=248057, hide_before=PHASEDIVING}, -- The King in Silver
}, prowlers{})
ns.RegisterPoints(ns.KARESH_TAZAVESH, {
	[61005551] = {criteria=106222, npc=237077,}, -- Mar
}, prowlers{parent=true})

-- Secrets of the K'areshi (60890)
local secrets = ns.nodeMaker{
	achievement=60890,
	atlas="loreobject-32x32",
	requires=ns.conditions.QuestComplete(84967), -- The Shadowguard Shattered
}
ns.RegisterPoints(ns.KARESH, {
	[42292093] = {criteria=107308, quest=91646, vignette=7122, hide_before=PHASEDIVING}, -- From Vengeance to Void
	[48925715] = {criteria=107313, quest=91686, vignette=7127}, -- Geologist Field Journal
	[72122941] = {criteria=107309, quest=91647, vignette=7123, hide_before=PHASEDIVING}, -- The Facets of K'aresh
	[49632676] = {criteria=107307, quest=91643, vignette=7120, hide_before=PHASEDIVING}, -- Multiversal Energy Dynamics and the Murmuration Paradox
}, secrets{})
ns.RegisterPoints(ns.KARESH_TAZAVESH, {
	[36795807] = {criteria=107306, quest=91649, vignette=7125, hide_before=PHASEDIVING}, -- I Have Become Void!
	[38234562] = {criteria=107310, quest=91687, vignette=7128, hide_before=PHASEDIVING}, -- Checklist of Minor Pleasures
	[46321858] = {criteria=107311, quest=91645, vignette=7121}, -- Ba'key's Aromatic Broker Cookies Recipes
	[37302570] = {criteria=107312, quest=91640, vignette=nil, minimap=true, loot={246584}}, -- A Dog-eared Book (no vignette)
	[58459150] = {criteria=107315, quest=91642, vignette=7119}, -- Mysterious Notebook
	[41683982] = {criteria=107314, quest=91648, vignette=7124}, -- Coins: An Oath We Exchange
}, secrets{parent=true})

-- Phase-Lost-and-Found (61017)
local phaseorb = ns.nodeMaker{
	achievement=61017, criteria=true,
	atlas="Vehicle-TempleofKotmogu-PurpleBall", minimap=true,
	hide_before=TRAIT_SECRETSOFTHEDEPTHS,
}
ns.RegisterPoints(ns.KARESH, {
	[43162164] = {},
	[43762556] = {},
	[44231681] = {},
	[45745153] = {},
	[47171579] = {},
	[47181578] = {},
	[47733728] = {},
	[47806085] = {},
	[48603845] = {},
	[48892670] = {},
	[48985746] = {},
	[49341897] = {},
	[50113620] = {},
	[50495412] = {},
	[50573510] = {},
	[50953671] = {},
	[51026912] = {},
	[51176774] = {},
	[52176488] = {},
	[53382057] = {},
	[53392050] = {},
	[53734838] = {},
	[54326317] = {},
	[54505016] = {},
	[54916381] = {},
	[55285545] = {},
	[55942154] = {},
	[56552093] = {},
	[57902393] = {},
	[58742099] = {},
	[58935751] = {},
	[59416044] = {},
	[59842272] = {},
	[60352841] = {},
	[60514201] = {},
	[60525549] = {},
	[61082734] = {},
	[61162324] = {},
	[61203920] = {},
	[62594165] = {},
	[63003911] = {},
	[63984597] = {},
	[64865224] = {},
	[64905495] = {},
	[66054880] = {note="Under the bridge"},
	[68834777] = {},
	[69755531] = {},
	[70206061] = {},
	[70263197] = {},
	[72711232] = {},
	[72791006] = {},
	[73985749] = {},
	[75713442] = {},
	[75963255] = {},
	[76035820] = {},
	[78224889] = {},
	[78762917] = {},
	[80405123] = {},
}, phaseorb{})
ns.RegisterPoints(ns.KARESH_TAZAVESH, {
	[35235775] = {},
	[39613240] = {},
	[40156823] = {},
	[42835032] = {},
	[44322686] = {},
	[44323460] = {},
	[44383470] = {},
	[53226055] = {},
	[53859605] = {},
	[55813380] = {},
	[56468671] = {},
	[60485724] = {},
	[61128910] = {},
	[62132931] = {},
	[66898969] = {},
}, phaseorb{parent=true})

-- Phase Conduits

local conduit = {
	label="{npc:249754:Phase Conduit}",
	texture=ns.atlas_texture("flightmaster_ancientwaygate-taxinode_neutral", {r=1, g=1, b=1}),
	requires=ns.conditions.Achievement(42731), -- Become a Hero, Become a Phasediver!
}
ns.RegisterPoints(ns.KARESH, {
	[50403640] = {}, -- Overlook Zo'Shuul Conduit
	[77104890] = {}, -- North Sufaad Conduit
	[51204850] = {}, -- Serrated Peaks Conduit
	[45202390] = {}, -- Shadow Point Conduit
	[60202900] = {}, -- Shan'dorah Conduit
	[75903290] = {}, -- The Oasis Conduit
	[71200820] = {}, -- Vanquisher's Wake Conduit
	[72601250] = {}, -- Vanquisher's Wake Arena Conduit
	[56202150] = {}, -- Fracture of Laacuna Conduit
	[53902670] = {}, -- Untethered Space Conduit
	[65404790] = {}, -- Lunnall River Conduit
	[58905780] = {}, -- Naakroa Conduit
	[51306710] = {}, -- Ruins of Yaathron Conduit
	[53806360] = {}, -- Hosaas' Rest Conduit
}, conduit)
ns.RegisterPoints(ns.KARESH_TAZAVESH, {
	[46705680] = {parent=true}, -- Tazavesh Conduit
}, conduit)

-- Rares

ns.RegisterPoints(ns.KARESH, {
	[75233098] = { label="Heka'tamos",
		criteria=106334,
		quest=91276, -- 91422
		npc=245998,
		loot={
			{245272,pet=true,}, -- Heka'Tarnos, Bringer of Discord
			246064, -- Reshii Magi's Pendant
			246065, -- Reshii Magi's Band
		},
		vignette=6981,
		note="Gather {spell:1240235}, {spell:1240217}, {spell:1240233}, {spell:1240237} nearby",
		nearby={75553340, 72853131, 76983175, 72023077, 72713330, 71783464, 72582845, 72713472, color={r=0,g=1,b=0}, worldmap=false},
	},
	[54055884] = { label="Malek'ta",
		criteria=106336,
		quest=91275,
		npc=245997,
		loot={
			240168, -- Reshii Magi's Seal
			240169, -- Reshii Magi's Amulet
			{245214,pet=true,}, -- Palek'ti, the Mouth of Nothingness
		},
		vignette=6980,
		note="Jump repeatedly",
	},
}, {
	achievement=42761, -- Remnants of a Shattered World
})
ns.RegisterPoints(ns.KARESH, {
	[74043254] = { label="Sthaarbs",
		criteria=106346,
		quest=91293, -- 91431
		npc=234845, -- 234848
		loot={
			240171, -- Observer's Soul Fetters
			240172, -- Depleted K'areshi Battery
			240213, -- Veiling Mana Shroud
			240214, -- Miniature Reshii Sandgarden
			{246160,mount=true,}, -- Sthaarbs's Last Lunch
		},
		vignette=6725,
	},
	[63824363] = { label="Ixthar the Unblinking",
		criteria=106245,
		quest=90596, -- 90685
		npc=232128,
		loot={
			ns.rewards.Achievement(42736, 106245), -- Ixthar's Legacy
			240171, -- Observer's Soul Fetters
			240213, -- Veiling Mana Shroud
			240214, -- Miniature Reshii Sandgarden
		},
		vignette=6636,
	},
	[54455445] = { label="Maw of the Sands",
		criteria=106337,
		quest=90594, -- 90683
		npc=231981,
		loot={
			240172, -- Depleted K'areshi Battery
			240213, -- Veiling Mana Shroud
			240214, -- Miniature Reshii Sandgarden
		},
		vignette=6630,
	},
	[52782081] = { label="Orith the Dreadful",
		criteria=106339,
		quest=90595, -- 90684
		npc=232127,
		loot={
			240172, -- Depleted K'areshi Battery
			240213, -- Veiling Mana Shroud
			240214, -- Miniature Reshii Sandgarden
		},
		vignette=6635,
	},
	[45782425] = { label="Prototype Mk-V",
		criteria=106341,
		quest=90590,
		npc=232182,
		loot={
			239449, -- Reshii Magi's Slippers
			239464, -- Reshii Skirmisher's Brigandine
			239478, -- Reshii Brute's Greatbelt
		},
		vignette=6638,
	},
	-- not yet vignette-coords:
	[70174979] = { label="Urmag",
		criteria=106348,
		quest=90593,
		npc=232195,
		loot={
			239456, -- Reshii Scout's Jerkin
			239470, -- Reshii Skirmisher's Sash
			239473, -- Reshii Brute's Sollerets
			{246067,mount=true,}, -- Pearlescent Krolusk
		},
		vignette=6641,
	},
	[76794208] = { label="Stalker of the Wastes",
		criteria=106345,
		quest=90592, -- 90681
		npc=232193,
		loot={
			239461, -- Reshii Scout's Shoulderpads
			239466, -- Reshii Skirmisher's Gauntlets
			246063, -- Void-Polished Warpstalker Stone
		},
		vignette=6640,
	},
	[51915767] = { label="The Nightreaver",
		criteria=106347,
		quest=90589, -- 90678
		npc=232111,
		loot={
			239454, -- Reshii Magi's Cord
			239467, -- Reshii Skirmisher's Cowl
			239479, -- Reshii Brute's Vambraces
			{245254,pet=true,}, -- Duskthief
		},
		vignette=6634,
	},
	[73605531] = { label="Sha'ryth the Cursed",
		criteria=106343,
		quest=90585,
		npc=232006,
		loot={
			239453, -- Reshii Magi's Spines
			239458, -- Reshii Scout's Grips
			239465, -- Reshii Skirmisher's Boots
		},
		vignette=6629,
	},
	[50536476] = { label="Revenant of the Wasteland",
		criteria=106342,
		quest=90591, -- 90680
		npc=232189,
		loot={
			239459, -- Reshii Scout's Hood
			239471, -- Reshii Skirmisher's Armguards
			239476, -- Reshii Brute's Greaves
		},
		vignette=6639,
	},
	[65144998] = { label="Xarran the Binder",
		criteria=106349,
		quest=90584, -- 90672
		npc=232199,
		loot={
			239451, -- Reshii Magi's Crown
			239463, -- Reshii Scout's Bracers
			239468, -- Reshii Skirmisher's Legguards
		},
		vignette=6642,
	},
	[56085040] = { label="Morgil the Netherspawn",
		criteria=106338,
		quest=90588, -- 90677
		npc=232108,
		loot={
			239450, -- Reshii Magi's Gloves
			239457, -- Reshii Scout's Soles
			239472, -- Reshii Brute's Breastplate
			{244915,pet=true,}, -- Jimmy
		},
		vignette=6633,
	},
	[54114923] = { label="Shadowhowl",
		criteria=106344,
		quest=90583, -- 90674
		npc=232129,
		loot={
			239452, -- Reshii Magi's Leggings
			239469, -- Reshii Skirmisher's Pauldrons
			239474, -- Reshii Brute's Handguards
		},
		vignette=6637,
	},
	[65624423] = { label="Korgorath the Ravager",
		criteria=106335,
		quest=90586, -- 90675
		npc=232077,
		loot={
			239448, -- Reshii Magi's Vestments
			239462, -- Reshii Scout's Belt
			239475, -- Reshii Brute's Helmet
		},
		vignette=6631,
	},
}, {
	achievement=42761, -- Remnants of a Shattered World
	hide_before=PHASEDIVING,
})
ns.RegisterPoints(ns.KARESH_TAZAVESH, {
	[72508187] = { -- "Chowdar"
		criteria=106331,
		quest=90587, -- 90676
		npc=232098,
		loot={
			239455, -- Reshii Magi's Bands
			239460, -- Reshii Scout's Breeches
			239477, -- Reshii Brute's Epaulettes
			{242323,toy=true,}, -- Chowdar's Favorite Ribbon
		},
		vignette=6632,
		note="Wanders northeast",
	},
	-- not yet vignette-coords:
	[34703610] = { label="Arcana-Monger So'zer",
		criteria=106332,
		quest=90696,
		npc=241956, -- 241987
		vignette=6913, -- also 6893?
		note="Complete {quest:89490:Warrant Arcana-Monger So'zer} to summon",
	},
	[71245702] = { label="Grubber",
		criteria=106333,
		quest=90698, -- 90699
		npc=238540,
		loot={
			239454, -- Reshii Magi's Cord
			239463, -- Reshii Scout's Bracers
			239465, -- Reshii Skirmisher's Boots
			239469, -- Reshii Skirmisher's Pauldrons
			239478, -- Reshii Brute's Greatbelt
			246064, -- Reshii Magi's Pendant
		},
		vignette=6914, -- also 6774?
		note="Complete {quest:87405:Warrant Grubber} to summon",
	},
}, {
	achievement = 42761, -- Remnants of a Shattered World
	parent=true,
})

ns.RegisterPoints(ns.KARESH, {
	[50555406] = { label="Miasmawrath",
		quest=86447, -- 91287, 91310, 91434
		npc=234970,
		loot={
			{246240, mount=2602, note="needs 20"}, -- Devoured Energy-Pod
			{238663, quest=89061,}, -- Crystallized Anima
			240111, -- Reshii Skirmisher's Axe
			240112, -- Reshii Scout's Blade
			240113, -- Reshii Magi's Dagger
			240114, -- Reshii Skirmisher's Morningstar
			240115, -- Reshii Brute's Warmace
			240116, -- Reshii Brute's Longsword
			240117, -- Reshii Magi's Wand
			240118, -- Reshii Brute's Spear
			240119, -- Reshii Skirmisher's Staff
			240120, -- Reshii Magi's Lantern
			240121, -- Reshii Brute's Barrier
		},
		vignette=6705, -- Devourer Attack: Eco-Dome Primus (not sure if multiples spawn?)
	},
	[49386418] = { label="The Harvester",
		quest=86464, -- 91289, 91311, 91435
		npc=235087, -- 246366
		loot={
			{246240, mount=2602, note="needs 20"}, -- Devoured Energy-Pod
			{238664, quest=89062,}, -- Crystallized Anima
			240113, -- Reshii Magi's Dagger
			240115, -- Reshii Brute's Warmace
			240116, -- Reshii Brute's Longsword
			240117, -- Reshii Magi's Wand
			240118, -- Reshii Brute's Spear
			240119, -- Reshii Skirmisher's Staff
			240120, -- Reshii Magi's Lantern
			240121, -- Reshii Brute's Barrier
		},
		vignette=6707, -- Devourer Attack: The Atrium
	},
	[42505755] = { label="Purple Peat",
		quest=90692, -- 90693 (90578 is on the vignette, but didn't trigger...)
		npc=241920, -- 241919
		loot={
			239448, -- Reshii Magi's Vestments
			239459, -- Reshii Scout's Hood
			239460, -- Reshii Scout's Breeches
			239466, -- Reshii Skirmisher's Gauntlets
			239472, -- Reshii Brute's Breastplate
			240168, -- Reshii Magi's Seal
		},
		vignette=6917, -- also 6891?
		note="Complete {quest:87546:Warrant Purple Peat} to summon",
	},
	[71792823] = { label="Korgoth the Hungerer",
		quest=84993, -- 91286; these didn't trip after the Energy-Pod: 91309, 91433
		npc=231229,
		loot={
			{246240, mount=2602, note="needs 20"}, -- Devoured Energy-Pod
			{232467, quest=85722,}, -- Crystallized Anima
			240111, -- Reshii Skirmisher's Axe
			240112, -- Reshii Scout's Blade
			240113, -- Reshii Magi's Dagger
			240114, -- Reshii Skirmisher's Morningstar
			240115, -- Reshii Brute's Warmace
			240116, -- Reshii Brute's Longsword
			240119, -- Reshii Skirmisher's Staff
			240120, -- Reshii Magi's Lantern
			240121, -- Reshii Brute's Barrier
		},
		vignette=6608, -- Devourer Attack: The Oasis
	},
	-- not yet vignette-coords:
	--[[
	[0] = { label="Hollowbane",
		quest=90582,
		npc=238536,
		vignette=6915, -- also 6773?
		note="Complete {quest:87343:Warrant Hollowbane} to summon",
	},
	[0] = { label="Phase-Thief Tezra",
		quest=86550,
		npc=235422,
		vignette=6727,
	},
	[0] = { label="Shatterpulse",
		quest=90577,
		npc=238135, -- 238144
		vignette=6916, -- also 6771?
		note="Complete {quest:87001:Warrant Shatterpulse} to summon",
	},
	--]]
	--[[
	-- These don't have vignettes in the files:
	[0] = { label="D'rude",
		quest=nil,
		npc=244453,
		--vignette=,
	},
	[0] = { label="Phase Hunter Om'nun",
		quest=nil,
		npc=235423,
		--vignette=,
	},
	[0] = { label="Invasive Phasecrawler",
		quest=nil,
		npc=244448,
		--vignette=,
	},
	[0] = { label="Boss 2",
		quest=nil,
		npc=238137,
		--vignette=,
	},
	[0] = { label="Great Devourer",
		quest=nil,
		npc=244444,
		--vignette=,
	},
	[0] = { label="Mercenary Acquisitionist",
		quest=nil,
		npc=244442,
		--vignette=,
	},
	[0] = { label="Soroth Miasmawrath",
		quest=nil,
		npc=240967,
		--vignette=,
	},
	[0] = { label="[DNT] Kill Credit",
		quest=nil,
		npc=239812,
		--vignette=,
	},
	--]]
})
ns.RegisterPoints(ns.KARESH_TAZAVESH, {
	[31225813] = { label="Xy'vox the Twisted",
		quest=90694, -- 90695 (90580 on vignette but didn't flip)
		npc=238384,
		loot={
			239455, -- Reshii Magi's Bands
			239457, -- Reshii Scout's Soles
			239461, -- Reshii Scout's Shoulderpads
			239470, -- Reshii Skirmisher's Sash
			239479, -- Reshii Brute's Vambraces
			246065, -- Reshii Magi's Band
		},
		vignette=6772, -- also 6770?
		note="Complete {quest:87345:Warrant Xy'vox the Twisted} to summon",
	},
	[27557044] = { label="The Wallbreaker",
		quest=86465, -- 91436, 91312, 91290
		npc=235104,
		loot={
			{246240, mount=2602, note="needs 20"}, -- Devoured Energy-Pod
			{238665, quest=89063,}, -- Crystallized Anima
			240111, -- Reshii Skirmisher's Axe
			240112, -- Reshii Scout's Blade
			240113, -- Reshii Magi's Dagger
			240114, -- Reshii Skirmisher's Morningstar
			240116, -- Reshii Brute's Longsword
			240117, -- Reshii Magi's Wand
			240121, -- Reshii Brute's Barrier
		},
		vignette=6708, -- Devourer Attack: Tazavesh
	},
}, {
	parent=true,
})
