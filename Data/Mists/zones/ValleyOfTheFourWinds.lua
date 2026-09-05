local myname, ns = ...

ns.RegisterPoints(376, { -- Valley of the Four Winds
    [46802460] = { loot={{85973, toy=true}}, npc=64004, quest=31284, }, -- Ancient Pandaren Fishing Charm
    [45403820] = { loot={86079}, npc=64191, quest=31292, }, -- Ancient Pandaren Craftsman
    [15402920] = { loot={86218}, quest=31407, }, -- Staff of the Hidden Master
    [14903360] = { loot={86218}, quest=31407, }, -- Staff of the Hidden Master
    [17503570] = { loot={86218}, quest=31407, }, -- Staff of the Hidden Master
    [19103780] = { loot={86218}, quest=31407, }, -- Staff of the Hidden Master
    [19004250] = { loot={86218}, quest=31407, }, -- Staff of the Hidden Master
    [43603740] = { label="Cache of Pilfered Goods", quest=31406, },
}, ns.treasure{})

ns.RegisterPoints(376, { -- Valley of the Four Winds
    [23712833] = { label="Virmen Treasure Cache", quest=31405, },
    [75105510] = { loot={86220}, quest=31408, path=77285750, } -- Saurok Stone Tablet
}, ns.riches{})

ns.RegisterPoints(376, { -- Valley of the Four Winds
    [92003900] = { loot={87524}, quest=31869, }, -- Boat-Building Instructions
    [52056382] = { loot={110505}, quest=37246, } -- Mysterious Fruit Pile (Mesmerizing Fruit Hat)
}, ns.junk{})

-- Rares

ns.RegisterPoints(376, { -- Valley of the Four Winds
    [32806240] = { label="Blackhoof",
        quest=nil,
        criteria=21098,
        npc=51059,
        loot={
            {86565, toy=true}, -- Battle Horn
        }
    },
    [13803860] = { label="Bonobos",
        quest=nil,
        criteria=21049,
        npc=50828,
        loot={
            86591, -- Magic Banana
        },
    },
    [18407740] = { label="Jonn-Dar",
        quest=nil,
        criteria=21077,
        npc=50351,
        loot={
            86572, -- Terracotta Fragment
        },
    },
    [8005920] = { label="Nal'lak the Ripper",
        quest=nil,
        criteria=21063,
        npc=50364,
        loot={
            86576, -- Dynasty of Steel
        },
    },
    [88401800] = { label="Nasra Spothide",
        quest=nil,
        criteria=21084,
        npc=50811,
        loot={
            86587, -- Seed of Tranquil Growth
        },
        translate={[371]=true}, -- The Jade Forest
    },
    [67405940] = { label="Salyin Warscout",
        quest=nil,
        criteria=21091,
        npc=50783,
        loot={
            {86583, toy=true,}, -- Salyin Battle Banner
        },
    },
    [52402820] = { label="Sele'na",
        quest=nil,
        criteria=21056,
        npc=50766,
        loot={
            86580, -- Wilted Lilypad
        },
        vignette=133,
    },
    [36802540] = { label="Sulik'shor",
        quest=nil,
        criteria=21070,
        npc=50339,
        loot={
            86569, -- Crystal of Insanity
        },
    },
}, {
    achievement=7439, -- Glorious!
    loot_shared={
        87217, -- Small Bag of Goods
        87595, -- Gloves of Burrow Spelunking
        87596, -- Mudmug's Mitts
        87597, -- Gloves of Congealed Mist
        87598, -- Monstrous Silk Gloves
        87599, -- Grower's Gloves
        87600, -- Marshsong Gloves
        87601, -- Plough Driving Grips
        87602, -- Grain Warden's Gauntlets
        87603, -- Thunderfall Gauntlets
    },
})

ns.RegisterPoints(376, { -- Valley of the Four Winds
    -- [71616441] = { -- Chief Salyis
    --     quest=32098,
    --     npc=62352,
    --     loot={
    --         {89783,mount=515,}, -- Son of Galleon's Saddle
    --     },
    -- },
    [69706190] = { label="Galleon (actually 71606440 but)",
        quest=32098,
        npc=62346,
        loot={
            {89783, mount=515,}, -- Son of Galleon's Saddle
        },
        atlas="VignetteKillElite", scale=1.2,
    },
})
