local myname, ns = ...

local path = ns.path

-- Technically Gilded Wader ({180866, pet=2938}) drops from most of the
-- calling treasures, but... it seems to be really really rare and
-- shadowlands-wide, so I'm leaving it out.

local bell = {-- Broken/Skyward Bell
    loot={
        {184415, toy=true}, -- Soothing Vesper
    },
}
local strongbox = {-- Silver Strongbox
    loot={
        {184418, toy=true}, -- Acrobatic Steward
    },
    note="Bring a {item:178915:Ripe Purian} to open",
}
ns.RegisterVignettes(1533, {
    [4239] = bell,
    [4240] = bell,
    [4241] = bell,
    [4242] = bell,
    [4243] = bell,
    [4275] = bell,

    [4214] = ns.merge(CopyTable(strongbox), {note=false}), -- actually Gilded Chest
    [4263] = strongbox,
    [4264] = strongbox,
    [4265] = strongbox,
    [4266] = strongbox,
    [4267] = strongbox,
    [4268] = strongbox,
    [4269] = strongbox,
    [4270] = strongbox,
    [4271] = strongbox,
    [4272] = strongbox,
    [4273] = strongbox,
    [4277] = strongbox,
})

-- Pepe costume: A Tiny Pair of Wings, 186593, q 64136

-- choosing larion: 60294

ns.RegisterPoints(1533, { -- Bastion
    [53508030] = {
        achievement=14311, criteria=50047, -- Scroll of Aeons
        quest=58298,
        loot={
            {173984, toy=true}, -- Scroll of Aeons
        },
        note="Loot 2x {item:173973:Purian} around Aspirant's Crucible and put them in tribute bowls",
    },
    [58507150] = {
        achievement=14311, criteria=50048, -- Vesper of Virtues
        quest=60478,
        loot={
            179982, -- Kyrian Bell
        },
        note="Located inside a building in the Temple of Purity",
    },
    [52008600] = {
        achievement=14311, criteria=50049, -- Purifying Draught
        quest=58329,
        loot={
            174007, -- Purifying Draught
        },
        note="Near an angel's statue",
    },
    [59306080] = {
        achievement=14311, criteria=50050, -- Lost Disciple's Notes
        quest=61048,
        loot={
            {182693, quest=62170}, -- Lost Disciple's Notes
        },
        note="Jump from the cliff on top to reach the treasure",
    },
    [58204000] = {
        achievement=14311, criteria=50051, -- Larion Tamer's Harness
        quest=61049,
        loot={
            -- 182652, -- Larion Tamer's Harness (not present)
            182653, -- Larion Treats
            183126, -- Kyrian Smith's Kit
        },
        note="Located at the end of the cavern",
        path=55704290,
    },
    [40404980] = {
        achievement=14311, criteria=50052, -- Stolen Equipment
        quest=61044,
        loot={
            182561, -- Fallen Disciple's Cloak
        },
        note="Random BOE uncommon / rare item",
    },
    [46124536] = {
        achievement=14311, criteria=50053, -- Abandoned Stockpile
        quest=61006,
        -- loot=Random Greens/Materials,
        note="Entrance is hidden behind some bushes",
        --level=60,
        path=46434657,
    },
    [51401790] = {
        achievement=14311, criteria=50054, -- Experimental Construct Part
        quest=61052,
        loot={
            183609, -- Re-Powered Golliath Fists
        },
        --level=60,
        note="Requires {item:180534:Unstable Construct Anima}, from containers nearby",
    },
    [35804810] = {
        achievement=14311, criteria=50055, -- Windsmith's Tools
        quest=61053,
        loot={
            180064, -- Ascended Flute
        },
        --level=60,
        note="Requires {item:180536:Broken Kyrian Flute} to unlock the treasure, dropped from {npc:159610:Agitated Etherwyrm} nearby",
    },
    [56501720] = {
        achievement=14311, criteria=50056, -- Memorial Offering
        quest=61150,
        -- loot={},
        --level=60,
        note="Purchase {item:180788:Memorial Wine} from {npc:171526:Kobri} and use it on the drink tray near the treasure to obtain the {item:180797:Memorial Offering Key} and unlock the treasure",
        routes={
            {34006650, 56501720, highlightOnly=true, _related=34006650},
            {43603225, 56501720, highlightOnly=true, _related=43603225},
            {47957400, 56501720, highlightOnly=true, _related=47957400},
            {51804640, 56501720, highlightOnly=true, _related=51804640},
            {52154710, 56501720, highlightOnly=true, _related=52154710},
            {53508035, 56501720, highlightOnly=true, _related=53508035},
        },
        nearby={56841908},
    },
    [34006650] = {quest=61150, label="{npc:171526:Kobri}", atlas="food", scale=1.1, note="Buy {item:180788:Memorial Wine}, go to 56.5 17.2", upcoming=false, route=56501720}, -- Kobri (Cliffs of Respite)
    [43603225] = {quest=61150, label="{npc:171526:Kobri}", atlas="food", scale=1.1, note="Buy {item:180788:Memorial Wine}, go to 56.5 17.2", upcoming=false, route=56501720}, -- Kobri (Sagehaven)
    [47957400] = {quest=61150, label="{npc:171526:Kobri}", atlas="food", scale=1.1, note="Buy {item:180788:Memorial Wine}, go to 56.5 17.2", upcoming=false, route=56501720}, -- Kobri (Aspirant's Rest)
    [51804640] = {quest=61150, label="{npc:171526:Kobri}", atlas="food", scale=1.1, note="Buy {item:180788:Memorial Wine}, go to 56.5 17.2", upcoming=false, route=56501720}, -- Kobri (Hero's Rest)
    [52154710] = {quest=61150, label="{npc:171526:Kobri}", atlas="food", scale=1.1, note="Buy {item:180788:Memorial Wine}, go to 56.5 17.2", upcoming=false, route=56501720}, -- Kobri (Hero's Rest)
    [53508035] = {quest=61150, label="{npc:171526:Kobri}", atlas="food", scale=1.1, note="Buy {item:180788:Memorial Wine}, go to 56.5 17.2", upcoming=false, route=56501720}, -- Kobri (Aspirant's Crucible)
    [35105800] = {
        achievement=14311, criteria=50058, -- Gift of Agthia
        quest=60893,
        loot={
            180063, -- Unearthly Chime
        },
        --level=60,
        note="Obtain the {spell:333063:Proof of Courage} by interacting with {spell:333365:Agthia's Flame} at 39.1 54.4. Then follow the Path of Courage braziers to reach the treasure.",
        path={
            39105440,
            label="{spell:333365:Agthia's Flame}",
            note="Take {spell:333063:Proof of Courage} to 35.1 58.0, by following and lighting the braziers",
            atlas="MantidTower",
        },
    },
    [65207030] = {
        achievement=14311, criteria=50059, -- Gift of Vesiphone
        quest=60890,
        loot={
            {180859, pet=2935}, -- Purity
        },
        --level=60,
        note="Obtain {spell:332785:Proof of Purity} by ringing the bell near the chest and standing under the nearby waterfall to unlock the treasure",
    },
    [70503650] = {
        achievement=14311, criteria=50060, -- Gift of Chyrus
        quest=60892,
        loot={
            {183988, toy=true}, -- Bondable Val'kyr Diadem
        },
        --level=60,
        note="Obtain the {spell:333045:Proof of Humility} by using /kneel in front of the treasure to unlock it",
    },
    [40201820] = {
        achievement=14311, criteria=50061, -- Gift of Thenios
        quest=60894,
        loot={
            {181290, covenant=Enum.CovenantType.Kyrian}, -- Harmonious Sigil of the Archon
        },
        --level=60,
        note="Obtain the {spell:333068:Proof of Wisdom} by using the teleporter near the chest and lighting the incenses in the correct order:\n* Incense of Patience\n* Incense of Knowledge\n* Incense of Insight\n* Anima Orb\n* Incense of Judgement\nYou'll have to go through the path multiple times to do this",
    },
    [27602170] = {
        achievement=14311, criteria=50062, -- Gift of Devos
        quest=60895,
        loot={
            179977, -- Benevolent Gong
        },
        --level=60,
        note="Obtain the {spell:333070:Proof of Loyalty} by taking the {spell:333912:Flame of Devotion} at 23.9 24.8 and bringing it to the nearby brazier",
        path={
            23902480,
            label="{spell:333912:Flame of Devotion}",
            note="Taking the {spell:333912:Flame of Devotion} to the brazier at 27.6 21.7",
            atlas="MantidTower",
        },
    },
})

-- Shard Labor:

local shard = ns.nodeMaker{
    label="Anima Shard",
    achievement=14339,
    --level=60,
    atlas="azeriteready",
    minimap=true,
    upcoming=false,
}
ns.RegisterPoints(1533, {
    -- Shard Labor
    [36012652] = {
        quest=61183,
        achievement=14339,
        label="Vesper of Silver Wind",
        loot={
            {180772, mount=1404}, -- Silverwind Larion
        },
        --level=60,
        atlas="VignetteLootElite", scale=1.2,
        note="Forge the {item:180858:Crystal Mallet of Heralds} and then ring the vesper",
    },
    [59343144] = {
        quest=61229,
        achievement=14339,
        loot={
            180858, -- Crystal Mallet of Heralds
        },
        --level=60,
        atlas="vehicle-hammergold",
        note="Collect 50 Anima Shards and give them to {npc:171732:Forgelite Hephaesius}",
        upcoming = false,
    },
    [39057704] = shard{quest=61225,note="Platform under the bridge"},
    [43637622] = shard{quest=61235,note="On the waterfall, go around and jump down"},
    [48427273] = shard{quest=61236,note="On the arch, glider to it from the cliffs nearby"},
    [52677555] = shard{quest=61237},
    [53317362] = shard{quest=61238,note="Under the bridge"},
    [53498060] = shard{quest=61239},
    [55968666] = shard{quest=61241,note="Ledge above the door"},
    [61048566] = shard{quest=61244},
    [58108008] = shard{quest=61245},
    [56877498] = shard{quest=61247,note="On the wall, carefully jump down from the balcony above"},
    [65527192] = shard{quest=61249,note="On the upper level"},
    [58156391] = shard{quest=61250},
    [54005970] = shard{quest=61251},
    [46706595] = shard{quest=61253},
    [50685614] = shard{quest=61254},
    [34846578] = shard{quest=61257},
    [51674802] = shard{quest=61258,note="A ledge on the side of Hero's Rest"},
    [47084923] = shard{quest=61260,note="Beneath the anima gateway"},
    [41394663] = shard{quest=61261,note="Jump down from the cliff"},
    [40045912] = shard{quest=61263,note="Up on the pillars"},
    [38525326] = shard{quest=61264},
    [57645567] = shard{quest=61270},
    [65254288] = shard{quest=61271,note="Upper ledge, in a box"},
    [72384029] = shard{quest=61273},
    [66892692] = shard{quest=61274},
    [57553827] = shard{quest=61275,note="Underground in the Hall of Beasts, behind some crates"},
    [52163939] = shard{quest=61277,note="Up on the pillars"},
    [49993826] = shard{quest=61278,note="On the ledge under the bridge"},
    [48483491] = shard{quest=61279,note="Up on the pillars"},
    [56722884] = shard{quest=61280},
    [56201731] = shard{quest=61281,note="Ledge above the Memorial Offering, need to jump down from above"},
    [59881391] = shard{quest=61282,note="Work your way down from above"},
    [52440942] = shard{quest=61283,note="Inside Covinkles' Workshop, behind some crates"},
    [46691804] = shard{quest=61284,note="Up on a ledge, path starts across water to the south @ ~45.7 19.9"},
    [44942845] = shard{quest=61285},
    [42302402] = shard{quest=61286,note="Up on the ledge"},
    [37102468] = shard{quest=61287,note="Run around the ledge from the north"},
    [42813321] = shard{quest=61288},
    [42713940] = shard{quest=61289,note="Jump down from the cliff"},
    [33033762] = shard{quest=61290},
    [31002747] = shard{quest=61291},
    [30612373] = shard{quest=61292},
    [24642298] = shard{quest=61293},
    [26152262] = shard{quest=61294},
    [24371821] = shard{quest=61295},
})
ns.RegisterPoints(1666, { -- Necrotic Wake
    [52508860] = shard{quest=61296},
    [36202280] = shard{quest=61297},
})
ns.RegisterPoints(1693, { -- Spires of Ascension (Gardens of Repose)
    [46605310] = shard{quest=61298},
    [69403870] = shard{quest=61299},
})
ns.RegisterPoints(1694, { -- Spires of Ascension (Font of Fealty)
    [49804690] = shard{quest=61300},
})

-- What is that Melody?

ns.RegisterPoints(1533, {
    [42902730] = {criteria=49950}, -- Hymn of Wisdom
    [42502560] = {criteria=49950}, -- Hymn of Wisdom
    [41702420] = {criteria=49950}, -- Hymn of Wisdom
    [42202370] = {criteria=49950}, -- Hymn of Wisdom
    [43182810] = {criteria=49950}, -- Hymn of Wisdom
    [66104080] = {criteria=49949}, -- Hymn of Humility
    [69304110] = {criteria=49949}, -- Hymn of Humility
    [68704340] = {criteria=49949}, -- Hymn of Humility
    [64504640] = {criteria=49949}, -- Hymn of Humility
    [63004290] = {criteria=49949}, -- Hymn of Humility
    [39205610] = {criteria=49948}, -- Hymn of Courage
    [32505770] = {criteria=49948}, -- Hymn of Courage
    [35405560] = {criteria=49948}, -- Hymn of Courage
    [34105850] = {criteria=49948}, -- Hymn of Courage
    [31905460] = {criteria=49948}, -- Hymn of Courage
    [40305880] = {criteria=49948}, -- Hymn of Courage
    [39402380] = {criteria=49948}, -- Hymn of Courage ?
    [63907350] = {criteria=49947}, -- Hymn of Purity
    [63607370] = {criteria=49947}, -- Hymn of Purity
    [61107610] = {criteria=49947}, -- Hymn of Purity
    [57907910] = {criteria=49947}, -- Hymn of Purity
}, {
    achievement=14768,
    atlas="poi-workorders",
    minimap=true,
})

-- Non-achievement treasures
ns.RegisterPoints(1533, { -- Bastion
    [61041511] = {
        quest=61698, -- this one seems to be daily?
        label="Cloudwalker's Coffer",
        note="Bounce on the flowers",
        loot={
            180783, -- Design: Crown of the Righteous
            {183756, quest=62472, covenant=Enum.CovenantType.Necrolord}, -- Halo of Purity (stitching)
        },
        path=58701630,
    },
    -- [24531794] = {
    --     quest=60663,
    --     label="Gilded Chest",
    -- },
    -- [47692635] = {
    --     quest=60798,
    --     label="Skyward Bell",
    -- },
    -- [46821989] = {
    --     quest=60712,
    --     label="Silver Strongbox",
    --     note="Requires Ripe Purian",
    -- },
})

ns.RegisterPoints(1533, { -- Bastion
    [49854685] = {
        quest=64959,
        loot={
            {187818, quest=64959, covenant=Enum.CovenantType.NightFae}, -- Otter Soul
        },
        note="/hug the {npc:181682:Lost Soul} swimming in the pool. You might have to wait a while for it to spawn, and it'll only stick around for 5 minutes.",
        hide_before=ns.conditions.Covenant(Enum.CovenantType.NightFae),
        atlas="sanctumupgrades-nightfae-32x32",
        minimap=true,
        group="soulshape",
    },
})

-- rares
ns.RegisterPoints(1533, {
    [32602335] = { label="Aspirant Eolis",
        achievement=14307, criteria=50613,
        quest=61083,
        npc=171211,
        loot={
            183607, -- Uncertain Aspirant's Spear
        },
        --level=60,
        note="Loot a {item:180613} nearby and read it while targeting the rare",
    },
    [51324077] = { label="Baedos",
        achievement=14307, criteria=50592,
        quest=58648,--62192,
        npc=160629,
        loot={
            172232, -- Eternal Crystal
        },
        vignette=4047,
    },
    [49005030] = { label="Basilofos, King of the Hill",
        achievement=14307, criteria=50602,
        quest=60897, -- 62158,
        npc=170659,
        loot={
            180704, -- Infused Pet Biscuit
            182653, -- Larion Treats
            -- 182655, -- Hill King's Roarbox
        },
    },
    [55806250] = { label="Bookkeeper Mnemis",
        achievement=14307, criteria=50612,
        quest=59022,
        npc=171189,
        loot={
            182682, -- Book-Borrower Identification
        },
    },
    [51015835] = { label="Cloudfeather Guardian",
        achievement=14307, criteria=50604,
        quest=60978,--62191,
        npc=170932,
        loot={
            {180812, pet=2925}, -- Golden Cloudfeather
        },
        vignette=4322,
    },
    [66004370] = { label="Collector Astorestes",
        achievement=14307, criteria=50610,
        quest=61002,
        npc=171014,
        loot={
            184295, -- Eternal Daybreak Necklace
            -- These are all super-low drop rate and shared with Relic-Hoarder:
            183604, -- Piercing Timbre Crossbow
            183605, -- Devourer Wrought Warglaive
            183606, -- Bulwark of Echoing Courage
            183607, -- Uncertain Aspirant's Spear
            183608, -- Evernote Vesper
            183609, -- Re-Powered Golliath Fists
            183610, -- Warrior Poet's Poniard
            183611, -- Humble Ophelia's Greatblade
            183612, -- Loyal Champion's Hammer
            183613, -- Glinting Daybreak Dagger
            183614, -- Gavel of Harmonious Wisdom
        },
        note="Read the Mercia's Legacy chapters inside in order, then talk to {npc:157979} for {spell:333779}, then find {item:180569} outside, and bring it back to {npc:157979}",
        minimap=true,
    },
    [56904780] = { label="Corrupted Clawguard",
        achievement=14307, criteria=50615,
        quest=60999,
        npc=171010,
        loot={
            {182759, quest=62200}, -- Functioning Anima Core
        },
        note="Bring a {item:180651}, found hidden behind debris nearby, to the {npc:171300}",
        vignette=4340,
    },
    [27803015] = { label="Dark Watcher",
        achievement=14307, criteria=50603,
        quest=60883,
        npc=170623,
        loot={
            184297, -- Death Warden's Greatblade
        },
        --level=60,
        note="You need to talk to this while you're dead to make it visible. The {spell:342893} buff will be present if it's up",
    },
    [37004180] = { label="Demi the Relic Hoarder",
        achievement=14307, criteria=50611,
        quest=61069,--61000,
        npc=171011,
        loot={
            -- These are all super-low drop rate and shared with Collector Astorestes:
            183604, -- Piercing Timbre Crossbow
            183605, -- Devourer Wrought Warglaive
            183606, -- Bulwark of Echoing Courage
            183607, -- Uncertain Aspirant's Spear
            183608, -- Evernote Vesper
            183609, -- Re-Powered Golliath Fists
            183610, -- Warrior Poet's Poniard
            183611, -- Humble Ophelia's Greatblade
            183612, -- Loyal Champion's Hammer
            183613, -- Glinting Daybreak Dagger
            183614, -- Gavel of Harmonious Wisdom
        },
        notes="Runs away, hit it to lower {spell:333874}",
    },
    [41354885] = { label="Dionae",
        achievement=14307, criteria=50595,
        quest=62650,
        npc=163460,
        loot={
            {180856, pet=2932}, -- Silvershell Snapper
        },
        --level=60,
        note="In a cave accessed from the north",
    },
    [45556460] = { label="Echo of Aella",
        achievement=14307, criteria=50614,
        quest=62251, -- progress 61082,61091
        npc=171255,
        loot={
            180062, -- Heavenly Drum
        },
        note="Wandering the road; talk to her",
    },
    [51151955] = { label="Enforcer Aegeon",
        achievement=14307, criteria=50605,
        quest=60998,
        npc=171009,
        loot={
            {184404, toy=true}, -- Ever-Abundant Hearth
        },
        --level=60,
        note="Wandering the forge, may spawn after you kill surrounding enemies",
    },
    [60407305] = { label="Fallen Acolyte Erisne",
        achievement=14307, criteria=50596,
        quest=58222,
        npc=160721,
        loot={
            180444, -- Harmonia's Chosen Belt
        },
        hide_before=ns.conditions.QuestComplete(59147),
        note="Spawns after quests in the area",
    },
    [42908265] = { label="Herculon",
        achievement=14307, criteria=50582,
        quest=57705,--57708,
        npc=158659,
        loot={
            {182759, quest=62200}, -- Functioning Anima Core
        },
        note="Gather anima from barrels nearby",
    },
    [51456860] = { label="Nikara Blackheart",
        achievement=14307, criteria=50594,
        quest=58319,
        npc=160882,
        loot={
            183608, -- Evernote Vesper
        },
        --level=60,
        vignette=4007,
        note="Need three players to trigger a vesper repair event",
    },
    [30355515] = { label="Reekmonger",
        achievement=14307, criteria=50616,
        quest=61108,
        npc=171327,
        --loot={},
        note="Kill enemies in the Temple of Courage to summon",
    },
    [61305090] = { label="Selena the Reborn",
        achievement=14307, criteria=50593,
        quest=58320,
        npc=160985,
        loot={
            174038, -- Chime of Celerity
        },
        --level=60,
        note="Need three players to trigger",
        vignette=4571,
    },
    [22452285] = { label="Orstus and Sotiros",
        achievement=14307, criteria=50618,
        quest=61634,
        npc=156339,
        areaPoi=6894, -- Black Bell
        loot={
            184365, -- Aegis of Salvation
            {184401, pet=3063, covenant=Enum.CovenantType.Kyrian}, -- Larion Pouncer
        },
        note="Requires Kyrian player to summon",
        nearby={22702290, label="Black Bell"},
    },
    [43502525] = { label="Unstable Memory",
        achievement=14307, criteria=50606,
        quest=60997,
        npc=171008,
        loot={
            {184413, toy=true}, -- Mnemonic Attunement Pane
        },
        --level=60,
        note="Drag a {npc:171018} through others, until it gets 10x {spell:333558}"
    },
    [40655305] = { label="Wingflayer the Cruel",
        achievement=14307, criteria=50600,
        quest=60314,-- 62197,
        npc=167078,
        areaPoi=6896, -- Horn of Courage
        loot={
            182749, -- Regurgitated Kyrian Wings
        },
        note="A Kyrian player must click the Horn of Courage",
        nearby={41655455, label="Horn of Courage"},
    },
    [60109350] = { label="Sundancer",
        achievement=14307, criteria=50601,
        quest=60862,
        npc=170548,
        note="Use the statue and a {item:180445:Skystrider Glider}",
        loot={
            {180773, mount=1307}, -- Sundancer
        },
    },
    [55358025] = { label="Beasts of Bastion",
        achievement=14307, criteria={50597, 50598, 50599, 50617},
        quest={
            60570, -- Sigilback (also 63423)
            60571, -- Cloudtail (also 63424)
            60569, -- Nemaeus (also 63421)
            58526, -- Aethon (also 63422)
        },
        label="Beasts of Bastion",
        npc=161527,
        loot={
            179486, -- Sigilback's Smashshell
            179488, -- Cloudtail's Paw
            179485, -- Fang of Nemaeus
            179487, -- Aethon's Horn
            -- {174445, toy=true}, -- Glimmerfly Cocoon
        },
        note="Beasts of Bastion; talk to {npc:161441} to summon",
        vignette=4032,
    },
    [53508870] = { label="The Ascended Council",
        achievement=14307, criteria=50619,
        quest=60977, -- 60933 makes Cache of the Ascended visible
        npc=170899,
        loot={
            {183741, mount=1426}, -- Ascended Skymane
        },
        --level=60,
        note="Ring the five vespers within 5 minutes to summon the council",
        routes={
            {53508870, 64306980, highlightOnly=true, _related=64306980,},
            {53508870, 33305980, highlightOnly=true, _related=33305980,},
            {53508870, 71953895, highlightOnly=true, _related=71953895,},
            {53508870, 39152040, highlightOnly=true, _related=39152040,},
            {53508870, 32151775, highlightOnly=true, _related=32151775,},
        },
        vignette=4320,
    },
    -- Rallying Cry of the Ascended
    -- TODO: are there questids for these? Doing if off the Council would be inaccurate...
    [64306980] = {achievement=14734,criteria=49818,atlas="pathofascension-32x32",route=53508870,}, -- Vesper of Purity
    [33305980] = {achievement=14734,criteria=49815,atlas="pathofascension-32x32",route=53508870,}, -- Vesper of Courage
    [71953895] = {achievement=14734,criteria=49816,atlas="pathofascension-32x32",route=53508870,}, -- Vesper of Humility
    [39152040] = {achievement=14734,criteria=49819,atlas="pathofascension-32x32",route=53508870,}, -- Vesper of Wisdom
    [32151775] = {achievement=14734,criteria=49817,atlas="pathofascension-32x32",route=53508870,}, -- Vesper of Loyalty
})

-- Swelling tear event
local tear = {
    achievement=14307, criteria={50607, 50608, 50609},
    label="Swelling Tear",
    npc=171013,
    quest={
        61001, -- Embodied Hunger
        61046, -- Xixin
        61047, -- Worldfeaster
    },
    loot={
        183605, -- Devourer Wrought Warglaive
        {180869, pet=2940}, -- Devoured Wader
    },
    --level=60,
    note="Possible spawns from the Swelling Tear event",
}
ns.RegisterPoints(1533, {
    [39604500] = tear,
    [48004295] = tear,
    [52203280] = tear,
    [56051460] = tear,
    [59655140] = tear,
    [63503600] = tear,
})
