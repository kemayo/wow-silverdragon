local myname, ns = ...

-- skyhold unlock: 44062 or 43954 @33094821

local TREASURE = {
    achievement=11260,
    requires=ns.conditions.AuraInactive(199416),
}

local grapple = ns.nodeMaker{
    label="Grapple start point",
    atlas="MiniMap-DeadArrow", scale=1.2,
    worldmap=false,
}
ns.RegisterPoints(680, { -- Suramar
    [16602974] = {quest=43846, label=ns.CHEST_SM},
    [17275462] = {quest=43844, label=ns.CHEST},
    [19791604] = {quest=43845, label=ns.CHEST_SM, note="Cave entrance @ 19.4, 19.4", path=19401940},
    [20605040] = ns.path{quest={43839, 43840, 43747}, label="Falanaar Tunnels"},
    [22863574] = ns.path{quest={43838, 43988}, label="Temple of Fal'adora"},
    [23414880] = {quest=43842, label=ns.CHEST_SM},
    [25958548] = {quest=43831, label=ns.CHEST_SM,  path=29018481},
    [26354127] = {quest=42827, loot={139890}, label="Ancient Mana Chunk"},
    [26831696] = {quest=43847, label=ns.CHEST_SM},
    [29271622] = {quest=43848, label=ns.CHEST},
    [29768799] = {quest=43748, loot={141655}, label="Shimmering Ancient Mana Cluster", path=29008481, vignette=1557},
    [31956249] = {quest=43831, label=ns.CHEST_SM},
    [32317708] = {quest=43834, label=ns.CHEST_SM, note="Inside the Lightbreaker, after quests; portal @ 31.0, 85.1", path=31008510},
    [38138712] = {quest=43830, label=ns.CHEST_SM},
    [41961919] = {quest=43746, loot={139786}, label="Shimmering Ancient Mana Cluster"},
    [42051968] = {quest=43849, loot={139786}, label=ns.CHEST_GLIM},
    [42577668] = {quest=43870, label=ns.CHEST_SM, note="Upstairs"},
    [44053194] = {quest=43856, loot={139786}, label=ns.CHEST_GLIM, note="Cave entrance behind waterfall @ 42.2, 30.0", path=42203000},
    [44302289] = {quest=43850, label=ns.CHEST},
    [44387587] = {quest=43869, label=ns.CHEST_SM},
    [46552599] = {quest=43744, loot={141655}, label="Shimmering Ancient Mana Cluster", vignette=1554},
    [48117321] = {quest=43865, label=ns.CHEST_SM, note="Grapple to it"},
    [48143399] = {quest=43853, label=ns.CHEST_SM},
    [48288261] = {quest=43866, label=ns.CHEST_SM, note="Grapple from 48.4, 82.2", path=grapple{48408220}},
    [48297121] = {quest=44324, label=ns.CHEST, note="Upstairs"},
    [48587217] = {quest=44323, label=ns.CHEST, note="Upstairs"},
    [48957379] = {quest=43867, label=ns.CHEST, note="Upstairs"},
    [49988493] = {quest=43864, label=ns.CHEST_SM, note="Grapple from 50.0, 84.5", path=grapple{50008450}},
    [50068061] = {quest=44325, label=ns.CHEST, note="Upstairs"},
    [51503859] = {quest=43855, label=ns.CHEST_SM},
    [51908214] = {quest=43868, label=ns.CHEST},
    [52272989] = {quest=43854, label=ns.CHEST, route=49503390},
    [52733130] = {quest=40767, label="Dusty Coffer", route=49503390},
    [49503390] = ns.path{quest={43854,40767}, routes={{49503390,52272989},{49503390,52733130}}},
    [54326033] = {quest=43875, label=ns.CHEST},
    [55685480] = {quest=43871, label=ns.CHEST_SM},
    [57326039] = {quest=43873, label=ns.CHEST},
    [57686197] = {quest=43874, label=ns.CHEST},
    [60356851] = {quest=43876, loot={139786}, label=ns.CHEST_GLIM},
    [61365550] = {quest=43872, label=ns.CHEST},
    [63654911] = {quest=43857, label=ns.CHEST_SM},
    [65814191] = {quest=43743, loot={141655}, label="Shimmering Ancient Mana Cluster", note="At the back of the leyline cave", vignette=1554},
    [67315511] = {quest=43858, label=ns.CHEST},
    [71464975] = {quest=43859, label=ns.CHEST_SM},
    [76886150] = {quest=43860, label=ns.CHEST_SM, note="Underwater, in a sunken ship"},
    [79647289] = {quest=43741, loot={141655}, label="Shimmering Ancient Mana Cluster"},
    [81965745] = {quest=43861, label=ns.CHEST_SM, note="Entrance @ 79.3, 57.4", path=79305740},
    [83126933] = {quest=43863, label=ns.CHEST},
    [83975764] = {quest=43862, label=ns.CHEST},
}, TREASURE)

ns.RegisterPoints(682, { -- Felsoul Hold, Suramar ("SuramarLegionScar")
    [40502903] = {quest=40902, label=ns.CHEST_SM},
    [54573780] = {quest=43835, label=ns.CHEST_SM},
}, TREASURE)
ns.RegisterPoints(684, { -- Temple of Fal'adora, Suramar
    [38605414] = {quest=43838, label=ns.CHEST_SM, note="Downstairs"},
}, TREASURE)
ns.RegisterPoints(685, { -- Falanaar Tunnels, Suramar
    [58307020] = {quest=43840, label=ns.CHEST}, -- also triggered 43839
    [35433240] = {quest=43747, loot={141655}, label="Shimmering Ancient Mana Cluster", vignette=1556},
    [48644258] = {quest=43839, label=ns.CHEST_SM, note="Climb spiderweb"}, -- TODO: verify location
}, TREASURE)
ns.RegisterPoints(686, { -- Elor'shan
    [49301730] = {quest=43743, loot={141655}, label="Shimmering Ancient Mana Cluster"},
}, TREASURE)

ns.RegisterPoints(ns.SURAMAR, {
    [58653375] = {quest=40692, label="Warp Cache", loot={139890,139786,138783}, note="In the cave high up, accessible via flight or Telemancy to \"Storage\""},
})

-- Why Can't I Hold All This Mana?

local MANA = {
    achievement=11133,
    atlas="VignetteLootElite", scale=1.2,
}
ns.RegisterPoints(680, { -- Suramar
    [21425446] = {quest=42842, loot={{136269, quest=42842}},}, -- Kel'danath's Manaflask (hide before 41212 maybe? Or 40326 scattered memories)
    [26877073] = {quest=43987, loot={{140327, quest=43987}}, note="Cave entrance @ 27.3, 72.9", path=27307290}, -- Kyrtos's Research Notes
    [35561209] = {quest=43989, loot={{140329, quest=43989}}, label="Arcane Power Unit"}, -- Infinite Stone
    [44803100] = {quest=43986, loot={{140326, quest=43986}}, note="Doesn't stand out much; by the bench, upper level"}, -- Enchanted Burial Urn
}, MANA)
ns.RegisterPoints(684, { -- Temple of Fal'adora, Suramar
    [35525280] = {quest=43988, loot={{140328, quest=43988}}, label="Volatile Leyline Crystal", note="Downstairs",},
}, MANA)

-- Rares

-- Adventurer
ns.RegisterPoints(680, { -- Suramar
    [13515344] = {quest=44124, npc=112802, criteria=33371, loot={140949}, vignette=1642}, -- Mar'tura
    [16472666] = {quest=43996, npc=103841, criteria=33348, loot={140401}, vignette=1610}, -- Shadowquill
    [18686106] = {quest=43542, npc=110824, criteria=33360, loot={140399}, vignette=1510}, -- Tideclaw
    [22165179] = {quest=41319, npc=99792, criteria=33342, loot={121806}, vignette=1263}, -- Elfbane
    [23982553] = {quest=43484, npc=105547, criteria=33349, loot={121759}, vignette=1508}, -- Rauren
    [24413517] = {quest=44071, npc=112497, criteria=33370, loot={139897}, vignette=1617}, -- Maia the White
    [24604744] = {quest=43449, npc=110577, criteria=33357, loot={140388}, vignette=1505}, -- Oreth the Vile
    [26254120] = {quest=42831, npc=109054, criteria=33352, loot={139926}, vignette=1442}, -- Shal'an
    [27756545] = {quest=43992, npc=110832, criteria=33361, loot={121747}, note="Portal Key"}, -- Gorgroth
    [33665177] = {quest=43954, npc=111197, criteria=33365, loot={{140934, pet=1934}}, vignette=1541}, -- Anax
    [33591495] = {quest=43717, npc=106351, criteria=33350, loot={140372}, vignette=1547}, -- Artificer Lothaire
    [34156099] = {quest=43351, npc=110024, criteria=33354, loot={140386}, vignette=1498}, -- Mal'Dreth the Corruptor
    [36183384] = {quest=43718, npc=111329, criteria=33366, loot={140390}, vignette=1548}, -- Matron Hagatha
    [36972110] = {quest=43369, npc=110438, criteria=33356, loot={140406}, vignette=1500}, -- Siegemaster Aedrin
    [40943277] = {quest=43358, npc=110340, criteria=33355, loot={ns.rewards.Recipe(133816, 201500), 121739}, vignette=1499}, -- Myonix
    [42068013] = {quest=43348, npc=109954, criteria=33353, loot={140405}, vignette=1497}, -- Magister Phaedris
    [42255658] = {quest=43580, npc=110870, criteria=33362, loot={121754}, vignette=1511}, -- Apothecary Faldren
    [48535666] = {quest=40905, npc=102303, criteria=33376, loot={121735}, vignette=1684}, -- Lieutenant Strathmar
    [49657898] = {quest=43603, npc=111007, criteria=33364, loot={140396}, vignette=1518}, -- Randril
    [53203020] = {quest=40897, npc=99610, criteria=33341, loot={121755}}, -- Garvrulg
    [54425612] = {quest=43792, npc=111651, criteria=33368, loot={121808}, vignette=1558}, -- Degren (Noble Blademaster)
    [54576371] = {quest=43794, npc=111649, criteria=33367, loot={139918}, vignette=1560}, -- Ambassador D'vwinn
    [57995112] = {quest=43597, npc=110944, criteria=33363, loot={140404}, vignette=1515, note="Wanders a bit"}, -- Guardian Thor'el
    [61283968] = {quest=43993, npc=103223, criteria=33346, loot={121737}, vignette=1251}, -- Hertha Grimdottir
    [62506370] = {quest=43793, npc=111653, criteria=33369, loot={121810}}, -- Miasu
    [62554810] = {quest=43495, npc=110726, criteria=33359, loot={139969}}, -- Cadraeus
    [65555915] = {quest=43481, npc=110656, criteria=33358, loot={140403}}, -- Arcanist Lylandre
    [66656715] = {quest=43968, npc=107846, criteria=33351, loot={140402,{140314, toy=true}}}, -- Pinchshank
    [67657105] = {quest=41136, npc=103214, criteria=33345, loot={140381}, note="Cave entrance @ 72.4, 68.1", path=72406810}, -- Har'kess the Insatiable
    [68155895] = {quest=41135, npc=100864, criteria=33343, loot={139952}, note="Cave entrance @ 69.9, 57.0", path=69905700}, -- Cora'Kar
    [77485783] = {quest=44003, npc=103575, criteria=33347, loot={121801}, vignette=1259}, -- Reef Lord Raj'his
    [79807221] = {quest=40680, npc=103183, criteria=33344, loot={140019}, vignette=1220, note="Wanders along the underwater trench"}, -- Rok'nash
}, {achievement=11265})

ns.RegisterPoints(680, { -- Suramar
    [35386700] = {quest=44675, npc=106526, loot={141866}, vignette=1691}, -- Lady Rivantas
    [29455333] = {quest=44676, npc=113368, loot={138839}, note="Cave entrance @ 29.3, 50.7", path=29305070, vignette=1692}, -- Llorian
    [87456235] = {quest=41786, npc=103827, loot={140384}, vignette=1281}, -- King Morgalash / Sea Giant King
    [37987039] = {quest=44569, npc=106532, loot={}, vignette=1685}, -- Inquisitor Volitix
    [23804580] = {quest=45505, npc=105728, worldquest=42797}, -- Scythemaster Cil'raman
})

ns.RegisterPoints(685, { -- Falanaar Tunnels
    [64405060] = { label="Broodmother Shu'malis",
        quest=93441,
        npc=105632,
        vignette=7361,
        -- parent=true,
    },
})

-- Leylines!

local LEYLINES = {
    achievement=10756,
    atlas="worldquest-questmarker-abilityhighlight",
    hide_before=ns.conditions.QuestComplete(41138), -- Feeding Shal'Aran
}
ns.RegisterPoints(680, { -- Suramar
    [41703890] = {criteria=31056, quest=41028}, -- Anora Hollow (the prerequisite!)
    [29008480] = {criteria=31918, quest=43594}, -- Soul Vaults (Halls of the Eclipse)
    [59304280] = {criteria=31914, quest=43588}, -- Kel'balor
    [65804190] = {criteria=31913, quest=43587}, -- Elor'shan
    [20405040] = {criteria=31917, quest=43593}, -- Falanaar South
    [21404330] = {criteria=31916, quest=43592}, -- Falanaar North
    [24301940] = {criteria=31919, quest=43591}, -- Moon Guard
    [35702410] = {criteria=31915, quest=43590}, -- Moonwhisper Gulch
}, LEYLINES)
ns.RegisterPoints(685, { -- Falanaar Tunnels
    [66505302] = {criteria=31916, quest=43592}, -- Falanaar North
    [58107520] = {criteria=31917, quest=43593}, -- Falanaar South
}, LEYLINES)
ns.RegisterPoints(686, { -- Elor'shan
    [46704720] = {criteria=31913, quest=43587},
}, LEYLINES)
ns.RegisterPoints(687, { -- Kel'balor
    [52304490] = {criteria=31914, quest=43588},
}, LEYLINES)
ns.RegisterPoints(689, { -- Ley Station Moonfall, Moonwhisper Gulch
    [54004470] = {criteria=31915, quest=43590},
}, LEYLINES)
ns.RegisterPoints(690, { -- Ley Station Aethenar, Moon Guard
    [48704870] = {criteria=31919, quest=43591},
}, LEYLINES)

-- Telemancy!

local Portal = function(questid, label, data) return ns.Getterize(ns.merge({
    _questid = questid,
    label = label,
    group="{achievementname:11125:Now You're Thinking With Portals}",
    __get={
        atlas=function(self)
            return C_QuestLog.IsQuestFlaggedCompleted(self._questid) and "MagePortalAlliance" or "MagePortalHorde"
        end,
    },
}, data)) end

ns.RegisterPoints(680, { -- Suramar
    -- These crop up at points in the storyline
    [36204710] = Portal(40956, "{area:8173:Ruins of Elune'eth}", {hide_before=ns.conditions.QuestComplete(40956), outdoors_only=true}), -- Ruins of Elune'eth, storyline: Survey Says...
    [22903580] = Portal(42230, "{area:7843:Falanaar}", {hide_before=ns.conditions.QuestComplete(42228)}), -- Falanaar, storyline: Valewalker's Burden, hidden until Hidden City
    [47508200] = Portal(42487, "{area:8382:Waning Crescent}", {require=ns.conditions.QuestIncomplete(43569), hide_before=ns.conditions.QuestComplete(42486), }), --Waning Crescent, storyline: Friends on the Outside, hidden until Little One Lost, hidden after Arluin's Request
    [64006040] = Portal(44084, "{area:8149:Twilight Vineyards}", {hide_before=ns.conditions.QuestComplete(42838)}), -- Twilight Vineyards, storyline: Vengeance for Margaux, hidden until Reversal
    [52007800] = Portal(42889, "{area:8487:Evermoon Terrace}", {hide_before=ns.conditions.QuestComplete(43569)}), -- Evermoon Terrace, storyline: The Way Back Home, hidden until 38694
    [54496943] = Portal(44740, "{area:8395:Astravar Harbor}", {hide_before=ns.conditions.QuestComplete(44738)}), -- Astravar Harbor, storyline: Staging Point, hidden until Full Might of the Elves
    -- These ones are general-access after Ruins is opened via Survey Says:
    [30801090] = Portal(43808, "{area:7842:Moon Guard Stronghold}", {hide_before=ns.conditions.QuestComplete(40956), path={27802230, atlas="map-icon-SuramarDoor.tga"}}), -- Moon Guard Stronghold
    [42203540] = Portal(43809, "{area:7841:Tel'anor}", {hide_before=ns.conditions.QuestComplete(40956)}), -- Tel'anor
    [43406070] = Portal(43813, "{area:8431:Sanctum of Order}", {hide_before=ns.conditions.QuestComplete(40956), path={42606170, atlas="map-icon-SuramarDoor.tga"}}), -- Sanctum of Order
    [43607910] = Portal(43811, "{area:8021:Lunastre Estate}", {hide_before=ns.conditions.QuestComplete(40956)}), -- Lunastre Estate
    [35808210] = Portal(41575, "{area:7844:Felsoul Hold}", {hide_before=ns.conditions.QuestComplete(40956)}), -- Felsoul Hold
})
ns.RegisterPoints(684, { -- Fal'adore
    [40901350] = Portal(42230, "{area:7843:Falanaar}", {hide_before=ns.conditions.QuestComplete(42228)}), -- Falanaar
})
ns.RegisterPoints(682, { -- The Fel Breach
    [53403680] = Portal(41575, "{area:7844:Felsoul Hold}", {hide_before=ns.conditions.QuestComplete(40956)}), -- Felsoul Hold
})

-- Withered Army Training

ns.RegisterPoints(692, { -- upper level
    [29804260]={ quest=43149, loot={139010}, label="Treasure Chest", note="+25% HP. Requires 5 withered.", },
    [30007000]={ quest=43146, loot={140451}, label="Glimmering Treasure Chest", note="Withered Mana-Rager. Requires 10 withered.", },
    [38805350]={ quest=43140, loot={140778}, label="Treasure Chest", note="Bank in Shal'aran. Under stairs. Requires 5 withered.", },
    [40801350]={ quest=43071, loot={139011}, label="Glimmering Treasure Chest", note="Withered Berserker. Requires 10 withered.", },
    [75902840]={ quest=43120, loot={139018}, label="Treasure Chest", note="Withered more efficiently focus their attacks. Requires 5 withered.", },
}, {group="withered"})
ns.RegisterPoints(693, { -- lower level
    [32506440]={ quest=43145, loot={140450}, label="Glimmering Treasure Chest", note="Withered Berserker. Requires 10 withered.", },
    [36603240]={ quest=43135, loot={139028}, label="Glimmering Treasure Chest", note="Withered Starcaller. Requires 10 withered.", },
    [44205350]={ quest=43134, loot={139027}, label="Glimmering Treasure Chest", note="Withered Spellseer. Requires 10 withered.", },
    [45704610]={ quest=43143, loot={141313}, label="Treasure Chest", note="Requires 5 withered.", },
    [48707980]={ quest=43141, loot={{136914, pet=true}}, label="Treasure Chest", note="Requires 5 withered.", },
    [51802930]={ quest=43111, loot={139017}, label="Treasure Chest", note="Reduces fear rate. Requires 5 withered.", },
    [60507310]={ quest=43148, loot={140448}, label="Treasure Chest", note="+25% damage. Requires 5 withered.", },
    [62206200]={ quest=43128, loot={139019}, label="Glimmering Treasure Chest", note="Withered Mana-Rager. Requires 10 withered.", },
    [62409010]={ quest=43142, loot={141314}, label="Treasure Chest", note="Requires 5 withered.", },
    [67305140]={ quest=43144, loot={{141296, toy=true}}, label="Treasure Chest", note="Requires 5 withered.", },
}, {group="withered"})
