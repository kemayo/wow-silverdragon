local myname, ns = ...

local path = ns.path

local RELIC_FRAGMENT = 186685 -- relic fragment
local rift_active = {
    ns.conditions.AuraActive(352795), ns.conditions.AuraActive(354870), any=true,
    note="You need to be in the rift to see this",
}

ns.groups["dailymount"] = "Daily Mounts"
ns.groups["mawsworncache"] = "Mawsworn Caches"
ns.groups["riftboundcache"] = "Riftbound Caches"
ns.groups["relic"] = "Relics"
ns.groups["nests"] = "Nests of Unusual Materials"
ns.groups["mawshrooms"] = "Invasive Mawshrooms"
ns.groups["riftportal"] = "Rift Portals"

local researched = ns.nodeMaker{
    IsActive = function(point)
        local info = C_Reputation.GetFactionDataByID(2472)
        if info and info.currentStanding then
            return info.currentStanding >= point.research
        end
    end,
}

ns.RegisterPoints(1961, { -- Korthia
    [29505345] = { label="Anima Laden Egg",
        achievement=15099, criteria=52241,
        quest=64244,
        loot={
            187349, -- Anima Laden Egg
        },
    },

    [47502920] = { label="Dislodged Nest",
        achievement=15099, criteria=52240,
        quest=64241,
        minimap=true,
        loot={
            {187339, toy=true}, -- Silver Shardhide Whistle
        },
        note="Get {spell:355181} from a Noxious Moth; use {spell:355131} on {npc:178547} and ride into the tree",
    },

    [50458445] = { label="Displaced Relic",
        achievement=15099, criteria=52242,
        quest=64252,
        loot={
            187350, --Displaced Relic (300 research)
        },
    },

    [68902990] = { label="Forgotten Feather",
        achievement=15099, criteria=52237,
        quest=64234,
        loot={
            {187051, toy=true}, -- Forgotten Feather
        },
        note="Jump down from Keeper's Respite",
    },

    [38354294] = { label="Glittering Nest Materials",
        achievement=15099, criteria=52236,
        quest=64222,
        vignette=4781,
    },

    [42505595] = { label="Infected Vestige",
        achievement=15099, criteria=52245,
        quest=64264,
        loot={
            187354, -- Abandoned Broker Satchel
        },
        note="In cave",
    },

    [52901475] = { label="Lost Memento",
        achievement=15099, criteria=52238,
        quest=64238,
    },

    [45356715] = { label="Offering Box",
        achievement=15099, criteria=52246,
        quest=64268,
        -- requires_item=187033,
        loot={
            {187344, toy=true}, -- Offering Kit Maker
        },
        note="Find {item:187033} in the nearby ruins, on the top of the west wall",
    },
    [43556770] = path({achievement=15099, criteria=52246, quest=64268, inbag=187033, label="{item:187033}", atlas="MantidTower"}), -- Small Offering Key

    [62055551] = { label="Spectral Bound Chest",
        quest=64247,
        -- vignette=4801 locked, 4802 unlocked
        loot = {
            187026, -- Field Warden's Torture Kit
            187240, -- Field Warden's Watchful Eye
            -- These are all incredibly low drop rate, but wowhead comments claim they drop:
            187020, -- Necrobinder's Shoulderpads
            187016, -- Eviscerator's Spiked Mantle
            187023, -- Instructor's Mantle
            ns.rewards.Currency(1767, 40),
        },
        label="Spectral Bound Chest",
        note="Click 3x nearby Spectral Keys to unlock",
        vignette=4802,
    },
})

-- spectral keys
ns.RegisterPoints(1961, { -- Korthia
    [57504930] = {quest=64248, atlas="warfronts-basemapicons-alliance-workshop-minimap"},
    [58204870] = {quest=64248, atlas="warfronts-basemapicons-alliance-workshop-minimap"},
    [59205671] = {quest=64248, atlas="warfronts-basemapicons-alliance-workshop-minimap"},
    [59154870] = {quest=64248, atlas="warfronts-basemapicons-alliance-workshop-minimap"},
    [61504735] = {quest=64248, atlas="warfronts-basemapicons-alliance-workshop-minimap"},
    [62755135] = {quest=64248, atlas="warfronts-basemapicons-alliance-workshop-minimap"},

    [50505370] = {quest=64249, atlas="warfronts-basemapicons-empty-workshop-minimap"},
    [52305320] = {quest=64249, atlas="warfronts-basemapicons-empty-workshop-minimap"},
    [52604970] = {quest=64249, atlas="warfronts-basemapicons-empty-workshop-minimap"},
    [54205060] = {quest=64249, atlas="warfronts-basemapicons-empty-workshop-minimap"},

    [59205670] = {quest=64250, atlas="warfronts-basemapicons-horde-workshop-minimap"},
    [60305650] = {quest=64250, atlas="warfronts-basemapicons-horde-workshop-minimap"},
    [61005870] = {quest=64250, atlas="warfronts-basemapicons-horde-workshop-minimap"},
    [62105770] = {quest=64250, atlas="warfronts-basemapicons-horde-workshop-minimap"},
}, {
    label = "Spectral Key",
    minimap=true,
    group="Spectral Keys",
})

-- Mawsworn cache
local mawcache = ns.nodeMaker{
    label="Mawsworn Cache",
    loot={
        187026, -- Field Warden's Torture Kit
        187240, -- Field Warden's Watchful Eye
        -- These are all incredibly low drop rate, but wowhead comments claim they drop:
        187020, -- Necrobinder's Shoulderpads
        187016, -- Eviscerator's Spiked Mantle
        187023, -- Instructor's Mantle
    },
    note="Multiple spawn points",
    group="mawsworncache",
}
ns.RegisterPoints(1961, { -- Korthia
    -- Cache one:
    [57553755] = mawcache(),
    [58833364] = mawcache(),
    [60103930] = mawcache(),
    [62903490] = mawcache(),
}, {
    quest=64021,
    texture=ns.atlas_texture("VignetteLoot", {r=1,g=0.5,b=0,a=1,scale=1}),
})
ns.RegisterPoints(1961, { -- Korthia
    -- Cache two:
    [56805610] = mawcache(),
    [58305285] = mawcache(),
    [61105160] = mawcache(),
    [61205790] = mawcache(),
    [62275863] = mawcache(),
}, {
    quest=64363,
    texture=ns.atlas_texture("VignetteLoot", {r=1,g=0.5,b=0.5,a=1,scale=1}),
    vignette=4852,
})
ns.RegisterPoints(1961, { -- Korthia
    -- Cache three
    [47707430] = mawcache(),
    [47956675] = mawcache(),
    [51306480] = mawcache(),
    [54007280] = mawcache(),
    [56406950] = mawcache(),
    [56507470] = mawcache(),
}, {
    quest=64364,
    texture=ns.atlas_texture("VignetteLoot", {r=0.5,g=1,b=0.5,a=1,scale=1}),
    vignette=4853,
})

-- Rift portals
ns.RegisterPoints(1961, { -- Korthia
    [41104210] = {}, -- 42304090
    [43504700] = {},
    [53707200] = {},
    [56807460] = {},
    [59405370] = {},
    [61804460] = {},
}, {
    label="{npc:179595}",
    atlas="poi-rift1",
    requires_no_buff={352795, 354870, any=true},
    note="Rifts let you enter an alternate phase, if you have a {item:186731}. There are rares and chests that're only in the rift.",
    group="riftportal",
    minimap=true,
})

-- Riftbound Caches
local riftcache = ns.nodeMaker{
    label="Riftbound Cache",
    -- requires_item=186731, -- Repaired Riftkey
    loot={
        187251, -- Shaded Skull Shoulderguards
        187243, -- Shadehunter's Crescent
        {187276, quest=64522}, -- Stolen Korthian Supplies
        {185050, quest=63606, covenant=Enum.CovenantType.NightFae}, -- Spider Soul
        186994, -- Design: Shaded Stone Statue
    },
    active=rift_active,
    group="riftboundcache",
}
ns.RegisterPoints(1961, { -- Korthia
    [33453930] = riftcache(),
    [35953245] = riftcache(),
    [38003550] = riftcache(),
    [39804300] = riftcache(),
}, {
    quest=64456,
    texture=ns.atlas_texture("VignetteLoot", {r=1,g=0,b=0,a=1,scale=1}),
})
ns.RegisterPoints(1961, { -- Korthia
    [24805625] = riftcache(),
    [30305640] = riftcache{note="Inside Gromit Hollow"},
}, {
    quest=64470,
    texture=ns.atlas_texture("VignetteLoot", {r=0,g=1,b=0,a=1,scale=1}),
})
ns.RegisterPoints(2007, { -- Gromit Hollow
    [29453985] = riftcache(),
    [34654645] = riftcache(),
    [43157370] = riftcache(),
}, {
    quest=64470,
    texture=ns.atlas_texture("VignetteLoot", {r=0,g=1,b=0,a=1,scale=1}),
})
ns.RegisterPoints(1961, { -- Korthia
    [54105460] = riftcache(),
    [54904240] = riftcache(),
    [55506510] = riftcache(),
    [60903520] = riftcache(),
    [61755870] = riftcache(),
}, {
    quest=64471,
    texture=ns.atlas_texture("VignetteLoot", {r=0,g=0.5,b=1,a=1,scale=1}),
})
ns.RegisterPoints(1961, { -- Korthia
    [46203192] = riftcache(),
    [50753300] = riftcache(),
    [56301850] = riftcache(),
    [64303040] = riftcache(),
}, {
    quest=64472,
    texture=ns.atlas_texture("VignetteLoot", {r=1,g=1,b=0,a=1,scale=1}),
})

--Mawshrooms
local mawshroom = ns.nodeMaker{
    label="Invasive Mawshroom",
    loot={
        {187153, mount=1507}, -- Tasty Mawshroom (for Darkmaul)
        {187244, pet=3215}, -- Questionable Mawshroom
        {185963, questComplete=63892}, -- Diviner's Rune Chit
    },
    note="Multiple spawn points. Feed the {item:187153:Tasty Mawshroom} to {npc:180063:Darkmaul} x10 for a mount. Also take {item:187244:Questionable Mawshroom} to {zone:1970:Zereth Mortis} and eat it to be able to catch {npc:183230:Mawtouched Geomental}.",
    group="mawshrooms",
}
ns.RegisterPoints(1961, {
    [54204120] = mawshroom(),
    [56965165] = mawshroom(),
    [57303940] = mawshroom(),
    [58154050] = mawshroom(),
    [60304160] = mawshroom(),
    [60703820] = mawshroom(),
}, {
    quest=64351,
    texture=ns.atlas_texture("teleportationnetwork-ardenweald-32x32", {r=1,g=1,b=0,a=1,scale=1}),
    vignette=4842,
})
ns.RegisterPoints(1961, {
    [48504115] = mawshroom(),
    [49504070] = mawshroom(),
    [49553174] = mawshroom(),
    [51504690] = mawshroom(),
    [53703790] = mawshroom(),
}, {
    quest=64354,
    texture=ns.atlas_texture("teleportationnetwork-ardenweald-32x32", {r=0,g=1,b=0,a=1,scale=1}),
    vignette=4843,
})
ns.RegisterPoints(1961, {
    [42103580] = mawshroom(),
    [43703670] = mawshroom(),
    [45603450] = mawshroom(),
    [52402500] = mawshroom(),
    [55101642] = mawshroom(),
}, {
    quest=64355,
    texture=ns.atlas_texture("teleportationnetwork-ardenweald-32x32", {r=0,g=0.5,b=1,a=1,scale=1}),
    vignette=4844,
})
ns.RegisterPoints(1961, {
    [35703110] = mawshroom(),
    [37503480] = mawshroom(),
    [38803380] = mawshroom(),
    [39513068] = mawshroom(),
    [39703491] = mawshroom(),
    [42103250] = mawshroom(),
}, {
    quest=64356,
    texture=ns.atlas_texture("teleportationnetwork-ardenweald-32x32", {r=1,g=0,b=1,a=1,scale=1}),
    vignette=4845,
})
ns.RegisterPoints(1961, {
    [39703010] = mawshroom(),
    [41204490] = mawshroom(),
    [43455635] = mawshroom(),
    [45194790] = mawshroom(),
    [46504850] = mawshroom(),
    [54805550] = mawshroom(),
}, {
    quest=64357,
    texture=ns.atlas_texture("teleportationnetwork-ardenweald-32x32", {r=0,g=1,b=1,a=1,scale=1}),
    vignette=4846,
})

--Nests
ns.RegisterPoints(1961, {
    [40993966] = {quest=64358, vignette=4847},
    [42175599] = {quest=64359, vignette=4848},
    [51864393] = {quest=64360, vignette=4849},
    [63773167] = {quest=64361, vignette=4850},
    [52407270] = {quest=64362, vignette=4851},
}, {
    label="Nest of Unusual Materials",
    texture=ns.atlas_texture("vehicle-trap-grey", {r=0.8,g=0,b=0.8,a=1,scale=1}),
    loot={
        187440, -- Feather Stuffed Helm
        {185963, questComplete=63892}, -- Diviner's Rune Chit
    },
    group="nests",
})

--Relics
local relic_traits = {
    minimap=true,
    atlas="reagents",
    onquest=true,
    group="relic",
}

ns.RegisterPoints(1961, { -- Korthia
    [30205510] = researched{ -- Book of Binding: The Mad Witch
        achievement=15066, criteria=52131,
        quest=63899,
        research=2,
        note="At the back of Gromit Hollow",
    },

    [45105610] = researched{ -- Celestial Shadowlands Chart
        achievement=15066, criteria=52258,
        quest=63912,
        research=2,
        minimap=false,
    },

    [41156015] = researched{ -- Gorak Claw Fetish
        achievement=15066, criteria=52268,
        quest=63924,
        -- requires_item=187614,
        research=2,
        path=43505741,
        note="In cave. Buy {item:187614:Key of Many Thoughts} from {npc:178257} to unlock",
    },

    [41304330] = researched{ -- Guise of the Changeling
        achievement=15066, criteria=52255,
        quest=63909,
        -- requires_item=186984,
        research=2,
        loot={
            {187155, toy=true} -- Guise of the Changeling
        },
        path=42204101,
        note="Buy {item:186984:Korthite Crystal Key} from {npc:178257} to unlock",
    },

    [33004190] = researched{ -- The Netherstar
        achievement=15066, criteria=52256,
        quest=63910,
        -- requires_item=187612,
        research=2,
        note="Buy {item:187612:Key of Flowing Waters} from {npc:178257} to unlock. On the lowest level.",
    },

    [43857690] = researched{ -- Ring of Self-Reflection
        achievement=15066, criteria=52265,
        quest=63921,
        -- requires_item=187613,
        research=2,
        loot={
            {187140, toy=true} -- Ring of Duplicity
        },
        note="Buy {item:187613:Key of the Inner Chambers} from {npc:178257} to unlock",
    },

    [62005680] = researched{ -- Singing Steel Ingot
        achievement=15066, criteria=52257,
        quest=63911,
        research=2,
    },

    [39385238] = researched{ -- Drum of Driving
        achievement=15066, criteria=52269,
        quest=63915,
        -- requires_item=186718,
        research=3,
        note="Use {item:186718} from {npc:178257} on the Ancient Teleporter",
    },

    [45003550] = researched{ -- Sack of Strange Soil
        achievement=15066, criteria=52261,
        quest=63916,
        -- requires_item=186718,
        research=3,
        note="Use {item:186718} from {npc:178257} on the Ancient Teleporter",
    },

    [40504140] = researched{ -- Talisman of the Eternal Scholar
        achievement=15066, criteria=52126,
        quest=63860,
        research=3,
        note="In cave",
    },

    [60803490] = researched{ -- Book of Binding: The Tormented Sorcerer
        achievement=15066, criteria=52264,
        quest=63919,
        -- requires_item=186731,
        research=4,
        active=rift_active,
        note="Buy {item:186731} from {npc:178257} to enter the rift",
    },

    [29005420] = researched{ -- Cipher of Understanding
        achievement=15066, criteria=52260,
        quest=63914,
        -- requires_item=186731,
        research=4,
        active=rift_active,
        note="Buy {item:186731} from {npc:178257} to enter the rift",
    },

    [52005260] = researched{ -- Enigmatic Decrypting Device
        achievement=15066, criteria=52270,
        quest=63920,
        -- requires_item=186731,
        research=4,
        active=rift_active,
        note="Buy {item:186731} from {npc:178257} to enter the rift",
    },

    [51402010] = researched{ -- Unstable Sin'dorei Explosive
        achievement=15066, criteria=52259,
        quest=63913,
        -- requires_item=186731,
        research=4,
        active=rift_active,
        note="Buy {item:186731} from {npc:178257} to enter the rift",
    },

    [18503800] = researched{ -- Bulwark of Divine Intent
        achievement=15066, criteria=52254,
        quest=63908,
        research=5,
        note="Use the shrine to get {spell:352367} to see the altar path",
    },

    [24355660] = researched{ -- Lang Family Wood-Carving
        achievement=15066, criteria=52267,
        quest=63923,
        research=5,
        note="Use the shrine to get {spell:352367} to see the altar path",
    },

    [39404270] = researched{ -- Shadow Slicing Sword
        achievement=15066, criteria=52266,
        quest=63922,
        research=5,
        loot={
            {187159, toy=true}, -- Shadow Slicing Shortsword
        },
        note="Use the shrine to get {spell:352367} to see the altar path",
    },
}, relic_traits)

ns.RegisterPoints(2007, { -- Gromit Hollow
    [39304920] = researched{ -- Book of Binding: The Mad Witch
        achievement=15066, criteria=52131,
        quest=63899,
        research=2,
    },
}, relic_traits)

--Maelie
ns.RegisterPoints(1961, { -- Korthia
    [60552105] = { label="Tinybell",
        quest=64292,
        label="{npc:179930}",
        atlas="stablemaster",
        texture=false,
    },
    -- Maelie
    [30005560] = {},
    [33103865] = {},
    [35804650] = {note="On the chain"}, -- on chain
    [35856225] = {note="Climb along the blue lines from the northeast"},
    [38403140] = {}, -- on shelf, jump down
    [39703490] = {}, -- among roots, jump down
    [41183988] = {}, -- middle level of cliffs
    [41302750] = {}, -- looking into Maw
    [42806040] = {},
    [43203130] = {}, -- on hill
    [49304170] = {}, -- among roots
    [50302290] = {}, -- on cliff, walk from above
    [59801510] = {}, -- on cliff
    [61304040] = {}, -- on cliff
    [62404970] = {}, -- by cliff behind large tree
    [67962980] = {},
}, {
    quest={64292,64298,any=true}, -- 2 is the final mount-quest, 8 is found-today
    progress={64293, 64294, 64295, 64296, 64297, 64299},
    label="{npc:179912}",
    texture=ns.merge(ns.atlas_texture("stablemaster"), {r=0,g=1,b=1,a=1,scale=1.2}),
    minimap=true,
    loot={
        {186643, mount=1511}, -- Reins of the Wanderer
    },
    note="{npc:179930} asks you to find {npc:179912}, who spawns in a different place each day. Find her each day, use {spell:355862} on her, and get a mount from {npc:179930}.",
    group="dailymount",
})

ns.RegisterPoints(1961, { -- Korthia
    [42853270] = { label="Darkmaul",
        quest=64376, progress=0,
        npc=180063,
        texture=ns.merge(ns.atlas_texture("stablemaster"), {r=1,g=0,b=1,a=1,scale=1.2}),
        loot={
            {186646, mount=1507}, -- Darkmaul
        },
        note="Feed {item:187153} from Invasive Mawshrooms to {npc:180063} 10 times.",
    },
    [25725108] = { label="Razorwing Nest",
        quest=64274, progress=0,
        npc=179871,
        texture=ns.merge(ns.atlas_texture("stablemaster"), {r=1,g=1,b=0,a=1,scale=1.2}),
        loot={
            {186651, mount=1510}, -- Dusklight Razorwing
        },
        note=function()
            local function qp(...)
                for i=1, select('#', ...) do
                    if not C_QuestLog.IsQuestFlaggedCompleted((select(i, ...))) then
                        return i - 1
                    end
                end
                return select('#', ...)
            end
            -- egg drop tracker: 64280, 64281
            return "Get 2x {item:187054} per day from devourers, turn in 10 at the nest for the mount.\n"..
                "Eggs found today: " .. qp(64280, 64281)
        end,
    },
}, {
    minimap=true,
    group="dailymount",
})

--Rares
ns.RegisterPoints(1961, { -- Korthia
    [58211768] = { label="Assault Supply Carriage",
        npc=180246,
        quest=64258, -- 64439?
        achievement=15107, criteria=52290,
        loot={
            187370, -- Carriage Crusher's Padded Slippers
            187391, -- Yarxhov's Rib-Cage
            187399, -- Maw Construct's Shoulderguards
        },
        note="Take the carriage that leaves from here, you'll fight the mob in the Maw",
        vignette=4857, -- then 4871 in the Maw
    },

    [51154177] = { label="Consumption",
        achievement=15107, criteria=52285,
        quest=64243,
        npc=179768, -- 179769 (normal), 179755 (rare)
        loot={
            187245, -- Death-Enveloped Spires
            187246, -- Death-Enveloped Pauldrons
            187247, -- Death-Enveloped Shoulder Spikes
            187402, -- All-Consuming Loop
        },
        note="Starts as a regular mob, eats {npc:179344} until it becomes a rare, and then a rare-elite. Loot gets better as it gets stronger, so wait.",
    },

    [59355220] = { label="Deadsoul Hatcher",
        achievement=15107, criteria=52275,
        quest=64285,
        npc=179913,
        requires_item=186731,
        loot={
            -- {187174, toy=true}, -- Shaded Judgement Stone (apparently not off-PTR?)
            187396, -- Girdle of the Deadsoul
            187401, -- Band of the Shaded Rift
        },
        active=rift_active,
        note="Buy {item:186731} from {npc:178257} to enter the rift",
    },


    [51822081] = { label="Dominated Protector",
        achievement=15107, criteria=52277,
        quest=63830,
        npc=177903,
        loot={
            187390, -- Dominated Protector's Helm
        },
        vignette=4732,
    },

    [33103930] = { label="Escaped Wilderling",
        achievement=15107, criteria=52298,
        quest=64320,
        npc=180014,
        vignette=4835,
        hide_before=ns.conditions.Covenant(Enum.CovenantType.NightFae),
        loot={
            {186492, mount=1487, covenant=Enum.CovenantType.NightFae}, -- Summer Wilderling Harness
        },
        note="Click on the {npc:180014} to start",
    },

    [59954370] = { label="Fleshwing (Corpse Heap)",
        achievement=15107, criteria=52299,
        quest=64349,
        npc=180042,
        vignette=4854,
        -- hide_before=ns.conditions.Covenant(Enum.CovenantType.Necrolord),
        loot={
            187372, -- Miasma Filtering Headpiece
            {186489, mount=1449, covenant=Enum.CovenantType.Necrolord}, -- Lord of the Corpseflies (from 187181)
            {187424, quest=64551,}, -- Legend of the Animaswell
        },
        note="Talk to {npc:180079}",
    },

    [59203580] = { label="Kroke the Tormented",
        achievement=15107, criteria=52304,
        quest=64428,
        npc=179108,
        loot={
            187394, -- Tormented Giant's Legplates
            187250, -- Kroke's Wingspiked Pauldrons
            187248, -- Kroke's Gleaming Spaulders
        },
    },

    [44202950] = { label="Malbog",
        achievement=15107, criteria=52283,
        quest=64233,
        npc=179684,
        loot={
            {186645, mount=1506}, -- Crimson Shardhide
            187377, -- Malbog's Paws
        },
        note="Talk to {npc:179729} in town to gain {spell:355078} and follow footprints",
    },
    [60652315] = {
        achievement=15107, criteria=52283,
        quest=64233,
        label="{npc:179729}", note="Get {spell:355078} and follow the footprints to 44.2, 29.5",
        atlas="ancientmana",
    },

    [50307590] = { label="Observer Yorik",
        achievement=15107, criteria=52294,
        quest=64440,
        npc=179914,
        -- requires_item=186731,
        loot={
            {187420, toy=true}, -- Maw-Ocular Viewfinder
            187365, -- Rift Splitter
            187405, -- Choker of the Hidden Observer
        },
        active=rift_active,
        note="Buy {item:186731} from {npc:178257} to enter the rift",
    },

    [22604140] = { label="Relic Breaker Krelva",
        achievement=15107, criteria=52291,
        quest=64291,
        npc=179931,
        vignette=4836,
        loot={
            187403, -- Relic Breaker's Drape
        },
    },

    [56256615] = { label="Reliwik the Defiant",
        achievement=15107, criteria=52318,
        quest=64455,
        npc=180160,
        loot={
            {186652, mount=1509}, -- Garnet Razorwing
            187388, -- Barbed Scale Cinch
        },
        note="Summon with the uncorrupted razorwing egg",
    },

    [44754297] = { label="Screaming Shade",
        achievement=15107, criteria=52273,
        quest=64263,
        npc=179608,
        vignette=4819,
        loot={
            187362, -- Stinging Shadow Screamer
            187400, -- Mantle of Screaming Shadows
        },
        active=rift_active,
        note="Buy {item:186731} from {npc:178257} to enter the rift",
    },

    [57607040] = { label="Silent Soulstalker",
        achievement=15107, criteria=52274,
        quest=64284,
        npc=179911,
        loot={
            187381, -- Rift-Touched Bindings
            187383, -- Silent Soulstalker Sabatons
        },
        active=rift_active,
        note="Buy {item:186731} from {npc:178257} to enter the rift",
    },

    [46507950] = { label="Stygian Stonecrusher (No Stoneborn Left Behind)",
        achievement=15107, criteria=52276,
        quest=64313,
        npc=179985,
        vignette={4831, 4832}, -- 4831
        hide_before=ns.conditions.Covenant(Enum.CovenantType.Venthyr),
        loot={
            184790, -- Archdruid Van-Yali's Greenthumbs
            {186479, mount=803, covenant=Enum.CovenantType.Venthyr}, -- Mastercraft Gravewing
            -- {187283,quest=64530, covenant=Enum.CovenantType.Venthyr}, -- Gravewing Crystal
            187386, -- Stygian Crystal Studded Legguards
            {187428,quest=64553,}, -- Legend of the Animaswell
        },
        note="Talk to {npc:179974}",
    },

    [47003560] = { label="Wild Worldcracker (Popo's Potion Patrol)",
        achievement=15107, criteria=52300,
        quest=64338,
        npc=180032,
        vignette={4838, 4839}, -- 4838 for the patrol...
        hide_before=ns.conditions.Covenant(Enum.CovenantType.Kyrian),
        loot={
            {187176, toy=true}, -- Vesper of Harmony
            {186483, mount=1493, covenant=Enum.CovenantType.Kyrian}, -- Foresworn Aquilon
            -- {187282,quest=64529,covenant=Enum.CovenantType.Kyrian}, -- Intact Aquilon Core
            187380, -- Devourer Hide Belt
            {187426,quest=64552,}, -- Legend of the Animaswell
        },
        note="Talk to {npc:180028}",
    },

    [44903550] = { label="Xyraxz the Unknowable (Chamber of Wisdom)",
        -- achievement=15066, criteria=52263, -- Reliquary Restoration
        achievement=15107, criteria=52296,
        quest=64278,
        npc=179859,
        -- requires_item=186718,
        loot={
            {187104, quest=63918}, -- Obelisk of Dark Tidings
            187387, -- Pauldrons of the Unknown Beyond
            187368, -- Xyraxz's Controlling Rod
        },
        note="Use {item:186718} from {npc:178257} on the Ancient Teleporter",
    },

    [39375241] = { label="Yarxhov the Pillager (Chamber of Knowledge)",
        -- achievement=15066, criteria=52262, -- Reliquary Restoration
        achievement=15107, criteria=52295,
        quest=64257,
        npc=179802,
        vignette=4806, -- Ancient Teleporter
        -- requires_item=186718,
        loot={
            {187103, quest=63917}, -- Everliving Statuette
            187366, -- Fallen Vault Guardian's Spire
            187391, -- Yarxhov's Rib-Cage
        },
        note="Use {item:186718} from {npc:178257} on the Ancient Teleporter",
    },

    [30305480] = { label="Zelnithop",
        achievement=15107, criteria=52301,
        quest=64442,
        npc=177336,
        loot={
            {186542, pet=3136}, --Korthian Specimen
            187371, -- Velvet Gromit Handwraps
        },
        note="In Gromit Hollow",
    },

    -- the many-spawn ones

    [10008000] = { label="Konthrogz the Obliterator",
        achievement=15107, criteria=52303,
        quest=64246, -- 64280?
        npc=179472,
        vignette={4800, 4885}, -- behind vignette=4885 "Devouring Tear"
        loot={
            {187183, mount=1514}, -- Rampaging Mauler
            187375, -- Bound Worldeater Tendrils
            187378, -- Visage of the Obliterator
            187384, -- Konthrogz's Scaled Handguards
            187397, -- Vambraces of the In-Between
        },
        note="Spawns in a devourer portal event",
    },
    [12008000] = { label="Towering Exterminator",
        achievement=15107, criteria=52302,
        quest=64245,
        npc=179760,
        vignette={4798, 4886}, -- behind vignette=4886 "Mawsworn Portal"
        loot={
            187035, -- Cold Burden of the Damned
            187241, -- Watchful Eye of the Damned
            187242, -- Exterminator's Crest of the Damned
            187373, -- Soul-Enveloping Leggings
            187376, -- Mawsworn Lieutenant's Treads
            187382, -- Mawsworn Exterminator's Hauberk
            187392, -- Sabatons of the Towering Construct
        },
        note="Spawns in a mawsworn portal event",
    },
    [14008000] = { label="Ve'rayn (Pop Quiz)",
        achievement=15107, criteria=52319,
        quest=64457,
        npc=180162,
        vignette={4866, 4883}, -- behind vignette=4883 "Abandoned Veilstaff"
        loot={
            {187264, quest=64513}, -- Ve'rayn's Head
            187369, -- Ve'rayn's Formal Robes
            187404, -- Cartel Ve Amulet
        },
        note="Find and use the Abandoned Veilstaff, then talk to {npc:180162}",
    },
})

ns.RegisterPoints(2007, { -- Gromit Hollow
    [45606830] = { label="Zelnithop",
        achievement=15107, criteria=52301,
        quest=64442,
        npc=177336,
        loot={
            {186542, pet=3136}, --Korthian Specimen
            187371, -- Velvet Gromit Handwraps
        },
        note="In Gromit Hollow",
    },
})

-- Teleporters

--Waystone
ns.RegisterPoints(1961, {
    [64502400] = {
        label="Waystone to Oribos",
        atlas="adventures-32x32", scale=1.2,
        active=ns.conditions.QuestComplete(63665),
        minimap=true,
        group="Transportation",
    },
})
-- Flayedwing
ns.RegisterPoints(1961, {
    [60852855] = {route=49356385,},
    [49356385] = {routes={{49356385,60852855,r=0,g=0.75,b=0}},},
}, {
    label="{npc:180548}",
    atlas="flightmaster", scale=1.2,
    active=ns.conditions.QuestComplete(63665),
    group="Transportation",
})
