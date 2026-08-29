local myname, ns = ...

--[[
notes:
Picked any cartel: 84948 (contract work)
Picked bilgewater: 84951
Picked steamwheedle: 84952

Worldsoul memory:
6358 @ 58206866
--]]

-- Quartermasters

ns.RegisterPoints(ns.UNDERMINE, {
    -- Bilgewater
    [38962225] = {
        label="{npc:231406:Rocco Razzboom}",
        loot={
            {236672, quest=85785, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BILGEWATER, "Honored")}, -- The Ol' Low-and-Slow
            {235670, toy=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BILGEWATER, "Honored")}, -- Bilgewater Cartel Banner
            {232845, pet=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BILGEWATER, "Revered")}, -- Bilgewater Junkhauler
            {235807, toy=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BILGEWATER, "Revered")}, -- Storefront-in-a-Box
            {229935, mount=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BILGEWATER, "Exalted")}, -- Crimson Armored Growler
            {231526, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BILGEWATER, "Exalted")}, -- Bilgewater Undermine Tabard
            {235388, quest=86773, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BILGEWATER, "Exalted")}, -- Paint: Redlining Red
        },
        note="{faction:".. ns.FACTION_UNDERMINE_BILGEWATER .."}",
    },
    -- Steamwheedle
    [27217233] = {
        label="{npc:231408:Lab Assistant Laszly}",
        loot={
            {236670, quest=85787, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_STEAMWHEEDLE, "Honored")}, -- Maniacal Melodies
            {235669, toy=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_STEAMWHEEDLE, "Honored")}, -- Steamwheedle Cartel Banner
            {232853, pet=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_STEAMWHEEDLE, "Revered")}, -- Eepy
            {226373, toy=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_STEAMWHEEDLE, "Revered")}, -- Everlasting Noggenfogger Elixir
            {229956, mount=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_STEAMWHEEDLE, "Exalted")}, -- Mean Green Flying Machine
            {231527, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_STEAMWHEEDLE, "Exalted")}, -- Steamwheedle Undermine Tabard
            {235389, quest=86772, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_STEAMWHEEDLE, "Exalted")}, -- Paint: Goblin Green
        },
        path=29136946,
        note="{faction:".. ns.FACTION_UNDERMINE_STEAMWHEEDLE .."}",
    },
    -- Blackwater
    [63351692] = {
        label="{npc:231405:Boatswain Hardee}",
        loot={
            {236671, quest=85786, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BLACKWATER, "Honored")}, -- The Buzzer
            {235671, toy=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BLACKWATER, "Honored")}, -- Blackwater Cartel Banner
            {232839, pet=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BLACKWATER, "Revered")}, -- Wavebreaker Mechasaur
            {235801, toy=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BLACKWATER, "Revered")}, -- Personal Fishing Barge
            {229948, mount=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BLACKWATER, "Exalted")}, -- Blackwater Shredder Deluxe Mk 2
            {231528, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BLACKWATER, "Exalted")}, -- Blackwater Undermine Tabard
            {235390, quest=86771, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_BLACKWATER, "Exalted")}, -- Paint: Body Roll Blue
        },
        note="{faction:".. ns.FACTION_UNDERMINE_BLACKWATER .."}",
    },
    -- Venture Co
    [53127263] = {
        label="{npc:231407:Shredz the Scrapper}",
        loot={
            {236669, quest=85788, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_VENTURE, "Honored")}, -- The Whole Brass Band
            {235672, toy=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_VENTURE, "Honored")}, -- Venture Co. Banner
            {232851, pet=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_VENTURE, "Revered")}, -- Rocketfist
            {235799, toy=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_VENTURE, "Revered")}, -- Throwin' Sawblade
            {229946, mount=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_VENTURE, "Exalted")}, -- Ochre Delivery Rocket
            {231542, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_VENTURE, "Exalted")}, -- Venture Co. Undermine Tabard
            {235391, quest=86774, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_VENTURE, "Exalted")}, -- Paint: Yellow Cake Yellow
        },
        note="{faction:".. ns.FACTION_UNDERMINE_VENTURE .."}",
    },
    -- Darkfuse
    [30603880] = {
        label="{npc:231396:Sitch Lowdown}",
        loot={
            {235558, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_DARKFUSE, "Neutral")}, -- Box of Darkfuse Miscellany
            {237276, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_DARKFUSE, "Neutral")}, -- Refurbished Rocket Glider
            {235532, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_DARKFUSE, "Neutral")}, -- Experimental Goblin-FUEL Supplement
            {229823, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_DARKFUSE, "Friendly")}, -- Canister of Darkfuse Solution
            {235533, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_DARKFUSE, "Friendly")}, -- Prototype Auto-Advertiser
            {234950, toy=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_DARKFUSE, "Honored")}, -- Atomic Regoblinator
            {235534, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_DARKFUSE, "Honored")}, -- Electropuncture Test Model
            {229950, mount=true, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_DARKFUSE, "Revered")}, -- Darkfuse Demolisher
            {231550, requires=ns.conditions.Faction(ns.FACTION_UNDERMINE_DARKFUSE, "Exalted")}, -- Darkfuse Lowdown Coat
        },
        hide_before=ns.conditions.QuestComplete(86961), -- Diversified Investments
        path=29694099, -- sewer entrance
        note="{faction:".. ns.FACTION_UNDERMINE_DARKFUSE .."}",
    },
}, {
    texture=ns.atlas_texture("Banker", {r=0.2, g=1, b=1}), scale=1.2,
    minimap=true,
    note="Quartermaster",
    showallloot=true,
})

-- S.C.R.A.P. Heap cosmetic drops

ns.RegisterVignettes(ns.UNDERMINE, {
    [6757] = {}, -- active
    [6687] = {}, -- starting
}, {
    loot={
        ns.rewards.Achievement(41590), -- Really No Littering
        ns.rewards.Achievement(41591), -- Really No Littering
        ns.rewards.Achievement(41593), -- Cleanin' the Streets
        {229953, mount=true}, -- Salvaged Goblin Gazillionaire's Flying Machine (from Garbage)
        236161, -- Broiler Supreme 300
        236178, -- Gammy's Hand-Me-Down Bow
        236181, -- Center-Stage Remover
        236191, -- Mechanic's Best Motivator
    },
})

-- Treasures

ns.RegisterPoints(ns.UNDERMINE, {
    [48454293] = { label="Unexploded Fireworks",
        criteria=71613,
        quest=85683,
        loot={235042}, -- Imminently Exploding Fireworks
        note="On the roof; there's a door you can click to open",
        vignette=6657,
    },
    [49886618] = { label="Suspicious Book",
        criteria=71624,
        quest=85868,
        loot={235283}, -- Bashful Book
        note="Pick it up three times",
        vignette=6679,
    },
    [57845269] = { label="Fireworks Hat",
        criteria=71614,
        quest=85856, -- first attempt 85838 @ 57845269, second attempt 85839 @ 56015172
        loot={{235220, toy=true}}, -- Fireworks Hat
        note="Pick it up twice",
        vignette=6677,
    },
    [49709027] = { label="Exploded Plunger",
        criteria=71615,
        quest=85698, -- 85694 first press
        loot={235238}, -- Exploded Plunder
        vignette=6658, -- Inert Plunger? / 6672 Exploded Plunger
    },
    [38965963] = { label="Blackened Dice",
        criteria=71625,
        quest=85814, -- 84813 for the valve
        loot={235255}, -- Durable Dice
        vignette=6671,
        note="Use the Pipe Valve",
    },
    [59371914] = { label="Lonely Tub",
        criteria=71626,
        quest=85858, -- 85860 extinguished
        loot={235279}, -- Scorched Shorts
        vignette=6678,
        note="Use the {spell:471345:Fire Extinguisher}",
    },
    [69652164] = { label="Potent Potable",
        criteria=71627,
        quest=85426,
        loot={235230}, -- Impotent Potable
        vignette=6646,
    },
    [40842127] = { label="Abandoned Toolbox",
        criteria=71628,
        quest=85422,
        loot={}, -- assorted engineering items
        vignette=6643,
    },
    [74697984] = { label="Papa's Prized Putter",
        criteria=71629,
        quest=85424,
        loot={234821}, -- Papa's Prized Putter
        vignette=6644,
    },
    [26844266] = { label="Unsupervised Takeout",
        criteria=71630,
        quest=85425,
        loot={
            7341, -- Cubic Zirconia Ring
            233118, -- Incontinental Takeout
        },
        vignette=6645,
    },
    [39386107] = { label="Particularly Nice Lamp",
        criteria=71631,
        quest=85492,
        loot={235221}, -- Particularly Bright Lightbulb
        vignette=6651,
    },
    [53415274] = { label="Uncracked Cold Ones",
        criteria=71632,
        quest=85495,
        loot={{234951, toy=true}}, -- Uncracked Cold Ones
        vignette=6654,
    },
    [63813220] = { label="Marooned Floatmingo",
        criteria=71633,
        quest=85494,
        loot={235273}, -- Distracting Floatmingo
        vignette=6653,
    },
    [43645155] = { label="Trick Deck of Cards",
        criteria=71634,
        quest=85496,
        loot={235268}, -- Misprinted Card
        vignette=6655,
    },
    [42288231] = { label="Crumpled Schematics",
        criteria=71635,
        quest=86487,
        loot={235038}, -- Crumpled Schematic
        vignette=6713,
    },
}, {
    achievement=41217,
})

ns.RegisterPoints(ns.UNDERMINE, {
    [23814539] = {quest=85072, loot={234427}, vignette=6624}, -- Gorillion Fork
    [71458594] = {quest=85114, loot={234430}, vignette=6625}, -- Gorillion Grease
    [75142295] = {quest=85115, loot={234431}, vignette=6626}, -- Gorillion Batteries
    [56675547] = {quest=85116, loot={234432}, vignette=6627}, -- Gorillion Engine
    [34338286] = {quest=85117, loot={234433}, vignette=6628}, -- Gorillion Chasis
}, {
    achievement=40948, -- Nine-Tenths of the Law
    texture=ns.atlas_texture("VignetteLoot", {r=0.5, g=0.5, b=1}),
    note="Unlock the Muff's Auto-Locker",
})

local READ = {
    achievement=41588, -- Read Between the Lines
    texture=ns.atlas_texture("loreobject-32x32"),
}
ns.RegisterPoints(ns.UNDERMINE, {
    [65621421] = {criteria=103112, quest=86568, vignette=6733}, -- Misplaced Work Order
}, READ)
ns.RegisterPoints(ns.UNDERMINE, {
    [27317085] = {criteria=103108, quest=86567, vignette=6732}, -- A Threatening Letter
    [40402851] = {criteria=103106, quest=86572, vignette=6737}, -- First Half of Noggenfogger's Journal
    [32915880] = {criteria=103109, quest=86571, vignette=6736}, -- Second Half of Noggenfogger's Journal
    [58585932] = {criteria=103111, quest=86573, vignette=6738}, -- Gallywix's Notes
}, ns.merge({
    hide_before=ns.conditions.QuestComplete(83130), -- Sour Victory
}, READ))
ns.RegisterPoints(ns.RINGINGDEEPS, {
    [72917314] = {criteria=103107, quest=86570, vignette=6735}, -- Rocket Drill Safety Manual
    [68029650] = {criteria=103110, quest=86569, vignette=6734}, -- Extractor Drill X-78 Safety Guide
}, READ)

ns.RegisterPoints(ns.UNDERMINE, {
    -- there are no tracking quests for this one, sadly
    [43591131] = {note="Beneath the stands"},
    [28485579] = {note="Upper floor under a trash can"},
    [35808557] = {note="On the bannister"},
    [65328859] = {note="In the cave"},
    [65864395] = {note="By a tree"},
}, {
    achievement=41708, -- You're My Friend Now
    texture=ns.atlas_texture("WildBattlePetCapturable", {r=1, g=0.7, b=1}),
    note="Grab the {npc:239248:Grabbable Rat}",
    minimap=true,
})

ns.RegisterPoints(ns.UNDERMINE, {
    [35394141] = {
        label="{npc:236411:Ditty Fuzeboy}",
        loot={
            {232850, toy=true}, -- Blackwater Kegmover
            {232846, toy=true}, -- Steamwheedle Flunkie
            {232849, toy=true}, -- Venture Companyman
            {232840, toy=true}, -- Mechagopher
            {232841, toy=true}, -- Professor Punch
            {232842, toy=true}, -- Crimson Mechasaur
        },
        atlas="banker",
    },
})

ns.RegisterPoints(ns.UNDERMINE, {
    -- Undermine Undershirt
    [63201680] = {
        label="{npc:237412:Pix Xizzix}",
        active=ns.conditions.Item(237129), -- Tarnished Undermine Real
        loot={237130}, -- Undermine Undershirt
        note="Bring the {item:237129:Tarnished Undermine Real} from the sewer @ 33.1 58.2",
        minimap=true,
        routes={{63201680, 33105818, highlightOnly=true}},
    },
    [33105818] = {
        label="Sewer Cheese",
        loot={237130}, -- Undermine Undershirt
        path={33835756, label="Sewer Grate"},
        nearby={33635815},
        minimap=true,
        route=63201680,
        active=false,
        note="Use the cheese, get {spell:1221472:Cheesed To Meet You?}, and talk to the {npc:238661:Hungry Rat} right by you. Take the {item:237129:Tarnished Undermine Real} to {npc:237412:Pix Xizzix} @ 63.2 16.8",
    },

    -- Recipe: Authentic Undermine Clam Chowder
    [38008864] = {
        label="{item:235800:Recipe_ Authentic Undermine Clam Chowder}",
        loot={ns.rewards.Recipe(235800, 1218414)}, -- Recipe: Authentic Undermine Clam Chowder
        atlas="poi-workorders",
        -- TODO: make a condition for knows-a-specific-recipe?
        -- In the interim, hiding this from people who aren't pursuing cooking is probably enough
        requires=ns.conditions.Profession(ns.PROF_WW_COOKING),
        minimap=true,
        note="You have to know {spell:20626:Undermine Clam Chowder} from Classic Cooking to be able to loot this."
    },
})

-- Rares

ns.RegisterPoints(ns.UNDERMINE, {
    [42227600] = { label="Candy Stickemup",
        criteria=71599,
        quest=84927, --v
        npc=231012, -- 238119
        loot={
            --234741, -- Miscellaneous Mechanica
            235304, -- Gutter Rat Mask
            235348, -- Back Alley Shank
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6605,
    },
    [65803340] = { label="Grimewick",
        -- [65803340, 67003160, 67003280, 67003360]
        criteria=71600,
        quest=84928, --v
        npc=231017,
        loot={
            --234741, -- Miscellaneous Mechanica
            235303, -- Seafused Brimstone Band
            235319, -- Tidebomb Chestpiece
            235323, -- Blastshell Bracers
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6606,
    },
    [37074526] = { label="Tally Doublespeak",
        criteria=71593,
        quest=84919,
        npc=230940,
        loot={
            234218, -- Goo-blin Grenade
            --234741, -- Miscellaneous Mechanica
            235320, -- S.1.Z.Z.L.E.S.T.E.P Boots
            235328, -- Boots of the Silver Tongue
            235355, -- Gossi-blin's Baton
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6600,
    },
    [36847814] = { label="V.V. Goosworth",
        criteria=71595,
        quest=84920, --v
        npc=230946,
        loot={
            --234741, -- Miscellaneous Mechanica
            235306, -- Ooze-fused Mantle
            235327, -- Mend-and-Match Shoulderpads
            235347, -- 100% Sharp Glimmerblade
            235329, -- Cowl of Acidic Mire
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6601,
        note="Accompanied by {npc:230947:Slimesby}",
    },
    [37207900] = { label="Slimesby",
        criteria=71594,
        quest=84920, --v for V.V.
        npc=230947,
        loot={},
        vignette=6601, -- V.V.
        note="Accompanies {npc:230946:V.V. Goosworth}",
    },
    [26516830] = { label="Ephemeral Agent Lathyd",
        criteria=71602,
        quest=84877, --v
        npc=230746,
        loot={
            --234741, -- Miscellaneous Mechanica
            235309, -- Gloomshroud Robe
            235350, -- Void-forged Cudgel
            235352, -- Netherflare Wand
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6593,
    },
    [68408060] = { label="Scrapbeak",
        -- [68408060, 69207980, 69408080, 69608080, 69808040]
        criteria=71591,
        quest=84917, --v
        npc=230931,
        loot={
            --234741, -- Miscellaneous Mechanica
            235301, -- Drape of the Dazzling Feather
            235305, -- Golfer's Truestrike Gloves
            235321, -- Feather-Spike Girdle
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6598,
    },
    [46915565] = { label="Nitro",
        criteria=71598,
        quest=84926, --v
        npc=230995,
        loot={
            --234741, -- Miscellaneous Mechanica
            235318, -- Ironfang Plate Legguards
            235324, -- Scavenger's Lost Bind
            235325, -- Rusthide Gloves
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6604,
    },
    [52354107] = { label="Slugger the Smart",
        criteria=71604,
        quest=84895, --v
        npc=230800,
        loot={
            --234741, -- Miscellaneous Mechanica
            235349, -- Shadowfume Club
            235363, -- Suspicious Energy Drink
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6595,
    },
    [58408663] = { label="Chief Foreman Gutso",
        criteria=71605,
        quest=84907, --v
        npc=230828,
        loot={
            --234741, -- Miscellaneous Mechanica
            235311, -- Rocket-Powered Shoulderguards
            235357, -- Bulletscar Barricade
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6596,
    },
    [57207860] = { label="Scrapchewer",
        criteria=71610,
        quest=90491, -- 85778 pre-11.1.5
        worldquest=90491,
        npc=233471,
        loot={
            --234741, -- Miscellaneous Mechanica
            235829, -- Welded Scrap Hood
            235830, -- Unstable Missilecaps
            235831, -- Battery-Powered Longshank
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6667, -- 6752
        note="Talk to {npc:236035:Scrapminer Krazzik} to summon",
    },
    [63354975] = { label="The Junk-Wall",
        criteria=71603,
        quest=84884, --v
        npc=230793,
        loot={
            --234741, -- Miscellaneous Mechanica
            235313, -- Shockproof Helm
            235354, -- Scrapblaster Lance
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6594,
    },
    [60550987] = { label="Flyboy Snooty",
        criteria=71606,
        quest=84911, --v
        npc=230840,
        loot={
            --234741, -- Miscellaneous Mechanica
            235312, -- Snooty's Aviator Bindings
            235316, -- Whirly-Giggle Windwhir Wrap
            235322, -- Junkyard Clawguards
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6597,
    },
    [41334367] = { label="Swigs Farsight",
        criteria=71601,
        quest=85004, --v
        npc=231288,
        loot={
            --234741, -- Miscellaneous Mechanica
            235307, -- Smoketrail Belt
            235314, -- Knightrider's Steelfists
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6609,
    },
    [54045018] = { label="Thwack",
        criteria=71596,
        quest=84921, --v
        npc=230951,
        loot={
            --234741, -- Miscellaneous Mechanica
            235310, -- Flashy Patchwork Trousers
            235317, -- Chestplate of the Ultimatum
            235353, -- Debtsmasher Axe
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6602,
    },
    [42012566] = { label="S.A.L.",
        criteria=71597,
        quest=84922, --v
        npc=230979,
        loot={
            --234741, -- Miscellaneous Mechanica
            235302, -- Shockwave Pendant
            235315, -- Rocketstep Boots
            235356, -- Sapper's Spark Reactor
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6603,
    },
    [39602200] = { label="M.A.G.N.O.",
        criteria=71608,
        quest=90488, -- 86298 pre-11.1.5
        npc=234480,
        loot={
            --234741, -- Miscellaneous Mechanica
            235300, -- Cloak of Mecha Shards
            235318, -- Ironfang Plate Legguards
            235835, -- Braided Wire Wrap
            235836, -- Gas-Powered Chainblade
        },
        vignette=6689,
    },
    [25453654] = { label="Ratspit",
        criteria=71592,
        quest=84918,
        npc=230934, -- accompanied by Grease (230935) and Grime (230936)
        loot={
            --234741, -- Miscellaneous Mechanica
            235308, -- Filthtread Boots
            235326, -- Ratspit's Heirloom Wristwraps
            235359, -- Ratfang Toxin
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6599, -- Court of Rats
    },
    [32027652] = { label="Giovante",
        criteria=71609,
        quest=90489, -- 86307 pre-11.1.5
        npc=234499,
        loot={
            --234741, -- Miscellaneous Mechanica
            235310, -- Flashy Patchwork Trousers
            235320, -- S.1.Z.Z.L.E.S.T.E.P Boots
            235823, -- Scrap-Plated Pants
            235824, -- Flame Sputterer
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6694, -- Noggenfogger Nuisance + 6710
        note="Talk to {npc:234751:Noggenfogger Recall Technician} to summon",
    },
    [61472520] = { label="Voltstrike the Charged",
        criteria=71611,
        quest=90490, -- 85777 pre-11.1.5
        npc=233472,
        loot={
            --234741, -- Miscellaneous Mechanica
            235373, -- Abyssal Volt
            235826, -- Electric Wristrags
            235827, -- Statically Charged Vest
            235828, -- Electrocution Warning
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6668, -- 6753
        note="Talk to {npc:234834:Boatwright Frankle} to summon",
    },
    [40209190] = { label="Darkfuse Precipitant",
        criteria=71612,
        quest=90492, -- 85010 pre-11.1.5
        worldquest=90492,
        npc=231310,
        loot={
            {229955, mount=true,}, -- Darkfuse Spy-Eye
            235467, -- Ominous Oil Residue
            235832, -- Oil-Splattered Cloak
            235833, -- Serrated Slickgrip
            235834, -- Rocketgrip Turboslicer
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        vignette=6613, -- 6614
        note="Talk to {npc:231329:De-Pollution Station X1119} with a {item:229823:Canister of Darkfuse Solution} to summon",
    },
}, {
    achievement=41216,
})

ns.RegisterPoints(ns.UNDERMINE, {
    [90005000] = { label="Gallagio Garbage",
        achievement=41594,
        quest=87007,
        npc=234621,
        loot={
            {229953, mount=true,}, -- Salvaged Goblin Gazillionaire's Flying Machine
            --234741, -- Miscellaneous Mechanica
            235819, -- Lucky Penny Locket
            235820, -- Hole-Punched Doubloon
            235821, -- Pressed-Gold Pantaloons
            235822, -- Coin-Woven Shawl
            235854, -- Gold-Inlaid Jetpack
            235910, -- Mint Condition Gallagio Anniversary Coin
            {232983, quest=85783}, -- Steamboil
            {232984, quest=85784}, -- Handcrank
        },
        notes="Appears after S.C.R.A.P. jobs sometimes",
        vignette=6700,
    },
    --[[
    [0] = { label="Taskmaster Zendu",
        quest=nil,
        npc=235117,
    },
    [0] = { label="Geomancer Keeri",
        quest=nil,
        npc=235116,
    },
    [0] = { label="Roxarix the Caveborer",
        quest=nil,
        npc=235112,
    },
    [0] = { label="Vynnie Samophlangus",
        quest=nil,
        npc=235072,
    },
    [0] = { label="Deep-King Grobrosh",
        quest=nil,
        npc=235113,
    },
    [0] = { label="Drone A",
        quest=nil,
        npc=230839,
    },
    [0] = { label="Mookcenary Captain Freg",
        quest=nil,
        npc=235074,
    },
    [0] = { label="Xal'atath",
        quest=nil,
        npc=236933,
    },
    [0] = { label="Hovering Menace",
        quest=nil,
        npc=236886,
    },
    [0] = { label="Madam Colada",
        quest=nil,
        npc=235073,
    },
    [0] = { label="Peet the Wheedler",
        quest=nil,
        npc=235071,
    },
    -- Unknown (???)
    [42802900] = { label="Treasure Crab",
        quest=nil,
        npc=236892,
    },
    [0] = { label="Drone B",
        quest=nil,
        npc=230842,
    },
    [0] = { label="Giovante",
        quest=nil,
        npc=237791,
    },
    [69004980] = { label="Malfunctioning Pummeler",
        quest=nil,
        npc=236895,
    },
    [0] = { label="Massive Kaja'mental",
        quest=nil,
        npc=235115,
    },
    [0] = { label="Pile of Gold",
        quest=nil,
        npc=234541,
    },
    [0] = { label="Prototype Shredder Unit",
        quest=nil,
        npc=235075,
    },
    [0] = { label="Treasured Goblin",
        quest=nil,
        npc=234529,
    },
    --]]
})
