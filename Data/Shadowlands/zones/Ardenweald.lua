local myname, ns = ...

local path = ns.path

local husk = {-- Decayed Husk
    loot={
        -- these are shared with Hunter Vivianna, but they're BoE high-AH items, so...
        179593, -- Darkreach Mask
        179594, -- Witherscorn Guise
    },
}
ns.RegisterVignettes(1565, {
    [4217] = husk,
    [4218] = husk,
    [4219] = husk,
    [4220] = husk,
    [4221] = husk,
    [4554] = husk, -- actually Darkreach Supplies
})

ns.RegisterPoints(1565, {
    [54107640] = path{ -- Decayed Husk entrance
        quest=60710,
        requires=ns.conditions.Vignette(4221),
        routes={{54107640, 53237843}},
    },
})

-- Achievement treasures

ns.RegisterPoints(1565, { -- Ardenweald
    [55902100] = {
        achievement=14313, criteria=50031, -- Aerto's Body
        quest=61072,
        loot={
            {180630, pet=2921}, -- Gorm Harrier
        },
        note="A swarm of insects will attack you after looting the treasure",
    },
    [52903730] = {
        achievement=14313, criteria=50033, -- Veilwing Egg
        quest=61065, -- also 58013?
        loot={
            {180642, pet=2909}, -- Cloudfeather Fledgling
        },
        note="On top of a branch; run through the level 60 area above to get to it",
    },
    [49705590] = {
        achievement=14313, criteria=50035, -- Faerie Trove
        quest=61073,
        loot={
            {182673, pet=3022}, -- Shimmerbough Hoarder
        },
        note="Inside a small alcove under the clearing",
    },
    [48203920] = {
        achievement=14313, criteria=50037, -- Hearty Dragon Plume
        quest=61067,
        loot={
            {182729, toy=true}, -- Hearty Dragon Plume
        },
        note="Up in a tree; go to the slow-fall feather above the waterfall at 48.9 41.1",
        path={48964106, atlas="poi-door-arrow-up", note="Slow-fall feather to reach the treasure"},
    },
    [63903750] = {
        achievement=14313, criteria=50039, -- Cache of the Moon
        quest=61074, -- also 61126 for having turned in the tools
        loot={
            {180731, mount=1397}, -- Wildseed Cradle
        },
        atlas="VignetteLootElite",scale=1.2,
        minimap=true,
        note="Locate 5 tools scattered around the Garden of Night (southeast of Root-Home), combine them into {item:180753:Twinklestar's Gardening Toolkit} and bring them to {npc:171360:Twinklestar} in Tirna Vaal.\nAfter this is done, talk to Twinklestar to receive the {spell:334353:Moonsight} buff",
        routes={
            {63903750, 38995696, highlightOnly=true, _related=38995696,},
            {63903750, 39755440, highlightOnly=true, _related=39755440,},
            {63903750, 40315262, highlightOnly=true, _related=40315262,},
            {63903750, 38495808, highlightOnly=true, _related=38495808,},
            {63903750, 38856010, highlightOnly=true, _related=38856010,},
        },
    },
    [38995696] = {quest=61074,achievement=14313, criteria=50039,label="{item:180759:Diary of the Night}",inbag={180759,180753,any=true},atlas="DruidEclipse-LunarMoon",minimap=true,route=63903750},
    [39755440] = {quest=61074,achievement=14313, criteria=50039,label="{item:180754:Gardener's Hammer}",inbag={180754,180753,any=true},atlas="DruidEclipse-LunarMoon",minimap=true,route=63903750},
    [40315262] = {quest=61074,achievement=14313, criteria=50039,label="{item:180758:Gardener's Basket}",inbag={180758,180753,any=true},atlas="DruidEclipse-LunarMoon",minimap=true,route=63903750},
    [38495808] = {quest=61074,achievement=14313, criteria=50039,label="{item:180756:Gardener's Flute}",inbag={180756,180753,any=true},atlas="DruidEclipse-LunarMoon",minimap=true,route=63903750},
    [38856010] = {quest=61074,achievement=14313, criteria=50039,label="{item:180757:Gardener's Wand}",inbag={180757,180753,any=true},atlas="DruidEclipse-LunarMoon",minimap=true,route=63903750},
    [37603710] = {
        achievement=14313, criteria=50041, -- Dreamsong Heart
        quest=61070,
        loot={
            179510, -- Dreamsong Warglaive
        },
        note="Use a Jumping Mushroom hidden in Dreamsong Fenn to climb to the top of the tree",
    },
    [44707570] = {
        achievement=14313, criteria=50043, -- Elusive Faerie Cache
        quest=61175,
        loot={
            179512, -- Dreamsong Saber
            {184490, toy=true}, -- Fae Pipes
        },
        note="Requires grabbing the {spell:333923:Faerie Lamp} buff at 46.4 70.9 to unlock the treasure",
        path={
            46507010,
            label="{spell:333923:Faerie Lamp}",
            note="Take to 44.7 75.7",atlas="worldquest-icon-inscription",
        },
    },
    [36106520] = {
        achievement=14313, criteria=50045, -- Darkreach Supplies
        quest=61068,
        loot={
            179593, -- Darkreach Mask
            179594, -- Witherscorn Guise
        },
        note="Use the jumping mushroom on the cliff above at 37.7 61.5",
        path=37706150,
    },
    [48202030] = {
        achievement=14313, criteria=50032, -- Lost Satchel
        quest=62187,
        loot={
            {182731, quest=62187}, -- Satchel of Culexwood
        },
        onquest=62187,
        note="Carefully climb down the branch. Starts {quest:62187:Satchel of Culexwood}",
    },
    [76602970] = {
        achievement=14313, criteria=50034, -- Swollen Anima Seed
        quest=62186,
        inbag=182730,
        loot={
            {182730, quest=62186}, -- Swollen Anima Seed
        },
        note="Starts {quest:62186:Swollen Anima Seed}",
    },
    [67803450] = {
        achievement=14313, criteria=50036, -- Harmonic Chest
        quest=61165,
        loot={
            {184489, toy=true}, -- Fae Harp
            179565, -- Songwood Stem
        },
        note="Requires 2 players to play the nearby harp and drums at the same time",
    },
    [41903250] = {
        achievement=14313, criteria=50040, -- Dessicated Moth
        quest=61147,
        loot={
            {180640, pet=2911}, -- Amber Glitterwing
        },
        note="Loot the {item:180784:Aromatic Flowers} at 36.4 59.5, then use the jumping mushroom near the treasure location to jump on to a tree. Use the flowers on the brazier within the tree to attract the treasure",
        path={
            36405950,
            label="{item:180784:Aromatic Flowers}",
            note="Take to the Dessicated Moth at 41.9 32.5", atlas="worldquest-icon-herbalism", scale=1,
            highlightOnly=true,
        },
    },
    [36402500] = {
        achievement=14313, criteria=50042, -- Enchanted Dreamcatcher
        quest=62259,
        loot={
            {183129, quest=62259}, -- Anima-Laden Dreamcatcher
        },
        onquest=62259,
        note="Carefully climb the roots in the area. Starts {quest:62259:Anima-Laden Dreamcatcher}",
    },
    [36006650] = {
        achievement=14313, criteria=50044, -- Cache of the Night
        quest=61110,
        loot={
            {180637, pet=2914}, -- Starry Dreamfoal
            179549, -- Nightwillow Cudgel
        },
        atlas="VignetteLootElite",scale=1.2,
        minimap=true,
        note="Loot {item:180654:Fae Ornament}, {item:180656:Enchanted Bough} and {item:180655:Raw Dream Fibers} scattered around Ardenweald to create the {item:180652:Fae Dreamcatcher}, which will let you reach the treasure. You might need to relog if you can't see it once you're there",
        routes={
            {36006650, 42414672, highlightOnly=true, _related=42414672,},
            {36006650, 51556160, highlightOnly=true, _related=51556160,},
            {36006650, 36982983, highlightOnly=true, _related=36982983,},
        },
    },
    [42414672] = {quest=61110,achievement=14313,criteria=50044,label="{item:180656:Enchanted Bough}",inbag=180656,atlas="covenantchoice-offering-sigil-nightfae",minimap=true,note="Combine to unlock the Cache of the Night at 36,66",route=36006650},
    [51556160] = {quest=61110,achievement=14313,criteria=50044,label="{item:180654:Fae Ornament}",inbag=180654,atlas="covenantchoice-offering-sigil-nightfae",minimap=true,note="Combine to unlock the Cache of the Night at 36,66",route=36006650},
    [36982983] = {quest=61110,achievement=14313,criteria=50044,label="{item:180655:Raw Dream Fibers}",inbag=180655,atlas="covenantchoice-offering-sigil-nightfae",minimap=true,note="Combine to unlock the Cache of the Night at 36,66",route=36006650},
})

local vulpin = {
    achievement=14313, criteria=50038, -- Playful Vulpin Befriended
    quest=61086, -- also 61080, 61081, 61084, 61085 for progress (61078 also triggers)
    progress={61080, 61081, 61084, 61085, 61086},
    loot={
        {180645, pet=2905}, -- Dodger
    },
    note="Find {npc:171206:Playful Vulpin} and play with them 5 times to obtain the treasure. Use emotes related to what they're doing, in order: /curious, /sit, /sing, /dance, /pet.",
    atlas="honorsystem-icon-bonus", scale=1,
    minimap=true,
    group="Playful Vulpin",
}
ns.RegisterPoints(1565, {
    [31854363] = vulpin,
    [31764100] = vulpin,
    [32604292] = vulpin,
    [34104500] = vulpin,
    [50215353] = vulpin,
    [41312874] = vulpin,
    [40945156] = vulpin,
    [41374979] = vulpin,
    [51165507] = vulpin,
    [67162888] = vulpin,
    [70143004] = vulpin,
    [65222265] = vulpin,
    [67553191] = vulpin,
    [72393146] = vulpin,
})

ns.RegisterPoints(1565, { -- Ardenweald
    [51836923] = {},
    [60005513] = {},
    [65083646] = {},
    [51213104] = {},
    [37593625] = {},
    [69852732] = {},
}, {
    quest=64961,
    loot={
        {187819, quest=64961, covenant=Enum.CovenantType.NightFae}, -- Cat Soul
    },
    note="/soothe the {npc:181694:Lost Soul}, at the very top of one of the great trees",
    hide_before=ns.conditions.Covenant(Enum.CovenantType.NightFae),
    atlas="sanctumupgrades-nightfae-32x32",
    minimap=true,
    group="soulshape",
})
-- other soulshapes:
-- In Heart of the Forest
-- Corgi: /pet Sparkle (64938)
-- Squirrel: Ask Choofa (64939)

-- Non-achievement treasures
ns.RegisterPoints(1565, { -- Ardenweald
    [26285897] = {
        quest=61192, -- failed:61208, passed: 61198; 58013 happened as well?
        note="Read the Tale of the Tangle, then follow blue lamps until you find {npc:171767:Shizgher}",
    },
    [32515302] = {
        label="Tale of the Tangle",note="Read, then follow the blue lamps to find {npc:171767:Shizgher}",
        atlas="poi-workorders",
        minimap=true,
    },
}, {
    quest=61192,
    loot={
        {180727, mount=1360}, -- Shimmermist Runner
    },
})

-- Fractured Fairy Tales

local meandering = ns.nodeMaker{
    criteria=50012,onquest=62619,inbag=183877,loot={{183877,quest=62619}},
}
local wandering = {criteria=50013,onquest=62620,inbag=183878,loot={{183878,quest=62620}},}
local escapist = {criteria=50014,onquest=62621,inbag=183879,loot={{183879,quest=62621}},}
local travel = {criteria=50015,onquest=62622,inbag=183880,loot={{183880,quest=62622}},}
local naughty = {criteria=50016,onquest=62623,inbag=183881,loot={{183881,quest=62623}},}
ns.RegisterPoints(1565, {
    [63602275] = {atlas="Campaign-QuestLog-LoreBook-Back",label="{npc:165867}",note="Bring books to him",criteria=true},
    [54604300] = meandering{
        routes={
            {54604300, 53004450, 51604490, 51004580, 50004560},
            {54604300, 53904260, 53504170, 52204080, 50903970, 50703860, 51503680},
            {54604300, 55004100, 56503980, 57103960, 57803820, 59003720, 57603590, 56403400, 55603390},
            {59003720, 59303700, 60303700, 60303630},
        },
    },
    [51405040] = meandering{
        routes={{51405040, 52405140, 53605100, 55005360, 56805240}},
    },
    [30004480] = wandering,
    [35602680] = wandering,
    [36104870] = wandering, -- (36404800 is more accurate, but overlaps Macabre)
    [37904005] = wandering,
    [32603160] = escapist,
    [40004460] = escapist,
    [40602760] = escapist,
    [40954230] = escapist,
    [40104170] = travel, -- Travel Journal
    [49654015] = travel,
    [50202500] = travel,
    [50154185] = travel,
    [55002100] = travel,
    [24755197] = naughty, -- Naughty Story
    [33605740] = naughty,
    [39806560] = naughty,
    [51005480] = naughty,
}, {
    achievement=14788,
    atlas="Campaign-QuestLog-LoreBook",
    minimap=true,
    --level=60,
})

-- ns.RegisterPoints(1565, {
--     [62503955] = {
--         label="Wish Cricket",
--         quest=60829,
--     },
--     [64052240] = {
--         label="Faerie Stash",
--         quest=60717,
--     },
    -- [61165667] = {
    --     label="Lunarlight pod",
    --     quest=60794, -- progress: 60820, 60821, 60822, 60823, 60824
    --     note="Stand on the 5 nearby buds first",
    -- },
-- })

ns.RegisterPoints(1565, {
    -- These wind up being in columns by set-of-points, but I don't have a
    -- good way to trigger filtering it down after you complete one. I could
    -- change this so that each set is a distinct color, rather than each
    -- quest? Not sure which is more understandable to the user.
    [-49943207] = {
        quest=61696,
        nearby={53093300, 52263243, 52513374, 52903321, 52463341,
            color={r=1,g=0,b=0},
            label="{npc:173005:Lunarlight Bud}"},
    },
    [-50593357] = {
        quest=61695,
        nearby={52333168, 51883147, 51803235, 52003200, 51983092,
            color={r=0,g=1,b=0},
            label="{npc:173006:Lunarlight Bud}"},
    },
    [-50593358] = {
        quest=61693,
        nearby={50593358, 50373296, 50863301, 50323272, 50043325,
            color={r=0,g=0.5,b=1},
            label="{npc:173009:Lunarlight Bud}"},
            -- 50593358 was 173008, but the quest was this one
    },
    [-51813384] = {
        quest=61694,
        nearby={51813384, 51473408, 51433329, 51893337, 51003439,
            color={r=1,g=1,b=0},
            label="{npc:173008:Lunarlight Bud}"},
            -- 51813384 was 173009, but the quest was this one
    },
    [-51023226] = {
        quest=61692,
        nearby={51023226, 50533181, 51183249, 49943207, 50253164,
            color={r=0.5,g=0,b=1},
            label="{npc:173010:Lunarlight Bud}"},
    },
}, {
    quest=61691,
    label="Large Lunarlight Pod",
    poi={{1565, 6908}},
    worldmap=false,
    minimap=false,
})

-- Rares
ns.RegisterPoints(1565, {
    [34606800] = { label="Deathbinder Hroth",
        achievement=14309, criteria=48714,
        quest=59226,
        npc=164477,
        loot={180166}, -- Deathbinder's Staff
        --level=60, -- assumed
    },
    [47502845] = { label="Deifir the Untamed",
        achievement=14309, criteria=48784,
        quest=59201,62271,
        npc=164238,
        loot={
            {180631, pet=2920}, -- Gorm Needler
        },
        --level=60, -- assumed
        note="Runs in circles around the area. Ride and use {spell:319566} and {spell:319575} to slow and stun it",
    },
    [48407715] = { label="Dustbrawl",
        achievement=14309, criteria=48794,
        quest=58987,
        npc=163229,
        loot={
            181395, -- Dustbreak Maul
        },
    },
    [58403230] = { label="Egg-Tender Leh'go",
        achievement=14309, criteria=48790,
        quest=60266,
        npc=167851,
        loot={
            179539, -- Kelox's Eggbeater
        },
        note="Destroy eggs in the burrow; you might have to wait a minute afterwards",
    },
    [68602765] = { label="Faeflayer",
        achievement=14309, criteria=48798,
        quest=61184,
        npc=171688,
        label="{npc:171688}", -- the criteria is bugged and says Soultwister Cero
        loot={
            180144, -- Faeflayer's Hatchet
        },
        note="Hidden behind the waterfall",
        path=70403060,
    },
    [54057600] = { label="Gormbore",
        achievement=14309, criteria=48795,
        quest=59006,
        npc=163370,
        label="{npc:163370}", -- another one with a mislabeled criteria
        loot={
            {183196, pet=3035}, -- Lavender Nibbler
        },
        note="Kill {npc:165420}s over the shaking ground to spawn",
    },
    [27905250] = { label="Gormtamer Tizo",
        achievement=14309, criteria=48781,
        quest=59145,
        npc=164107,
        loot={
            {180725, mount=1362}, -- Spinemaw Gladechewer
        },
        --level=60, -- assumed
        note="Kill {npc:166736} until it spawns",
    },
    [32403025] = { label="Humon'gozz",
        achievement=14309, criteria=48782,
        quest=59157,
        npc=164112,
        loot={
            {182650, mount=1415}, -- Arboreal Gulper
        },
        note="Loot {item:175247} and use the Damp Loam to summon"
    },
    [67455145] = { label="Hunter Vivianna",
        achievement=14309, criteria=48787,
        quest=59221,
        npc=160448,
        loot={
            179593, -- Darkreach Mask (cloth)
            179594, -- Witherscorn Guise (leather)
            179596, -- Drust Mask of Dominance
            {183091, quest=62246}, -- Lifewoven Bracelet
        },
        note="Starts {quest:62246}",
    },
    [62102470] = { label="Mymaen",
        achievement=14309, criteria=48788,
        quest=59431,
        npc=165053,
        loot={
            179502, -- Ripvine Barb
        },
        note="Kill {npc:165050} to summon",
    },
    [65502910] = { label="Mystic Rainbowhorn",
        achievement=14309, criteria=48715,
        quest=59235,
        npc=164547,
        loot={
            179586, -- Elderwood Piercer
            {182179, quest=62434, covenant=Enum.CovenantType.NightFae}, -- Runestag Soul
        },
        atlas="colorblind-colorwheel",
        note="Great Horn of the Runestag spawns around the zone. Blow it, and this will spawn here then start running around the zone very quickly",
    },
    [51105740] = { label="Old Ardeite",
        achievement=14309, criteria=48785,
        quest=59208, -- 62270?
        npc=164391,
        loot={
            {180643, pet=2908}, -- Chirpy Valeshrieker
        },
        note="Get {spell:313053} from buckets in Shimmerbough, use it to reach the rare",
    },
    [65104430] = { label="Rootwrithe",
        achievement=14309, criteria=48791,
        quest=60273,
        npc=167726,
        loot={
            179603, -- Nettlehusk Barrier
        },
        --level=60,
        note="Hit all the flowers",
    },
    [65702430] = { label="Rotbriar Boggart (but the criteria is called Rotbriar Changeling)",
        achievement=14309, criteria=48789,
        quest=60258,
        npc=167724,
        loot={
            175729, -- Rotbriar Sprout
        },
        note="Talk to {npc:174365} to start."
    },
    -- Relatedly... Toss a Seed to Your Hunter
    [65752400] = {
        achievement=14791,
        icon=true,
        note="Loot {item:183902} around the zone, use the bonus action button to throw it at {npc:174364}",
    },
    [72405175] = { label="Soultwister Cero",
        achievement=14309, criteria=48797,
        quest=61177,
        npc=171451,
        loot={
            180164, -- Soultwister's Scythe
        },
    },
    [37675917] = { label="Skuld Vit",
        achievement=14309, criteria=48786,
        quest=59220,
        npc=164415,
        loot={
            180146, -- Axe of Broken Wills
            {182183, quest=62439, covenant=Enum.CovenantType.NightFae}, -- Wolfhawk Soul
        },
        note="Use {spell:310143} to get in",
    },
    [59304660] = { label="The Slumbering Emperor",
        achievement=14309, criteria=48792,
        quest=60290,
        npc=167721,
        loot={
            175711, -- Slumberwood Band
            {183828,covenant=Enum.CovenantType.Necrolord,quest=62574,}, -- Friendly Bugs
        },
        note="Use AOE or a flare on the foggy area",
    },
    [30105535] = { label="Valfir the Unrelenting",
        achievement=14309, criteria=48796,
        quest=61632,
        npc=168647,
        areaPoi=6910, -- Sparkling Animaseed
        loot={
            {180730, mount=1393, covenant=Enum.CovenantType.NightFae}, -- Wild Glimmerfur Prowler
            180154, -- Greataxe of Unrelenting Pursuit
            {182176, quest=62431, covenant=Enum.CovenantType.NightFae}, -- Shadowstalker Soul (quest=62431)
        },
        --level=60, -- assumed
        -- covenant=Enum.CovenantType.NightFae,
        note="A Night Fae player channeling the Tirna Scithe must:\n"..
            "* Pick up a {spell:338045}\n"..
            "* Use {spell:338045} to remove {spell:338038}",
        nearby={30455555, label="Sparkling Animaseed"},
    },
    [58306180] = { label="Wrigglemortis",
        achievement=14309, criteria=48783,
        quest=59170,
        npc=164147,
        loot={
            181396, -- Thornsweeper Scythe
        },
        note="Drag out of the ground",
    },
    -- Ardenweald's a Stage:
    [41254445] = {
        achievement=14353, criteria=true,
        quest=61633, -- this is the overall questid for the event, but each rare has its own quest as well
        -- Argus (quest: 61202)
        -- Azshara (quest: 61201)
        -- Gul'dan (quest: 61204)
        -- Jaina (quest:61205)
        -- Kil'jaeden (quest: 61203)
        -- N'Zoth (quest: 61206)
        -- Xavius (quest: 61207)
        areaPoi=6909, -- Dapperdew
        loot={
            179534, -- Mikai's Deathscythe (Argus)
            179518, -- Glimmerlight Staff (Azshara)
            182454, -- Murmurs in the Dark (Guldan)
            182451, -- Glimmerdust's Grand Design (Kil'Jaeden)
            182452, -- Everchill Brambles (Jaina)
            182453, -- Twilight Bloom (N'Zoth)
            182455, -- Dreamers Mending (Xavius)
            -- the vendor sells:
            {181304, covenant=Enum.CovenantType.NightFae, note="Vendor"}, -- Winterwoven Branches
            {182175, quest=62430, covenant=Enum.CovenantType.NightFae, note="Vendor"}, -- Moose Soul
            {187873, quest=64992, covenant=Enum.CovenantType.NightFae, note="Vendor"}, -- Prairie Dog Soul
            {180748, mount=1332, note="Vendor"}, -- Silky Shimmermoth
        },
        atlas="VignetteLootElite",scale=1.2,
        -- covenant=Enum.CovenantType.NightFae,
        note="A Night Fae player must talk to {npc:171743} to start a play; there are 7 possible encounters, one per day. After you can buy items from {npc:163714} depending on how many rares you've cleared.",
    },
    [43204710] = {
        label="{npc:163714}",
        note="Buy items unlocked by the Ardenweald's a Stage rares",
        loot={
            -- the vendor sells:
            {181304, covenant=Enum.CovenantType.NightFae}, -- Winterwoven Branches
            {182175, quest=62430, covenant=Enum.CovenantType.NightFae}, -- Moose Soul
            {187873, quest=64992, covenant=Enum.CovenantType.NightFae}, -- Prairie Dog Soul
            {180748, mount=1332}, -- Silky Shimmermoth
        },
        active=ns.conditions.QuestComplete(61633),
        atlas="banker",
        minimap=true,
    },
})

local macabre = { -- Macabre
    achievement=14309, criteria=48780,
    quest=59140, -- Also 62269
    npc=164093,
    loot={
        {180644, pet=2907}, -- Rocky
    },
    note="Stand in a Mysterious Mushroom Ring with three players dancing",
}
ns.RegisterPoints(1565, {
    [36504790] = macabre,
    [32704477] = macabre,
    [57932936] = macabre,
})

ns.RegisterPoints(1565, {
    [62155220] = { label="Night Mare",
        npc=168135,
        loot={
            {180728, mount=1306}, -- Swift Gloomhoof
        },
        -- requires_item=178675,
        note="* Loot {item:181243} at 19.7 63.5 (may need a glider)\n"..
            "* Do Night Fae quests through {quest:57871}\n"..
            "* Ask {npc:165704} to repair {item:181243}\n"..
            "* Get {item:178675} from {npc:160262} (talk to the guards if you're not Night Fae)\n"..
            "* Use {item:178675} here, and defeat the rare",
    },
    [18056200] = ns.path{
        atlas="poi-door-arrow-up",
        inbag={181243,181242,178675,any=true},
        note="Jump to the root; a glider might help, but isn't required"
    },
    [19706350] = {
        label="{item:181243:Broken Soulweb}",
        loot={181243},
        inbag={181243,181242,178675,any=true},
        minimap=true,
        note="Take it to {npc:165704} at Glitterfall Basin",
    },
    [50403310] = {
        label="{npc:165704:Elder Gwenna}",
        loot={181242},
        inbag=181242,
        requires_item=181243,
        atlas="repair",
        minimap=true,
        note="DISMOUNT FIRST! Ask her to repair your soulweb, then take it to Ysera at Heart of the Forest. If she's not here, do the nearby quests",
    },
    [47805370] = {
        label="{npc:160262:Ysera}",
        requires_item=181242,
        loot={178675}, -- Dream Catcher
        inbag=178675,
        atlas="worldquest-icon-enchanting",
        minimap=true,
        note="DISMOUNT FIRST! Ask the guards to call her out if you're not allowed in, then go to Hibernal Hollow",
    },
}, {
    achievement=14309, criteria=48793,
    quest=60306,
    --level=60, -- assumed
})
