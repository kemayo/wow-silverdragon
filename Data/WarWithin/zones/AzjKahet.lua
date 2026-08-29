local myname, ns = ...

--[[
Notes:

Anub'azal's pheromones (siegehold): spellid 430649, questid 81628
Weaver's Azj-Kahet Pheromones (burrows): spellid 434977, questid 81625
Nizrek's Azj-Kahet Pheromones (umbral bazar, skeins, burrows): spellid 434980, questid 81623
]]

local addThreadsRep = function(amount, quest, loot, append)
    local extra = quest and {quest=quest}
    table.insert(loot, append and #loot+1 or 1, ns.rewards.Currency(ns.CURRENCY_SEVERED_WEAVER, amount, extra))
    table.insert(loot, append and #loot+1 or 2, ns.rewards.Currency(ns.CURRENCY_SEVERED_GENERAL, amount, extra))
    table.insert(loot, append and #loot+1 or 3, ns.rewards.Currency(ns.CURRENCY_SEVERED_VIZIER, amount, extra))
    return loot
end

-- Treasures

ns.RegisterPoints(ns.AZJKAHET, {
    [34076105] = { label="Concealed Contraband",
        criteria=70381,
        quest=82525,
        loot=addThreadsRep(50, false, {
            220228, -- Quartz Growth
            220237, -- Shining Amethyst Cluster
            220224, -- Iridescent Integument
        }, true),
        level=74,
        path={33846068, 33796026, 34015980, 34365949, 35555918},
        vignette=6288,
    },
    [78623320] = { -- "Weaving Supplies"
        criteria=69643,
        quest=82527,
        loot=addThreadsRep(50, false, {{225347, toy=true}}, true), -- Web-Vandal's Spinning Wheel
        level=74,
        vignette=6289,
        note="Collect {item:223901:Violet Silk Scrap}, {item:223902:Crimson Silk Scrap}, {item:223903:Gold Silk Scrap} from the edges of the nearby platform to unlock",
        nearby={
            74794282, -- Violet Silk Scrap
            72683967, -- Crimson Silk Scrap
            74183772, -- Gold Silk Scrap
        },
    },
    [49564370] = { label="Nest Egg",
        criteria=69645,
        quest=82529,
        loot=addThreadsRep(50, false, {{221760, pet=4513}}, true), -- Bonedrinker
        level=74,
        vignette=6291,
        note="Webbed to the ceiling",
    },
    [67449072] = { label="Disturbed Soil",
        criteria=69646,
        quest=82718,
        loot=addThreadsRep(50, false, {224816}, true), -- Nerubian Almanac
        vignette=6280,
    },
    [38783722] = { label="Missing Scout's Pack",
        criteria=69650,
        quest=82722,
        loot=addThreadsRep(50, false, {
            220222, -- Everburning Lump
            211879, -- Algari Healing Potion
        }, true), -- grays and commendations
        vignette=6283,
    },
    [54525081] = { label="Niffen Stash",
        -- didn't appear until after I hit 73? Could just be a despawn-when-looted though...
        criteria=69649,
        quest=82721,
        loot=addThreadsRep(50, false, {
            204730, -- Grub Grub
            204790, -- Strong Sniffin' Soup for Niffen
            204838, -- Discarded Toy
            204842, -- Red Sparklepretty
            213261, -- Niffen Smell Pouch
        }, true),
        vignette=6282,
        note="Hanging under the bridge",
    },
    [67492754] = { label="Silk-spun Supplies",
        -- Wasn't around for ages; despawn-when-looted?
        criteria=69647,
        quest=82719,
        loot=addThreadsRep(50, false, {
            224828, -- Weavercloth
            224441, -- Weavercloth Bandage
        }, true),
        path={67462755, 66882761, 66692773, 66342805, 66142810, 65582772},
        vignette=6285,
    },
}, {
    achievement=40828,
    levels=true,
})
ns.RegisterPoints(ns.AZJKAHETLOWER, { -- Azj-Kahet Lower
    [62728795] = { label="Memory Cache (confirm lower)",
        criteria=69615,
        quest=82520,
        loot=addThreadsRep(50, false, {{225544, pet=4599}}, true), -- Mind Slurp
        note="Get {spell:420847:Unseeming Shift} from a nearby Extractor Storage, then kill {npc:223908:Corrupted Memory} here for a {item:223870:Cache Key}",
        vignette=6287,
    },
}, {
    achievement=40828,
    levels=true,
})
ns.RegisterPoints(ns.CITYOFTHREADS, {
    [67397441] = { label="Trapped Trove",
        criteria=69644,
        quest=82727,
        loot=addThreadsRep(50, false, {{222966, pet=4473}}, true), -- Spinner
        level=74,
        vignette=6290,
        note="In the hanging building; navigate through the web traps",
    },
    [31642077] = { label="Nerubian Offerings",
        criteria=69648,
        quest=82720,
        loot=addThreadsRep(50, false, {
            225543, -- Bloodied Idol
            220236, -- Sanguineous Sac
            223899, -- Shadowed Appendage
        }, true),
        vignette=6281,
        note="In a nook beneath the platform",
    },
}, {
    achievement=40828,
    parent=true, levels=true, translate={[2256]=true},
})

-- Itsy Bitsy Spider
ns.RegisterPoints(ns.AZJKAHET, {
    -- [] = {criteria=68972,}, -- Webster (227217)
    [55654395] = {criteria=68973,}, -- Spindle (216213) (this coord isn't giving me completion... 44255678 did as 216217, but it's temporary while Spindle's a questgiver there)
    -- [] = {criteria=68974,}, -- Swift (226133 or 220666)
    -- [] = {criteria=68976,}, -- Ru'murh (...14 different npc ids)
    -- [] = {criteria=68977,}, -- Thimble (220568)
    -- [] = {criteria=68978,}, -- Scampering Weave-Rat (217468)
    -- [] = {criteria=68979,}, -- General's Scouting Shadecaster (220665)
}, {
    achievement=40624,
    atlas="WildBattlePet", color={r=0.75, g=1, b=0},
    minimap=true,
    levels=true,
    note=EMOTE102_CMD1,
})

-- Smelling History
local SMELL = {
    achievement=40542,
    texture=ns.atlas_texture("profession", {r=0, g=1, b=1}),
    minimap=true,
    levels=true,
    active=ns.conditions.AuraActive(456122), -- Polymorphic Translation: Nerubian
    note="Drink {item:225784:Potion of Polymorphic Translation Nerubian} first",
}
ns.RegisterPoints(ns.AZJKAHET, {
    [62973119] = {criteria=68971,}, -- Ethos of War, Part 1
    [66693128] = {criteria=68980,}, -- Ethos of War, Part 2
    [48862399] = {criteria=68981, note="Inside the building"}, -- Ethos of War, Part 3
    [43252557] = {criteria=68982, note="Inside the building"}, -- Ethos of War, Part 4
}, SMELL)
ns.RegisterPoints(ns.CITYOFTHREADS, {
    [27695460] = {criteria=68818, note="Inside the building"}, -- Strands of Memory
    [38263554] = {criteria=68984, note="Inside Skein of the Dynasty"}, -- Queen Xekatha
    [37113274] = {criteria=68985, note="Inside Skein of the Dynasty"}, -- Queen Anub'izek
    [38413225] = {criteria=68986, note="Inside Skein of the Dynasty"}, -- Queen Zaltra
    [38193902] = {criteria=68987, note="Inside the House of Scrolls, hidden behind the counter"}, -- Treatise on Forms: Sages
    [38553772] = {criteria=68988, note="Inside the House of Scrolls"}, -- Treatise on Forms: Skitterlings
    [23645109] = {criteria=69446, note="Inside the building, enter on the upper level", path=25925136}, -- Treatise on Forms: Lords
    [77984104] = {criteria=69447, note="Inside the building"}, -- Treatise on Forms: Ascended
}, SMELL)

-- Bookworm
ns.RegisterPoints(ns.AZJKAHET, {
    [40103980] = {criteria=68983,}, -- Entomological Essay on Grubs, Volume 1
    [39794050] = {criteria=68989,}, -- Entomological Essay on Grubs, Volume 2
    [39104259] = {criteria=68990,}, -- Entomological Essay on Grubs, Volume 3
}, {
    achievement=40629,
    texture=ns.atlas_texture("profession", {r=1, g=0, b=1}),
    minimap=true,
    levels=true,
    active=ns.conditions.AuraActive(456122), -- Polymorphic Translation: Nerubian
    note="Drink {item:225784:Potion of Polymorphic Translation Nerubian} first",
})

-- No Harm Ever Came From Reading A Book
ns.RegisterPoints(ns.CITYOFTHREADSLOWER, {
    [66775626] = {
        label="{npc:215605:Grimoire}",
        quest=83741,
        note="Read the Fleshy Grimoire.",
    },
    [66775627] = {
        label="{npc:227452:Another You}",
        quest=83724,
        note="Talk to {npc:227452:Another You} again.",
    },
}, {
    note="Find the wall with three tiny spiders on it, climb it, and jump down the hole by the top spider.",
    path={66465579, 66635516, 67235497, 67805521, 68755623, 69305652, 69875672, 71045679, 71715691},
    achievement=40632, achievementNotFound=true,
    texture=ns.atlas_texture("notoriety-32x32", {r=0, g=1, b=1}), minimap=true,
    levels=true, parent=true,
})
ns.RegisterPoints(ns.AZJKAHET, {
    [78046325] = {quest=83746, hide_before=ns.conditions.QuestComplete(83741)}, -- Mmarl
    [60231814] = {quest=83745, hide_before=ns.conditions.QuestComplete(83741)}, -- Faerin's Advance
    [24215274] = {quest=83744, hide_before=ns.conditions.QuestComplete(83741)}, -- Wildcamp Or'lay
    [56564317] = {quest=83747, hide_before=ns.conditions.QuestComplete(83741)}, -- Weaver's Lair
}, {
    achievement=40632, achievementNotFound=true,
    label="{npc:227452:Another You}",
    note="Find {npc:227452:Another You} and tell it to go home. You may need to talk to the flight master nearby before it appears. It'll /whisper you when you're close.",
    texture=ns.atlas_texture("notoriety-32x32", {r=0, g=1, b=1}), minimap=true, levels=true,
})

-- Back to the Wall
-- https://www.wowhead.com/achievement=40620/back-to-the-wall

ns.RegisterPoints(ns.AZJKAHET, {
    [65901335] = {},
    [64951100] = {},
    [65101058] = {},
    [64241006] = {},
    [65080784] = {},
    [64880760] = {},
    [64720438] = {},
    [64740440] = {},
    [61690791] = {},
    [60280928] = {},
    [60270939] = {},
    [62000428] = {},
    [61210398] = {},
    [63060098] = {},
    [63800073] = {},
    [63880010] = {},
    -- [48465780] = {}, -- the wowhead page says this, but I am skeptical
}, {
    achievement=40620,
    note="Requires {quest:81965:Invasion Disruption} or {quest:82414:Special Assignment A Pound of Cure}. Respawns slowly.",
    atlas="poi-soulspiritghost", minimap=true,
})

-- Rares

ns.RegisterPoints(ns.AZJKAHET, {
    [61712962] = { label="Kaheti Silk Hauler",
        criteria=69659,
        quest=81702,
        npc=221327,
        loot=addThreadsRep(50, 84071, {
            221206, -- Reinforced Chitin Chestpiece
            221240, -- Nerubian Stagshell Gouger
            221252, -- Nerubian Slayer's Claymore
            221263, -- Nerubian Venom-Tipped Dart
        }),
        vignette=6134,
        routes={{65201896, 65142033, 63122532, 62492877, 61712962}},
        note="Slowly wanders back and forth",
    },
    [76585780] = { label="XT-Minecrusher 8700",
        criteria=69660,
        quest=81703,
        npc=216034,
        loot=addThreadsRep(50, 84072, {
            221231, -- Steam-Powered Wristwatch
            221232, -- Polished Goblin Bling
        }),
        vignette=6131,
    },
    [45863916] = { label="Abyssal Devourer",
        criteria=69651,
        quest=81695,
        npc=216031,
        loot=addThreadsRep(50, false, {
            223389, -- Legplates of Dark Hunger
            223390, -- Leggings of Dark Hunger
            223391, -- Legguards of Dark Hunger
            223392, -- Trousers of Dark Hunger
        }, true),
        vignette=6129,
    },
    [66536946] = { label="Maddened Siegebomber",
        criteria=69663,
        quest=81706, -- 84075
        npc=216044,
        loot=addThreadsRep(50, 84075, {
            221217, -- Nerubian Bomber's Leggings
            221240, -- Nerubian Stagshell Gouger
            221252, -- Nerubian Slayer's Claymore
            221263, -- Nerubian Venom-Tipped Dart
        }),
        vignette=6138,
        routes={{
            66536946, 66056803, 65616706, 65096620, 64446559, 63706526, 62926513, 62146530,
            61486584, 61396696, 61826791, 62536809, 63166813, 63746786, 64146720, 65386409,
            65706345, 66026301, 66606247, 67206246, 67696278, 68086319, 68356370, 68806483,
            69006550, 69096626, 69076707, 68876785, 68436846, 67866891,
            loop=true,
        }},
        note="Patrols around the area, fighting other mobs",
    },
    [34574106] = { label="Vilewing",
        -- [36004480, 36204400, 36404580, 36604660, 36804320, 36804580, 37004540]
        criteria=69656,
        quest=81700,
        npc=216037,
        loot=addThreadsRep(50, false, {
            223386, -- Vilewing Crown
            223387, -- Vilewing Chain Helm
            223388, -- Vilewing Cap
            223405, -- Vilewing Visor
        }),
        vignette=6132,
    },
    [61242731] = { label="Webspeaker Grik'ik",
        criteria=69655,
        quest=81699,
        npc=216041,
        loot=addThreadsRep(50, false, {
            223369, -- Webspeaker's Spiritual Cloak
        }, true),
        vignette=6135,
    },
    [70732146] = { label="Cha'tak",
        criteria=69661,
        quest=81704, -- 84073
        npc=216042,
        loot=addThreadsRep(50, 84073, {
            221212, -- Death Burrower Handguards
            221237, -- Lamentable Vagrant's Lantern
        }),
        vignette=6136,
        note="Cave behind the waterfall",
    },
    [58056233] = { label="Enduring Gutterface",
        criteria=69664,
        quest=81707, -- 84076
        npc=216045,
        loot=addThreadsRep(50, 84076, {
            221233, -- Deephunter's Bloody Hook
            221234, -- Tidal Pendant
            221243, -- Slippers of Delirium
            221248, -- Deep Terror Carver
            221255, -- Sharpened Scalepiercer
        }),
        vignette=6139,
    },
    [69996920] = { label="Monstrous Lasharoth",
        criteria=69662,
        quest=81705, -- 84074
        npc=216043,
        loot=addThreadsRep(50, 84074, {
            221227, -- Monstrous Fungal Cord
            221250, -- Creeping Lasher Machete
            221253, -- Cultivator's Plant Puncher
            221264, -- Fungarian Mystic's Cluster
            223005, -- String of Fungal Fruits
        }),
        vignette=6137,
    },
    [44803980] = { label="Khak'ik",
        criteria=69653,
        quest=81694,
        npc=216032,
        loot=addThreadsRep(50, false, {
            223378, -- Footguards of the Nerubian Twins
            223406, -- Slippers of the Nerubian Twins
            223407, -- Sabatons of the Nerubian Twins
            223408, -- Treads of the Nerubian Twins
        }, true),
        vignette=6130,
        note="Patrols with {npc:221032:Rhak'ik}",
    },
    --[[ -- with Khak'ik:
    [43763953] = { label="Rhak'ik",
        -- [44803880, 44803980, 45204440]
        criteria=69653,
        quest=81694,
        npc=221032,
        vignette=6130, -- Stronghold Scouts
        note="Patrols with {npc:216032:Khak'ik}",
    },
    --]]
    [37944285] = { label="Ahg'zagall",
        criteria=69654,
        quest=78905,
        npc=214151,
        loot=addThreadsRep(50, false, {
            223375, -- Clattering Chitin Necklace
        }, true),
        vignette=5973,
    },
    [64600352] = { label="Umbraclaw Matra",
        criteria=69668,
        quest=82037,
        npc=216051,
        loot=addThreadsRep(50, 84080, {
            221240, -- Nerubian Stagshell Gouger
            221252, -- Nerubian Slayer's Claymore
            221263, -- Nerubian Venom-Tipped Dart
            223930, -- Monstrous Chain Pincers
        }),
        vignette=6186,
    },
    [61210771] = { label="Kaheti Bladeguard",
        label="{npc:216052:Skirmisher Sa'zryk}",
        criteria=69670,
        quest=82078,
        npc=216052, -- Skirmisher Sa'zryk
        loot=addThreadsRep(50, 84082, {
            223915, -- Nerubian Orator's Stiletto
            223916, -- Nerubian Cutthroat's Reach
            223917, -- Nerubian Covert's Cloak
            223939, -- Esteemed Nerubian's Mantle
        }),
        vignette=6204,
        note="Spawns at the top, teleports to the bottom of the path, walks back to the top, then repeats",
        routes={{62940509, 62430707, 62270757, 61930840, 61740856, 61520848, 61330831, 61210803, 61210771}},
    },
    [64590667] = { label="Deepcrawler Tx'kesh",
        criteria=69669,
        quest=82077,
        npc=222624,
        loot=addThreadsRep(50, 84081, {
            223915, -- Nerubian Orator's Stiletto
            223916, -- Nerubian Cutthroat's Reach
            223917, -- Nerubian Covert's Cloak
            223923, -- Gilded Cryptlord's Sabatons
        }),
        vignette=6203,
    },
}, {
    achievement=40840, -- Adventurer
    levels=true,
})

ns.RegisterPoints(ns.AZJKAHETLOWER, { -- Azj-Kahet Lower
    [65688051] = { label="Harvester Qixt",
        criteria=69667,
        quest=82036, -- 84079
        npc=216050,
        loot=addThreadsRep(50, 84079, {
            223915, -- Nerubian Orator's Stiletto
            223916, -- Nerubian Cutthroat's Reach
            223917, -- Nerubian Covert's Cloak
            223941, -- Nerubian Cultivator's Girdle
        }),
        routes={{
            -- 65318052, 65098306, 64908333, 64898331, 64868391, 64468542, 64478571, 64798646, 64888682,
            -- 64698716, 64478728, 64258727, 63448621, 63618636, 62418558
            62418558, 63228614, 63608652, 64218736, 64618723, 64828700, 64718638, 64458568, 64598484,
            64548512, 65208295, 65238270, 65268127, 65358100, 65688051,
        }},
        vignette=6185,
    },
    [61938973] = { label="The Oozekhan",
        criteria=69666,
        quest=82035,
        npc=216049,
        loot=addThreadsRep(50, 84078, {
            223006, -- Signet of Dark Horizons
            223931, -- Black Blood Cowl
        }),
        vignette=6184,
    },
    [67458318] = { label="Jix'ak the Crazed",
        criteria=69665,
        quest=82034,
        npc=216048,
        loot=addThreadsRep(50, 84077, {
            223915, -- Nerubian Orator's Stiletto
            223916, -- Nerubian Cutthroat's Reach
            223917, -- Nerubian Covert's Cloak
            223950, -- Corruption Sifter's Treads
        }),
        vignette=6183,
    },
}, {
    achievement=40840, -- Adventurer
    levels=true,
})

ns.RegisterPoints(ns.AZJKAHET, {
    [63409500] = { label="The One Left",
        quest=82290,
        npc=216047,
        loot=addThreadsRep(50, 85167, {
            221246, -- Fierce Beast Staff
            221247, -- Cavernous Critter Shooter
            221251, -- Bestial Underground Cleaver
            221265, -- Charm of the Underground Beast
            225998, -- Earthen Adventurer's Cloak
        }),
        path={63489512, 63959536, 64129539, 65349489, 65429466, 65279345},
        vignette=6266,
    },
}, {levels=true})

ns.RegisterPoints(ns.CITYOFTHREADS, {
    [30975607] = { label="Chitin Hulk",
        label="{npc:216038:The Groundskeeper}",
        criteria=69657,
        quest=81634, -- 84069
        npc=216038, -- The Groundskeeper
        loot=addThreadsRep(50, 84069, {
            221214, -- Chitin Chain Headpiece
            221240, -- Nerubian Stagshell Gouger
            221252, -- Nerubian Slayer's Claymore
            221263, -- Nerubian Venom-Tipped Dart
        }),
        vignette=6111,
    },
    [67165840] = { label="Xishorr",
        criteria=69658,
        quest=81701, -- 84070
        npc=216039,
        loot=addThreadsRep(50, 84070, {
            221221, -- Venomous Lurker's Greathelm
            221239, -- Spider Blasting Blunderbuss
            221506, -- Arachnid's Web-Sown Guise
        }),
        vignette=6133,
    },
}, {
    achievement=40840, -- Adventurer
    parent=true, levels=true, translate={[2256]=true},
})

ns.RegisterPoints(ns.AZJKAHET, {
    [62796618] = { label="Tka'ktath",
        quest=82289,
        npc=216046,
        loot=addThreadsRep(50, 85166, {
            ns.rewards.Item(225952, {quest=83627, requires=ns.conditions.Level(80)}), -- Vial of Tka'ktath's Bloo
            -- {224150, mount=2222}, -- Siesbarg
            221240, -- Nerubian Stagshell Gouger
            221252, -- Nerubian Slayer's Claymore
            221263, -- Nerubian Venom-Tipped Dart
        }),
        vignette=6265,
        note="Begins a quest chain leading to the mount {item:224150:Siesbarg}, item won't drop until you're level 80. Seems to spawn shortly after the daily quest reset.",
    },
    [39804100] = { label="Elusive Razormouth Steelhide",
        quest=nil,
        npc=226232,
        requires=ns.conditions.Profession(ns.PROF_WW_SKINNING),
        active=ns.conditions.Item(219007), -- Elusive Creature Lure
    },
}, {levels=true,})
