local myname, ns = ...

-- skyhold unlock: 41359 @ thunder totem 750 39564199

local TREASURE = {
    achievement=11257,
    requires=ns.conditions.AuraInactive(188741),
}

ns.RegisterPoints(650, { -- Highmountain
    [36616213] = {quest=40488, label=ns.CHEST},
    [37353381] = {quest=40477, label=ns.CHEST_SM},
    [39005450] = {quest=44731, label=ns.CHEST, note="Path up behind Nesingwary's camp"},
    [39307621] = {quest=40473, label=ns.CHEST, note="Hard to reach; try from behind the totem"},
    [39376229] = {quest=40474, label=ns.CHEST},
    [39555744] = {quest=39812, label=ns.CHEST},
    [39704830] = {quest=39494, loot={131763}, label="Floating Treasure", note="On river surface, moves"},
    [42203482] = {quest=40480, label=ns.CHEST_SM},
    [42212730] = {quest=40479, label=ns.CHEST},
    [43582510] = {quest=40478, label=ns.CHEST, note="Cave entrance @ 42.5, 25.4", path=42502540},
    [43757275] = {quest=40510, label=ns.CHEST_SM},
    [45192746] = {quest=44279, label=ns.CHEST_SM, note="Underwater cave"},
    [45573462] = {quest=40481, label=ns.CHEST_SM},
    [46227340] = {quest=40489, label=ns.CHEST},
    [46302760] = {quest=44280, loot={131753}, label=ns.CHEST},
    [46682810] = {quest=40482, label=ns.CHEST_GLIM, note="Top of the building"},
    [46814013] = {quest=40507, label=ns.CHEST_SM, note="All the way at the top of the mountain"},
    [47644406] = {quest=39503, loot={131926}, label=ns.CHEST, note="1/4 of slow fall toy", toy=true},
    [49647128] = {quest=39606, label=ns.CHEST_GLIM, note="Inside cave"},
    [49653772] = {quest=39466, loot={131927}, label=ns.CHEST, note="1/4 of slow fall toy, in nest at top of mountain", toy=true},
    [50243861] = {quest=40497, label=ns.CHEST_SM, note="Cave @ 51.6, 37.4"},
    [50813504] = {quest=40506, label=ns.CHEST_SM, note="All the way at the top of the mountain"},
    [50983647] = {quest=40496, label=ns.CHEST, note="Cave @ 51.6, 37.4"},
    [50983880] = {quest=40498, label=ns.CHEST},
    [52023241] = {quest=40505, label=ns.CHEST},
    [53035224] = {quest=40493, label=ns.CHEST_SM, path={49905380, label="Crystal Fissure"}},
    [51175305] = {quest=39471, label=ns.CHEST_GLIM, note="Path past the Skyhorn", path={53004830, label="Path to Reflection Peak"}},
    [52566637] = {quest=42453, label=ns.CHEST, note="Only after Battle of Snowblind Mesa quests are done?"},
    [53063946] = {quest=40499, label=ns.CHEST_SM},
    [53414868] = {quest=40500, label=ns.CHEST_SM},
    [53454352] = {quest=40484, label=ns.CHEST_SM, note="Cave entrance @ 55.1, 44.3"},
    [53615103] = {quest=39824, loot={131810}, label=ns.CHEST, note="1/4 of slow fall toy; on ledge, path to southeast", toy=true, path={55405270, label="Path to Derelict Skyhorn Kite"}},
    [54174159] = {quest=40483, label=ns.CHEST_GLIM, note="Cave entrance @ 55.1, 44.3"},
    [55104430] = ns.path{quest={40483, 40484, 40414}, label="Candle Rock"},
    [55134965] = {quest=40487, label=ns.CHEST_SM},
    [38406150] = ns.path{quest=40476, label="Lifespring Cavern"},
    [41407250] = ns.path{quest=40489, label="Bitestone Enclave"},
    [44707230] = ns.path{quest={39606, 40508, 40509, 48381}, label="Neltharion's Vault"},
    [51603740] = ns.path{quest={40496, 40497, 40406}, label="Rockcrawler Chasm"},
    [48103390] = ns.path{quest={40496, 40497, 40406}, label="Rockcrawler Chasm"},
    [32206680] = {achievement=10774, loot={{139773, toy=true}}}, -- Emerald Winds
}, TREASURE)
ns.RegisterPoints(651, { -- BitestoneEnclave, Highmountain
    [85213787] = {quest=40489, label=ns.CHEST},
}, TREASURE)
ns.RegisterPoints(655, { -- LifespringCavern, Lower, Highmountain
    [39505740] = {quest=40476, label=ns.CHEST_GLIM},
}, TREASURE)
ns.RegisterPoints(656, { -- LifespringCavern, Upper, Highmountain
    [61703450] = {quest=40476, label=ns.CHEST_GLIM},
}, TREASURE)
ns.RegisterPoints(659, { -- StonedarkGrotto, Highmountain
    [35987235] = {quest=40478, label=ns.CHEST},
}, TREASURE)
ns.RegisterPoints(654, { -- MucksnoutDen, Highmountain
    [60592533] = {quest=40494, label=ns.CHEST},
}, TREASURE)
ns.RegisterPoints(750, { -- ThunderTotem, Highmountain
    [13715555] = {quest=40491, label=ns.CHEST_SM},
    [63435929] = {quest=39531, loot={141322}, label="A Steamy Jewelry Box"},
    [50667537] = {quest=40472, label=ns.CHEST_SM},
    [32354174] = {quest=40475, label=ns.CHEST_SM, note="On a boat"},
    [31843842] = {quest=44352, label=ns.CHEST, note="Underwater cave, below the boat"},
}, TREASURE)
ns.RegisterPoints(652, { -- ThunderTotemInterior, Highmountain
    [62946793] = {quest=40471, label=ns.CHEST},
}, TREASURE)
ns.RegisterPoints(657, { -- Path of Huln, floor 1, Highmountain
    [52002890] = ns.path{quest=39606, label="Titan Waygate"},
    [59304130] = {quest=39606, label="Treasures of Deathwing", note="Take the Waygate to get up, and use the brazier"},
    [40215031] = {quest=40509, label=ns.CHEST},
    [60425458] = {quest=40508, label=ns.CHEST_SM},
}, TREASURE)

-- Rares

-- Adventurer
ns.RegisterPoints(650, { -- Highmountain
    [36751635] = {quest=40084, npc=98299, criteria=33375, loot={131799}}, -- Bodash the Hoarder
    [38084557] = {quest=40405, npc=97449, criteria=33328, loot={131761}, vignette=1148}, -- Bristlemaul
    [41483177] = {quest=40175, npc=98890, criteria=33335, loot={131921}, worldquest=41838, vignette=1106}, -- Slumber
    [41964161] = {quest=39782, npc=97203, criteria=33323, loot={{129175, pet=1752}}, vignette=1001, note="The Exiled Shaman"}, -- Tenpak Flametotem
    [43384725] = {quest=40413, npc=100230, criteria=33336, loot={131781}, vignette=1150, note="Loot chest afterwards"}, -- Amateur hunters (100230, 100231, 100232)
    [44201210] = {quest=39994, npc=97933, criteria=33331, loot={131798}, note="Wanders a bit"}, -- Crab Rider Grmlrml
    [45705500] = {quest=40681, npc=101077, criteria=33338, loot={131730}, worldquest=41844}, -- Sekhan
    [46500745] = {quest=40096, npc=98311, criteria=33333, loot={131797}}, -- Mrrklr (captured survivor)
    [47803200] = {quest=39646, npc=96410, criteria=33319, loot={{131900, toy=true}}, vignette=995, note="Wanders a bit"}, -- Majestic Elderhorn
    [48394019] = {quest=39806, npc=97345, criteria=33326, loot={{131809, toy=true}}, vignette=1006, note="1/4 of slow fall toy"}, -- Crawshuk the Hungry
    [48605000] = {quest=39784, npc=97215, criteria=33324, loot={131756}, note="Help him tame Arru, loot inside the cave afterwards"}, -- Beastmaster Pao'lek
    [49202710] = {quest=40242, npc=96621, criteria=33321, loot={131808}}, -- Mellok, Son of Torok
    [50803460] = {quest=40406, npc=98024, criteria=33332, loot={131776}, note="In cave"}, -- Luggut the Eggeater
    [51052570] = {quest=39762, npc=97093, criteria=33322, loot={131791}}, -- Shara Felbreath
    [51074823] = {quest=39802, npc=97326, criteria=33325, loot={129190}, vignette=1004}, -- Hartli the Snatcher
    [51453190] = {quest=39465, npc=95872, criteria=33318, loot={131769}}, -- Skullhat (Skywhisker Taskmaster)
    [53715128] = {quest=39872, npc=97653, criteria=33330, loot={131800}, vignette=1043, note="Loot chest afterwards"}, -- Taurson (Beastly Boxer)
    [54404110] = {quest=40414, npc=100495, criteria=33337, loot={131780}, path=55114431, note="Blow out candles."}, -- Devouring Darkness
    [54504060] = {quest=39866, npc=97593, criteria=33329, loot={131792}, note="Top of mountain"}, -- Mynta Talonscreech (Scout Harefoot)
    [56786126] = {quest=40347, npc=96590, criteria=33320, loot={131775}, vignette=1126, note="Wanders a bit"}, -- Gurbog da Basher
    [52405850] = {quest=40423, npc=109498, criteria=33340, loot={131767}, note="Use the Seemingly Unguarded Treasure to summon the Unethical Adventurers"}, -- Unethical Adventurers
    [52335138] = {quest=39766, criteria=33334, loot={131802}, vignette=1000}, -- Totally Safe Treasure Chest, Ram'pag
}, {achievement=11264})

ns.RegisterPoints(650, { -- Highmountain
    [40955775] = {quest=39963, npc=97793, loot={131773}, note="Abandoned Fishing Pole", vignette=1047}, -- Flamescale (93195? bugged?)
    [54447454] = {quest=40773, npc=101649,}, -- Frostshard
    [56357250] = {quest=39235, npc=94877, loot={138396}}, -- Brogrul the Mighty
    [56694870] = {quest=45513, npc=104513, vignette=1837}, -- Defilia
})
ns.RegisterPoints(658, { -- Path of Huln, floor 2, Highmountain
    [54508400] = {quest=48381, npc=125951, loot={141708}}, -- Obsidian Deathwarder
})
