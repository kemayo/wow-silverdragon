local myname, ns = ...

-- Zone added in 10.0.7

ns.RegisterPoints(ns.FORBIDDENREACH, {
    [45917966] = { label="Warden Entrix",
        -- interior map: 2102 42908450
        criteria=58470,
        quest=73367, -- 74348
        npc=200960,
        loot={
            {191930, pet=3261}, -- Wakyn
        },
        vignette=5520,
        path=51935938,
    },
    [51717276] = { label="Pyrachniss",
        -- interior map: 2102 67175616
        criteria=58472,
        quest=73385, -- 74350
        npc=200978,
        loot={
            {197590,quest=69794,}, -- Windborne Velocidrake: Small Head Fin
        },
        vignette=5521,
        note="Jump down using the whirlwind for a slow fall",
        path=51935939,
    },
    [32852931] = { label="Duzalgor",
        criteria=58462,
        quest=73118, -- 74340
        npc=200610, -- also 203674
        vignette=5492,
        note="Inside; grab a {spell:371045:Toxin Antidote} first",
        path=36803250,
    },
    [78205066] = { label="Volcanakk",
        criteria=58473,
        quest=73225, -- 74351
        npc=200911,
        loot={
            {197617,quest=69821,}, -- Windborne Velocidrake: Heavy Scales
        },
        vignette=5515,
        path=74505464,
    },
    [29005720] = { label="Amephyst",
        criteria=58486,
        quest=74333,
        npc=200743,
        loot={
            204219, -- Design: Unstable Elementium
            204222, -- Conductive Ametrine Shard
        },
    },
    [12401520] = { label="Loot Specialist",
        -- [12401520, 13005220, 13605420, 15001460, 16201540, 20201300, 28405680, 29005620, 29406020, 30805520, 31204900, 32406500, 32606520, 33804520, 34003860, 34203840, 35804440, 36401800, 37807060, 38003660, 38006340, 40002420, 40003640, 40203060, 40802700, 42004480, 42809020, 43004440, 43004480, 43804080, 44201900, 44204040, 44207620, 44403640, 44403660, 44606160, 44804560, 45003900, 45006100, 45204760, 45604200, 45605680, 45804120, 45807040, 45807080, 46205080, 47204240, 47404260, 47801460, 48001440, 48205360, 48606940, 48806960, 49002440, 50005260, 50605560, 50605680, 50805420, 51204740, 51605780, 51805120, 52202460, 52602420, 52607740, 53204760, 53205160, 53404720, 53405500, 53805440, 54405740, 54604160, 54605760, 54803580, 55005880, 55207080, 55804860, 56404780, 56805420, 57606620, 58005720, 58206180, 58404120, 60206340, 60406360, 61403940, 62803160, 63203140, 64202700, 66405800, 66406220, 66605840, 66806080, 68201040, 69000920, 69001240, 69405900, 69604560, 69606340, 71006720, 71205600, 71406100, 71806920, 72006140, 72805460, 73204620, 74205760, 81006160, 88006340]
        criteria=58830,
        quest=nil,
        npc=203353,
        note="Spawns anywhere",
        vignette=5635,
    },
    [44727943] = { label="Galakhad",
        criteria=58464,
        quest=73152, -- 74342
        npc=200717,
        vignette=5498,
    },
    [55905141] = { label="Luttrok",
        criteria=58485,
        quest=74332,
        npc=200742,
        loot={
            {193235, pet=3285}, -- Luvvy
        },
        vignette=5507,
        note="Summon with Cooking",
    },
    [80005900] = { label="Tidesmith Zarviss",
        criteria=58480,
        quest=74325,
        npc=200730,
        loot={
            191260, -- Serevite Repair Hammer
            204230, -- Dense Seaforged Javelin
        },
    },
    [28003860] = { label="Gahz'raxes",
        criteria=58459,
        quest=73095, -- 74337
        npc=200537,
        note="In underwater cave",
        path=26744144,
    },
    [56003940] = { label="Agni Blazehoof",
        criteria=58484,
        quest=74331,
        npc=200740,
        loot={
            191360, -- Bottled Putrescence
            191387, -- Elemental Potion of Power
            191399, -- Potion of Shocking Disclosure
            204226, -- Blazehoof Ashes
        },
    },
    [61202680] = { label="Fimbol",
        criteria=58483,
        quest=74330,
        npc=200739,
        loot={
            198199, -- Reinforced Machine Chassis
            204227, -- Everflowing Antifreeze
        },
    },
    [43204900] = { label="Tectonus",
        criteria=58474,
        quest=74300, -- 73127 + 74926 (one of these is probably not related...)
        npc=200619,
        loot={
            204233, -- Impenetrable Elemental Core
        },
    },
    [55203660] = { label="Manathema",
        criteria=58476,
        quest=74306,
        npc=200621,
        loot={
            204224, -- Speck of Arcane Awareness
        },
    },
    [31205340] = { label="Gareed",
        criteria=58478,
        quest=74321,
        npc=200722,
        loot={
            204225, -- Perfect Windfeather
        },
    },
    [23006680] = { label="Sir Pinchalot",
        criteria=58475,
        quest=74305,
        npc=200620,
    },
    [61723400] = { label="Wyrmslayer Angvardi",
        criteria=58469,
        quest=73409, -- 74347
        npc=201013, -- accomanied by Nidharr (201310)
        loot={
            {197609,quest=69813,}, -- Windborne Velocidrake: White Horns

        },
        vignette=5526,
    },
    [59695883] = { label="Lady Shaz'ra",
        criteria=58466,
        quest=73222, -- 74344
        npc=200885,
        loot={
            {197628,quest=69834,}, -- Windborne Velocidrake: Plated Neck
        },
        vignette=5514,
    },
    [36731223] = { label="Ookbeard",
        criteria=58471,
        quest=73366, -- 74349
        npc=200956,
        loot={
            {197636,quest=69847,}, -- Windborne Velocidrake: Shrieker Pattern
        },
        vignette=5519,
    },
    [37004700] = { label="Snarfang",
        criteria=58477,
        quest=74307,
        npc=200622,
        loot={
            204232, -- Slyvern Alpha Claw
        },
    },
    [49204180] = { label="Arcantrix",
        criteria=58481,
        quest=74328,
        npc=200737,
        loot={
            198413, -- Serene Pigment
            198416, -- Flourishing Pigment
            198419, -- Blazing Pigment
            198422, -- Shimmering Pigment
            204229, -- Glimmering Rune of Arcantrix
        },
    },
    [43776125] = { label="Bonesifter Marwak",
        criteria=58463,
        quest=43150, -- 74341
        npc=200681,
        loot={
            {193374, pet=3293}, -- Ashenwing
        },
        vignette=5497,
    },
    [58174826] = { label="Vraken the Hunter",
        criteria=58458,
        quest=73111, -- 74336
        npc=200584,
        loot={
            {193364, pet=3291}, -- Scruffles
        },
        vignette=5490,
    },
    [47722071] = { label="Reisa the Drowned",
        criteria=58461,
        quest=73117, -- 74339
        npc=200600,
        vignette=5491,
    },
    [56405900] = { label="Kangalo",
        criteria=58482,
        quest=74329,
        npc=200738,
        loot={
            204228, -- Undigested Hochenblume Petal
        },
    },
    [45003640] = { label="Faunos",
        criteria=58479,
        quest=74322,
        npc=200725,
        loot={
            204231, -- Kingly Sheepskin Pelt
        },
    },
    [67924531] = { label="Mad-Eye Carrey",
        criteria=58468,
        quest=74283, -- 74346
        npc=201181,
        vignette=5544,
    },
    [41021436] = { label="Ishyra",
        criteria=58460,
        quest=73100, -- 74338
        npc=200579,
        vignette=5489,
    },
    [72986738] = { label="Veltrax",
        criteria=58467,
        quest=73229, -- 74345
        npc=200904,
        vignette=5517,
    },
    [43949052] = { label="Grugoth the Hullcrusher",
        criteria=58465,
        quest=73154, -- 74343
        npc=200721,
        vignette=5500,
    },
}, {
    achievement=17525, -- Champion of the Forbidden Reach
})

ns.RegisterPoints(ns.FORBIDDENREACH, {
    [29804740] = {},
    [35404080] = {},
    [37402300] = {},
    [41403820] = {},
    [54404660] = {},
    [54405540] = {},
    [62606140] = {},
    [62606160] = {},
    [63805060] = {},
    [74003740] = {},
}, {
    npc=203280, -- To'no and Little Ko (203286)
    spell=405714,
    note="The kids are stealthed; talk to them for a gift",
    atlas="Vehicle-GrummleConvoy",
    minimap=true,
})

--[[
ns.RegisterPoints(ns.FORBIDDENREACH, {
    [42605200] = { label="Elusive Frenzied Amberfur",
        quest=nil,
        npc=202436,
    },
    [0] = { label="Goldenfur Skyfox",
        quest=nil,
        npc=203675,
    },
    [0] = { label="Elusive Auric Argali",
        quest=nil,
        npc=202441,
    },
    [0] = { label="Vinyeti",
        quest=nil,
        npc=199163,
    },
    [0] = { label="PH Vrykul",
        quest=nil,
        npc=200980,
    },
    [0] = { label="Rarebear",
        quest=nil,
        npc=199210,
    },
})
--]]

ns.RegisterPoints(ns.FORBIDDENREACH, {
    [48197366] = {criteria=58501, loot={204338}, path=51915963}, -- The Burden of Lapisagos
    -- ^ 2102 @ 52405970
    [64783441] = {criteria=58502, loot={204316}, path=60313860}, -- A Soldier's Journal
    -- ^ 2154 @ 64765652
    [71046733] = {criteria=58503, loot={204335}}, -- A Song of the Depths
    [34930891] = {criteria=58504, loot={204328}}, -- Return of the Nightsquall
    [57456342] = {criteria=58505, loot={204321}}, -- Lost Expedition Notes
    [61553378] = {criteria=58506, loot={204317}}, -- Words of the Wyrmslayer
    -- In the vaults:
    -- [] = {criteria=58660, loot={204691}}, -- Living Book
    -- [] = {criteria=58661, loot={204181}}, -- Opera of the Aspects
    -- [] = {criteria=58507, loot={204185}}, -- The Old Gods and the Ordering of Azeroth (Annotated)
}, {
    achievement=17530, -- Librarian of the Reach
    texture=ns.atlas_texture("profession", {r=1, g=1, b=0}),
    minimap=true,
})

ns.RegisterVignettes(ns.FORBIDDENREACH, {
    [5614] = {}, -- Forbidden Hoard
    [5463] = {}, -- Forbidden Hoard (locked)
}, {
    loot={
        {197000, quest=69200}, -- Cliffside Wylderdrake: Coiled Horns
        {203463, quest=74359}, -- Atrenosh's Journal
        202667, -- Sealed Artifact Scroll
        202668, -- Sealed Spirit Scroll
        202669, -- Sealed Fish Scroll
        202670, -- Sealed Knowledge Scroll
    },
})
