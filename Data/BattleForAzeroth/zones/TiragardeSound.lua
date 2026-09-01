local myname, ns = ...

-- Treasures of Tiragarde
ns.RegisterPoints(895, { -- Tiragarde Sound
    [61515233] = {quest=49963, criteria=41012, npc=130350, loot={155571}, note="Ride the Guardian",}, -- Hay Covered Chest; Guardian of the Spring (49983 is the ride, 49963 is the loot)
    [56033319] = {quest=52866, criteria=41014,}, -- Precarious Noble Cache
    [72482169] = {quest=52870, criteria=41016, note="In cave",}, -- Scrimshaw Cache
    [72495814] = {quest=50442, loot={155381}, criteria=41013,}, -- Cutwater Treasure Chest
    [61786275] = {quest=52867, criteria=41015, note="In cave",}, -- Forgotten Smuggler's Stash
    [73103950] = {quest=52195, loot={161342}, criteria=41017, note="In Boralus, on Stomsong Monastary",}, -- Secret of the Depths
    [55769095] = { label="Secret of the Depths",
        quest=52195,
        loot={161342}, criteria=41017, note="Teleport here from Stormsong, pick up the gem",
        hide_before={ns.conditions.QuestComplete(52134), ns.conditions.QuestComplete(52135), ns.conditions.QuestComplete(52136), ns.conditions.QuestComplete(52137), ns.conditions.QuestComplete(52138)},
    },
    -- Freehold treasure maps
    [80007600] = {quest=52853, loot={162571}, criteria=41018, note="Kill pirates in Freehold until the map drops",}, -- Soggy Treasure Map 162571 (q:52853)
    [80708050] = {quest=52859, loot={162581}, criteria=41020, note="Kill pirates in Freehold until the map drops",}, -- Yellowed Treasure Map 162581 (q:52859)
    [74008300] = {quest=52854, loot={162580}, criteria=41019, note="Kill pirates in Freehold until the map drops",}, -- Fading Treasure Map 162580 (q:52854)
    [76008500] = {quest=52860, loot={162584}, criteria=41021, note="Kill pirates in Freehold until the map drops",}, -- Singed Treasure Map 162584 (q:52860)
    -- ...and the actual treasures they point to
    [54994608] = {quest=52807, hide_before=ns.conditions.QuestComplete(52853), criteria=41018, note="Kill pirates in Freehold until the map drops",}, -- Soggy Treasure Map 162571 (q:52853)
    [90507551] = {quest=52836, hide_before=ns.conditions.QuestComplete(52859), criteria=41020, note="Kill pirates in Freehold until the map drops",}, -- Yellowed Treasure Map 162581 (q:52859)
    [29222534] = {quest=52833, hide_before=ns.conditions.QuestComplete(52854), criteria=41019, note="Kill pirates in Freehold until the map drops",}, -- Fading Treasure Map 162580 (q:52854)
    [48983759] = {quest=52845, hide_before=ns.conditions.QuestComplete(52860), criteria=41021, note="Kill pirates in Freehold until the map drops",}, -- Singed Treasure Map 162584 (q:52860)
}, {
    achievement=12852,
})
ns.RegisterPoints(1161, { -- Boralus
    [61901010] = {quest=52870, criteria=41016, note="In cave",}, -- Scrimshaw Cache
    -- Secret of the Depths:
    [61518382] = {quest=52195, atlas="MagePortalAlliance", minimap=true, criteria=41017, note="Entrance to the underwater cave",},
    [55979126] = {quest=52134, atlas="poi-workorders", minimap=true, criteria=41017, note="Read Damp Scrolls; in the underwater cave, from the monastary",},
    [61527772] = {quest=52135, atlas="poi-workorders", minimap=true, criteria=41017, note="Read Damp Scrolls; underground",},
    [63078186] = {quest=52136, atlas="poi-workorders", minimap=true, criteria=41017, note="Read Damp Scrolls; upstairs",},
    [70328576] = {quest=52137, atlas="poi-workorders", minimap=true, criteria=41017, note="Read Damp Scrolls; underground",},
    [67147982] = {quest=52138, atlas="poi-workorders", minimap=true, criteria=41017, note="Read Damp Scrolls",},
    [55769095] = { label="Secret of the Depths",
        quest=52195, criteria=41017,
        loot={161342},
        note="Ominous Altar; use it, get teleported, pick up the gem",
        atlas="DemonInvasion2", scale=1.4, minimap=true,
        hide_before={ns.conditions.QuestComplete(52134), ns.conditions.QuestComplete(52135), ns.conditions.QuestComplete(52136), ns.conditions.QuestComplete(52137), ns.conditions.QuestComplete(52138)},
    },
}, {
    achievement=12852,
})

-- Shanty Raid
local shanty =  {
    achievement=13057,
    atlas="poi-workorders",
    minimap=true,
}
ns.RegisterPoints(895, { -- Tiragarde Sound
    [43382585] = {quest=53410, loot={163715}, criteria=41542, note="In a cave",}, -- Fruit Counting
    [76218306] = {quest=50233, loot={163717}, criteria=41544, note="Kill Barman Bill",}, -- Josephus
    [56706990] = {quest=50096, loot={163718}, criteria=41545, note="Kill Black-Eyed Bart",}, -- Black Sphere
    [73208410] = {quest=53411, loot={163719}, criteria=41546, note="Ground floor, on a table",}, -- Horse
    [70602270] = {quest=53407, loot={163716}, criteria=41543, note="Behind Jay the Tavern Bard",}, -- Inebriation
    [74403540] = {quest=53408, loot={163714}, criteria=41541, note="On the fireplace mantel",}, -- Lively Men
}, shanty)
ns.RegisterPoints(1161, { -- Boralus
    -- Shanty Raid
    [72616853] = {quest=53408, loot={163714}, criteria=41541, note="On the fireplace mantel",}, -- Lively Men
    [53141767] = {quest=53407, loot={163716}, criteria=41543, note="Behind Jay the Tavern Bard",}, -- Inebriation
}, shanty)

-- junk
local junk = {
    label='Small Treasure Chest',
    group="junk",
}
ns.RegisterPoints(895, { -- Tiragarde Sound
    [83673580] = {quest=53631, label="Dusty Marine Supplies",},
    [76967543] = {quest=48593,},
    [78008050] = {quest=48595,},
    [76358090] = {quest=48595,},
    [73468317] = {quest=48596,},
    [75758283] = {quest=48596,},
    [38432868] = {quest=48598,},
    [38762673] = {quest=48599,},
    [78114901] = {quest=48607,},
    [79205050] = {quest=48607,},
    [81314939] = {quest=48607,},
    [81344938] = {quest=48607,},
    [76126733] = {quest=48608,},
    [77576583] = {quest=48608, vignette=2211,},
    [78266779] = {quest=48608,},
    [67115938] = {quest=48609, vignette=2212,},
    [68635108] = {quest=48609,},
    [50842310] = {quest=48611,},
    [47442365] = {quest=48611,},
    [48392785] = {quest=48611,},
    [61212836] = {quest=48612,},
    [57311757] = {quest=48617,},
    [87347379] = {quest=48618,},
    [88387840] = {quest=48618,},
    [69801270] = {quest=48619,},
    [46481829] = {quest=48621,},
}, junk)
ns.RegisterPoints(1161, { -- Boralus
    [66758031] = {quest=50952,},
}, junk)

-- Rares

-- Adventurer of Tiragarde Sound
ns.RegisterPoints(895, { -- Tiragarde Sound
    [75147848] = {quest=50156, npc=132182, criteria=41793,}, -- Auditor Dolp
    [76218305] = {quest=50233, npc=129181, loot={163717}, criteria=41795,}, -- Barman Bill
    [34013029] = {quest=50094, npc=132068, criteria=41796,}, -- Bashmu
    [56676994] = {quest=50096, npc=132086, loot={163718}, criteria=41797,}, -- Black-Eyed Bart
    [84707385] = {quest=51808, npc=139145, loot={154411}, criteria=41798, note="Hillside above the cave",}, -- Blackthorne
    [83364413] = {quest=49999, npc=130508, criteria=41800,}, -- Broodmother Razora
    [38422066] = {quest=50097, npc=132088, criteria=41806,}, -- Captain Wintersail
    [72838146] = {quest=51809, npc=139152, criteria=41812,}, -- Carla Smirk
    [89787815] = {quest=50155, npc=132211, criteria=41813,}, -- Fowlmouth
    [59982275] = {quest=50137, npc=132127, criteria=41814,}, -- Foxhollow Skyterror
    [57725613] = {quest=53373, npc=139233, criteria=41819,}, -- Gulliver
    [48072334] = {quest=49984, npc=131520, criteria=41820,}, -- Kulett the Ornery
    [68352088] = {quest=50525, npc=134106, loot={155524}, criteria=41821,}, -- Lumbergrasp Sentinel
    [58094870] = {quest=51880, npc=139290, loot={154458}, criteria=41822,}, -- Maison the Portable
    [64291931] = {quest=51321, npc=137183, loot={160472}, criteria=41823,}, -- Imperiled Merchants (Honey-Coated Slitherer)
    [43801771] = {quest=49921, npc=131252, criteria=41824,}, -- Merianae
    [65176460] = {quest=51833, npc=139205, criteria=41825,}, -- P4-N73R4
    [39461517] = {quest=49923, npc=131262, loot={160263}, criteria=41826,}, -- Pack Leader Asenya
    [64805893] = {quest=50148, npc=132179, loot={161446}, criteria=41827,}, -- Raging Swell
    [68336362] = {quest=51872, npc=139278, criteria=41828,}, -- Ranja
    [58541513] = {quest=48806, npc=127290, loot={154416}, criteria=41829,}, -- Saurolisk Tamer Mugg (Mugg)
    [76022887] = {quest=51877, npc=139287, loot={155273}, criteria=41830,}, -- Sawtooth
    [55703318] = {quest=51876, npc=139285, criteria=41831,}, -- Shiverscale the Toxic
    [80838277] = {quest=50160, npc=132280, criteria=41832,}, -- Squacks
    [49353613] = {quest=51807, npc=139135, criteria=41833,}, -- Squirgle of the Depths
    [66701427] = {quest=51873, npc=139280, criteria=41834,}, -- Sythian the Swift
    [60801727] = {quest=50301, npc=133356, criteria=41835,}, -- Tempestria
    [55095056] = {quest=51879, npc=139289, criteria=41836,}, -- Tentulos the Drifter
    [63735039] = {quest=49942, npc=131389, loot={158556}, criteria=41837,}, -- Teres
    [70035567] = {quest=51835, npc=139235, criteria=41838,}, -- Tort Jaw
    [46391997] = {quest=50095, npc=132076, loot={160452}, criteria=41839,}, -- Totes
    [70271283] = {quest=50073, npc=131984, loot={160473}, criteria=41840,}, -- Twin-hearted Construct
}, {achievement=12939,})
ns.RegisterPoints(1161, { -- Boralus
    [80403500] = {quest=51877, npc=139287, criteria=41830,}, -- Sawtooth
}, {achievement=12939,})

-- non-achievement
ns.RegisterPoints(895, { -- Tiragarde Sound
    -- [52253215] = {quest=nil, npc=132052, loot={155074},}, -- Vol'Jim (removed from game?)
})