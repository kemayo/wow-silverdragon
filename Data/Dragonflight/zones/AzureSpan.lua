local myname, ns = ...

-- heart of the deck (66846), in case it becomes relevant later...
-- 66992 dragon
-- 66983 life-giver
-- 66995 adaptive

ns.RegisterPoints(ns.AZURESPAN, {
    [66911275] = {
        hide_before=ns.conditions.QuestComplete(72547), -- Academic Acquisitions
        texture=ns.atlas_texture("profession", {scale=1.2}),
        label="{faction:2526:Winterpelt Furbolg}",
    },
})

ns.RegisterPoints(ns.AZURESPAN, {
    -- https://www.wowhead.com/beta/achievement=16300/treasures-of-the-azure-span
    [45135939] = { label="Forgotten Jewel Box",
        criteria=54804,
        quest=70603,
        loot={{201927, toy=true}},
        active={ns.conditions.QuestComplete(70534), ns.conditions.Item(199065), any=true}, -- Sorrowful Letter
        note="Find {item:199065} in other treasures",
        vignette=5373,
    },
    [53964377] = { label="Gnoll Fiend Flail",
        criteria=54805,
        quest=70604,
        loot={
            202692, -- Gnoll Fiend Flail
        },
        active={ns.conditions.QuestComplete(70535), ns.conditions.Item(199066), any=true}, -- Letter of Caution
        note="Find {item:199066} in other treasures",
    },
    [48632466] = { label="Sapphire Gem Cluster",
        criteria=54806,
        quest=70605,
        loot={
            200866, -- Glimmering Malygite Cluster
        },
        hide_before=ns.conditions.MajorFaction(ns.FACTION_DRAGONSCALE, 21),
        active={ns.conditions.QuestComplete(70536), ns.conditions.Item(199067), any=true}, -- Precious Plans
        note="Find {item:199067} in other treasures",
    },
    [74905499] = { label="Lost Compass",
        criteria=54807,
        quest=70606,
        loot={
            {202711, toy=true}, -- Lost Compass
        },
    },
    [54642933] = { label="Rubber Fish",
        criteria=54808,
        quest=70380,
        loot={
            202712, -- Rubber Fish
        },
    },
    [26544629] = { label="Pepper Hammer",
        criteria=54809,
        quest=70441,
        loot={
            {193834, pet=3321}, -- Blackfeather Nester
        },
        note="Climb the tree, then use the Tree Sap on the stick to summon {npc:195373}",
    },
}, {
    achievement=16300, -- Treasures
    -- hide_before=ns.conditions.Level(63),
    minimap=true,
})

ns.RegisterPoints(ns.AZURESPAN, {
    [45635482] = { label="for The Great Shellkhan in Thaldraszus",
        achievement=16679, criteria=56155,
        quest=72121,
        loot={200949}, -- Case of Fresh Gleamfish
        note="Quickly take this to {npc:191305} in Thaldraszus @ 38.4, 68.2",
        routes={{45635482, 52550000, highlightOnly=true}},
        minimap=true,
    },
    [18802540] = { label="Temperamental Skyclaw",
        -- Position is deliberately off because he overlaps with the flight point otherwise...
        -- https://www.wowhead.com/news/how-to-obtain-the-temperament-skyclaw-secret-mount-in-dragonflight-330267
        label="{item:201454:Temperamental Skyclaw}",
        npc=190892, -- Zon'Wogi
        loot={
            {201454, mount=1674}, -- Temperamental Skyclaw
        },
        active={
            ns.conditions.Item(201420, 20), -- Gnolan's House Special
            ns.conditions.Item(201421, 20), -- Tuskarr Jerky
            ns.conditions.Item(201422, 20), -- Flash Frozen Meat
        },
        note="Bring stacks of foods that drop from gnolls elsewhere",
        related={
            [23074372] = {label="{item:201420}", loot={201420}, note="Kill gnolls in the Inn", active=false,}, -- Gnolan's House Special
            [34824533] = {label="{item:201421}", loot={201421}, note="Kill Darktooth gnolls", active=false,}, -- Tuskarr Jerky
            [57704280] = {label="{item:201422}", loot={201422}, note="Kill gnolls; you may need to have done {quest:66730} or {quest:66270} before this will drop", active=false,}, -- Flash Frozen Meat
        },
        texture=ns.atlas_texture("stablemaster", {r=0, g=0.8, b=1, scale=1.2}),
        minimap=true,
    },
    [66403330] = {
        quest=71002, -- Best Spell Ever
        loot={200205}, -- Tome of Polymorph: Duck
        path={66433179, note="Blink through the blocked cave entrance with a duck above it"},
        requires=ns.conditions.Class("MAGE"),
    },
    [67601860] = { label="Primal Bear Cub",
        quest=nil,
        label="{npc:196768:Primal Bear Cub}",
        loot={{201838, pet=3359}}, -- Snowclaw Cub
        -- A Dryadic Remedy: 67606 + 69935
        hide_before={ns.conditions.QuestComplete(69935)},
        active={ns.conditions.Item(197744, 3), ns.conditions.Item(198356)}, -- Hornswog Hunk + Honey Snack
        note="Complete {quest:67606}, buy the {item:198356} from {npc:193310:Dealer Vexil} in Waking Shores; you must have the Honorary Dryad title active",
    }
})

-- Rares
ns.RegisterPoints(ns.AZURESPAN, {
    -- https://www.wowhead.com/beta/achievement=16678/adventurer-of-the-azure-span
    [59405520] = { label="Wilrive",
        criteria=56097,
        quest=73900, -- 69948 didn't actually trigger
        npc=193632,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            200212, -- Sand-Encrusted Greaves
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5224,
    },
    [27804580] = { label="Dragonhunter Gorund",
        criteria=56098,
        quest=73873,
        npc=193157,
        loot={
            {197005, quest=69205}, -- Cliffside Wylderdrake: Horned Nose
            {197019, quest=69219}, -- Cliffside Wylderdrake: Blunt Spiked Tail
            200169, -- Protector's Molten Cudgel
            200302, -- Magmaforged Scimitar
            200757, -- Qalashi War-Helm
        },
    },
    [53003560] = { label="Arcane Devourer",
        criteria=56099,
        quest=nil,
        npc=194270,
        loot={},
        vignette=5267,
    },
    [40404840] = { label="Mange the Outcast",
        criteria=56100,
        quest=nil,
        npc=198004,
        loot={
            {196982,quest=69182,}, -- Cliffside Wylderdrake: Ears
            {197150,quest=69351,}, -- Highland Drake: Spiked Club Tail
            200266, -- Gnollish Chewtoy Launcher
            200283, -- Gnoll-Gnawed Breeches
        },
    },
    [58204380] = { label="Frostpaw",
        criteria=56101,
        quest=73877, -- 67148?
        npc=191356,
        loot={},
        vignette=5153,
        note="Use the hammer nearby to smash the toys",
        nearby={58664340, label="Wooden Hammer"},
    },
    [57685441] = { label="Mucka the Raker",
        -- ...very prone to resetting+evading and healing to full
        criteria=56102,
        quest=73885,
        npc=193201,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
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
        note="You may need to kill a stuck {npc:193219:Muckling} nearby to stop this from evading",
    },
    [08804860] = { label="Brackle",
        criteria=56103,
        quest=70165,
        npc=194392,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197022,quest=69222,}, -- Cliffside Wylderdrake: Finned Neck
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            {197589,quest=69793,}, -- Windborne Velocidrake: Large Head Fin
            198974, -- Elegantly Engraved Embellishment
            200131, -- Reclaimed Survivalist's Dagger
            200151, -- Seamist Blade
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            200435, -- Brackish Breeches
            200445, -- Lucky Hunting Charm
            200448, -- Abyssal Ward
            200552, -- Torrent Caller's Shell
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5269,
    },
    [64792998] = { label="Frigidpelt Den Mother",
        criteria=56104,
        quest=73876, -- vignette 69985
        npc=193698,
        loot={},
        vignette=5252,
    },
    [61213127] = { label="Azure Pathfinder",
        criteria=56105,
        quest=73867,
        npc=194210,
        loot={},
        note="Patrols the icy area",
        routes={{61213127, 59163080, 57562986, 54223190, 52023452, 49283837}},
        minimap=true,
    },
    [73002660] = { label="Beogoka",
        criteria=56106,
        quest=nil,
        npc=193116,
        loot={
            {197023,quest=69223,}, -- Cliffside Wylderdrake: Maned Neck
            200253, -- Snowspring Incanter's Knife
            200254, -- Totemic Cinch
            200673, -- Beogoka's Tooth and Claw
            200946, -- Thunderous Blade
        },
        vignette=5189,
    },
    [20674974] = { label="Notfar the Unbearable",
        criteria=56107,
        quest=73887,
        npc=193225,
        loot={},
        note="In cave",
    },
    [16622799] = { label="Blue Terror",
        criteria=56108,
        quest=nil,
        npc=193259,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            {197595,quest=69799,}, -- Windborne Velocidrake: Finned Ears
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
        note="Spawns at the top of a tree",
    },
    [36323583] = { label="Mahg the Trampler",
        criteria=56109,
        quest=73883,
        npc=190244,
        loot={
            {197149,quest=69350,}, -- Highland Drake: Club Tail
            {197608,quest=69812,}, -- Windborne Velocidrake: Gray Horns
            200157, -- Pathmaker
            200203, -- Repurposed Giant's Thimble
            200684, -- Emerald Tailbone
        },
        minimap=true,
    },
    [26804940] = { label="Skag the Thrower",
        criteria=56110,
        quest=74030, -- 72154
        npc=193149,
        loot={
            {196991,quest=69191,}, -- Cliffside Wylderdrake: Black Horns
            {197149,quest=69350,}, -- Highland Drake: Club Tail
            {197608,quest=69812,}, -- Windborne Velocidrake: Gray Horns
            200203, -- Repurposed Giant's Thimble
            200244, -- Enchanted Muckstompers
            200279, -- Competitive Throwing Gauntlets
            200563, -- Primal Ritual Shell
            200684, -- Emerald Tailbone
        },
        vignette=5440,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [32652915] = { label="Gruffy",
        criteria=56111,
        quest=69885,
        npc=193251,
        loot={
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200563, -- Primal Ritual Shell
            200755, -- Gruffy's Dented Horn
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5206,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [19204360] = { label="Grumbletrunk",
        criteria=56112,
        quest=69892,
        npc=193269,
        loot={
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200206, -- Behemoth Slayer Greatbow
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200563, -- Primal Ritual Shell
        },
        vignette=5210,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    --[[
    [] = { -- Rusthide
        criteria=56113,
        quest=nil,
        npc=193693,
        loot={},
    },
    --]]
    [70202520] = { label="Trilvarus Loreweaver",
        criteria=56114,
        quest=69861, -- 74087
        npc=193196,
        loot={
            {197106,quest=69307,}, -- Highland Drake: Finned Head
            {197400,quest=69601,}, -- Renewed Proto-Drake: Shark Snout
            198970, -- Infinitely Attachable Pair o' Docks
            200434, -- Anund's Mana-Singed Amice
            200446, -- Crystalized Sigil
            200549, -- Restored Titan Artifact
        },
        vignette=5186,
        note="Use crystals in the tower to the North and bring the energies to {npc:193782}",
        nearby={70402370, label="{spell:382076}"},
    },
    [49343819] = { label="Fisherman Tinnak",
        criteria=56115,
        quest=72730, -- 72254 (had 70792+74064 before)
        npc=193691,
        loot={
            {196985,quest=69185,}, -- Cliffside Wylderdrake: Horned Jaw
            {197001,quest=69201,}, -- Cliffside Wylderdrake: Finned Cheek
            {197098,quest=69299,}, -- Highland Drake: Finned Back
            {197382,quest=69583,}, -- Renewed Proto-Drake: White Horns
            {198070,quest=69980,}, -- Tattered Seavine
            200158, -- Eerie Spectral Ring
            200164, -- Iceloop
            200187, -- Rod of Glacial Force
            200245, -- Leviathan Lure
            200256, -- Darkmaul Soul Horn
            200310, -- Stole of the Iron Phantom
            200552, -- Torrent Caller's Shell
            200563, -- Primal Ritual Shell
        },
        hide_before=ns.conditions.MajorFaction(ns.FACTION_ISKAARA, 7),
        minimap=true,
        vignette=5475,
        related={
            [50523672] = {label="{item:381654:Broken Fishing Pole}", note="Click this first!", minimap=true,},
            [49973821] = {label="{item:385046:Torn Fishing Net}", note="Click this second!", minimap=true,},
            [49223842] = {label="{item:385047:Old Harpoon}", note="Click this third! {npc:193691: Fisherman Tinnak's Ghost} spawns closely nearby", minimap=true,},
        },
    },
    [13604860] = { label="Bisquius",
        -- also get achievement 16444, Leftovers' Revenge
        criteria=55381,
        quest=74097,
        npc=197557,
        loot={
            200882, -- Big Kinook's Spare Ladle
            200247, -- Inextinguishable Gavel
        },
        note="Complete {spell:388961:Community Feasts}",
    },
    [13602200] = { label="Blightfur",
        criteria=56122,
        quest=69858,
        npc=193178,
        loot={
            {196973,quest=69173,}, -- Cliffside Wylderdrake: Dual Horned Chin
            {196982,quest=69182,}, -- Cliffside Wylderdrake: Ears
            {196985,quest=69185,}, -- Cliffside Wylderdrake: Horned Jaw
            {196986,quest=69186,}, -- Cliffside Wylderdrake: Black Hair
            {197150,quest=69351,}, -- Highland Drake: Spiked Club Tail
            {197382,quest=69583,}, -- Renewed Proto-Drake: White Horns
            {197404,quest=69605,}, -- Renewed Proto-Drake: Finned Tail
            200127, -- Gold-Alloy Blade
            200158, -- Eerie Spectral Ring
            {200178,toy=true,}, -- Infected Ichor
            200256, -- Darkmaul Soul Horn
            200266, -- Gnollish Chewtoy Launcher
            200283, -- Gnoll-Gnawed Breeches
            200310, -- Stole of the Iron Phantom
            200432, -- Rotguard Cowl
        },
        vignette=5184,
    },
    [55043408] = { label="Spellwrought Snowman",
        criteria=56124,
        quest=74082, -- 69879 on vignette, didn't actually trigger?
        npc=193238,
        loot={
            {197001,quest=69201,}, -- Cliffside Wylderdrake: Finned Cheek
            {197098,quest=69299,}, -- Highland Drake: Finned Back
            200164, -- Iceloop
            200187, -- Rod of Glacial Force
            200211, -- Snowman's Icy Gaze
            200245, -- Leviathan Lure
            200552, -- Torrent Caller's Shell
        },
        vignette=5200,
        note="Collect 10x {npc:193424:Arcane Energy} for {npc:193255: Archmage Cleary} nearby",
        related={
            [53913570] = {label="{npc:193255: Archmage Cleary}", atlas="mechagon-projects", note="Gather {npc:193424:Arcane Energy}",},
        },
        nearby={
            54013628, 54083719, 54163467, 53493476, 53393655, 52923710, 52203733, 51683682, 51953565,
            label="{npc:193424:Arcane Energy}",
            note="Bring to {npc:193242:Arcane Pedestal}",
        },
    },
    [11093217] = ns.SUPERRARE{ -- Snarglebone
        criteria=56125,
        quest=74032,
        npc=197344,
        loot={
            {196982,quest=69182,}, -- Cliffside Wylderdrake: Ears
            {197150,quest=69351,}, -- Highland Drake: Spiked Club Tail
            200266, -- Gnollish Chewtoy Launcher
            200283, -- Gnoll-Gnawed Breeches
        },
        vignette=5413,
        note="On ~10 minute rotation with the other Brackenhide Hollow rares ({npc:197344}, {npc:197353}, {npc:197354}, {npc:197356})",
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [14483105] = ns.SUPERRARE{ -- Blisterhide
        criteria=56126,
        quest=73985,
        npc=197353,
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
        note="On ~10 minute rotation with the other Brackenhide Hollow rares ({npc:197344}, {npc:197353}, {npc:197354}, {npc:197356})",
        vignette=5414,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [14083747] = ns.SUPERRARE{ -- Gnarls
        criteria=56127,
        quest=73996,
        npc=197354,
        loot={
            {197121,quest=69322,}, -- Highland Drake: Tan Horns
            {197398,quest=69599,}, -- Renewed Proto-Drake: Snub Snout
            200259, -- Forest Dweller's Shield
            200267, -- Reinforced Garden Tenders
        },
        vignette=5415,
        note="On ~10 minute rotation with the other Brackenhide Hollow rares ({npc:197344}, {npc:197353}, {npc:197354}, {npc:197356})",
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [16213364] = ns.SUPERRARE{ -- High Shaman Rotknuckle
        criteria=56128,
        quest=74004,
        npc=197356,
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
        vignette=5416,
        note="On ~10 minute rotation with the other Brackenhide Hollow rares ({npc:197344}, {npc:197353}, {npc:197354}, {npc:197356})",
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    -- Lunker rares
    -- Needs Iskaara 5 to actually summon
    -- TODO: split these out somewhere
    [33806440] = { label="Skald the Impaler",
        -- TODO: this is the lava spot in waking shores...
        criteria=56117,
        quest=nil,
        npc=193708,
        loot={
            200086, -- Khaz'gorite-infused Resin
            200174, -- Bonesigil Shoulderguards
            200218, -- Charred Fishing Pole
            200232, -- Raptor Talonglaive
            200563, -- Primal Ritual Shell
        },
    },
    [58763255] = { label="Snufflegust",
        criteria=56116,
        quest=nil,
        npc=193706,
        loot={
            {197098,quest=69299,}, -- Highland Drake: Finned Back
            200086, -- Khaz'gorite-infused Resin
            200245, -- Leviathan Lure
            200563, -- Primal Ritual Shell
        },
        note="Summon with {item:194701:Ominous Conch}",
    },
    --[[
    [] = { -- Moth'go Deeploom
        criteria=56119,
        quest=74068,
        npc=193735,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200086, -- Khaz'gorite-infused Resin
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
    },
    [] = { -- Swog'ranka
        criteria=56120,
        quest=nil,
        npc=193634,
        loot={
            {197022,quest=69222,}, -- Cliffside Wylderdrake: Finned Neck
            {197589,quest=69793,}, -- Windborne Velocidrake: Large Head Fin
            200086, -- Khaz'gorite-infused Resin
            200131, -- Reclaimed Survivalist's Dagger
            200151, -- Seamist Blade
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            200435, -- Brackish Breeches
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200448, -- Abyssal Ward
            200552, -- Torrent Caller's Shell
        },
    },
    [] = { -- Swagraal the Swollen
        -- not certain this is a lunker rare, as wowhead has never seen it
        criteria=56121,
        quest=nil,
        npc=193167,
        loot={},
    },
    [58803260] = { label="Ravenous Tundra Bear",
        criteria=56129,
        quest=nil,
        npc=197371,
        loot={},
    },
    --]]
}, {
    achievement=16678, -- Adventurer
})
ns.RegisterPoints(ns.AZURESPAN, {
    [23443327] = { label="Cascade",
        npc=186962,
        quest=72836, -- 72358?
        loot={
            {197001,quest=69201,}, -- Cliffside Wylderdrake: Finned Cheek
            {197098,quest=69299,}, -- Highland Drake: Finned Back
            200135, -- Corroded Greatsword
            200164, -- Iceloop
            200187, -- Rod of Glacial Force
            200245, -- Leviathan Lure
            200552, -- Torrent Caller's Shell
            200563, -- Primal Ritual Shell
        },
        vignette=5050,
    },
    [38185903] = { label="Forgotten Creation",
        npc=193214,
        quest=69864, -- 72840
        loot={
            {197138,quest=69339,}, -- Highland Drake: Striped Pattern
            {197586,quest=69790,}, -- Windborne Velocidrake: Spiked Back
            200138, -- Ancient Dancer's Longspear
            200210, -- Amnesia
            200758, -- Breastplate of Storied Antiquity
        },
        vignette=5191,
    },
    [70063318] = { label="Summoned Destroyer",
        npc=193288,
        quest=72848, -- also 69895
        loot={
            {197135,quest=69336,}, -- Highland Drake: Toothy Mouth
            {197379,quest=69580,}, -- Renewed Proto-Drake: Impaler Horns
            200133, -- Volcanic Chakram
            200163, -- Ring of Embers
            200217, -- Blazing Essence
            200247, -- Inextinguishable Gavel
            200252, -- Molten Flak Cannon
            200563, -- Primal Ritual Shell
            200868, -- Integrated Primal Fire
        },
        vignette=5213,
    },
    [17394121] = { label="Vakril, the Strongest Tuskarr",
        npc=193223,
        quest=72853, -- 69872
        loot={
            {201728, quest=72853}, -- Vakril's Strongbox
            {197001, quest=69201}, -- Cliffside Wylderdrake: Finned Cheek
            {197098, quest=69299}, -- Highland Drake: Finned Back
        },
        vignette=5194,
    },
    [29814613] = { label="Breezebiter",
        npc=195353,
        quest=nil,
        loot={
            {201440, mount=1553}, -- Reins of the Liberated Slyvern
        },
        note="Spawns in this cave, then flies around the area in a big circle",
    },
    [36793249] = { label="Sharpfang",
        quest=72846, -- 67173
        npc=192749,
        loot={
            {196982, quest=69182}, -- Cliffside Wylderdrake: Ears
            {197150, quest=69351}, -- Highland Drake: Spiked Club Tail
            200266, -- Gnollish Chewtoy Launcher
            200283, -- Gnoll-Gnawed Breeches
        },
        note="Kill the gnolls to summon",
        vignette=5158, -- Thieving Gnolls (also 5484 Sharpfang)
    },
    [79503590] = { label="Bazual",
        quest=69927,
        worldquest=69927,
        npc=193532,
        loot={
            200654, -- Magmatic Vestments
            200660, -- Cinderfang Wrap
            200661, -- Basalt Brood Stompers
            200663, -- Shackles of the Dreaded Flame
            200761, -- Smoldering Sulfuron Signet
        },
    },
})

-- Ley Line in the Span
-- https://www.wowhead.com/achievement=16638/ley-line-in-the-span
ns.RegisterPoints(ns.AZURESPAN, {
    [43786190] = {criteria=55972, quest=72138,}, -- Azure Archives
    [26303631] = {criteria=55973, quest=72139,}, -- Ancient Outlook
    [65402835] = {criteria=55976, quest=72140,}, -- Slyvern Plunge
    [66075111] = {criteria=55974, quest=72136,}, -- Rustpine Den
    [66725958] = {criteria=55975, quest=72141,}, -- Ruins of Karnthar
}, {
    achievement=16638,
    atlas="AzeriteReady",
    minimap=true,
    note="Interact with the {npc:198260}; sometimes a Miner will need to break a rock wall before you can get in",
})
