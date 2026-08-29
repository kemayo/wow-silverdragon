local myname, ns = ...

-- Zone added in 10.1.0

-- Zaralek Cavern (2133)
ns.RegisterPoints(ns.ZARALEKCAVERN, {
    --[[
    [0] = { label="Lavermix",
        criteria=59201,
        quest=75338,
        npc=203630,
    },
    [0] = { label="Shadowforge Mole Machine",
        criteria=59211,
        quest=75576, -- Grim Guzzler Invasion
        npc=204096,
    },
    [0] = { label="Hadexia",
        criteria=59197,
        quest=75314,
        npc=203611,
    },
    [0] = { label="Kronkapace",
        criteria=59204,
        quest=75342,
        npc=203642,
    },
    --]]
    [56207380] = { label="Alcanon",
        criteria=59188,
        quest=75284, -- 75285
        npc=203515,
        loot={
            {203307,quest=73795,}, -- Winding Slitherdrake: Plated Brow
            205309, -- Loyal Attendant's Gaze
            205318, -- Guardian Golem's Legplates
        },
        vignette=5646,
    },
    [48367509] = { label="Aquifon",
        criteria=59185,
        quest=75270, -- 75271
        npc=203468,
        loot={
            {205154, pet=3548}, -- Aquapo
            205090, -- Zaralek Surveyor's Barrier
            205295, -- Sediment Sifters
            205306, -- Aquiferous Raiment
        },
        vignette=5640,
    },
    [57786911] = { label="Underlight Queen",
        criteria=59191,
        quest=75297, -- 75298
        npc=203593,
        loot={
            {205159, pet=3551}, -- Teardrop Moth
            205302, -- Underlight Headwrap
            205324, -- Moth Queen Mantle
            205325, -- Crystal Wing Shield
        },
        vignette=5646,
    },
    [41518613] = { label="Brullo the Strong (Brulsef the Stronk?)",
        criteria=59202,
        quest=75325, -- 75326
        npc=203621,
        loot={
            -- All actually from the Chest of Massive Gains
            {205114, pet=3533}, -- Brul
            204847, -- Recipe: Rocks on the Rocks
            205320, -- Greatbelt of the Stronk
            205313, -- Brullo's Wristbraces
        },
        vignette=5652,
    },
    [55841899] = { label="Professor Gastrinax",
        criteria=59189,
        quest=75291, -- 75292
        npc=203521,
        loot={
            {203331,quest=73820,}, -- Winding Slitherdrake: Cluster Horns
            205322, -- Algeth'ar Exile's Frock
            205333, -- Obsidian Amulet of Transmutation
        },
        vignette=5644,
    },
    [46103346] = { label="Invoq (Invohq?)",
        criteria=59200,
        quest=75335, -- 75336 (70518 also? probably just a curious djardin rune)
        npc=203627,
        loot={
            {203328,quest=73816,}, -- Winding Slitherdrake: White Horns
            204981, -- Neltharic Wand
            205297, -- Flamewielder's Trousers
            205329, -- Loop of Burning Invocation
            {205796,toy=true,}, -- Molten Lava Pack
        },
        vignette=5654,
    },
    [28875085] = { label="Dinn (Jrumm?)",
        criteria=59206,
        quest=75352, -- 75353
        npc=203646,
        loot={
            {203320,quest=73808,}, -- Winding Slitherdrake: Ears
            205299, -- Rudiment Cuffs
            205304, -- Snareguard Sash
            {205419,toy=true,}, -- Jrumm's Drum
        },
        vignette=5660,
    },
    [36324481] = { label="Flowfy",
        criteria=59207,
        quest=75357, -- 75358
        npc=203660,
        loot={
            {197109,quest=69310,}, -- Highland Drake: Spiked Head
            205303, -- Leggings of Flowing Flame
            205334, -- Flowfy's Smoldering Chain
        },
        vignette=5661,
    },
    [47822342] = { label="Colossian",
        criteria=59212,
        quest=75475, -- 75476
        npc=204093,
        loot={
            {197364,quest=69565,}, -- Renewed Proto-Drake: Short Spiked Crest
            205096, -- Zaralek Surveyor's Shank
            205315, -- Colossian Cuirass
            205330, -- Signet of Colossal Mastery
            205332, -- Fist of the Demolisher
        },
        vignette=5674,
    },
    [39407061] = { label="Viridian King",
        criteria=59210,
        quest=75365, -- 75366
        npc=201029,
        loot={
            {203345,quest=73836,}, -- Winding Slitherdrake: Split Jaw Horns
            205316, -- Crystal Stompers
            205327, -- Shard of the Veridian King
            205336, -- Glowing Veridian Necklace
        },
        vignette=5664,
    },
    [60293933] = { label="Kapraku (Kaprachu?)",
        criteria=59184,
        quest=75268, -- 75269
        npc=203466,
        loot={
            {205341,quest=75743,}, -- Winding Slitherdrake: Heavy Scales
            205310, -- Legguards of Kaprachu
            205319, -- Deepflayer Shoulderguards
            205461, -- Vicious Stoneclaw
            205462, -- Royal Nerubian Capsa
        },
        vignette=5639,
    },
    [42521879] = { label="General Zskorro",
        criteria=59190,
        quest=75295, -- 75296
        npc=203592,
        loot={205321}, -- Brimstone Bracers
        vignette=5645,
    },
    [32445127] = { label="Emberdusk",
        criteria=59209,
        quest=75361, -- 75364
        npc=203664,
        loot={
            {203363,quest=73855,}, -- Winding Slitherdrake: Large Finned Throat
            205293, -- Emberdusk's Embrace
            205335, -- Talisman of the Dusk
        },
        vignette=5663,
    },
    [65435587] = { label="Kob'rok",
        criteria=59183,
        quest=75266, -- 75267
        npc=203462,
        loot={
            {197021, quest=69221}, -- Cliffside Wylderdrake: Spiked Club Tail
            {206021, pet=3545}, -- Kob'rok's Luminescent Scale
            {205152, pet=3546}, -- Skaarn
            {205147, pet=3541}, -- Ridged Shalewing
            205307, -- Kob'rok's Scale Sabatons
        },
        vignette=5638,
    },
    [68734593] = { label="Goopal",
        criteria=59186,
        quest=75273, -- 75274
        npc=203477,
        loot={
            {203309,quest=73797,}, -- Winding Slitherdrake: Long Chin Horn
            205296, -- Goopal's Visage
            205317, -- Crystalpod Gauntlets
        },
        vignette=5641,
    },
    [42176584] = { label="Karokta",
        criteria=59199,
        quest=75333, -- 75334
        npc=203625,
        loot={
            {203358,quest=73850,}, -- Winding Slitherdrake: Small Finned Tail
            {205203, mount=1732}, -- Cobalt Shalewing
            {205147, pet=3541}, -- Ridged Shalewing
            205292, -- Kairoktra's Mane
            205298, -- Belt of Floating Stone
        },
        vignette=5653,
    },
    [53724114] = { label="Klakatak",
        criteria=59198,
        quest=75321, -- 75322
        npc=203618,
        loot={
            205308, -- Clacking Clawguards
            205343, -- Crude Seal of Mak'aru
            205686, -- Clacking Claw
        },
        vignette=5651,
    },
    [36425329] = { label="Skornak",
        criteria=59205,
        quest=75348, -- 75349
        npc=203643,
        loot={
            {203321,quest=73809,}, -- Winding Slitherdrake: Curled Cheek Horn
            205294, -- Sandals of Molten Scorn
            205301, -- Hardened Lava Handwraps
            -- {205463, toy=true}, -- Skornak's Lava Ball
        },
        vignette=5659,
    },
    [53106421] = { label="Spinmarrow",
        criteria=59187,
        quest=75275, -- 75276
        npc=203480,
        loot={
            {203318,quest=73806,}, -- Winding Slitherdrake: Hairy Crest
            205290, -- Greatcloak of Spun Marrow
            205305, -- Zaralek Arachnid Armbands
            205326, -- Crystalweb Chelicera
        },
        path=54796586,
    },
    [37954642] = { label="Subterrax",
        criteria=59208,
        quest=75359, -- 75360
        npc=203662,
        loot={
            {203338,quest=73829,}, -- Winding Slitherdrake: Antler Horns
            205312, -- Subterrax's Stout Waistguard
            205314, -- Greathelm of the Emissary
            205328, -- Earthen Emissasry's Edge
        },
        vignette=5662,
    },
    [41383744] = { label="Magtembo (magmanesha?)",
        criteria=59203,
        quest=75339, -- 75340
        npc=200111,
        loot={
            {203339,quest=73830,}, -- Winding Slitherdrake: Impaler Horns
            205300, -- Magma Waders
            205311, -- Magmascale Pauldrons
        },
        vignette=5656,
    },
}, {
    achievement=17783, -- Adventurer of Zaralek Cavern
})

ns.RegisterPoints(ns.ZARALEKCAVERN, {
    -- [54205180] = { -- Bogg
    --     quest=nil,
    --     npc=201747,
    -- },
    -- [58205580] = { -- Jalgon Stoutburn
    --     quest=nil,
    --     npc=204426,
    --     loot={
    --         205939, -- Iron Titan Key
    --     },
    -- },
    --[[
    [0] = { label="Elusive Magma Cobra",
        quest=nil,
        npc=204831,
    },
    [0] = { label="Elusive Crystalscale Stonecleaver",
        quest=nil,
        npc=204821,
    },
    [0] = { label="Captain Reykal",
        quest=nil,
        npc=203355,
    },
    [0] = { label="Lost Lunker",
        quest=nil,
        npc=205630,
    },
    [0] = { label="Crimson Oldblood",
        quest=nil,
        npc=201054,
    },
    [0] = { label="Rampant Shadowflame",
        quest=nil,
        npc=203698,
    },
    [0] = { label="Banechitter",
        quest=nil,
        npc=203869,
    },
    [0] = { label="Banechitter",
        quest=nil,
        npc=203870,
    },
    [58005600] = { label="Calibrating Scent Matrix",
        quest=nil,
        npc=203606,
    },
    [0] = { label="Dreadswoop",
        quest=nil,
        npc=203868,
    },
    [0] = { label="Escaped Elderwing",
        quest=nil,
        npc=203326,
    },
    [0] = { label="Flamebringer Rageblood",
        quest=nil,
        npc=203703,
    },
    [0] = { label="Happy Child",
        quest=nil,
        npc=203871,
    },
    [0] = { label="Treasure Goblin",
        quest=nil,
        npc=205490,
    },
    [0] = { label="Vinyeti",
        quest=nil,
        npc=202932,
    },
    [0] = { label="Animated Contaminant",
        quest=nil,
        npc=202270,
    },
    [0] = { label="Cavern Flayer Matriarch",
        quest=nil,
        npc=202309,
    },
    [0] = { label="Contaminated Titan Watcher",
        quest=nil,
        npc=203834,
    },
    [0] = { label="Elder Magma Serpent",
        quest=nil,
        npc=203846,
    },
    [0] = { label="Flamebringer Cauterizer",
        quest=nil,
        npc=203707,
    },
    [0] = { label="Flamebringer Elementalist",
        quest=nil,
        npc=203705,
    },
    [0] = { label="Flamebringer Shaman",
        quest=nil,
        npc=203700,
    },
    [0] = { label="Half-bound Rageflame",
        quest=nil,
        npc=203699,
    },
    [0] = { label="Monstrous Magmaclaw Snapper",
        quest=nil,
        npc=202874,
    },
    [0] = { label="Pahi'rys",
        -- in a dig
        quest=nil,
        npc=205540,
        loot={
            205990, -- Fierce Key
        },
    },
    [0] = { label="Response Team Watcher",
        quest=nil,
        npc=202318,
    },
    [0] = { label="Rupturing Earth",
        quest=nil,
        npc=205791,
    },
    --]]
})

ns.RegisterPoints(ns.ZARALEKCAVERN, {
    [36634881] = {criteria=59222, quest=73697, vignette=5534, nearby={36454821, label="Magma Bottle"}}, -- Ancient Zaqali Chest
    [28524794] = {criteria=59220, quest=72986, vignette=5523, note="Equip your {item:15138:Onyxia Scale Cloak} to loot this (really)"}, -- Blazing Shadowflame Chest
    -- [] = {criteria=59225, quest=75232}, -- Bloody Body
    [30054193] = {criteria=59226, quest=73706, vignette=5539, note="On the high ledge"}, -- Charred Egg
    -- [] = {criteria=59224, quest=75187}, -- Chest of the Flights
    [36407426] = { label="Crystal-Encased Chest",
        criteria=59228, quest=74986, -- 75601 for unlock
        loot={205192}, -- Volatile Crystal Shard
        related={
            [37766880] = {label="Purple Crystal",quest=74987,note="On floating rock",minimap=true,},
            [39367326] = {label="Yellow Crystal",quest=75559,note="On floating rock",minimap=true,},
        },
        vignette=5690,
        note="Use two nearby crystals",
    },
    [62705377] = {criteria=59223, quest=75019, vignette=5593, note="Underwater"}, -- Long-Lost Cache
    [43068257] = { label="Old Trunk",
        criteria=59227, quest=74995,
        loot={204810}, -- Drogbar Rocks
        related={
            [42988255] = {label="{npc:204277:Thieving Rock Mouse}", quest=75526, minimap=true,},
            [42148014] = {label="{npc:204277:Thieving Rock Mouse}", quest=75527, hide_before=ns.conditions.QuestComplete(75526), minimap=true,},
            [41728145] = {label="{npc:204277:Thieving Rock Mouse}", quest=75534, hide_before=ns.conditions.QuestComplete(75527), minimap=true,},
            [42758221] = {label="{npc:204277:Thieving Rock Mouse}", quest=75535, hide_before=ns.conditions.QuestComplete(75534), minimap=true,},
            [43728386] = {label="{npc:204277:Thieving Rock Mouse}", hide_before=ns.conditions.QuestComplete(75535), minimap=true,},
        },
        note="Find the {npc:204277:Thieving Rock Mouse} 5x nearby",
    },
    -- [] = {criteria=59221, quest=73410}, -- Seething Cache
    [29764055] = {criteria=59219, quest=73395, vignette=5522, path=30394148, nearby={30124074}, note="Get the key from the bear"}, -- Well-Chewed Chest
}, {
    achievement=17786, -- Treasures of Zaralek Cavern
})

ns.RegisterPoints(ns.ZARALEKCAVERN, {
    [56684936] = {
        label="Moth-Pilfered Pouch",
        quest=75320,
        -- npc=203225, -- Struggling mothling
        loot={205191}, -- Underlight Globe
        note="Stand under {npc:203225:Struggling Mothling} it as it bounces on you",
        vignette=5658, -- 5650 once dropped
    },
    [57956632] = {
        label="Dreamer's Bounty",
        quest=75762,
        loot={205194}, -- Fractured Crystalspine Quill
        note="Get a {npc:201068:Preying Duskmoth} to use {spell:400066:Drowsy Dust} on you, quickly kill it, then open the chest",
        vignette=5712,
    },
    [48451083] = {
        label="Fealty's Reward",
        quest=75514,
        loot={205195}, -- Drakeforged Magma Charm
        note="/kneel by the nearby statue",
        related={
            [43572302] = {label="Statue", note="/kneel", minimap=true,},
        },
    },
    [48421636] = {
        label="Molten Hoard",
        quest=75515,
        loot={205981}, -- Molten Primal Fang
        vignette=5686,
        note="Underground, where the magma is coming from",
        path=48531838,
    },
    [62065534] = { label="Waterlogged Bundle",
        label="Waterlogged Bundle",
        quest=75015, -- 75814? probably one is a barter-brick
        loot={204985}, -- Barter Brick
        note="Underwater",
        vignette=5592,
    },
    [64177497] = {
        label="Nal ks'kol Reliquary",
        quest=75745,
        hide_before=ns.conditions.QuestComplete(72963), -- The Upper Hand
        vignette=5711,
    }
})

local STASH = {
    label="Stolen Stash",
    texture=ns.atlas_texture("VignetteLoot", {r=0.5, g=1, b=0.5, scale=0.9}),
}
ns.RegisterPoints(ns.ZARALEKCAVERN, {
    [60664621] = {quest=75302, vignette=5647},
    [63203710] = {quest=75303, vignette=5648, note="In cave", path=60373727}, -- 63603864?
}, STASH)
ns.RegisterPoints(2184, { -- starting cave
    [63688296] = {quest=75303, vignette=5648},
}, STASH)

local RITUAL = {
    label="Ritual Offerings",
    texture=ns.atlas_texture("VignetteLoot", {r=1, g=0.5, b=0.5, scale=0.9}),
}
ns.RegisterPoints(ns.ZARALEKCAVERN, {
    [38184991] = {quest=73548, vignette=5528, note="In cave"},
    [41934711] = {quest=73548, vignette=5528}, -- verify quest
    [32634418] = {quest=73551, vignette=5529},
    [36034453] = {quest=73551, vignette=5529},
    [30055141] = {quest=73552, vignette=5530}, -- verify quest
    [32015277] = {quest=73552, vignette=5530},
    [32395034] = {quest=73552, vignette=5530}, -- verify quest
    [27344217] = {quest=73553, vignette=5531},
    [28175154] = {quest=73553, vignette=5531}, -- verify quest
    [28264627] = {quest=73553, vignette=5531},
}, RITUAL)

local TRASH = {
    label="Smelly Trash Pile",
    texture=ns.atlas_texture("VignetteLoot", {r=0.5, g=0.5, b=1, scale=0.9}),
    vignette=5714,
    group="junk",
}
ns.RegisterPoints(ns.ZARALEKCAVERN, {
    [29024917] = {},
    [31175207] = {},
    [35754907] = {},
    [37056988] = {},
    [39377663] = {},
    [39438314] = {},
    [40415197] = {},
    [40613568] = {},
    [41634101] = {},
    [42014541] = {},
    [42982468] = {},
    [43552886] = {},
    [44686197] = {},
    [48213766] = {},
    [49641601] = {},
    [51224089] = {},
    [51984729] = {},
    [52957419] = {},
    [55076345] = {},
    [57444585] = {},
    [58557141] = {},
    [58894172] = {},
    [65135290] = {},
}, TRASH)

local HAT = {
    npc=205010, -- Curious Top Hat
    loot={{205021, pet=3521}}, -- Lord Stantley
    note="Use a {item:205686:Clacking Claw} from {npc:203618:Klakatak} to stop it running away",
    texture=ns.atlas_texture("transmog-nav-slot-head", {r=1, g=0.5, b=0.75, scale=1.3}),
    minimap=true,
}
ns.RegisterPoints(ns.ZARALEKCAVERN, {
    [38866432] = {},
    [43967748] = {},
    [51586689] = {},
    [61576953] = {},
    [63205572] = {},
    [60323734] = {note="Inside the cave"}, --  on interior map
}, HAT)
ns.RegisterPoints(2184, { -- starting cave
    [69236586] = {},
}, HAT)
