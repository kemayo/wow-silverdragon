local myname, ns = ...

-- Treasures of Vol'dun
ns.RegisterPoints(864, { -- Vol'dun
    [46598801] = {quest=50237, criteria=40966, path={44339222, label="Mine cart"}, note="Use mine cart",}, -- Ashvane Spoils
    [49787940] = {quest=51132, criteria=40968, note="Climb the rock arch",}, -- Lost Explorer's Bounty
    [44502613] = {quest=51135, criteria=40970, path=44712480, note="Climb fallen tree",}, -- Stranded Cache
    [29388742] = {quest=51137, criteria=40972, note="Under Disturbed Sand",}, -- Zem'lan's Buried Treasure
    [40578574] = {quest=52994, criteria=41003, path=38848290,}, -- Deadwood Chest
    [48186469] = {quest=51093, criteria=40967, note="Door on East side", hide_before=ns.conditions.QuestComplete(50550), faction="Horde",}, -- Grayal's Last Offering
    [48176469] = {quest=51093, criteria=40967, path=49166469, note="Door on East side", faction="Alliance",}, -- Grayal's Last Offering
    [47195846] = {quest=51133, criteria=40969, path=47445984, note="Path from South side",}, -- Sandfury Reserve
    [57746464] = {quest=51136, criteria=40971, path=56696469,}, -- Excavator's Greed
    [57061121] = {quest=52992, criteria=41002, note="Enter at top of temple",}, -- Lost Offerings of Kimbul
    [26484534] = {quest=53004, loot={163036}, criteria=41004, note="Use Abandoned Bobber",}, -- Sandsunken Treasure
}, {
    achievement=12849,
})

-- Elusive Quickhoof
ns.RegisterPoints(864, {
    [26405250] = {},
    [28006500] = {},
    [31106730] = {},
    [42006000] = {},
    [43006900] = {},
    [51108590] = {},
    [52508900] = {},
    [54008300] = {},
    [54605320] = {},
    [55007300] = {},
}, {
    npc=162681,
    loot={{174860,mount=1324}},
    notes="Spawns rarely, waits 10 minutes. Feed it {item:161128:Seaside Leafy Greens Mix} to get the mount",
    atlas="stablemaster",
})

-- Scavenger of the Sands
ns.RegisterPoints(864, { -- Vol'dun
    [56297011] = {quest=53132, criteria=41342, note="Under the bridge",}, -- Jason's Rusty Blade
    [36217838] = {quest=53133, criteria=41343, note="Inside the turned over box",}, -- Ian's Empty Bottle
    [53568981] = {quest=53134, criteria=41344, note="On the table",}, -- Julie's Cracked Dish
    [37813049] = {quest=53135, criteria=41345, note="Under the rock",}, -- Brian's Broken Compass
    [26775289] = {quest=53136, criteria=41346, note="First floor, blue stone table",}, -- Ofer's Bound Journal
    [29455937] = {quest=53137, criteria=41347, note="On the small hill",}, -- Skye's Pet Rock
    [52431439] = {quest=53138, criteria=41348, note="Near the bones close to the cliff",}, -- Julien's Left Boot
    [43217700] = {quest=53139, criteria=41349, note="Near the wall",}, -- Navarro's Flask
    [47067577] = {quest=53140, criteria=41350, note="Under the stairs",}, -- Zach's Canteen
    [45883072] = {quest=53141, criteria=41351, note="Hanging on the hut",}, -- Damarcus' Backpack
    [66413590] = {quest=53142, criteria=41352, path=64883632, note="In cave",}, -- Rachel's Flute
    [47933673] = {quest=53143, criteria=41353, note="Cave under the giant tree",}, -- Josh's Fang Necklace
    [45229114] = {quest=53144, criteria=41354, note="On the wall",}, -- Portrait of Commander Martens
    [62832267] = {quest=53145, criteria=41355, note="Down from Tortaka Refuge",}, -- Kurt's Ornate Key
}, {
    achievement=13016,
    atlas="VignetteLootElite",
    scale=1,
    minimap=true,
})

-- Dune Rider
ns.RegisterPoints(864, { -- Vol'dun
    [32206900] = {},
    [38107100] = {},
    [47906250] = {},
    [45806360] = {},
    [54902140] = {},
}, {
    achievement=13018,
    atlas="flightmasterferry",
    minimap=true,
    note="Rickety Plank",
})

-- Loa of a Tale
ns.RegisterPoints(864, { -- Vol'dun
    [27706212] = {criteria=41570,}, -- Tales of de Loa: Kimbul
    [42226211] = {criteria=41564,}, -- Tales of de Loa: Akunda
    [49572457] = {criteria=41574,}, -- Tales of de Loa: Sethraliss
}, {
    achievement=13036,
    atlas="profession",
    minimap=true,
})

-- junk
ns.RegisterPoints(864, { -- Vol'dun
    [59631517] = {quest=50914,},
    [61071734] = {quest=50914,},
    [53841481] = {quest=50915,},
    [60843637] = {quest=50916,},
    [62783373] = {quest=50916,},
    [54363351] = {quest=50917,},
    [64172528] = {quest=50918,},
    [35095003] = {quest=50919,},
    [48338890] = {quest=50920, note="In cave"},
    [46384538] = {quest=50921,},
    [30344624] = {quest=50922,},
    [29815402] = {quest=50922,},
    [26496777] = {quest=50923,},
    [31158381] = {quest=50924,},
    [37577607] = {quest=50924,},
    [36918033] = {quest=50924,},
    [44858126] = {quest=50925,},
    [52747649] = {quest=50926,},
    [56496993] = {quest=50926,},
    [57545508] = {quest=50928,},
    [52328519] = {quest=51673,},
    [51908251] = {quest=51673,},
}, {
    label='Treasure Chest',
    group="junk",
})

-- Rares

ns.RegisterPoints(864, { -- Vol'dun
    [50378160] = {quest=51058, npc=135852, criteria=41606,}, -- Ak'tar
    [54701517] = {quest=47532, npc=130439, criteria=41607,}, -- Ashmane
    [49058905] = {quest=49252, npc=128553, criteria=41608,}, -- Azer'tor
    [31008109] = {quest=49251, npc=128497, criteria=41609,}, -- Bajiani the Slick
    [49064989] = {quest=47562, npc=129476, criteria=41610,}, -- Bloated Krolusk
    [56105356] = {quest=51079, npc=136393, criteria=41611,}, -- Bloodwing Bonepicker
    [41272449] = {quest=51073, npc=136346, criteria=41612,}, -- Captain Stef "Marrow" Quin
    [42679245] = {quest=50905, npc=124722, criteria=41613,}, -- Commodore Calhoun
    [61853788] = {quest=51077, npc=136335, criteria=41614,}, -- Enraged Krolusk
    [64004757] = {quest=49270, npc=128674, criteria=41615,}, -- Gut-Gut the Glutton
    [53685347] = {quest=47533, npc=130443, criteria=41616, path=53835149, note="In cave"}, -- Hivemother Kraxi
    [37428498] = {quest=49392, npc=129283, criteria=41617,}, -- Jumbo Sandsnapper
    [60561801] = {quest=51074, npc=136341, criteria=41618,}, -- Jungleweb Hunter
    [35085183] = {quest=50528, npc=128686, criteria=41619,}, -- Kamid the Trapper
    [38284138] = {quest=51424, loot={161108}, npc=137681, criteria=41620, path=37354050, note="In cave"}, -- King Clickyclack
    [43758624] = {quest=50898, npc=128951, criteria=41621,}, -- Nez'ara
    [49017210] = {quest=51126, npc=136340, criteria=41622,}, -- Relic Hunter Hazaak
    [44538023] = {quest=48960, npc=127776, criteria=41623,}, -- Scaleclaw Broodmother
    [32716522] = {quest=51076, npc=136336, criteria=41624,}, -- Scorpox
    [24736850] = {quest=51075, npc=136338, criteria=41625,}, -- Sirokar
    [46972518] = {quest=50637, npc=134571, criteria=41626, path=46242714, note="In cave",}, -- Skycaller Teskris
    [51263645] = {quest=50686, npc=134745, criteria=41627,}, -- Skycarver Krakit
    [66892446] = {quest=51063, npc=136304, criteria=41628,}, -- Songstress Nahjeen
    [57197349] = {quest=49674, npc=130401, criteria=41629,}, -- Vathikur
    [37084616] = {quest=49373, npc=129180, criteria=41630,}, -- Warbringer Hozzik
    [30115256] = {quest=50662, npc=134638, criteria=41631,}, -- Warlord Zothix
    [50713086] = {quest=50658, npc=134625, criteria=41632,}, -- Warmother Captive
    [43915405] = {quest=48319, npc=129411, criteria=41633, path=43985246, note="Inside skeleton under the sand"}, -- Zunashi the Exile
}, {achievement=12943,})
