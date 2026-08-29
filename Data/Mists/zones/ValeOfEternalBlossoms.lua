local myname, ns = ...

-- no treasures

ns.RegisterPoints(390, { -- Vale of Eternal Blossoms
    [42846925] = { label="Ai-Ran the Shifting Cloud",
        quest=nil,
        criteria=21089,
        npc=50822,
        loot={
            {86590,toy=true,}, -- Essence of the Breeze
        },
        vignette=114,
    },
    [14005820] = { label="Kal'tik the Blight",
        quest=nil,
        criteria=21068,
        npc=50749,
        loot={
            -- 86579, -- Bottled Tornado (pre-toy version)
            {134023,toy=true,}, -- Bottled Tornado
        },
    },
    [15003540] = { label="Kang the Soul Thief",
        quest=nil,
        criteria=21075,
        npc=50349,
        loot={
            {86571,toy=true,}, -- Kang's Bindstone
        },
    },
    [30809151] = { label="Major Nanners",
        quest=nil,
        criteria=21054,
        npc=50840,
        loot={
            {86594,toy=true,}, -- Helpful Wikky's Whistle
        },
        vignette=107,
    },
    [37535721] = { label="Moldo One-Eye +2",
        quest=nil,
        criteria=21096,
        npc=50806,
        loot={
            {86586,toy=true,}, -- Panflute of Pandaria
        },
        vignette=121,
    },
    [69203020] = { label="Sahn Tidehunter",
        quest=nil,
        criteria=21061,
        npc=50780,
        loot={
            {86582,toy=true,}, -- Aqua Jewel
        },
    },
    [39582515] = { label="Urgolax",
        quest=nil,
        criteria=21082,
        npc=50359,
        loot={
            {86575,toy=true,}, -- Chalice of Secrets
        },
    },
    [88084434] = { label="Yorik Sharpeye",
        quest=nil,
        criteria=21103,
        npc=50336,
        loot={
            {86568,toy=true,}, -- Mr. Smite's Brass Compass
        },
        vignette=156,
    },
}, {
    achievement=7439, -- Glorious!
})

ns.RegisterPoints(390, { -- Vale of Eternal Blossoms
    [35038997] = { label="Aetha",
        quest=nil,
        criteria=20521,
        npc=58778,
        vignette=37,
    },
    [16404780] = { label="Bai-Jin the Butcher",
        quest=nil,
        criteria=20530,
        npc=58949,
    },
    [28404300] = { label="Baolai the Immolator",
        quest=nil,
        criteria=20524,
        npc=63695,
    },
    [24602670] = ns.path{ -- Bloodtip, Huo-Shang, Gaohun the Soul-Severer
        quest=nil,
        label="{zone:395}",
        criteria={20526, 20525, 20529},
        -- npc={58474, 62881, 63691},
    },
    [46455934] = { label="Cracklefang",
        quest=nil,
        criteria=20517,
        npc=58768,
        vignette=34,
    },
    [30365802] = { label="General Temuja",
        quest=nil,
        criteria=20519,
        npc=63101,
        vignette=42,
    },
    [27001340] = { label="Gochao the Ironfist",
        quest=nil,
        criteria=20528,
        npc=62880,
        path=28001530,
        note="Inside a blocked cave",
        vignette=40,
    },
    [6205780] = { label="Kri'chon",
        quest=nil,
        criteria=20531,
        npc=63978,
    },
    [66203900] = { label="Quid",
        quest=nil,
        criteria=20522,
        npc=58771,
    },
    [30597837] = { label="Shadowmaster Sydow",
        quest=nil,
        criteria=20520,
        npc=63240,
        vignette=43,
    },
    [47406620] = { label="Spirit of Lao-Fe",
        quest=nil,
        criteria=20523,
        npc=58817,
    },
    [37385090] = { label="Vicejaw",
        quest=nil,
        criteria=20518,
        npc=58769,
        vignette=35,
    },
    [7803380] = { label="Vyraxxis",
        quest=nil,
        criteria=20532,
        npc=63977,
    },
    [45347624] = { label="Wulon",
        quest=nil,
        criteria=20527,
        npc=63510,
        path=40807720,
        vignette=44,
    },
}, {
    achievement=7317, -- One Many Army
})
ns.RegisterPoints(395, {-- Guo-Lai Halls
    [64041911] = { label="Huo-Shuang",
        quest=nil,
        criteria=20529,
        npc=63691,
        note="Inside the Guo-Lai Halls"
    },
    [75804758] = { label="Bloodtip",
        quest=nil,
        criteria=20526,
        npc=58474,
        vignette=33,
    },
    [53395910] = { label="Gaohun the Soul-Severer",
        quest=nil,
        criteria=20525,
        npc=62881,
    },
})

ns.RegisterPoints(390, { -- Vale of Eternal Blossoms
    [16603400] = { label="Alani",
        quest=nil,
        npc=64403,
        loot={
            {90655,mount=517,boe=true,}, -- Reins of the Thundering Ruby Cloud Serpent
        },
    },
})
