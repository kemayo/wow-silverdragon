local myname, ns = ...

--[[
mining walls
52344167 herb
41079405 ?

Promised to rescue Wu'De Prepfoot @ 35154722: 70709

Tarjin's Tales @ 1616261
Tale of the Outsider: unlocked 70767, listened 70768
Tale of the Elders: unlocked 70770, listened 70769

Disoriented Watcher (187745) kill-quest 74092
--]]

ns.RegisterPoints(ns.WAKINGSHORES, {
    -- https://www.wowhead.com/beta/achievement=16297/treasures-of-the-waking-shores
    [65804182] = { label="Replica Dragon Goblet",
        criteria=54698,
        quest=70600,
        loot={
            {202019, toy=true}, -- Golden Dragon Goblet
        },
        active={ns.conditions.QuestComplete(70409), ns.conditions.Item(198854), any=true}, -- Archeologist Artifact Notes
        related={
            [76343420] = {quest=70409,loot={{198854,quest=70409}},atlas="poi-workorders",}, -- Archeologist Artifact Notes
        },
        vignette=5367,
    },
    [40454136] = { label="Bubble Drifter",
        criteria=54699,
        quest=70599,
        loot={
            {193852, pet=3269}, -- Azure Frillfish
        },
        active={ns.conditions.QuestComplete(70527), ns.conditions.Item(199061), any=true}, -- A Guide To Rare Fish
        nearby={40924140, label="{spell:199061:Fragrant Plant Scent}"},
        note="Find {item:199061} in other treasures to make this appear, then use the Fragrant Plant nearby",
        vignette=5397,
    },
    [61347079] = { label="Ruby Gem Cluster",
        criteria=54713,
        quest=70598,
        loot={
            200864, -- Glimmering Alexstraszite Cluster
        },
        hide_before=ns.conditions.MajorFaction(ns.FACTION_DRAGONSCALE, 21),
        active={ns.conditions.Item(199062), ns.conditions.QuestComplete(70528), any=true}, -- Ruby Gem Cluster Map
        note="Find {item:198843} in other treasures"
    },
    [46713121] = { label="Yennu's Kite",
        criteria=54701,
        quest=70345,
        loot={
            {202022, toy=true}, -- Yennu's Kite
        },
        note="In the tree",
    },
    [69314658] = { label="Dead Man's Chestplate",
        criteria=54702,
        quest=70346,
        loot={
            202193, -- Dead Man's Tunic
            202192, -- Dead Man's Leathers
            202190, -- Dead Man's Chains
            202191, -- Dead Man's Breastplate
        },
        note="Inside tower; middle floor, requires flying",
        minimap=true,
    },
    [48498516] = { label="Torn Riding Pack",
        criteria=54703,
        quest=70378,
        loot={}, -- just supplies
        note="Top of waterfall",
    },
    [58585301] = { label="Misty Treasure Chest",
        criteria=55403,
        quest=65646,
        loot={
            202194, -- Misty Satchel (34 slot bag)
        },
        note="On a well-hidden ledge just below the top of the waterfall",
        -- (the clue is the nearby scouts and non-interactable handhold-objects)
    },
    [29454699] = { label="Onyx Gem Cluster",
        criteria=55448,
        quest=72020,
        loot={
            200867, -- Glimmering Neltharite Cluster
        },
        hide_before=ns.conditions.MajorFaction(ns.FACTION_DRAGONSCALE, 21),
        active={ns.conditions.Item(200738), ns.conditions.QuestComplete(72021), any=true}, -- Onyx Gem Cluster Map
        note="Buy {item:200738}",
        related={
            [47008280] = {quest=72021,loot={{200738,quest=72021}},atlas="poi-workorders",active=false,}, -- Onyx Gem Cluster Map
        },
    },
}, {
    achievement=16297, -- Treasures
    minimap=true,
})

ns.RegisterPoints(ns.WAKINGSHORES, {
    [43156738] = { label="FullSails Supply Chest",
        quest=65965,
        label="FullSails Supply Chest",
        -- loot={}, -- 20g
        active=ns.conditions.Item(191122), -- Fullsails Supply Chest Key
        note="{item:191122:Fullsails Supply Chest Key} drops from {npc:187971} or {npc:187320} south of Wingrest Embassy",
        vignette=5046,
    },
    [23246049] = { label="Continuing Veritistrasz's story",
        label="{item:198661:Partially Destroyed Diary}",
        achievement=16406,
        criteria=55245,
        quest=70268, -- Memories Revived
        onquest=true,
        loot={198661}, -- Partially Destroyed Diary
        -- hide_before=ns.conditions.QuestComplete(70132), -- Stay a While
        atlas="profession", minimap=true,
        path=27176090,
    },
    [71202540] = { label="Magmashell mount",
        label="{npc:199010:Empowered Snail}",
        loot={{192777, mount=1469}}, -- Magmashell
        note="Bring a {item:201883:Empty Magma Shell} dropped by {npc:186623:Lavaslurper}, and channel it for 16 seconds in the lava",
        related={
            [22607160] = {label="{npc:186623:Lavaslurper}", note="Drops a {item:201883:Empty Magma Shell} that you should take to {npc:199010:Empowered Snail}"},
        },
        atlas="stablemaster", minimap=true,
    },
    [19403630] = {
        loot={{198870, mount=1656}}, -- Otto
        note="First, get the {item:202042:Aquatic Shades} from  {item:202102:Immaculate Sac of Swog Treasures} from {npc:191608:The Great Swog} (Ohn'ahran @ 82,73). It's a lot of fishing, so have fun.\n"..
            "Now, come here to the dive bar (underwater!). Use the {item:202042:Aquatic Shades} and /dance on the pad for 5 minutes. You'll have a {spell:396539:Dance, Dance 'Til You're Dead} buff if you're in the right place. Pick up the {item:202061:Empty Barrel} you find yourself in front of.\n"..
            "Next? More fishing! Fish up 100x {item:202072:Frigid Floe Fish} in Iskaara, 25x {item:202073:Calamitous Carp} in lava around Obsidian Citadel, and 1x {item:202074:Kingfin, the Wise Whiskerfish} by Algethar Academy. Put them all in the barrel, and come back here, where Otto will give you the mount.",
        atlas="stablemaster", color={r=1, g=0, b=1}, minimap=true,
        active=ns.conditions.Toy(202042), -- Aquatic Shades
    },
    [35754758] = { label="Broken Waygate",
        quest=74978, -- repairing the waygate
        label="Broken Waygate",
        atlas="flightmaster_ancientwaygate-taxi_frame_gray", scale=1.4,
        minimap=true,
        loot={{202278, quest=73058}}, -- Renewed Proto-Drake: Antlers
        active=ns.conditions.Item(204278),
        note="Bring a {item:204278:Neltharion's Toolkit} from the vaults in {zone:2107}, and repair the waygate inside the cave",
    },
})
local drink = ns.nodeMaker{
    atlas="EmberCourt-32x32",
    minimap=true,
    requires=ns.conditions.OnQuest(65875), -- A Dragon's Day Off
}
ns.RegisterPoints(ns.WAKINGSHORES, {
    [20163958] = { label="A Dragon's Day Off",
        label="{quest:65875}",
        quest=65875,
        loot={{198622, pet=3342}}, -- Spyragos
        hide_before=ns.conditions.QuestComplete(66057), -- restoring the faith, end of Wrathion's questline in-zone
        note="Wait for {npc:196000:Vazallia} to land, then fetch booze for her",
        atlas="EmberCourt-32x32", minimap=true,
        related={
            -- available before the quest starts:
            [63247992] = drink{label="{item:195543}", inbag=195543}, -- Riptide Brew
            [46923071] = drink{label="{item:198045}", inbag=198045}, -- Slam Bam Swill
            -- only after:
            [35934792] = drink{label="{item:197738}", inbag=197738, note="Complete {npc:185627:Ingot}'s quests first"}, -- Flameslinger Rum
            [39454833] = drink{label="{npc:185627}", quest=65691, note="Complete this questline to unlock {npc:193310:Dealer Vexil}"}, -- Ingot, if you've not completed The Shadow of His Wings
            [39303832] = drink{label="{item:197737}", inbag=197737, note="In shipwreck"}, -- Popfizz Punch
            [25705514] = drink{label="{item:198043}", inbag=198043, note="Buy from {npc:188349:Outfitter Tipech}"}, --Stealthy Elven Port
            [43106730] = drink{label="{item:197739}", inbag=197739, note="Buy from {npc:186752:Firstmate Kaleson}"}, -- Happy Trigger Sour
            [76184290] = drink{label="{item:198044}", inbag=198044, note="Buy {item:198047} from {npc:186454:Kora Fullsails} to throw at {npc:187494:Rampaging Wind}"}, -- Whirlwind Wine
            -- for the previous:
            [43106732] = drink{label="{item:198047}", inbag=198047, note="Buy from {npc:186454:Kora Fullsails} to throw at {npc:187494:Rampaging Wind}"}, -- Kul Tiran Red
        },
    }
})

-- Rares
ns.RegisterPoints(ns.WAKINGSHORES, {
    -- https://www.wowhead.com/beta/achievement=16676/adventurer-of-the-waking-shores
    [52535855] = { label="Gushgut the Beaksinker",
        criteria=56033,
        quest=73879, -- 70718?
        npc=196056,
        loot={
            {197001,quest=69201,}, -- Cliffside Wylderdrake: Finned Cheek
            {197098,quest=69299,}, -- Highland Drake: Finned Back
            200164, -- Iceloop
            200187, -- Rod of Glacial Force
            200245, -- Leviathan Lure
            200552, -- Torrent Caller's Shell
            200563, -- Primal Ritual Shell
        },
        vignette=5380,
    },
    [55994587] = { label="Nulltheria the Void Gazer",
        criteria=56034,
        quest=72103,
        npc=193256,
        loot={
            {196985,quest=69185,}, -- Cliffside Wylderdrake: Horned Jaw
            {196992,quest=69192,}, -- Cliffside Wylderdrake: Heavy Horns
            {197382,quest=69583,}, -- Renewed Proto-Drake: White Horns
            {197403,quest=69604,}, -- Renewed Proto-Drake: Club Tail
            200158, -- Eerie Spectral Ring
            200165, -- Aegis of Scales
            200236, -- Memory of Nulltheria
            200310, -- Stole of the Iron Phantom
        },
        note="Top of the tower",
    },
    [58774034] = { label="Anhydros the Tidetaker",
        criteria=56035,
        quest=nil,
        npc=187945,
        loot={
            {197001,quest=69201,}, -- Cliffside Wylderdrake: Finned Cheek
            {197098,quest=69299,}, -- Highland Drake: Finned Back
            200164, -- Iceloop
            200187, -- Rod of Glacial Force
            200245, -- Leviathan Lure
            200552, -- Torrent Caller's Shell
            200563, -- Primal Ritual Shell
        },
        vignette=5069,
    },
    [39654122] = { label="Skewersnout",
        criteria=56036,
        quest=nil,
        npc=193181,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197022,quest=69222,}, -- Cliffside Wylderdrake: Finned Neck
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            {197589,quest=69793,}, -- Windborne Velocidrake: Large Head Fin
            200132, -- Skewer's Snout
            200174, -- Bonesigil Shoulderguards
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200445, -- Lucky Hunting Charm
            200448, -- Abyssal Ward
            200552, -- Torrent Caller's Shell
            200563, -- Primal Ritual Shell
        },
    },
    [43427361] = { label="Helmet Missingway",
        -- no quest, no loot, it just deaggros and runs away and you get achievement-credit
        criteria=56037,
        quest=nil,
        npc=193263, -- 199645 is the criteria asset
        loot={},
        minimap=true, -- just a neutral mob wandering, no vignette
    },
    [34607110] = { label="Brundin the Dragonbane",
        criteria=56038,
        quest=73890, -- TODO: verify; got this for killing the mammoth when it was all that was left
        npc=192738,
        loot={
            -- this is somewhat consolidated with the entire war party
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            {197135,quest=69336,}, -- Highland Drake: Toothy Mouth
            {197379,quest=69580,}, -- Renewed Proto-Drake: Impaler Horns
            200131, -- Reclaimed Survivalist's Dagger
            200133, -- Volcanic Chakram
            200163, -- Ring of Embers
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200217, -- Blazing Essence
            200232, -- Raptor Talonglaive
            200247, -- Inextinguishable Gavel
            {200249,toy=true,}, -- Mage's Chewed Wand
            200252, -- Molten Flak Cannon
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        routes={{
            52906590, 53006650, 52006670, 51306660, 49606530, 48706530, 48436605, 47706890,
            48007100, 46907360, 45407400, 42607250, 41706940, 40306820, 39306830, 37906960,
            37607070, 36507160, 34607110,
        }},
        note="Patrols with {npc:192737:Qalashi War Mammoth}",
        minimap=true,
        vignette=5386, -- Qalashi War Party
    },
    [45413562] = { label="Thunderous Matriarch",
        criteria=56040,
        quest=69841,
        npc=193148,
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
        vignette=5174,
    },
    [54897110] = { label="Azra's Prized Peony",
        criteria=56041,
        quest=69839,
        npc=193135,
        loot={
            {197121,quest=69322,}, -- Highland Drake: Tan Horns
            {197398,quest=69599,}, -- Renewed Proto-Drake: Snub Snout
            200229, -- Slightly Digested Leggings
            200259, -- Forest Dweller's Shield
        },
        vignette=5172,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [78575019] = { label="Snappy",
        criteria=56042,
        quest=nil,
        npc=193228,
        loot={},
    },
    [82214945] = { label="O'nank Shorescour",
        criteria=56043,
        quest=70983,
        npc=193118,
        loot={
            {197022,quest=69222,}, -- Cliffside Wylderdrake: Finned Neck
            {197149,quest=69350,}, -- Highland Drake: Club Tail
            {197589,quest=69793,}, -- Windborne Velocidrake: Large Head Fin
            {197608,quest=69812,}, -- Windborne Velocidrake: Gray Horns
            200203, -- Repurposed Giant's Thimble
            200435, -- Brackish Breeches
            200448, -- Abyssal Ward
            200552, -- Torrent Caller's Shell
            200684, -- Emerald Tailbone
        },
        vignette=5167,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [69016482] = { label="Smogswog the Firebreather",
        criteria=56044,
        quest=74031, -- 69668
        npc=193120,
        loot={
            {197379,quest=69580,}, -- Renewed Proto-Drake: Impaler Horns
            200133, -- Volcanic Chakram
            200163, -- Ring of Embers
            200193, -- Manafrond Sandals
            200209, -- Firebreather's Cowl
            200217, -- Blazing Essence
            200247, -- Inextinguishable Gavel
            200252, -- Molten Flak Cannon
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5169,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [62705455] = { label="Amethyzar the Glittering",
        criteria=56045,
        quest=69838,
        npc=193132,
        loot={
            {196991,quest=69191,}, -- Cliffside Wylderdrake: Black Horns
            198964, -- Elementious Splinter
            200156, -- Amethyzarite Geode
            200244, -- Enchanted Muckstompers
            200246, -- Lost Delving Lamp
        },
        vignette=5171,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [40206516] = { label="Magmaton",
        -- Obsidian Citadel objective-bonus
        criteria=56046,
        quest=70979,
        npc=186827,
        loot={
            {197135,quest=69336,}, -- Highland Drake: Toothy Mouth
            {197149,quest=69350,}, -- Highland Drake: Club Tail
            {197379,quest=69580,}, -- Renewed Proto-Drake: Impaler Horns
            {197608,quest=69812,}, -- Windborne Velocidrake: Gray Horns
            200133, -- Volcanic Chakram
            200163, -- Ring of Embers
            200203, -- Repurposed Giant's Thimble
            200217, -- Blazing Essence
            200247, -- Inextinguishable Gavel
            200252, -- Molten Flak Cannon
            200563, -- Primal Ritual Shell
            200684, -- Emerald Tailbone
        },
        vignette=5116,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [21947690] = { label="Massive Magmashell",
        criteria=56047,
        quest=69848,
        npc=193152,
        loot={
            {197022,quest=69222,}, -- Cliffside Wylderdrake: Finned Neck
            200192, -- Handheld Geyser
            200247, -- Inextinguishable Gavel
            200252, -- Molten Flak Cannon
            200448, -- Abyssal Ward
            200552, -- Torrent Caller's Shell
            200563, -- Primal Ritual Shell
        },
        vignette=5175,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [33417637] = { label="Forgotten Gryphon",
        criteria=56048,
        quest=72130, -- 73073
        npc=193154,
        loot={
            {196985,quest=69185,}, -- Cliffside Wylderdrake: Horned Jaw
            {197382,quest=69583,}, -- Renewed Proto-Drake: White Horns
            200256, -- Darkmaul Soul Horn
            200858, -- Plume of the Forgotten
        },
        vignette=5383,
    },
    [21606478] = ns.SUPERRARE{ -- Enkine the Voracious
        criteria=56049,
        quest=73072, -- 72128
        npc=193134,
        loot={
            {197135, quest=69336}, -- Highland Drake: Toothy Mouth
            200133, -- Volcanic Chakram
            200167, -- Regurgitated Stone Handaxe
            200247, -- Inextinguishable Gavel
            200252, -- Molten Flak Cannon
            200163, -- Ring of Embers
            200563, -- Primal Ritual Shell
            200217, -- Blazing Essence
        },
        note="Kill nearby mobs for {item:201092:Lava Spices}, then fish here to summon",
        vignette=5382,
    },
    [27017601] = ns.SUPERRARE{ -- Captain Lancer
        criteria=56050,
        quest=72127, -- 73075
        npc=193198,
        loot={
            {197005,quest=69205,}, -- Cliffside Wylderdrake: Horned Nose
            {197019,quest=69219,}, -- Cliffside Wylderdrake: Blunt Spiked Tail
            200169, -- Protector's Molten Cudgel
            200286, -- Dragonbane Lance
            200289, -- Valdrakken Accord Insignia
            200757, -- Qalashi War-Helm
        },
        vignette=5385,
        note="Spawns after Dragonbane Keep event",
    },
    [64456922] = { label="Possessive Hornswog",
        criteria=57852,
        quest=67048, -- 70864 for cave-access
        npc=192362,
        loot={
            {199916, pet=3365}, -- Roseate Hopper
        },
        vignette=5139, -- Hidden Hornswog Hoard
        atlas="VignetteLootElite", scale=1.2,
        note="Bring {item:200064}, {item:200065}, and {item:200066} here to enter",
        related={
            [47738363] = {quest=70864,label="{item:200064}",inbag=200064,atlas="Islands-AzeriteChest",}, -- Marmoni's Prize
            [39648469] = {quest=70864,label="{item:200065}",inbag=200065,atlas="Islands-AzeriteChest",}, -- Adventurer's Lost Soap Bar
            [66185530] = {quest=70864,label="{item:200066}",note="Top of tower",inbag=200066,atlas="Islands-AzeriteChest",}, -- Well-Preserved Bone
        },
    },
    [30025538] = { label="Worldcarver A'tir",
        criteria=56052,
        quest=74090, -- vignete 70763
        npc=186859,
        loot={
            {197135,quest=69336,}, -- Highland Drake: Toothy Mouth
            {197379,quest=69580,}, -- Renewed Proto-Drake: Impaler Horns
            200133, -- Volcanic Chakram
            200163, -- Ring of Embers
            200213, -- Lava-Splattered Breastplate
            200217, -- Blazing Essence
            200252, -- Molten Flak Cannon
            200563, -- Primal Ritual Shell
        },
        nearby={30005520, label="{npc:197395:Wurmling Bones}"},
        note="Gather 3x {item:191211:Wurmling Bones} from {npc:187366:Worldcarver Wurmling} then click on the {npc:197395:Wurmling Bones}",
        vignette=5110,
    },
    [31825440] = { label="Death's Shadow",
        criteria=56053,
        quest=73074, -- 67027 vignette
        npc=190985,
        loot={
            200159, -- Blaze Ring
        },
        note="Give 20x{item:191264:Restored Obsidian Key} to {npc:191640:Sabellian} to trigger {quest:67027}",
        vignette=5113,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [23825742] = { label="Shas'ith",
        criteria=56054,
        quest=74077, -- 66903 vignette
        npc=189822,
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
            200447, -- Centaur Hunting Trophy
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        note="Under the Obsidian Citadel. Give 20x{item:191264:Restored Obsidian Key} to {npc:186681:Wrathion} to trigger {quest:66903}",
        vignette=5108,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [33748639] = { label="Lepidoralia the Resplendent",
        criteria=56055,
        quest=69891,
        npc=193266,
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
        note="In the Fluttering Cavern",
        vignette=5209, -- Resplendent Shimmerwing
        path=35808453,
    },
    [30915494] = ns.SUPERRARE{ -- Cauldronbearer Blakor
        -- also 25825982?
        criteria=56056,
        quest=74042,
        npc=186783,
        loot={
            {197005,quest=69205,}, -- Cliffside Wylderdrake: Horned Nose
            {197019,quest=69219,}, -- Cliffside Wylderdrake: Blunt Spiked Tail
            200169, -- Protector's Molten Cudgel
            200757, -- Qalashi War-Helm
        },
        note="Patrols",
        vignette=5480,
    },
    [25286032] = ns.SUPERRARE{ -- Rohzor Forgesmash
        criteria=56057,
        quest=74052,
        npc=187598,
        loot={
            194503, -- Plans: Black Dragon Touched Hammer
            194508, -- Plans: Alvin the Anvil
            {197005,quest=69205,}, -- Cliffside Wylderdrake: Horned Nose
            {197019,quest=69219,}, -- Cliffside Wylderdrake: Blunt Spiked Tail
            200169, -- Protector's Molten Cudgel
            200757, -- Qalashi War-Helm
        },
        vignette=5513,
    },
    [33635572] = ns.SUPERRARE{ -- Turboris
        criteria=56058,
        quest=74054,
        npc=187886,
        loot={
            {196991,quest=69191,}, -- Cliffside Wylderdrake: Black Horns
            {197624,quest=69828,}, -- Windborne Velocidrake: Club Tail
            200244, -- Enchanted Muckstompers
            200246, -- Lost Delving Lamp
            200563, -- Primal Ritual Shell
            200683, -- Legguards of the Deep Strata
        },
        vignette=5109,
    },
    [28635882] = ns.SUPERRARE{ -- Battlehorn Pyrhus
        criteria=56059,
        quest=74040,
        npc=190986,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197135,quest=69336,}, -- Highland Drake: Toothy Mouth
            {197379,quest=69580,}, -- Renewed Proto-Drake: Impaler Horns
            200131, -- Reclaimed Survivalist's Dagger
            200133, -- Volcanic Chakram
            200163, -- Ring of Embers
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200217, -- Blazing Essence
            200232, -- Raptor Talonglaive
            200247, -- Inextinguishable Gavel
            200252, -- Molten Flak Cannon
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5112, -- and 5114
    },
    [29245162] = ns.SUPERRARE{ -- Char
        criteria=56060,
        quest=74043,
        npc=190991,
        loot={
            {196991,quest=69191,}, -- Cliffside Wylderdrake: Black Horns
            {197383,quest=69584,}, -- Renewed Proto-Drake: Heavy Horns
            {197602,quest=69806,}, -- Windborne Velocidrake: Cluster Horns
            {197624,quest=69828,}, -- Windborne Velocidrake: Club Tail
            {200198,toy=true,}, -- Primalist Prison
            200199, -- Elements' Burden
            200244, -- Enchanted Muckstompers
            200246, -- Lost Delving Lamp
            200292, -- Cragforge Pauldrons
            200293, -- Primal Scion's Twinblade
            200294, -- Primal Chain Hauberk
            200313, -- Earthen Protoscale Drape
            200439, -- Earthpact Scepter
            200563, -- Primal Ritual Shell
            200683, -- Legguards of the Deep Strata
        },
        vignette=5115,
    },
    [30226045] = { label="Rasnar the War Ender",
        criteria=56061,
        quest=74051,
        npc=193232,
        loot={
            {197005,quest=69205,}, -- Cliffside Wylderdrake: Horned Nose
            {197019,quest=69219,}, -- Cliffside Wylderdrake: Blunt Spiked Tail
            200169, -- Protector's Molten Cudgel
            200757, -- Qalashi War-Helm
        },
        vignette=5512,
    },
    [32215221] = { label="Morchok",
        criteria=56988,
        quest=74067, -- 66901
        npc=187306,
        loot={
            {196991,quest=69191,}, -- Cliffside Wylderdrake: Black Horns
            {197624,quest=69828,}, -- Windborne Velocidrake: Club Tail
            200207, -- Petrified Fungal Spores
            200244, -- Enchanted Muckstompers
            200246, -- Lost Delving Lamp
            200683, -- Legguards of the Deep Strata
        },
        note="Give 20x{item:191264:Restored Obsidian Key} to {npc:187275:Igys the Believer} to trigger {quest:66901}",
        vignette=5388, -- 5119 for "Morchock Reformed"?
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [46987332] = { label="Shadeslash Trakken",
        criteria=56989,
        quest=74076, -- 70719
        npc=193271,
        loot={
            {196999,quest=69199,}, -- Cliffside Wylderdrake: Swept Horns
            {197116,quest=69317,}, -- Highland Drake: Ears
            200152, -- Gleaming Blade of Insight
            200297, -- Hastily Cobbled Maul
            200689, -- Rimetalon Band
        },
        note="Use the three Pilfered objects inside the cave to summon",
        path=48457426,
        nearby={47727445, 46857355, }, -- TODO: last one
        vignette=5381,
    },
    [34628978] = { label="Slurpo, the Incredible Snail",
        -- at ~65001620 in Ohn'ahran...
        criteria=57003,
        quest=74079, -- 72126
        npc=193175,
        loot={
            {197001,quest=69201,}, -- Cliffside Wylderdrake: Finned Cheek
            {197098,quest=69299,}, -- Highland Drake: Finned Back
            200164, -- Iceloop
            200189, -- Hydroforged Shell Helm
            200245, -- Leviathan Lure
            200552, -- Torrent Caller's Shell
            200563, -- Primal Ritual Shell
        },
        vignette=5384,
        note="Bring {item:201033:Magical Salt Crystal} from Azure Span @ 11.6 41.0 and {spell:392947:Toss Salt} to spawn; this only works when the pool is full of {npc:198216:Unsalted Water Snail}",
        path=36048985,
        minimap=true,
    },
}, {
    achievement=16676, -- Adventurer
})
ns.RegisterPoints(ns.AZURESPAN, {
    [11614107] = { label="Salt Crystal for Slurpo",
        achievement=16676, -- Adventurer
        criteria=57003,
        quest=74079, -- 72126
        loot={201033}, -- Magical Salt Crystal
        inbag=201033,
        note="In the corner of the cave; take to Waking Shores to spawn {npc:193175}",
        atlas="AzeriteSpawning", minimap=true,
        path=11024139,
    },
})
-- Drakewing
local drakewing = {
    achievement=16676, -- Adventurer
    criteria=56039,
    quest=nil,
    npc=193217,
    note="Flying",
    loot={
        200219, -- Dangerous Drapery
        {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
        {197111,quest=69312,}, -- Highland Drake: Maned Head
        198876, -- Technique: Weathered Explorer's Stave
        200131, -- Reclaimed Survivalist's Dagger
        200174, -- Bonesigil Shoulderguards
        200193, -- Manafrond Sandals
        200195, -- Thunderscale Legguards
        200232, -- Raptor Talonglaive
        {200249,toy=true,}, -- Mage's Chewed Wand
        200563, -- Primal Ritual Shell
    },
    minimap=true,
}
ns.RegisterPoints(ns.WAKINGSHORES, {
    [49806960] = {routes={{49806960, 49807220, 48007680, 47207700, r=1, g=1, b=0}}},
    [52205060] = {routes={{52205060, 53605320, 55205820, r=1, g=1, b=0}}},
    [69205480] = {routes={{69205480, 69405940, 67606020, 63605860, r=1, g=1, b=0}}},
    [72824701] = {},
}, drakewing)

ns.RegisterPoints(ns.WAKINGSHORES, {
    [81213783] = { label="Primal Scythid Queen",
        quest=66074, -- 57559, 62396, 72843
        npc=184853,
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
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5055,
    },
    [64173289] = { label="Dragonhunter Igordan",
        quest=66956, -- 72838
        npc=191611,
        loot={
            {197005,quest=69205,}, -- Cliffside Wylderdrake: Horned Nose
            {197019,quest=69219,}, -- Cliffside Wylderdrake: Blunt Spiked Tail
            200169, -- Protector's Molten Cudgel
            200757, -- Qalashi War-Helm
            -- 198876, -- Technique: Weathered Explorer's Stave (general drop?)
        },
        worldquest=65994,
        vignette=5126,
    },
    [54808220] = { label="Klozicc the Ascended",
        quest=72841, -- also 66960
        npc=187209,
        loot={
            {196991,quest=69191,}, -- Cliffside Wylderdrake: Black Horns
            {197023,quest=69223,}, -- Cliffside Wylderdrake: Maned Neck
            {197383,quest=69584,}, -- Renewed Proto-Drake: Heavy Horns
            {197602,quest=69806,}, -- Windborne Velocidrake: Cluster Horns
            {197624,quest=69828,}, -- Windborne Velocidrake: Club Tail
            {200198,toy=true,}, -- Primalist Prison
            200199, -- Elements' Burden
            200244, -- Enchanted Muckstompers
            200246, -- Lost Delving Lamp
            200253, -- Snowspring Incanter's Knife
            200254, -- Totemic Cinch
            200292, -- Cragforge Pauldrons
            200439, -- Earthpact Scepter
            200563, -- Primal Ritual Shell
            200683, -- Legguards of the Deep Strata
        },
        vignette=5127,
    },
    [77602220] = { label="Ancient Hornswog",
        quest=72835, -- 66076
        npc=187111,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {196992,quest=69192,}, -- Cliffside Wylderdrake: Heavy Horns
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            {197403,quest=69604,}, -- Renewed Proto-Drake: Club Tail
            200131, -- Reclaimed Survivalist's Dagger
            200165, -- Aegis of Scales
            200174, -- Bonesigil Shoulderguards
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200682, -- Hardened Scale Shoulderguards
            200859, -- Seasoned Hunter's Trophy
        },
        note="In cave",
        vignette=5057,
    },
    [46715715] = { label="Monsoo, The Boiling Rage",
        -- This is rare-flagged, but has no quest, no loot, and no criteria-completion...
        quest=nil,
        npc=190718,
        loot={
            198964, -- Elementious Splinter
        },
        vignette=nil,
        note="Kill {npc:190719:Primalist Arlin} to trigger",
    },
    [54512137] = { label="Firava the Rekindler",
        quest=72839, -- also 70648
        npc=195915,
        loot={
            {197135,quest=69336,}, -- Highland Drake: Toothy Mouth
            {197379,quest=69580,}, -- Renewed Proto-Drake: Impaler Horns
            200133, -- Volcanic Chakram
            200163, -- Ring of Embers
            200217, -- Blazing Essence
            200247, -- Inextinguishable Gavel
            200252, -- Molten Flak Cannon
            200563, -- Primal Ritual Shell
        },
        routes={{54512137, 56202250, 56502480, r=1, g=0, b=0}},
        vignette=5372,
    },
    [60598286] = { label="Terillod the Devout",
        quest=72850, -- also 70751
        npc=193171,
        loot={
            {197372,quest=69573,}, -- Renewed Proto-Drake: Purple Hair
            {197383,quest=69584,}, -- Renewed Proto-Drake: Heavy Horns
            {197602,quest=69806,}, -- Windborne Velocidrake: Cluster Horns
            {197606,quest=69810,}, -- Windborne Velocidrake: Swept Horns
            200172, -- Zephyrdance Signet
            {200198,toy=true,}, -- Primalist Prison
            200208, -- Cloud Coalescing Handwraps
            200314, -- Skyspeaker's Envelope
        },
        vignette=5387,
    },
    [28047868] = { label="Beakers",
        quest=73902,
        npc=193177,
        loot={},
    },
    [24205400] = { label="Penumbrus",
        quest=nil,
        npc=189289,
        loot={
            {196991,quest=69191,}, -- Cliffside Wylderdrake: Black Horns
            {197624,quest=69828,}, -- Windborne Velocidrake: Club Tail
            200144, -- Band of the Unscalable
            200244, -- Enchanted Muckstompers
            200246, -- Lost Delving Lamp
            200563, -- Primal Ritual Shell
            200683, -- Legguards of the Deep Strata
        },
        note="Under the Obsidian Citadel",
    },
    [78405000] = { label="Gorjo the Crab Shackler",
        -- [78405000, 78405060, 78604920, 78604980]
        quest=nil,
        npc=193226,
        loot={
            {197022,quest=69222,}, -- Cliffside Wylderdrake: Finned Neck
            {197589,quest=69793,}, -- Windborne Velocidrake: Large Head Fin
            200151, -- Seamist Blade
            200281, -- Gorjo's Riding Crop
            200435, -- Brackish Breeches
            200448, -- Abyssal Ward
        },
    },
    [42203940] = {
        label="Harkyn Grymstone",
        -- [42203940, 42203960]
        quest=74003, -- Also: 74000, 74033, 74037
        npc=186200,
        loot={
            {197131,quest=69332,}, -- Highland Drake: Hairy Cheek
            200171, -- Grymheart Blade
            200175, -- Repurposed Anvil
            200243, -- Titanic Scholar's Finery
            -- Rest of the group:
            200169, -- Protector's Molten Cudgel
            200757, -- Qalashi War-Helm
            {197005,quest=69205,}, -- Cliffside Wylderdrake: Horned Nose
            {197019,quest=69219,}, -- Cliffside Wylderdrake: Blunt Spiked Tail
        },
    },
    [55107740] = { label="Basrikron",
        quest=69930, -- 72056
        worldquest=69930,
        npc=193535,
        loot={
            200736, -- Belt of Living Earth
            200739, -- Stony Cragwalkers
            200740, -- Petrified Bracelets
            200742, -- Hardened Shale Breastplate
            200762, -- Earthspeaker's Brooch
        },
    },
})

-- Symbols of Hope
ns.RegisterPoints(ns.WAKINGSHORES, {
    [73193776] = { label="Wingrest Embassy",
        criteria=55841,
        quest=72096,
        note="Top of tower",
    },
    [73035290] = { label="Skytop Observatory",
        criteria=55842,
        quest=72097,
    },
    [56735799] = { label="Crumbling Life Archway",
        criteria=55843,
        quest=72098,
    },
    [61718083] = { label="Hatchery Observatory",
        criteria=55844,
        quest=72099,
    },
    [43566381] = { label="Obsidian Observatory",
        criteria=55845,
        quest=72100,
    },
    [24058995] = { label="Apex Canopy",
        criteria=55846,
        quest=72101,
    },
    [57134640] = { label="Concord Observatory",
        criteria=55848,
        quest=72103,
    },
    [50295562] = { label="The Overflowing Spring",
        criteria=55847,
        quest=72102,
    },
    [48843995] = { label="Uktulut Backwater",
        criteria=55849,
        quest=72104,
    },
    [57022000] = { label="Life-Binder Conservatory",
        criteria=55850,
        quest=72105,
    },
}, {
    achievement=16584,
    note="Interact with the {npc:198123:Hope Kite}",
    texture=ns.atlas_texture("VenthyrAssaultsQuest-32x32", {r=1, g=0.5, b=1}),
    requires=ns.DRAGONRIDING,
    minimap=true,
})
