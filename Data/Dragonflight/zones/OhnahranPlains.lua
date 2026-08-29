local myname, ns = ...

-- forgotten dragon treasure: 53246888

-- Aylaag camp SE: areaPoi 7101
-- Aylaag camp NE: areaPoi 7102

-- Aylaag caravan: vignette 5453, rewards caravan strongbox 200094, no quest completion

ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    -- https://www.wowhead.com/beta/achievement=16299/treasures-of-the-ohnahran-plains
    [32413815] = { label="Nokhud Warspear",
        criteria=54707,
        quest=67049,
        loot={
            200861, -- Stolen Shikaar Warspear
        },
        active={ns.conditions.Item(194540), ns.conditions.QuestComplete(67046), any=true}, -- Nokhud Armorer's Notes
        note="Find {item:194540} in other treasures"
    },
    [70533549] = { label="Slightly Chewed Duck Egg",
        criteria=54708,
        quest=67950,
        loot={
            {199172, pet=3309}, -- Viridescent Duck 
        },
        active={ns.conditions.Item(195453), ns.conditions.QuestComplete(67718), any=true}, -- Ludo's Stash Map
        related={
            [61014337] = {label="{npc:192997}",quest=67718,loot={{195453,quest=67718}},atlas="poi-workorders",active=false,note="Pet to receive {item:195453}"}, -- Ludo
        },
        note="Fetch {item:195453} from {npc:192997}",
        vignette=5214,
    },
    [33205532] = { label="Emerald Gem Cluster",
        criteria=54700,
        quest=70391,
        loot={
            200865, -- Glimmering Ysemerald Cluster
        },
        hide_before=ns.conditions.MajorFaction(ns.FACTION_DRAGONSCALE, 21),
        active={ns.conditions.Item(198843), ns.conditions.QuestComplete(70392), any=true}, -- Emerald Gardens Explorer's Notes
        note="Find {item:198843} in other treasures"
    },
    [73475616] = { label="Cracked Centaur Horn",
        criteria=54709,
        quest=70402,
        loot={
            200869, -- Ohn Lite Branded Horn
        },
    },
    [82307338] = { label="Gold Swog Coin",
        criteria=54710,
        quest=70379,
        loot={
            199338, -- Copper Coin of the Isles
        },
        note="In cave",
        path=81667175,
    },
    [51985830] = { label="Yennu's Boat",
        criteria=54711,
        quest=70400,
        loot={
            {200878, toy=true}, -- Wheeled Floaty Boaty Controller
        },
        note="In the water",
    },
}, {
    achievement=16299, -- Treasures
    minimap=true,
})
ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    [56017879] = {
        quest=71033,
        label="Water-Bound Chest",
        loot={
            201442, -- Primal Revenant's Frostblade
            201443, -- Primal Revenant's Icewall
            197948, -- Stone Sentinel's Greatsword
            197955, -- Sword of the Eternal Guard
        },
        note="Survive the trial of the elements",
        vignette=5407, -- and areaPoi 7265
        areaPoi=7265,
    },
    [82317322] = { label="The Great Swog",
        npc=191608,
        loot={
            199341, -- Regurgitated
            199342, -- Weighted
            202102, -- Immaculate
            {202042, toy=true, note="In bags"}, -- Aquatic Shades
            {199234, note="In bags"}, -- Schematic: Khaz'gorite Fisherfriend
        },
        active={ns.conditions.Item(199338), ns.conditions.Item(199339), ns.conditions.Item(199340), any=true},
        texture=ns.atlas_texture("Fishing-Hole", {r=1, g=0.5, b=0.5}), scale=1.2,
        minimap=true,
        path=81657175,
    },
    [52043344] = { label="Khadin",
        npc=193110,
        hide_before=ns.conditions.QuestComplete(69979), -- A worthy hunt
        note="Trade {item:191784:Dragon Shard of Knowledge} for Profession Knowledge",
        atlas="profession", minimap=true,
        group="professionknowledge",
    },
})

-- Divine Kiss of Ohn'ahra mount:
ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    [57593192] = { label="Ohn'ahra",
        npc=194796,
        quest=72512, -- A Whispering Breeze
        loot={
            {198821, mount=1545},
        },
        atlas="SanctumUpgrades-Venthyr-32x32",
        hide_before=ns.conditions.QuestComplete(66676), -- Sneaking In
        active=ns.conditions.OnQuest(72512), -- A Whispering Breeze
        note="* 3x {item:201929} from {npc:186151:Balakar Khan} in The Nokhud Offensive\n* 1x {item:201323:Essence of Awakening} from {npc:196707:Quartermaster Huseng}\n* 1x {item:191507:Exultant Incense} (Rank 3) from Alchemy",
        related={
            [56467328] = { label="Godoloto",
                -- (at 56797587 before sneaking in)
                label="{npc:190022:Godoloto}",
                quest=72512, -- A Whispering Breeze
                texture=ns.atlas_texture("SanctumUpgrades-Venthyr-32x32",{r=0.5, g=1, b=1}),
                hide_before=ns.conditions.QuestComplete(66676), -- Sneaking In
                active=ns.conditions.Item(201929, 3),
                note="Bring 3x {item:201929} from {npc:186151:Balakar Khan} in The Nokhud Offensive to start {quest:72512}",
            },
        },
    },
}, {
    minimap=true,
})

-- Lizi's Reins mount:
-- https://www.wowhead.com/beta/item=192799/lizis-reins#comments:id=5443480
-- (It's the Patient Bufonid again)
ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    [56127701] = {
        quest={71209, 71203, any=true}, -- 71199 is day 4, 71203 is the daily
        hide_before=ns.conditions.QuestComplete(66676), -- Sneaking In
    },
    [57667232] = {
        -- relocates here for day 5...
        quest={71195, 71203, any=true}, -- 71203 is the daily
        requires=ns.conditions.QuestComplete(71199), -- day 4 done
        related={
            [53517898] = {
                label="{item:200598}",
                npc=190015, -- Ohn Meluun
                loot={200598}, -- Meluun's Green Curry
                atlas="food", minimap=true,
            },
        },
    },
}, {
    npc=190014, -- Initiate Radiya
    loot={
        {192799, mount=1639}, -- Lizi's Reins
    },
    progress={71196, 71197, 71198, 71199, 71195},
    active={ns.conditions.MajorFaction(2503, 9), ns.conditions.Level(70)}, -- Maruuk rank 9
    texture=ns.atlas_texture("stablemaster", {r=0, g=0.5, b=1}), scale=1.2, minimap=true,
    note=function()
        local function q(quest, label)
            return (C_QuestLog.IsQuestFlaggedCompleted(quest) and GREEN_FONT_COLOR or RED_FONT_COLOR):WrapTextInColorCode(label)
        end
        return "Gather items over a week of quests:\n"..
            q(71196, "Day 1") ..": 20x {item:192615} from insects\n"..
            q(71197, "Day 2") ..": 20x {item:192658} from plant mobs\n"..
            q(71198, "Day 3") ..": 10x {item:194966} from fishing\n"..
            q(71199, "Day 4") ..": 20x {item:192636} from animals\n"..
            q(71195, "Day 5") ..": 1x {item:200598} from {npc:190015:Ohn Meluun}"
    end,
    group="dailymount"
})

-- Honor Our Ancestors
local ancestor = function(details)
    return ns.merge({
        label=function(self)
            self.label = ("{achievement:%d.%d}"):format(self.achievement, self.criteria)
            return self.label
        end,
        achievement=16423,
        requires=ns.conditions.AuraActive(369277), -- Essence of Awakening
        atlas="poi-soulspiritghost",
        minimap=true,
    }, details)
end
ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    [85662085] = {
        achievement=16423,
        label="{spell:369277:Essence of Awakening}",
        spell=369277,
        loot={
            {200630, toy=true}, -- Ohn'ir Windsage's Hearthstone
        },
        note="Get the buff from a small purple pile of dust in the hut, then go talk to the ghosts. They will want stuff...",
        hide_before=ns.conditions.MajorFaction(ns.FACTION_MARUUK, 7),
        texture=ns.atlas_texture("poi-soulspiritghost", {r=1, g=0, b=0.8}),
        minimap=true,
        related={
            [59703765] = ancestor{criteria=55302, quest=71167, active=ns.conditions.Item(197776)}, -- Maruukai Ancestor, Thrice-Spiced Mammoth Kabob (Cooking)
            [84902343] = ancestor{criteria=55303, quest=71168, active={ns.conditions.Item(199934), ns.conditions.Item(199976), ns.conditions.Item(200018), any=true}}, -- Timberstep Outpost Ancestor, Enchant Boots - Plainsrunner's Breeze (Enchanting)
            [75914208] = ancestor{criteria=55304, quest=71169, active=ns.conditions.Item(194690)}, -- Horn of Drusahl Ancestor, Horn o' Mead
            [73005500] = ancestor{criteria=55305, quest=71170, active=ns.conditions.Item(202070)}, -- Toghusuq Village Ancestor, Exceptional Pelt
            [84554842] = ancestor{criteria=55306, quest=71171, active=ns.conditions.Item(193470)}, -- Shikaar Highlands Ancestor, Feral Hide Drums (Leatherworking?)
            [74706980] = ancestor{criteria=55307, quest=71172, active=ns.conditions.Item(190327)}, -- The Carving Winds Ancestor, Awakened Air
            [63265727] = ancestor{criteria=55308, quest=71173, active=ns.conditions.Item(197788, 2)}, -- Sylvan Glade Ancestor, 2x Braised Bruffalon Brisket
            [54707838] = ancestor{criteria=55309, quest=71174, active=ns.conditions.Item(202071)}, -- Ohn'iri Springs Ancestor, Elemental Mote
            [41635670] = ancestor{criteria=55310, quest=71175, active=ns.conditions.Item(199049)}, -- Teerakai Ancestor, Fire-Blessed Greatsword
            [32757029] = ancestor{criteria=55311, quest=71176, active=ns.conditions.Item(191470, 5)}, -- The Eternal Kurgans Ancestor, 5x Writhebark (Herbalism)
        },
    },
})

-- Rares
ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    -- https://www.wowhead.com/beta/achievement=16677/adventurer-of-the-ohnahran-plains
    [20403800] = { label="Sparkspitter Vrak",
        criteria=56062,
        quest=73896,
        npc=193165,
        loot={
            {196999,quest=69199,}, -- Cliffside Wylderdrake: Swept Horns
            {197116,quest=69317,}, -- Highland Drake: Ears
            {197372,quest=69573,}, -- Renewed Proto-Drake: Purple Hair
            {197383,quest=69584,}, -- Renewed Proto-Drake: Heavy Horns
            {200198,toy=true,}, -- Primalist Prison
            200234, -- Vrak's Embossed Aegis
            200294, -- Primal Chain Hauberk
            200297, -- Hastily Cobbled Maul
            200313, -- Earthen Protoscale Drape
            200563, -- Primal Ritual Shell
            200689, -- Rimetalon Band
        },
    },
    [50027484] = { label="Scav Notail",
        criteria=56063,
        quest=69863,
        npc=193136,
        loot={
            {196982,quest=69182,}, -- Cliffside Wylderdrake: Ears
            {197150,quest=69351,}, -- Highland Drake: Spiked Club Tail
            200168, -- Gnoll Hide Belt
            200266, -- Gnollish Chewtoy Launcher
            200283, -- Gnoll-Gnawed Breeches
        },
        vignette=5187,
    },
    [56408160] = { label="Enraged Sapphire",
        criteria=56064,
        quest=69840,
        npc=193142,
        loot={
            {196991,quest=69191,}, -- Cliffside Wylderdrake: Black Horns
            {197624,quest=69828,}, -- Windborne Velocidrake: Club Tail
            198973, -- Incandescent Curio
            200244, -- Enchanted Muckstompers
            200246, -- Lost Delving Lamp
            200309, -- Rock Encrusted Chestguard
            200683, -- Legguards of the Deep Strata
        },
        vignette=5173,
    },
    [61801300] = { label="Seeker Teryx",
        criteria=56065,
        quest=nil,
        npc=193188,
        loot={
            {196970,quest=69170,}, -- Cliffside Wylderdrake: Spiked Back
            {197105,quest=69306,}, -- Highland Drake: Spined Chin
            {197138,quest=69339,}, -- Highland Drake: Striped Pattern
            {197586,quest=69790,}, -- Windborne Velocidrake: Spiked Back
            198974, -- Elegantly Engraved Embellishment
            200154, -- Rubyscale Band
            200758, -- Breastplate of Storied Antiquity
            200875, -- Seeker's Bands
        },
    },
    [31646421] = { label="Zenet Avis",
        criteria=56066,
        quest=73901,
        npc=193209,
        loot={
            {200879, note="Hatches into..."}, -- Zenet Egg
            {198825, mount=1672}, -- Zenet Hatchling
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            {197372,quest=69573,}, -- Renewed Proto-Drake: Purple Hair
            {197606,quest=69810,}, -- Windborne Velocidrake: Swept Horns
            200131, -- Reclaimed Survivalist's Dagger
            200172, -- Zephyrdance Signet
            200174, -- Bonesigil Shoulderguards
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200306, -- Tempest Shawl
            200314, -- Skyspeaker's Envelope
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        note="Flying",
    },
    [87406140] = { label="Liskheszaera",
        criteria=56067,
        quest=nil,
        npc=197009,
        loot={
            {197106,quest=69307,}, -- Highland Drake: Finned Head
            {197400,quest=69601,}, -- Renewed Proto-Drake: Shark Snout
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200434, -- Anund's Mana-Singed Amice
            200442, -- Basilisk Hide Jerkin
            200446, -- Crystalized Sigil
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
    },
    [29426783] = { label="Deadwaker Ghendish",
        criteria=56068,
        quest=nil,
        npc=189652,
        loot={
            189055, -- Ghendish's Backup Talisman
            {197367,quest=69568,}, -- Renewed Proto-Drake: Gray Hair
            200308, -- Rellen's Legacy
            200859, -- Seasoned Hunter's Trophy
        },
    },
    [37005400] = { label="Researcher Sneakwing",
        criteria=56069,
        quest=70698, -- 74023
        npc=196010,
        loot={
            {196992,quest=69192,}, -- Cliffside Wylderdrake: Heavy Horns
            {197403,quest=69604,}, -- Renewed Proto-Drake: Club Tail
            200165, -- Aegis of Scales
            200682, -- Hardened Scale Shoulderguards
        },
        vignette=5378,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [62987932] = { label="Mikrin of the Raging Winds",
        criteria=56070,
        quest=69857,
        npc=193173,
        loot={
            {197372,quest=69573,}, -- Renewed Proto-Drake: Purple Hair
            {197602,quest=69806,}, -- Windborne Velocidrake: Cluster Horns
            {197606,quest=69810,}, -- Windborne Velocidrake: Swept Horns
            {200198,toy=true,}, -- Primalist Prison
            200542, -- Breezy Companion
            200563, -- Primal Ritual Shell
        },
        vignette=5183,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [43145573] = { label="Ronsak the Decimator",
        criteria=56071,
        quest=74026, -- vignette 69878
        npc=193227,
        loot={
            {197016,quest=69216,}, -- Cliffside Wylderdrake: Maned Tail
            {197367,quest=69568,}, -- Renewed Proto-Drake: Gray Hair
            200308, -- Rellen's Legacy
            200441, -- Jhakan's Horned Cowl
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5205,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [53627281] = { label="Steamgill",
        criteria=56072,
        quest=69667,
        npc=193123,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200193, -- Manafrond Sandals
            200216, -- Water Heating Cord
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
            200942, -- Vibrant Emulsion
        },
        vignette=5168,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [71204620] = { label="Malsegan",
        criteria=56073,
        quest=69871,
        npc=193212,
        loot={
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200197, -- Armoredon Herding Crook
            200232, -- Raptor Talonglaive
        },
        vignette=5195,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [60812677] = { label="Oshigol",
        criteria=56074,
        quest=69877,
        npc=193235,
        loot={
            {197149,quest=69350,}, -- Highland Drake: Club Tail
            {197608,quest=69812,}, -- Windborne Velocidrake: Gray Horns
            200203, -- Repurposed Giant's Thimble
            200684, -- Emerald Tailbone
        },
        note="Patrols",
        vignette=5199,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [74414762] = { label="Fulgurb",
        criteria=56075,
        quest=69856,
        npc=193170,
        loot={
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            {200249,toy=true,}, -- Mage's Chewed Wand
            200433, -- Footwraps of Subjugation
            200442, -- Basilisk Hide Jerkin
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5182,
        -- hide_before=ns.MAXLEVEL, -- TODO
    },
    [58596822] = { label="Windseeker Avash",
        criteria=56076,
        quest=74088, -- 74440
        npc=192045,
        loot={
            {197016,quest=69216,}, -- Cliffside Wylderdrake: Maned Tail
            {197367,quest=69568,}, -- Renewed Proto-Drake: Gray Hair
            200141, -- Wind Generating Band
            200308, -- Rellen's Legacy
            200441, -- Jhakan's Horned Cowl
            200859, -- Seasoned Hunter's Trophy
        },
    },
    [49496663] = { label="Eaglemaster Niraak",
        criteria=56077,
        quest=74063,
        npc=192020,
        loot={
            {197016,quest=69216,}, -- Cliffside Wylderdrake: Maned Tail
            {197367,quest=69568,}, -- Renewed Proto-Drake: Gray Hair
            200308, -- Rellen's Legacy
            200536, -- Tamed Eagle
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5138,
    },
    [29756131] = { label="Zarizz",
        criteria=56078,
        quest=72364, -- 74091
        npc=193140,
        loot={
            200131, -- Reclaimed Survivalist's Dagger
            200215, -- Plumed Shoulderguards of the Hunt
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5469,
    },
    [20304370] = { label="Scaleseeker Mezeri",
        criteria=56079,
        quest=74073, -- 69865?
        npc=193215,
        loot={
            {197383,quest=69584,}, -- Renewed Proto-Drake: Heavy Horns
            {200198,toy=true,}, -- Primalist Prison
            200292, -- Cragforge Pauldrons
            200294, -- Primal Chain Hauberk
            200313, -- Earthen Protoscale Drape
            200439, -- Earthpact Scepter
            200735, -- Magically Magical Faerie Flower
        },
        vignette=5190,
        related={
            [16605120] = {label="{npc:193224:Dawnbell}",note="Bring {item:194681:Sugarwing Cupcakes} from an innkeeper, then follow her to {npc:193215:Scaleseeker Mezeri}"},
        }
    },
    [29554146] = { label="Shade of Grief",
        criteria=56080,
        quest=74075,
        npc=187559,
        loot={
            {196985,quest=69185,}, -- Cliffside Wylderdrake: Horned Jaw
            {196996,quest=69196,}, -- Cliffside Wylderdrake: Branched Horns
            {197115,quest=69316,}, -- Highland Drake: Thorned Jaw
            {197382,quest=69583,}, -- Renewed Proto-Drake: White Horns
            200158, -- Eerie Spectral Ring
            200256, -- Darkmaul Soul Horn
            200310, -- Stole of the Iron Phantom
            200437, -- Dreamsong Censer
            200444, -- Mantle of the Gatekeeper
        },
        vignette=5181, -- Solethus' Gravestone
    },
    --[[
    [] = { -- Nokhud Warmaster
        criteria=56081,
        quest=nil,
        npc=187219,
        loot={},
        vignette=5062,
    },
    --]]
    [85221544] = { label="Hamett",
        criteria=56082,
        quest=73951,
        npc=187781,
        loot={},
    },
    [80364198] = { label="Hunter of the Deep",
        criteria=56083,
        quest=nil, -- no quest tripped
        npc=188095,
        loot={}, -- supplies and centaur rep...
        vignette=5077, -- vignette wasn't actually shown, just a swarm of no-data vignettes
    },
    [80413867] = { label="Irontree",
        criteria=56084,
        quest=73967, -- 66356
        npc=188124,
        loot={},
        vignette=5078,
        path=79383649,
    },
    [72222321] = { label="Zerimek",
        criteria=56085,
        quest=73980,
        npc=188451,
        loot={},
        vignette=5087,
    },
    [77868271] = { label="Sulfurion",
        criteria=56086,
        quest=nil,
        npc=191842,
        loot={},
        vignette=5135,
        path=76768206,
    },
    [59716810] = { label="Porta the Overgrown",
        criteria=56087,
        quest=nil,
        npc=191950,
        loot={},
        vignette=5136,
        active=ns.conditions.Item(194426, 5), -- Enriched Soil
    },
    [27715557] = { label="The Jolly Giant",
        criteria=56088,
        quest=73976,
        npc=195204,
        loot={},
        vignette=5352,
    },
    [84214784] = { label="Windscale the Stormborn",
        criteria=56089,
        quest=nil,
        npc=192364,
        loot={
            198970, -- Infinitely Attachable Pair o' Docks
        },
        vignette=5140,
    },
    [83786215] = { label="Vaniik the Stormtouched",
        criteria=56090,
        quest=nil,
        npc=192453,
        loot={},
        vignette=5143, -- Vaniik the Corrupted
    },
    [31607660] = { label="Cinta the Forgotten",
        criteria=56092,
        quest=nil,
        npc=195186,
        loot={},
        vignette=5351,
    },
    [42804428] = { label="Rustlily",
        criteria=56093,
        quest=nil,
        npc=195223,
        loot={
            198976, -- Exceedingly Soft Skin
        },
    },
    [32823817] = { label="Makhra the Ashtouched",
        criteria=56094,
        quest=73968,
        npc=195409,
        loot={},
        vignette=5365,
        note="Only when the Aylaag Camp is in the Western position",
    },
    --[[
    [] = { -- Quackers the Terrible
        -- Spawns during the Aylaag Caravan escort from Eaglewatch Outpost to Aylaag Outpost
        criteria=56091,
        quest=nil,
        npc=192557,
        loot={},
        vignette=5144,
    },
    [] = { -- The Great Enla
        -- Spawns during the Aylaag Caravan escort from Eaglewatch Outpost to Aylaag Outpost
        criteria=56095,
        quest=nil,
        npc=196334,
        loot={},
    },
    [] = { -- Old Stormhide
        -- Spawns during the Aylaag Caravan escort from Eaglewatch Outpost to Aylaag Outpost
        criteria=56096,
        quest=nil,
        npc=196350,
        loot={},
    },
    --]]
}, {
    achievement=16677, -- Adventurer
})
ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    [81447834] = { label="Seereel, the Spring",
        -- TODO: find the spawn point in Azure Span, which presumably exists?
        achievement=16678, -- Adventurer of the *Azure Span*
        criteria=56118,
        quest=nil,
        npc=193710,
        loot={
            {197001,quest=69201,}, -- Cliffside Wylderdrake: Finned Cheek
            {197098,quest=69299,}, -- Highland Drake: Finned Back
            198964, -- Elementious Splinter
            200086, -- Khaz'gorite-infused Resin
            200164, -- Iceloop
            200187, -- Rod of Glacial Force
            200245, -- Leviathan Lure
            200552, -- Torrent Caller's Shell
            200563, -- Primal Ritual Shell
        },
        note="Throw 5x {item:194701:Ominous Conch} into a Lurker Sighting to summon",
    },
    [81207780] = { label="Astray Splasher",
        achievement=16678, -- Adventurer of the *Azure Span*
        criteria=56130,
        quest=74057, -- 72400? an iskaar rep level hit at the same time...
        npc=197411,
        loot={
            200164, -- Iceloop
        },
    },
    [59926695] = { label="Prozela Galeshot",
        quest=72815, -- 69968 also
        npc=193669,
        loot={
            {197372,quest=69573,}, -- Renewed Proto-Drake: Purple Hair
            {197383,quest=69584,}, -- Renewed Proto-Drake: Heavy Horns
            {197602,quest=69806,}, -- Windborne Velocidrake: Cluster Horns
            {197606,quest=69810,}, -- Windborne Velocidrake: Swept Horns
            200134, -- Ohuna Mass-Binding Totem
            200172, -- Zephyrdance Signet
            {200198,toy=true,}, -- Primalist Prison
            200199, -- Elements' Burden
            200292, -- Cragforge Pauldrons
            200293, -- Primal Scion's Twinblade
            200294, -- Primal Chain Hauberk
            200306, -- Tempest Shawl
            200313, -- Earthen Protoscale Drape
            200314, -- Skyspeaker's Envelope
            200439, -- Earthpact Scepter
            200563, -- Primal Ritual Shell
        },
        vignette=5240,
    },
    [44904923] = { label="Skaara",
        quest=70783, -- 72847 also
        npc=192949,
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
        note="In cave",
        vignette=5389,
    },
    [26356534] = { label="Ripsaw the Stalker",
        quest=69851, -- also 72845
        npc=193153,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200137, -- Chitin Dreadbringer
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
        },
        vignette=5178,
    },
    [22996667] = { label="Territorial Coastling",
        quest=69852, -- also 72851
        npc=193163,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200186, -- Amberquill Shroud
            200193, -- Manafrond Sandals
            200212, -- Sand-Encrusted Greaves
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200445, -- Lucky Hunting Charm
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        vignette=5179,
    },
    [26073414] = { label="Ty'foon the Ascended",
        quest=66970, -- also 72852
        npc=191354,
        loot={
            {197372,quest=69573,}, -- Renewed Proto-Drake: Purple Hair
            {197383,quest=69584,}, -- Renewed Proto-Drake: Heavy Horns
            {197602,quest=69806,}, -- Windborne Velocidrake: Cluster Horns
            {197606,quest=69810,}, -- Windborne Velocidrake: Swept Horns
            198429, -- Typhoon Bringer
            {200198,toy=true,}, -- Primalist Prison
            200314, -- Skyspeaker's Envelope
            200563, -- Primal Ritual Shell
        },
        path=24503340,
        vignette=5131,
    },
    [73785597] = { label="Biryuk",
        quest=73903,
        npc=193168,
        loot={}, -- only supplies and commendations
    },
    [63044855] = { label="Sunscale Behemoth",
        quest=69837, -- 72849
        npc=193133,
        loot={
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            {198409,toy=true,}, -- Personal Shell
            {200249,toy=true,}, -- Mage's Chewed Wand
        },
        note="Behind the waterfall",
    },
    [43205060] = { label="Web-Queen Ashkaz",
        -- [43205060, 43405040]
        quest=nil,
        npc=192983,
        loot={
            {196976,quest=69176,}, -- Cliffside Wylderdrake: Head Mane
            {197111,quest=69312,}, -- Highland Drake: Maned Head
            200131, -- Reclaimed Survivalist's Dagger
            200174, -- Bonesigil Shoulderguards
            200193, -- Manafrond Sandals
            200195, -- Thunderscale Legguards
            200232, -- Raptor Talonglaive
            {200249,toy=true,}, -- Mage's Chewed Wand
            200442, -- Basilisk Hide Jerkin
            200563, -- Primal Ritual Shell
            200859, -- Seasoned Hunter's Trophy
        },
        path=43004800, -- TODO: improve this
    },
    [83507630] = { label="Strunraan",
        quest=69929, -- 72055
        worldquest=69929,
        npc=193534,
        loot={
            200676, -- Static-Charged Scale
            200687, -- Stormshale Cuffs
            200688, -- Tights of Twisting Winds
            200733, -- Storm Chaser's Waistguard
            200734, -- Striders of the Sky's Misery
        },
    },
    [60417127] = { label="Nergazurai",
        quest=74093,
        npc=195895, -- 59027499
        routes={{
            60417127, 58807080, 57807360, 58207460, 62207600, 63807600, 66807300, 65207060, 65206820,
            66005880, 68805560, 68605160, 67205100, 68805680, 65605980, 65206900, r=1, g=0, b=0, loop=true,
        }},
    },
    [36043433] = { label="Lurgan",
        quest=74546, -- 74464
        npc=201540,
        loot={
            203674, -- Brutal Tramplers
        },
        vignette=5570,
    },
    [32634184] = { label="Stormcaller Narkena",
        quest=74547, -- 47465
        npc=201539,
        loot={
            203676, -- Stormcaller's Grounding Shoes
        },
        vignette=5571,
    },
    [33803840] = { label="Huntmaster Yrgena",
        quest=74548, -- 74466
        npc=201538,
        loot={
            203672, -- Master Huntmaster's Wristguards
        },
        vignette=5572,
    },
    --[[
    -- accompanied by
    [33803840] = { label="Rugren",
        -- [33803840, 33803860]
        quest=nil,
        npc=201563,
    },
    ]]
    [35404080] = { label="Groffnar",
        quest=74463,
        npc=201537,
        loot={
            203671, -- Pack Leader's Pelt
        },
    },
    [37003640] = { label="Bloodbeak the Ravenous",
        quest=74467,
        npc=201535,
        loot={
            203673, -- Bloodbeak's Ravenor
        },
    },
})

-- Who's a Good Bakar?
ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    [40915658] = { label="Alli",
        criteria=55348,
        npc=197569,
    },
    [84272477] = { label="Baba",
        criteria=55316,
        npc=189274,
        hide_before=ns.conditions.QuestComplete(66006), -- Return to Roscha
    },
    [48994107] = { label="Baga",
        criteria=55329,
        npc=196871,
    },
    [60603980] = { label="Berrel",
        criteria=55326,
        npc=195669,
    },
    [85132240] = { label="Elaichi",
        criteria=55317,
        npc=187840,
        hide_before=ns.conditions.QuestComplete(65954), -- Release the Hounds
    },
    [76683055] = { label="Ellam",
        criteria=55321,
        npc=187667,
        hide_before={ns.conditions.MajorFaction(ns.FACTION_MARUUK, 4), ns.conditions.OnQuest(66698)}, -- Counting Argali
    },
    [83902592] = { label="Gentara",
        criteria=55320,
        npc=186189,
    },
    [80685891] = { label="Laila",
        criteria=55331,
        npc=190043,
    },
    [61005230] = { label="Nahma",
        criteria=55328,
        npc=192687,
    },
    [84162711] = { label="Pesca",
        criteria=55319,
        npc=189278,
        hide_before=ns.conditions.QuestComplete(65954), -- Release the Hounds
    },
    [81115841] = { label="Rotti",
        criteria=55330,
        npc=191405,
    },
    [71624965] = { label="Soyoo",
        criteria=55347,
        npc=197514,
        hide_before=ns.conditions.QuestComplete(67772), -- The Trouble with Taivan
    },
    [84082295] = { label="Tseg",
        criteria=55318,
        npc=189276,
        hide_before=ns.conditions.QuestComplete(65954), -- Release the Hounds
    },
    [81035949] = { label="Wish",
        criteria=55324,
        npc=191408,
    },
    --
    --[[
    [61164002] = { label="Taivan (before quest)",
        criteria=55325,
        npc=197518,
        hide_before=ns.conditions.QuestIncomplete(69096), -- Taivan's Purpose
    },
    --]]
    [61813865] = { label="Taivan (after quest)",
        criteria=55325,
        npc=197518,
        hide_before=ns.conditions.QuestComplete(69096), -- Taivan's Purpose
        note="The version summoned by the toy doesn't count",
    },
    --
    [64004118] = { label="Katei",
        criteria=55323,
        npc=196650,
    },
    [64014119] = { label="Vinyu",
        criteria=55322,
        npc=196651,
    },
    --
    [84932508] = { label="Fogl",
        criteria=55315,
        npc=189387,
        hide_before=ns.conditions.QuestComplete(65954), -- Release the Hounds
    },
    [84942509] = { label="Zephyr",
        criteria=55314,
        npc=189388,
        hide_before=ns.conditions.QuestComplete(65954), -- Release the Hounds
    },
}, {
    achievement=16424, -- Who's a Good Bakar?
    texture=ns.atlas_texture("WildBattlePet", {}),
    minimap=true,
    -- icon=930453, -- Inv_stbernarddogpet
})
-- Hugo
ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    [55605240] = {},
    [70636364] = {},
    [71193156] = {},
}, {
    achievement=16424, -- Who's a Good Bakar?
    criteria=55327,
    npc=189377,
    note="In the Aylaag Clan camp, wherever it currently is",
    hide_before=ns.conditions.MajorFaction(ns.FACTION_MARUUK, 4),
    texture=ns.atlas_texture("WildBattlePet", {}),
    minimap=true,
})

-- Sleeping on the Job
ns.RegisterPoints(ns.OHNAHRANPLAINS, {
    [33515321] = {criteria=55776, npc=198064,}, -- Dreamguard Felyasra
    [29876222] = {criteria=55777, npc=198068, path=29696022}, -- Dreamguard Erezsra
    [25296540] = {criteria=55778, npc=198069,}, -- Dreamguard Sayliasra
    [18025378] = {criteria=55779, npc=198074,}, -- Dreamguard Aiyelasra
    [19088289] = {criteria=55780, npc=198073,}, -- Dreamguard Lucidra
    [29404153] = {criteria=55781, npc=198075,}, -- Dreamguard Taelyasra
}, {
    achievement=16574,
    note="/sleep",
    texture=ns.atlas_texture("VenthyrAssaultsQuest-32x32", {r=0, g=1, b=0}), scale=1.2,
    minimap=true,
})
