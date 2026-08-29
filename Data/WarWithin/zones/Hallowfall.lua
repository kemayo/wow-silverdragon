local myname, ns = ...

--[[
Notes:

tripped together while I was running around the keyflame area at 80: 81416+83208

faction unlocks with light of the dawntower 78671, also trips hidden 79654...

Strange Eggs @ 67162184, The Unusual Bug (item 212331), starts The Unusual Bug (quest 79221)

Worldsoul memories (vignette 6358)
60686749
]]

local ShadowPhase = ns.conditions._Condition:extends{classname="ShadowPhase"}
function ShadowPhase:Label()
    local shadowed = ITEM_QUALITY_COLORS[4].color:WrapTextInColorCode("{spell:131233:Shadowed}")
    if self:Matched() then
        return shadowed .. " " .. GARRISON_MISSION_TIMELEFT:format(self:Duration(self:NextSpawn() - (3600 * 2.5)))
    else
        -- "%s in %s"
        return WARDROBE_TOOLTIP_ENCOUNTER_SOURCE:format(shadowed, self:Duration(self:NextSpawn()))
    end
end
function ShadowPhase:Matched()
    -- if it's more than 2.5 hours away, we must be during the current event
    return self:NextSpawn() > (3600 * 2.5)
end
function ShadowPhase:NextSpawn()
    -- Shadow phase starts one hour and one minute after the daily reset, then
    -- repeating every three hours; each time it lasts for 30 minutes.
    -- (Well, the shift starts about 45 seconds after, and takes about 15
    -- seconds to play.)
    return (GetQuestResetTime() + 3600 + 60) % 10800
end
function ShadowPhase:Duration(seconds)
    if seconds > 3600 then
        return COOLDOWN_DURATION_HOURS:format(floor(seconds / 3600)) .. " " .. COOLDOWN_DURATION_MIN:format(floor((seconds % 3600) / 60))
    end
    return COOLDOWN_DURATION_MIN:format(floor(seconds / 60))
end

local SHADOWPHASE = ShadowPhase()

ns.RegisterPoints(ns.HALLOWFALL, {
    [11091678] = ns.Getterize{
        label="{spell:452526:Beledar's Influence}",
        texture_light = ns.atlas_texture("Mobile-Jewelcrafting", {r=1, g=1, b=0.5}),
        texture_dark = ns.atlas_texture("Mobile-Jewelcrafting", {r=0.75, g=0, b=1}),
        scale=5,
        group="beledar",
        __get={
            note=function(self)
                return SHADOWPHASE:Label() ..
                    "\nBeledar switches from light to dark for 30 minutes every 3 hours." ..
                    "\n|cff00ffffClick|r this to force {npc:207802:Beledar's Spawn} to " ..
                    (self.FORCED and "hide" or "show") .. " regardless of your normal settings"
            end,
            texture=function(self)
                return SHADOWPHASE:Matched() and self.texture_dark or self.texture_light
            end,
        },
        OnClick=function(self, button, uiMapID, coord)
            -- TODO: it'd be nice to work out the current state of the Spawn
            -- points so I can toggle from the start, rather than the first
            -- click apparently doing nothing if they're currently shown
            self.FORCED = not self.FORCED
            for coord, opoint in pairs(ns.points[ns.HALLOWFALL]) do
                if opoint.npc == 207802 then
                    opoint.force = self.FORCED
                end
            end

            C_Timer.NewTimer(0, function() ns.HL:Refresh() end)
        end,
    },
})

-- Treasures

ns.RegisterPoints(ns.HALLOWFALL, {
    [41775829] = { label="Caesper",
        criteria=69692,
        quest=83263,
        loot={
            225639, -- Recipe: Exquisitely Eviscerated Muscle
            225592, -- Exquisitely Eviscerated Muscle
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        active=ns.conditions.Item(225238), -- Meaty Haunch
        related={
            [69254397]={label="{npc:217645:Torran Dellain}", note="Buy {item:225238:Meaty Haunch}", inbag=225238, minimap=true,},
        },
        note="Bring {item:225238:Meaty Haunch} from {npc:217645:Torran Dellain}, give to {npc:225948:Caesper}, follow to the treasure",
        level=73,
        vignette=6367, -- 6368 after you feed, 6366 for Disturbed Lynx Treasure
    },
    [55135193] = { label="Smuggler's Treasure",
        criteria=69693,
        quest=83273,
        loot={
            226021, -- Jar of Pickles
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        note="Get the key from the {npc:226025:Dead Arathi} below",
        nearby={55425164},
        level=73,
        vignette=6370,
    },
    [59525966] = { label="Dark Ritual",
        criteria=69694,
        quest=83284,
        loot={
            225693, -- Shadowed Essence
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        note="In cave; use the book, defeat the summoned monsters",
        level=73,
        vignette=6372, -- 6371 after you defeat them
    },
    [40015112] = { label="Arathi Loremaster",
        criteria=69695,
        quest=83298, -- questions trip 83300, 83301, 83302, 83303, 83304, 83305
        loot={
            {225659, toy=true}, -- Arathi Book Collection
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        note="Answer riddles from {npc:221630:Ryfus Sacredpyr}; you need to find the books for {achievement:40622:Biblo Archivist} for the correct answers to appear",
        level=73, -- not to talk to him, but to get any of the books for answers...
        vignette=6373,
    },
    [55796954] = { label="Jewel of the Cliffs",
        criteria=69697,
        quest=81971,
        loot={
            224580, -- Massive Sapphire Chunk
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        note="High up on the rocks",
        level=75,
        vignette=6174,
    },
    [30223877] = { label="Priory Satchel",
        criteria=69698,
        quest=81972,
        loot={
            224578, -- Arathor Courier's Satchel
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        level=75,
        note="Hanging from the cathedral",
        vignette=6175,
    },
    [50061382] = { label="Lost Necklace",
        criteria=69699,
        quest=81978,
        loot={
            224575, -- Lightbearer's Pendant
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        level=75,
        vignette=6177, -- Lost Memento
    },
    [58392716] = { label="Illuminated Footlocker",
        criteria=69701,
        quest=81468,
        loot={
            {224552, toy=true}, -- Cave Spelunker's Torch
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        note="In cave. Catch falling glimmers from {npc:220703:Starblessed Glimmerfly} until you get {spell:442529:Glimmering Illumination}",
        level=73,
        vignette=6098,
    },
    [76775383] = { label="Spore-covered Coffer",
        criteria=69702,
        quest=79275,
        loot={
            -- alchemy mats
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        note="In cave",
        level=73,
        vignette=5989,
    },
    [45904510] = { label="Sky-Captains' Sunken Cache",
         -- I believe the four captains are random, but the quest ids I got from the four I talked to were 82012, 82026, 82024, and 82025. ~Marthammor
        criteria=69700,
        quest=82005,
        loot={
            {224554, toy=true}, -- Silver Linin' Scepter
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        active={ns.conditions.QuestComplete(82012), ns.conditions.QuestComplete(82026), ns.conditions.QuestComplete(82024), ns.conditions.QuestComplete(82025)},
        note="Talk to four skyship captains flying around the zone to make this appear",
        routes={
            {45904510, 62754689, highlightOnly=true, _related=62754689},
            {45904510, 49535554, highlightOnly=true, _related=49535554},
            {45904510, 54821161, highlightOnly=true, _related=54821161},
            {45904510, 27633461, highlightOnly=true, _related=27633461},
        },
        atlas="VignetteLootElite", scale=1.2,
        vignette=6181, -- Sunken Cache
    },
}, {
    achievement=40848,
})

ns.RegisterPoints(ns.HALLOWFALL, {
    [62551633] = {
        label="Crabber Supplies",
        quest=84342,
        loot={
            226018, -- Darkened Arathi Cape (cosmetic)
            206350, -- Radiant Remnant
            ns.rewards.Currency(ns.CURRENCY_RESONANCE, 5),
        },
        vignette=6537,
    },
    [56091455] = {
        label="Fisherman's Pouch",
        quest=81518,
        loot={
            206350, -- Radiant Remnant
            ns.rewards.Currency(ns.CURRENCY_RESONANCE, 3),
        },
        vignette=6103,
    },
})

-- Assorted shadowed loot
local SHADOWED = ns.nodeMaker{
    note="Only visible with a light source ({item:211872:Patrol Torch}, {item:220756:Flickering Torch}, {item:217344:Sentry Flare Launcher}, etc)",
    minimap=true, scale=0.9,
    hide_before=ns.WORLDQUESTS,
    group="shadowed",
}

ns.RegisterPoints(ns.HALLOWFALL, {
    [62013176] = {
        label="Hillhelm Lunchbox",
        quest=82996,
        vignette=6352,
    },
    [65193399] = {
        label="Hillhelm Lunchbox",
        quest=82996,
        vignette=6352,
    },
    [65432715] = {
        label="Surveyor's Box",
        quest=84341,
        vignette=6536,
    },
    [64732948] = {
        label="Harvest Box",
        quest=80420,
        vignette=6071,
    },
    [65652946] = {
        label="Harvest Box",
        quest=80420,
        vignette=6071,
    },
    [64492879] = {
        label="Fieldhand Stash",
        quest=84337,
        vignette=6533,
    },
    [66142802] = {
        label="Farm Satchel",
        quest=81988,
        vignette=6178,
        additional={64872564},
    },
}, SHADOWED{
    loot={
        226019, -- Darkened Arathi Shoulderguards (cosmetic)
        206350, -- Radiant Remnant
        ns.rewards.Currency(ns.CURRENCY_RESONANCE, 3),
    },
})

ns.RegisterPoints(ns.HALLOWFALL, {
    [66561514] = {
        label="Captain Lancekat's Discretionary Funds",
        quest=81612,
        path=66011863,
        vignette=6108,
    },
    [61633265] = { label="directly saw",
        label="Farmhand Stash",
        quest=80590,
        vignette=6092,
    },
    [63073074] = { label="wowhead comments",
        label="Farmhand Stash",
        quest=80590,
        vignette=6092,
    },
    [64513159] = { label="directly saw the vignette for this one",
        label="Old Rotting Crate",
        quest=84339,
        vignette=6534,
    },
    [64933336] = { label="wowhead comments swear it's here",
        label="Old Rotting Crate",
        quest=84339,
        vignette=6534,
    },
}, SHADOWED{
    loot={
        226016, -- Darkened Tabard of the Arathi (cosmetic)
    },
})

-- Nightfarm Growthling
ns.RegisterPoints(ns.HALLOWFALL, {
    [61403180] = {},
    [63403110] = {},
    [64203160] = {},
    [65203340] = {},
    [65203350] = {},
}, SHADOWED{
    loot={
        {221546, pet=true}, -- Nightfarm Growthling
    },
    texture=ns.atlas_texture("VignetteLoot", {r=1, g=0.5, b=1})
})

-- Thunder
ns.RegisterPoints(ns.HALLOWFALL, {
    [64451880] = {
        label="{npc:212419:Attica Whiskervale}",
        note="Talk until they offer {quest:82007:Tale of Tales}",
    },
}, SHADOWED{
    quest=82007,
    atlas="banker",
    loot={
        {220782, pet=true}, -- Thunder
    },
})
ns.RegisterPoints(ns.HALLOWFALL, {
    [66311569] = {label="{npc:222373:Beef}", note="In cave", path=65831877}, -- Beef
}, SHADOWED{
    quest=82007,
    atlas="WildBattlePet", minimap=true, scale=0.9,
    requires=ns.conditions.OnQuest(82007), -- Tale of Tales
    -- hide_before=ns.conditions.QuestComplete(82006), -- quest for finishing Attica's dialog
})
ns.RegisterPoints(ns.HALLOWFALL, {
    [63901970] = {label="{npc:222372:Beans}"}, -- Beans
    [61982078] = {label="{npc:222375:Thunder}"}, -- Thunder
    [66702100] = {label="{npc:222374:Cap'n Elaena}"}, -- Cap'n Elaena
}, {
    quest=82007,
    atlas="WildBattlePet",
    requires=ns.conditions.OnQuest(82007), -- Tale of Tales
})

-- Life on the Farm
local FARMLIFE = {
    achievement=40360, 
    atlas="QuestNormal",
}
ns.RegisterPoints(ns.HALLOWFALL, {
    [64752653] = { label="Lil Piggy",
        criteria=68012, quest=82963, onquest=82963, loot={224457},
        additional={
            63802643,
            64022592,
            64502736,
            64752732,
        },
        note="Various spawn points near here",
    },
}, SHADOWED(FARMLIFE))
ns.RegisterPoints(2312, { -- Mycomancer Cavern
    [39292127] = {criteria=68271, quest=83278, onquest=83278, loot={225336},}, -- Lost Shoe
    [58913111] = {criteria=68272, quest=83282, onquest=83282, loot={225339},}, -- Chicken Eggs
}, FARMLIFE)

-- Sky-Captain's Sunken Cache (Treasures)
ns.RegisterPoints(ns.HALLOWFALL, {
    [62754689] = {
        label="{npc:222333:Sky-Captain Dornald}, The Mighty Lynx",
        quest=82012,
        routes={{
            58174030, 55013755, 53543627, 53343609, 52253524, 52033507, 48913292, 48503264, 48273252, 48043235,
            47813233, 47573235, 47313239, 47083247, 46873259, 46663276, 46433299, 46253319, 46053337, 45393392,
            45193414, 45023438, 44863464, 44563522, 44293587, 44103648, 43584116, 43594153, 43664222, 43724256,
            46154846, 46324869, 46894935, 47524996, 48185051, 49525136, 49995156, 50225164, 50465171, 51415189,
            52145196, 54155173, 55395149, 56085131, 56745109, 59335028, 59555018, 61004968, 61234958, 61464941,
            61684921, 61884898, 62064873, 62224848, 62364821, 62484791, 62594759, 62694725, 62754689, 62784650,
            62774615, 62724584, 62634552, 62524519, 62394488, 62074425, 61744370, 61564345, 61164299, 59894181,
            59674159, 59274123,
            loop=true,
            r=1, g=0.6, b=0.6,
        }},
    },
    [49535554] = {
        label="{npc:222311:Sky-Captain Clairmonte}, The Embers",
        quest=82024,
        routes={{
            40034513, 35694513, 34024547, 33354577, 32914604, 32454639, 32064674, 30944759, 30554798, 30394824,
            30254852, 30134883, 29944950, 29874986, 29755094, 29745129, 29805244, 30135458, 30235496, 30365530,
            30515558, 30675582, 31025625, 31195653, 31375675, 31565693, 31975725, 32185738, 32415750, 34565838,
            34785844, 35275853, 37185924, 37875947, 39476029, 42336237, 42566253, 43036280, 43956320, 44406341,
            44656348, 44886350, 45396346, 45886337, 46136330, 46376321, 46596307, 46806290, 47586208, 47946157,
            48226097, 49155797, 49275725, 49535554, 49705372, 49765297, 49745262, 49635196, 49425130, 49285097,
            48684983, 46614717, 45784650, 44184565, 43934557, 43694551, 43454547, 42094520,
            loop=true,
            r=0.6, g=1, b=0.6,
        }},
    },
    [54821161] = {
        label="{npc:222337:Sky-Captain Onaro}, The Resolute Flame",
        quest=82026,
        routes={{
            52392748, 55451614, 55501578, 55521541, 55511504, 55481467, 55431432, 54821161, 54581100, 54301042,
            53780961, 53260901, 52870863, 52640844, 52380826, 50330731, 49320705, 47610718, 46640748, 46420758,
            46200770, 45990784, 45790800, 45590820, 45230868, 45060896, 43801212, 43361643, 43361747, 43772211,
            44142385, 46012782, 46692883, 47032919, 47783007, 47973026, 48193044, 48403058, 48633070, 49133090,
            49833111, 50093114, 50343111, 50583102, 50803088, 51353033, 51503014, 51622987,
            loop=true,
            r=0.6, g=0.6, b=1,
        }},
    },
    [27633461] = {
        label="{npc:222323:Sky-Captain Aerthin}, The Righteous Hammer",
        quest=82025,
        routes={{
            35122517, 37532340, 38032309, 38232293, 38592260, 38802244, 39042234, 39262227, 39752216, 40762205,
            40992205, 41222207, 41462214, 41682225, 41882242, 42072262, 42252287, 44342661, 44672758, 45072932,
            45313072, 45363110, 45413211, 45373392, 45353430, 45223538, 45153573, 45103646, 44883747, 44793784,
            44693816, 44563845, 44403871, 44223896, 43024079, 42844105, 41444245, 41234259, 40534295, 39834322,
            38184362, 37704364, 34284336, 33814327, 33594321, 32444276, 30744216, 30314186, 29874149, 28704021,
            28523996, 28043912, 27793851, 27703819, 27563751, 27503683, 27493611, 27533536, 27633461, 27783395,
            28113304, 28553216, 29583053, 32802690,
            loop=true,
            r=0.6, g=1, b=0.1,
        }},
    },
}, {
    achievement=40848, -- Treasures
    criteria=69700,
    atlas="Vehicle-Air-Occupied", scale=1.5,
    note="Find the ship on the route and talk to the captain",
})

-- Illusive Kobyss Lure (Treasures)
ns.RegisterPoints(ns.HALLOWFALL, {
    [55362720] = {label="{npc:215653:Kobyss Shadeshaper}: {item:225554:Sunless Lure}", inbag=225554},
    [47611854] = {label="{npc:213622:Murkfin Depthstalker}: {item:225558:Murkfin Lure}", inbag=225558},
    [50655037] = {label="{npc:215243:Hungering Shimmerfin}: {item:225559:Hungering Shimmerfin}", inbag=225559},
    [34965465] = {label="{npc:213406:Ragefin Necromancer}: {item:225560:Ragefin Necrostaff}", inbag=225560},
}, {
    achievement=40848, -- Treasures
    criteria=69696,
    quest=83299,
    atlas="Vehicle-TempleofKotmogu-CyanBall", scale=1.2,
    loot={{225641, toy=true}}, -- Illusive Kobyss Lure
    note="Gather and combine {item:225554:Sunless Lure}, {item:225558:Murkfin Lure}, {item:225559:Hungering Shimmerfin}, {item:225560:Ragefin Necrostaff}",
})

-- Biblo Archivist
ns.RegisterPoints(ns.HALLOWFALL, {
    [48153959] = {criteria=68954, quest=83314, loot={225212}, note="Needed for {achievement:40848.69695:Arathi Loremaster}"}, -- The Big Book of Arathi Idioms
    [43904997] = {criteria=68955, loot={225217}}, -- 500 Dishes Using Cave Fish and Mushrooms
    [69344394] = {criteria=68957, loot={225207}, note="Needed for {achievement:40848.69695:Arathi Loremaster}"}, -- Care and Feeding of the Imperial Lynx
    [68684159] = {criteria=68958, loot={225206}}, -- Light's Gambit Playbook
    [57815182] = {criteria=68960, loot={225208}, note="By the shore"}, -- From the Depths They Come
    [48756472] = {criteria=68961, quest=83309, loot={225216}, note="Needed for {achievement:40848.69695:Arathi Loremaster}", vignette=6374}, -- Palawltar's Codex of Dimensional Structure
    [64182812] = {criteria=68963, loot={225204}, note="Needed for {achievement:40848.69695:Arathi Loremaster}"}, -- Shadow Curfew Guidelines
    [59802203] = {criteria=68965, loot={225205}}, -- Shadow Curfew Journal
    [70225684] = {criteria=68967, loot={225215}, note="Needed for {achievement:40848.69695:Arathi Loremaster}"}, -- The Song of Renilash
    [56586518] = {criteria=68968, loot={225203}, note="In the ship. Needed for {achievement:40848.69695:Arathi Loremaster}"}, -- Beledar- The Emperor's Vision
    [52645999] = {criteria=69729, quest=84497, loot={228457}}, -- Lightspark Grade Book
}, {
    achievement=40622,
    texture=ns.atlas_texture("profession", {r=0, g=1, b=1}),
    minimap=true,
    level=73,
})

-- The Missing Lynx
ns.RegisterPoints(ns.HALLOWFALL, {
    [60426022] = {criteria=68975, npc=220720}, -- Magpie
    [42695387] = {criteria={68998, 68999},}, -- Evan + Emery
    [42255378] = {criteria={69000, 69010},}, -- Jinx + Gobbo
    [69274372] = {criteria={69001, 69002},}, -- Moog, Iggy
    [63302940] = {criteria=7, note="Light the lesser keyflame"}, -- Nightclaw
    [63262811] = {criteria=8, note="Light the blooming keyflame"}, -- Shadowpouncer
    [63792962] = {criteria=9, note="Light the blooming keyflame"}, -- Purrlock
    [61193054] = {criteria=10,}, -- Miral Murder-Mittens
    [64441857] = {criteria={11, 12},}, -- Fuzzy, Furball
    [61922081] = {criteria=13,}, -- Dander
}, {
    achievement=40625,
    atlas="WildBattlePet", color={r=0.75, g=1, b=0},
    minimap=true,
})

-- Flamegard's Hope
ns.RegisterPoints(ns.HALLOWFALL, {
    [43215177] = {
        achievement=20594,
        -- quest=79081, -- daily
        atlas="GreenCross", minimap=true,
        note="Use any healing ability on {npc:220225:Injured Soldier}, once a day.\nHealed today: {quest:79081:Tracking quest}",
    },
})

-- Lost and Found
local lostAndFound=function(data)
    return {
        achievement=40618,
        criteria=data.criteria,
        quest=data.quest,
        label=("{item:%d} to {npc:%d}"):format(data.item, data.npc),
        hide_before=ns.conditions.Item(data.item),
        atlas="QuestBlob",
    }
end
ns.RegisterPoints(ns.HALLOWFALL, {
    -- From Time Lost (80678)
    [65453223] = lostAndFound{item=219810, npc=215527, criteria=68932, quest=80681}, -- Broken Bracelet -> Keyrra Flamestonge
    [43285544] = lostAndFound{item=219809, npc=218486, criteria=68933, quest=80679}, -- Plush Lynx -> Phillip Taversil
    [43485173] = lostAndFound{item=219524, npc=217338, criteria=68934, quest=80680}, -- Tarnished Compass -> Grave Offering Location
    -- From Time Found (82810)
    [41643476] = lostAndFound{item=224266, npc=226051, criteria=68942, quest=82845}, -- Ivory Tinderbox -> Haverd Sunhart
    [42355500] = lostAndFound{item=224267, npc=213145, criteria=68943, quest=82846}, -- Dented Spear -> Auralia Steelstrike
    [43974971] = lostAndFound{item=224268, npc=217813, criteria=68945, quest=82849}, -- Filigreed Cleric -> Kiera Horth
    -- From Time Borrowed (82813)
    [43185018] = lostAndFound{item=224274, npc=220859, criteria=68935, quest=82815}, -- Sturdy Locket -> Amy Lychenstone (patrols)
    [69254383] = lostAndFound{item=224273, npc=217609, criteria=68937, quest=82832}, -- Wooden Figure -> Barahl Lynflayme
    [48423889] = lostAndFound{item=224272, npc=222813, criteria=68940, quest=82835}, -- Calcified Journal -> Lorel Ironglen
})

-- Mereldar Menace
ns.RegisterPoints(ns.HALLOWFALL, {
    [41895552] = {criteria={67121, 67122, 67123, 67124, 67125}}, -- Orphanage
    [42265254] = {criteria={67126, 67127, 67128}}, -- Training Ground
    [44245123] = {criteria={67129, 67130,}}, -- Steelstrike Residence
}, {
    achievement=40151,
    label="{achievement:40151:Mereldar Menace}",
    note="Find the tiny {npc:219916:Throw Rock Vehicle} on the ground",
    texture=ns.atlas_texture("Professions_Tracking_Ore", {r=1, g=0.5, b=1}),
    minimap=true,
})
ns.RegisterPoints(ns.HALLOWFALL, {
    -- From Orphanage
    [41845564] = {criteria=67121, note="From the Orphanage"}, -- Orphanage Window
    [42545551] = {criteria=67122, note="From the Orphanage"}, -- Notice Board
    [42455439] = {criteria=67123, note="From the Orphanage"}, -- Food Stall
    [42355491] = {criteria=67124, note="From the Orphanage"}, -- Fountain
    [42295439] = {criteria=67125, note="From the Orphanage"}, -- Spice Stall
    -- From Training Ground
    [42975268] = {criteria=67126, note="From the Training Ground"}, -- Light and Flame
    [43025235] = {criteria=67127, note="From the Training Ground"}, -- Lamplighter Doorway
    [41325296] = {criteria=67128, note="From the Training Ground"}, -- Barracks Doorway
    -- From Steelstrike Residence
    [43505078] = {criteria=67129, note="From the Steelstrike Residence"}, -- Holy Oil
    [44685177] = {criteria=67130, note="From the Steelstrike Residence"}, -- Airship Drafting Board
}, {
    achievement=40151,
    requires=ns.conditions.Vehicle(219916), -- Throwing Rock
    atlas="XMarksTheSpot",
    minimap=true, worldmap=false,
})

-- Rares

ns.RegisterPoints(ns.HALLOWFALL, {
    [23005922] = { label="Lytfang the Lost",
        criteria=69710,
        quest=81756, -- 84063
        npc=221534,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84063}),
            221207, -- Den Mother's Chestpiece
            221246, -- Fierce Beast Staff
            221251, -- Bestial Underground Cleaver
            221265, -- Charm of the Underground Beast
        },
        vignette=6145,
    },
    [63452859] = { label="Moth'ethk",
        criteria=69719,
        quest=82557, -- 84051
        npc=206203,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84051}),
            221240, -- Nerubian Stagshell Gouger
            221252, -- Nerubian Slayer's Claymore
            221263, -- Nerubian Venom-Tipped Dart
            223924, -- Chitin-Inscribed Vest
        },
        vignette=5958,
        note="Objective of {questname:76588}",
    },
    [44011639] = { label="The Perchfather",
        criteria=69711,
        quest=81791, -- 84064
        npc=221648,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84064}),
            221229, -- Perchfather's Cuffs
            221246, -- Fierce Beast Staff
            221247, -- Cavernous Critter Shooter
            221251, -- Bestial Underground Cleaver
            221265, -- Charm of the Underground Beast
        },
        vignette=6151,
    },
    [56466897] = { label="The Taskmaker",
        criteria=69708,
        quest=80009, -- 84061
        npc=218444,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84061}),
            221215, -- Taskmaster's Mining Cap
            221240, -- Nerubian Stagshell Gouger
            221252, -- Nerubian Slayer's Claymore
            221263, -- Nerubian Venom-Tipped Dart
        },
        vignette=6033,
    },
    [31205464] = { label="Grimslice",
        criteria=69706,
        quest=81761,
        npc=221551,
        loot={
            223397, -- Abyssal Hunter's Girdle
            223398, -- Abyssal Hunter's Sash
            223399, -- Abyssal Hunter's Chain
            223400, -- Abyssal Hunter's Cinch
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        routes={{
            31205464, 33235598, 32725814, 34135728, 34525751, 35085894, 35655746, 36495657, 36945464,
            36555280, 35625156, 35055029, 34555186, 34135204, 32725119, 33235334,
            r=0, g=1, b=1,
            loop=true,
        }},
        vignette=6146,
        note="Patrols clockwise",
    },
    [43622993] = { label="Strength of Beledar",
        criteria=69713,
        quest=81849, -- 84066
        npc=221690,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84066}),
            221216, -- Bruin Strength Legplates
            221246, -- Fierce Beast Staff
            221247, -- Cavernous Critter Shooter
            221251, -- Bestial Underground Cleaver
            221265, -- Charm of the Underground Beast
            221508, -- Pelt of Beledar's Strength
        },
        vignette=6153,
    },
    [57046436] = { label="Ixlorb the Spinner",
        criteria=69704,
        quest=80006,
        npc=218426,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
            223374, -- Nerubian Weaver's Gown
            223379, -- Nerubian Weaver's Chestplate
            223380, -- Nerubian Weaver's Chainmail
            223381, -- Nerubian Weaver's Vest
            223100, -- Pattern: Vambraces of Deepening Darkness
        },
        vignette=6032, -- Ixlorb the Weaver
    },
    [62401320] = { label="Murkspike",
        criteria=69728,
        quest=82565, -- 84060
        npc=220771,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84060}),
            221233, -- Deephunter's Bloody Hook
            221234, -- Tidal Pendant
            221248, -- Deep Terror Carver
            221255, -- Sharpened Scalepiercer
            223934, -- Makrura's Foreboding Legplates
        },
        vignette=6123,
        note="Objective of {questname:76588}",
    },
    [64663172] = { label="Deathpetal",
        criteria=69721,
        quest=82559, -- 84053
        npc=206184,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84053}),
            221250, -- Creeping Lasher Machete
            221253, -- Cultivator's Plant Puncher
            221264, -- Fungarian Mystic's Cluster
            223005, -- String of Fungal Fruits
            223927, -- Vinewrapped Leather Tunic
        },
        vignette=6078,
        note="Objective of {questname:76588}",
    },
    [72136436] = { label="Deepfiend Azellix",
        criteria=69703,
        quest=80011,
        npc=218458,
        loot={
            223393, -- Deepfiend Spaulders
            223394, -- Deepfiend Pauldrons
            223395, -- Deepfiend Shoulderpads
            223396, -- Deepfiend Shoulder Shells
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        vignette=6035,
    },
    [64051911] = { label="Duskshadow",
        criteria=69724,
        quest=82562, -- 84056
        npc=221179,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84056}),
            223918, -- Specter Stalker's Shotgun
            223919, -- Abducted Lawman's Gavel
            223936, -- Shadow Bog Trousers
        },
        vignette=6122,
        note="Objective of {questname:76588}",
    },
    [36807210] = { label="Funglour",
        criteria=69707,
        quest=81881,
        npc=221767,
        loot={
            223377, -- Ancient Fungarian's Fingerwrap
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        vignette=6157,
    },
    [35953546] = { label="Sir Alastair Purefire",
        criteria=69714,
        quest=81853, -- 84067
        npc=221708,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84067}),
            221241, -- Priestly Agent's Knife
            221245, -- Righteous Path Treads
        },
        vignette=6154,
    },
    [43410990] = { label="Horror of the Shallows",
        criteria=69712,
        quest=81836, -- 84065
        npc=221668,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84065}),
            221211, -- Grasp of the Shallows
            221233, -- Deephunter's Bloody Hook
            221234, -- Tidal Pendant
            221248, -- Deep Terror Carver
            221255, -- Sharpened Scalepiercer
        },
        vignette=6152,
        note="Very long patrol",
        routes={{
            43410990, 43870879, 44520774, 45250767, 45970726, 45540662, 44870677, 44270749, 43710858, 41631452,
            41391580, 41051714, 40501821, 39731909, 36652173, 33992545, 33422650, 32912763, 31783130, 30933154,
            29993162, 29123191, 28213204, 27343238, 26553287, 26513416, 26813550, 27983757, 28633853, 29403934,
            30173998, 30764092, 30984221, 30594339, 29814381, 27194486, 26364534, 25664611, 24954700, 23314830,
            23274858, 22464885, 20774968, 19904976, 19565105, 20285138, 20865040, 21614971, 22474926,
            r=0,g=0,b=1,
        }},
    },
    [73405259] = { label="Sloshmuck",
        criteria=69709,
        quest=79271, -- 84062
        npc=215805,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84062}),
            221223, -- Bog Beast Mantle
            221250, -- Creeping Lasher Machete
            221253, -- Cultivator's Plant Puncher
            221264, -- Fungarian Mystic's Cluster
            223005, -- String of Fungal Fruits
        },
        vignette=5988,
    },
    [52132682] = { label="Murkshade",
        criteria=69705,
        quest=80010,
        npc=218452,
        loot={
            223382, -- Murkshade Grips
            223383, -- Murkshade Handguards
            223384, -- Murkshade Gloves
            223385, -- Murkshade Gauntlets
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150),
        },
        vignette=6034,
        note="Underwater",
    },
    [67562316] = { label="Croakit",
        criteria=69722,
        quest=82560, -- 84054
        npc=214757,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84054}),
            221246, -- Fierce Beast Staff
            221247, -- Cavernous Critter Shooter
            221251, -- Bestial Underground Cleaver
            221265, -- Charm of the Underground Beast
            223938, -- Marsh Hopper's Spaulders
        },
        vignette=6125,
        --tameable=true, -- hopper
        note="Fish up 10x{item:211474:Shadowblind Grouper} and throw them to fill the {spell:437124:Craving} bar. Objective of {questname:76588}.",
    },
    [57304858] = { label="Pride of Beledar",
        criteria=69715,
        quest=81882, -- 84068
        npc=221786,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84068}),
            221225, -- Benevolent Hornstag Cinch
            221246, -- Fierce Beast Staff
            221247, -- Cavernous Critter Shooter
            221251, -- Bestial Underground Cleaver
            221265, -- Charm of the Underground Beast
            223007, -- Lance of Beledar's Pride
        },
        vignette=6159,
        -- tameable=true, -- stag
    },
    [67182424] = { label="Toadstomper",
        criteria=69723,
        quest=82561, -- 84055
        npc=207803,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84055}),
            223920, -- Slime Deflecting Stopper
            223921, -- Ever-Oozing Signet
            223933, -- Slime Goliath's Cap
        },
        vignette=6084,
        note="Objective of {questname:76588}",
    },
    [64802920] = { label="Crazed Cabbage Smacker",
        criteria=69720,
        quest=82558, -- 84052
        npc=206514,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84052}),
            211968, -- Blueprint Bundle
            221238, -- Pillar of Constructs
            223928, -- Crop Cutter's Gauntlets
            223935, -- Cabbage Harvester's Pantaloons
        },
        vignette=6120,
        note="Objective of {questname:76588}",
    },
    [60201860] = { label="Finclaw Bloodtide",
        criteria=69727,
        quest=82564, -- 84059
        npc=207780, -- also 220492, the mount
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84059}),
            221233, -- Deephunter's Bloody Hook
            221234, -- Tidal Pendant
            221248, -- Deep Terror Carver
            223925, -- Blood Hungerer's Chestplate
        },
        vignette=6085,
        note="Objective of {questname:76588}",
    },
    [62033212] = { label="Ravageant",
        criteria=69726,
        quest=82566, -- 84058
        npc=207826,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84058}),
            221240, -- Nerubian Stagshell Gouger
            221252, -- Nerubian Slayer's Claymore
            221263, -- Nerubian Venom-Tipped Dart
            223932, -- Scarab's Carapace Cap
        },
        vignette=6124,
        note="Objective of {questname:76588}",
    },
    [61623277] = { label="Parasidious",
        criteria=69725,
        quest=82563,
        npc=206977, -- Disturbed Dirt (206978) > Fungus Growth (206980) > Fungus Mound (206981) > Fungal Mass (206993) > Parasidious
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=84057}),
            221250, -- Creeping Lasher Machete
            221264, -- Fungarian Mystic's Cluster
            223005, -- String of Fungal Fruits
            223940, -- Deranged Fungarian's Epaulets
        },
        vignette=6361,
        note="Objective of {questname:76588}. Buy {item:206670:Darkroot Grippers} from {npc:206533:Chef Dinaire}, and use them to pull {npc:206870:Shadowrooted Vine} until this spawns.",
        related={
            [64403100] = {
                label="{npc:206533:Chef Dinaire}",
                loot={206670}, -- Darkroot Grippers
                atlas="banker", minimap=true,
                note="Feed the keyflame if he's not there",
            },
        },
    },
    -- UNKNOWN LOCATION
    --[[
    [] = { -- Brineslash
        criteria=69718,
        quest=80486,
        npc=220159,
        vignette=6075,
    },
    --]]
}, {
    achievement=40851,
})
-- Beledar's Spawn
ns.RegisterPoints(ns.HALLOWFALL, {
    [25825754] = {},
    [32673962] = {},
    [37207190] = {},
    [37744585] = {},
    [38382474] = {},
    [42733133] = {},
    [45252569] = {},
    [47015504] = {},
    [48853197] = {},
    [50514857] = {},
    [51427080] = {},
    [54833679] = {},
    [58034885] = {},
    [60451862] = {},
    [61380753] = {},
    [62823857] = {},
    [68123014] = {},
    [71976558] = {},
    [72804152] = {},
}, {
    achievement=40851,
    criteria=69716,
    quest=81763, -- 85164
    npc=207802,
    loot={
        ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=85164}),
        {223315, mount=2192,}, -- Beledar's Spawn
        223006, -- Signet of Dark Horizons
    },
    active={SHADOWPHASE},
    note="Spawns during the shadow event, which happens every 3 hours.\nBuy and use {item:224553:Beledar's Attunement} from {majorfaction:2570:Hallowfall Arathi} to see which spawn is active.",
    atlas="worldquest-icon-boss-zhCN",
    group="beledarspawn",
    vignette=6359, -- also 6118? That was the close-up one...
})

-- Deathtide
local deathtide = ns.nodeMaker{
    achievement=40851,
    criteria=69717,
    quest=81880,
    level=80, -- required to loot the offering/jar
}
ns.RegisterPoints(ns.HALLOWFALL, {
    [44744241] = { label="Deathtide",
        npc=221753,
        loot={
            ns.rewards.Currency(ns.CURRENCY_ARATHI, 150, {quest=85165}),
            223920, -- Slime Deflecting Stopper
            223921, -- Ever-Oozing Signet
            225997, -- Earthen Adventurer's Spaulders
        },
        vignette=6156,
        active=ns.conditions.Item(220123), -- Ominous Offering
        note="Create an {item:220123:Ominous Offering} from {item:220124:Jar of Mucus} (|A:playerpartyblip:::::0:255:127|a) + {item:220122} (|A:playerpartyblip:::::0:0:255|a) to summon",
        routes={
            -- water
            {28925120, 44744241, highlightOnly=true, _related=28925120},
            {34185782, 44744241, highlightOnly=true, _related=34185782},
            {34365357, 44744241, highlightOnly=true, _related=34365357},
            {43451413, 44744241, highlightOnly=true, _related=43451413},
            {50094966, 44744241, highlightOnly=true, _related=50094966},
            {53771913, 44744241, highlightOnly=true, _related=53771913},
            {55142344, 44744241, highlightOnly=true, _related=55142344},
            -- mucus
            {48001668, 44744241, highlightOnly=true, _related=48001668},
        },
    },
}, deathtide{})
ns.RegisterPoints(ns.HALLOWFALL, {
    -- Jar of Mucus
    [48001668] = {route=44744241},
}, deathtide{
    label="{item:220124}",
    loot={220124}, inbag={220124, 220123, any=true},
    texture=ns.atlas_texture("playerpartyblip",{r=0,g=1,b=0.5,}),
    minimap=true,
    note="Take to {npc:221753} @ 44.7,42.4",
})
ns.RegisterPoints(ns.HALLOWFALL, {
     -- Offering of Pure Water
    [28925120] = {route=44744241},
    [34185782] = {route=44744241},
    [34365357] = {route=44744241},
    [43451413] = {route=44744241},
    [50094966] = {route=44744241},
    [53771913] = {route=44744241},
    [55142344] = {route=44744241},
}, deathtide{
    label="{item:220122}",
    loot={220122}, inbag={220122, 220123, any=true},
    texture=ns.atlas_texture("playerpartyblip",{r=0,g=0,b=1,}),
    minimap=true,
    note="Take to {npc:221753} @ 44.7,42.4",
})


-- ns.RegisterPoints(ns.HALLOWFALL, {
--     [62650611] = { -- Radiant-Twisted Mycelium
--         quest=nil, -- confirmed, this has a vignette and is rare-flagged, but no quest or rep rewards
--         npc=214905,
--         vignette=5984,
--         note="Objective of {questname:76588}",
--         additional={61953305},
--     },
-- })

ns.RegisterPoints(ns.HALLOWFALL, {
    [72054154] = { label="Dissenter Troosilver",
        npc=241232,
        quest=91158,
        vignette=6884,
    },
})
