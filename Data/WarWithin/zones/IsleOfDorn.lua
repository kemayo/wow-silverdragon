local myname, ns = ...

--[[
notes:
Arrival post-intro is 83622

Magni and Merrix chat after restoration: 84815
Alleria and Anduin chat after restoration: 84335
Lufsela chat after Rook Rally: 84813
Merrix and Olbarig chat after Titanic Failsafe: 82541

Earthern coffer 6230
38523951 - in cave from 36354156

Worldsoul Memory
55627771
51212917
]]

-- Treasures

ns.RegisterPoints(ns.ISLEOFDORN, {
    [48513004] = { label="Tree's Treasure",
        criteria=68197,
        quest=83242, -- 82160 when treasure appears
        loot={
            {224585, toy=true}, -- Hanna's Locket
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        note="In cave; talk to {npc:222940:Freysworn Letitia} for a {item:224185:Crab-Guiding Branch}, then go find {npc:222941:Pearlescent Shellcrab} around the zone",
        related={
            [19715844] = {quest=82755},
            [50717055] = {quest=82751},
            [74924940] = {quest=82752},
            [70752001] = {quest=82753, note="On the rocks above the tree"},
            [41822704] = {quest=82754},
            [38364194] = {quest=82756, note="Up in the branches"},
            --
            label="{npc:222941:Pearlescent Shellcrab}",
            color={r=1, g=0.5, b=0.5}, minimap=true,
            requires=ns.conditions.Item(224185), -- Crab-Guiding Branch
            note="Chase away all six crabs then return to {npc:222940:Freysworn Letitia}",
        },
        vignette=6210,
    },
    [40655988] = { label="Magical Treasure Chest",
        criteria=68199,
        quest=83243, -- 82212 for giving Lionel crabs
        loot={
            {224579, pet=3362}, -- Sapphire Crab
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        note="Push {npc:223104:Lionel} into the water, talk to it, then go gather 5x {item:223159:Plump Snapcrab} nearby",
        vignette=6224,
    },
    [54001914] = { label="Mysterious Orb",
        criteria=68201,
        quest=83244, -- 82047 after talking, 82134 after giving, also 82252 when looted
        loot={
            224373, -- Waterlord's Iridescent Gem
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        note="Talk to {npc:222847:Weary Water Elemental}, then go fetch its {item:221504:Elemental Pearl}",
        nearby={53051857, label="{item:221504:Elemental Pearl}"},
        vignette=6208, -- Weary Water Elemental
    },
    [55006564] = { label="Mushroom Cap",
        criteria=68202,
        quest=83245, -- 82142 after giving cap, 82253 as well on loot
        loot={
            210796, -- Mycobloom
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        note="Talk to {npc:222894:U'llort the Self-Exiled} then fetch a {item:221550:Boskroot Cap} from the nearby woods",
        vignette=6209,
    },
    [38074358] = { label="Thak's Treasure",
        criteria=68203,
        quest=82246,
        loot={
            212498, -- Ambivalent Amber
            212511, -- Ostentatious Onyx
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        note="Talk to {npc:223227:One-Eyed Thak} and follow him to the treasure",
        vignette=6236,
    },
    [59622459] = { label="Mosswool Flower",
        criteria=68204,
        quest=82145, -- when flower spawns
        loot={
            {224450, pet=4527}, -- Lil' Moss Rosy
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        nearby={
            -- In this order: (but no helpful quests)
            -- 59622459, -- 222956
            59102706, -- 222963
            59752870, -- 222965
            label="{npc:222956:Lost Mosswool}",
        },
        routes={{59622459, 59102706, 59752870}},
        minimap=true,
        note="Chase {npc:222956:Lost Mosswool} to the flower",
        vignette=6212,
    },
    [59722869] = { label="Mosswool Flower",
        criteria=68204,
        quest=83246, -- 82251 also when looted
        loot={
            {224450, pet=4527}, -- Lil' Moss Rosy
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        hide_before=ns.conditions.QuestComplete(82145),
        note="Chase {npc:222956:Lost Mosswool} to the flower; if another player has recently looted if you may have to wait for it to appear",
        vignette=6238,
    },
    [62574327] = { label="Kobold Pickaxe",
        criteria=68205,
        quest=82325,
        loot={
            223484, -- Kobold Mastermind's "Pivel"
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        vignette=6273,
        note="Despawns for a while after someone loots it, so you might need to wait around",
    },
    [77232446] = { label="Jade Pearl",
        criteria=68206,
        quest=82287,
        loot={
            223280, -- Jade Pearl
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        vignette=6262,
        note="Despawns for a while after someone loots it, so you might need to wait around",
    },
    [48896086] = { label="Shimmering Opal Lily",
        criteria=68207,
        quest=82326,
        loot={
            213197, -- Null Lotus
            210800, -- Luredrop
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        path=47316149,
        note="At the bottom of the cave; despawns for a while after someone loots it, so you might need to wait around",
        vignette=6274,
    },
    [56226094] = { label="Infused Cinderbrew",
        criteria=68208,
        quest=82714,
        loot={
            224263, -- Infused Fire-Honey Milk
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        note="On the desk; despawns for a while after someone loots it, so you might need to wait around",
        vignette=6292,
    },
    [59122347] = { label="Web-Wrapped Axe",
        criteria=68209,
        quest=82715,
        loot={
            224290, -- Storm Defender's Axe
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        note="Inside the building; despawns for a while after someone loots it, so you might need to wait around",
        vignette=6293,
    },
}, {
    achievement=40434, -- Treasures
})
-- Turtle's Thanks
ns.RegisterPoints(ns.ISLEOFDORN, {
    [40917377] = { label="Turtle's Thanks (initial)",
        criteria=68198,
        quest=79585, -- pike
        loot={
            {224549,pet=4594}, -- Sewer Turtle Whistle
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        note="Give {npc:223338:Dalaran Sewer Turtle} 5x {item:220143:Dornish Pike}, then leave the area and return to give it 1x {item:222533:Goldengill Trout}. Then go find it again in Dornegal.",
        active=ns.conditions.Item(220143, 5),
        vignette=6244,
    },
    [40917376] = { label="Turtle's Thanks (after pike)",
        criteria=68198,
        quest=79586, -- trout
        loot={
            {224549,pet=4594}, -- Sewer Turtle Whistle
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        note="Give {npc:223338:Dalaran Sewer Turtle} 1x {item:222533:Goldengill Trout}. Then go find it again in Dornegal.",
        active=ns.conditions.Item(222533),
        vignette=6245,
    },
}, {achievement=40434}) -- Treasures
ns.RegisterPoints(ns.DORNOGAL, {
    [58283027] = { label="Turtle's Thanks (after trout)",
        achievement=40434, -- Treasures
        criteria=68198,
        quest=82716, -- final!, also 82255 when treasure spawns
        loot={
            {224549,pet=4594}, -- Sewer Turtle Whistle
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        requires=ns.conditions.QuestComplete(79586), -- moves here
        note="Talk to the turtle to spawn the treasure",
        vignette=6246, -- Dalaran Sewer Turtle, then 6579 Turtle's Thanks
        parent=true,
    },
})

ns.RegisterPoints(ns.ISLEOFDORN, {
    [31445131] = { --- Dog!
        label="Half-Buried Dog Bowl",
        quest=83094, -- 83093 for calling Dog
        loot={
            {224766, pet=4596}, -- Faithful Dog
            -- no rep, shockingly
        },
        active={
            ns.conditions.QuestComplete(30526), -- Recruiting Dog in Pandaria
            ns.conditions.QuestComplete(46952), -- Bringing Dog to Dalaran in Legion
        },
        note="{npc:225486:Dog} will be here if you've completed their quest chain across previous expansions. If you haven't... go recruit them as part of the Tillers in Pandaria, then get them to move from your Draenor garrison to the Legion version of Dalaran...",
        minimap=true,
    },

    [29063621] = {
        loot={220770}, -- Void-Scarred Stormhammer
        requires=ns.conditions.Class("HUNTER"),
        note="Use to call down {npc:213428:Aradan} to tame in {zone:2315:The Rookery}",
        atlas="paw-icon",
        backdrop=ns.atlas_texture("CircleMask", {r=0, g=0, b=0}),
        border=ns.atlas_texture("pet-list_default-ring", 1.2),
    },
})

ns.RegisterPoints(2315, {-- The Rookery (Landing)
    [11851904] = {
        label="{npc:213428:Aradan}",
        requires=ns.conditions.Class("HUNTER"),
        active=ns.conditions.Item(220770), -- Void-Scarred Stormhammer
        note="Collect the {item:220770:Void-Scarred Stormhammer} in {zone:2248:Isle of Dorn} first. Get here by going up the stairs after jumping down after {npc:209230:Kyrioss}. Use the {item:220770:Void-Scarred Stormhammer} to call down {npc:213428:Aradan} to tame.",
        atlas="paw-icon",
        backdrop=ns.atlas_texture("CircleMask", {r=0, g=0, b=0}),
        border=ns.atlas_texture("pet-list_default-ring", 1.2),
    },
})

-- Rares

ns.RegisterPoints(ns.ISLEOFDORN, {
    [22985829] = { label="Alunira",
        criteria=68225,
        quest=82196,
        npc=219281,
        loot={{223270, mount=2176}},
        active={ns.conditions.Item(224025, 10), ns.conditions.Item(224026)},
        note="Get 10x {item:224025:Crackling Shard} from zone mobs, combine into {item:224026:Storm Vessel}, use to break the shield",
        vignette=6055,
        --routes={{16606120,23205840}},
    },
    [72043881] = { label="Tephratennae",
        criteria=68229,
        quest=81923, -- 84037
        npc=221126,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84037}),
            223922, -- Cinder Pollen Cloak
            223937, -- Honey Deliverer's Leggings
        },
        -- tameable=true, -- wasp
        vignette=6112,
    },
    [57003460] = { label="Warphorn",
        criteria=68213,
        quest=81894,
        npc=219263,
        loot={
            223341, -- Warphorn's Resilient Mane
            223342, -- Warphorn's Resilient Chestplate
            223343, -- Warphorn's Resilient Chainmail
            223344, -- Warphorn's Resilient Vest
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        routes={{57003460, 58403560, 58403680, 57803780, 56603840, 56003780, 56403660, loop=true,}},
        vignette=6044,
    },
    [48202703] = { label="Kronolith, Might of the Mountain",
        criteria=68220,
        quest=81902, -- 84031
        npc=219270,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84031}),
            221210, -- Grips of the Earth
            221254, -- Earthshatter Lance
            221507, -- Earth Golem's Wrap
        },
        vignette=6051,
    },
    [74082756] = { label="Shallowshell the Clacker",
        criteria=68221,
        quest=81903, -- 84032
        npc=219278,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84032}),
            221224, -- Bouldershell Waistguard
            221233, -- Deephunter's Bloody Hook
            221255, -- Sharpened Scalepiercer
            221234, -- Tidal Pendant
            221248, -- Deep Terror Carver
        },
        vignette=6052,
    },
    [41137679] = { label="Bloodmaw",
        criteria=68214,
        quest=81893,
        npc=219264,
        loot={
            223349, -- Wolf Packleader's Cowl
            223350, -- Wolf Packleader's Helm
            223351, -- Wolf Packleader's Hood
            223370, -- Wolf Packleader's Visor
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        vignette=6045,
    },
    [58766068] = { label="Springbubble",
        criteria=68212,
        quest=81892,
        npc=219262,
        loot={
            223356, -- Shoulderpads of the Steamsurger
            223357, -- Spaulders of the Steamsurger
            223358, -- Mantle of the Steamsurger (name matches, but not listed?)
            223359, -- Epaulets of the Steamsurger
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        vignette=6043,
    },
    [62776842] = { label="Sandres the Relicbearer",
        criteria=68211,
        quest=79685,
        npc=217534,
        loot={
            223376, -- Band of the Relic Bearer
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        vignette=6026,
    },
    [55712727] = { label="Clawbreaker K'zithix",
        criteria=68224,
        quest=81920, -- 84036
        npc=221128,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84036}),
            223140, -- Formula: Enchant Cloak - Chant of Burrowing Rapidity
        },
        vignette=6115,
    },
    [47946014] = { label="Emperor Pitfang",
        criteria=68215,
        quest=81895,
        npc=219265,
        loot={
            223345, -- Viper's Stone Grips
            223346, -- Viper's Stone Handguards
            223347, -- Viper's Stone Mitts
            223348, -- Viper's Stone Gauntlets
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        vignette=6046,
        note="At the bottom of the cave",
    },
    [25784503] = { label="Escaped Cutthroat",
        criteria=68218,
        quest=81907, -- 84029
        npc=219266,
        vignette=6049,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84029}),
            221208, -- Unseen Cutthroat's Tunic
            221235, -- Dark Agent's Cloak
        },
    },
    [73004010] = { label="Matriarch Charfuria",
        criteria=68231,
        quest=81921, -- 84039
        npc=220890,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84039}),
            223948, -- Stubborn Wolf's Greathelm
            221247, -- Cavernous Critter Shooter
            221251, -- Bestial Underground Cleaver
            221265, -- Charm of the Underground Beast
            221246, -- Fierce Beast Staff
        },
        vignette=6114,
    },
    [57461625] = { label="Tempest Lord Incarnus",
        criteria=68219,
        quest=81901,
        npc=219269,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84030}),
            221230, -- Storm Bindings
            221236, -- Stormbreaker's Shield
        },
        vignette=6050,
    },
    [53348006] = { label="Gar'loc",
        criteria=68217,
        quest=81899, -- 84028
        npc=219268,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84028}),
            221222, -- Water-Imbued Spaulders
            221234, -- Tidal Pendant
            221248, -- Deep Terror Carver
            221255, -- Sharpened Scalepiercer
            221233, -- Deephunter's Bloody Hook
        },
        vignette=6048,
    },
    [57072279] = { label="Twice-Stinger the Wretched",
        criteria=68222,
        quest=81904, -- 84033
        npc=219271,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84033}),
            221219, -- Silkwing Trousers
            221239, -- Spider Blasting Blunderbuss
            221506, -- Arachnid's Web-Sown Guise
        },
        -- tameable=true, -- blood beast
        vignette=6053,
    },
    [36477505] = { label="Rustul Titancap",
        criteria=68210,
        quest=78619,
        npc=213115,
        loot={
            223364, -- Wristwraps of the Titancap
            223365, -- Wristguards of the Titancap
            223366, -- Bracers of the Titancap
            223367, -- Cuffs of the Titancap
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        vignette=5959,
        note="Wanders the quarry",
    },
    [63994055] = { label="Flamekeeper Graz",
        criteria=68223,
        quest=81905, -- 84034
        npc=219279,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84034}),
            221244, -- Flamekeeper's Footpads
            221249, -- Kobold Rodent Squasher
        },
        vignette=6054,
    },
    [50876984] = { label="Plaguehart",
        criteria=68216,
        quest=81897, -- 84026
        npc=219267,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84026}),
            221213, -- Shawl of the Plagued
            221265, -- Charm of the Underground Beast
            221246, -- Fierce Beast Staff
            221251, -- Bestial Underground Cleaver
            221247, -- Cavernous Critter Shooter
        },
        --tameable=true, -- stag
        vignette=6047,
    },
    [69853847] = { label="Sweetspark the Oozeful",
        criteria=68230,
        quest=81922, -- 84038
        npc=220883,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=84038}),
            223929, -- Honey Sweetener's Squeezers
            223921, -- Ever-Oozing Signet
            223920, -- Slime Deflecting Stopper
        },
        vignette=6113,
    },
    -- Violet Hold prisoners:
    -- These all technically spawn exactly at 30915238
    [29915238] = { label="Kereke",
        criteria=68227,
        quest=82204, -- 85160
        npc=222378,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=85160}),
            226111, -- Arakkoan Ritual Staff
            226113, -- Kereke's Flourishing Sabre
            226114, -- Windslicer's Lance
        },
        vignette=6215,
        note="Violet Hold Prisoner",
    },
    [30915238] = { label="Zovex",
        criteria=68226,
        quest=82203, -- 85159
        npc=219284,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=85159}),
            226117, -- Dalaran Guardian's Arcanotool
            226118, -- Arcane Prisoner's Puncher
            226119, -- Arcane Sharpshooter's Crossbow
        },
        vignette=6058,
        note="Violet Hold Prisoner",
    },
    [31915238] = { label="Rotfist",
        criteria=68228,
        quest=82205, -- 85161
        npc=222380,
        loot={
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150, {quest=85161}),
            226112, -- Rotfist Flesh Carver
            226115, -- Contaminating Cleaver
            226116, -- Coagulating Phlegm Churner
        },
        vignette=6216,
        note="Violet Hold Prisoner",
    },
}, {
    achievement=40435, -- Adventurer
})

ns.RegisterPoints(ns.ISLEOFDORN, {
    [31495529] = { label="Malfunctioning Spire",
        quest=81891,
        npc=220068,
        loot={
            210931, -- Bismuth
            210934, -- Aqirite
            210937, -- Ironclaw Ore
            210939, -- Null Stone
            ns.rewards.Currency(ns.CURRENCY_DORNOGAL, 150),
        },
        vignette=6073,
    },
    -- [46003180] = { -- Rowdy Rubble
    --     quest=81515,
    --     npc=220846,
    --     vignette=6102,
    -- },
    [69204960] = { label="Elusive Ironhide Maelstrom Wolf",
        quest=nil,
        npc=224515,
        requires=ns.conditions.Profession(ns.PROF_WW_SKINNING),
        active=ns.conditions.Item(219007), -- Elusive Creature Lure
    },
})
