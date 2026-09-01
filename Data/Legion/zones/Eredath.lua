local myname, ns = ...

ns.RegisterPoints(882, { -- Eredath
    [27284015] = {quest=48750, criteria=37601, note="You will need a Glider", path=31924519}, -- Shattered House Chest
    [39605060] = { label="Void-Tinged Chest",
        quest=48747, -- 48746 for breaking the rubble
        criteria=37598,
        note="Requires Lightforge Warframe. Jump on the rubble.",
        minimap=true,
    },
    [40856975] = {quest=49153, criteria=37957, vignette=2324, note="Requires Shroud of Arcane Echoes. Stealth before opening."}, -- Augari Goods
    [42900550] = { label="Eredar Treasure Cache",
        quest=48743, -- 48613 for breaking the rubble, vignette=2254
        criteria=37595,
        note="Requires Lightforged Warframe.",
        minimap=true,
    },
    [43445440] = {quest=48751, criteria=37602, note="You will need a Glider"}, -- Doomseeker's Treasure
    [50693851] = {quest=48744, criteria=37596}, -- Chest of Ill-Gotten Gains
    [57097677] = {quest=48346, criteria=37600, loot={253520}, vignette=2259, path=56987437}, -- Desperate Eredar's Cache
    [62132249] = {quest=49151, criteria=37956, vignette=2323, note="Requires Shroud of Arcane Echoes. Stealth before opening."}, -- Secret Augari Chest
    [62207120] = {quest=48745, criteria=37597, note="Requires Light's Judgement."}, -- Student's Surprising Surplus
    [70315974] = {quest=48748, criteria=37599, vignette=2258}, -- Augari Secret Stash
    [70632745] = {quest=49129, criteria=37955, vignette=2320, note="Requires Shroud of Arcane Echoes. Stealth before opening."}, -- Augari-Runed Chest
}, {
    achievement=12074,
    atlas="VignetteLootElite", scale=1.2,
})

-- Junk:
ns.RegisterPoints(882, { -- Eredath
    [53328003] = {quest=48346, label="Ancient Eredar Cache", vignette=2069},
    [55167767] = {quest=48346, label="Ancient Eredar Cache", vignette=2069},
    [54825759] = {quest=48346, label="Ancient Eredar Cache"},
    [54806700] = {quest=48346, label="Ancient Eredar Cache"},
    [59476292] = {quest=48346, label="Ancient Eredar Cache"},
    [59906980] = {quest=48346, label="Ancient Eredar Cache"},

    [53342741] = {quest=48350, label="Ancient Eredar Cache", vignette=2081},
    [53902320] = {quest=48350, label="Ancient Eredar Cache"},
    [53603410] = {quest=48350, label="Ancient Eredar Cache"},
    [58704082] = {quest=48350, label="Ancient Eredar Cache"},
    [59602090] = {quest=48350, label="Ancient Eredar Cache"},
    [63311994] = {quest=48350, label="Ancient Eredar Cache"},

    [37205550] = {quest=48351, label="Ancient Eredar Cache"},
    [42305750] = {quest=48351, label="Ancient Eredar Cache"},
    [43776836] = {quest=48351, label="Ancient Eredar Cache"},
    [43617138] = {quest=48351, label="Ancient Eredar Cache"},
    [44446871] = {quest=48351, label="Ancient Eredar Cache", vignette=2085},

    [44601860] = {quest=48357, label="Ancient Eredar Cache"},
    [57821057] = {quest=48357, label="Ancient Eredar Cache"},

    [28904422] = {quest=48361, label="Void-Seeped Cache"},
    [25834447] = {quest=48361, label="Void-Seeped Cache"},

    [62013276] = {quest=48362, label="Ancient Eredar Cache"},
    [62805035] = {quest=48362, label="Ancient Eredar Cache", vignette=2086},

    [43776837] = {quest=48371, label="Ancient Eredar Cache"},
    [48704980] = {quest=48371, label="Ancient Eredar Cache"},
    [25263016] = {quest=48371, label="Ancient Eredar Cache"},
    [50605600] = {quest=48371, loot={153334}, label="Ancient Eredar Cache"},
    [54624483] = {quest=48371, label="Ancient Eredar Cache", vignette=2110},

    [33752371] = {quest=48371, label="Void-Seeped Cache"},

    [31552541] = {quest=49264, label="Void-Seeped Cache"},
    [37583619] = {quest=49264, label="Void-Seeped Cache"},
    [37102010] = {quest=49264, label="Void-Seeped Cache"},
}, {
    group="junk",
    scale=0.9,
})

-- Rares

ns.RegisterPoints(882, { -- Eredath
    [27202980] = {quest=48707, npc=126869, criteria=37631, worldquest=48727}, -- Captain Faruq
    [30304040] = {quest=48709, npc=127323, criteria=37629, loot={{153056, pet=2120}}}, -- Ataxon
    [33704750] = {quest=48705, npc=126867, criteria=37633, loot={{152844, mount=973}}}, -- Venomtail Skyfin
    [35203720] = {quest=48708, npc=126885, criteria=37630}, -- Umbraliss
    [35505870] = {quest=48711, npc=126896, criteria=37627, note="On the 2nd floor."}, -- Herald of Chaos
    [36302360] = {quest=48703, npc=126865, criteria=37635, loot={{153183,toy=true},153322}}, -- Vigilant Thanos
    [38705580] = {quest=48697, npc=126860, criteria=37638}, -- Kaara the Pale
    [39716420] = {quest=48706, npc=126868, criteria=37632, loot={153306}, note="Inside the building"}, -- Turek the Lucid
    [41301160] = {quest=48702, npc=126864, criteria=37636, loot={152998}}, -- Feasel the Muffin Thief
    [43806020] = {quest=48700, npc=126862, criteria=37637, loot={{153193, toy=true}}}, -- Baruut the Bloodthirsty
    [44204980] = {quest=48712, npc=126898, criteria=37626, loot={153190}}, -- Sabuul
    [44547164] = {quest=48692, npc=122838, criteria=37654, loot={153296}, vignette=2230}, -- Shadowcaster Voruun
    [48504090] = {quest=48713, npc=126899, criteria=37625, loot={153302}}, -- Jed'hin Champion Vorusk
    [49505280] = {quest=48935, npc=126913, criteria=37617, loot={153203}}, -- Slithon the Last
    [49700990] = {quest=48721, npc=126912, criteria=37618, loot={{152904, mount=980}}}, -- Skreeg the Devourer
    [55536016] = {quest=48695, npc=126852, criteria=37639, loot={{152814, mount=970}, 144432, 153269}, vignette=2231, worldquest=48696}, -- Wrangler Kravos
    [56801450] = {quest=48720, npc=126910, criteria=37619, worldquest=48739}, -- Commander Xethgar
    [56962927] = {quest=48716, npc=125497, criteria=37623, loot={153268}, vignette=2247}, -- Overseer Y'Sorna
    [59203770] = {quest=48714, npc=124440, criteria=37624, loot={153315}}, -- Overseer Y'Beda
    [60402970] = {quest=48717, npc=125498, criteria=37622, loot={153257}}, -- Overseer Y'Morna
    [61405020] = {quest=48718, npc=126900, criteria=37621, loot={{153179, toy=true}, {153180, toy=true}, {153181, toy=true}, 153309}}, -- Instructor Tarahna
    [63806460] = {quest=48704, npc=126866, criteria=37634, loot={{153183,toy=true}, 153323}, worldquest=48724}, -- Vigilant Kuro
    [66712847] = {quest=48719, npc=126908, criteria=37620, vignette=2250, worldquest=48738}, -- Zul'tan the Numerous
    [52796704] = {quest=48693, npc=126815, criteria=37640}, -- Soultwisted Monstrosity
    [70404670] = {quest=48710, npc=126889, criteria=37628, loot={153292}}, -- Sorolis the Ill-Fated
}, {
    achievement=12078,
})
