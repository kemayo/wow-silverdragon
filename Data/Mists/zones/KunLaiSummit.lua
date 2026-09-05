local myname, ns = ...

ns.RegisterPoints(379, { -- Kun Lai Summit
    [52907140] = { loot={86394}, note="in the cave", quest=31413, }, -- Hozen Warrior Spear
    [35207640] = { loot={86125}, quest=31304, npc=64227, }, -- Kafa Press (Frozen Trail Packer)
    [73107350] = { label="Sprite's Cloth Chest", note="in the cave", quest=31412, },
    [71206260] = { loot={88723}, note="in Stash of Yaungol Weapons", quest=31421, }, -- Sturdy Yaungol Spear
    [44705240] = { loot={86393}, quest=31417, }, -- Tablet of Ren Yun
}, ns.treasure{})
ns.RegisterPoints(383, { -- TheDeeper, cave in Kun-Lai
    [24106580] = { loot={86394}, quest=31413, }, -- Hozen Warrior Spear
}, ns.treasure{})
ns.RegisterPoints(381, { -- PrankstersHollow, cave in Kun-Lai
    [54706980] = { label="Sprite's Cloth Chest", quest=31412, },
}, ns.treasure{})

ns.RegisterPoints(379, { -- Kun Lai Summit
    [64234513] = { loot={86471}, quest=31420, note="in the cave" }, -- Ancient Mogu Tablet
    [50366177] = { label="Hozen Treasure Cache", note="in the cave", quest=31414, },
    [36747982] = { label="Lost Adventurer's Belongings", quest=31418, },
    [52575154] = { loot={86430}, note="In Rikktik's Tiny Chest", quest=31419, path=52285088, }, -- Rikktik's Tick Remover
    [72013396] = { loot={86422}, quest=31416, }, -- Statue of Xuen
    [59405300] = { label="Stolen Sprite Treasure", note="in the cave", quest=31415, },
    [59247303] = { loot={86427}, quest=31422, nearby={57007540,57807630,58407340,59207440,}, note="Various spawn points in the ruins", }, -- Terracotta Head
}, ns.riches{})
ns.RegisterPoints(382, { -- KnucklethumpHole, cave in Kun-Lai
    [52002750] = ns.riches{ label="Hozen Treasure Cache", quest=31414, },
})
ns.RegisterPoints(380, { -- HowlingwindCavern, cave in Kun-Lai
    [41674412] = ns.riches{ label="Stolen Sprite Treasure", quest=31415, },
})

ns.RegisterPoints(379, {
    [47887350] = { label="Mo-Mo's Treasure Chest", quest=31868, },
}, ns.junk{})

-- Rares

ns.RegisterPoints(379, { -- Kun-Lai Summit
    [40604280] = { label="Ahone the Wanderer",
        quest=nil,
        criteria=21086,
        npc=50817,
        loot={
            {86588,toy=true,}, -- Pandaren Firework Launcher
        },
    },
    [55404340] = { label="Borginn Darkfist",
        quest=nil,
        criteria=21072,
        npc=50341,
        vignette=152,
    },
    [59357376] = { label="Havak",
        quest=nil,
        criteria=21079,
        npc=50354,
        loot={
            {86573,toy=true,}, -- Shard of Archstone
        },
        vignette=145,
    },
    [47508123] = { label="Korda Torros",
        quest=nil,
        criteria=21100,
        npc=50332,
        loot={
            86566, -- Forager's Gloves
        },
        vignette=159,
    },
    [63801380] = { label="Nessos the Oracle",
        quest=nil,
        criteria=21093,
        npc=50789,
        loot={
            {86584, toy=true,}, -- Hardened Shell
        },
        vignette=124,
    },
    [44806380] = { label="Scritch",
        quest=nil,
        criteria=21051,
        npc=50831,
        loot={
            86592, -- Hozen Peace Pipe
        },
        vignette=110,
    },
    [36667984] = { label="Ski'thik",
        quest=nil,
        criteria=21065,
        npc=50733,
        loot={
            86577, -- Rod of Ambershaping
        },
        vignette=138,
    },
    [73007660] = { label="Zai the Outcast",
        quest=nil,
        criteria=21058,
        npc=50769,
        loot={
            {86581,toy=true,}, -- Farwater Conch
        },
    },
}, {
    achievement=7439, -- Glorious!
    loot_shared={
        87217, -- Small Bag of Goods
        87613, -- Frozen Zandalari Bracer
        87614, -- Kafa Picker's Bracers
        87615, -- Yakwasher's Bracers
        87616, -- Mountain Trailblazer's Cuffs
        87617, -- Bracers of the Serene Mountaintop
        87618, -- Ice Encrusted Bracer
        87619, -- Terracotta Guardian's Bracer
        87620, -- Bracers of the Frozen Summit
        87621, -- Wristguards of Great Fortune
    },
})

ns.RegisterPoints(379, { -- Kun-Lai Summit
    [75006740] = { label="Zandalari Warbringer",
        quest=nil,
        npc=69841, -- also 69769, 69842
        loot={
            {94230,mount=534,}, -- Reins of the Amber Primordial Direhorn
            {94229,mount=535,}, -- Reins of the Slate Primordial Direhorn
            {94231,mount=536,}, -- Reins of the Jade Primordial Direhorn
        },
        loot_shared=ns.zandalari_loot,
        atlas="VignetteKillElite", scale=1.2,
    },
    [64606400] = { label="Zandalari Warscout",
        quest=nil,
        npc=69768,
        loot_shared=ns.zandalari_loot,
        routes={
            {64606400, 68006440, 74606780, 71607240, 71207420, 67807940},
        },
        vignette=98,
    },
    [53606460] = { label="Sha of Anger",
        quest=32099,
        npc=60491,
        loot={
            {87771, mount=473,}, -- Reins of the Heavenly Onyx Cloud Serpent
            {89317, quest=31809,}, -- Claw of Anger
        },
    },
    [73008540] = { label="Krakkanon",
        quest=nil,
        npc=70323,
        loot={
            88563, -- Nat's Fishing Journal
        },
    },
})
