local myname, ns = ...

-- talk to Tanmar: 85103
-- talk to Didi: 85157

-- A Choir of Citrines 41050:
-- [] = {criteria=70827, quest=85674}, -- Storm Sewer's Citrine
-- [] = {criteria=70825, quest=85673}, -- Old Salt's Bardic Citrine
-- [] = {criteria=70826, quest=85672}, -- Mariner's Hallowed Citrine
-- [] = {criteria=70828, quest=85707}, -- Legendary Skipper's Citrine
-- [] = {criteria=70829, quest=85708}, -- Seabed Leviathan's Citrine
-- [] = {criteria=70830, quest=85709}, -- Roaring War-Queen's Citrine
-- [] = {criteria=70831, quest=85676}, -- Stormbringer's Runed Citrine
-- [] = {criteria=70832, quest=85677}, -- Fathomdweller's Runed Citrine
-- [] = {criteria=70834, quest=85675}, -- Windsinger's Runed Citrine
-- [] = {criteria=70835, quest=85669}, -- Thunderlord's Crackling Citrine
-- [] = {criteria=70836, quest=85670}, -- Undersea Overseer's Citrine
-- [] = {criteria=70837, quest=85671}, -- Squall Sailor's Citrine

-- starving snapdragon runt daily: 86566
-- (+86482 A Lifeline, 86486 Hungry Hungry Snapdragon, )

local TEMPEST = ns.conditions.AuraActive(458069) -- Seafury Tempest
local CALM = ns.conditions.AuraInactive(458069) -- Seafury Tempest

-- Treasures

--[[
-- quest: 86714?
ns.RegisterPoints(ns.SIRENISLE, {
    [67567351] = {}, -- amethyst
}, {
    quest=86171, -- 85714 unlock
    vignette=6684,
    label="Rune-Sealed Coffer",
})
--]]

ns.RegisterPoints(ns.SIRENISLE, {
    -- Quests for most of these are IsQuestFlaggedCompletedOnAccount but not
    -- on later characters, *but* they're not present anyway.
    [74025331] = {
        found=ns.conditions.QuestCompleteOnAccount(86765),
        loot={233910}, -- Salt-Stained Sweatcap
        vignette=6747,
    },
    [41684585] = {
        found=ns.conditions.QuestCompleteOnAccount(86766),
        loot={233916}, -- Ashvane-Issued Workboots
        vignette=6740,
    },
    [40284185] = {
        found=ns.conditions.QuestCompleteOnAccount(86764),
        loot={233957}, -- Kul Tiran Lumberer's Hatchet
        vignette=6741,
    },
    [39405328] = {
        found=ns.conditions.QuestCompleteOnAccount(86767),
        loot={233831}, -- Minnow's Favorite Blade
        note="Stuck in the rafters; jump from the upstairs",
        vignette=6743,
    },
    [68439433] = {
        found=ns.conditions.QuestCompleteOnAccount(84527), -- actually account?
        label="Pilfered Earthen Chest",
        loot={229181}, -- Ordained Forge Maul
        vignette=6685,
        note="Naga phase only",
    },
    [36925309] = {
        found=ns.conditions.QuestCompleteOnAccount(87446),
        label="Iron Mining Pick",
        loot={233955}, -- Iron Mining Pick,
        vignette=6742,
        note="Inside the Shuddering Hollow",
    },
    [62449081] = {
        quest=84529, -- 84873
        label="Bilge Rat Supply Chest",
        loot={},
        vignette=6683,
        related={[61146889]={label="{npc:228582:First Mate Shellshock}",loot={228621}},},
        note="Get the {item:228621:Bilge Rat Supply Key} from {npc:228582:First Mate Shellshock}",
    },
})

ns.RegisterPoints(ns.FORGOTTENVAULT, {
    [26462297] = {
        quest=86732,
        loot={233834}, -- Stone Carver's Scramseax
        note="First get {spell:1215470:Glittering Vault Shard} from the other vault, and rush back here",
        vignette=6739,
        related={[32147952]={label="{spell:1215470:Glittering Vault Shard}"}},
    },
})

ns.RegisterPoints(ns.SIRENISLE, {
    [52583865] = {quest=86435, note="In cave, in ghost's hands", path=50024270},
    [38195188] = {quest=86436, note="In {npc:235134:Dirt Pile}"},
    [67237882] = {quest=86437, note="In cave"},
}, {
    label="{npc:234934:Runic Fragment}",
    loot={234327}, -- Turbulent Fragment
    atlas="reagents",
    minimap=true,
    requires=TEMPEST,
})

--[[
ns.RegisterPoints(ns.SIRENISLE, {
    [37723869] = {},
    [52043265] = {},
    [59692058] = {},
    [44216377] = {note="Up on the ledge"},
    [45056264] = {}, -- tempest
    [52054102] = {}, -- tempest
    [49297264] = {}, -- tempest
    [42174741] = {}, -- tempest
}, {
    label="Runed Storm Cache",
})
ns.RegisterPoints(ns.FORGOTTENVAULT, {
    [64165059] = {}, -- tempest
    [31702778] = {}, -- tempest
}, {
    label="Runed Storm Cache",
})
ns.RegisterPoints(ns.SIRENISLE, {
    [71101984] = {}, -- 84842, earthen landlubber's breastplate 229037
    [63200920] = {},
    -- somewhere above ~77500000, 85956, cursed pirate skull 231116
    [81440172] = {},
    [53060069] = {},
    [76642024] = {},
    [77772623] = {},
    [64722409] = {},
}, {
    label="Seafarer's Cache",
    loot={},
    vignette=6659,
})
--]]

-- Rares

-- 44.49 22.70 = Forgotten Vault Entrance

ns.RegisterPoints(ns.SIRENISLE, {
    -- Always
    [35791339] = { label="Grimgull",
        criteria=70797,
        quest=84796,
        npc=228155,
        loot={
            229040, -- Earthen Landlubber's Helm
        },
        vignette=6529,
    },
    [53323381] = { label="Ghostmaker",
        criteria=70796,
        quest=84801,
        npc=228601,
        loot={
            231118, -- Runecaster's Stormbound Rune
        },
        vignette=6531,
    },
    [67222763] = { label="Snacker",
        criteria=70799,
        quest=86933,
        npc=231090,
        vignette=6607,
    },
    [46847808] = { label="Wreckwater",
        criteria=70800,
        quest=84794,
        npc=228151,
        vignette=6526,
    },
    [31757154] = { label="Bloodbrine",
        criteria=70794,
        quest=84795, -- 84875
        npc=228154,
        vignette=6530,
    },
    -- Project quests
    [37105499] = { label="Stalagnarok",
        criteria=70793,
        quest=85437,
        npc=229992,
        loot={
            229037, -- Earthen Landlubber's Breastplate
            229051, -- Scurvy Sailor's Ring
            231118, -- Runecaster's Stormbound Rune
        },
        vignette=6610,
        path=44195630,
    },
    [26236548] = { label="Nerathor",
        criteria=70791,
        quest=85938, -- also 85760 (drowned lair); second time 84845 + 85762 (drowned lair)
        npc=229982,
        loot={
            231118, -- Runecaster's Stormbound Rune
        },
        vignette=6754,
        path=32456476,
    },
    [55206840] = { label="Gravesludge (The Drain)",
        criteria=70792,
        quest=85937, -- 84753 the drain
        npc=228201,
        loot={
            229052, -- Moneyed Mariner's Pendant
            231118, -- Runecaster's Stormbound Rune
        },
        vignette=6517,
        path=62607519,
    },
    -- Storm
    [32327408] = { label="Ikir the Flotsurge",
        criteria=70805,
        quest=84792, -- 84847
        npc=227545,
        loot={
            231117, -- Darktide Wavebender's Orb
            231118, -- Runecaster's Stormbound Rune
        },
        vignette=6525,
    },
    -- Vrykul phase
    [63938735] = { label="Asbjorn the Bloodsoaked",
        criteria=70806,
        quest=84805, -- 84839 first time?
        npc=230137,
        loot={
            234972, -- Bloodwake Missive
        },
        vignette=6590,
    },
    -- Naga phase
    [61708967] = { label="Coralweaver Calliso",
        criteria=70801,
        quest=84802,
        npc=229852,
        vignette=6581,
    },
    [55808381] = { label="Siris the Sea Scorpion",
        criteria=70802,
        quest=84803,
        npc=229853,
        vignette=6582,
    },
    -- Pirate phase
    [66128506] = { label="Chef Chum Platter",
        criteria=70803,
        quest=84800,
        npc=228583,
        loot={
            {166358, pet=true}, -- Proper Parrot
        },
        vignette=6580,
    },
    [60568904] = { label="Plank-Master Bluebelly",
        criteria=70804,
        quest=84799,
        npc=228580,
        loot={
            {166358, pet=true}, -- Proper Parrot
        },
        vignette=6577,
    },
}, {
    achievement=41046, -- Clean Up On Isle Siren
    requires=CALM,
})

ns.RegisterPoints(ns.SIRENISLE, {
    [33017365] = { label="Zek'ul the Shipbreaker",
        quest=84840, -- 85405
        npc=231357, -- also 236083
        loot={
            232569, -- Cyclonic Runekey
            234328, -- Torrential Fragment
        },
        vignette=6617,
        requires=TEMPEST,
    },
    [42416488] = { label="Tempest Talon",
        quest=85403,
        npc=231353,
        vignette=6615,
        loot={
            234328, -- Torrential Fragment
        },
        requires=TEMPEST,
    },
    [32818762] = { label="Slaughtershell",
        additional={55375857, 35781966, 42297258},
        quest=84798,
        npc=228547,
        loot={
            234328, -- Torrential Fragment
        },
        vignette=6524,
        requires=TEMPEST,
    },
    [55988410] = { label="Brinebough",
        quest=85404,
        npc=231356,
        vignette=6616,
        loot={
            234328, -- Torrential Fragment
        },
        requires=TEMPEST,
    },
    --[[
    [0] = { label="Gritstorm",
        quest=nil,
        npc=228150,
        vignette=6528,
    },
    [0] = { label="Nickel Back",
        quest=85407,
        npc=231366,
        vignette=6618,
    },
    [0] = { label="Restless Odek",
        quest=nil,
        npc=229970,
        vignette=6591,
    },
    [0] = { label="Restless Rex",
        quest=nil,
        npc=228202,
    },
    [0] = { label="Stormtouched Restless Death",
        quest=nil,
        npc=231369,
    },
    [0] = { label="[DNT] Test NPC",
        quest=nil,
        npc=230673,
    },
    --]]
})

ns.RegisterPoints(ns.FORGOTTENVAULT, {
    [28342486] = { label="Shardsong",
        criteria=70795,
        quest=86779,
        npc=227550,
        loot={
            {235017,toy=true,}, -- Glittering Vault Shard
        },
        vignette=6666,
    },
    [64805460] = { label="Gunnlod the Sea-Drinker",
        criteria=70798,
        quest=84797,
        npc=228159,
        loot={
            229019, -- Earthen Deckhand's Cape
            229023, -- Earthen Deckhand's Breeches
            229034, -- Earthen Islander's Cinch
            229051, -- Scurvy Sailor's Ring
            229167, -- Earthen Deckhand's Cleaver
            229174, -- Earthen Landlubber's Shield
            229180, -- Earthen Landlubber's Hammer
            231116, -- Cursed Pirate Skull
            231118, -- Runecaster's Stormbound Rune
            {235017,toy=true,}, -- Glittering Vault Shard
        },
        vignette=6527,
    },
}, {
    achievement=41046, -- Clean Up On Isle Siren
    requires=CALM,
})
ns.RegisterPoints(ns.FORGOTTENVAULT, {
    [37987637] = { label="Ksvir the Forgotten",
        quest=85406,
        npc=231368,
        loot={
            232571, -- Whirling Runekey
            {235017,toy=true,}, -- Glittering Vault Shard
        },
        vignette=6619,
        requires=TEMPEST,
    },
})
