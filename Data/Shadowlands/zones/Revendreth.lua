local myname, ns = ...

local path = ns.path

-- Secret Treasure
local secret = {
    loot={
        {180589, pet=2894}, -- Soullocked Sinstone
    },
}
ns.RegisterVignettes(1525, {
    [4173] = secret,
    [4174] = secret,
    [4175] = secret,
    [4176] = secret,
    [4177] = secret,
    [4178] = secret,
    [4179] = secret,
    [4180] = secret,
    [4181] = secret,
    [4182] = secret,
    [4212] = { label="Bleakwood Chest",
        loot={
            {180592, pet=2901}, -- Trapped Stonefiend
        },
    }
})

-- Pepe costume: A Tiny Sinstone, 186580, q 64132

-- abandoned belongings 60851

ns.RegisterPoints(1525, { -- Revendreth
    [37706920] = {
        achievement=14314, criteria=50076, -- Lost Quill
        quest=61990,
        loot={
            {182613, pet=3008}, -- Refilling Inkwell
        },
        note="Grab a {item:182475:Forbidden Ink} from the library below, and climb up onto the walls",
    },
    [38404430] = {
        achievement=14314, criteria=50077, -- Stylish Parasol
        quest=61999,
        loot={
            {182694, toy=true}, -- Stylish Black Parasol
        },
        note="On top of the castle walls",
    },
    [57304330] = {
        achievement=14314, criteria=50078, -- The Count
        quest=62063,
        loot={
            {182612, pet=3009}, -- The Count's Pendant
        },
        note="Requires 99 {currency:1820:Infused Ruby}",
    },
    [79903700] = {
        achievement=14314, criteria=50079, -- Rapier of the Fearless
        quest=62156,
        loot={
            182689, -- Rapier of the Fearless
        },
        note="On the ground. An enemy will spawn when interacting with the treasure. Kill the mob for the sword",
    },
    [70106000] = {
        achievement=14314, criteria=50080, -- Vrytha's Dredglaive
        quest=62164,
        loot={
            177807, -- Vyrtha's Dredglaive
        },
        note="Under a bridge",
    },
    [29703720] = {
        achievement=14314, criteria=50081, -- Makeshift Muckpool
        quest=62198,
        loot={
            {182780, toy=true}, -- Muckpool Cookpot
        },
        note="Inside the castle ruins. Requires 30 {currency:1820:Infused Ruby}",
    },
    [63007210] = {
        achievement=14314, criteria=50082, -- Taskmaster's Trove
        quest=62199,
        loot={
            {183986, toy=true}, -- Bondable Sinstone
        },
        note="Use the Ingress and Egress Rites scroll at the area, then dodge orbs",
    },
    [47505530] = {
        achievement=14314, criteria=50084, -- Forbidden Chamber
        quest=62243, -- 60200 for unlocking the door
        loot={
            {184075, toy=true}, -- Stonewrought Sentry
        },
        note="Take the {spell:314749:Anima Canister} inside the building and drain anima from the {npc:173838:Silent Observer}s to reach the treasure",
    },
    [31055510] = {
        achievement=14314, criteria=50895, -- Smuggled Cache
        quest=59889,
        loot={
            {182738, quest=62189}, -- Bundle of Smuggled Parasol Components
        },
        note="Rewards 35+6 {currency:1820:Infused Ruby}, after {quest:62189:Parasol Components}",
    },
    [69357799] = {
        achievement=14314, criteria=50896, -- Chest of Envious Dreams
        quest=59833,
        loot={
            {179393, toy=true}, -- Mirror of Envious Dreams
        },
    },
    [64197265] = {
        achievement=14314, criteria=50897, -- Filcher's Prize
        quest=59883,
        loot={
            179392, -- Orb of Burgeoning Ambition
        },
        note="Jump down from the North",
    },
    [68456446] = {
        achievement=14314, criteria=50898, -- Wayfarer's Abandoned Spoils
        quest=59884,
        loot={
            181547, -- Noble's Draught
            172230, -- soul dust
            173058, -- umbral ink
            ns.rewards.Currency(1820),
        },
        note="Jump on the mushroom at 67.9, 64.5",
    },
    [61565865] = {
        achievement=14314, criteria=50899, -- Remlate's Hidden Cache
        quest=59885,
        -- loot={},
        note="Outer wall, jump from near the flight master",
    },
    [46395817] = {
        achievement=14314, criteria=50900, -- Fleeing Soul's Bundle
        quest=59886,
        -- loot={},
        note="Outer wall",
    },
    [74975698] = {
        achievement=14314, criteria=50901, -- Gilded Plum Chest
        quest=59887,
        loot={
            179390, -- Tantalizingly Large Golden Plum
        },
        note="Kill the {npc:166680:Greedy Soul} wandering on the road",
    },
    [51815963] = {
        achievement=14314, criteria=50902, -- Abandoned Curios
        quest=59888,
        loot={
            182744, -- Ornate Belt Buckle
        },
    },
})

-- non-achievement treasures
ns.RegisterPoints(1525, {
    [73597539] = {
        quest=62196,
        label="Forgotten Angler's Rod",
        loot={
            {180993, toy=true}, -- Bat Visage Bobber
        },
        hide_before=ns.conditions.QuestComplete(57481),
        note="Complete quests from {npc:157846:Rendle} through {quest:57481} to be able to see this; might need to log back in to make it appear",
    },
    -- Loyal Gorger
    [59305700] = {
        label="{npc:173499}",
        quest={61843, 62046, any=true}, -- daily, final
        progress={
            61839, -- Nipping at the Undergrowth
            61840, -- Vineroot on the Menu
            61842, -- Vineroot Will Not Do
            61844, -- Hungry Hungry Gorger
            62044, -- Standing Toe to Toe
            62045, -- Ready for More
            62046  -- A New Pack
        },
        hide_before=ns.conditions.QuestComplete(61188), -- Worldedge Gorger
        loot={
            {182589, mount=1391}, -- Loyal Gorger
        },
        note="Kill {npc:160821} until {item:180583} drops, do 7 days of dailies for {npc:173499}, get a mount",
        atlas="stablemaster", scale=1.2,
        group="Daily Mounts",
    },
    --
    -- [45507810] = {
    --     label="Stoneborn Satchel",
    --     quest=60896, -- 60980
    --     note="Jump down",
    --     junk=true,
    -- },
    -- [36535153] = {
    --     label="Stoneborn Satchel",
    --     quest=60985,
    -- },
    -- [55384235] = {
    --     label="Stoneborn Satchel",
    --     quest=60942,
    -- },
    -- [74896194] = {
    --     label="Secret Treasure",
    --     quest=60199,
    --     note="Use the Cracked Crate to get inside",
    -- },
})

ns.RegisterPoints(1525, { -- Revendreth
    [63756169] = {
        quest=64941, -- Chicken; go work out the well fed cat one, if it has a quest
        loot={187811}, -- Spectral Feed
    },
    [63264285] = {
        quest=64941,
        loot={
            {187813, quest=64941, covenant=Enum.CovenantType.NightFae}, -- Chicken Soul
        },
        active=ns.conditions.Item(187811),
    }
}, {
    note="Bring the {item:187811:Spectral Feed} (63.7, 61.7) to the {npc:181660:Lost Soul} (63, 42), use /chicken at it, then give it the feed",
    hide_before=ns.conditions.Covenant(Enum.CovenantType.NightFae),
    atlas="sanctumupgrades-nightfae-32x32",
    minimap=true,
    group="soulshape",
})

-- Dead Blanchy

ns.RegisterPoints(1525, {
    [63134311] = { label="Dead Blanchy",
        quest={62050, 62107, any=true}, -- daily-done is 62107
        progress={62038, 62042, 62047, 62049, 62048, 62050},
        loot={
            {182614, mount=1414}, -- Blanchy's Reins
        },
        note=function()
            local function q(quest, label)
                return (C_QuestLog.IsQuestFlaggedCompleted(quest) and GREEN_FONT_COLOR or RED_FONT_COLOR):WrapTextInColorCode(label)
            end
            return "Nurse {npc:173468:Dead Blanchy} over the course of several days. You need items from all over the world:\n"..
            q(62038, "Day 1") ..": 8x {item:182581} from Westfall\n"..
            q(62042, "Day 2") ..": {item:182585} from {npc:173570} in Darkhaven\n"..
            q(62047, "Day 3") ..": 4x {item:182595} from the roads around Darkhaven\n"..
            q(62049, "Day 4") ..": Fill {item:182620} near {npc:173570} with water from Bastion or Ardenweald\n"..
            q(62048, "Day 5") ..": {item:182597} from {npc:171808} near the Night Market\n"..
            q(62050, "Day 6") ..": 3x {item:179271} from {npc:167815} by the Hole in the Wall\n"
        end,
        --level=60,
    },
    [63406180] = { label="Day 2: brush from Snickersnee",
        quest=62042,
        hide_before=ns.conditions.QuestComplete(62038),
        inbag=182585,
        label="{npc:173468}: {item:182585}",
        note="Day 2: Buy {item:182585} for {npc:173468}",
    },
    -- Day 4's horseshoes are everywhere
    [63306160] = { label="Day 4: fresh water",
        quest=62047,
        hide_before=ns.conditions.QuestComplete(62042),
        inbag=182620,
        label="{npc:173468}: {item:182620}",
        note="Day 4: Take to Bastion or Ardenweald and use in water",
    },
    [51007881] = { label="Day 5: blanket",
        quest=62048,
        hide_before=ns.conditions.QuestComplete(62047),
        inbag=182597,
        label="{npc:173468}: {item:182597}",
        note="Day 5: Buy from {npc:171808}",
    },
    [40804660] = { label="Day 6: apples",
        quest=62050,
        hide_before=ns.conditions.QuestComplete(62048),
        inbag=179271,
        label="{npc:173468}: 3x{item:179271}",
        note="Day 6: Buy 3x {item:179271} from {npc:167815}",
    },
}, {
    atlas="stablemaster",scale=1.2,
    minimap=true,
    --level=60,
    upcoming=false,
    group="Daily Mounts",
})
ns.RegisterPoints(52, { -- Westfall
    -- Day 1: oats
    [46573779] = {},
    [48692024] = {},
    [51023908] = {},
    [52163356] = {},
    [55142742] = {},
    [56263017] = {},
    [56523657] = {},
}, {
    label="{npc:173468}: {item:182581}",
    quest=62038,
    note="Day 1: Collect 8 for {npc:173468:Dead Blanchy} in Revendreth",
    atlas="stablemaster",scale=1.2,
    minimap=true,
    --level=60,
    group="Daily Mounts",
})

-- Carriages

ns.RegisterPoints(1525, {
    -- Chalice
    [49305210] = {
        criteria=50168,
        texture=ns.merge(ns.atlas_texture("vehicle-silvershardmines-minecart"), {r=1,g=1,b=0,a=1,scale=1.2}),
        routes={{
            54804840, 53904920, 52404950, 49305210, 48205110, 46904830,
            46904690, 47704800, 48905050, 50005070, 52204870, 54704800,
            loop=true,
            r=1, g=1, b=0,
        }},
    },
    -- Old Gate
    [56403720] = {
        criteria=50169,
        texture=ns.merge(ns.atlas_texture("vehicle-silvershardmines-minecart"), {r=0,g=1,b=1,a=1,scale=1.2}),
        routes={{
            56403720, 55903720, 55603900, 54804030, 53703850, 53803630,
            55203600, 55903720, 57403720, 57503610, 59703130, 60403230,
            60003300, 59103520, 59103850, 59503970, 58804080, 57603920,
            57403720,
            r=0, g=1, b=1,
        }},
    },
    -- Banewood
    [61606950] = {
        criteria=50170,
        routes={{
            61606950, 59107290, 55507320, 54207140, 50207070, 49007180,
            44707380, 40306780, 41506440, 42106110, 43306010, 43605940,
            r=1, g=0, b=0,
        }},
    },
    [43605940] = {criteria=50170, route=61606950,},
    -- Pridefall
    [68408060] = {
        criteria=50171,
        texture=ns.merge(ns.atlas_texture("vehicle-silvershardmines-minecart"), {r=1,g=0,b=1,a=1,scale=1.2}),
        routes={{
            68408060, 67307840, 66807630, 65507470, 65007090, 67706840,
            69807000, 71606850, 73006850,
            r=1, g=0, b=1,
        }},
    },
    [73006850] = {
        criteria=50171,
        texture=ns.merge(ns.atlas_texture("vehicle-silvershardmines-minecart"), {r=1,g=0,b=1,a=1,scale=1.2}),
        route=68408060,
    },
    -- Darkhaven
    [68306640] = {
        criteria=50172,
        atlas="vehicle-silvershardmines-minecartblue",
        routes={{
            68306640, 67806830, 65906730, 64606830, 64506860, 61606920,
            62406790, 63506460, 63906430, 64706210, 64105880, 62705870,
            62406060, 61306140, 61206220, 63706230, 68206570,
            loop=true,
            r=0, g=0, b=1,
        }},
    },
    -- Castle
    [45703800] = {
        criteria=50173,
        atlas="vehicle-silvershardmines-minecart",
        routes={{
            45703800, 45603630, 46303530, 47903550, 48803640, 50803640,
            52203860, 52804150, 52204420, 50904650, 48604670, 47704770,
            45804600, 45704460, 44304190, 44404080,
            loop=true,
        }},
    },
}, {
    achievement=14771,
    atlas="vehicle-silvershardmines-minecartred",scale=1.2,
    -- always=true,
    group="Carriage Routes",
})

-- Castle Sinrunners: What We Ride In The Shadows
-- TODO: worth writing a "highlight this line from point X onwards" mode? This is
-- the only place that'd use it currently...

local sinroute = ns.nodeMaker{
    highlightOnly=true,
    r=1, g=0.5, b=1,
}
ns.RegisterPoints(1525, {
    [40153775] = { label="Dominance Gate : Hole in the Wall",
        criteria={50175,50176},
        route=sinroute{
            40153775, 39003580, 39003460, 43002860, 45102890, 45103230,
            45403290, 44303540, 43803890, 44204010, 43904090, 42904100,
            42004270, 42004600, 41304690,
        },
    },
    [39454455] = { label="The Abandoned Purlieu : Hole in the Wall",
        criteria={50175,50176},
        route=sinroute{
            39454455, 39104350, 39003870,
            --
            40153775, 39003580, 39003460, 43002860, 45102890, 45103230,
            45403290, 44303540, 43803890, 44204010, 43904090, 42904100,
            42004270, 42004600, 41304690,
        }
    },
    [41304730] = { label="Hole in the Wall : Ramparts : Hole in the Wall",
        criteria={50175,50176},
        route=sinroute{
            41304730, 41804620, 42104500, 40204470,
            --
            39454455, 39104350, 39003870,
            --
            40153775, 39003580, 39003460, 43002860, 45102890, 45103230,
            45403290, 44303540, 43803890, 44204010, 43904090, 42904100,
            42004270, 42004600, 41304690,
        },
    },
    -- to Old Gate
    [55256220] = { label="Wildwall : Old Gate",
        criteria=50174,
        route=sinroute{
            55256220, 54305690, 54705500, 59105150, 58704060, 60503840,
        },
    },
    [60356270] = { label="Darkhaven : Old Gate",
        criteria=50174,
        route=sinroute{
            60356270, 55206320,
            --
            55256220, 54305690, 54705500, 59105150, 58704060, 60503840,
        },
    },
    -- to Darkhaven
    [69655800] = { label="Edge of Sin : Darkhaven",
        criteria=50177,
        route=sinroute{
            69655800, 67605680, 64305880, 62705890, 62306090, 62706210, 63106180,
        },
    },
    [76355370] = { label="Edge of Sin : Darkhaven",
        criteria=50177,
        route=sinroute{
            76355370, 75205550, 74905710, 73905800,
            --
            69655800, 67605680, 64305880, 62705890, 62306090, 62706210, 63106180,
        },
    },
    [77404880] = { label="Edge of Sin : Darkhaven",
        criteria=50177,
        route=sinroute{
            77404880, 77605090,
            --
            76355370, 75205550, 74905710, 73905800,
            --
            69655800, 67605680, 64305880, 62705890, 62306090, 62706210, 63106180,
        },
    },
    [71604105] = { label="Absolution Crypt : Darkhaven",
        criteria=50177,
        route=sinroute{
            71604105, 72604100, 73403990, 74704280, 76504400,
            --
            77404880, 77605090,
            --
            76355370, 75205550, 74905710, 73905800,
            --
            69655800, 67605680, 64305880, 62705890, 62306090, 62706210, 63106180,
        },
    },
    -- to Hole in the Wall
    [44055640] = { label="Charred Ramparts : Hole in the Wall",
        criteria=50175,
        route=sinroute{
            44055640, 40905660, 38905060, 40104850, 40504710,
        },
    },
    [53555530] = { label="Briar Gate : Hole in the Wall",
        criteria=50175,
        route=sinroute{
            53555530, 51905510, 50005230, 48405130, 44905610,
            --
            44055640, 40905660, 38905060, 40104850, 40504710,
        },
    },
    [54906235] = { label="Wildwall : Hole in the Wall",
        criteria=50175,
        route=sinroute{
            54906235, 54305740,
            --
            53555530, 51905510, 50005230, 48405130, 44905610,
            --
            44055640, 40905660, 38905060, 40104850, 40504710,
        },
    },
    [48856885] = { label="Wanecrypt Hill : Hole in the Wall",
        criteria=50175,
        route=sinroute{
            48856885, 50007010, 50306930, 52106760, 53806910, 54306800, 53906370, 55006310,
            --
            54906235, 54305740,
            --
            53555530, 51905510, 50005230, 48405130, 44905610,
            --
            44055640, 40905660, 38905060, 40104850, 40504710,
        },
    },
}, {
    achievement=14770,
    texture=ns.merge(ns.atlas_texture("stablemaster"), {r=1, g=0.5, b=1, scale=1.2}),
    -- always=true,
    label="{npc:174032}",
    note="Requires {currency:1820} x 5",
    group="Sinrunners",
})

-- Bat!

ns.RegisterPoints(1525, {
    [21685023] = {},
    [25103760] = {},
    [31905920] = {},
    [56306230] = {},
    [60406120] = {},
    [64106210] = {},
}, {
    achievement=14769,
    label="Dredbat",
    texture=ns.merge(ns.atlas_texture("ancientmana"), {r=1, g=0, b=0}),
    --level=60,
    note="It's inconsistent whether you'll get credit for animating any particular bat",
    group="Dredbats",
})

-- Mirrors
-- TODO: gather the rest of the questsids
ns.RegisterPoints(1525, {
    -- these all have a repaired quest and a looted quest
    -- group 1
    [29493726] = {quest=61833, requires_worldquest=61879, note="Room with cauldron",}, -- 61818, 61833
    [40417334] = {quest=61834, requires_worldquest=61879, note="Inside house with sleeping beasts",}, -- 61822, 61834
    [27152163] = {quest=61835, requires_worldquest=61879, note="Base of cliff, room with elite spider",}, -- 61826, 61835
    -- group 2
    [39095218] = {quest=61836, requires_worldquest=61883, note="Inside, at base of cliff",}, -- 61819, 61836
    [58806780] = {quest=61837, requires_worldquest=61883, note="Inside, at top of cliff",}, -- 61823, 61837
    [70974363] = {quest=61838, requires_worldquest=61883, note="Inside the building",}, -- 61827, 61838
    -- group 3
    [72604365] = {quest=61830, requires_worldquest=61885, note="Inside the crypt",}, -- 61817, 61830
    [40307716] = {quest=61831, requires_worldquest=61885, note="Inside a building",}, -- 61821, 61831
    [77176543] = {quest=61832, requires_worldquest=61885, note="Inside a building with several elite mobs",}, -- 61825, 61832
    -- group 4
    [55123567] = {quest=61828, requires_worldquest=61886, note="Inside the crypt", nearby={55193472},}, -- 61820, 61828
    [29602589] = {quest=61829, requires_worldquest=61886, note="Room with elite soulbender",}, -- 61824, 61829
    [20755426] = {quest=60297, requires_worldquest=61886, note="Just inside manor entrance",}, -- 59236, 60297
}, {
    label="{spell:357778:Broken Mirror}",
    loot={
        -- TODO: there's also four blue daggers but wowhead shows them being way more restricted in their drop locations, so verify that
        183707, -- Mantle of Burnished Blades
        183710, -- Burnished Sinstone Chain
        183711, -- Burnished Crypt Keeper's Mantle
        {183855, pet=3012}, -- Stony's Infused Ruby
        {183798, mount=1389}, -- Silessa's Battle Harness
        {181124, set=2064}, -- Soulbreaker's Burnished Vestments (cloth)
        {181061, set=2069}, -- Burnished Death Shroud Armor (leather)
        {181088, set=2073}, -- Fearstalker's Burnished Battlegear (mail)
        {181022, set=2076}, -- Dread Sentinel's Burnished Battleplate (plate)
    },
    active=ns.conditions.Item(181363), -- Handcrafted Mirror Repair Kit
    requires={ns.conditions.GarrisonTalent(1049), ns.conditions.Covenant(Enum.CovenantType.Venthyr)}, -- Mirror's Edge
    texture=ns.atlas_texture("teleportationnetwork-revendreth-32x32", {r=0.5, g=1, b=0.5}), scale=2, minimap=true,
})

-- Rares

ns.RegisterPoints(1525, {
    [53257300] = { label="Amalgamation of Filth",
        achievement=14310, criteria=48814,
        quest=59854,
        npc=166393,
        loot={
            183729, -- Filth-Splattered Headcover
        },
        note="When {quest:57443:Dirty Job Demolition Detail} world quest is up, open a Rubbish Box and use {spell:324115} into the water",
    },
    [25304850] = { label="Amalgamation of Light",
        achievement=14310, criteria=48811,
        quest=59584,
        npc=164388,
        loot={
            {180586,pet=2892,}, -- Lightbinders (flagged as zone-drop, because it can drop from the other light-elementals)
            180688, -- Infused Remnant of Light
            179924, -- Light-Infused Jacket
            179926, -- Light-Infused Tunic
            179653, -- Light-Infused Hauberk
            179925, -- Light-Infused Breastplate
        },
        note="Move 3x Mirror Traps to summon",
    },
    [65802915] = { label="Amalgamation of Sin",
        achievement=14310, criteria=50029,
        quest=60836,
        npc=170434,
        loot={
            183730, -- Sinstone-Studded Greathelm
        },
        note="During {quest:60656:Summon Your Sins} choose Catalyst of Power",
    },
    [35807050] = { label="Azgar",
        achievement=14310, criteria=48816,
        quest=59893,
        npc=166576,
        loot={
            183731, -- Smolder-Tempered Legplates
            180690, -- Bottled Ash Cloud
        },
    },
    [35003230] = { label="Bog Beast",
        achievement=14310, criteria=48818,
        quest=59823,
        npc=166292,
        loot={
            {180588, pet=2896}, -- Bucket of Primordial Sludge
        },
        note="Up during {quest:59808}",
    },
    [66555945] = { label="Endlurker",
        achievement=14310, criteria=48810,
        quest=59582,
        npc=165206,
        loot={
            179927, -- Glowing Endmire Stinger
            {183759, quest=62474, covenant=Enum.CovenantType.Necrolord}, -- Unusually Large Cranium (Necro only?)
        },
        note="Use {spell:321827} to summon",
    },
    -- [65406030] = path{achievement=14310, criteria=48810,quest=59582,},
    [37104740] = { label="Executioner Aatron",
        achievement=14310, criteria=48819,
        quest=59913,
        npc=166710,
        loot={
            180696, -- Legion Wing Insignia
            183737, -- Aatron's Stone Girdle
        },
    },
    [43055185] = { label="Executioner Adrastia",
        achievement=14310, criteria=48807,
        quest=58441,
        npc=161310,
        loot={
            180502, -- Adrastia's Executioner Gloves
        },
        note="Flies around the area; free {npc:161299} nearby until she lands",
    },
    [62504715] = { label="Famu the Infinite",
        achievement=14310, criteria=48815,
        quest=59869,
        npc=166521,
        loot={
            {180582, mount=1379}, -- Endmire Flyer Tether
            183739, -- Endmire Wristwarmers
        },
        note="Talk to {npc:166483}",
    },
    [32651545] = { label="Forgemaster Madalav",
        quest=61618,
        npc=159496,
        areaPoi=6913, -- Madlav's Hammer
        loot={
            {180939, covenant=Enum.CovenantType.Venthyr}, -- Mantle of the Forgemaster's Dark Blades
            180489, -- Forgemaster's Many-Fold Rapier
            180709, -- Tempered Armor Patch
        },
        -- covenant=Enum.CovenantType.Venthyr,
        note="A Venthyr player channeling Dominance Keep must click the hammer",
    },
    [20485300] = { label="Grand Arcanist Dimitri",
        achievement=14310, criteria=48821,
        quest=60173,
        npc=167464,
        loot={
            180708, -- Mirror of Despair
            180503, -- Grand Arcanist's Soulblade
        },
        note="Kill {npc:167467}",
    },
    [45857920] = { label="Harika the Horrid",
        quest=59612,
        npc=165290,
        areaPoi=6912, -- Dredterror Ballista
        loot={
            183720, -- Dredbatskin Jerkin
            {180461, mount=1310, covenant=Enum.CovenantType.Venthyr}, -- Horrid Brood Dredwing
        },
        -- covenant=Enum.CovenantType.Venthyr,
        note="A Venthyr player channeling Wanecrypt Hill must fire the Dredterror Ballista; fetch the bolt from 42.7 73.4",
        vignette=4480,
    },
    [42757340] = {
        quest=59612,
        loot={176397}, -- Dredhollow Bolt
        hide_before=ns.conditions.Covenant(Enum.CovenantType.Venthyr),
        note="Take to {npc:165327} at 46.3, 77.7",
    },
    [52005180] = { label="Hopecrusher",
        achievement=14310, criteria=48817,
        quest=59900,
        npc=166679,
        loot={
            180874, -- Gargon Whistle
            {180581, mount=1298, covenant=Enum.CovenantType.Venthyr}, -- Hopecrusher Gargon
        },
    },
    [61707950] = { label="Huntmaster Petrus",
        achievement=14310, criteria=48820,
        quest=60022,
        npc=166993,
        loot={
            180874, -- Gargon Whistle
            {180705, class="HUNTER"}, -- Gargon Training Manual
            180405, -- Rusty Gargon Chain
        },
    },
    [21803590] = { label="Innervus",
        achievement=14310, criteria=48801,
        quest=58210,
        npc=160640,
        loot={
            183735, -- Rogue Sinstealer's Mantle
            {183760, quest=62476, covenant=Enum.CovenantType.Necrolord}, -- Venthyr Spectacles (Necro only?)
            180685, -- Soul Sliver
            180686, -- "Borrowed" Soulstone
        },
        note="Get a {item:177223} from {npc:160375}",
    },
    [68008180] = { label="Leeched Soul",
        achievement=14310, criteria=48809,
        quest=59580,
        npc=165152,
        loot={
            {180585, pet=2897}, -- Bottled Up Rage
            183736, -- Pride Resistant Handwraps
        },
        note="Finish the crypt event",
    },
    [76006160] = { label="Lord Mortegore",
        achievement=14310, criteria=48808,
        quest=58633,
        npc=161891,
        loot={
            180501, -- Skull-Formed Headcage
            182968, -- Humerus
        },
        note="Use {item:174378} from nearby mobs to activate 4x {npc:161870}",
    },
    [49003490] = { label="Manifestation of Wrath",
        achievement=14310, criteria=48822,
        quest=60729,
        npc=170048,
        loot={
            {180585, pet=2897}, -- Bottled Up Rage
            180715, -- Bottled Wrath
        },
        note="During {quest:60654} bring ~10x {npc:169916} to {npc:169917}",
    },
    [38306915] = { label="Scrivener Lenua",
        achievement=14310, criteria=48800,
        quest=58213,
        npc=160675,
        loot={
            {180587, pet=2893}, -- Animated Tome
            180693, -- Cyclonic Chronicles
            180694, -- Tome of Power
        },
        note="Bring 4x {npc:160753} to the library",
    },
    [67453050] = { label="Sinstone Hoarder",
        achievement=14310, criteria=50030,
        quest=62252,
        npc=162481,
        loot={
            183732, -- Sinstone-Linked Greaves
        },
        note="Use the Catacombs Cache inside a broken golem",
    },
    [34055555] = { label="Sire Ladinas",
        achievement=14310, criteria=48806,
        quest=58263,
        npc=160857,
        loot={
            {180873, toy=true}, -- Smolderheart
        },
        note="Use {spell:313065} on {npc:157733}",
    },
    [78954975] = { label="Soulstalker Doina",
        achievement=14310, criteria=48799,
        quest=58130,
        npc=160392,
        loot={
            180692, -- Box of Stalker Traps
            180490, -- Soulstalker's Barbs (maybe? wowhead claims...)
        },
        note="Follow when it runs away",
    },
    [31302325] = { label="Stonefist",
        achievement=14310, criteria=48803,
        quest=62220,
        npc=159503,
        loot={
            180488, -- Fist-Forged Breastplate
        },
    },
    [66507080] = { label="Tollkeeper Varaboss",
        achievement=14310, criteria=48812,
        quest=59595, -- also 60583, 
        npc=165253,
        loot={
            {179363, quest=60517}, -- 'Misplaced' Anima Tolls
        },
    },
    [43007910] = { label="Tomb Burster",
        achievement=14310, criteria=48802,
        quest=56877,
        npc=155779,
        loot={
            {180584, pet=2891}, -- Blushing Spiderling
        },
        note="Destroy {npc:155769} near {npc:155777}",
        vignette=4203,
    },
    [38607200] = { label="Worldedge Gorger",
        achievement=14310, criteria=48805,
        quest=58259,
        npc=160821,
        loot={
            {180583, quest=61188}, -- Impressionable Gorger Spawn
        },
        note="Use {item:173939} from nearby mobs near braziers. There's strong speculation that completing {quest:60480:The Endmire} @ 65 63 is needed for the drop.",
    },
})

-- It's Always Sinny In Revendreth
local inquisitor_loot = {
    180493, -- Inquisitor's Robes
    184213, -- Ritualist's Soles
    184214, -- Chained Manacles
    184217, -- Sinstone Stompers
    180451, -- Grand Inquisitor's Sinstone Fragment
}
local high_inquisitor_loot = {
    184211, -- High Inquisitor's Banded Cincture
    184212, -- Intimidator Trainer's Cuffs
    184215, -- Depraved Houndmasster's Grips
    184216, -- Stoneborn Bodyguard's Shoulderplates
    180451, -- Grand Inquisitor's Sinstone Fragment
}
ns.RegisterPoints(1525, {
    [73005200] = { label="Archivist Fane",
        label="{npc:160248}",
        note="Complete quests through {quest:57929}, then spend {currency:1816} to get random sinstones that summon an inquisitor",
    },
    -- Inquisitors
    [76205210] = { label="Inquisitor Traian",
        criteria=48136,
        npc=159151,
        requires_item=172999,
        loot=inquisitor_loot,
    },
    [64704640] = { label="Inquisitor Otilia",
        criteria=48135,
        npc=156918,
        requires_item=172998,
        loot=inquisitor_loot,
    },
    [67254340] = { label="Inquisitor Petre",
        criteria=48134,
        npc=156919,
        requires_item=172997,
        loot=inquisitor_loot,
    },
    [69754720] = { label="Inquisitor Sorin",
        criteria=48133,
        npc=156916,
        requires_item=172996,
        loot=inquisitor_loot,
    },
    [75304415] = { label="High Inquisitor Gabi",
        npc=159152,
        requires_item=173000,
        criteria=48137,
        loot=ns.merge({
            180500, -- High Inquisitor's Bloody Cloak
        }, high_inquisitor_loot),
    },
    [71254235] = { label="High Inquisitor Radu",
        criteria=48138,
        npc=159153,
        requires_item=173001,
        loot=ns.merge({
            180499, -- High Inquisitor's Cloak of Fanaticism
        }, high_inquisitor_loot),
    },
    [72105315] = { label="High Inquisitor Dacian",
        criteria=48140,
        npc=159155,
        requires_item=173006,
        loot=ns.merge({
            180496, -- High Inquisitor's Drape of Shame
        }, high_inquisitor_loot),
    },
    [69755225] = { label="High Inquisitor Magda",
        criteria=48139,
        npc=159154,
        requires_item=173005,
        loot=ns.merge({
            180498, -- High Inquisitor's Obscene Shawl
        }, high_inquisitor_loot),
    },
    [69654540] = { label="Grand Inquisitor Aurica",
        criteria=48142,
        npc=159157,
        requires_item=173008,
        loot={
            177803, -- Grand Inquisitor's Stave
            184210, -- Spiked Cudgel of the Inquisition
        },
    },
    [64505275] = { label="Grand Inquisitor Nicu",
        criteria=48141,
        npc=159156,
        requires_item=173007,
        loot={
            177803, -- Grand Inquisitor's Stave
            184210, -- Spiked Cudgel of the Inquisition
        },
    },
}, {
    achievement=14276,
    note="Spend {currency:1816} with {npc:160248} to try to summon this inquisitor",
    icon=true,
})
