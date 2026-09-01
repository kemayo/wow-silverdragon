local myname, ns = ...

local path = ns.path

-- Note to self: first Pocopoc costume unlock gets 65531
-- Lovely Regal pocopoc from achievement is 65600
-- wicked pocopoc: 65530 (but not really point-friendly)
-- gravid repose, interior locus arrangement 65330
-- gravid repose, primary locus arrangement 65337
-- gravid repose, secondus locus arrangement 65339
-- gravid repose, tertius locus arrangement 65339
-- gravid repose, quartus locus arrangement 65340
-- gravid repose, quintus locus arrangement 65341
-- gravid repose, ultimus locus arrangement 65342 (also 65457 - all-complete?)
-- gravid repose, camber alcove arrangement 65343 (also 65378)
-- gravid repose, rondure alcove arrangement 65345 (also 65378)
-- gravid repose, fulgore alcove arrangement 65347 47.86 30.46
-- gravid repose, dormant alcove arrangement 65346 51043248
-- 58013 tripped while I was killing Dreadlord Infliltrators after I got loot from one
-- 65539 after Arbiter in the Making -- could be for flight, it's complete on other characters as well

local MOUNT = "|A:StableMaster:15:15|a"
local PET = "|A:WildBattlePetCapturable:15:15|a"

-- Treasures of Zerith Mortis
ns.RegisterPoints(1970, { -- Zereth Mortis
    [61153710] = { label="Architect's Reserve",
        quest=65520,
        active={ns.conditions.GarrisonTalent(1931), ns.conditions.QuestComplete(65427)},
        achievement=15331, criteria=53053,
        -- achievement=15508, criteria=53290, -- Fashion of the First Ones
        loot={
            {187833, quest=65528}, -- Dapper Pocopoc
        },
        note="Unlocked by completing Pilgrim's Grace quests: {quest:64829} from {npc:180630} and {quest:65426} from {npc:181273}",
    },

    [47459525] = { label="Bushel of Progenitor Produce",
        quest=65573,
        achievement=15331, criteria=53071,
        -- achievement=15508, criteria=53286, -- Fashion of the First Ones
        loot={
            {190853, toy=true}, -- Bushel of Mysterious Fruit
            {189451, quest=65524}, -- Chef Pocopoc
        },
        note="Kill a {npc:182368} to the north with {spell:360945} to get {spell:360945} yourself. Kill more to get 5 stacks, then open the door.",
    },

    [56756415] = { label="Crushed Supply Crate",
        quest=65489,
        achievement=15331, criteria=53054,
        note="Get {item:189767} from the pillar above the crate, give to {npc:185151} nearby for a {item:189768}, break the rocks",
    },

    [38253725] = { label="Damaged Jiro Stash",
        quest=64667,
        achievement=15331, criteria=52965,
        loot={
            190637, -- Percussive Maintenance Instrument
        },
    },

    [60001800] = { label="Domination Cache",
        quest=65465,
        achievement=15331, criteria=53018,
        active=ns.conditions.Item(189704),
        loot={
            190638, -- Tormented Mawsteel Greatsword
            189863, -- Spatial Opener
        },
        note="{item:189704:Dominance Key} drops from elites and rares nearby. It can also drop from {npc:184417:Dreadlord Infiltrator} during {quest:65362:Not of the Body} if that's up.",
    },

    [35157020] = { label="Drowned Broker Supplies",
        quest=65523,
        achievement=15331, criteria=53061,
        -- achievement=15508, criteria=53288, -- Fashion of the First Ones
        active=ns.conditions.GarrisonTalent(1932),
        loot={
            {190059, quest=65526}, -- Pirate Pocopoc
        },
        note="Have {npc:181059} use the {npc:185282} nearby",
    },

    [51550990] = { label="Fallen Vault",
        quest=65487,
        achievement=15331, criteria=53016,
        loot={
            189863, -- Spatial Opener
        }
    },

    [49758725] = { label="Filched Artifact",
        quest=65503,
        achievement=15331, criteria=53052,
        loot={
            189863, -- Spatial Opener
        },
        note="Jump up the spheres",
    },

    [67006935] = { label="Forgotten Proto-Vault",
        quest=65178,
        achievement=15331, criteria=52967,
        active={ns.conditions.WorldQuestActive(65089), ns.conditions.Achievement(15514), any=true}, -- WQ or flying
        loot={
            {189469, quest=65393, note=MOUNT}, -- Schematic: Prototype Leaper
        },
        note="Only reachable during the {worldquest:65089} world quest",
    },

    [38957320] = { label="Gnawed Valise",
        quest=65480,
        achievement=15331, criteria=53017,
        loot={
            188054, -- Antecedent Drape (shared, but really high droprate here)
        },
        note="Fly, or try jumping from the top of the Cradle of Nascence. You'll probably need a glider, though.",
    },

    [37157830] = { label="Grateful Boon",
        quest=65545,
        achievement=15331, criteria=53066,
        loot={
            {189478, quest=65401, note=MOUNT}, -- Schematic: Adorned Vombata
        },
        note="Needs flying or movement abilities to reach. Soothe 12 creatures nearby, {npc:185293} will give you the reward",
    },

    [58857705] = { label="Library Vault",
        quest=65173,
        achievement=15331, criteria=52887,
        loot={
            {189447, quest=65360, note=PET}, -- Schematic: Viperid Menace
        },
        hide_before=ns.conditions.GarrisonTalent(1932), -- Dealic Understanding
        note="In cave. Use tablets to find the correct {spell:362062} buff to make the chest appear",
        path=59258145,
    },

    [60603055] = { label="Mawsworn Cache",
        quest=65441,
        achievement=15331, criteria=52969,
        loot={
            {189456, quest=65379, note=MOUNT},-- Schematic: Sundered Zerethsteed
        },
    },

    [34805605] = { label="Offering to the First Ones",
        quest=65537,
        achievement=15331, criteria=53062,
        loot={
            190339, -- Enlightened Offering
        },
    },

    [35254410] = { label="Overgrown Protofruit",
        quest=65536,
        achievement=15331, criteria=53056,
        loot={
            190953, -- Protofruit Flesh
        },
    },

    [60854295] = { label="Pilfered Curio",
        quest=65542,
        achievement=15331, criteria=53064,
        -- achievement=15508, criteria=53294, -- Fashion of the First Ones
        loot={
            {190098, quest=65538}, -- Pepepec
        },
        note="On top of the pillar, you'll need flying",
    },

    [52557145] = { label="Protoflora Harvester",
        quest=65546,
        achievement=15331, criteria=53067,
        loot={
            190952, -- Protoflora Harvester
        },
    },

    [46653095] = { label="Protomineral Extractor",
        quest=65540,
        achievement=15331, criteria=53063,
        active=ns.conditions.QuestComplete(64889), -- Match Made in Zereth Mortis
        loot={
            190942, -- Protomineral Extractor
        },
    },

    [37906520] = { label="Stolen Relic",
        quest=65447,
        achievement=15331, criteria=52970,
        note="Jump up the spheres",
    },

    [34056765] = { label="Stolen Scroll",
        quest=65543,
        achievement=15331, criteria=53065,
        loot={
            189863, -- Spatial Opener
        },
        note="Climb the Slumbering Vault and jump over",
    },

    [58707300] = { label="Submerged Chest",
        quest=64545,
        achievement=15331, criteria=52964,
        -- achievement=15508, criteria=53291, -- Fashion of the First Ones
        loot={
            {190061, quest=65529}, -- Admiral Pocopoc
            189863, -- Spatial Opener
        },
        note="Use the Dangerous Orb of Power to the south then the Forgotten Pump to raise the treasure",
    },
    [59407685] = {
        label="Dangerous Orb of Power",
        quest=64545, achievement=15331, criteria=52964,
        texture=ns.atlas_texture("playerpartyblip", {r=0.7,g=0,b=0,a=1,scale=0.8}),
        minimap=true,
        note="Take north to the Forgotten Pump",
    },

    [52606295] = { label="Symphonic Vault",
        quest=65270,
        achievement=15331, criteria=52968,
        loot={
            189863, -- Spatial Opener
        },
        note="Interact with {npc:183998} to learn the order, then use the {npc:183952}s to play the sounds.\n"..
            "Order is probably: SW, NE, SW, NW, NE.",
    },

    [58704280] = { label="Template Archive",
        quest=65175,
        achievement=15331, criteria=52966,
        -- achievement=15508, criteria=53289, -- Fashion of the First Ones
        loot={
            {190060, quest=65527}, -- Adventurous Pocopoc
        },
        note="Inside the Nexus of Actualization",
    },
})

ns.RegisterPoints(1970, {
    [77555820] = { label="Syntactic Vault",
        quest=65565, -- 65670 is when you unlock it
        achievement=15331, criteria=53068,
        active=ns.conditions.QuestComplete(64844), -- The Pilgrimage Ends (campaign chapter 4)
        loot={
            {190457, toy=true}, -- Protopological Cube
        },
        note="In a cave. Find all six runic syllables before their {spell:367499} buff runs out to unlock the vault.",
    },
})
ns.RegisterPoints(1970, {
    [78065339] = {label="Runic Syllable", note="Under the platform between waterfalls"},
    [76924667] = {label="Runic Syllable"},
    [78214795] = path{label="Path to Runic Syllable",routes={{78214795,80904790,81265045,r=1,g=0,b=1}}},
    [81265045] = {label="Runic Syllable", note="Behind the Sepulcher's North side"},
    [78255917] = path{label="Path to Runic Syllable",routes={{78255917,80005810,80935626,r=1,g=0,b=1}}},
    [80935626] = {label="Runic Syllable", note="Behind the Sepulcher's South side"},
    [77056032] = {label="Runic Syllable"},
    [76995879] = {label="Runic Syllable", note="In a cave"},
    [76315959] = path{label="Cave Entrance",routes={{76315959,76995879,r=1,g=0,b=1}}}, -- also to the vault
}, {
    quest=65565,
    achievement=15331, criteria=53068,
    hide_before=ns.conditions.QuestComplete(64844), -- The Pilgrimage Ends (campaign chapter 4)
    atlas="Rune-09-light",
    minimap=true,
    note="Find all six runic syllables before their {spell:367499} buff runs out to unlock the Syntactic Vault."
})

-- Just the Ovoids...
ns.RegisterPoints(1970, {
    [53557225] = { label="Mistaken Ovoid",
        quest=65522, -- 65524 also trips for when you place the eggs
        achievement=15331, criteria=53060,
        active=ns.conditions.Item(190239, 5),
        loot={
            {189435, quest=65333, note=PET}, -- Schematic: Multichicken
        },
        note="Inside the cave, under the {npc:185280}.",
    },
})
ns.RegisterPoints(1970, {
    -- Lost Ovoids
    -- https://ptr.wowhead.com/object=375411/mistaken-ovoid#comments:id=5299055
    [34316656] = {},
    [33964576] = {note="In a cave."},
    [34204869] = {note="In a cave."},
    [34494976] = {note="In a cave."},
    [35204889] = {note="In a cave."},
    [34676925] = {},
    [35974620] = {},
    [36735967] = {},
    [39345098] = {},
    [41386931] = {},
    [41855715] = {},
    [43228490] = {},
    [44565985] = {},
    [44755183] = {},
    [46686301] = {},
    [48157357] = {},
    [49187153] = {},
    [50807081] = {},
    [52427364] = {},
    [53836486] = {},
    [55207685] = {},
    [55986879] = {},
    [58916831] = {},
    [60847592] = {},
    [61076515] = {},
}, {
    quest={65624, 65522, any=true},
    achievement=15331, criteria=53060,
    label="{item:190239}",
    texture=ns.atlas_texture("playerpartyblip", {r=0.6,g=0.6,b=0.1,a=1,scale=0.8}),
    minimap=true,
    found={ns.conditions.Item(190239, 5), ns.conditions.QuestComplete(65522), any=true},
    group="lostovoid",
    note="Find 5x {item:190239} around the zone and take them to the {npc:185280}. There's a lot of spawn points and they vanish after someone loots them. You're looking for a small brown lump with no sparkles.",
})

local protopear = { -- Ripened Protopear
    quest=65566,
    active=ns.conditions.GarrisonTalent(1931),
    achievement=15331, criteria=53069,
    -- achievement=15508, criteria=53287, -- Fashion of the First Ones
    loot={
        {190058, quest=65525}, -- Peaceful Pocopoc
    },
    note="Bring {spell:367180} from the green clouds to the {npc:185416} inside the Blooming Foundry",
}
ns.RegisterPoints(2027, { -- Blooming Foundry
    [65655025] = protopear,
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    [63717374] = protopear,
})

ns.RegisterPoints(2030, { -- Nexus of Actualization
    [51618820] = { label="Template Archive",
        quest=65175,
        achievement=15331, criteria=52966,
        -- achievement=15508, criteria=53289, -- Fashion of the First Ones
        loot={
            {190060, quest=65527}, -- Adventurous Pocopoc
        },
        routes={{72024882, 63855973}},
        note="Push the orb",
    },
})

local lock = ns.nodeMaker{
    label="{npc:185390}",
    achievement=15331, criteria=53070,
    atlas="warfronts-basemapicons-empty-workshop-minimap",
    minimap=true,
}
ns.RegisterPoints(2066, { -- Catalyst Wards
    [49253440] = { label="Undulating Foliage",
        quest=65572,
        achievement=15331, criteria=53070,
        loot={
            {190926, toy=true}, -- Infested Automa Core
            189863, -- Spatial Opener
        },
        note="Activate the four {npc:185390} to activate the teleporter in the main room.",
    },
    -- TODO: ...per-lock questids?
    [39406900] = lock{quest=65589},
    [60208720] = lock{quest=65590},
    [69755245] = lock{quest=65591},
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    [49657785] = path{quest=65572, achievement=15331, criteria=53070, note="Activate the four {npc:185390} to open the barrier."},
    [50007665] = lock{quest=65592},
})

-- Soulshapes

ns.RegisterPoints(1970, { -- Zereth Mortis
    -- https://ptr.wowhead.com/item=190337/cervid-soul#comments:id=5316385
    [34407130] = {
        quest=65517,
        loot={
            {189989, quest=65517, covenant=Enum.CovenantType.NightFae},
        },
        hide_before={ns.conditions.Covenant(Enum.CovenantType.NightFae), ns.conditions.Achievement(15514)}, -- flying
        note="On top of the floating orb",
    },
    [63306050] = {
        quest=65518,
        label="Lost Comb",
        loot={
            {189990, quest=65518, covenant=Enum.CovenantType.NightFae},
        },
        hide_before={ns.conditions.Covenant(Enum.CovenantType.NightFae), ns.conditions.Achievement(15514)}, -- flying
        note="Glowing blue, on top of a pillar",
    },
}, {
    atlas="sanctumupgrades-nightfae-32x32",
    minimap=true,
    group="soulshape",
})

-- Miscellaneous treasures

ns.RegisterPoints(1970, { -- Zereth Mortis
    [46903950] = {
        quest=65643,
        label="Torn Ethereal Drape",
        loot={
            188054, -- Antecedent Drape (same caveat as the Valise)
        },
        active={ns.conditions.GarrisonTalent(1902),ns.conditions.QuestComplete(65328)}, -- Arbiter in the Making
        notes="Unlock the Fulgore Alcove arrangement @ 47.8 30.4, then use the second teleporter in the Inner Locus to reach this. Activate the orb closest to the center of the room and ride it until it gets close to the treasure.",
        routes={{50553200, 46903950}},
    },
    [42005185] = {
        quest=65183,
        label="Provis Cache",
        active=ns.conditions.Item(188231),
        loot={
            {189710, quest=65474}, -- Pocopoc's Ruby and Platinum Body
        },
        note="Use {item:187908} to get 15x {item:187728}, which will sometimes give you the {item:188231}",
    },
})

ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Prying Eye Discovery
    [34354430] = {},
    [35254370] = {},
    [48006640] = {},
    [51757790] = {},
}, {
    quest=65184,
    label="Prying Eye Discovery",
    -- achievement=15508, criteria=53293, -- Fashion of the First Ones
    active={ns.conditions.Item(188170), ns.conditions.Achievement(15514), any=true}, -- flying or the Portal Play daily item
    note="Multiple spawn points; you need to be on {quest:65142} or have flying unlocked",
    loot={
        {190096, quest=65534}, -- Pocobold
        {189711, quest=65476}, -- Pocopoc's Gold and Ruby Components
    },
})

ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Sandworn Chest
    [60002585] = {},
    [60853785] = {},
    [61401765] = {},
    [63202607] = {},
    [65952695] = {},
}, {
    quest=65611,
    label="Sandworn Chest",
    active=ns.conditions.Item(190197), -- Sandworn Chest Key
    note="Multiple spawn points. Get 5x {item:190198} from nearby mobs to make {item:190197}",
    loot={
        {190734, toy=true}, -- Makaris's Satchel of Mines
        {189713, quest=65478}, -- Pocopoc's Copper and Cobalt Components
        {189714, quest=65479}, -- Pocopoc's Platinum and Emerald Components
    },
})

ns.RegisterPoints(1970, { -- Zereth Mortis
    -- https://www.wowhead.com/object=375363/mawsworn-supply-chest#map
    [45404640] = {},
    [46002430] = {},
    [46702680] = {},
    [46801240] = {},
    [47800140] = {},
    [48104820] = {},
    [48804240] = {},
    [50104460] = {},
    [50705040] = {},
    [50801000] = {},
    [51700820] = {},
    [57602290] = {},
    [58404030] = {},
    [59303150] = {},
    [59901670] = {},
    [60103230] = {},
    [61003050] = {},
    [63002490] = {},
    [63302100] = {},
    [67602960] = {},
}, {
    label="Mawsworn Supply Chest",
    loot={
        {190766, mount=1585}, -- Spectral Mawrat's Tail
    },
    note="Multiple spawn points. Mount is a very low drop rate.",
    texture=ns.atlas_texture("VignetteLoot", {r=0.5,g=1,b=0.5,a=1,scale=0.9}),
    group="mawsworncache",
    vignette=4969,
})

ns.RegisterPoints(1970, { -- Zereth Mortis
    [54294965] = {},
    [41903420] = {},
    [60906940] = {},
    [29404930] = {},
    [66502510] = {},
    [63704120] = {},
    [61301550] = {},
    [69503440] = {},
    [42805290] = {},
    [44507140] = {},
    [53009220] = {},
    [43908430] = {},
    [40306260] = {},
    [54304970] = {},
    [49003050] = {},
    [50800470] = {},
    [61955715] = {},
    [62204623] = {},
    [36254810] = {},
    [34087043] = {},
    [51078289] = {},
}, {
    label="Shrouded Cypher Cache",
    loot={
        {189983, quest=65513, covenant=Enum.CovenantType.NightFae}, -- Gromit Soul
        -- This is also in other chests, but:
        {189707, quest=65471}, -- Pocopoc's Bronze and Gold Body
    },
    active={ns.conditions.AuraActive(361917), ns.conditions.AuraActive(364478)},
    note="You need to be wearing Cypher gear with {spell:364478} and have {spell:361917} active",
    texture=ns.atlas_texture("VignetteLoot", {r=0.5,g=1,b=1,a=1,scale=0.9}),
    minimap=true, -- they'll show as a perceptive pocopoc... but it's easier to find them with this up too
    group="junk",
})

local discarded = {
    label="Discarded Automa Scrap",
    loot={
        {189717, quest=65483}, -- Pocopoc's Shielded Core
        {189718, quest=65484}, -- Pocopoc's Upgraded Core
    },
    texture=ns.atlas_texture("mechagon-projects", {r=0.5, g=0.5, b=1, scale=0.9}),
    group="junk",
}
ns.RegisterPoints(1970, { -- Zereth Mortis
    [39607760] = {},
    [40706990] = {},
    [43608330] = {},
    [51104690] = {},
    [54008860] = {},
    [54804680] = {},
    [57704360] = {},
    [58906090] = {},
    [59905120] = {},
    [62107480] = {},
    [64007220] = {},
    [65804040] = {},
    [67604030] = {},
    [69903420] = {},
}, discarded)
ns.RegisterPoints(2028, { -- Locrian Esper
    [50257618] = {},
    [79087500] = {},
}, discarded)

ns.RegisterPoints(1970, { -- Zereth Mortis
    [44403680] = {
        achievement=15502, -- Sand Sand Everywhere
        criteria=true,
        atlas="storyheader-cheevoicon",
        active=ns.conditions.Item(189863), -- Spatial Opener
        hide_before=ns.conditions.QuestComplete(65346), -- Dormant Alcove Arrangement
        note="In the Dormant Alcove; teleport here from the Inner Locus. Use {item:189863:Spatial Opener} from various treasures to loot the piles of sand. The loot from the Misshapen pile varies based on your class/spec.",
        loot={
            {190374, quest=65499, note="Sparkling"}, -- Gemstone of Prismatic Brilliance (sparkling)
            {188044, quest=65496, note="Shifting"}, -- Discarded Cartel Al Signet (shifting)
            {188045, quest=65494, note="Lumpy"}, -- Salvaged Viperid Band (lumpy)
            {188053, quest=65497, note="Humming"}, -- Abandoned Automa Loop (humming)
            {188055, quest=65495, note="Glinting"}, -- Impossibly Ancient Band (glinting)
            {188106, quest=65496, note="Shifting"}, -- Unfathomable Pendant (shifting)
            -- This one could be a bunch of different trinkets:
            {190389, quest=65498, note="Misshapen"}, -- Broker's Lucky Coin (misshapen)
            {190390, quest=65498, note="Misshapen"}, -- Protector's Diffusion Implement (misshapen)
            {190582, quest=65498, note="Misshapen"}, -- Symbol of the Vombata (misshapen)
            {190597, quest=65498, note="Misshapen"}, -- Symbol of the Lupine (misshapen)
            {190602, quest=65498, note="Misshapen"}, -- Symbol of the Raptora (misshapen)
            {190726, quest=65498, note="Misshapen"}, -- Extract of Prodigious Sands (misshapen)
        },
        routes={{50553200, 44403680}},
    },
    [42934006] = {
        quest=65567,
        label="Rondure Cache",
        loot={
            {190096, quest=65534}, -- Pocobold (even if you already have it -- it just vanishes)
        },
        note="Unlock the Rondure Alcove Arrangement to come here from the Inner Locus. Solve a fairly horrible jumping puzzle to reach the orb near the ceiling.",
        routes={{50553200, 42934006}},
        hide_before=ns.conditions.QuestComplete(65345), -- Rondure Alcove Arrangement
    },
})

local requisites = {
    quest=65532,
    label="{npc:185261:Requisites Originator}",
    atlas="creationcatalyst-32x32",
    -- TODO: check for updates on loot @ https://www.wowhead.com/npc=185261/requisites-originator
    note="|cFFFFFF00Unlock the Repertory Alcove Arrangement to come here from the Inner Locus. Once a week you can request items based on your Cypher research level.|r\n"..
        "{spell:366667}: {item:190336:Thrumming Powerstone} and gold\n"..
        "{spell:366668}: {item:189865:Anima Matrix}\n"..
        "{spell:366669}: {currency:1979:Cyphers of the First Ones}\n"..
        "{spell:366670}: {item:188957:Genesis Motes} and low chance at {item:189179}\n"..
        "{spell:366671}: Mix of Cyphers, Genesis Modes, Anima, and gold\n"..
        "{spell:366672}: Spec-appropriate Cypher Equipment\n",
    hide_before=ns.conditions.QuestComplete(65345), -- Repertory Alcove Arrangement
}
ns.RegisterPoints(1970, { -- Zereth Mortis
    [47503660] = {
        routes={{50553200, 47503660}},
    },
}, requisites)
ns.RegisterPoints(2029, { -- Gravid Repose
    [30506380] = requisites,
})

ns.RegisterPoints(1970, { -- Zereth Mortis
    [47703450] = {quest=65343, label="Camber Alcove Arrangement"},
    [49553105] = {quest=65344, label="Repertory Alcove Arrangement", note="Inside the Terrestrial Cache cave"},
    [50502760] = {quest=65345, label="Rondure Alcove Arrangement", note="Hidden away between two pillars, you'll need flying or the Tertius Locus to reach it"},
    [51043248] = {quest=65346, label="Dormant Alcove Arrangement"},
    [47863046] = {quest=65347, label="Fulgore Alcove Arrangement"},
}, {
    atlas="Rune-06-neutral",
    minimap=true,
    hide_before=ns.conditions.QuestComplete(65328), -- Arbiter in the Making
    note="|cFFFFFF00Activate to unlock a new destination from the Inner Locus|r",
})

-- Notable locations

ns.RegisterPoints(1970, { -- Zereth Mortis
    [61805895] = { label="Synthesis Forge",
        label="{npc:184172}",
        note="Make pets here",
        texture=ns.atlas_texture("teleportationnetwork-32x32", {r=1,g=0.6,b=0.2,a=1,scale=1.2}),
        minimap=true,
        achievement=15411, criteria=true, -- Synthe-supersized!
        hide_before=ns.conditions.QuestComplete(65419), -- Protoform Synthesis
    },
    [68703005] = { label="Protoform Repository",
        label="Protoform Repository",
        note="Make mounts here",
        texture=ns.atlas_texture("teleportationnetwork-32x32", {r=1,g=0.6,b=0.2,a=1,scale=1.2}),
        minimap=true,
        achievement=15411, criteria=true, -- Synthe-supersized!
        hide_before=ns.conditions.QuestComplete(65427), -- A New Architect
    },
    [61505370] = { label="Wellspring of the First Ones",
        label="Wellspring of the First Ones",
        texture=ns.atlas_texture("teleportationnetwork-32x32", {r=0,g=0.8,b=0.8,a=1,scale=1}),
        minimap=true,
        hide_before=ns.conditions.QuestComplete(65448), -- A Return To Grace
        note="Stand in the wellspring to receive {spell:368622}",
        spell=368622, -- Grace of the First Ones
    },
    [37104470] = { label="Olea Manu",
        label="{npc:183962:Olea Manu}",
        loot={
            {188793, quest=65282, note="150{currencyicon:1979}"}, -- Improvised Cypher Analysis Tool
            {190333, toy=true, note="100{currencyicon:1979}"}, -- Jiro Circle of Song
            {191039, pet=3247, note="500{currencyicon:1979}"}, -- Pocopoc Traveler
            {187804, note="25{currencyicon:1979}"}, -- Recipe: Empty Kettle of Stone Soup
            {187824, note="25{currencyicon:1979}"}, -- Formula: Magically Regulated Automa Core
            {189980, quest=65510, covenant=Enum.CovenantType.NightFae, note="1000{currencyicon:1979}"}, -- Brutosaur Soul
            {189986, quest=65514, covenant=Enum.CovenantType.NightFae, note="500{currencyicon:1979}"}, -- Armadillo Soul
        },
        atlas="banker", minimap=true,
        hide_before=ns.conditions.QuestComplete(65219), -- Jiro to Hero
        note="This is a vendor. Learn {garrisontalent:1902} then complete the {quest:65219} questline",
    },
    [47448863] = { label="Creation Catalyst",
        label="{spell:368843:Creation Catalyst}",
        atlas="creationcatalyst-32x32",
        hide_before=ns.conditions.QuestComplete(65774), -- The Catalyst Awakens
        note="Bring gear here to become tier",
    },

    [61607000] = { label="Mawtouched Geomental",
        label="{npc:183230:Mawtouched Geomental}",
        loot={ns.rewards.BattlePet(3215)},
        active=ns.conditions.Item(187244), -- Questionable Mushroom
        atlas="WildBattlePetCapturable",
        note="Eat a {item:187244:Questionable Mushroom} to be able to see this",
    }
})

-- Schematics

-- TODO: honestly, classes and getters might be useful here?
local makeSchematic = function(questid, itemid, stype, extra)
    return ns.merge({
        quest=questid,
        label=("{item:%d}"):format(itemid),
        loot={{itemid, quest=questid, note=stype}},
    }, extra)
end
local schematic = {
    atlas="poi-islands-table",
    minimap=true,
    hide_before=ns.conditions.QuestComplete(65427), -- A New Architect
    group="Schematics",
}
local hide_flying = {
    ns.conditions.QuestComplete(65427), -- A New Architect
    ns.conditions.Achievement(15514), -- flying
}

-- Mount schematics

ns.RegisterPoints(1970, { -- Zereth Mortis
    [64203560] = makeSchematic(65400, 189477, MOUNT, { -- Schematic: Darkened Vombata
        note="In the floating cage. You can jump up the chain under it if you're lucky, but it's fiddly.",
    }),
    [62004350] = makeSchematic(65381, 189458, MOUNT, { -- Schematic: Desertwing Hunter
        hide_before=hide_flying,
        note="On top of a tall pillar, you'll need flying",
    }),
    [50203230] = makeSchematic(65396, 189473, MOUNT, { -- Schematic: Bronzewing Vespoid
        note="Inside the Gravid Repose",
    }),
    [53302560] = makeSchematic(65398, 189475, MOUNT), -- Schematic: Forged Spiteflyer
    [31505030] = makeSchematic(65388, 189465, MOUNT, {note="On top of the entryway to the Genesis Alcove"}), -- Schematic: Genesis Crawler
    [34904870] = makeSchematic(65390, 189467, MOUNT, { -- Schematic: Ineffable Skitterer
        note="Talk to {npc:185092} inside Firim's hideout while dead",
    }),
    [67404010] = makeSchematic(65383, 189460, MOUNT, { -- Schematic: Raptora Swooper
        note="Inside the Chamber of Shaping",
    }),
    [47700950] = makeSchematic(65387, 189464, MOUNT, { -- Schematic: Scarlet Helicid
        note="High up on an arch. Without flying you can jump up from the northeast corner.",
    }),
    [62962152] = makeSchematic(65389, 189466, MOUNT, { -- Schematic: Tarachnid Creeper
        hide_before={
            ns.conditions.QuestComplete(65427), -- A New Architect
            ns.conditions.QuestComplete(64809), -- One Half of the Equation
        },
    }),
    [50003340] = makeSchematic(65386, 189463, MOUNT, { -- Schematic: Unsuccessful Prototype Fleetpod
        note="Unlock the Camber Alcove @ 47.7 34.5, use the Inner Locus to reach it, then complete the Inert Prototype minigame",
        hide_before={
            ns.conditions.QuestComplete(65427), -- A New Architect
            ns.conditions.GarrisonTalent(1902), -- Altonian Understanding
            ns.conditions.QuestComplete(65328), -- Arbiter in the Making, end of A Means to an End storyline
        },
        routes={{50553200, 50003340}},
    }),
    [50352715] = makeSchematic(65395, 189472, MOUNT, { -- Schematic: Vespoid Flutterer
        -- this one is accessible at the base state
        note="In the Resonant Peaks, accessed through the Gravid Repose teleporters",
    }),
    -- Doubled from treasures:
    [67006940] = makeSchematic(65393, 189469, MOUNT, { -- Schematic: Prototype Leaper
        note="In the Forgotten Proto-Vault treasure; if you looted it before unlocking protoforms, it should just be sitting there",
        hide_before={
            ns.conditions.QuestComplete(65427), -- New Architect
            ns.conditions.QuestComplete(65178),
        },
        requires_worldquest=65089,
    }),
    [60503050] = makeSchematic(65379, 189456, MOUNT, { -- Schematic: Sundered Zerethsteed
        note="In the Mawsworn Cache treasure; if you looted it before unlocking protoforms, it should just be sitting there",
        hide_before={
            ns.conditions.QuestComplete(65427), -- New Architect
            ns.conditions.QuestComplete(65441),
        },
    }),
    -- mob drops
    [76405160] = makeSchematic(65391, 189468, MOUNT, { -- Schematic: Goldplate Bufonid
        note="Drops from {npc:178803} in this area",
    }),
    [50107340] = makeSchematic(65391, 189468, MOUNT, { -- Schematic: Goldplate Bufonid
        note="Drops from {npc:178803} in this area",
    }),
    [53106385] = makeSchematic(65680, 190585, MOUNT, { -- Schematic: Heartbond Lupine
        note="Drops from {npc:179939} inside the Choral Residium",
    }),
    [61402800] = makeSchematic(65382, 189459, MOUNT, { -- Schematic: Mawdapted Raptora
        note="Drops from {npc:181412} in this area",
    }),
}, schematic)
ns.RegisterPoints(2029, { -- Gravid Repose
    [50007700] = makeSchematic(65386, 189463, MOUNT, {
        note="Unlock the Camber Alcove outside @ 47.7 34.5, use the Inner Locus to reach it, then complete the Inert Prototype minigame",
        hide_before={
            ns.conditions.QuestComplete(65427), -- A New Architect
            ns.conditions.GarrisonTalent(1902), -- Altonian Understanding
            ns.conditions.QuestComplete(65328), -- Arbiter in the Making, end of A Means to an End storyline
        },
    }), -- Schematic: Unsuccessful Prototype Fleetpod
    [49004060] = makeSchematic(65396, 189473, MOUNT), -- Schematic: Bronzewing Vespoid
}, schematic)
ns.RegisterPoints(2047, { -- Sepulcher of the First Ones: Immortal Hearth
    [45813090] = makeSchematic(65384, 189461, MOUNT, { -- Schematic: Serenade
        note="Hanging in a chain-link under the floating island", minimap=true,
    }),
}, schematic)
ns.RegisterPoints(2061, { -- Sepulcher of the First Ones: Ephemeral Plains
    [63205140] = makeSchematic(65399, 189476, MOUNT, { -- Schematic: Curious Crystalsniffer
        note="Defeat {npc:184915:Halondrus}, then loot this from the second-phase room. You've got a reasonably short time after the boss kill to get it.",
    }),
}, schematic)

ns.RegisterPoints(2061, { -- Sepulcher of the First Ones: Ephemeral Plains
    [23923771] = {
        label="High Value Cache",
        loot={
            {189175, note="Token for..."}, -- Mawforged Bridle
            {187631, mount=true}, -- Darkened Vombata
            {187667, mount=true}, -- Mawdapted Raptora
            {187641, mount=true}, -- Reins of the Sundered Zerethsteed
            {189991, quest=65519, covenant=Enum.CovenantType.NightFae}, -- Snail Soul
        },
        hide_before=ns.conditions.Item(190727), -- Security Override Orb
        note="Kill {npc:185032:Taskmaster Xy'pro} while they have 3x{spell:366919:Synergy} from being near other mobs",
    },
})

ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Pulp-Covered Relic
    -- no hide_before because you *can* loot it, it just won't have the schematic
    [41903400] = {},
    [50304120] = {},
    [52804580] = {},
    [53402570] = {},
    [64356345] = {},
}, {
    quest=65501,
    label="Pulp-Covered Relic",
    note="Multiple spawn points",
    loot={
        {189474, quest=65397, note=MOUNT}, -- Schematic: Buzz
    },
    texture=ns.atlas_texture("creationcatalyst-32x32", {r=0.5,g=1,b=0.5,a=1,scale=0.9}),
    group="Schematics",
})

schematic = CopyTable(schematic, true)
schematic.atlas = nil
schematic.texture = ns.atlas_texture("poi-islands-table", {r=0,g=1,b=1,a=1,scale=0.9})
schematic.hide_before=ns.conditions.QuestComplete(65419) -- Protoform Synthesis
hide_flying = {
    ns.conditions.QuestComplete(65419), -- Protoform Synthesis
    ns.conditions.Achievement(15514), -- flying
}

-- Pet schematics
ns.RegisterPoints(1970, { -- Zereth Mortis
    [78105310] = makeSchematic(65327, 189418, PET, {note="Underwater by the platform with {npc:185312}"}), -- Schematic: Ambystan Darter
    [61204260] = makeSchematic(65332, 189434, PET, {note="Under the platform"}), -- Schematic: Fierce Scarabid
    [58407450] = makeSchematic(65357, 189444, PET, { -- Schematic: Leaping Leporid
        hide_before=hide_flying,
        note="In a floating tree",
    }),
    [28105000] = makeSchematic(65358, 189445, PET, {note="Hidden in the leaves of the floating tree"}), -- Schematic: Microlicid
    [53807250] = makeSchematic(65333, 189435, PET, { -- Schematic: Multichicken
        hide_before={
            ns.conditions.QuestComplete(65419), -- Protoform Synthesis
            ns.conditions.QuestComplete(65522),
        },
        note="In the Mistaken Ovoid treasure; if you looted it before unlocking protoforms, it should just be sitting there",
    }),
    [42804060] = makeSchematic(65348, 189440, PET, { -- Schematic: Omnipotential Core
        hide_before={
            ns.conditions.QuestComplete(65427), -- A New Architect
            ns.conditions.GarrisonTalent(1902), -- Altonian Understanding
            ns.conditions.QuestComplete(65328), -- Arbiter in the Making, end of A Means to an End storyline
        },
        note="In the Rondure Alcove area of the Resonant Peaks, solve the shorter jumping puzzle to reach it on top of one of the doorways.\nUnlock Rondure Alcove @ 50.5 27.6 on the Tertius level.",
    }),
    [52207530] = makeSchematic(65354, 189442, PET, { -- Schematic: Prototickles
        note="In a chain overlooking the falls, hidden in the leaves; jump down from the East and edge up to it",
    }),
    [57807780] = makeSchematic(65359, 189446, PET, { -- Schematic: Shelly
        note="On the back of the shelves at the back of the Lexical Grotto; requires some sort of movement ability to reach",
        path=59258146,
    }),
    [67203260] = makeSchematic(65355, 189443, PET, { -- Schematic: Terror Jelly
        hide_before=hide_flying,
        note="On a pillar, you'll need flying or a glider",
    }),
    [55705340] = makeSchematic(65361, 189448, PET, {note="Inside the Locrian Esper"}), -- Schematic: Tunneling Vombata
    [58807720] = makeSchematic(65360, 189447, PET, { -- Schematic: Viperid Menace
        -- TODO: the Library Vault was made inaccessible until you had Dealic on March 1st 2022, so this should no longer be a possible situation for new players. Remove this someday.
        hide_before={
            ns.conditions.QuestComplete(65419), -- Protoform Synthesis
            ns.conditions.QuestComplete(65173),
        },
        note="In the Library Vault treasure; if you looted it before unlocking protoforms, it should just be sitting there",
        path=59258144,
    }),
    -- drops
    [76405430] = makeSchematic(65351, 189441, PET, { -- Schematic: Resonant Echo
        note="Find in {item:189172:Crystallized Echo of the First Song} in this area",
    }),
}, schematic)
ns.RegisterPoints(2028, { -- Locrian Esper
    [74605160] = makeSchematic(65361, 189448, PET), -- Schematic: Tunneling Vombata
}, schematic)
ns.RegisterPoints(2049, { -- Sepulcher of the First Ones: The Endless Foundry
    [66901770] = makeSchematic(65336, 189437, PET, {note="Can drop from {npc:182169:Lihuvim}"}), -- Schematic: Stabilized Geomental
}, schematic)

ns.RegisterPoints(1970, {
    [58608990] = {note="On a floating orb, at the top of the waterfall coming from it", hide_before=hide_flying},
    [77404530] = {},
    [77605900] = {note="In cave"},
    [77606040] = {},
    [78205440] = {note="On ledge, needs movement abilities"},
    [78305310] = {note="Under the platform, reachable from 78.4 52.9"},
}, {
    label="{item:189172:Crystallized Echo of the First Song}",
    loot={
        {189441, quest=65351, note=PET}, -- Schematic: Resonant Echo
        189172, -- Crystallized Echo of the First Song
    },
    note="These glow and have musical notes coming from them",
    atlas="islands-azeritechest",
    minimap=true,
    hide_before=ns.conditions.QuestComplete(65427), -- A New Architect (they have a pet schematic, but the nodes require this apparently...)
    group="Schematics",
    ShouldShow = function() return true end, -- this gets checked after the group, so these are still hideable, this just suppresses the completion from the schematic-quest
})

-- Puzzle caches
-- The WQs for these all use 65418 + a WQ quest regardless of the type of cache

local puzzle = ns.nodeMaker{
    group="puzzlecache",
    active=ns.conditions.GarrisonTalent(1972),
    minimap=true,
}
ns.RegisterPoints(1970, { -- Zereth Mortis
    [38556365] = {quest=65094},
    [43652150] = {quest=65094},
    [53004560] = {quest=65094},
    [65654095] = {quest=65094},
    [48608745] = {quest=65318},
    [54954800] = {quest=65318},
    [55957960] = {quest=65318},
    [44209010] = {quest=65323},
    [44757610] = {quest=65323},
    [47504620] = {quest=65323},
}, puzzle{
    label="Cantaric Cache",
    texture=ns.atlas_texture("VignetteLoot", {r=0,g=1,b=1,a=0.8,scale=0.9}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    [46056460] = {quest=65093},
    [47107720] = {quest=65093},
    [57506575] = {quest=65093},
    [63103740] = {quest=65093},
    [44303095] = {quest=65317},
    [47603910] = {quest=65317},
    [59702290] = {quest=65317},
    [36455645] = {quest=65322},
    [39204665] = {quest=65322},
    [42206880] = {quest=65322},
}, puzzle{
    label="Fugueal Cache",
    texture=ns.atlas_texture("VignetteLoot", {r=1,g=0.5,b=0,a=0.8,scale=0.9}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    [41853130] = {quest=65092},
    [54254280] = {quest=65092},
    [58903635] = {quest=65092},
    [45109410] = {quest=65316},
    [56008415] = {quest=65316},
    [56656140] = {quest=65316},
    [33805425] = {quest=65321},
    [39957285] = {quest=65321},
    [44655055] = {quest=65321},
    [51302575] = {quest=65412},
}, puzzle{
    label="Glissandian Cache",
    texture=ns.atlas_texture("VignetteLoot", {r=1,g=1,b=0,a=0.8,scale=0.9}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    [38357035] = {quest=65091},
    [39356045] = {quest=65091},
    [52357200] = {quest=65091},
    [55655000] = {quest=65091},
    [35805910] = {quest=65315},
    [57853165] = {quest=65315},
    [64705280] = {quest=65315},
    [38503550] = {quest=65320},
    [43604035] = {quest=65320},
    [49953045] = {quest=65320},
}, puzzle{
    label="Mezzonic Cache",
    texture=ns.atlas_texture("VignetteLoot", {r=0,g=0.8,b=0,a=0.8,scale=0.9}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    [32055260] = {quest=64972},
    [34606880] = {quest=64972},
    [37004645] = {quest=64972},
    [46806700] = {quest=64972},
    [52455705] = {quest=65314},
    [53258685] = {quest=65314},
    [62807390] = {quest=65314},
    [64306330] = {quest=65319},
    [65604760] = {quest=65319},
    [67802745] = {quest=65319},
}, puzzle{
    label="Toccatian Cache",
    texture=ns.atlas_texture("VignetteLoot", {r=1,g=0,b=1,a=0.8,scale=0.8}),
})

-- Lore concordances

local lore = ns.nodeMaker{
    group="Lore Concordances",
    note=function(point)
        if point.quest_ then
            local known = C_QuestLog.IsQuestFlaggedCompleted(point.quest_)
            return "Unlocks lore entries at the Lore Console in Exile's Hollow\n" ..
                "This lore is " ..
                (known and GREEN_FONT_COLOR or RED_FONT_COLOR):WrapTextInColorCode(known and "known" or "unknown")
        else
            return "Unlocks lore entries at the Lore Console in Exile's Hollow"
        end
    end,
    minimap=true,
}
local metrial = ns.conditions.GarrisonTalent(1901)
local dealic = {ns.conditions.GarrisonTalent(1932)}
local trebalim = {ns.conditions.GarrisonTalent(1907)}
ns.RegisterPoints(1970, { -- Zereth Mortis
    [31775466] = {quest_=65179, hide_before=dealic},
    [38953127] = {quest_=65213, hide_before=dealic},
    [50405096] = {quest_=65216, hide_before=dealic},
    [64616035] = {quest_=65210, hide_before=dealic},
}, lore{
    label="Excitable concordance",
    atlas="vehicle-templeofkotmogu-purpleball",
    spell=362757, -- Hasty Understanding
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    [35037144] = {quest_=65180, hide_before=trebalim},
    [39702572] = {quest_=65214, hide_before=trebalim},
    [51579134] = {quest_=65211, hide_before=trebalim},
    [64262397] = {quest_=65217, hide_before=trebalim},
}, lore{
    label="Mercurial concordance",
    atlas="vehicle-templeofkotmogu-orangeball",
    spell=362759, -- Powerful Knowledge
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    [32196281] = {quest_=64940, hide_before=metrial},
    [38844857] = {quest_=65212, hide_before=metrial},
    [49367149] = {quest_=65209, hide_before=metrial},
    [60204707] = {quest_=65215, hide_before=dealic},
}, lore{
    label="Tranquil concordance",
    atlas="vehicle-templeofkotmogu-greenball",
    spell=362498, -- Critical Potency
})

-- Tales of the Exile

ns.RegisterPoints(1970, { -- Zereth Mortis
    [35755546] = {criteria=53299}, -- Part 1
    [41796247] = {criteria=53300}, -- Part 2
    [37544601] = {criteria=53301}, -- Part 3
    [49827656] = {criteria=53302}, -- Part 4
    [39033109] = {criteria=53303}, -- Part 5
    [67422518] = {criteria=53304}, -- Part 6
    [64833364] = {criteria=53305}, -- Part 7
}, {
    achievement=15509,
    atlas="poi-workorders", -- 4072784?
    minimap=true,
})

-- Patient Bufonid

ns.RegisterPoints(1970, { -- Zereth Mortis
    [34506550] = {
        npc=185798,
        quest={65732, 65724, any=true}, -- 65724 is the daily
        progress={65727, 65725, 65726, 65728, 65729, 65730, 65731},
        hide_before=ns.conditions.QuestComplete(65768), -- Our Forward Scouts
        texture=ns.merge(ns.atlas_texture("stablemaster"), {r=1,g=1,b=0,a=1,scale=1.2}),
        minimap=true,
        loot={
            {188808, mount=1569},
        },
        group="dailymount",
        note=function()
            local function q(quest, label)
                return (C_QuestLog.IsQuestFlaggedCompleted(quest) and GREEN_FONT_COLOR or RED_FONT_COLOR):WrapTextInColorCode(label)
            end
            return "Gather items over a week of quests:\n"..
                q(65727, "Day 1") ..": 15x {item:190852} from Vespoid\n"..
                q(65725, "Day 2") ..": 30x {item:172053}\n"..
                q(65726, "Day 3") ..": 200x {item:173202}\n"..
                q(65728, "Day 4") ..": 10x {item:173037}\n"..
                q(65729, "Day 5") ..": 5x {item:187704}\n"..
                q(65730, "Day 6") ..": 5x {item:190880} from {npc:185748} near Pilgrim's Grace\n"..
                q(65731, "Day 7") ..": 1x {item:187171} from {npc:180114} in Tazavesh the Veiled Market\n"
        end,
    },
    [58554980] = {
        label="{npc:185748}", -- Mai Toa
        quest=65730,
        hide_before=ns.conditions.QuestComplete(65729),
        note="Buy 5x {item:190880} for day 6 of the Patient Bufonid",
        atlas="food",
        minimap=true,
    },
})

-- Coreless for Pocopoc
local coreless = ns.nodeMaker{
    hide_before=ns.conditions.GarrisonTalent(1932), -- Dealic Understanding
    note="|cFFFFFF00Use with Pocopoc and gain access to a special ability|r",
    -- atlas="poi-scrapper",
    minimap=true, scale=0.9,
    achievement=15542, always=true,
    group="coreless",
}
ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Coreless Vombata
    [33205620] = {},
    [37203760] = {},
    [37804720] = {},
    [38407080] = {},
    [45407580] = {},
    [46807860] = {},
    [56006660] = {},
}, coreless{
    label="{npc:181580:Coreless Vombata}",
    spell=361415, -- Withering Bash
    texture=ns.atlas_texture("poi-scrapper", {r=1, g=0.5, b=1}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Coreless Tarachnid
    [41602780] = {},
    [44202460] = {},
    [53602700] = {},
    [57002540] = {},
    [59004900] = {},
    [59405480] = {},
    [62806240] = {},
    [64004380] = {},
}, coreless{
    label="{npc:181556:Coreless Tarachnid}",
    spell=361556, -- Acrid Spit
    texture=ns.atlas_texture("poi-scrapper", {r=1, g=0.7, b=0.7}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Coreless Helicid
    [32605980] = {},
    [37207080] = {},
    [37805500] = {},
    [42408820] = {},
    [43806120] = {},
    [44405640] = {},
    [50006260] = {},
    [52407480] = {},
    [59008420] = {},
    [63207040] = {},
}, coreless{
    label="{npc:181558:Coreless Helicid}",
    spell=362897, -- Sticky Mucus
    texture=ns.atlas_texture("poi-scrapper", {r=0.25, g=1, b=0.5}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Coreless Geomental
    [47204600] = {},
    [50004160] = {},
    [54003804] = {},
    [54009080] = {},
    [55006040] = {},
    [66403800] = {},
}, coreless{
    label="{npc:181586:Coreless Geomental}",
    spell=360577, -- Earthquake
    texture=ns.atlas_texture("poi-scrapper", {r=0.5, g=0.25, b=1}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Coreless Scarabid
    [40803160] = {},
    [42604360] = {},
    [44453685] = {}, -- almost collides with Sand Sand Everywhere
    [47602420] = {},
    [51404920] = {},
    [57403040] = {},
    [62003200] = {},
    [67202500] = {},
}, coreless{
    label="{npc:181385:Coreless Scarabid}",
    spell=330595, -- Bite
    texture=ns.atlas_texture("poi-scrapper", {r=0.7, g=0.7, b=1}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Coreless Aurelid
    [34607060] = {},
}, coreless{
    quest=65523,
    label="{npc:185282:Coreless Aurelid}",
    note="This one is just used to reach the nearby underwater treasure",
    texture=ns.atlas_texture("poi-scrapper", {r=0.5, g=0.5, b=1}),
})
ns.RegisterPoints(1970, { -- Zereth Mortis
    -- Coreless Guardian
    [39405420] = {},
    [41804560] = {},
    [42602300] = {},
    [43403920] = {},
    [43406880] = {},
    [45605680] = {},
    [47209420] = {},
    [47807720] = {},
    [48800320] = {},
    [53604320] = {},
    [56202840] = {},
    [56207800] = {},
    [57005420] = {},
    [65203660] = {},
    [66602840] = {},
}, coreless{
    label="{npc:183869:Coreless Guardian}",
    note="Pilot with up to two others",
    hide_before=ns.conditions.GarrisonTalent(1998), -- Bassalim Understanding
    texture=ns.atlas_texture("poi-scrapper", {r=0.7, g=1, b=1}),
})

-- Traversing the Spheres
-- *Most* of this is in wide areas, but there's a few highly specific ones
local traverse = ns.nodeMaker{
    achievement=15229,
    atlas="ancientmana",
    minimap=true,
    active=ns.conditions.Item(187908),
}
ns.RegisterPoints(1970, { -- Zereth Mortis
    [32814036] = {},
    [43601150] = {},
    [43908850] = {},
    [36307090] = {},
    [51709000] = {},
}, traverse{
    quest=65559,
    criteria=9,
    loot={190128}, -- Wayward Essence
    note="Tap the orb with a bird circling around it",
})
ns.RegisterPoints(1970, {
    [34604670] = traverse{
        quest=65560,
        criteria=10,
        note="Above the Exile's Hollow cave entrance",
    },
})
-- 65622 when I was forge-tapping and got a honeycombed lattice
-- 65560 serene pigment (above Firim's)
-- 65016 volatile precursor
-- 65014 incorporeal sand
-- 65017 empyrean essence
-- 65005 pollinated extraction
-- 65015 energized firmament

-- Coming To Terms
do
    local TERMS = {
        label="{npc:185766:Haunting Memory}",
        achievement=15399,
        atlas="Vehicle-TempleofKotmogu-OrangeBall",
        note="Collect 3x {npc:185766:Haunting Memory} before Anduin",
    }
    ns.RegisterPoints(2048, { -- Sepulcher of the First Ones: Genesis Cradle
        [30035395] = {},
    }, TERMS)
    ns.RegisterPoints(2061, { -- Sepulcher of the First Ones: Ephemeral Plains
        [25835422] = {},
        [36782899] = {note="Accessible before the boss fight"},
    }, TERMS)
end

-- Adventurer of Zerith Mortis

ns.RegisterPoints(1970, { -- Zereth Mortis
    [64753370] = { label="Akkaris",
        npc=179006,
        quest=65552,
        vignette=4747,
        criteria=52977,
        loot={
            189903, -- Sand Sifting Sandals
            189958, -- Tunneler's Penetrating Greathelm
            190053, -- Underground Circler's Crossbow
            190733, -- Circle of Akkaris
        },
        note="This doesn't spawn every day",
    },

    [49556750] = { label="Chitali the Eldest",
        npc=183596,
        quest=65553,
        criteria=52978,
        vignette=4948,
        loot={
            189906, -- Mask of the Resolute Cervid
            189947, -- Majestic Watcher's Girdle
            189994, -- Chitali's Command
            190729, -- Vigorous Sentinel's Seal
        },
        note="This doesn't spawn every day",
    },

    [47506230] = { label="Corrupted Architect",
        npc=183953,
        quest=65273,
        criteria=53047,
        vignette=4989,
        loot={
            189907, -- Crown of Contorted Thought
            189940, -- Architect's Polluting Touch
            190009, -- Hammer of Shattered Works
            190732, -- Strand of Tainted Relics
        },
        note="Fight {npc:183958} and {npc:183961} to trigger",
    },

    [53654435] = { label="Destabilized Core",
        npc=180917,
        quest=64716,
        criteria=52974,
        loot={
            189910, -- Adornment of Jingling Fractals
            189930, -- Restraints of Boundless Chaos
            189985, -- Curtain of Untold Realms
            189999, -- Dark Sky Gavel
            189153, -- Unformed Lattice
            187837, -- Schematic: Erratic Genesis Matrix (engineer only)
        },
    },

    [47454515] = { label="Euv'ouk",
        npc=184409,
        quest=65555,
        criteria=52982,
        vignette=4961,
        loot={
            189949, -- Shackles of the Bound Guardian
            189956, -- Perverse Champion's Handguards
            189993, -- Twisted Judicator's Gavel
            190047, -- Converted Broker's Staff
        },
        note="This doesn't spawn every day",
    },

    [61806060] = { label="Feasting",
        npc=178229,
        quest=65557,
        criteria=52973,
        loot={
            187848, -- Recipe: Sustaining Armor Polish
            189936, -- Feasting's Feeding Cloak
            189969, -- Vespoid's Clanging Legguards
            189970, -- Visor of Visceral Cravings
        },
    },

    [64605865] = { label="Furidian",
        npc=183646,
        quest=65544,
        criteria=53031,
        loot={
            189920, -- Viperid Keeper's Gloves
            189932, -- Slick Scale Chitin
            189963, -- Sculpted Ouroboros Clasp
            190004, -- Furidian's Inscribed Barb
        },
        note="Find 3x Empowered Keys nearby then unlock the Suspiciously Angry Vault",
        nearby={62605980, 64005730, 64456040, label="Empowered Key"},
    },

    [69053660] = { label="Garudeon",
        npc=180924,
        quest=64719,
        criteria=53025,
        vignette=4982,
        loot={
            189937, -- Garudeon's Blanket of Feathers
            189951, -- Sunbathed Avian Armor
            190602, -- Symbol of the Raptora
            190057, -- Protective Raptora's Wing-Glaive
            187832, -- Schematic: Pure-Air Sail Extensions (engineer only)
        },
        note="Gather {npc:183562} nearby, feed to {npc:183554}",
    },

    [59852110] = { label="General Zarathura",
        npc=182318,
        quest=65583,
        criteria=52985,
        vignette=4909,
        loot={
            189968, -- Dreadlord General's Tunic
            189948, -- Strangulating Chainlink Lasso
            190731, -- Deceiver's Illusionary Signet
            190125, -- Kris of Intricate Secrets
        },
        note="This doesn't spawn every day",
    },

    [53109305] = { label="Gluttonous Overgrowth",
        npc=178778,
        quest=65579,
        criteria=52971,
        loot={
            189929, -- Vinebound Strap
            189953, -- Lush-Stained Footguards
            190008, -- Enlightened Botanist's Machete
            190049, -- Perennial Punching Dagger
        },
        note="Break nearby {npc:184048}. This is often bugged.",
        nearby={52009380, 52409280, 53209300, 53409080, 54009120, label="{npc:184048:Bulging Root}"},
    },

    [80404705] = { label="Gorkek",
        npc=178963,
        quest=63988,
        criteria=52986,
        vignette=4746,
        loot={
            189926, -- Poison-Licked Spaulders
            189960, -- Crouching Legs of the Bufonid
            190001, -- Gorkek's Glistening Throatguard
        },
        note="This doesn't spawn every day",
    },

    [52602505] = { label="Hadeon the Stonebreaker",
        npc=178563,
        quest=65581,
        criteria=52984,
        loot={
            189919, -- Skittering Scarabid Treads
            189942, -- Hadeon's Indomitable Faceguard
            190000, -- Carapace of Gliding Sands
            190051, -- Elder's Opulent Stave
        },
        note="This doesn't spawn every day",
    },

    [58206835] = { label="Helmix",
        npc=183748,
        quest=65551,
        criteria=53048,
        loot={
            189931, -- Annelid's Hinge Wrappings
            189965, -- Armored Cuffs of Helmix
            190054, -- Facet Sharpening Crossbow
            190056, -- Enlightened Explorer's Lantern
        },
        note="This doesn't spawn every day. To spawn it, kill Annelid mobs nearby.",
    },

    [51807420] = { label="Hirukon",
        npc=180978,
        quest=65548, -- 65785 for killing with the lure buff, 65039 for making the lure
        criteria=52990,
        active=ns.conditions.Item(187923),
        atlas="VignetteKillElite", scale=1,
        loot={
            189905, -- Hirukon's Syrupy Squeezers
            189946, -- Jellied Aurelid Mantle
            190005, -- Hirukon's Radiant Reach
            187636, -- Aurelid Lattice
            {187676, mount=1434}, -- Deepstar Aurelid
        },
        -- TODO: add notes on the other maps?
        note=function()
            local attempted = C_QuestLog.IsQuestFlaggedCompleted(65785)
            return "You have to make a {item:187923}:\n"..
                "{a:*} Fish up {item:187662} nearby\n"..
                "{a:*} Fish up {item:187915} from Coilfang Reservoir in Zangarmarsh\n"..
                "{a:*} Fish up {item:187922} near Keyla's Grave in Nazjatar\n"..
                "{a:*} Find {item:187916} in Nar'shola Terrace in the Shimmering Expanse (34.7, 75.0)\n"..
                "{a:*} Ask {npc:182194} south of the Seat of the Primus in Maldraxxus to make your {item:187923}\n"..
                "{a:*} Bring it back here, use it, and fish in the Aurelid Cluster you can now see.\n"..
                "The lure will be consumed on use, but you can ask {npc:182194} for a new one each week without having to do the fishing again.\n"..
                "You " .. (attempted and GREEN_FONT_COLOR or RED_FONT_COLOR):WrapTextInColorCode(attempted and "have" or "have not") .. " used the lure this week."
        end,
    },

    [58654040] = { label="Otaris the Provoked",
        npc=183814,
        quest=65257,
        criteria=53046,
        loot={
            189909, -- Pantaloons of Cold Recesses
            189945, -- Shoulders of the Missing Giant
            189957, -- Colossus' Focusing Headpiece
        },
        note="Inside a cave",
        path=58703810,
    },

    [54103495] = { label="Mother Phestis",
        npc=178508,
        quest=65547,
        criteria=53020,
        loot={
            189769, -- Fang of Phestis
            189923, -- Tarachnid's Terrifying Visage
            189950, -- Constrained Prey's Binds
            190045, -- Flowing Sandbender's Staff
        },
        path=55953260,
    },

    [56406820] = { label="Orixal",
        npc=179043,
        quest=65582,
        criteria=52981,
        loot={
            189912, -- Orixal's Moist Sash
            189934, -- Slime-Wake Sabatons
            189952, -- Celestial Mollusk's Chestshell
        },
        note="Kill {npc:185487} and it might spawn",
    },

    [43308760] = { label="Otiosen",
        npc=183746,
        quest=65556,
        criteria=52972,
        loot={
            189914, -- Otiosen's Regenerative Wristwraps
            189925, -- Amphibian's Nimble Leggings
            190046, -- Broker's Stolen Cane
            189995, -- Builder's Alignment Hammer
            187634, -- Ambystan Lattice
        },
    },

    [38852760] = { label="Protector of the First Ones",
        npc=180746,
        quest=64668,
        criteria=52989,
        vignette=4988,
        loot={
            189961, -- Enduring Protector's Shoulderguards
            189984, -- Drape of Idolized Symmetry
            190002, -- Bulwark of the Broken
            190390, -- Protector's Diffusion Implement
            189176, -- Protoform Sentience Crown
            189177, -- Revelation Key
        },
        note="Two people required to open the barrier",
    },

    [53404705] = { label="Sand Matriarch Ileus",
        npc=183927,
        quest=65574,
        criteria=52975,
        loot={
            189927, -- Broker's Gnawed Spaulders
            189955, -- Scarabid's Clattering Handguards
            189998, -- Ornate Stone Mallet
            190730, -- Matriarch's Shell Band
        },
    },

    [42302100] = { label="Shifting Stargorger",
        npc=184413,
        quest=65549,
        criteria=52988,
        loot={
            189908, -- Gorger's Leggings of Famine
            189916, -- Mutated Devourer's Harness
            189941, -- Voracious Diadem
            {189972, quest=65505, covenant=Enum.CovenantType.NightFae}, -- Scorpid Soul
        },
    },

    [35857120] = { label="Sorranos",
        npc=183722,
        quest=65240,
        criteria=52980,
        loot={
            189911, -- Sublime Fur Mantle
            189944, -- Immovable Stance of the Vombata
            189962, -- Sorranos' Gleaming Pauldrons
            190582, -- Protector's Diffusion Implement
            187826, -- Formula: Cosmic Protoweave
        },
        note="This doesn't spawn every day",
    },

    [49803915] = { label="Tahkwitz",
        npc=183925,
        quest=65272,
        criteria=52979,
        loot={
            189915, -- Tahkwitz' Cloth Ribbon
            189933, -- Vigilant Raptora's Crest
            189954, -- Lustrous Sentinel's Sabatons
            190003, -- Skyward Savior's Talon
            187832, -- Schematic: Pure-Air Sail Extensions (engineer only)
        },
        note="You need a movement ability, or to use the {npc:184384:Locus Shift} to reach the Resonant Peaks",
    },

    [54507345] = { label="Tethos",
        npc=181249,
        quest=65550,
        criteria=52987,
        vignette=4903,
        loot={
            189928, -- Centripetal Waistband
            189966, -- Singing Metal Wristbands
            189967, -- Hood of Star Topology
            190055, -- Coalescing Energy Implement
            187830, -- Design: Aealic Harmonizing Stone
            189146, -- Geomental Lattice
        },
        note="This doesn't spawn every day",
    },

    [43957530] = { label="The Engulfer",
        npc=183516,
        quest=65580,
        criteria=53050,
        loot={
            189913, -- Engulfer's Tightening Cinch
            189921, -- Devourer's Insatiable Grips
            190006, -- Anima-Siphoning Sword
        },
        note="Protect {npc:183505} until this appears",
    },

    [39555735] = { label="Vexis",
        npc=181360,
        quest=65239,
        criteria=53049,
        loot={
            189900, -- Vexis' Gentle Heartcloth
            189959, -- Legs of Graceful Landing
            189997, -- The Lupine Prime's Might
            190048, -- Vexis' Wisest Fang
            190597, -- Symbol of the Lupine
        },
        note="This doesn't spawn every day",
    },

    [47054700] = { label="Vitiane",
        npc=183747,
        quest=65584,
        criteria=52983,
        vignette=4967,
        loot={
            189901, -- Vitiane's Defiled Vestment
            189922, -- Cowl of Shameful Proliferation
            189935, -- Harrowing Hope Squashers
        },
        note="This doesn't spawn every day",
    },

    [64054975] = { label="Xy'rath the Covetous",
        npc=183737,
        quest=65241,
        vignette=4938,
        criteria=52976,
        loot={
            189918, -- Fleeting Broker's Strides
            189964, -- Multi-Faceted Belt
            190052, -- Xy'rath's Letter Opener
            190007, -- Xy'rath's Signature Saber
            {190238, toy=true}, -- Xy'rath's Booby-Trapped Cache
            190389, -- Broker's Lucky Coin
            187828, -- Recipe: Infusion: Corpse Purification
        },
        note="This doesn't spawn every day",
    },

    [43503295] = { label="Zatojin",
        npc=183764,
        quest=65251,
        criteria=53044,
        vignette=4990,
        loot={
            189902, -- Hapless Traveler's Treads
            189924, -- Buzzing Predator's Legs
            189939, -- Zatojin's Paralytic Grip
            190726, -- Extract of Prodigious Sands
        },
        note="Engage the {npc:183721} to get 20 stacks of {spell:362976} and be {spell:362983}. Make sure you're standing on the {npc:183774} corpses.",
    },
}, {
    achievement=15391, -- Adventurer of Zereth Mortis
})

-- Dune Dominance
ns.RegisterPoints(1970, { -- Zereth Mortis
    [63202605] = {
        label="{achievement:15392}",
        achievement=15392, criteria=true,
        atlas="VignetteKillElite", scale=1.2,
        quest={
            65585, -- Iska, Outrider of Ruin, criteria 52992 (mount Rhuv, 65706), vignette 4918
            65586, -- High Reaver Damaris, criteria 52993 (mount Edra, 65558), vignette 4951
            65587, -- Reanimatrox Marzan, criteria 52994 (mount Phalangax, 65707), vignette 4952
            all=true,
        },
        note="One of these rares is here each day",
        loot={
            -- Iska
            {190102, note="Iska"}, -- Chains of Infectious Serrations
            {190103, note="Iska"}, -- Pillar of Noxious Dissemination
            {190126, note="Iska"}, -- Rotculler's Encroaching Shears
            {190458, note="Iska"}, -- Atrophy's Ominous Bulwark
            -- Iska's mount, Rhuv
            {190765, mount=1584, note="Iska's mount"}, -- Iska's Mawrat Leash
            -- Damaris
            {190105, note="Damaris"}, -- Chilling Domination Mace
            {190106, note="Damaris"}, -- Approaching Terror's Torch
            {190459, note="Damaris"}, -- Cold Dispiriting Barricade
            {190460, note="Damaris"}, -- High Reaver's Sickle
            -- Marzan
            {190108, note="Marzan"}, -- Aegis of Laughing Souls
            {190109, note="Marzan"}, -- Cudgel of Mortality's Chains
            {190127, note="Marzan"}, -- Marzan's Dancing Twin-Scythe
            {190461, note="Marzan"}, -- Reanimator's Beguiling Baton
            -- All of them
            {190050, note="All"}, -- Entropic Broker's Ripper
            {190104, note="All"}, -- Deadeye's Spirit Piercer
            {190107, note="All"}, -- Staff of Broken Coils
            {190124, note="All"}, -- Interrogator's Vicious Dirk
            {190463, note="All"}, -- Dismal Mystic's Glaive
        },
    },
})

ns.RegisterPoints(1970, { -- Zereth Mortis
    [48800560] = { label="Antros",
        npc=182466,
        quest=65695,
        worldquest=65143,
        loot={
            {189709, quest=65473}, -- Pocopoc's Cobalt and Copper Body
            190614, -- Antros' Entrusted Bascinet
            190615, -- Cosmic Guardian's Casing
            190616, -- Controlled Sequence Clasp
            190617, -- Destruction-Core Handlers
            190618, -- Lattice of the Distant Keeper
            190619, -- Antecedent's Aliform Joggers
            190620, -- Sav'thul's Calamitous Tantour
            190621, -- Dealic Deterrent Stockings
        },
    }
})

-- Completing the Code

ns.RegisterPoints(1970, { -- Zereth Mortis
    [41456245] = { label="Bitterbeak",
        npc=181352,
        criteria=52577,
    },

    [38855860] = { label="Cipherclad",
        npc=181349,
        criteria=52576,
    },

    [50306390] = { label="Corrupted Runehoarder",
        npc=181290,
        criteria=52569,
        note="Patrols around the eastern pools, /tar macros will help",
    },

    [48651370] = { label="Dominated Irregular",
        npc=184819,
        criteria=52568,
    },

    [62202500] = { label="Enchained Servitor",
        npc=181208,
        criteria=52567,
    },

    [60756475] = { label="Gaiagantic",
        npc=181223,
        criteria=52553,
        note="Only available on days when the {quest:64785} daily is up",
    },

    [36153850] = { label="Gorged Runefeaster",
        npc=181287,
        criteria=52566,
    },

    [56154805] = { label="Misaligned Enforcer",
        npc=181292,
        criteria=52570,
        note="Spawns here, walks around the area, and eventually despawns; watch out for a running automata",
        routes={{
            56154805, 54904560, 56304460, 55104090, 52404240, 51404080, 53003990,
            53304300, 56004660, 58104650, 57904440,
            r=1,g=1,b=0,
        }},
    },

    -- Moss-Choked Guardian
    [43609020] = {npc=181219, criteria=52554,},
    [45809520] = {npc=181219, criteria=52554,},
    [50659440] = {npc=181219, criteria=52554,},
    [53809360] = {npc=181219, criteria=52554,},

    [62806830] = { label="Overgrown Geomental",
        npc=179007,
        criteria=52565,
    },
    [61257440] = { label="Bygone Geomental",
        npc=181221,
        criteria=52552,
        note="Can spawn instead of nearby {npc:179007}",
    },

    [63205800] = { label="Over-charged Vespoid",
        npc=181222,
        criteria=52606,
        note="Spawns in this general area",
    },

    [39805205] = { label="Runefur",
        npc=181344,
        criteria=52575,
    },

    [50256015] = { label="Runegorged Bufonid",
        npc=181294,
        criteria=52572,
    },

    [61855180] = { label="Runethief Xy'lora",
        npc=181295,
        criteria=52574,
        note="Appears stealthed in Pilgrim's Grace",
    },

    [53557520] = { label="Sharpeye Collector",
        npc=178835,
        criteria=52573,
    },

    [35056375] = { label="Suspicious Nesmin",
        npc=181293,
        criteria=52571,
    },

    [45202190] = { label="Twisted Warpcrafter",
        npc=182798,
        criteria=52686,
    },
}, {
    achievement=15211,
    texture=ns.atlas_texture("VignetteKill", {r=1,g=0.5,b=0,a=1,scale=1}),
    minimap=true,
    active=ns.conditions.Item(187909),
    note="You need to have completed the daily quest {quest:64785} or {quest:64854} to get the {item:187909}."
})

-- Transportation

-- Ancient Translocator
-- ns.RegisterPoints(1970, {
--     [46122172] = {route=47301340,},
--     [47301340] = {routes={{47301340,46122172,r=0,g=0.75,b=0}},},
-- }, {
--     label="{npc:183968}",
--     atlas="progenitorflightmaster-32x32", scale=1,
--     group="Transportation",
-- })
-- -- Ancient Translocator
-- ns.RegisterPoints(1970, {
--     [64855355] = {route=73305340,},
--     [73305340] = {routes={{73305340,64855355,r=0,g=0.75,b=0}},},
-- }, {
--     label="{npc:183970}",
--     atlas="progenitorflightmaster-32x32", scale=1,
--     hide_before=ns.conditions.QuestComplete(64844), -- The Pilgrimage Ends
--     group="Transportation",
-- })
ns.RegisterPoints(1970, {
    [50553200] = {
        label="{npc:184384}", -- Locus Shift
        note="Inside the Gravid Repose",
        atlas="flightmaster_progenitorobelisk-taxinode_neutral",
        minimap=true,
        group=TUTORIAL_TITLE35, -- Travel
    },
})
