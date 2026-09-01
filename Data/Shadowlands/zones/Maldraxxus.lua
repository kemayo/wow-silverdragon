local myname, ns = ...

local growth = {
    loot={
        {181173, pet=2949}, -- Skittering Venomspitter
    },
}
ns.RegisterVignettes(1536, {
    -- Sp(r)outing Growth
    [4202] = growth,
    [4362] = growth,
    [4363] = growth,
    [4366] = { label="Slime-Coated Crate",
        loot={
            {181262, pet=2952}, -- Bubbling Pustule
            {184447, toy=true}, -- Kevin's Party Supplies
        },
    },
})

ns.RegisterPoints(1536, { -- Maldraxxus
    [47206210] = {
        achievement=14312, criteria=50063, -- Ornate Bone Shield
        quest=59358,
        loot={
            180749, -- Hauk's Battle-Scarred Bulwark
        },
        note="On the ground near some bones",
    },
    [32702120] = {
        achievement=14311, criteria=50064, -- Kyrian Keepsake
        quest=60587,
        loot={
            180085, -- Kyrian Keepsake
            175708, -- Reconstructed Family Locket
        },
        note="Interact with the {npc:169664:Kyrian Corpse} at the location to obtain the treasure",
    },
    [30702870] = {
        achievement=14312, criteria=50065, -- Halis' Lunch Pail
        quest=60730,
        -- loot=Random Food,
        note="In the middle of the ring in the House of Constructs",
    },
    [59807900] = {
        achievement=14312, criteria=50066, -- Vat of Conspicuous Slime
        quest=61444,
        loot={
            {181825, toy=true}, -- Phial of Ravenous Slime
        },
        note="Take the bottle from the nearby table and use it on the pool to obtain the treasure",
    },
    [42302430] = {
        achievement=14312, criteria=50068, -- Necro Tome
        quest=61470,
        loot={
            {182732, toy=true}, -- The Necronom-i-nom
        },
        hide_before=ns.conditions.QuestComplete(58620),
        note="Complete the questline starting with {quest:58619:Read Between the Lines}. Once the tower is unlocked, it's on the top floor",
    },
    [40603300] = {
        label="{npc:166657}", -- Ta'eran
        achievement=14312, criteria=50068, -- Necro Tome
        quest=58619,
        atlas="questnormal",
        note="Starts the quest chain leading to {item:182732}",
    },
    [22503050] = {
        achievement=14312, criteria=50069, -- Forgotten Mementos
        quest=58710, -- also 58709
        -- loot=Random Gear,
        --level=60,
        note="Find the Vault Portcullis chain in the next room to open the gate",
    },
    [49401510] = {
        achievement=14312, criteria=50070, -- Chest of Eyes
        quest=59244,
        loot={
            183696, -- Sp-eye-glass
        },
        --level=60,
        note="Inside the wreckage of Nurakkir in the House of Eyes",
    },
    [62405990] = {
        achievement=14312, criteria=50071, -- Misplaced Supplies
        quest=60311,
        -- loot=Random Gear,
        --level=60,
        note="On top of a giant mushroom; climb the small hill to the north, jump to the smaller mushroom, then be surprised by what slopes you can run up",
    },
    [72805360] = {
        achievement=14312, criteria=50072, -- Glutharn's Stash
        quest=61484,
        -- loot=Random Gear,
        --level=60,
        note="Hidden behind the waterfall. Kill {npc:172485:Scathely} and his 2 adds to unlock the treasure",
    },
    [31707000] = {
        achievement=14312, criteria=50073, -- Runespeaker's Trove
        quest=61491,
        loot={
            183516, -- Stained Bonefused Mantle
        },
        --level=60,
        note="Kill {npc:170563:Runespeaker Phaeton} to obtain the {item:181777:Phaeton's Key} required to unlock the treasure",
        path={
            37907000,
            label="{npc:170563}",
            loot={
                181777, -- Phaeton's Key
            },
            inbag=181777,
            atlas="Garr_LevelUpgradeLocked", scale=1.3,
            note="Take the key to 31.7 70.0",
        },
    },
    [57607580] = {
        achievement=14312, criteria=50074, -- Plaguefallen Chest
        quest=61474,
        loot={
            {183515, pet=3045}, -- Iridescent Ooze / Reanimated Plague
        },
        --level=60,
        note="Enter the tunnels at 62.4 76.5 to become {spell:330092:Plaguefallen} and unlock the treasure",
        path={
            62387655,
            label="Tunnel entrance",
            note="Under the platform; stand in the goo to get 10 stacks of {spell:330069} and become become {spell:330092:Plaguefallen}, then go into the cave and you'll be able to get through the pipe",
        },
    },
    [64602470] = {
        achievement=14312, criteria=50075, -- Ritualist's Cache
        quest=61514,
        loot={
            {183517, quest=62372}, -- Page 76 of the Necronom-i-nom
        },
        --level=60,
        note="Loot the {item:181558:Missing Ritual Pages} nearby, then use the Book of Binding Rituals behind the cache before opening it",
    },
})
ns.RegisterPoints(1649, { -- Etheric Vault
    [34565549] = {
        achievement=14312, criteria=50069, -- Forgotten Mementos
        quest=58710, -- also 58709
        -- loot=Random Gear,
        note="Find the Vault Portcullis Chain to open the gate",
    },
    [25605780] = {
        achievement=14312, criteria=50069, -- Forgotten Mementos
        quest=58710,
        label="Vault Portcullis Chain",
        atlas="ammunition",
    },
})

local stolen_jar = {
    achievement=14312, criteria=50067, -- Stolen Jar
    quest=61451,
    loot={
        {182618, quest=62085}, -- Reclaimed Vessel
    },
    note="Can spawn in several different caves. Gives the quest {quest:62085:...Why Me?}",
}
ns.RegisterPoints(1536, {
    [66105040] = stolen_jar,
    [73554985] = stolen_jar,
    [75104390] = stolen_jar,
})

-- Harvester of Sorrow

local sorrow = {
    achievement=14626,
    quest={61127, 61128}, -- arm, sword
    --level=60,
    atlas="animadiversion-icon",
}
ns.RegisterPoints(1536, {
    [51404840] = {
        achievement=14626,-- Harvester of Sorrow
        loot={
            180273, -- Sorrowbane
            {181164, pet=2944}, -- Oonar's Arm
        },
        scale=1.2,
        minimap=true,
        note="Requires stacking several strength buffs and the world quest {quest:57205:A Few Bumps Along the Way}:\n"..
            "* Buy {item:181163} from {npc:169964} in Maldraxxus\n".. -- teleport scroll
            "* Buy {item:180771} from {npc:166640} in Maldraxxus\n".. -- strength potion
            "* Buy {item:182163} from {npc:171808} in Revendreth\n".. -- other strength potion
            "* During {quest:57205} get 2 stacks of {spell:306272}\n"..
            "* Eat 4x {spell:327367} in Glutharn's Decay\n"..
            "* Use {item:181163}, drink the potions, pull the sword\n"..
            "(You can get the arm with just the {spell:327367})",
    },
    [53254125] = {
        -- todo: this npc is also in wardrobe makeover... but I can't double-up on achievements for a point
        label="{npc:169964:One-Eyed Joby}",
        inbag=181163,
        note="Buy {item:181163}", -- Teleport scroll
    },
    [53654785] = {
        label="{npc:166640:Au'larrynar}",
        inbag=180771,
        note="Buy {item:180771:Potion of Unusual Strength}",
    },
    [37104700] = {
        label="{quest:57205:A Few Bumps Along the Way}",
        note="Get 2 stacks of {spell:306272} while this quest is up",
        requires_item={180771, 182163, all=true},
    },
    [76105550] = {
        label="{spell:327367:Edible Redcap}",
        note="Eat 4x",
        requires_item={180771, 182163, all=true},
    },
}, sorrow)
ns.RegisterPoints(1525, {
    [51107885] = {
        -- todo: this npc is also in wardrobe makeover... but I can't double-up on achievements for a point
        label="{npc:171808:Ta'tru}",
        inbag=182163,
        note="Buy {item:182163:Strength of Blood}",
    },
}, sorrow)

-- Wardrobe Makeover

local makeover = {
    achievement=14748,
    atlas="buildanabomination-32x32",
    minimap=true,
    hide_before=ns.conditions.Covenant(Enum.CovenantType.Necrolord),
}
ns.RegisterPoints(1536, { -- Maldraxxus
    [47104900] = {criteria=50546, quest=62758, inbag=184036, note="Buy {item:184036} from {npc:164588}"}, -- Dundae's Hat
    [54203060] = {criteria=50546, quest=62758, inbag=184036, note="Buy {item:184036} from {npc:169698}"}, -- Dundae's Hat
    [40204120] = {criteria={50551,50556,50558}, quest={62817,62824,62825}, inbag=184203, note="Buy three {item:184203} from {npc:168429}... one at a time"}, -- Skull Fungus and Shoulder Sprouts and Back Mushrooms
    [53204120] = {criteria=49870, quest=61562, inbag=181798, note="Buy {item:181798} from {npc:169964}"}, -- Trustworthy Doll
    [60004470] = {criteria=49920, quest=62571, inbag=183831, note="Probably need to glide down from the necropolis"}, -- Safe Fall Pack
    -- No known location, probably Chordy:
    -- [] = {criteria=50541, quest=62762, inbag=184039,}, -- Chef Hat
    -- [] = {criteria=50550, quest=62764, inbag=184040,}, -- Egg Hat
    -- [] = {criteria=49865, quest=62471, inbag=183755,}, -- Flower Crown
    -- [] = {criteria=49866, quest=62472, inbag=183756,}, -- Halo of Purity
    -- [] = {criteria=49926, quest=62583, inbag=184225,}, -- Hitchhiker
    -- [] = {criteria=50554, quest=62759, inbag=184037,}, -- Lovely Candle Display
    -- [] = {criteria=49918, quest=62573, inbag=183829,}, -- Sticky Cat
    -- [] = {criteria=49872, quest=62469, inbag=183752,}, -- Engineering Pack
    -- [] = {criteria=49921, quest=62576, inbag=nil,}, -- Plague Pack (just superior parts)
    -- [] = {criteria=49875, quest=62468, inbag=nil,}, -- Vesitgial Wings (just cooking mats)
    -- [] = {criteria=49925, quest=62580, inbag=nil,}, -- Barrel O' Fish
    -- [] = {criteria=50559, quest=62823, inbag=nil,}, -- Underpowered Gravity Pack
    -- [] = {criteria=49917, quest=62582, inbag=183824,}, -- Spare Weapon
    -- Known but not work waypointing:
    -- [] = {criteria=50560, quest=62760, inbag=184038,}, -- Trained Corpselice (on Smorgas)
    -- [] = {criteria=49867, quest=61712, inbag=nil,}, -- Holiday Hat (vendor crafting mats)
    -- [44103990] = {criteria=49922, quest=62575, inbag=183827,}, -- Armor Plating (Blackhound Cache)
    -- [] = {criteria=49874, quest=62481, inbag=183789, note="Search with {npc:158259} anywhere"}, -- Six-League Pack
    -- [] = {criteria=50549, quest=62826, inbag=184204, note="Search with {npc:158259} anywhere"}, -- Pirate Hat
    -- [] = {criteria=50553, quest=62819, inbag=184205, note="Search with {npc:158259} anywhere"}, -- Unworthy Crown
    -- [55006860] = {criteria=49924, quest=62572, inbag=183830, note="Reward from {quest:60195}"}, -- Faction Flag
    -- [] = {criteria=49876, quest=62470, inbag=183754,}, -- Operational Instructions (on Gieger)
    -- [] = {criteria=50558, quest=62824, inbag=184224,}, -- Back Mushrooms (on Deadly Dapperling)
    -- [] = {criteria=49873, quest=61561, inbag=181797,}, -- Outlaw Flag (rare loot)
    -- [] = {criteria=49919, quest=62570, inbag=183833,}, -- Collector Kash's Pack (rare loot)
}, makeover)
ns.RegisterPoints(1533, { -- Bastion
    [33403640] = {criteria=49871, quest=62479, inbag=183786, note="Buy {item:183786} from {npc:158625}"}, -- Happiness Bird
}, makeover)
-- ns.RegisterPoints(1565, { -- Ardenweald
--     [] = {criteria=49923, quest=62574, inbag=183828,}, -- Butterflies (on slumbering emperor)
-- }, makeover)
ns.RegisterPoints(1525, { -- Revendreth
    [51007880] = {criteria=49864, quest=61560, inbag=181799, note="Buy {item:181799} from {npc:171808}"}, -- Dapper Top Hat
    [42505030] = {criteria=49916, quest=62577, inbag=183826, note="{item:183826} is found in Secret Treasures"}, -- Magician's Hat
    -- [] = {criteria=49868, quest=62476, inbag=183760,}, -- Red Eye Lens (on Innervus)
    -- [] = {criteria=49869, quest=62474, inbag=183759,}, -- Skull Protector (on Endlurker)
}, makeover)
ns.RegisterPoints(1536, { -- Maldraxxus
    [69704110] = {
        label="{npc:162151:Neena}",
        quest={62929, 57604, any=true}, -- 57604 is neena-has-been-made
        atlas="buildanabomination-32x32",
        hide_before=ns.conditions.Covenant(Enum.CovenantType.Necrolord),
        note="Requires Abomination Factory level 2. Release her with the key from {npc:175510} next to the cage, talk to her and do {quest:59615}.",
        minimap=true,
    },
})

-- non-achievement treasures
ns.RegisterPoints(1536, { -- Maldraxxus
    [44103990] = {
        quest=60368,
        label="Blackhound Cache",
        loot={
            183619, -- Everlasting Boneforged Greataxe
            {183827, quest=62575, covenant=Enum.CovenantType.Necrolord}, -- Blacksteel Backplate (stitching)
            {183824, quest=62582, covenant=Enum.CovenantType.Necrolord}, -- Cache of Spare Weapons (stitching)
            {184318, toy=true}, -- Battlecry of Krexus
            181800, -- Standard of the Blackhound Warband
        },
        hide_before=ns.conditions.Covenant(Enum.CovenantType.Necrolord),
    },
    -- [36807860] = {
    --     quest=nil,
    --     label="Bladesworn Supply Cache",
    -- },
    [41511953] = {
        quest=62602,
        label="Giant Cache of Epic Treasure",
        pet=3047,
        -- todo: this adds a pet directly to your collection, so before this can be uncommented I need to make loot cope with that
        -- loot={
        --    {pet=3047},
        --}
        note="Click the treasure pile, {spell:343163}",
        minimap=true,
    },
    [54952610] = {
        quest=60109,
        label="Web Sealed Chest", -- vignette's "Web Covered Chest" though
        requires_worldquest=58207,
        note="During world quest {quest:58207} use Twigin to jump up here",
    },
    [55893897] = {
        quest=59428, -- later 59429
        label="Strange Growth",
        loot={
            {182606, pet=3013}, -- Bloodlouse Larva
        },
        note="Loot a {item:182607:Hairy Egg} and wait three days for your pet to hatch",
    },
    [54001235] = {
        quest=nil, -- ?
        label="Cache of Eyes",
        loot={
            {181171, pet=2947}, -- Luminous Webspinner
        },
        note="Spawns in multiple places inside Sightless Hold",
    },
    -- the world map ones:
    -- [36208145] = {
    --     quest=60662,
    --     label="Bonebound Chest",
    --     loot={181723}, -- Meticulously pickled head (high sell value)
    --     junk=true,
    --     --level=60,
    -- },
    -- [38036548] = {
    --     quest=61647, -- 61648, 61649, 61650
    --     label="Chosen Runecoffer",
    --     junk=true,
    --     --level=60,
    --     hide_before=ns.conditions.Covenant(Enum.CovenantType.Necrolord),
    --     note="Channel anima to the Chosen. Three runes nearby on the ground",
    -- },
    -- [32223710] = {
    -- [28723397] = {
    --     quest=61115, -- progress runes: 61120, 61121, 61122
    --     label="Runebound Coffer",
    --     junk=true,
    --     --level=60,
    --     note="Three runes nearby on construct tables",
    -- },
    -- [36208145] = {
    -- [64953323] = {
    --     quest=61116, -- progress runes 61117, 61118, 61119
    --     label="Runebound Coffer",
    --     junk=true,
    --     --level=60,
    --     note="Three runes nearby on the ground",
    -- },
    -- various locations, same questid:
    -- [39974393] = {
    -- [40805470] = {
    -- [34755495] = {
    -- [36494974] = {
    --     quest=60556,
    --     label="Sprouting Growth",
    --     note="Grapple up, jump down",
    --     junk=true,
    --     --level=60,
    -- },
    -- [41623849] = {
    --     quest=61080,
    --     label="Sprouting Growth",
    --     note="Grapple up, jump down",
    --     junk=true,
    --     --level=60,
    -- },
    -- [41593842] = {
    -- [40902569] = {
    --     quest=61089,
    --     label="Sprouting Growth",
    --     note="Grapple up, jump down",
    --     junk=true,
    --     --level=60,
    -- },
    -- [65244965] = {
    --     quest=61090,
    --     label="Sprouting Growth",
    -- },
    -- [76054945] = {
    -- [70965072] = {
    --     quest=61090,
    --     label="Sprouting Growth",
    --     note="Grapple up, jump down",
    --     junk=true,
    --     --level=60,
    -- },
    -- [51401916] = {
    -- [54261491] = {
    --     quest=61111,
    --     label="Bloated Lootfly",
    -- },
    -- [70377628] = {
    --     quest=61093,
    --     label="Slime-Coated Crate",
    -- },
})

ns.RegisterPoints(1536, {
    [44626554] = {
        quest=64995,
        loot={
            {187878, quest=64995, covenant=Enum.CovenantType.NightFae}, -- Saurid Soul
        },
        note="/bow to the {npc:182105:Mysterious Trashpile}",
        hide_before=ns.conditions.Covenant(Enum.CovenantType.NightFae),
        atlas="sanctumupgrades-nightfae-32x32",
        minimap=true,
        group="soulshape",
    },
})

-- Rares

ns.RegisterPoints(1536, {
    [52653540] = { label="Bubbleblood",
        achievement=14308, criteria=48876,
        quest=58870,
        npc=162727,
        loot={
            184154, -- Grungy Containment Pack
            184290, -- Blood-Dyed Bonesaw
            {184476, toy=true}, -- Regenerating Slime Vial (toy)
        },
        --level=60,
    },
    [49002350] = { label="Collector Kash",
        achievement=14308, criteria=48866,
        quest=58005,
        npc=159105,
        loot={
            184181, -- Kash's Favored Hook
            184182, -- Strengthened Abomination Hook
            184188, -- Collector's Corpse Gambrel
            184189, -- Stained Fleshgorer
            {183833, quest=62570, covenant=Enum.CovenantType.Necrolord}, -- Kash's Bag of Junk (Necro only?)
            {181797, quest=61561, covenant=Enum.CovenantType.Necrolord}, -- Strange Cloth (Necro only?)
            {183692, quest=62408, covenant=Enum.CovenantType.Necrolord}, -- Jagged Bonesaw (Crypt Couture)
        },
        --level=60,
    },
    [26402635] = { label="Corpsecutter Moroc",
        achievement=14308, criteria=48872,
        quest=58335,
        npc=157058,
        loot={
            184176, -- Moroc's Boneslicing Warglaive
            184177, -- Grotesque Goring Pick
            {183833, quest=62570, covenant=Enum.CovenantType.Necrolord}, -- Kash's Bag of Junk (Necro only?)
            {181797, quest=61561, covenant=Enum.CovenantType.Necrolord}, -- Strange Cloth (Necro only?)
        },
        --level=60,
    },
    [76855705] = { label="Deadly Dapperling",
        achievement=14308, criteria=48851,
        quest=58868, -- 61989
        npc=162711,
        loot={
            {181263, pet=2953}, -- Shy Melvin
            184280, -- Dapper Threads
            {184224, quest=62824, covenant=Enum.CovenantType.Necrolord}, -- Dapperling Seeds (Necro only?)
        },
    },
    [45052840] = { label="Devour'us",
        achievement=14308, criteria=48855,
        quest=58835,
        npc=162669,
        loot={
            184178, -- Worldrending Claymore
        },
        --level=60,
    },
    [57805155] = { label="Gristlebeak",
        achievement=14308, criteria=48853,
        quest=58837,
        npc=162588,
        loot={
            182196, -- Arbalest of the Colossal Predator
        },
        note="Destroy {npc:162761} to summon",
    },
    [38804335] = { label="Indomitable Schmitd",
        achievement=14308, criteria=48848,
        quest=58332,
        npc=161105,
        loot={
            182192, -- Knee-Obstructing Legguards
            {174070,quest=58411,covenant=Enum.CovenantType.Necrolord,}, -- Indomitable Hide (58379 is for a quest from it)
        },
        note="Use {spell:313451} to break shield",
    },
    [72852890] = { label="Necromantic Anomaly",
        achievement=14308, criteria=49724,
        quest=62369,
        npc=174108,
        loot={
            184174, -- Clasp of Death
            {181810,covenant=Enum.CovenantType.Necrolord,}, -- Phylactery of the Dead Conniver (Necro campaign story gated?)
        },
        --level=60,
    },
    [66003530] = { label="Nerissa Heartless",
        achievement=14308, criteria=49723,
        quest=58851,
        npc=162690,
        loot={
            {182084, mount=1373}, -- Gorespine
            184179, -- Lichsworn Commander's Boneblade
            {174076,quest=58376,covenant=Enum.CovenantType.Necrolord,}, -- Necromantic Oil
        },
        --level=60,
    },
    [50356330] = { label="Nirvaska the Summoner",
        achievement=14308, criteria=48868,
        quest=58629, -- incorrect?
        npc=161857,
        loot={
            183700, -- Forgotten Summoner's Shoulderpads
            {181811,covenant=Enum.CovenantType.Necrolord}, -- Beckoner's Shadowy Crystal
        },
        --level=60,
        note="Only when the {quest:58490} world quest is up",
    },
    [53706130] = { label="Pesticide",
        achievement=14308, criteria=48849,
        quest=58875,
        npc=162767,
        loot={
            182205, -- Scarab-Shell Faceguard
        },
    },
    [53851875] = { label="Ravenomous",
        achievement=14308, criteria=48865,
        quest=58004,
        npc=159753,
        loot={
            {181283, pet=2964}, -- Foulwing Buzzer
            184184, -- Ravenomous's Acid-Tipped Stinger
        },
        note="Kill {npc:159901} nearby to spawn",
        --level=60,
    },
    [51754440] = { label="Sabriel the Bonecleaver",
        achievement=14802, criteria=48874,
        quest=58784,
        npc=168147,
        areaPoi=6905, -- Spoiling For A Fight
        loot={
            184291, -- Tempered Boneplate Waistguard
            {181815, mount=1370, covenant=Enum.CovenantType.Necrolord}, -- Armored Bonehoof Tauralus
            -- {182083, mount=nil}, -- Bonecleaver's Skullboar (removed?)
        },
        --level=60,
        note="A Necrolord player channeling The Theater of Pain must activate this",
    },
    [62107580] = { label="Scunner",
        achievement=14308, criteria=48857,
        quest=58006,
        npc=158406,
        loot={
            {181267, pet=2957}, -- Writhing Spine
            184287, -- Scum-Caked Epaulettes
            {183833, quest=62570, covenant=Enum.CovenantType.Necrolord}, -- Kash's Bag of Junk (Necro only?)
            {181797, quest=61561, covenant=Enum.CovenantType.Necrolord}, -- Strange Cloth (Necro only?)
        },
        --level=60,
    },
    [55502361] = { label="Sister Chelicerae",
        achievement=14308, criteria=48873,
        quest=58003,
        npc=159886,
        loot={
            {181172, pet=2948}, -- Boneweave Hatchling
            184289, -- Spindlefang Spellblade
        },
        --level=60,
    },
    [42465345] = { label="Smorgas the Feaster",
        achievement=14308, criteria=48869,
        quest=58768,
        npc=162528,
        loot={
            {181266, pet=2956}, -- Feasting Larva
            {181265, pet=2955}, -- Corpselouse Larva
            184299, -- Goresoaked Carapace
            {184038, quest=62760, covenant=Enum.CovenantType.Necrolord,}, -- Trained Corpselice
        },
        minimap=true, -- no vignette until lump used
        note="Use the Bloody Lump",
    },
    [44205130] = { label="Tahonta",
        achievement=14308, criteria=48850,
        quest=58783,
        npc=162586,
        loot={
            182190, -- Tauralus Hide Collar
            {182075, mount=1366, covenant=Enum.CovenantType.Necrolord}, -- Bonehoof Tauralus
        },
        note="You need to have {npc:162151:Neena} with you for the mount. Go to 69.7, 41.1 to find her."
    },
    [50552010] = { label="Taskmaster Xox",
        achievement=14308, criteria=48867,
        quest=58091,
        npc=160059,
        loot={
            184186, -- Flesh-Fishing Hook
            184192, -- Pristine Alabaster Gorer
            184187, -- Taskmaster's Tenderizer
            184193, -- Callus-Forged Hook
        },
        --level=60,
        note="Shares spawn with {npc:160226} and {npc:160204}",
    },
    [24204295] = { label="Thread Mistress Leeda",
        achievement=14308, criteria=48870,
        quest=58678,
        npc=162180,
        loot={
            184180, -- Leeda's Unrefined Mask
        },
        --level=60,
    },
    [33708015] = { label="Warbringer Mal'Korak",
        achievement=14308, criteria=48875,
        quest=58889,
        npc=162819,
        loot={
            {182085, mount=1372}, -- Blisterback Bloodtusk
            184288, -- Ruthless Warlord's Barrier
        },
        --level=60,
        note="At the bottom of the tower",
    },
    [28965138] = { label="Zargox the Reborn",
        achievement=14308, criteria=48864,
        quest=59290,
        npc=157125,
        loot={
            184285, -- Boneclutched Shackles
            {181804, covenant=Enum.CovenantType.Necrolord}, -- Trophy of the Reborn Bonelord
            {183690, quest=62404, covenant=Enum.CovenantType.Necrolord}, -- Ashen Ink (Crypt Couture)
        },
        --level=60,
        note="Do {quest:57245} at 26.3 42.8, then use the {item:175827} to summon",
    },

    -- non-achievement:
    [31603540] = { label="Gieger",
        quest=58872,
        npc=162741,
        areaPoi=6901, -- Final Thread
        loot={
            {182080, mount=1411, covenant=Enum.CovenantType.Necrolord}, -- Predatory Plagueroc
            184298, -- Amalgamated Forsworn's Journal
            {183754, quest=62470, covenant=Enum.CovenantType.Necrolord}, -- Operational Instructions
        },
        --level=60,
        -- covenant=Enum.CovenantType.Necrolord,
        note="A Necrolord player channeling House of Constructs must drag {npc:162815} to the rare's right foot",
    },
})

local deepscar = { -- Deepscar
    achievement=14308, criteria=48852,
    quest=58878,
    npc=162797,
    loot={
        182191, -- Slobber-Soaked Chew Toy
    },
}
ns.RegisterPoints(1536, {
    [46754550] = deepscar,
    [48105190] = deepscar,
    [53954550] = deepscar,
})

-- Pool of Mixed Monstrosities:
local BLUE = "|T136007:0|t" -- goo
local RED = "|T136124:0|t" -- oil
local YELLOW = "|T646670:0|t" -- ooze
ns.RegisterPoints(1536, {
    [58207420] = {
        achievement=14721, criteria={
            48858, -- Gelloh
            48863, -- Corrupted Sediment
            48854, -- Pulsing Leech
            48860, -- Boneslurp
            48862, -- Burnblister
            48861, -- Violet Mistake
            48859, -- Oily Invertebrate
        },
        quest={
            61721, -- Gelloh
            61719, -- Corrupted Sediment
            61718, -- Pulsing Leech (62805?)
            61722, -- Boneslurp
            61723, -- Burnblister
            61720, -- Violet Mistake
            61724, -- Oily Invertebrate
        },
        label="{npc:157226}", -- the pool
        icon=true,
        loot = {
            {183903, toy=true}, -- Smelly Jelly
            {182079, mount=1410}, -- Slime-Covered Reins of the Hulking Deathroc (violet)
            {181270, pet=2960}, -- Decaying Oozewalker (oily)
            182287, -- Eternally Preserved Scarab (gelloh)
            184302, -- Residue-coated Muck Waders (corrupted)
            184185, -- Grunge-Caked Collarbone
            184279, -- Siphoning Blood-Drinker (pulsing)
            -- 182198, -- Undulating Blood Burrower (pulsing)
            -- 182200, -- Engorged Blood Burrower (pulsing)
            {181270,pet=2960,}, -- Invertebrate Oil (oily)
            184300, -- Fused Spineguard (oily)
            184175, -- Bone-Blistering Wand (burnblister)
            {184155, quest=62804}, -- Recovered Containment Pack (oily)
            184301, -- Twenty-Loop Violet Girdle (violet)
        },
        ----level=60, -- it's not totally --level=60, but at least some of the spawns are (e.g. Violet)
        note="Mix: 30 ({spell:306722} + {spell:306719} + {spell:306713})\n"..
            "{npc:157294}: 15+ "..RED.."\n".. -- Pulsing Leech
            "{npc:157307}: 15+ "..YELLOW.."\n".. -- Gelloh
            "{npc:157308}: 15+ "..BLUE.."\n".. -- Corrupted Sediment
            "{npc:157310}: "..'('..YELLOW..' = '..BLUE..') > '..RED.."\n".. -- Boneslurp
            "{npc:157311}: "..'('..YELLOW..' = '..RED..') > '..BLUE.."\n".. -- Burnblister
            "{npc:157309}: "..'('..BLUE..' = '..RED..') > '..YELLOW.."\n".. -- Violet Mistake
            "{npc:157312}: "..YELLOW..' = '..BLUE..' = '..RED -- Oily Invertebrate
    }
})

-- Bloodsport, Theater of Pain
ns.RegisterPoints(1536, {
    [50354730] = {
        achievement=14802, criteria={
            50397, -- Azmogal
            50398, -- Unbreakable Urtz
            50399, -- Xantuth the Blighted
            50400, -- Mistress Dyrax
            50402, -- Devmorta
            50403, -- Ti'or
            48874  -- Sabriel the Bonecleaver
        },
        atlas="VignetteKillElite", scale=1.3,
        -- quest=62786, -- this is the mount roll, from the first kill of the day
        -- npc=162853,
        loot={
            {184062, mount=1437}, -- Gnawed Reins of the Battle-Bound Warhound
        },
        note=function()
            local attempted = C_QuestLog.IsQuestFlaggedCompleted(62786)
            return "Some of these require accepting the three {quest:59826} quests\n" ..
                "You " .. (attempted and GREEN_FONT_COLOR or RED_FONT_COLOR):WrapTextInColorCode(attempted and "have" or "have not") .. " attempted to get the mount today"
        end,
    },
})

-- Nine Afterlives (Jellycats)
local jellycat = ns.nodeMaker{
    achievement=14634,
    note="Pet all nine cats to get {item:184449}",
    icon=true,
    minimap=true,
    loot={
        {184449, toy=true}, -- Jiggles's Favorite Toy
    }
}
ns.RegisterPoints(1536, {
    [32025705] = jellycat{criteria=49426,}, -- Snots
    [50246021] = jellycat{criteria=49427,}, -- Pus-In-Boots
    [65215060] = jellycat{criteria=49428,}, -- Envy
    [64852241] = jellycat{criteria=49429,}, -- Mr. Jigglesworth
    [51082759] = jellycat{criteria=49430,note="Up on the bone arch"}, -- Lime
    [49491763] = jellycat{criteria=49431,note="Up on the wall"}, -- Mayhem
    [47553376] = jellycat{criteria=49432,note="Climb the mushroom. You can stand on the mushroom-veins for the last jump."}, -- Moldstopheles
    [34345315] = jellycat{criteria=49433,}, -- Meowmalade
})
ns.RegisterPoints(1697, { -- Plaguefall
    [45253680] = jellycat{criteria=49425,},
})

ns.RegisterPoints(1698, { -- Seat of the Primus
    [40482447] = {
        label="{spell:439568:Runeforge}",
        requires={ns.conditions.Class("DEATHKNIGHT"), ns.conditions.Covenant(Enum.CovenantType.Necrolord)},
        atlas="ClassOverlay-Rune", scale=1.2,
        minimap=true,
    },
})
