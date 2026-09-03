local myname, ns = ...

-- Treasure chests
ns.RegisterPoints(1462, { -- Mechagon
    -- 325659
    [43304977] = {quest=55547, note="Chest 1 (of 9 in Normal Time)"},
    [52115326] = {quest=55547, note="Chest 1 (of 9 in Normal Time)"},
    [53254190] = {quest=55547, note="Chest 1 (of 9 in Normal Time)"},
    [49223021] = {quest=55547, note="Chest 1 (of 9 in Normal Time)"},
    [56973861] = {quest=55547, note="Chest 1 (of 9 in Normal Time)"},
    -- 325660
    [35683833] = {quest=55548, note="Chest 2 (of 9 in Normal Time)"},
    [30785183] = {quest=55548, note="Chest 2 (of 9 in Normal Time)"},
    [40155409] = {quest=55548, note="Chest 2 (of 9 in Normal Time)"},
    [20617141] = {quest=55548, note="Chest 2 (of 9 in Normal Time)"},
    -- 325661
    [80374838] = {quest=55549, note="Chest 3 (of 9 in Normal Time)"},
    [73515334] = {quest=55549, note="Chest 3 (of 9 in Normal Time)"},
    [67075645] = {quest=55549, note="Chest 3 (of 9 in Normal Time)"},
    [65866460] = {quest=55549, note="Chest 3 (of 9 in Normal Time)"},
    [59946357] = {quest=55549, note="Chest 3 (of 9 in Normal Time)"},
    -- 325662
    [65555284] = {quest=55550, note="Chest 4 (of 9 in Normal Time)"},
    [72594733] = {quest=55550, note="Chest 4 (of 9 in Normal Time)"},
    [73014950] = {quest=55550, note="Chest 4 (of 9 in Normal Time)"},
    [76215286] = {quest=55550, note="Chest 4 (of 9 in Normal Time)"},
    [81196149] = {quest=55550, note="Chest 4 (of 9 in Normal Time)"},
    -- 325664
    [66432227] = {quest=55552, note="Chest 5 (of 9 in Normal Time)"},
    [64092627] = {quest=55552, note="Chest 5 (of 9 in Normal Time)"},
    [56782918] = {quest=55552, note="Chest 5 (of 9 in Normal Time)"},
    [57142283] = {quest=55552, note="Chest 5 (of 9 in Normal Time)"},
    [55612404] = {quest=55552, note="Chest 5 (of 9 in Normal Time)"},
    [50662858] = {quest=55552, note="Chest 5 (of 9 in Normal Time)"},
    -- 325665
    [67322289] = {quest=55553, note="Chest 6 (of 9 in Normal Time)"},
    [80691868] = {quest=55553, note="Chest 6 (of 9 in Normal Time)"},
    [86232042] = {quest=55553, note="Chest 6 (of 9 in Normal Time)"},
    [88732015] = {quest=55553, note="Chest 6 (of 9 in Normal Time)"},
    [85752824] = {quest=55553, note="Chest 6 (of 9 in Normal Time)"},
    -- 325666
    [48367595] = {quest=55554, note="Chest 7 (of 9 in Normal Time)"},
    [57258202] = {quest=55554, note="Chest 7 (of 9 in Normal Time)"},
    [62297390] = {quest=55554, note="Chest 7 (of 9 in Normal Time)"},
    [66767759] = {quest=55554, note="Chest 7 (of 9 in Normal Time)"},
    -- 325667
    [63626715] = {quest=55555, note="Chest 8 (of 9 in Normal Time)"},
    [72126545] = {quest=55555, note="Chest 8 (of 9 in Normal Time)"},
    [76516601] = {quest=55555, note="Chest 8 (of 9 in Normal Time)"},
    [81167231] = {quest=55555, note="Chest 8 (of 9 in Normal Time)"},
    [85166335] = {quest=55555, note="Chest 8 (of 9 in Normal Time)"},
    -- 325668
    [24796526] = {quest=55556, note="Chest 9 (of 9 in Normal Time)"},
    [20537696] = {quest=55556, note="Chest 9 (of 9 in Normal Time)"},
    [21788303] = {quest=55556, note="Chest 9 (of 9 in Normal Time)"},
    [12088568] = {quest=55556, note="Chest 9 (of 9 in Normal Time)"},
}, {
    label="Mechanized Chest",
    requires_no_buff=296644,
})

ns.RegisterPoints(1462, { -- Mechagon
    -- 325663, Alt Mechagon only
    [61583230] = {quest=55551, note="Chest 1 (of 1 in Alternate Time)"},
    [58634160] = {quest=55551, note="Chest 1 (of 1 in Alternate Time)"},
    [70654796] = {quest=55551, note="Chest 1 (of 1 in Alternate Time)"},
    [64365961] = {quest=55551, note="Chest 1 (of 1 in Alternate Time)"},
    [56665739] = {quest=55551, note="Chest 1 (of 1 in Alternate Time)"},
}, {
    label="Mechanized Chest",
    requires_buff=296644,
})

-- Rares
ns.RegisterPoints(1462, { -- Mechagon
    [62802600] = {quest=55814, npc=150342, loot={{167042, quest=55030}}, criteria=45138, note="Complete Drill Rig DR-TR35 and enter the cave"}, -- Earthbreaker Gulroc
    [60604460] = {quest=55546, npc=150394, loot={{170072, pet=2766}, {167843, quest=55058}, {167796, quest=55455}}, criteria=45158, vignette=3586,}, -- Armored Vaultbot
    [38805320] = {quest=55368, npc=150575, loot={{168001, quest=55517}}, criteria=45123}, -- Rumblerocks
    [19207940] = {quest=55545, npc=150937, loot={{168063, quest=55065}}, criteria=45133}, -- Seaspit
    [56905330] = {quest=55207, npc=151124, loot={{168490, quest=55069}, {169688, quest=56515}}, criteria=45117}, -- Mechagonian Nullifier
    [65605100] = {quest=55513, npc=151202, loot={{167871, quest=55063}, {167042, quest=55030}}, criteria=45127}, -- Foul Manifestation
    [56803990] = {quest=55515, npc=151296, loot={{168492, quest=55071}}, criteria=45129}, -- OOX-Avenger/MG
    [53003300] = {quest=55539, npc=151308, loot={{169688, quest=56515}}, criteria=45131}, -- Boggac Skullbash
    [35804300] = {quest=55514, npc=151569, loot={{167836, quest=55057}}, criteria=45128}, -- Deepwater Maw
    [71204840] = {quest=55364, npc=151625, loot={{167846, quest=55061}, 168435}, criteria=45118}, -- The Scrap King
    [59806080] = {quest=55859, npc=151627, loot={{168248, quest=55068}, {167794, quest=55454}}, criteria=45156}, -- Mr. Fixthis
    [86801940] = {quest=55386, npc=151672, loot={{169393, pet=2720}}, criteria=45119}, -- Mecharantula
    [75404400] = {quest=55399, npc=151684, loot=nil, criteria=45121}, -- Jawbreaker
    [23006860] = {quest=55405, npc=151702, loot={170468}, criteria=45122}, -- Paol Pondwader
    [48704760] = {quest=55367, npc=151884, loot={{169379, pet=2712}, {167793, quest=55457}}, criteria=45126}, -- Fungarian Furor
    [61004120] = {quest=55544, npc=151933, loot={{169382, pet=2715}}, criteria=45136}, -- Malfunctioning Beastbot
    [51604160] = {quest=55512, npc=151934, loot={{168823, mount=1229}}, criteria=45124}, -- Arachnoid Harvester
    [57002140] = {quest=55538, npc=151940, loot=nil, criteria=45132}, -- Uncle T'Rogg
    [65202320] = {quest=55537, npc=152001, loot={{169392, pet=2719}}, criteria=45130}, -- Bonepicker
    [43404900] = {quest=55369, npc=152007, loot={{167931, toy=true}}, criteria=45125}, -- Killsaw
    [68354810] = { label="The Kleptoboss",
        quest=55858, npc=152113, loot={{169886, pet=2753}}, criteria=45153,
        note="Complete Drill Rig DR-CC88 and enter the cave",
    },
    [63807800] = {quest=55811, npc=152182, loot={{168370, mount=1248}}, criteria=45135}, -- Rustfeather
    [82202100] = {quest=55812, npc=152570, loot={{169167, quest=55075}, {169169, quest=55077}, {169168, quest=55076}, {167793, quest=55457}, {167792, quest=55452}}, criteria=45137}, -- Crazed Trogg
    [57206260] = {quest=55856, npc=152764, loot={{167794, quest=55454}}, criteria=45157}, -- Oxidized Leachbeast
    [78203080] = {quest=55810, npc=153000, loot=nil, criteria=45134}, -- Sparkqueen P'Emp
    [51205000] = {quest=55857, npc=153200, loot={{167042, quest=55030}, {169691, quest=56518}}, criteria=45152, note="Complete Drill Rig DR-JD41 and enter the cave"}, -- Boilburn
    [59606730] = {quest=55855, npc=153205, loot={{169691, quest=56518}}, criteria=45146, note="Complete Drill Rig DR-JD99 and enter the cave"}, -- Gemicide
    [56103600] = {quest=55853, npc=153206, loot={{169691, quest=56518}}, criteria=45145, note="Complete Drill Rig DR-TR28 and enter the cave"}, -- Ol' Big Tusk
    [24807720] = {quest=55854, npc=153226, loot={{168062, quest=55064}}, criteria=45154}, -- Steel Singer Freza
    [40203960] = {quest=55852, npc=153228, loot={{167847, quest=55062}}, criteria=45155}, -- Gear Checker Cogstar
    [53806180] = {quest=56207, npc=154153, loot={{169174, quest=55082}, 170467}, criteria=45373}, -- Enforcer KX-T57
    [58305690] = {quest=56182, npc=154225, loot={{169347, toy=true}, 170467}, criteria=45374, note="Time displaced"}, -- The Rusty Prince
    [72965404] = { label="Gorged Gear-Cruncher",
        quest=56367, npc=154701, loot={{167846, quest=55061}}, criteria=45410,
        note="Complete Drill Rig DR-CC61 project and enter the cave",
    },
    [66505870] = { label="Caustic Mechaslime",
        quest=56368, npc=154739, loot={{169170, quest=55078}}, criteria=45411,
        note="Complete Drill Rig DR-CC73 project and enter the cave",
    },
    [80902020] = {quest=56419, npc=155060, loot=nil, criteria=45433}, -- Doppel Ganger
    [81407600] = {quest=56737, npc=155583, loot={{168490, quest=55069}}, criteria=45691}, -- Scrapclaw
}, {
    achievement=13470,
})

-- Secret Fish

ns.RegisterPoints(1462, { -- Mechagon
    [35004650] = { label="Bolted Steelhead, Energized Lighting Cod, Solarsprocket Barbel",
        criteria={44738, 44744, 44745},
        loot={{167655,quest=55305},{167661,quest=55311},{167662,quest=55312}},
        note="These can be fished anywhere on the coast",
    },
    [76704920] = {criteria=44737,loot={{167654,quest=55299}}}, -- Bottom Feeding Stinkfish
    [55803190] = {criteria=44739,loot={{167656,quest=55306}}}, -- Pond Hopping Springfish
    [59102280] = {criteria=44740,loot={{167657,quest=55307}}}, -- Shadowy Cave Eel
    [26107570] = {criteria=44741,loot={{167658,quest=55308}}}, -- Mechanical Blowfish
    [83707300] = {criteria=44742,loot={{167659,quest=55309}}}, -- Spitting Clownfish
    [65505220] = {criteria=44743,loot={{167660,quest=55310}}}, -- Sludge-fouled Carp
    [47403600] = {criteria=44746,loot={{167663,quest=55313}}}, -- Tasty Steelfin
}, {
    achievement=13489,
    atlas="worldquest-icon-fishing",
    minimap=true,
})