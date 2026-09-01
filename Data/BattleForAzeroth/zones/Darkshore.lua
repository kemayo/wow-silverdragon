local myname, ns = ...

-- The kodo
local kodo = {
    npc=148790,
    loot={
        {166433, mount=1201}, -- Frightened Kodo
    },
    atlas="stablemaster", scale=1.2, minimap=true,
    note="Appears for a few minutes at a time, you just need to click it",
    art=1176,
}
ns.RegisterPoints(62, {
    -- see: https://www.wowhead.com/npc=148790/frightened-kodo#comments:id=2869160
    [44056755] = {},
    [41255400] = {},
    [38006600] = {},
    [39205650] = {},
    [44006500] = {},
    [41306548] = {},
}, kodo)

local decor = {
    {241066, decor=true, expansion=LE_EXPANSION_WAR_WITHIN}, -- Forsaken Spiked Brazier
    {245462, decor=true, expansion=LE_EXPANSION_WAR_WITHIN}, -- Banshee Queen's Banner
    {245627, decor=true, expansion=LE_EXPANSION_WAR_WITHIN}, -- Elven Temple Brazier
    {246110, decor=true, expansion=LE_EXPANSION_WAR_WITHIN}, -- Filigree Moon Sconce
}
local addDecor = function(loot)
    if not loot then return decor end
    tAppendAll(loot, decor)
    return loot
end

-- Either faction
ns.RegisterPoints(62, { -- Darkshore
    [56483077] = { label="Alash'anir",
        quest={54695, 54696, any=true},
        npc=148787,
        loot={{166432, mount=1200}},
        vignette=3392,
    },
    [37838478] = { label="Aman",
        quest={54405, 54406, any=true},
        npc=147966,
        loot=addDecor(),
        vignette=3376,
    },
    [57381567] = { label="Amberclaw",
        quest={54285, 54286, any=true},
        npc=147744,
        vignette=3367, -- Glrglrr
    },
    [58482433] = { label="Athrikus Narassin",
        quest={54278, 54279, any=true},
        npc=147708,
        loot={{166784, toy=true}},
        vignette=3365,
    },
    [37957624] = { label="Commander Ral'esh",
        quest={54426, 54427, any=true},
        npc=148025,
        loot={{166787, toy=true}},
        vignette=3378,
    },
    [39296203] = { label="Conflagros",
        quest={54232, 54233, any=true},
        npc=147260,
        loot={{166451, pet=2546}},
        vignette=3353,
    },
    [43735358] = { label="Cyclarus",
        quest={54229, 54230, any=true},
        npc=147241,
        loot={{166448, pet=2545}},
        vignette=3352,
    },
    [43511964] = { label="Glimmerspine",
        quest={54884, 54885, any=true},
        npc=149654,
        loot=addDecor(),
        vignette=3520,
    },
    [48405557] = { label="Granokk",
        quest={54234, 54235, any=true},
        npc=147261,
        loot=addDecor(),
        vignette=3354,
    },
    [40915644] = { label="Gren Tornfur",
        quest={54428, 54429, any=true},
        npc=148031,
        loot={{166785, toy=true}},
        vignette=3379,
    },
    [52443213] = { label="Hydrath",
        quest={54227, 54228, any=true},
        npc=147240,
        loot={{166452, pet=2547}},
        vignette=3351,
    },
    [44044879] = { label="Madfeather",
        quest={54887, 54888, any=true},
        npc=149657,
        loot=addDecor(),
        vignette=3522,
    },
    [35848176] = { label="Mrggr'marr",
        quest={54408, 54409, any=true},
        npc=147970,
        loot=addDecor(),
        vignette=3377,
    },
    [47644454] = { label="Scalefiend",
        quest={54893, 54894, any=true},
        npc=149665,
        loot=addDecor(),
        vignette=3527,
    },
    [43492941] = { label="Shattershard",
        quest={54289, 54290, any=true},
        npc=147751,
        loot=addDecor(),
        vignette=3368,
    },
    [40618533] = { label="Soggoth the Slitherer",
        quest={54320, 54321, any=true},
        npc=147897,
        loot={{166454, pet=2549}},
        vignette=3373,
    },
    [45515899] = { label="Stonebinder Ssra'vess",
        quest={54247, 54248, any=true},
        npc=147332,
        loot=addDecor(),
        vignette=3355,
    },
    [40618269] = { label="Twilight Prophet Graeme",
        quest={54397, 54398, any=true},
        npc=147942,
        loot={{166455, pet=2550}},
        vignette=3375,
    },
}, {
    art=1176,
})

-- Alliance
ns.RegisterPoints(62, { -- Darkshore
    [49532495] = { label="Agathe Wyrmwood",
        quest=54883,
        npc=149652,
        loot={{166438, mount=1199}},
        note="Requires Alliance control",
        vignette=3519,
    },
    [41587674] = { label="Burninator Mark V",
        quest=54768,
        npc=149141,
        loot={
            {166788, toy=true},
            {166449, pet=2544},
        },
        note="Requires Alliance control",
        vignette=3503,
    },
    [46498598] = { label="Commander Drald",
        quest=54309,
        worldquest=54836,
        npc=147845,
        loot={{166790, toy=true}},
        vignette=3372,
    },
    [50643241] = { label="Croz Bloodrage",
        quest=54886,
        npc=149661,
        loot={{166437, mount=1205}},
        note="Requires Alliance control",
        vignette=3521,
    },
    [67251875] = { label="Moxo the Beheader",
        quest=54277,
        npc=147701,
        loot={{166434, mount=1203}},
        vignette=3364,
    },
    [39693341] = { label="Orwell Stevenson",
        quest=54889,
        npc=149664,
        loot={{166528, pet=2563}},
        note="Requires Alliance control",
        vignette=3523,
    },
    [62380985] = { label="Zim'kaga",
        quest=54274,
        worldquest=54820,
        npc=147664,
        loot={{166453, pet=2548}},
        vignette=3363,
    },
    [41233602] = { label="Ivus the Decayed",
        quest=54862,
        worldquest=54895,
        npc=148295,
        loot={
            161413, -- Knot of Ancient Fury
            161415, -- Forest Lord's Razorleaf
            161417, -- Ancient Knot of Wisdom
            166683, -- Garments of the Forest Lord
            166686, -- Ivus' Tanglemoss Waistcord
            166687, -- Warring Ancient's Mask
            166690, -- Protector's Tangleroot Belt
            166691, -- Forest Protector's Shoulderguards
            166694, -- Gnarled Bough Gauntlets
            166695, -- Petrified Ironbark Crown
            166698, -- Stoneroot Stompers
        },
    },
}, {
    art=1176,
    faction="Alliance",
})

-- Horde
ns.RegisterPoints(62, { -- Darkshore
    [41607640] = { label="Athil Dewfire",
        quest=54431,
        npc=148037,
        loot={{166449, pet=2544}, {166803, mount=1203}},
    },
    [49682495] = { label="Blackpaw",
        quest=54890,
        npc=149651,
        loot={{166428, mount=1199}},
        note="Requires Horde control",
    },
    [50703231] = { label="Grimhorn",
        quest=54891,
        npc=149656,
        loot={{166528, pet=2563}},
        note="Requires Horde control",
    },
    [45187495] = { label="Onu",
        quest=54291,
        npc=147758,
        loot={{166453, pet=2548}},
    },
    [32758405] = { label="Sapper Odette",
        quest=54452,
        npc=148103,
        loot={{166788, toy=true}},
    },
    [39753269] = { label="Shadowclaw",
        quest=54892,
        npc=149658,
        loot={{166435, mount=1205}},
    },
    [62101650] = { label="Thelar Moonstrike",
        quest=54252,
        npc=147435,
        loot={{166790, toy=true}},
    },
    [41233600] = { label="Ivus the Forest Lord",
        quest=54896, -- wq
        worldquest=54896,
        npc=144946,
        loot={
            166684, -- Garments of the Forest Lord
            166685, -- Ivus' Tanglemoss Waistcord
            166688, -- Warring Ancient's Crown
            166689, -- Protector's Tangleroot Belt
            166692, -- Forest Protector's Shoulderguards
            166693, -- Gnarled Bough Gauntlets
            166696, -- Petrified Ironbark Crown
            166697, -- Stoneroot Stompers
            166793, -- Ancient Knot of Wisdom
            166794, -- Forest Lord's Razorleaf
            166795, -- Knot of Ancient Fury
        },
    },
}, {
    art=1176,
    faction="Horde",
})

-- Caches

-- There's 10 different objectids here, appearing in clusters. I haven't
-- actually proved to myself that each objectid corresponds to a specific
-- questid, but it does seem likely...

ns.RegisterPoints(62, {
    [58802525] = {quest=54872, vignette=3514},
    [61222000] = {quest=54872, vignette=3514},
    [48242742] = {quest=54877, vignette=3515},
    [42383860] = {quest=54879, vignette=3516},
    [46825568] = {quest=54880, vignette=3517},
    [37277695] = {quest=54881, vignette=3518},
    [37746163] = {quest=54881, vignette=3518},
    [43578125] = {quest=54881, vignette=3518},
    [61761934] = {quest=54908, vignette=3529},
    [49881814] = {quest=54909, vignette=3530},
    [40804337] = {quest=54910, vignette=3531}, -- 54879
    [41324820] = {quest=54911, vignette=3532}, -- 54880
    [39576230] = {quest=54912, vignette=3533},
}, {
    art=1176,
    label="Darkshore Cache",
    minimap=false,
})
