local myname, ns = ...

-- quests:
-- 32610 = got a Shan'ze Ritual Stone from a rare mob
-- 32626 = got a Key to the Palace of Lei Shen from a mob drop

ns.RegisterPoints(504, { -- Isle of Thunder
    [44603000] = { label="Al'tabim the All-Seeing",
        criteria=22826,
        npc=70000,
        vignette=169,
    },
    [61494959] = { label="God-Hulk Ramuk",
        criteria=22825,
        npc=69999,
        vignette=168,
    },
    [53805323] = { label="Goda",
        criteria=22824,
        npc=69998,
        vignette=167,
    },
    [48598768] = { label="Haywire Sunreaver Construct",
        criteria=22820,
        npc=50358,
        loot={
            {94124,pet=1178,}, -- Sunreaver Micro-Sentry
        },
        vignette=6142,
    },
    [37738285] = { label="Ku'lai the Skyclaw",
        criteria=22822,
        npc=69996,
        vignette=166,
    },
    [54343551] = { label="Lu-Ban",
        criteria=22828,
        npc=70002,
        vignette=171,
    },
    [63444916] = { label="Molthor",
        -- technically at 59603614, but this is the door
        criteria=22829,
        npc=70003,
        vignette=172,
        note="At the back of the room",
    },
    [35006220] = { label="Mumta",
        criteria=22821,
        npc=69664,
        vignette=162,
    },
    [51307118] = { label="Progenitus",
        criteria=22823,
        npc=69997,
        vignette=165,
    },
}, {
    achievement=8103, -- Champions of Lei Shen
})
ns.RegisterPoints(505, { -- Lightning Vein Mine
    [33802760] = { label="Backbreaker Uru",
        achievement=8103, -- Champions of Lei Shen
        criteria=22827,
        npc=70001,
        vignette=170,
        parent=true,
    },
})
ns.RegisterPoints(506, { -- The Swollen Vault
    [36003250] = { label="Molthor",
        achievement=8103, -- Champions of Lei Shen
        criteria=22829,
        npc=70003,
        vignette=172,
        -- not parent, because we want to have the main map point as the door
    },
})

ns.RegisterPoints(504, { -- Isle of Thunder
    [60503730] = { label="Nalak",
        quest=32518, -- also 33109?
        npc=69099,
        loot={
            {95057,mount=542,}, -- Reins of the Thundering Cobalt Cloud Serpent
            95602, -- Stormtouched Cache
        },
        atlas="VignetteKillElite", scale=1.2,
    },
    [39438159] = { label="Ra'sha",
        npc=70530,
        loot={
            95566, -- Ra'sha's Sacrificial Dagger
        },
        path=40658016,
        vignette=96,
    },
    [30407830] = {
        achievement=8112, -- Blue Response
        texture=ns.atlas_texture("nameplates-icon-elite-silver", {r=0,g=0.5,b=1,a=1,scale=1}),
        note="Run near {npc:69128} to scare them until a blue {npc:70215} spawns. This may take some time.",
    },
    [55203040] = {
        achievement=8115, -- Speed Metal
        atlas="warfronts-basemapicons-alliance-barracks-minimap", scale=1.2,
        note="Kill 10x {npc:69216} in the area to get 10 stacks of {spell:136842}, then kill {npc:69326}",
    },
    [55603860] = {
        achievement=8116, -- You Made Me Bleed My Own Blood
        atlas="warfronts-basemapicons-horde-barracks-minimap", scale=1.2,
        note="Kill {npc:69435} without killing any {npc:69436}",
    },
    [60605400] = {
        achievement=8119, -- Our Powers Combined
        criteria=true,
        atlas="crossedflagswithtimer",
        note="The priests will bless {npc:69336} 30 seconds after they're engaged. To engage without killing them at max level use {item:137663}.",
    },
    [62904080] = {
        achievement=8114, -- Platform Hero
        atlas="ui-squarebuttonbrown-up",
        note="Go inside and stand on platforms for 90 seconds",
    },
    [48873932] = {
        achievement=8120, -- Direhorn in a China Shop
        path={52013663, label="{npc:69193}", atlas="playerpartyblip"},
        atlas="creationcatalyst-32x32", minimap=true,
        note="Kite the {npc:69193} to the {npc:70244} then get it to charge. Don't kill the {npc:69302}. It only charges if you move further away from it.",
    }
})

-- Thunder Plunder
ns.RegisterPoints(504, { -- Isle of Thunder
    [34804750] = {},
    [37906090] = {},
    [28808080] = {},
    [40807470] = {},
    [35006300] = {},
    [39006500] = {},
    [53005300] = {},
    [44206740] = {},
    [37006820] = {},
    [51007400] = {},
    [50707070] = {},
    [38905470] = {},
    [40007400] = {},
}, {
    achievement=8104, -- Thunder Plunder
    label="Trove of the Thunder King",
    note="Random spawn chance, lootable weekly",
    minimap=true,
})

-- These Mogu Have Gotta Go-gu
ns.RegisterPoints(504, { -- Isle of Thunder
    [38705810] = {
        criteria=22837,
        npc=69809, -- Forgemaster Deng
        active=ns.conditions.Item(94233), -- Incantation of Deng
    },
    [38905930] = {
        criteria=22836,
        npc=69800, -- Haquin of the Hundred Spears
        active=ns.conditions.Item(94130), -- Incantation of Haquin
    },
    [38505480] = {
        criteria=22838,
        npc=69961, -- Sparkmaster Vu
        active=ns.conditions.Item(95350), -- Incantation of Vu
    },
}, {
    achievement=8110, -- These Mogu Have Gotta Go-gu
    minimap=true,
    atlas="poi-torghast",
})

-- When in Ihgaluk, Do as the Skumblade Do
ns.RegisterPoints(504, { -- Isle of Thunder
    [51207120] = { label="Kroshik Egg",
        criteria=22832,
        -- npc=69907,
    },
    [51407400] = { label="Baby Kroshik (around this area)",
        criteria=22833,
        -- npc=69908,
    },
    [52008240] = { label="Kroshik Adult (around this area)",
        criteria=22834,
        -- npc=69218,
    },
    [55008780] = { label="Sacrificed Kroshik",
        criteria=22835,
        -- npc=70226,
    },
}, {
    achievement=8108,
    note="/bow to each stage of {npc:69907:Kroshik}; not all up at the same time",
    atlas="nameplates-icon-elite-silver",
    minimap=true,
})

-- It Was Worth Every Ritual Stone
ns.RegisterPoints(504, { -- Isle of Thunder
    -- Spirit
    [30705860] = {npc=69633, criteria=22815, loot={94720},}, -- Kor'dok and Tinzo the Emberkeeper
    [35706380] = {npc=69471, criteria=22814, loot={94707},}, -- Spirit of Warlord Teng
    [55208770] = {npc=69341, criteria=22812, loot={94708},}, -- Echo of Kros
    -- Lightning
    [44506100] = {npc=69339, criteria=23205, loot={94825},}, -- Electromancer Ju'le
    [48002600] = {npc=69749, criteria=22763, loot={94824},}, -- Qi'nor
    [55304790] = {npc=69767, criteria=22817, loot={94826},}, -- Ancient Mogu Guardian
    -- Primal
    [49902070] = {npc=69347, criteria=23206, loot={94823},}, -- Incomplete Drakkari Colossus
    [57907920] = {npc=69396, criteria=22813, loot={94706},}, -- Cera
    [68903930] = {npc=70080, criteria=22759, loot={94709},}, -- Windweaver Akil'amon
}, {
    achievement=8101,
    active=ns.conditions.Item(94221, 3), -- Shan'ze Ritual Stone
    texture=ns.atlas_texture("reagents", {r=1, g=0, b=1}) -- used to be poi-torghast but isn't available in mop classic
})
