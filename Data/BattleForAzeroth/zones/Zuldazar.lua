local myname, ns = ...

-- Treasures of Zuldazar
ns.RegisterPoints(862, { -- Zuldazar
    [54093150] = {quest=48938, criteria=40988, note="On second floor",}, -- Offerings of the Chosen
    [64712167] = {quest=50259, criteria=40989,}, -- Witch Doctor's Hoard
    [51718690] = {quest=49936, criteria=40990, note="Bottom floor of ship",}, -- Spoils of Pandaria
    [51442661] = {quest=50582, criteria=40991, note="Top of hill", path=50112715}, -- Gift of the Brokenhearted
    [49506526] = {quest=49257, criteria=40992, note="Top of ship",}, -- Warlord's Cache
    [38793444] = {quest=50707, criteria=40993, note="Up on the rocks", path={39903290, 41003328, 41973566, note="Behind the waterfall"},}, -- Dazar's Forgotten Chest
    [61065863] = {quest=50947, criteria=40994, npc=133208, note="Event: kill Da White Shark first",}, -- Da White Shark's Bounty
    [71821677] = {quest=50949, loot={163036}, criteria=40995, note="In cave", path=71161767}, -- The Exile's Lament
    [56123806] = {quest=51338, criteria=40996, note="In cave behind waterfall",}, -- Cache of Secrets
    [52974719] = {quest=51624, criteria=40997}, -- Riches of Tor'nowa
    [54303440] = {quest=52269, loot={161443}, note="Pepe'jin is perched above the bar",}, -- A Tiny Voodoo Mask
}, {achievement=12851,})
ns.RegisterPoints(1165, { -- Dazar'alor
    [59258870] = {quest=50947, minimap=true, criteria=40994, npc=133208, note="Event: kill Da White Shark first",}, -- Da White Shark's Bounty
    [44472690] = {quest=51338, minimap=true, criteria=40996, note="In cave behind waterfall",}, -- Cache of Secrets
    [38300716] = {quest=48938, minimap=true, criteria=40988, note="On top of the Hall of the High Priests", path=41141101}, -- Offerings of the Chosen
    [39001580] = {quest=52269, loot={161443}, note="Pepe'jin is perched above the bar",}, -- A Tiny Voodoo Mask
}, {achievement=12851,})

-- A Loa of a Tale
local tale = {
    achievement=13036,
    atlas="profession",
    minimap=true,
}
ns.RegisterPoints(862, { -- Zuldazar
    [43747674] = {criteria=41573,}, -- Tales of de Loa: Rezan
    [47842884] = {criteria=41576,}, -- Tales of de Loa: Shadra
    [48545460] = {criteria=41569,}, -- Tales of de Loa: Jani
    [49004129] = {criteria=41572,}, -- Tales of de Loa: Pa'ku
    [51692825] = {criteria=41566,}, -- Tales of de Loa: Gonk
    [57703170] = {criteria=41581,}, -- Tales of de Loa: Zandalar
    [67281762] = {criteria=41577,}, -- Tales of de Loa: Torcali
    [75506760] = {criteria=41567,}, -- Tales of de Loa: Gral
}, tale)
ns.RegisterPoints(1165, { -- Dazar'alor
    [53230940] = {criteria=41581,}, -- Tales of de Loa: Zandalar
}, tale)

-- Junk
local junk = {
    label='Treasure Chest',
    group="junk",
}
ns.RegisterPoints(862, { -- Zuldazar
    [50823158] = {quest=50711,},
    [65041636] = {quest=50715,},
    [68902222] = {quest=50715,},
    [68503365] = {quest=50716,},
    [74836214] = {quest=50719,},
    [66552896] = {quest=50720,},
    [63062832] = {quest=50720,},
    [75042303] = {quest=50721,},
    [48984088] = {quest=50722,},
    [45676019] = {quest=50723,},
    [47526049] = {quest=50723,},
    [80791415] = {quest=50724,},
    [80151648] = {quest=50724,},
    [41127489] = {quest=50726,},
    [43177297] = {quest=50726,},
    [40953756] = {quest=50727,},
    [81203857] = {quest=50728,},
    [80135512] = {quest=51346,},
    [82465431] = {quest=51346,},
}, junk)
ns.RegisterPoints(1165, { -- Dazar'alor
    [48981013] = {quest=49142, parent=true,},
    [52341766] = {quest=49142, parent=true,},
}, junk)

-- Rares

-- Adventurer of Zuldazar
ns.RegisterPoints(862, { -- Zuldazar
    [80972163] = {quest=50280, npc=129961, loot={161042}, criteria=41850, note="Climb the ropes onto the ship"}, -- Atal'zul Gotaka
    [64253271] = {quest=50439, npc=129954, loot={161043}, criteria=41851,}, -- Gahz'ralka
    [44157652] = {quest=51083, npc=136428, loot={160979}, criteria=41852,}, -- Dark Chronicler
    [53404465] = {quest=51080, npc=136413, loot={161047}, criteria=41853, path=53944489, note="In cave, down the river"}, -- Syrawon the Dominus
    [48005424] = {quest=49972, npc=131476, loot={161125}, criteria=41869,}, -- Zayoos
    [58777395] = {quest=49911, npc=131233, loot={161033}, criteria=41870,}, -- Lei-zhi
    [49855744] = {quest=49410, npc=129343, loot={161034}, criteria=41871, path=49605911, note="In cave",}, -- Avatar of Xolotal
    [59821830] = {quest=49267, npc=128699, loot={161104}, criteria=41872,}, -- Bloodbulge
    [46616533] = {quest=49004, npc=127939, loot={161029}, criteria=41873,}, -- Torraske the Eternal
    [68714875] = {quest=48543, npc=126637, loot={160984}, criteria=41874,}, -- Kandak
    [59605640] = {quest=48333, npc=120899, loot={160947}, criteria=41875,}, -- Kul'krazahn
    [74112850] = {quest=47792, npc=124185, loot={161035}, criteria=41876,}, -- Golrakahn
    [71423239] = {quest=47567, npc=122004, loot={161091}, criteria=41877, path=70333301, note="In cave",}, -- Umbra'jin
    [65411022] = {quest=50693, npc=134760, loot={160958}, criteria=41855,}, -- Darkspeaker Jo'la
    [42003620] = {quest=50677, npc=134738, loot={160978}, criteria=41856,}, -- Hakbi the Risen
    [61904622] = {quest=50508, npc=134048, loot={162613}, criteria=41858, note="Interact with Strange Egg",}, -- Vukuba
    [43952544] = {quest=50438, npc=133842, loot={161040}, criteria=41859,}, -- Warcrawler Karkithiss
    [60626627] = {quest=50281, npc=134782, loot={161022}, criteria=41863,}, -- Murderbeak
    [74203930] = {quest=50269, npc=133190, criteria=41864,}, -- Daggerjaw
    [79973597] = {quest=50260, npc=133155, criteria=41865,}, -- G'Naat
    [75613582] = {quest=50159, npc=132244, loot={161112}, criteria=41866,}, -- Kiboku
    [66203240] = {quest=50034, npc=131718, loot={161020}, criteria=41867,}, -- Bramblewing
    [77711029] = {quest=50013, npc=131687, loot={161109}, criteria=41868,}, -- Tambano
}, {achievement=12944,})
ns.RegisterPoints(1165, { -- Dazar'alor
    [55378240] = {quest=48333, npc=120899, loot={160947}, criteria=41875,}, -- Kul'krazahn
}, {achievement=12944,})

-- non-achievement:
ns.RegisterPoints(862, { -- Zuldazar
    [69783776] = {quest=54770, npc=149147, loot={166345},}, -- N'chala  the Egg Thief
})

-- Life Finds a Way... To Die!
ns.RegisterPoints(862, { -- Zuldazar
    [67732903] = {npc=135512, criteria=41675, note="Shares spawn timer with Azuresail the Ancient and Kil'Tawan",}, -- Thuderfoot the Brutosaur
    [67102657] = {npc=135510, criteria=41676, note="Shares spawn timer with Thunderfoot and Kil'Tawan",}, -- Azuresail the Diemetrodon
    [71134034] = {npc=139365, criteria=41672, note="South of Savagelands",}, -- Queenfeather the Ravasaur
    [52394771] = {npc=129323, criteria=41674, note="Can be found near the road in the grass",}, -- The Sabertusk Empress
    [66082238] = {npc=143910, criteria=41684, note="South of the Nesingwary's Trek windrider",}, -- Sludgecrusher the Anklyodon
    [61622537] = {npc=130741, criteria=41673, note="Fighting Ten'gor at crossroad",}, -- Nol'ixwan the Direhorn
    [71242184] = {npc=123502, criteria=41677, note="On the road from Zeb'ahari to Tal'gurub",}, -- King K'tal the Devilsaur
}, {achievement=13048,})
