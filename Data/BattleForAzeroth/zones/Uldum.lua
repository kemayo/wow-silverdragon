local myname, ns = ...

-- Friendly Alpaca
ns.RegisterPoints(1527, {
    [15006200] = {},
    [24000900] = {},
    [28004900] = {},
    [30002900] = {},
    [39001000] = {},
    [42007000] = {},
    [46004800] = {},
    [53001900] = {},
    [55006900] = {},
    [63005300] = {},
    [63001400] = {},
    [70003900] = {},
    [76006800] = {},
}, {
    label="{npc:162765}", -- Friendly Alpaca
    quest=58879,
    loot={{174859,mount=1329}},
    note="Feed it {item:174858:Gersahl Greens} for 7 days; find them by the rivers",
    atlas="stablemaster", scale=1.2,
    progress=function()
        -- it's a different quest for the progress than for the overall completion...
        return select(4, GetQuestObjectiveInfo(58881, 0, false))
    end,
})

local NZOTH = ns.conditions.WorldQuestActive(57157)
local AMATHET = ns.conditions.WorldQuestActive(55350)
local AQIR = ns.conditions.WorldQuestActive(56308)

-- these come up a lot...
local aqirWeapons = {
    174222, -- Unspeakable Bloodletter (dagger)
    174224, -- Greatsword of Cruelty (2h sword)
    174227, -- Writhing Feeler (dagger)
}

-- N'Zoth Assault
ns.RegisterPoints(1527, { -- Uldum
    [46407320] = { label="Falconer Amenophis",
        quest=57662, npc=158491,
        -- routes={{44407820,46407320,51806880}},
    },
    [47407720] = {quest=57664, npc=158528,}, -- High Guard Reshef
    [49208260] = {quest=57688, npc=158636, loot={{169303, toy=true}}, note="Up on the floating platform"}, -- The Grand Executor
    [49403840] = {quest=57672, npc=158594,}, -- Doomsayer Vathiris
    [57403740] = {quest=58333, npc=161033,}, -- Shadowmaw
    [53205020] = {quest=57680, npc=158633, loot={175142, {175140, toy=true}}}, -- Gaze of N'Zoth
    [54604300] = {quest=57675, npc=158597,}, -- High Executor Yothrim
    [58408220] = {quest=57432, npc=156654,}, -- Shol'thoss the Doomspeaker
    [59203940] = {quest=58206, npc=160623,}, -- Hungering Miasma
    -- [60003940] = {quest=58206, npc=160631,}, -- Hungering Miasma
    [59404940] = {quest=57673, npc=158595,}, -- Thoughtstealer Vos
    [59807240] = {quest=58330, npc=157593, loot={{174478, pet=2851}}, note="Complete the {quest:57429} event"}, -- Amalgamation of Flesh
    [66407380] = {quest=57669, npc=158557,}, -- Actiss the Deceiver
    [70407440] = {quest=57433, npc=156655,}, -- Korzaran the Slaughterer
    -- [50208180,50807320] = {quest=57665, npc=158531,}, -- Corrupted Neferset Guard
}, {
    requires=NZOTH,
})
ns.RegisterPoints(1527, { -- Uldum
    -- Summoning rituals:
    [50007860] = {},
    [50408800] = {},
    [55207940] = {},
    -- [] = {quest=57434, npc=157390,}, -- R'oyolok the Reality Eater
    -- [] = {quest=57435, npc=157469,}, -- Zoth'rum the Intellect Pillager
    -- [] = {quest=57436, npc=157470,}, -- R'aas the Anima Devourer
    -- [] = {quest=57437, npc=157472,}, -- Aphrom the Guise of Madness
    -- [] = {quest=57438, npc=157473, loot={{174874, toy=true}}}, -- Yiphrim the Will Ravager
    -- [] = {quest=57439, npc=157476,}, -- Shugshul the Flesh Gorger
}, {
    requires=NZOTH,
    label="Summoning Ritual",
    quest={57434,57435,57436,57437,57438,57439,},
    loot={{174874,toy=true}},
    atlas="VignetteKillElite", scale=1.2,
    note="Complete the summoning ritual for a chance at one of six rares spawning:\n"..
        "* {npc:157390} ({quest:57434})\n"..
        "* {npc:157469} ({quest:57435})\n"..
        "* {npc:157470} ({quest:57436})\n"..
        "* {npc:157472} ({quest:57437})\n"..
        "* {npc:157473} ({quest:57438}) !toy!\n"..
        "* {npc:157476} ({quest:57439})\n",
})


-- Amathet Assault
ns.RegisterPoints(1527, { -- Uldum
    [61402580] = {quest=55684, npc=152677,}, -- Nebet the Ascended
    [64402540] = {quest=57281, npc=157170,}, -- Acolyte Taspu
    [64403660] = {quest=55682, npc=152657,}, -- Tat the Bonechewer
    [65005140] = {quest=55710, npc=152757,}, -- Atekhramun
    [66401820] = {quest=57277, npc=157157,}, -- Muminah the Incandescent
    [67406340] = {quest=55716, npc=152788,}, -- Uat-ka the Sun's Wrath
    [68003140] = {quest=57273, npc=157146, loot={{174753, mount=1317}}}, -- Rotfeaster
    [73805180] = {quest=55468, npc=151883,}, -- Anaua
    [69604140] = {quest=55518, npc=152040,}, -- Scoutmaster Moswen
    [73406420] = {quest=55496, npc=151948,}, -- Senbu the Pridefather
    [73407440] = {quest=55353, npc=151609,}, -- Sun Prophet Epaphos
    [77205020] = {quest=55629, npc=152431,}, -- Kaneb-ti
    [77404600] = {quest=55502, npc=151995,}, -- Hik-ten the Taskmaster
    [77405220] = {quest=55461, npc=151852,}, -- Watcher Rehu
    [79006340] = {quest=58613, npc=151878,}, -- Sun King Nahkotep
    [80005720] = {quest=57279, npc=157164,}, -- Zealot Tekem
    [83404760] = {quest=57285, npc=157188,}, -- The Tomb Widow
    [84405700] = {quest=55479, npc=151897,}, -- Sun Priestess Nubitt
}, {
    requires=AMATHET,
})

-- Aqir Assault
ns.RegisterPoints(1527, { -- Uldum
    [22006160] = {quest=56823, npc=155531, loot=aqirWeapons, note="Kill {npc:154369} to spawn",}, -- Infested Wastewander Captain
    [21256105] = {quest=58697, npc=162140, loot=tAppendAll({{174476,pet=2848}}, aqirWeapons),}, -- Skikx'traz
    [28601420] = { label="R'krox the Runt",
        quest=58864, npc=162173,
        loot=aqirWeapons,
        -- routes={{30603200, 30202760, 28601420, 25400900, 30800940, 33801100, 37801000}},
    },
    [30006500] = {quest=56952, npc=156078, loot=aqirWeapons,}, -- Magus Rehleth
    [30404940] = {quest=58696, npc=162147, loot=tAppendAll({{174769,mount=1319}}, aqirWeapons),}, -- Corpse Eater
    [33402580] = {quest=58702, npc=162170, loot=aqirWeapons,}, -- Warcaster Xeshro
    [34401840] = {quest=56340, npc=154604, loot=tAppendAll({{174475,pet=2847}}, aqirWeapons),}, -- Lord Aj'qirai
    [37205940] = {quest=58693, npc=162142, loot=aqirWeapons,}, -- Qho
    [40404300] = {quest=58695, npc=162141, loot=aqirWeapons,}, -- Zuythiz
    [45805940] = {quest=58701, npc=162163, loot=aqirWeapons,}, -- High Priest Ytaessis
    [45405780] = {quest=58699, npc=162171, loot=aqirWeapons,}, -- Captain Dunewalker
    -- Kill enough of related mobs all over the place...
    -- [] = {quest=58612, npc=154578,}, -- Aqir Flayer
    -- [] = {quest=58614, npc=154576,}, -- Aqir Titanus
    -- [] = {quest=58694, npc=162172,}, -- Aqir Warcaster
}, {
    requires=AQIR,
})

-- multi-assault:
ns.RegisterPoints(1527, {
    [43804140] = {quest=58718, npc=162370, }, -- Armagedillo
    [50004000] = {quest=58716, npc=162352, note="In cave", path=52044011}, -- Spirit of Dark Ritualist Zakahn
    [74806820] = {quest=57258, npc=157120, }, -- Fangtaker Orsa
    [75205140] = {quest=57280, npc=157167, }, -- Champion Sen-mat
    [58006160] = {quest=58715, npc=162372, }, -- Spirit of Cyrus the Black
    [58008240] = {quest=58715, npc=162372, }, -- Spirit of Cyrus the Black
    [66406800] = {quest=58715, npc=162372, }, -- Spirit of Cyrus the Black
    [70807460] = {quest=58715, npc=162372, }, -- Spirit of Cyrus the Black
}, {requires={AMATHET, AQIR, any=true}})
ns.RegisterPoints(1527, {
    [60607300] = {quest=58169, npc=160532, requires={NZOTH, AQIR, any=true},}, -- Shoth the Darkened
    [58006000] = { label="R'khuzj the Unfathomable",
        quest=57430, npc=156299,
        loot=aqirWeapons,
        requires={NZOTH, AQIR, any=true},
        -- routes={{50205080,56405240,58006000,58406640,57407820}},
    },
})

-- Any assault
ns.RegisterPoints(1527, { -- Uldum
    [32406440] = {quest=56834, npc=155703, loot=aqirWeapons,}, -- Anq'uri the Titanic
    [35001740] = {quest=58681, npc=162196, loot=aqirWeapons,}, -- Obsidian Annihilator
    [73808340] = {quest=57259, npc=157134, loot={{174641, mount=1314}}}, -- Ishak of the Four Winds
    -- [] = {quest=58691, npc=162254,}, -- Corrupted Observer
    -- [] = {quest=58691, npc=158632,}, -- Corrupted Fleshbeast
    [45401620] = { label="Vuk'laz the Earthbreaker",
        quest=58510,
        worldquest=55466,
        npc=160970,
        loot={
            174237, -- Breeches of Faithful Execution
            174247, -- Grotesque Mutilator's Leggings
            174250, -- Psyche Tormentor's Visage
            174258, -- Greathelm of Indiscriminate Brutality
            174469, -- Band of Insidious Ruminations
        },
        requires={AMATHET, AQIR, any=true},
    },
})
