local myname, ns = ...

local NZOTH = ns.conditions.WorldQuestActive(56064)
local MOGU = ns.conditions.WorldQuestActive(57008)
local MANTID = ns.conditions.WorldQuestActive(57728)

-- these come up a lot...
local moguWeapons = {
    174221, -- Cleaver of the Fractured Dynasty (1h axe)
    174225, -- Bulwark of the Traitorous Disciple (shield)
    174229, -- Lantern of the Damned (offhand)
}
local mantidWeapons = {
    174220, -- Ambered Greatstaff (staff)
    174223, -- Ooze-Imbued Rifle (gun)
    174226, -- Paragon's Will (1h sword)
}

-- N'Zoth Assault
ns.RegisterPoints(1530, { -- Vale of Eternal Blossoms
    [44004420] = {quest=57343, npc=157267,}, -- Escaped Mutation
    [50606560] = { label="Kilxl the Gaping Maw",
        quest=57341, npc=157266,
        -- routes={{44606320,45205900,48005860,50606550,49206860,46407020}},
    },
    [51804100] = {quest=57342, npc=157176, loot={{174473, pet=2845}}, note="On floating platform"}, -- The Forgotten
    [52406140] = {quest=56303, npc=154495, loot={{175140, toy=true}, 175141, {174474, pet=2846}}}, -- Will of N'Zoth
    [56404120] = {quest=56237, npc=154447,}, -- Brother Meller
    [67602900] = {quest=56183, npc=154332, note="Underground in Pools of Power",}, -- Voidtender Malketh
    [64405140] = {quest=56302, npc=154490,}, -- Rijz'x the Devourer
    [65006700] = {quest=56323, npc=154559, note="Underground in the mine",}, -- Deeplord Zrihj
    [69404140] = {quest=56084, npc=154087,}, -- Zror'um the Infinite
    [80206360] = {quest=56255, npc=154467,}, -- Chief Mek-mek
    [85404120] = {quest=56213, npc=154394,}, -- Veskan the Fallen
    [89004760] = {quest=56094, npc=154106,}, -- Quid
}, {
    requires=NZOTH,
})
ns.RegisterPoints(1579, { -- Pools of Power
    [37004780] = {quest=56183, npc=154332}, -- Voidtender Malketh
}, {
    requires=NZOTH,
})

-- Mogu Assault
ns.RegisterPoints(1530, { -- Vale of Eternal Blossoms
    [17601120] = {quest=58295, npc=160968, note="Inside Guo-Lai Halls",}, -- Jade Colossus
    [16403840] = {quest=57351, npc=157291, }, -- Spymaster Hul'ach
    [17006660] = {quest=59216, npc=157183, }, -- Coagulated Anima
    [19807300] = {quest=59216, npc=157183, }, -- Coagulated Anima
    [21206380] = {quest=59216, npc=157183, }, -- Coagulated Anima
    [20401260] = {quest=57346, npc=157162, loot=tAppendAll({174230,{174649,mount=1313}}, moguWeapons), note="Use the scale to buy the mount",}, -- Rei Lun
    [27007400] = { label="Stormhowl",
        quest=57348, npc=157279,
        -- routes={{23807700,27007400,27207140}},
    },
    [26401040] = {quest=57350, npc=157290, note="In cave",}, -- Jade Watcher
    [29053930] = { label="Ha-Li",
        quest=57344, npc=157153,
        -- routes={{37323630,33973378,29053930,31524387,37313632,37323630,loop=true}},
        loot=tAppendAll({{173887,mount=1297}}, moguWeapons),
        note="Flying in a circle counterclockwise",
    },
    [28404020] = {quest=57347, npc=157171,}, -- Heixi the Stonelord
    [29402220] = {quest=58507, npc=155958, loot={{174873, toy=true}}}, -- Tashara
    [33406740] = {quest=57363, npc=157466, loot=tAppendAll({{174840,mount=1328}}, moguWeapons),}, -- Anh-De the Loyal
    [41406000] = {quest=57349, npc=157287,}, -- Dokani Obliterator
    [47605600] = {quest=56954, npc=156083, loot=tAppendAll({174071}, moguWeapons),}, -- Sanguifang
    [47406420] = {quest=56332, npc=154600,}, -- Teng the Awakened
    [53204960] = {quest=57358, npc=157443,}, -- Xiln the Mountain
    [11603160] = { label="Houndlord Ren",
        quest=57345, npc=157160,
        loot=tAppendAll({{174841,mount=1327}}, moguWeapons),
        routes={{09003520,11603160,12802640}},
    },
    [26805510] = { label="Ivory Cloud Serpent",
        npc=163042,
        loot={{174752,mount=1311}},
        note="You need a {item:174927:Zan-Tien Lasso} to catch it. It spawns fairly high up",
    },
}, {
    requires=MOGU,
    loot=moguWeapons,
})

-- Mantid Assault
ns.RegisterPoints(1530, { -- Vale of Eternal Blossoms
    [10404040] = {quest=58305, npc=160874,}, -- Drone Keeper Ak'thet
    [13005140] = {quest=58303, npc=160868,}, -- Harrier Nir'verash
    [13403240] = {quest=58311, npc=160922,}, -- Needler Zhesalla
    [17200960] = {quest=58310, npc=160920,}, -- Kal'tik the Blight
    [17206340] = {quest=58312, npc=160930,}, -- Infused Amber Ooze
    [19407340] = {quest=58300, npc=160825,}, -- Amber-Shaper Esh'ri
    [20206140] = {quest=58301, npc=160826,}, -- Hive-Guard Naz'ruzek
    [26403920] = {quest=58302, npc=160867,}, -- Kzit'kovok
    [27204380] = {quest=58309, npc=160906,}, -- Skiver
    [04204860] = { label="Captain Vor'lek",
        quest=58308, npc=160893,
        --routes={{08807060,06607060,06606400,04206400,04204860,06604180,06602860}},
    },
    [28205260] = {quest=58299, npc=160810,}, -- Harbinger Il'koxik
    [05606400] = {quest=58307, npc=160878,}, -- Buh'gzaki the Blasphemous
    [11604160] = {quest=58306, npc=160876,}, -- Enraged Amber Elemental
    [12603260] = {quest=58304, npc=160872,}, -- Destroyer Krox'tazar
    [21604460] = {quest=58304, npc=160872,}, -- Destroyer Krox'tazar
    [25406780] = {quest=58304, npc=160872,}, -- Destroyer Krox'tazar
}, {
    requires=MANTID,
    loot=mantidWeapons,
})

-- Any assault
ns.RegisterPoints(1530, { -- Vale of Eternal Blossoms
    [9406740] = {quest=57364, npc=157468, loot=moguWeapons}, -- Tisiphon
    [5405620] = { label="Grand Empress Shek'zara",
        quest=58705, -- todo: actual quest
        worldquest=58705,
        npc=154638,
        loot={
            174234, -- Maniacal Speaker's Cover
            174243, -- Guise of the Voracious Prowler
            174255, -- Greaves of Shattered Thoughts
            174264, -- Chitinous Conqueror's Legplates
            174268, -- Loop of Abhorrent Celerity
        },
        requires={MANTID, MOGU, any=true},
    },
})
