local myname, ns = ...

-- Treasures of Nazmir
ns.RegisterPoints(863, { -- Nazmir
    [77903634] = {quest=49867, criteria=40857,}, -- Lucky Horace's Lucky Chest
    [77884635] = {quest=50061, criteria=40858, note="In dead hippo's mouth",}, -- Partially-Digested Treasure
    [43065078] = {quest=49979, criteria=40859, path=42275056, note="In cave",}, -- Cursed Nazmani Chest
    [35668560] = {quest=49885, criteria=40860, note="In cave",}, -- Cleverly Disguised Chest
    [62103487] = {quest=49891, criteria=40861, note="Underwater cave",}, -- Lost Nazmani Treasure
    [42772620] = {quest=49484, criteria=40862, note="Climb the tree",}, -- Offering to Bwonsamdi
    [66791735] = {quest=49483, criteria=40863, note="Climb the tree",}, -- Shipwrecked Chest
    [46228295] = {quest=49889, criteria=40864,}, -- Venomous Seal
    [76826220] = {quest=50045, criteria=40865, note="Underwater cave",}, -- Swallowed Naga Chest
    [35455498] = {quest=49313, criteria=40866, note="In cave",}, -- Wunja's Trove
}, {
    achievement=12771,
})

-- Hoppin' Sad (Lost Spawn of Krag'wa)
ns.RegisterPoints(863, { -- Nazmir
    [69105790] = {quest=53417,}, --verify
    [65605090] = {quest=53418,}, --verify
    [56106490] = {quest=53419,},
    [52804290] = {quest=53420,}, --verify
    [33506160] = {quest=53421,},
    [45609100] = {quest=53422,}, --verify
    [28408230] = {quest=53423, note="Cave in cliffs",}, --verify
    [24209160] = {quest=53424,}, --verify
    [21706930] = {quest=53425,},
    -- [52804290] = {quest=53426, achievement=13828, minimap=true,}, -- maybe?
    [25694058] = {quest=53426,},
}, {
    achievement=13028,
    atlas="WildBattlePetCapturable",
    minimap=true,
})

-- Carved in Stone, Written in Blood
ns.RegisterPoints(863, { -- Nazmir
    [56355727] = {criteria=41860,},
    [43364810] = {criteria=41861,},
    [51268511] = {criteria=41862,},
    [42565711] = {criteria=42116,},
}, {
    achievement=13024,
    atlas="reagents",
    minimap=true,
})

-- Loa of a Tale
ns.RegisterPoints(863, { -- Nazmir
    [39123865] = {criteria=41565,}, -- Tales of de Loa: Bwonsamdi
    [39575467] = {criteria=41568,}, -- Tales of de Loa: Hir'eek
    [58924865] = {criteria=41571,}, -- Tales of de Loa: Krag'wa
    [72850760] = {criteria=41579,}, -- Tales of de Loa: Torga
}, {
    achievement=13036,
    atlas="profession",
    minimap=true,
})

-- junk
ns.RegisterPoints(863, { -- Nazmir
    [41575046] = {quest=49916,},
    [41596574] = {quest=49916,},
    [28048187] = {quest=50895,},
}, {
    label='Treasure Chest',
    group="junk",
})

-- Rares

-- Adventurer of Nazmir
ns.RegisterPoints(863, { -- Nazmir
    [67812972] = {quest=48063, npc=125250, criteria=41440,}, -- Ancient Jawbreaker
    [32802690] = {quest=50563, npc=134293, criteria=41447,}, -- Azerite-Infused Slag
    [44224873] = {quest=49305, npc=128965, criteria=41450,}, -- Uroku the Bound
    [68102023] = {quest=50567, npc=134296, criteria=41452,}, -- Chag's Challenge
    [81813057] = {quest=48057, npc=125232, criteria=41454,}, -- Cursed Chest
    [68955747] = {quest=50361, npc=121242, criteria=41456,}, -- Glompmaw
    [56666932] = {quest=49312, npc=128974, criteria=41458,}, -- Queen Tzxi'kik
    [45375197] = {quest=50307, npc=133373, criteria=41460,}, -- Jax'teb the Reanimated
    [52931340] = {quest=47843, npc=124397, criteria=41462,}, -- Kal'draxa
    [81696105] = {quest=50565, npc=134295, criteria=41464,}, -- Lost Scroll
    [58963893] = {quest=48972, npc=127820, criteria=41467,}, -- Scout Skrasniss
    [31443815] = {quest=48508, npc=126460, criteria=41469,}, -- Tainted Guardian
    [38095768] = {quest=50888, npc=135565, criteria=41472,}, -- Urn of Agussu
    [48985082] = {quest=48623, npc=126907, criteria=41474,}, -- Wardrummer Zurula
    [38722674] = {quest=49469, npc=129657, criteria=41476,}, -- Za'amar the Queen's Blade
    [78084451] = {quest=50355, npc=133539, criteria=41478,}, -- Lo'kuno
    [54128110] = {quest=50569, npc=134298, criteria=41444,}, -- Azerite-Infused Elemental
    [43199131] = {quest=48541, npc=126635, criteria=41448, path=43069011, note="In cave, behind waterfall"}, -- Blood Priest Xak'lar
    [53694287] = {quest=49317, npc=129005, criteria=41451,}, -- King Kooba
    [41665344] = {quest=48462, npc=126187, criteria=41453,}, -- Corpse Bringer Yal'kar
    [33538708] = {quest=48638, npc=127001, criteria=41455,}, -- Gwugnug the Cursed
    [32344332] = {quest=49231, npc=128426, criteria=41457,}, -- Gutrip
    [24967778] = {quest=47877, npc=124399, criteria=41459,}, -- Infected Direhorn
    [27823357] = {quest=50342, npc=133527, criteria=41461,}, -- Juba the Scarred
    [76033654] = {quest=48052, npc=125214, criteria=41463,}, -- Krubbs
    [42805949] = {quest=48439, npc=126142, criteria=41466,}, -- Bajiatha
    [58431014] = {quest=48980, npc=127873, criteria=41468,}, -- Scrounger Patriarch
    [49453714] = {quest=48406, npc=126056, criteria=41470,}, -- Totem Maker Jash'ga
    [29705107] = {quest=48626, npc=126926, criteria=41473,}, -- Venomjaw
    [36555053] = {quest=50348, npc=133531, criteria=41475,}, -- Xu'ba
    [38887148] = {quest=50423, npc=133812, criteria=41477,}, -- Zanxib
    [52605489] = {quest=50040, npc=128930, criteria=41479,}, -- Mala'kili and Rohnkor
}, {achievement=12942,})

-- Life Finds a Way... To Die!
ns.RegisterPoints(863, { -- Nazmir
    [25706971] = {npc=143898, achievement=13048, criteria=41683, note="Flying close to the road from Vol'dun to Zuldazar",}, -- Makatau the Pterrordax
})
