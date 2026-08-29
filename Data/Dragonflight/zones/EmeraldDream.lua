local myname, ns = ...

--[[
Unlocking the Dream Wardens: 77572, 77887
Legend of Elun'ahir: 78831, item:210049
]]

-- Portal
ns.RegisterPoints(ns.VALDRAKKEN, {
    [62815726] = {
        label="Portal to Emerald Dream",
        texture=ns.atlas_texture("dreamsurge_fire-portal-icon", {r=0, g=1, b=0, scale=2}),
        active=ns.conditions.QuestComplete(77572),
        note="You must unlock {majorfaction:2574} before this is available",
        minimap=true,
    },
})

-- Treasures
ns.RegisterPoints(ns.EMERALDDREAM, {
    [34095634] = { label="Triflesnatch's Roving Trove",
        criteria=62952,
        quest=77872,
        related={
            [39705210] = {label="{npc:210060:Triflesnatcher}",note="Follow until the treasure appears", quest=77855},
            [42205620] = {label="{npc:210060:Triflesnatcher}",note="Follow until the treasure appears", quest=77857}, -- 77505?
            [41706250] = {label="{npc:210060:Triflesnatcher}",note="Follow until the treasure appears", quest=77369},
        },
        note="Follow the nearby {npc:210060:Triflesnatcher} until the treasure appears",
        vignette=5812,
    },
    [47503490] = { label="Hidden Moonkin Stash",
        criteria=62953,
        quest=77858,
        loot={
            {210725, toy=true}, -- Owl Post
        },
        vignette=5826,
    },
    [39106552] = { label="Crystalline Glowblossom",
        criteria=62954,
        quest=77950,
        vignette=5981,
        note="Climb the tree",
    },
    [37303070] = { label="Pineshrew Cache",
        criteria=62956,
        quest=78120,
        loot={
            {210411, toy=true}, -- Fast Growing Seed
        },
        vignette=5872,
    },
    [61605956] = { label="Magical Bloom",
        criteria=62960,
        quest=78005, -- 78033 for treasure appearance
        hide_before=ns.conditions.QuestComplete(77818), -- The Cruel
        related={
            [64316131] = {label="{npc:210544:Laughing Podling}",note="Follow until the treasure appears"},
            [62946039] = {label="{npc:210544:Laughing Podling}",note="Follow until the treasure appears"},
        },
        note="Follow the nearby {npc:210544:Laughing Podling} until the treasure appears",
        vignette=5831, -- also 5926, 5927
    },
    [55275725] = { label="Odd Burl",
        criteria=62961,
        quest=78006,
        vignette=5832,
        note="In the tree",
    },
    [47105310] = { label="Reliquary of Ursol",
        criteria=62955,
        quest=78107, -- 78095 for treasure appearing
        loot={
            210434, -- Visage of Ursol
        },
        note="Use a Mark of Ursol and come here with {spell:423306:Bear Spirit Guardian}. If you can be a bear, you don't need the Mark. (Pandaren count!)",
        nearby={48015246, label="Mark of Ursol"},
        vignette=5870, -- Statue of the Bear Lord
    },
    [64101920] = { label="Reliquary of Aviana",
        criteria=62957,
        quest=78360,
        loot={
            210659, -- Branch of Aviana
        },
        note="Use a Mark of Aviana and come here with {spell:425432:Winged Spirit Guardian}. If you can have wings, you don't need the Mark.",
        vignette=5936, -- Statue of the Sky Mistress
    },
    [63437155] = { label="Reliquary of Ashamane",
        criteria=62958,
        quest=78359,
        hide_before=ns.conditions.QuestComplete(76320), -- Wild Gods in Our Midst
        loot={
            210631, -- Branch of Ashamane
        },
        note="Inside the Barrows of Reverie",
        vignette=5935, -- Statue of the Ashen Panther
    },
    [33208330] = { label="Reliquary of Goldrinn",
        criteria=62959,
        quest=78361,
        loot={
            210660, -- Claw of Lo'Gosh
        },
        note="Use a Mark of Goldrinn and come here with {spell:425408:Wolf Spirit Guardian}. If you can be a wolf, you don't need the Mark. (Worgen count!)",
        vignette=5937, -- Statue of the Great Wolf
    },
}, {
    achievement=19317, -- Treasures
    -- minimap=true,
})
ns.RegisterPoints(2254, { -- Barrows of Reverie
    [62903510] = { label="Reliquary of Ashamane",
        criteria=62958,
        quest=78359, -- 78365 for treasure appearing
        hide_before=ns.conditions.QuestComplete(76320), -- Wild Gods in Our Midst
        loot={
            210631, -- Branch of Ashamane
        },
        note="Use a Mark of Ashamane and come here with {spell:425426:Panther Spirit Guardian}. If you can stealth, you don't need the Mark",
        related={
            [39006660] = {label="Mark of Ashamane", minimap=true},
        },
        vignette=5935, -- Statue of the Ashen Panther
    },
}, {
    achievement=19317, -- Treasures
})

ns.RegisterPoints(ns.EMERALDDREAM, {
    [69585285] = {
        quest=78550,
        loot={210686}, -- Grovekeeper's Barrier
        vignette=5954,
    },
    [55324538] = {
        quest=78551,
        loot={210678}, -- Verdant Gleaner's Scythe
        vignette=5955,
        path=54764451,
    },
}, {
    label="Unwaking Echo",
    note="/sleep to open",
})

-- Small Somnut
--[[
-- No quests, basically everywhere, might not even be worth showing
-- https://www.wowhead.com/object=408719/small-somnut#comments
ns.RegisterPoints(ns.EMERALDDREAM, {
    [28553410] = {},
    [32815440] = {},
    [32936563] = {},
    [37735020] = {},
    [38486184] = {},
    [39184365] = {},
    [39315799] = {},
    [39695235] = {},
    [40273457] = {},
    [42246677] = {},
    [42284821] = {},
    [43107190] = {},
    [52003800] = {note="Stuck in a wall"},
    [57185350] = {},
    [63447358] = {},
    [66256328] = {note="On the branch"},
    [66496315] = {note="Under the branch, but stuck in a wall"},
}, {vignette=5833, label="Small Somnut"}
]]

-- Rares
ns.RegisterPoints(ns.EMERALDDREAM, {
    [54803680] = { label="Mosa Umbramane",
        criteria=62949,
        quest=77940,
        npc=210070,
        loot={
            208375, -- Owlbear's Decisive Strike
            {210647, class="DRUID"}, -- Mark of the Umbramane
        },
        vignette=5822,
    },
    [44403920] = { label="Ristar the Rabid",
        criteria=62951,
        quest=77890,
        npc=210161,
        loot={
            209957, -- Fang of the Frenzied Nightclaw
            208322, -- Treads of the Nightclaw
            208359, -- Nightclaw's Bauble
            {210674,quest=78511,}, -- Mark of the Sable Dreamtalon
        },
        vignette=5871,
    },
    [34806320] = { label="Envoy of Winter",
        criteria=62933,
        quest=77878,
        npc=209929, -- also 214131
        loot={
            208332, -- Horns of the Envoy
            208337, -- Leaf Steward's Leggings
            208340, -- Stag's Flourishing Mantle
            208365, -- Winter's Stand
        },
        note="Loot nearby {item:208881:Shiversnap Blossom} and throw into the well",
        vignette=5816,
    },
    [40457263] = { label="Moragh the Slothful",
        criteria=62942,
        quest=78210,
        npc=210045,
        loot={
            210121, -- Ring of Season's Sunset
            210237, -- Nipping Night's Necklace
        },
        vignette=5908,
    },
    [51203180] = { label="Bloodstripe Great Ray",
        criteria=62945,
        quest=77942,
        npc=210050,
        loot={
            208376, -- Great Ray's Longbow
        },
        vignette=5819,
    },
    [53804040] = { label="Greedy Gessie",
        criteria=62932,
        quest=77982,
        npc=209936,
        loot={
            208355, -- String of Delicacies
        },
        vignette=5817, -- or 5969? There's two in Vignette.db2...
    },
    [41207320] = { label="Matriarch Keevah",
        criteria=62944,
        quest=78213,
        npc=210051,
        loot={
            {210683, class="DRUID"}, -- Mark of the Dreamtalon Matriarch
        },
        vignette=5911,
    },
    [62007140] = { label="Nuoberon",
        criteria=62929,
        quest=77570,
        npc=209113,
        loot={
            209880, -- Curve of Starry Dusks
            209959, -- Pinch of Dream Magic
        },
        vignette=5786, -- Nuoberon, the Wild Dream of a Child
    },
    [43404700] = { label="Somnambulant Ori",
        criteria=62944,
        quest=78212,
        npc=210047,
        loot={
            208381, -- Scepter of Still Waters
            209956, -- Ori's Verdant Feather
        },
        vignette=5910,
    },
    [66006280] = { label="Crabtankerous",
        criteria=62937,
        quest=77862,
        npc=209909,
        loot={
            208333, -- Fallen Flame's Crown
            208334, -- Legplates of the Krakken
            208341, -- Fire-Runed Spaulders
        },
        vignette=5809,
    },
    [58405120] = { label="Ignit the Firebranded",
        criteria=62936,
        quest=77864,
        npc=209620,
        loot={
            208325, -- Ignit's Fiery Heart
            208338, -- Furious Flame's Shoulders
            208383, -- Pommel of Fire
        },
        vignette=5811,
    },
    [61805180] = { label="Splinterlimb",
        criteria=62935,
        quest=77863,
        npc=209365, -- also 212410
        loot={
            208346, -- Singed Barkbands
            208361, -- Splinterlimb's Branch
        },
        vignette=5810,
    },
    [46201920] = { label="Moltenbinder's Disciple",
        criteria=62947,
        quest=77941,
        npc=208658,
        loot={
            {205463, toy=true}, -- Molten Lava Ball
            208353, -- Djaradin's Molten Band
        },
        vignette=5818,
    },
    [43603100] = { label="Surging Lasher",
        criteria=62941,
        additional={57805220, 60806400, 59007200},
        quest=78263,
        npc=210111,
        loot={
            208330, -- Piercing Touch of the Vine
            208335, -- Vibrant Fall Leggings
            208367, -- Lasher's Red Thorn
            207761, -- Technique: Grotto Netherwing Drake: Chin Tendrils
        },
    },
    [63803620] = { label="Molten Leadspike",
        criteria=62948,
        quest=77943,
        npc=210064,
        loot={
            208323, -- Nature's Firebathed Robes
            208349, -- Burning Leather Cuffs
        },
        vignette=5821,
    },
    [37603180] = { label="Isaqa",
        criteria=62940,
        quest=77989,
        npc=209919,
        loot={
            208345, -- Forgebreaker's Belt
            208348, -- Binds of the Shatterer
            208385, -- Flame Endowed Blade
        },
        vignette=5824,
    },
    [38406200] = { label="Voracious Mikanji",
        criteria=64492,
        quest=78214,
        npc=210508,
        loot={
            208354, -- Cerulean Turtle's Pendant
        },
        vignette=5912,
    },
    [40304920] = { label="Keen-eyed Cian",
        criteria=62943,
        quest=78211,
        npc=210046,
        loot={
            208336, -- Legguards of the Dreamsaber
            208342, -- Girdle of Nature's Fury
            208363, -- Twinfang of the Cian
            {210650, class="DRUID"}, -- Mark of the Keen-Eyed Dreamsaber
        },
        vignette=5909,
    },
    [47403030] = { label="Henri Snufftail",
        criteria=62950,
        quest=77944,
        npc=210075,
        loot={
            208357, -- Henri's Warm Coat
        },
        vignette=5820,
    },
    [35102260] = { label="Talthonei Ashwhisper",
        additional={36902240,61406740,63907010,64406660},
        criteria=62934,
        quest=77994,
        npc=209902, -- also 210413
        loot={
            208369, -- Druid's Vengeful Gaze
            208374, -- Talthornei's Wrath
        },
        vignette=5828, -- also 5829
    },
    [64208400] = { label="Reefbreaker Moruud",
        criteria=62931,
        quest=77867,
        npc=209898,
        loot={
            208327, -- Maruud's Piercing Hands
        },
        vignette=5806, -- also 5814
    },
    [63407160] = { label="Fruitface",
        criteria=62938,
        quest=77846,
        npc=209913,
        loot={
            208344, -- Sash of the Fruit Thief
            208372, -- Trickster's Tip Toers
            208388, -- Leafster's Magic Wand
            -- 210493, -- Technique: Grotto Netherwing Drake: Spiked Jaw
        },
        note="Inside the Barrows of Reverie",
        vignette=5805,
    },
    [26002660] = { label="The Apostle",
        criteria=62939,
        quest=77990,
        npc=209911,
        loot={
            208370, -- The Apostle's Steps
            208389, -- Spear of the Wilds
        },
        vignette=5825,
    },
}, {
    achievement=19316, -- Adventurer of the Emerald Dream
})
ns.RegisterPoints(2254, { -- Barrows of Reverie
    [54173749] = { label="Fruitface",
        criteria=62938,
        quest=77846,
        npc=209913,
        loot={
            208344, -- Sash of the Fruit Thief
            208372, -- Trickster's Tip Toers
            208388, -- Leafster's Magic Wand
            -- 210493, -- Technique: Grotto Netherwing Drake: Spiked Jaw
        },
        related={
            [60226882] = {label="{npc:209950:Mylune}", minimap=true},
        },
        note="Talk to {npc:209950:Mylune} for {spell:421446:Mylune's Blessing}. Pick up {item:208837:Missing Fruit} until {npc:209980:Thieving Podling} appears. Chase it here.",
        vignette=5805,
    },
}, {
    achievement=19316, -- Adventurer of the Emerald Dream
})
ns.RegisterPoints(ns.EMERALDDREAM, {
    [57803780] = { label="Elusive Verdant Gladewarden",
        quest=nil,
        npc=212133,
    },
    [30002120] = { label="Firebrand Fystia",
        criteria=62930,
        quest=78015,
        npc=209893,
        loot={
            208328, -- Fystia's Deft Hands
            209881, -- Fystia's Fiery Kris
        },
        vignette=5835,
    },
    [41202620] = { label="Amalgamation of Dreams",
        additional={39805300,51805740,58205940,62805200},
        quest=nil,
        npc=209915,
    },
    [40804280] = { label="Elusive Blooming Brierhide",
        quest=nil,
        npc=212090,
    },
    [39805120] = { label="Raszageth's Last Breath",
        additional={50403840, 65404340, 67406620},
        quest=77859,
        npc=209912,
        loot={
            208373, -- Band of Bated Breath
        },
        vignette=5808,
    },
    [22903240] = { label="Balboan",
        quest=78039,
        npc=210559,
        note="In cave",
        loot={
            208356, -- Earthbound Furbolg's Shroud
        },
        vignette=5837,
    },
    --[[
    [0] = { label="Enormous Dream Moth",
        quest=nil,
        npc=209864,
        vignette=5799,
    },
    --]]
    [39405340] = { label="Aurostor",
        quest=76367,
        worldquest=76367, -- Hybernation Heroes
        npc=209574,
        loot={
            208429, -- Mossen Rage Waistguard
            208435, -- Forgotten Jalgar's Girdle
            208436, -- Flame-Etched Breastplate
            208437, -- Crown of Freya's Chosen
            208438, -- Grasps of Awakened Fury
            208439, -- Rousing Earth Striders
            208440, -- Aurostor's Sleeping Knickers
            208441, -- Restful Dozer's Shoes
            208443, -- Slumbering Ursine Talisman
            210433, -- Visage of Aurostor
        },
    },
})
