local myname, ns = ...

--[[ mining walls
40857586 ?
--]]

-- stuffed the review box full at the Serene Dreams spa: 72357

-- PRIMALIST_TOMORROW = 2085
-- AZMERLOTH = 2092
-- GNOLL_WAR = 2090
-- SHIFTING_SANDS = 2091
-- PANDAREN_REVOLUTION = 2088
-- BLACK_EMPIRE = 2089

ns.RegisterPoints(ns.THALDRASZUS, {
    -- https://www.wowhead.com/beta/achievement=16301/treasures-of-thaldraszus
    [33957694] = { label="Cracked Hourglass",
        criteria=54810,
        quest=70607,
        loot={169951}, -- Broken Hourglass
        active={ns.conditions.QuestComplete(70537), ns.conditions.Item(199068), any=true}, -- Time-Lost Memo
        note="Find {item:199068} in other treasures",
        vignette=5379,
    },
    [58158005] = { label="Sandy Wooden Duck",
        criteria=54811,
        quest=70608,
        loot={
            200827, -- Weathered Sculpture
        },
        active={ns.conditions.QuestComplete(70538), ns.conditions.Item(199069), any=true}, -- Yennu's Map
        note="Find {item:199069} nearby",
        related={
            [54937543] = {quest=70538,loot={{199069,quest=70538},},atlas="poi-islands-table",active=false,}, -- Yennu's Map
        },
        vignette=5371, -- Sand Pile
    },
    [52607673] = { label="Amber Gem Cluster",
        criteria=54812,
        quest=70408,
        loot={},
        hide_before=ns.conditions.MajorFaction(ns.FACTION_DRAGONSCALE, 21),
        active={ns.conditions.QuestComplete(70407), ns.conditions.Item(198852), any=true}, -- Bear Termination Orders
        note="Find {item:198852} in other treasures",
    },
    [60234160] = { label="Elegant Canvas Brush",
        criteria=54813,
        quest=70609,
        loot={
            203206, -- Elegant Canvas Brush (sells for 2112g)
        },
    },
    [64851650] = { label="Surveyor's Magnifying Glass",
        criteria=54814,
        quest=70610,
        loot={
            193036, -- Left-Handed Magnifying Glass (inscription accessory, boe...)
        },
    },
    [49456291] = { label="Acorn Harvester",
        criteria=54815,
        quest=70611,
        loot={
            {193066, pet=3275}, -- Chestnut
        },
        note="Give an acorn to the squirrel; you may have to /reloadui after picking up the acorn before you can give it",
    },
}, {
    achievement=16301, -- Treasures
    minimap=true,
    -- hide_before=ns.conditions.Level(64),
})

ns.RegisterPoints(ns.THALDRASZUS, {
    [60665371] = { label="Revival Catalyst",
        label="{questname:72528:Revival Catalyst}",
        atlas="creationcatalyst-32x32",
        scale=1.2,
        hide_before=ns.conditions.QuestCompleteOnAccount(72360), -- Reviving the Machine
        note="Bring gear here to become tier",
    },
})

-- Living Mud Mask pet
ns.RegisterPoints(ns.THALDRASZUS, {
    [40464527] = {
        label="{quest:70377:Derelict Fashion}",
        quest=70377,
        loot={200586}, -- Derelict Sunglasses
        note="Kill for the {item:200586} which begin the chain leading to {item:200872}",
    },
    [38604642] = {
        label="{quest:72060:Special Treatment}",
        quest=72060,
        hide_before=ns.conditions.QuestComplete(70377),
        loot={{200872, pet=3405}}, -- Living Mud Mask
        note="Chase the {npc:198590:Sneaky Mud Mask} here",
    },
}, {
    texture=ns.atlas_texture("SmallQuestBang", {r=0, g=1, b=1}),
    minimap=true,
})

-- Rares
ns.RegisterPoints(ns.THALDRASZUS, {
    -- https://www.wowhead.com/beta/achievement=16679/adventurer-of-thaldraszus
    [51534871] = { label="Razk'vex the Untamed",
        criteria=56133,
        quest=73892, -- 69853?
        npc=193143,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {196992,quest=69192,}, -- Cliffside Wylderdrake: Heavy Horns
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            {197403,quest=69604,}, -- Renewed Proto-Drake: Club Tail
            200131, -- Reclaimed Survivalist's Dagger
            200165, -- Aegis of Scales
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200682, -- Hardened Scale Shoulderguards
            200859, -- Seasoned Hunter's Trophy
        },
        note="Runs around, you can jump on it",
        routes={{53104363, 53124230, 51624534, 50304953, 51534871, 52714652, loop=true}},
        minimap=true,
        vignette=5180,
    },
    [57968158] = { label="Innumerable Ruination",
        criteria=56135,
        quest=nil,
        npc=193126,
        loot={
            {197008,quest=69208,}, -- Cliffside Wylderdrake: Narrow Stripes Pattern
            {197135,quest=69336,}, -- Highland Drake: Toothy Mouth
            200133, -- Volcanic Chakram
            {200148,toy=true,}, -- A Collection Of Me
            200163, -- Ring of Embers
            200252, -- Molten Flak Cannon
            200760, -- Unstable Arcane Cell
        },
    },
    [31107120] = { label="Blightpaw the Depraved",
        -- overlaps a bit with plains @ 90454003
        criteria=56136,
        quest=73869, -- also 74096
        npc=193128,
        loot={
            {196973,quest=69173,}, -- Cliffside Wylderdrake: Dual Horned Chin
            {196982,quest=69182,}, -- Cliffside Wylderdrake: Ears
            {196986,quest=69186,}, -- Cliffside Wylderdrake: Black Hair
            {197150,quest=69351,}, -- Highland Drake: Spiked Club Tail
            200127, -- Gold-Alloy Blade
            {200178,toy=true,}, -- Infected Ichor
            200266, -- Gnollish Chewtoy Launcher
            200283, -- Gnoll-Gnawed Breeches
            200432, -- Rotguard Cowl
        },
        note="Talk to {npc:193222:Archaeologist Koranir} to engage, along with {npc:193231:Ancient Tundrafur}",
    },
    [38107820] = { label="Pleasant Alpha",
        criteria=56137,
        quest=73889, -- 72806 on criteria?
        npc=193130,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5479,
    },
    [53424101] = { label="Goremaul the Gluttonous",
        criteria=56138,
        quest=nil,
        npc=193125,
        loot={
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200436, -- Gorestained Hauberk
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
        },
    },
    [59806100] = { label="Phenran",
        criteria=56140,
        quest=74020, -- 69976,
        npc=193688,
        loot={
            {197100,quest=69301,}, -- Highland Drake: Crested Brow
            {197138,quest=69339,}, -- Highland Drake: Striped Pattern
            {197586,quest=69790,}, -- Windborne Velocidrake: Spiked Back
            200138, -- Ancient Dancer's Longspear
            200146, -- Phenran's Discordant Smasher
            200303, -- Dreamweaver Acolyte's Staff
        },
        vignette=5248,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [52805920] = { label="Matriarch Remalla",
        criteria=56141,
        quest=74013, -- vignette 69883
        npc=193246,
        loot={
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200174, -- Bonesigil Shoulderguards
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            200257, -- Decay Infused Branch
            200563, -- Primal Ritual Shell
        },
        vignette=5204,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [58398489] = { label="Phleep",
        criteria=56142,
        quest=74021, -- vignette 69866
        npc=193210,
        loot={
            {197008,quest=69208,}, -- Cliffside Wylderdrake: Narrow Stripes Pattern
            {197130,quest=69331,}, -- Highland Drake: Stag Horns
            200126, -- Mantle of Copious Chronologies
            {200148,toy=true,}, -- A Collection Of Me
            200202, -- Tomorrow's Chains
        },
        vignette=5192,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [49207980] = { label="Tempestrian",
        criteria=56144,
        quest=69886,
        npc=193258,
        loot={},
        vignette=5207,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [35027001] = { label="Treasure-Mad Trambladd",
        criteria=56146,
        quest=74036, -- 70947
        npc=193146,
        loot={
            {196994,quest=69194,}, -- Cliffside Wylderdrake: Short Horns
            200291, -- Waterlogged Racing Grips
            200300, -- Sack of Looted Treasures
        },
        vignette=5431,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [47805120] = { label="Eldoren the Reborn",
        criteria=56147,
        quest=73990, -- 69875
        npc=193234,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197135,quest=69336,}, -- Highland Drake: Toothy Mouth
            200133, -- Volcanic Chakram
            200163, -- Ring of Embers
            200186, -- Amberquill Shroud
            200217, -- Blazing Essence
            {200249,toy=true,}, -- Mage's Chewed Wand
            200284, -- Phoenix Feather Pendant
            200442, -- Basilisk Hide Jerkin
        },
        vignette=5198,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [39807000] = { label="Riverwalker Tamopo",
        criteria=56148,
        quest=74024, -- 69880
        npc=193240,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200859, -- Seasoned Hunter's Trophy
            200137, -- Chitin Dreadbringer
        },
        vignette=5201,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [59607012] = { label="Broodweaver Araznae",
        criteria=56149,
        quest=69868,
        npc=193220,
        loot={
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            {197586,quest=69790,}, -- Windborne Velocidrake: Spiked Back
            200138, -- Ancient Dancer's Longspear
            200147, -- Web-Woven Robe
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200445, -- Lucky Hunting Charm
            200758, -- Breastplate of Storied Antiquity
            200943, -- Whispering Band
        },
        vignette=5193,
        -- hide_before=ns.MAXLEVEL, -- TODO
        -- path=59416977, -- too close to need
    },
    [37387792] = { label="Sandana the Tempest",
        criteria=56150,
        quest=74029, -- 69859
        npc=193176,
        loot={
            {197008,quest=69208,}, -- Cliffside Wylderdrake: Narrow Stripes Pattern
            {197130,quest=69331,}, -- Highland Drake: Stag Horns
            {197372,quest=69573,}, -- Renewed Proto-Drake: Purple Hair
            {197606,quest=69810,}, -- Windborne Velocidrake: Swept Horns
            {200148,toy=true,}, -- A Collection Of Me
            200172, -- Zephyrdance Signet
            200202, -- Tomorrow's Chains
            200306, -- Tempest Shawl
            200563, -- Primal Ritual Shell
        },
        path=38517642,
        vignette=5185,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [50195193] = { label="Rokmur",
        criteria=56151,
        quest=74025, -- 69966
        npc=193666,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200137, -- Chitin Dreadbringer
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5238,
        note="In the cave",
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [47914980] = { label="Woolfang",
        criteria=56152,
        quest=74089, -- 69850,
        npc=193161,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        note="Pet {npc:193156:Wooly Lamb}",
        vignette=5177,
    },
    [46287298] = { label="The Weeping Vilomah",
        criteria=56153,
        quest=74086, -- 65365
        npc=183984,
        loot={
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200214, -- Grasp of the Weeping Widow
            200445, -- Lucky Hunting Charm
            200859, -- Seasoned Hunter's Trophy
        },
        note="In cave, talk to {npc:193206:Boomhooch the Lost} to summon",
        path={47537168, note="Upper level"},
        vignette=4958,
        minimap=true,
    },
    [45798526] = { label="Craggravated Elemental",
        criteria=56154,
        quest=74061, -- vignette 69964
        npc=193663,
        loot={
            {196991,quest=69191,}, -- Cliffside Wylderdrake: Black Horns
            200244, -- Enchanted Muckstompers
            200246, -- Lost Delving Lamp
            200298, -- Stoneshaped Greatbelt
            200563, -- Primal Ritual Shell
        },
        note="Break down the rock wall; *doesn't* require mining",
        vignette=5237,
    },
    [38436824] = { label="The Great Shellkhan",
        criteria=56155,
        quest=72121,
        npc=191305,
        loot={
            {200999, toy=true,}, -- The Super Shellkhan Gang
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        note="Bring a {item:200949:Case of Fresh Gleamfish} from 45.6, 54.8 in Azure Span and give it to {npc:191416:Patient Vaargo}; other quests in the area might interfere with this",
        vignette=5439,
        routes={{38436824, 32009999, highlightOnly=true}},
    },
    [44806900] = { label="Corrupted Proto-Dragon",
        criteria=56156,
        quest=74060, --69962
        npc=193658,
        loot={
            {196983,quest=69183,}, -- Cliffside Wylderdrake: Maned Jaw
            {197125,quest=69326,}, -- Highland Drake: Coiled Horns
            {197383,quest=69584,}, -- Renewed Proto-Drake: Heavy Horns
            {197602,quest=69806,}, -- Windborne Velocidrake: Cluster Horns
            200166, -- Corrupted Drake Horn
            {200198,toy=true,}, -- Primalist Prison
            200233, -- Paradox Saber
            200293, -- Primal Scion's Twinblade
        },
        vignette=5235,
        note="Interact with the egg inside the cave",
    },
    [62288178] = { label="Lord Epochbrgl",
        criteria=56157,
        quest=74066, -- vignette 69882
        npc=193241,
        loot={
            {197008,quest=69208,}, -- Cliffside Wylderdrake: Narrow Stripes Pattern
            {197022,quest=69222,}, -- Cliffside Wylderdrake: Finned Neck
            {200148,toy=true,}, -- A Collection Of Me
            200185, -- Grips of the Everflowing Ocean
            200552, -- Torrent Caller's Shell
        },
        note="In building; if {npc:193257:Unstable Time Rift} is up, click to summon",
        vignette=5203,
    },
    [59105874] = ns.SUPERRARE{ -- Ancient Protector
        criteria=56158,
        quest=74055, -- 69963 bonus objective, and 72050
        npc=193664,
        loot={
            {197100,quest=69301,}, -- Highland Drake: Crested Brow
            {197138,quest=69339,}, -- Highland Drake: Striped Pattern
            {197586,quest=69790,}, -- Windborne Velocidrake: Spiked Back
            200138, -- Ancient Dancer's Longspear
            200299, -- Strange Clockwork Gladius
            200303, -- Dreamweaver Acolyte's Staff
            200758, -- Breastplate of Storied Antiquity
        },
        nearby={61005510,59405680,59506070,60906240, label="Pillar"},
        note="Collect 20x {item:197708:Unstable Matrix Core} from {npc:193244:Titan Defense Matrix} to make 4x {item:197733:Unsustainable Containment Core}, then use one at all four pillars. You'll probably need a group to get this in time.",
        vignette=5236,
    },
}, {
    achievement=16679, -- Adventurer
})
ns.RegisterPoints(ns.THALDRASZUS, {
    [37538339] = { label="Private Shikzar",
        quest=70986,
        npc=193127,
        loot={},
        vignette=5406,
        note = "Ask him what's wrong",
    },
    [36808557] = { label="Lookout Mordren",
        quest=72813, -- 69967 on vignette?
        npc=193668,
        loot={
            {197135,quest=69336,}, -- Highland Drake: Toothy Mouth
            {197379,quest=69580,}, -- Renewed Proto-Drake: Impaler Horns
            {197383,quest=69584,}, -- Renewed Proto-Drake: Heavy Horns
            {197602,quest=69806,}, -- Windborne Velocidrake: Cluster Horns
            200122, -- Temporal Spyglass
            200163, -- Ring of Embers
            200182, -- Riveted Drape
            {200198,toy=true,}, -- Primalist Prison
            200217, -- Blazing Essence
            200247, -- Inextinguishable Gavel
            200252, -- Molten Flak Cannon
        },
        vignette=5239,
    },
    [37777413] = { label="Acrosoth",
        quest=72834, -- 72114
        npc=193243,
        loot={
            {196992, quest=69192}, -- Cliffside Wylderdrake: Heavy Horns
            {197403, quest=69604}, -- Renewed Proto-Drake: Club Tail
            200165, -- Aegis of Scales
            200228, -- Protoscale Pauldrons
            200682, -- Hardened Scale Shoulderguards
        },
        note="Flying nearby",
        routes={{37777413, 36307560, 36507860, 38407940, 40107780, 39507500, loop=true}},
        minimap=true,
        vignette=5436,
    },
    [55797732] = { label="Henlare",
        quest=69873, -- 72814
        npc=193229,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200880, -- Wind-Sealed Mana Capsule
        },
        vignette=5196,
    },
    [36737280] = { label="Liskron the Dazzling",
        quest=72116, -- 72842
        npc=193273,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5437,
    },
    [62005980] = { label="Morlash",
        quest=74450,
        npc=201549,
        loot={
            203666, -- Vinelashed Bracers
        },
    },
    [59406120] = { label="Overloading Defense Matrix",
        quest=74449, -- 74565
        npc=201550,
        loot={
            203677, -- Watcher's 'Neck' Ring
        },
    },
    [59566227] = { label="Overseer Stonetongue",
        quest=74566, -- 74448
        npc=201552,
        loot={
            203665, -- Stonetongues Hood
        },
    },
    [60008190] = { label="Liskanoth",
        -- also primalist future @ 53686325
        quest=69928, -- 72057
        worldquest=69928,
        npc=193533,
        loot={
            200743, -- Frozen Footwraps
            200744, -- Glacial Bindings
            200745, -- Horns of the Futurebane
            200746, -- Icebound Girdle
            200763, -- Frosted Scale Drape
        },
    },
    [54608580] = { label="Temporal Investi-gator",
        quest=nil,
        npc=201664,
        loot={
            {206993,toy=true,}, -- Investi-gator's Pocketwatch
            200126, -- Mantle of Copious Chronologies
            200202, -- Tomorrow's Chains
            {200148, toy=true,}, -- A Collection of Me
        },
        note="Finish {quest:75935:Time Signature} questline, then:\n*Get a {item:208449:Melly's Metronographer+++} from {npc:204990:Melly Teletone}\n*Use it by {npc:203769:Bartender Bob}\nBuy {item:208448:Infinitea}\n*Drink it here then (quickly!) use the clock",
    },
    [59807040] = { label="Zal'kir the Chosen",
        quest=nil,
        npc=205865,
        loot={
            208168, -- Black Blade of K'tanth
            208170, -- Runeaxe of the Last Resistance
            208172, -- Bloodstained Runecrook
        },
        path=59376968,
    },
})

-- the future

ns.RegisterPoints(ns.PRIMALISTFUTURE, {
    [48601740] = { label="Shardwing",
        quest=74453,
        npc=201562,
        loot={
            {197593,quest=69797,}, -- Windborne Velocidrake: Feathery Head
            200241, -- Stormcaller's Ritual Hatchet
            200242, -- Watcher's Lightning Rod
            203669, -- Chillwing Leggings
        },
    },
    [52206760] = { label="Avalantus",
        quest=74452,
        npc=201543,
        loot={
            203670, -- Prismatic Diamond Loop
        },
    },
    [61603200] = { label="Tikarr Frostclaw",
        quest=74451,
        npc=201542,
        loot={
            203667, -- Frostclaw's Spellfingers
        },
    },
    [46204120] = { label="Shapemaster Za'lani",
        quest=74454,
        npc=201545,
        loot={
            203668, -- Earhshaping Grips
        },
    },
})
