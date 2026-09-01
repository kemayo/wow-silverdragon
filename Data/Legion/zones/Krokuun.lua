local myname, ns = ...

ns.RegisterPoints(830, { -- Krokuun
    [48505890] = {quest=48886, criteria=37594}, -- Lost Krokul Chest
    [51257624] = {quest=48884, criteria=37592, loot={153304}, path=50667531, note="Requires Lightforge Warframe. Jump on the rubble.", minimap=true, vignette=2291}, -- Krokuul Emergency Cache (48876 for opening)
    [55927430] = {quest=49156, criteria=37959, vignette=2326, note="Requires Shroud of Arcane Echoes"}, -- Precious Augari Keepsakes
    [62803730] = {quest=48885, criteria=37593, loot={151246}, note="Climb up behind the tower"}, -- Legion Tower Chest
    [75176974] = {quest=49154, criteria=37958, vignette=2325, note="Requires Shroud of Arcane Echoes. Stealth before opening."}, -- Long-Lost Augari Treasure
}, {
    achievement=12074,
    atlas="VignetteLootElite", scale=1.2,
})

-- Junk:
local LEGION_SUPPLIES = "Legion War Supplies"
local EREDAR_SUPPLIES = "Eredar War Supplies"
ns.RegisterPoints(830, { -- Krokuun
    [72293223] = {quest=48339, label=EREDAR_SUPPLIES},
    [52856280] = {quest=48339, label=EREDAR_SUPPLIES},
    [61406640] = {quest=48339, label=EREDAR_SUPPLIES},
    [43505520] = {quest=48339, label=EREDAR_SUPPLIES},
    [63014237] = {quest=48339, label=EREDAR_SUPPLIES, vignette=2046},
    [44854341] = {quest=48339, label=EREDAR_SUPPLIES, vignette=2046},
    [45905841] = {quest=48339, label=EREDAR_SUPPLIES, vignette=2046},

    [48553340] = {quest=47999, label=EREDAR_SUPPLIES, vignette=2025},
    [47782890] = {quest=47999, label=EREDAR_SUPPLIES, vignette=2025},
    [59544417] = {quest=47999, label=EREDAR_SUPPLIES},
    [61573519] = {quest=47999, label=EREDAR_SUPPLIES},
    [62803810] = {quest=47999, label=EREDAR_SUPPLIES},
    [66802490] = {quest=47999, label=EREDAR_SUPPLIES},
    [62394178] = {quest=47999, label=EREDAR_SUPPLIES},


    [67606990] = {quest=48000, label=EREDAR_SUPPLIES, note="Up on the ridge"},
    [69406280] = {quest=48000, label=EREDAR_SUPPLIES},
    [75006420] = {quest=48000, label=EREDAR_SUPPLIES},
    [71426162] = {quest=48000, label=LEGION_SUPPLIES},
    [74146790] = {quest=48000, label=EREDAR_SUPPLIES, vignette=2057},

    [46508520] = {quest=47997, label=EREDAR_SUPPLIES},
    [40617531] = {quest=47997, label=LEGION_SUPPLIES},
    [40357413] = {quest=47997, label=EREDAR_SUPPLIES, vignette=2002},
    [43868139] = {quest=47997, label=EREDAR_SUPPLIES, vignette=2002, path={43928135, 49287668, 49487606, 49627240, 49267026, 48816899}, note="Up on the ledge"},

    [64203910] = {quest=48885, label=LEGION_SUPPLIES, note="Requires Light's Judgement. Blow the pile of rubble with the ability"},

    [47705940] = {quest=48886, label=LEGION_SUPPLIES, note="Requires Light's Judgement. Blow the pile of rubble with the ability"},

    [32047451] = {quest=48336, label=LEGION_SUPPLIES},
    [35475618] = {quest=48336, label=LEGION_SUPPLIES},
    [37007430] = {quest=48336, label=LEGION_SUPPLIES},
    [41335836] = {quest=48336, label=LEGION_SUPPLIES},
    [36396765] = {quest=48336, label=LEGION_SUPPLIES},
    [34556303] = {quest=48336, label=EREDAR_SUPPLIES, vignette=2045},

    [56675875] = {quest=47752, label=LEGION_SUPPLIES},
    [55525237] = {quest=47752, label=EREDAR_SUPPLIES, vignette=2024},
    [53305110] = {quest=47752, label=LEGION_SUPPLIES},
    [52015968] = {quest=47752, label=EREDAR_SUPPLIES, vignette=2024},
    [50365115] = {quest=47752, label=EREDAR_SUPPLIES, vignette=2024},

    [58207179] = {quest=47753, label=LEGION_SUPPLIES},
    [59377345] = {quest=47753, label=LEGION_SUPPLIES},
    [58607990] = {quest=47753, label=LEGION_SUPPLIES},
    [53157308] = {quest=47753, label=EREDAR_SUPPLIES, vignette=2001},
    [56108039] = {quest=47753, label=EREDAR_SUPPLIES, vignette=2001},
}, {
    group="junk",
    scale=0.9,
})

-- Rares

ns.RegisterPoints(830, { -- Krokuun
    [33207615] = {quest=48562, npc=122912, criteria=37644, vignette=2198}, -- Commander Sathrenael
    [38105952] = { label="Commander Vecaya",
        quest=48563, npc=122911, criteria=37643, loot={153299}, vignette=2199, worldquest=48510,
        path={38135924, 38895958, 39375948, 39685893, 40395700, 40795671, 42085721},
        note="Either go through the Xenedar, or climb up from outside"
    },
    [42426987] = {quest=48666, npc=125820, criteria=37650, vignette=2228, worldquest=48282}, -- Imp Mother Laglath
    [45305882] = {quest=48564, npc=124775, criteria=37642, loot={153255}, vignette=2200, worldquest=48511}, -- Commander Endaxis
    [52833097] = {quest=48565, npc=123464, criteria=37641, loot={{153124, toy=true}}, vignette=2201, worldquest=48512}, -- Sister Subversia
    [55508020] = {quest=48628, npc=123689, criteria=37655, loot={153329}}, -- Talestra the Vile
    [58347584] = {quest=48627, npc=120393, criteria=37659, vignette=1996, worldquest=47542}, -- Siegemaster Voraan (43369?)
    [60831972] = {quest=48629, npc=125388, criteria=37652, loot={153114}, vignette=2223, worldquest=48091}, -- Vagath the Betrayed
    [69605750] = {quest=48664, npc=124804, criteria=37653, loot={153263}, vignette=2225, worldquest=47953, path=69305934}, -- Tereck the Selector
    [69708050] = {quest=48665, npc=125479, criteria=37651, worldquest=48192}, -- Tar Spitter
    [71033276] = {quest=48667, npc=126419, criteria=37645, loot={153190}, vignette=2229, worldquest=48502}, -- Naroua
}, {
    achievement=12078,
})
ns.RegisterPoints(833, { -- Nath'raxas Spire
    [38954032] = {quest=48561, npc=125824, criteria=37646, loot={153316}, vignette=2197, worldquest=47507}, -- Khazaduum
}, {
    achievement=12078,
    parent=true,
})
