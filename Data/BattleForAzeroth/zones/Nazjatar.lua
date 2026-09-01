local myname, ns = ...

local CHEST_AR = 'Arcane Chest'
local AR_TRUNK = 'Arcane Trunk'

ns.RegisterPoints(1355, { -- Nazjatar
    -- [43227436] = {quest=56290,}, -- forgot what this is
    [85203860] = {quest=55938,},
    [80302980] = {quest=55939,},
    [74805320] = {quest=55940,},
    [73313580] = {quest=55941, note="Inside Temple, bottom floor"},
    [79502720] = {quest=55942},
    [64303350] = {quest=55943},
    [56493390] = {quest=55944, note="Top of the cliffs"},
    [52904980] = {quest=55945},
    [58103510] = {quest=55946, path=57303900, note="Underwater Cave"},
    [44804880] = {quest=55947},
    [43305810] = {quest=55948},
    [49506450] = {quest=55949},
    [38707440] = {quest=55950},
    [48508740] = {quest=55951},
    [34704350] = {quest=55952, path=37404280, note="Inside Cave"},
    [26003230] = {quest=55953, note="Under Starfish pile"},
    [34504050] = {quest=55954},
    [50605000] = {quest=55955, path=49705030, note="Inside Cave"},
    [39804930] = {quest=55956},
    [38006060] = {quest=55957},
}, {
    achievement=13549,
    label=CHEST_AR,
    minimap=true,
})

ns.RegisterPoints(1355, { -- Nazjatar
    [61502290] = {quest=55958, label="Arcane Pylon", path=61401990, note="Inside Cave"}, -- game quest id: 55359
    [37900604] = {quest=55959, path=39351005, note="Inside Cave"},
    [55701440] = {quest=55961,}, -- game quest id: 55998
    [64202850] = {quest=55962, note="Click Arcane device on the side on the right"}, -- game quest id: 55996
    [43901680] = {quest=55963,},
    [37191919] = {quest=55960, note="Underwater Cave"},
    [24803520] = {quest=56912, label="Arcane Pylon", path=26703380, note="Inside Cave"}, -- game quest id: 56913
    [80503190] = {quest=56547, label="Arcane Pylon", path=83003380, note="Up the building"}, -- game quest id: 56913
}, {
    achievement=13549,
    label=AR_TRUNK,
    minimap=true,
})

ns.RegisterPoints(1355, {
    -- Cats!
    [28802910] = {quest=56983, note="Underwater cave",},
    [61102680] = {quest=56984,},
    [59103040] = {quest=56985,},
    [55302720] = {quest=56986,},
    [40158608] = {quest=56987, path=40318144, note="In underwater cave",},
    [71402370] = {quest=56988,},
    [38004930] = {quest=56989, path=38704930,},
    [58202200] = {quest=56990,},
    [61601070] = {quest=56991,},
    [73602590] = {quest=56992,},
}, {
    achievement=13836,
    label='Crystalline Cat Figurine',
    atlas="Warfront-AllianceHero-Silver", scale=1.2,
    minimap=true,
})
ns.RegisterPoints(1355, {
    -- Jellies!
    -- all the quests are {daily,weekly}
    -- TODO: better activation criteria for the quests
    [54904870] = {quest={55427,55470,any=true},label="{npc:151218} #1"},
    [71712570] = {quest={55428,55471,any=true},label="{npc:151782} #2"},
    [45702411] = {quest={55429,55472,any=true},label="{npc:151874} #3"},
    [32763953] = {quest={55430,55473,any=true},label="{npc:151875} #4"},
}, {
    achievement=13715,
    atlas="vehicle-templeofkotmogu-cyanball", scale=1.2,
    loot={
        {167804, pet=2765}, -- Slimy Sea Slug
        {167805, pet=2757}, -- Slimy Otter
        {167806, pet=2760}, -- Slimy Octopode
        {167807, pet=2761}, -- Slimy Fangtooth
        {167808, pet=2758}, -- Slimy Eel
        {167809, pet=2762}, -- Slimy Darkhunter
        {167810, pet=2763}, -- Slimy Hermit Crab
    },
    note="Get a {item:167893} and use {spell:293404} to lure any critter here. Each {npc:151875} can be fed daily. Feed it five times and it'll give you a pet.",
    minimap=true,
})

-- Rares

-- I Thought You Said They'd Be Rare
ns.RegisterPoints(1355, { -- Nazjatar
    [78003280] = {quest=56276, npc=151870, loot={{169369, pet=2703}}, criteria=45543, note="Summoned using a [Scrying Stone]"}, -- Sandcastle
    [58805460] = {quest=56281, npc=152566, loot={170184}, criteria=45522, note="Requires killing a Colossal Ray on top of it for spawn"}, -- Anemonar
    [50606920] = {quest=56287, npc=152567, loot={170184}, criteria=45535, note="Requries charming a Muck Slug using a [Prismatic Crystal] and bringing it in front of him"}, -- Kelpwillow
    [78602580] = {quest=56288, npc=152397, loot={170184}, criteria=45539, note="Requires summoning the Drowned Hatchling pet in front of him"}, -- Oronu
    [31603060] = {quest=56299, npc=152568, loot={170184}, criteria=45557, note="Must kill a Staghorn Reefwalker in front of him"}, -- Urduu
    [71605420] = {quest=56282, npc=152561, loot={170179}, criteria=45524, note="Spawns after you kill Siltstalker"}, -- Banescale the Packfather
    [56204360] = {quest=56272, npc=152291, loot=nil, criteria=45530}, -- Deepglider
    [28802900] = {quest=55671, npc=152323, loot={{169371, pet=2681}}, criteria=45536, note="Requires to Shoo the Bloodfin Tadpoles until the King emotes a few times"}, -- King Gakula
    [71405480] = {quest=56297, npc=152359, loot={170179}, criteria=45550}, -- Siltstalker the Packmother
    [64604700] = {quest=56278, npc=152360, loot={170178}, criteria=45556}, -- Toxigore the Alpha
    [63803260] = {quest=56284, npc=152414, loot=nil, criteria=45531}, -- Elder Unu
    [52404200] = {quest=56279, npc=152415, loot=nil, criteria=45519}, -- Alga the Eyeless
    [69204020] = {quest=56280, npc=152416, loot=nil, criteria=45520}, -- Allseer Oma'kil
    [47205500] = {quest=56286, npc=152448, loot={{169352, pet=2686}}, criteria=45534, note="Requires killing Glimmershell Hulks around his spawn points"}, -- Iridescent Glimmershell
    [45602560] = {quest=56275, npc=152465, loot={{169357, pet=2689}}, criteria=45538}, -- Needlespine
    [35604120] = {quest=56292, npc=152548, loot={{169370, pet=2704}}, criteria=45545}, -- Scale Matriarch Gratinax
    [27403720] = {quest=56293, npc=152545, loot={{169370, pet=2704}}, criteria=45546}, -- Scale Matriarch Vynara
    [28704630] = {quest=56294, npc=152542, loot={{169370, pet=2704}}, criteria=45547}, -- Scale Matriarch Zodia
    [37201320] = {quest=56274, npc=144644, loot={{169366, pet=2700}}, criteria=45537}, -- Mirecrawler
    [36003960] = {quest=56273, npc=152553, loot={170180}, criteria=45533}, -- Garnetscale
    [52207400] = {quest=56285, npc=152555, loot={{169359, pet=2693}}, criteria=45532}, -- Elderspawn Nalaada
    [49008800] = {quest=56270, npc=152556, loot=nil, criteria=45528}, -- Chasm-Haunter
    [43008760] = {quest=56289, npc=152681, loot={{169367, pet=2701}}, criteria=45540}, -- Prince Typhonus
    [42807480] = {quest=56290, npc=152682, loot={{169368, pet=2702}}, criteria=45541}, -- Prince Vortran
    [36408000] = {quest=56269, npc=152712, loot={{169372, pet=2682}}, criteria=45525}, -- Blindlight
    [72203620] = {quest=56268, npc=152794, loot={{169363, pet=2697}}, criteria=45521}, -- Amethyst Spireshell
    [64804060] = {quest=56277, npc=152795, loot={{169350, pet=2684}}, criteria=45544}, -- Sandclaw Stoneshell
    [37801440] = {quest=56296, npc=153658, loot={170182}, criteria=45549}, -- Shiz'narasz the Consumer
    [62402960] = {quest=56122, npc=153898, loot={170502}, criteria=45553, note="Must kill chanelling Azsh'ari Invokers until it spawns"}, -- Tidelord Aquatus
    [57602600] = {quest=56123, npc=153928, loot={170502}, criteria=45554, note="Must kill chanelling Azsh'ari Invokers until it spawns"}, -- Tidelord Dispersius
    [39005930] = {quest=56271, npc=152756, loot={{169361, pet=2695}}, criteria=45529}, -- Daggertooth Terror
    [63401160] = {quest=56295, npc=152552, loot={{170187, toy=true}}, criteria=45548}, -- Shassera
    [67152325] = {quest=56106, npc=154148, loot={{170196, toy=true}}, criteria=45555}, -- Tidemistress Leth'sindra
    [40800735] = {quest=56283, npc=152464, loot={{169356, pet=2690}}, criteria=45527}, -- Caverndark Terror
    [62405950] = {quest=56291, npc=150583, loot={{169374, pet=2707}}, criteria=45542, note="Has a chance to spawn after you kill Algans"}, -- Rockweed Shambler
    [57605220] = {quest=56298, npc=152290, loot={{169163, mount=1257}}, criteria=45551}, -- Soundless
    [67603460] = {quest=56300, npc=151719, loot=nil, criteria=45558, note="Get a Molted Shell to break rocks"}, -- Voice in the Deeps
}, {achievement=13691,})

-- Non-achievement
ns.RegisterPoints(1355, { -- Nazjatar
    [48352400] = {quest=55603, npc=150468, loot={{169376, pet=2709}}}, -- Vor'koth
    [36901120] = {quest=55584, npc=150191, loot={{169373, pet=2706}}}, -- Avarius
    [54804200] = {quest=55366, npc=149653, loot={{169375, pet=2708}}}, -- Carnivorous Lasher (also seen 56296 + 56587)
    [83913611] = { label="Ulmath, The Soulbinder",
        quest=56057, -- The Soulbinder
        npc=152697,
        loot={
            168603, -- Cloak of Restless Spirits
            169317, -- Enthraller's Bindstone
            170088, -- Ulmath's Soulseeker
            170089, -- Liara's Spire
            170090, -- Merciless Pincher
            170091, -- Willbinder's Halberd
            170092, -- Netherdancer's Knife
            170093, -- Tyr'mar's Greatsword
            170094, -- Temple Guardian's Saber
            170095, -- Moon Priestess' Baton
        },
        worldquest=56057,
    },
})
