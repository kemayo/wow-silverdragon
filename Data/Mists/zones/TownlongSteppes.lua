local myname, ns = ...

ns.RegisterPoints(388, { -- Townlong Steppes
    [66304470] = { loot={86518}, quest=31425, }, -- Yaungol Fire Carrier
    [66804800] = { loot={86518}, quest=31425, }, -- Yaungol Fire Carrier
}, ns.treasure{})
ns.RegisterPoints(388, { -- Townlong Steppes
    [62823405] = { label="Abandoned Crate of Goods", note="in a tent", quest=31427, },
    [65838608] = { loot={86472}, quest=31426, }, -- Amber Encased Moth
    [52845617] = { loot={86517}, quest=31424, }, -- Hardened Sap of Kri'vess
    [57505850] = { loot={86517}, quest=31424, }, -- Hardened Sap of Kri'vess
    [32806160] = { loot={86516}, note="in the cave", quest=31423, }, -- Fragment of Dread
}, ns.riches{})
ns.RegisterPoints(389, { -- Niuzao Catacombs, cave in Townlong
    [56406480] = { loot={86516}, quest=31423, }, -- Fragment of Dread
    [36908760] = { loot={86516}, quest=31423, }, -- Fragment of Dread
    [48408860] = { loot={86516}, quest=31423, }, -- Fragment of Dread
    [64502150] = { loot={86516}, quest=31423, }, -- Fragment of Dread
}, ns.riches{})

-- Rares

ns.RegisterPoints(388, { -- Townlong Steppes
    [65408740] = { label="Eshelon",
        quest=nil,
        criteria=21059,
        npc=50772,
        loot={
            87222, -- Big Bag of Linens
        },
        vignette=130,
    },
    [62803540] = { label="Kah'tir",
        quest=nil,
        criteria=21080,
        npc=50355,
    },
    [41807860] = { label="Lith'ik the Stalker",
        quest=nil,
        criteria=21066,
        npc=50734,
        loot={
            87221, -- Big Bag of Jewels
        },
    },
    [64004940] = { label="Lon the Bull",
        quest=nil,
        criteria=21101,
        npc=50333,
    },
    [53806340] = { label="Norlaxx",
        quest=nil,
        criteria=21073,
        npc=50344,
        loot={
            87220, -- Big Bag of Mysteries
        },
    },
    [59208540] = { label="Siltriss the Sharpener",
        quest=nil,
        criteria=21094,
        npc=50791,
    },
    [67607420] = { label="The Yowler",
        quest=nil,
        criteria=21052,
        npc=50832,
        loot={
            87225, -- Big Bag of Food
        },
    },
    [32006180] = { label="Yul Wildpaw",
        quest=nil,
        criteria=21087,
        npc=50820,
        loot={
            87224, -- Big Bag of Wonders
        },
    },
}, {
    achievement=7439, -- Glorious!
})
ns.RegisterPoints(388, { -- Townlong Steppes
    [36408540] = { label="Zandalari Warbringer",
        quest=nil,
        npc=69841, -- also 69769, 69842
        loot={
            {94230,mount=534,}, -- Reins of the Amber Primordial Direhorn
            {94229,mount=535,}, -- Reins of the Slate Primordial Direhorn
            {94231,mount=536,}, -- Reins of the Jade Primordial Direhorn
        },
        atlas="VignetteKillElite", scale=1.2,
        vignette=163,
    },
    [48808460] = { label="Zandalari Warscout",
        quest=nil,
        npc=69768,
        loot={
            94159, -- Small Bag of Zandalari Supplies
            94158, -- Big Bag of Zandalari Supplies
        },
        routes={
            {48808460, 46808960, 43609080, 40808980, 37008480, 40008040, 40407740, 44207480, 47407440, 49407320},
        },
        vignette=98,
    },
    [35205120] = { label="Krakkanon",
        quest=nil,
        npc=70323,
        loot={
            88563, -- Nat's Fishing Journal
        },
    },
    [37205760] = { label="Huggalon the Heart Watcher",
        quest=nil,
        npc=66900,
        loot={
            {90067,toy=true,}, -- B. F. F. Necklace
        },
    },
})
