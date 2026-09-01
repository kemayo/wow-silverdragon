local myname, ns = ...

local path = ns.path
local CAVE = "Cave entrance"

--[[
Mugrem the Soul Destroyer, 178002, 64116 + 63854 + 64693
]]

local rift_active = {
    ns.conditions.AuraActive(352795), ns.conditions.AuraActive(354870), any=true,
    note="You need to be in the rift to see this",
}

ns.RegisterPoints(1543, {
    -- Better to Be Lucky Than Dead
    [25933116] = { label="Adjutant Dekaris",
        achievement=14744, criteria=49841,
        quest=57482,
        npc=157964,
        loot={
            186222, -- Grips of the Coldheart Adjutant
        },
        vignette=3832,
        --level=60,
    },
    [19304170] = { label="Apholeias, Herald of Loss",
        achievement=14744, criteria=49842,
        quest=60788,
        npc=170301,
        loot={
            182327, -- Dominion Etching Loss
            184106, -- Gimble
        },
        note="Need three players to summon",
        --level=60,
    },
    [38944119] = { label="Borr-Geth",
        achievement=14744, criteria=49843,
        quest=57469,
        npc=157833,
        loot={
            {184312, toy=true}, -- Borr-Geth's Fiery Brimstone
            186223, -- Coif of the Molten Terror
        },
        vignette=3830,
        --level=60,
    },
    [27731305] = { label="Conjured Death",
        achievement=14744, criteria=49844,
        quest=61106, -- 58013
        npc=171317,
        loot={
            183887, -- Suirhtaned, Blade of the Heir
        },
        --level=60,
    },
    [60954805] = { label="Darithis the Bleak",
        achievement=14744, criteria=49845,
        quest=62281,
        npc=160770,
        loot={
            186220, -- Stygian Chestcage
        },
        --level=60,
    },
    [49128175] = { label="Darklord Taraxis",
        achievement=14744, criteria=49846,
        quest=62282,
        npc=158025,
        loot={
            {183901,toy=true}, -- Bonestorm Top
            186611, -- Taraxis' Treads
        },
        --level=60,
    },
    [28106060] = { label="Dolos",
        achievement=14744, criteria=49847,
        quest=60909,
        npc=170711,
        loot={
            186209, -- Blood-Spattered Gloves of Death
        },
        --level=60,
    },
    [23755340] = { label="Eketra",
        achievement=14744, criteria=49848,
        quest=60915,
        npc=170774,
        loot={
            186563, -- Spear of the Impaler
        },
        --level=60,
    },
    [42352110] = { label="Ekphoras, Herald of Grief",
        achievement=14744, criteria=49849,
        quest=60666,
        npc=169827,
        loot={
            182328, -- Dominion Etching: Grief
            184105, -- Gyre
        },
        note="Need three players to summon",
        --level=60,
    },
    [19204610] = { label="Eternas the Tormentor",
        achievement=14744, criteria=49850,
        quest=57509,
        npc=154330,
        loot={
            {183407,pet=3037,}, -- Contained Essence of Dread
            186212, -- Eternas' Braided Waistcord
        },
        --level=60,
    },
    [20606935] = { label="Exos, Herald of Domination",
        achievement=14744, criteria=49851,
        quest=62260,
        npc=170303,
        loot={
            184108, -- Vorpal Amulet
            {183066,quest=63160,}, -- Korrath's Grimoire: Aleketh
            {183067,quest=63161,}, -- Korrath's Grimoire: Belidir
            {183068,quest=63162,}, -- Korrath's Grimoire: Gyadrek
            186606, -- Nilganihmaht's Signet Ring
        },
        note="Get the etching from the three other Heralds, combine into {item:182329}, and use to summon",
        --level=60,
    },
    [53507950] = { label="Gorged Shadehound",
        achievement=14738, criteria=49251,
        npc=174827,
        -- quest=61124,
        vignette=4460,
        label="{npc:174827}",
        loot={
            {184167,mount=1304,}, -- Mawsworn Soulhunter
        },
        note="Only during the Hunt:Shadehounds event, mount is not a guaranteed drop",
    },
    [30775000] = { label="Ikras the Devourer",
        achievement=14744, criteria=50621,
        quest=62788,
        npc=175012,
        loot={
            186214, -- Maw Snakeskin Boots
        },
        note="Flies around",
        --level=60,
    },
    [16955100] = { label="Morguliax",
        achievement=14744, criteria=49852,
        quest=60987,
        npc=162849,
        loot={
            {184292, toy=true}, -- Ancient Elethium Coin
            185892, -- Stygia-Etched Decapitator
        },
        --level=60,
    },
    [45507375] = { label="Nascent Devourer",
        achievement=14744, criteria=49853,
        quest=57573,
        npc=158278,
        loot={
            186236, -- Devourer's Shadehide Jerkin
        },
        --level=60,
    },
    [48801830] = { label="Obolos",
        achievement=14744, criteria=49854,
        quest=60667,
        npc=164064,
        loot={
            186238, -- Mantle of the Prime Collector
        },
        --level=60,
    },
    [23692142] = { label="Orophea",
        achievement=14744, criteria=49855,
        quest=61519, -- 62722
        npc=172577,
        loot={
            {181794, toy=true}, -- Orophea's Lyre
            186211, -- Pantaloons of the Condemned Bard
        },
        note="Fetch {spell:337150} from 26.7 29.3, use it to summon",
        vignette=4459,
        --level=60,
    },
    [26752930] = { label="Eurydea's Necklace",
        achievement=14744, criteria=49855,
        quest=61519,
        label="{spell:337150}",
        note="Take to {npc:172577} at 23.7 21.4",
        --level=60,
    },
    [32956645] = { label="Shadeweaver Zeris",
        achievement=14744, criteria=49856,
        quest=60884,
        npc=170634,
        loot={
            183187, -- Shadeweaver Incantation
            185945, -- Shadeweaver's Spire
            {183066, quest=63160,}, -- Korrath's Grimoire: Aleketh
            {183067, quest=63161,}, -- Korrath's Grimoire: Belidir
            {183068, quest=63162,}, -- Korrath's Grimoire: Gyadrek
            {181794, toy=true}, -- Orophea's Lyre (weirdly)
        },
        --level=60,
    },
    [35994149] = { label="Soulforger Rhovus",
        achievement=14744, criteria=49857,
        quest=60834,
        npc=166398,
        loot={
            183141, -- Stygic Magma
            186613, -- Rhovus' Linked Greaves
            {185473, quest=63667}, -- Soulforger's Tools (for the Feral Shadehound)
        },
        vignette=4245,
        --level=60,
    },
    [28721205] = { label="Talaporas, Herald of Pain",
        achievement=14744, criteria=49858,
        quest=60789, -- 62722?
        npc=170302,
        loot={
            182326, -- Dominion Etching: Pain
            184107, -- Borogove Cloak
        },
        note="Need three players to summon",
        vignette=4233, -- Convocation of Pain
        --level=60,
    },
    [27407150] = { label="Thanassos",
        achievement=14744, criteria=49859,
        quest=60914,
        npc=170731,
        --loot={},
        --level=60,
    },
    [37656590] = { label="Yero the Skittish",
        achievement=14744, criteria=49860,
        quest=61568,
        npc=172862,
        loot={
            186228, -- Helm of the Skittish Hero
        },
        note="Follow until it becomes hostile",
        --level=60,
    },

    -- It's About Sending A Message
    [20803925] = path{
        label=CAVE,
        achievement=14660,
        criteria={49485,51058},
        quest={61136,63044},
        --level=60,
    },
    [28204450] = { label="Agonix",
        achievement=14660, criteria=49485,
        quest=61136, -- 63380
        npc=169102,
        loot={
            186616, -- Bindings of Screaming Death
        },
        --level=60,
    },
    [34107455] = { label="Akros",
        achievement=14660, criteria=49487,
        quest=60920,
        npc=170787,
        loot={
            186617, -- Death's Hammer Stompers
        },
        --level=60,
    },
    [28702515] = { label="Cyrixia",
        achievement=14660, criteria=49484,
        quest=61346, -- 63379
        npc=168693,
        loot={
            {183070, quest=63164}, -- Mawsworn Orders
            186618, -- Willbreaker's Chain
        },
        vignette=4427,
        --level=60,
    },
    [25761470] = { label="Dartanos",
        achievement=14660, criteria=49476,
        quest=59230, -- 63373
        npc=162452,
        loot={
            186619, -- Bloodspattered Shoulders of the Flayer
        },
        vignette=4383,
        --level=60,
    },
    [19205740] = { label="Dath Rezara",
        achievement=14660, criteria=50410,
        quest=61140,
        npc=162844,
        loot={
            {183066, quest=63160,}, -- Korrath's Grimoire: Aleketh
            {183067, quest=63161,}, -- Korrath's Grimoire: Belidir
            {183068, quest=63162,}, -- Korrath's Grimoire: Gyadrek
            186620, -- Rezara's Fencing Grips
        },
        --level=60,
    },
    [31972124] = { label="Drifting Sorrow",
        achievement=14660, criteria=49475,
        quest=59183,
        npc=158314,
        loot={
            186622, -- Robe of Drifting Sorrow
        },
        vignette=3848,
        --level=60,
    },
    [60456475] = { label="Houndmaster Vasanok",
        achievement=14660, criteria=49490,
        quest=62209,
        npc=172523,
        loot={
            186224, -- Beastwarren Houndmaster's Treads
        },
        vignette=4518,
        --level=60,
    },
    [20802968] = { label="Huwerath",
        achievement=14660, criteria=49481,
        quest=58918,
        npc=162965,
        loot={
            186623, -- Lost Soul's Mantle
        },
        vignette=4379,
        --level=60,
    },
    [30846866] = { label="Krala",
        achievement=14660, criteria=49486,
        quest=63381,
        npc=170692,
        loot={
            186624, -- Death Wing Drape
        },
        --level=60,
    },
    [27341755] = { label="Malevolent Stygia",
        achievement=14660, criteria=49488,
        quest=61125,
        npc=171316,
        loot={
            186625, -- Hood of Malevolence
        },
        vignette=4381,
        --level=60,
    },
    [38642880] = { label="Odalrik",
        achievement=14660, criteria=50408,
        quest=62618, -- 63413?
        npc=172207,
        loot={
            {183061,quest=63158,}, -- Wailing Coin
            178561, -- Runecarver's Memory
        },
        vignette=4573,
        --level=60,
    },
    [25354875] = { label="Orrholyn <Lord of Bloodletting>",
        achievement=14660, criteria=49480,
        quest=60991,
        npc=162845,
        loot={
            186626, -- Bloodwicking Bands
        },
        --level=60,
    },
    [22654225] = { label="Ratgusher",
        achievement=14660, criteria=51058,
        quest=63044, -- 63388 ??
        npc=175821,
        loot={
            186627, -- Belt of Ten Thousand Tails
        },
        --level=60,
    },
    [26183116] = { label="Razkazzar",
        achievement=14660, criteria=49479,
        quest=60992,
        npc=162829,
        loot={
            186628, -- Razkazzar's Axe Grippers
        },
        vignette=4331,
        --level=60,
    },
    [55646319] = { label="Sanngror the Torturer",
        achievement=14660, criteria=49489,
        quest=62210,
        npc=172521,
        loot={
            {183410,pet=3040,}, -- Sharpclaw
            186629, -- Sanngor's Spiked Band
        },
        vignette=4519,
        --level=60,
        path=55806755,
    },
    [54507930] = { label="Skittering Broodmother",
        achievement=14660, criteria=49491,
        quest=62211,
        npc=172524,
        loot={
            186240, -- Broodmotherhide Cloak
        },
        --level=60,
        note="In the Pit of Anguish",
    },
    -- [54558015] = path{label=CAVE, achievement=14660, criteria=49491, quest=62211, routes={{54558015, 54507930}}},
    [36213734] = { label="Soulsmith Yol-Mattar",
        achievement=14660, criteria=49482,
        quest=59441, -- 63377
        npc=165047,
        loot={
            186630, -- Spark-Deflecting Girdle
        },
        vignette=4132,
        --level=60,
    },
    [36854480] = { label="Stygian Incinerator",
        achievement=14660, criteria=50409,
        quest=62539,
        npc=156203,
        loot={
            186631, -- Emberfused Band
        },
        --level=60,
    },
    [40695512] = { label="Valis the Cruel",
        achievement=14660, criteria=49492,
        quest=61728,
        npc=173086,
        loot={
            186632, -- Rune Covered Bindings
        },
        vignette=4503,
        --level=60,
    },

    -- 9.1 additions:

    [69204520] = { label="Helsworn Chest",
        achievement=15099, criteria=52243,
        quest=64256,
        loot={
            187351, -- Stygic Cluster
            185902, -- Iron Maiden's Toolkit
            187014, -- Shackler's Spiked Shoulders
            187018, -- Ritualist's Shoulder Scythes
            187019, -- Infiltrator's Shoulderguards
            187026, -- Field Warden's Torture Kit
            187240, -- Field Warden's Watchful Eye
        },
        note=DAILY,
    },
    [66506227] = { label="Jeweled Heart",
        achievement=15099, criteria=52244,
        quest=64261,
        loot={
            187352, -- Jeweled Heart of Ezekiel
        },
        vignette=4809,
    },

    [27652525] = { label="Torglluun",
        achievement=15107, criteria=52284,
        quest=64232,
        npc=179735,
        loot={
            187360, -- Orb of Enveloping Rifts
            187389, -- Lord of Shade's Binders
            {187139,toy=true}, -- Bottled Shade Heart
            186605, -- Nilganihmaht's Runed Band
        },
        active=rift_active,
        note="In the rift. Drops {item:186605} for {npc:179572:Nilganihmaht}",
    },

    [35904370] = { label="Blinding Shadow",
        achievement=15107, criteria=52297,
        quest=64276,
        npc=179853,
        loot={
            187361, -- Rift-Bound Shadow Piercer
            187406, -- Band of Blinding Shadows
        },
        active=rift_active,
        note="In the rift.",
    },

    [67804740] = { label="Traitor Balthier",
        achievement=15107, criteria=52297,
        quest=64258, -- also 64439
        npc=179805,
        loot={
            187364, -- Maldraxxi Traitor's Blade
            187374, -- Balthier's Waistcord
        },
    },

    [61604160] = { label="Deomen the Vortex",
        achievement=15107, criteria=52286,
        quest=64251,
        npc=179779,
        loot={
            187367, -- Deomen's Vortex Blade
            187385, -- Vortex Piercing Headgear
        },
        note="Unlock cage with levers to the south",
    },

    [53007280] = { label="Guard Orguluus",
        achievement=15107, criteria=52293,
        quest=64272,
        npc=179851,
        loot={
            187363, -- Orguluus' Spear
            187398, -- Chestguard of the Shadeguard
        },
        active=rift_active,
        note="Wanders a bit in the area",
    }

    -- non-achievement
    --[] = { -- Warren Mongrel
    --    quest=61124,
    --    npc=165973,
    --}
})

ns.RegisterPoints(1820, { -- Pit of Anguish - upper level
    [36707940] = { label="Skittering Broodmother",
        achievement=14660, criteria=49491,
        quest=62211,
        npc=172524,
        loot={
            186240, -- Broodmotherhide Cloak
        },
        --level=60,
    },
})

-- Lil'Abom
ns.RegisterPoints(1543, {
    [32215608] = { label="Lil'Abom Head",
        quest=64010,
        label="{item:186183}",
        loot={
            186183, -- Lil'Abom Head
            {186188, pet=3098}, -- Lil'Abom
        },
    },
    [39906260] = { label="Lil'Abom Torso",
        quest=64011,
        label="{item:186184}",
        loot={
            186184, -- Lil'Abom Torso
            {186188, pet=3098}, -- Lil'Abom
        },
    },
    [29356730] = { label="Lil'Abom Legs",
        quest=64013,
        label="{item:186185}",
        loot={
            186185, -- Lil'Abom Legs
            {186188, pet=3098}, -- Lil'Abom
        },
    },
    [38505850] = { label="Lil'Abom Right Hand",
        quest=64008,
        label="{item:186186}",
        loot={
            186186, -- Lil'Abom Right Hand
            {186188, pet=3098}, -- Lil'Abom
        },
        note="In cave",
    },
    [39306650] = { label="Lil'Abom Spare Arm",
        quest=64009,
        label="{item:186187}",
        loot={
            186187, -- Lil'Abom Spare Arm
            {186188, pet=3098}, -- Lil'Abom
        },
    },
}, {
    note="Collect all 5 parts to assemble a pet",
    minimap=true,
})

-- lore:
ns.RegisterPoints(1543, {
    [35754555] = { label="Tormentor's Notes",
        achievement=14761, criteria=49914,
        quest=63163,
        loot={
            183069, -- Tormentor's Notes
        },
        inbag=183069,
        minimap=true,
        note="Look for the body of {npc:173811}",
    },
    [19353340] = { label="Words of the Warden",
        achievement=14761, criteria=49910,
        quest=63159,
        loot={
            183063, -- Word of the Warden
        },
        inbag=183063,
        minimap=true,
        note="Find a Paper Scrap hidden behind some junk",
    },
    [27702020] = ns.path{ -- To: Box of Torments
        achievement=14761, criteria=49908,
        quest=63157,
        onquest=63157,
    },
})

ns.RegisterPoints(1822, { -- Tremaculum
    [73101660] = { label="Box of Torments",
        achievement=14761, criteria=49908,
        quest=63157,
        onquest=63157,
        loot={
            183060, -- Box of Torments
        },
        note="Under the Tremaculum, open {npc:173837}",
    }
})

-- Assaults
local icon_red = ns.atlas_texture("VignetteLoot", {r=1,g=0,b=0,a=1,scale=1})
local icon_green = ns.atlas_texture("VignetteLoot", {r=0,g=1,b=0,a=1,scale=1})
local icon_blue = ns.atlas_texture("VignetteLoot", {r=0,g=0.5,b=1,a=1,scale=1})
local icon_purple = ns.atlas_texture("VignetteLoot", {r=1,g=0,b=1,a=1,scale=1})
local icon_yellow = ns.atlas_texture("VignetteLoot", {r=1,g=1,b=0,a=1,scale=1})
local icon_orange = ns.atlas_texture("VignetteLoot", {r=1,g=0.5,b=0,a=1,scale=1})
local icon_pink = ns.atlas_texture("VignetteLoot", {r=1,g=0.5,b=0.5,a=1,scale=1})
local icon_lightgreen = ns.atlas_texture("VignetteLoot", {r=0.5,g=1,b=0.5,a=1,scale=1})
local icon_lightblue = ns.atlas_texture("VignetteLoot", {r=0.5,g=0.5,b=1,a=1,scale=1})
local ASSAULT_NECRO = {1550, 6989}
local ASSAULT_VENTHYR = {1550, 6990}
local ASSAULT_KYRIAN = {1550, 6991}
local ASSAULT_NIGHTFAE = {1550, 6992}

-- there's also a tracking on 64700

-- Necrolord
ns.RegisterPoints(1543, {
    [34156125] = {quest=64044,texture=icon_red,},
    [36766805] = {quest=64044,texture=icon_red,},
    [23006840] = {quest=64045,texture=icon_green,}, -- inside the Altar
    -- claimed on wowhead, but haven't found yet:
    -- [32306590] = {quest=nil,texture=icon_green,},
    -- [25905530] = {quest=nil,texture=icon_green,},
}, {
    label="Stolen Anima Vessel",
    poi={ASSAULT_NECRO},
    group="Stolen Anima",
})
ns.RegisterPoints(1823, { -- Altar of Domination
    [20105250] = {quest=64045,texture=icon_green,},
}, {
    label="Stolen Anima Vessel",
    poi={ASSAULT_NECRO},
    group="Stolen Anima",
})
ns.RegisterPoints(1543, {
    [28905710] = {quest=64209},
    [30156495] = {quest=63816},
    [30355595] = {quest=63815},
    [32105640] = {quest=63826},
    [32806500] = {quest=63825},
    [33557040] = {quest=63818},
    -- [33805720] = {quest=nil},
    [34106165] = {quest=63817},
    [35066973] = {quest=64209},
}, {
    label="Mawsworn Cache",
    poi={ASSAULT_NECRO},
    loot={
        186573, -- Quartered Ancient Ring
        186600, -- Defense Map
    },
    note="Nilganihmaht. Neither drop is guaranteed...",
})
ns.RegisterPoints(1543, {
    [33656625] = {
        loot={186604}, -- Quartered Ancient Ring
        inbag={186604,186603,any=true,},
        note="Nilganihmaht. Spawns somewhat randomly...",
        poi={ASSAULT_NECRO},
    }
})
-- Venthyr
ns.RegisterPoints(1543, {
    [23431665] = {quest=64055,texture=icon_red,},
    [25201250] = {quest=64055,texture=icon_red,},
    [27401650] = {quest=64055,texture=icon_red,},
    [27801950] = {quest=64055,texture=icon_red,},
    [26201960] = {quest=64056,texture=icon_green,},
    [29601160] = {quest=64056,texture=icon_green,},
    [32701480] = {quest=64056,texture=icon_green,},
    [28502100] = {quest=64056,texture=icon_green,note="In the Extractor's Sanatorium",},
}, {
    label="Stolen Anima Vessel",
    poi={ASSAULT_VENTHYR},
    group="Stolen Anima",
})
ns.RegisterPoints(1822, { -- Extractor's Sanatorium
    [73705060] = {quest=64056,texture=icon_green,},
}, {
    label="Stolen Anima Vessel",
    poi={ASSAULT_VENTHYR},
    group="Stolen Anima",
})
-- Kyrian
ns.RegisterPoints(1543, {
    [32604090] = {quest=64057,texture=icon_red,},
    [32604340] = {quest=64057,texture=icon_red,},
    [37504500] = {quest=64057,texture=icon_red,},
    [34103580] = {quest=64058,texture=icon_green,},
    [36604010] = {quest=64058,texture=icon_green,},
    [38354870] = {quest=64058,texture=icon_green,},
    [45404775] = {quest=64058,texture=icon_green,},
}, {
    label="Stolen Anima Vessel",
    poi={ASSAULT_KYRIAN},
    group="Stolen Anima",
})
ns.RegisterPoints(1543, {
    [29954327] = {
        label="{npc:173533:Sinfall Screecher}",
        poi={ASSAULT_KYRIAN},
        loot={
            {186544, pet=3010}, -- Sinfall Screecher
        },
        note="Kill the {npc:177966:Chain of Domination} and open the cage",
    },
})
ns.RegisterPoints(1543, {
    -- A Sly Fox
    [42154450] = {
        label="{npc:179068:Orator Kloe}",
        note="Talk and get the {spell:353322} buff, then go find {npc:179083:Sly}",
    },
    [40705160] = {quest={64019,64024,any=true},},
    [38053975] = {quest={64019,64022,any=true},hide_before=ns.conditions.QuestComplete(64024),},
    [32904420] = {quest={64019,64023,any=true},hide_before=ns.conditions.QuestComplete(64022),},
}, {
    achievement=15004,
    label="{npc:179083:Sly}",
    -- progress={64024,64022,64023}, -- covered by the achievement-progress
    atlas="wildbattlepetcapturable",
    minimap=true,
    poi={ASSAULT_KYRIAN},
    loot={
        {186539, pet=3101}, -- Sly
    }
})
-- Night Fae
ns.RegisterPoints(1543, {
    [19103320] = {quest=64059,texture=icon_red,},
    [25303330] = {quest=64059,texture=icon_red,},
    [25303820] = {quest=64059,texture=icon_red,},
    [27804180] = {quest=64059,texture=icon_red,},
    [17304780] = {quest=64060,texture=icon_green,},
    [18604260] = {quest=64060,texture=icon_green,},
    [18905030] = {quest=64060,texture=icon_green,},
    [22704850] = {quest=64060,texture=icon_green,},
}, {
    label="Stolen Anima Vessel",
    poi={ASSAULT_NIGHTFAE},
    group="Stolen Anima",
})
ns.RegisterPoints(1543, {
    [19104620] = {quest=63993,texture=icon_red,},
    [20604740] = {quest=63993,texture=icon_red,},
    [22604625] = {quest=63993,texture=icon_red,},
    [25304920] = {quest=63995,texture=icon_green,},
    [20702980] = {quest=63996,texture=icon_orange,},
    [25102705] = {quest=63996,texture=icon_orange,},
    [24603690] = {quest=63997,texture=icon_pink,},
    [26403760] = {quest=63997,texture=icon_pink,},
    [18903970] = {quest=63998,texture=icon_lightgreen,},
    [19153335] = {quest=63998,texture=icon_lightgreen,},
    [19054400] = {quest=63998,texture=icon_lightgreen,},
    [23203580] = {quest=63998,texture=icon_lightgreen,},
    [29754280] = {quest=63999,texture=icon_lightblue,},
}, {
    achievement=15001, -- Jailer's Personal Stash
    label="Rift Hidden Cache",
    active=rift_active,
    poi={ASSAULT_NIGHTFAE},
    loot={
        187251, -- Shaded Skull Shoulderguards
    },
    group="Rift Hidden Caches",
})
ns.RegisterPoints(1543, {
    [23104225] = {
        quest=64000,
        label="{item:186191:Infused Etherwyrm}",
        loot={
            {186191, pet=3099}, -- Infused Etherwyrm
        },
        note="When the {quest:63951} quest is available, find the {item:186190} from the {npc:179030:Elusive Keybinder} in the rift phase, then bring it to the cage inside the Desolate Hollow",
        path={23104225, label="Desolate Hollow entrance"},
    },
    [23804050] = {
        label="{npc:179030:Elusive Keybinder}",
        loot={186190}, -- Etherwyrm Cage Key
        note="In the rift, loot the key",
    },
}, {
    quest=64000,
    atlas="wildbattlepetcapturable",
    minimap=true,
    poi={ASSAULT_NIGHTFAE},
})

-- Rifts
ns.RegisterPoints(1543, {
    [47457620] = {quest=64265,texture=icon_blue,note="In rift, in cave",},
    [47808650] = {quest=64265,texture=icon_blue,note="In rift, in Death's Roar",},
    [51008545] = {quest=64265,texture=icon_blue,note="In rift, in Death's Howl",},
    [32404310] = {quest=64269,texture=icon_purple,},
    [35704620] = {quest=64269,texture=icon_purple,},
    [36254215] = {quest=64269,texture=icon_purple,},
    [38454845] = {quest=64269,texture=icon_purple,note="In rift, in cave",},
    [44554760] = {quest=64269,texture=icon_purple,},
    [27454950] = {quest=64270,texture=icon_yellow,},
}, {
    label="Stolen Anima Vessel",
    active=rift_active,
    poi={ASSAULT_NECRO, ASSAULT_VENTHYR, ASSAULT_KYRIAN, ASSAULT_NIGHTFAE},
    group="Stolen Anima",
})

-- Fallen Charger
ns.RegisterPoints(1543, {
    [16274949] = {
        poi={ASSAULT_NIGHTFAE, ASSAULT_VENTHYR},
    },
    [27906290] = {
        poi={ASSAULT_NECRO},
    },
    [31803850] = {
        poi={ASSAULT_KYRIAN},
    }
}, {
    achievement=15107, criteria=52292,
    quest=64164, -- also 63180, 63433
    npc=179460,
    loot={
        {186659, mount=1502}, -- Fallen Charger's Reins
    },
    atlas="stablemaster",
    note="Yells, runs from its spawn point to Korthia, then despawns",
})

-- Zovaal's Vault
ns.RegisterPoints(1543, {
    [33606630] = {},
    [47257968] = {},
    [62176427] = {},
    [66405820] = {},
}, {
    label="{npc:179883}",
    quest=64283,
    atlas="VignetteLootElite", scale=1.3,
    active=rift_active,
    loot={
        187251, -- Shaded Skull Shoulderguards
        {187113, toy=true}, -- Personal Ball and Chain
        {187416, toy=true}, -- Jailer's Cage
    },
    note="In the rift, get {quest:64282} from {npc:179904:Ve'nari} @ 44.5, 51.5, then drag {npc:179883} back. You can drag it back before getting the quest, but you have to put it down before you can accept the quest.",
})
ns.RegisterPoints(1543, {
    [44805140] = {
        label="{npc:179904:Ve'nari}",
        atlas="questdaily", scale=1.2,
        active=rift_active,
        -- requires_buff=355650, -- Zovaal's Vault Chain
        quest=64283,
        note="Get {quest:64282} here, find {npc:179883}, and drag it back here",
    },
})

-- Nilganihmaht
local helgarde = ns.nodeMaker{
    quest=62682,
    label="Helgarde Supply Cache",
    loot={186727}, -- Seal Breaker Key
    note="For the Domination Chest",
    minimap=true,
    scale=0.8,
}
ns.RegisterPoints(1543, {
    [25503680] = {
        label="{npc:179572:Nilganihmaht}",
        quest=64202, -- signet:64201, silver:64200, gold:64199, runed:64198, stone: 64197
        -- requires_item={186603, 186605, 186606, 186607, 186608},
        texture=ns.atlas_texture("VignetteLootElite", {scale=1.5, r=0, g=0.5, b=1}),
        -- atlas="VignetteLootElite", scale=1.5,
        active=rift_active,
        loot={
            {186713, mount=1503}, -- Hand of Nilganihmaht
        },
        note=function()
            local function q(quest)
                return CreateAtlasMarkup(C_QuestLog.IsQuestFlaggedCompleted(quest) and "common-icon-checkmark" or "common-icon-redx")
            end
            return "In a cave in the rift. Bring the 5 rings.\n"..
                q(64197).."{item:186603:Stone Ring}: assemble during a Necrolord Assault if {quest:63545} is up\n"..
                q(64198).."{item:186605:Runed Band}: kill {npc:179735:Torglluun}\n"..
                q(64201).."{item:186606:Signet Ring}: kill {npc:170303:Exos}\n"..
                q(64200).."{item:186607:Silver Ring}: loot the Domination Chest\n"..
                q(64199).."{item:186608:Gold Band}: climb to find it"
        end,
        path={25053270, label="Hollow of the Insolent"},
    },
    -- Silver Ring
    [66055740] = {
        quest=64207,
        label="Domination Chest",
        atlas="VignetteLootElite", scale=1.2,
        minimap=true,
        progress={64204,64205,64206,64208},
        loot={186607}, -- Nilganimahts Silver Ring
        note=function()
            local function q(quest, label)
                return (C_QuestLog.IsQuestFlaggedCompleted(quest) and GREEN_FONT_COLOR or RED_FONT_COLOR):WrapTextInColorCode(label)
            end
            return "Bring 4x {item:186727} to unlock.\n"..
                "* "..q(62683, "Kill {npc:177444}").."\n"..
                "* "..q(62679, "Kill {npc:177134:Maldraxxi Defector} until it drops").."\n"..
                "* "..q(62682, "Loot Helgarde Supply Caches").."\n"..
                "* "..q(62680, "Pick up the Harrower's Key Ring")
        end,
    },
    [66404190] = { label="Ylva",
        achievement=15107, criteria=52287,
        quest=64152,
        npc=177444,
        loot={
            186217, -- Supple Helhound Leather Pants
            187359, -- Ylva's Water Dish
            187393, -- Sterling Hound-Handler's Gauntlets
            {186970, quest=62683, note="{item:186727}"}, -- Feeder's Hand and Key / Seal Breaker Key
            ns.rewards.Achievement(14943), -- Guarmageddon
        },
        note="Drops {item:186727} for {npc:179572:Nilganihmaht}",
    },
    [66905620] = {
        quest=62680,
        label="The Harrower's Key Ring",
        minimap=true,
        loot={186727}, -- Seal Breaker Key
        note="For the Domination Chest",
    },
    [62456180] = helgarde(),
    [65706120] = helgarde(),
    [67555570] = helgarde(),
    [68204810] = helgarde(),
    [62455530] = helgarde(),

    -- Gold Band
    [19203225] = {
        quest=64199,
        label="{item:186608}",
        loot={
            186608, -- Nilganihmaht's Gold Band
        },
        route=18503925,
        inbag=186608,
        minimap=true,
        path={18503925, r=0,g=1,b=1, note="Look for the grapple point, then run to the base of the spire",},
    },
}, {
    group="Nilganihmaht",
})

-- Teleporters

ns.RegisterPoints(1543, {
    [42384216] = {
        label="Waystone to Oribos",
        atlas="adventures-32x32", scale=1.2,
        minimap=true,
        group="Transportation",
    },
})

local riftstone = ns.nodeMaker{
    label="{npc:174962}",
    atlas="WarlockPortalHorde", scale=1.3,
    active=ns.conditions.QuestComplete(63177),
    note="Buy access from {npc:162804}",
    group="Transportation",
}
local rift_three = ns.atlas_texture("WarlockPortalAlliance", {r=0,g=0.75,b=0.75,a=1,scale=1})
-- Chaotic Riftstones
ns.RegisterPoints(1543, {
    -- First pair: Tremaculum / Crucible
    [19204780] = riftstone{route=25201785,},
    [25181787] = riftstone{routes={{19204780,25201785,r=0.75,g=0,b=0}},},
    -- Second pair: Calcis / Cauldron of Flame
    [23483123] = riftstone{atlas="WarlockPortalAlliance",route=34804360,},
    [34804360] = riftstone{atlas="WarlockPortalAlliance",routes={{23453120,34804360,r=0,g=0,b=0.75}},},
    -- Third pair: Perdition Hold / Desmotaeron
    [33905665] = riftstone{texture=rift_three,routes={{33905665,68753675,r=0,g=0.75,b=0.75}},},
    [68753675] = riftstone{texture=rift_three,route=33905665,},
}) -- vignette=1543

-- Animaflow
ns.RegisterPoints(1543, {
    [34201475] = {}, -- Tremaculum
    [53406365] = {}, -- Beastwarrens (also gated behind Rule 6)
    [33955675] = {}, -- Perdition Hold
    [68903680] = { label="Desmotaeron",
        active={
            ns.conditions.QuestComplete(61600), ns.conditions.Achievement(15126),
        },
    },
}, {
    label="{npc:172925} " .. EXIT,
    atlas="MagePortalAlliance",
    active=ns.conditions.QuestComplete(61600),
    note="Buy access from {npc:162804}",
    scale = 1.2,
    group="Transportation",
})
