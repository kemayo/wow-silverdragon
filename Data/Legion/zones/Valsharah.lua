local myname, ns = ...

local TREASURE = {
    achievement=11258,
    requires=ns.conditions.AuraInactive(185719),
}

ns.RegisterPoints(641, { -- Val'sharah
    [33815826] = {quest=39081, label=ns.CHEST},
    -- [37005734] = {quest=39083, label=ns.CHEST_SM},
    [38456530] = {quest=39080, label=ns.CHEST_SM, note="Basement; must have completed The Farmsteads"},
    [38626718] = {quest=39079, label=ns.CHEST_SM},
    [39945460] = {quest=38369, label=ns.CHEST_SM},
    [41404560] = ns.path{quest={39085,39086}, label="Darkpens"},
    [42665801] = {quest=39077, label=ns.CHEST_SM},
    [43068822] = {quest=44138, label=ns.CHEST, note="Cave entrance @ 43.7, 89.9"},
    [43225488] = {quest=39084, label=ns.CHEST, note="Top of wall"},
    [43397589] = {quest=38363, label=ns.CHEST_SM},
    [44358257] = {quest=38387, loot={141892}, label=ns.CHEST, note="Cave under the inn; entrance behind the building"},
    [45106120] = {quest=39083, label=ns.CHEST_SM, note="Hidden in the tree"},
    [46448630] = {quest=38277, label=ns.CHEST_SM},
    [48687381] = {quest=38366, label=ns.CHEST_SM, note="Under tree roots"},
    [48998615] = {quest=38886, label=ns.CHEST_SM},
    [51247777] = {quest=38388, label=ns.CHEST_SM, note="Cave entrance @ 50.9, 77.0", path=50907700},
    [54003489] = {quest=38390, loot={141891}, label=ns.CHEST_GLIM, note="Cave entrance @ 53.2, 38.0", path=53203800},
    [54187061] = {quest=39093, label=ns.CHEST_SM, note="In cave"},
    [54417419] = {quest=38359, label=ns.CHEST_SM, note="In house behind the fence"},
    [54506048] = {quest=39097, loot={130152}, label=ns.CHEST, note="In cave"},
    [54908056] = {quest=38864, label=ns.CHEST_SM, note="In underwater cave", path=54108210},
    -- [54958054] = {quest=38861, label=ns.CHEST_SM, note="In underwater cave"}, -- removed? swapped for 38864?
    [56008376] = {quest=38861, label=ns.CHEST_SM},
    [56225730] = {quest=39072, label=ns.CHEST_SM},
    [59887228] = {quest=38943, label=ns.CHEST_SM, note="Upstairs, stairs on the right"},
    [60498216] = {quest=38893, label=ns.CHEST_SM, note="Cave entrance @ 62.1, 86.1", path=62108610},
    [61006400] = {quest=39087, label=ns.CHEST_SM},
    [61017917] = {quest=39089, label=ns.CHEST_GLIM},
    [61073421] = {quest=39088, label=ns.CHEST, note="Underwater, hidden in roots"},
    [61657372] = {quest=39087, label=ns.CHEST_SM},
    [62076737] = {quest=39071, label=ns.CHEST, note="Chest behind waterfall"},
    [62707040] = {quest=39069, label=ns.CHEST_SM, note="Second floor balcony"},
    [62708526] = {quest=44136, label=ns.CHEST_SM},
    [63007700] = {quest=39070, label=ns.CHEST_SM, note="Inside Den of Claws, entrance @ 62.2, 76.2", path={62207620, label="Den of Claws entrance"}},
    [63277401] = {quest=39102, label=ns.CHEST},
    [63378841] = {quest=38389, label=ns.CHEST_SM},
    [63904556] = {quest=44139, label=ns.CHEST_SM},
    [65907920] = {quest=38391, label=ns.CHEST_SM},
    [64715126] = {quest=38355, label=ns.CHEST_SM},
    [65398629] = {quest=39074, label=ns.CHEST},
    [66604090] = {quest=39108, label=ns.CHEST},
    -- [67105770] = {quest=, loot={139023}, label="Elven Chest"}, -- no tracking quest triggers here...
    [67215928] = {quest=38782, label=ns.CHEST, note="Cave entrance @ 65.9, 56.3; doesn't appear until area quests are finished", path={65905630, label="Darkgrove Cavern"}},
    [67395342] = {quest=38386, label=ns.CHEST_SM},
    [68334060] = {quest=39073, label=ns.CHEST_SM},
    [69475999] = {quest=38781, label=ns.CHEST_SM},
    [70225704] = {quest=38783, label=ns.CHEST_SM},
}, TREASURE)

ns.RegisterPoints(642, { -- Darkpens, Val'sharah
    [42018849] = {quest=39085, label=ns.CHEST_SM, note="In water at bottom of stairs"},
    [50905168] = {quest=39086, label=ns.CHEST_GLIM},
}, TREASURE)

-- Rares

ns.RegisterPoints(641, { -- Val'sharah
    [34405830] = {quest=39121, npc=94414, criteria=33281, loot={141876}}, -- Kiranys Duskwhisper (Haunted Manor)
    [38055280] = {quest=38772, npc=92423, criteria=33275, loot={130136}}, -- Theryssia
    [41657825] = {quest=38479, npc=92180, criteria=33274, loot={{130171, toy=true}}}, -- Seersei
    [44155210] = {quest=38767, npc=92965, criteria=33276, loot={{130166, pet=1804}}, note="Bottom floor"}, -- Darkshade
    [45608880] = {quest=43446, npc=110562, criteria=33291, loot={130135}}, -- Bahagar
    [47205800] = {quest=39357, npc=95221, criteria=33285, loot={{130214, toy=true}}, vignette=967}, -- Mad Henryk (Old Bear Trap)
    [48904690] = {quest=44070, npc=93679, criteria=32406, loot={132359}}, -- Gathenak (Marius and Tehd vs a Satyr)
    [52748750] = {quest=38889, npc=93686, criteria=332, loot={{128690, pet=1706}}, vignette=886, note="Shivering Ashmaw Cub"}, -- Jinikki the Puncturer
    [55567762] = {quest=38466, loot={{130147,toy=true}}, vignette=775, note="Unguarded..."}, -- Unguarded Thistleleaf Treasure npc:92104
    [58753400] = {quest=40080, npc=93030, criteria=33277, loot={130126}}, -- Ironbranch
    [59807737] = {quest=38468, npc=92117, criteria=33273, loot={{130154, pet=1907}}, vignette=776, note="Talk to Lorel Sagefeather"}, -- Gorebeak
    [60194422] = {quest=39858, npc=97517, criteria=33288, loot={130125}, vignette=1028}, -- Dreadbog
    [60429072] = {quest=38887, npc=93654, criteria=33279, loot={130115}, vignette=887, note="Talk to Elindya Featherlight, then follow her"}, -- Skul'vrax
    [61126938] = {quest=39596, npc=95318, criteria=33286, loot={130137}, vignette=993}, -- Perrexx the Corruptor
    [61802955] = {quest=40079, npc=98241, criteria=33289, loot={130118}}, -- Lyrath Moonfeather
    [62664751] = {quest=38780, npc=93205, criteria=33278, loot={130121}, vignette=869}, -- Thondrax
    [64358463] = {quest=38900, criteria=33280, vignette=891, note="Talk to the sleeping druid, loot the chest hidden behind some dishes"}, -- Antydas Nightcaller npc:93758, quest 38903 for talking to him
    [65805343] = {quest=40126, npc=95123, criteria=33284, loot={130122}, vignette=1099}, -- Grelda the Hag
    [66853685] = {quest=39856, npc=97504, criteria=33287, loot={130116}}, -- Wraithtalon
    [67156960] = {quest=43176, npc=109708, criteria=33290, loot={130133}}, -- Undergrell Attack
    [67194551] = {quest=39130, npc=94485, criteria=33282, loot={{130168, pet=1802}}, vignette=944}, -- Pollous the Fetid (Purging the River)
}, {achievement=11262})
