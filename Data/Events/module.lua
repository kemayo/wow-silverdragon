if LE_EXPANSION_LEVEL_CURRENT <= LE_EXPANSION_CATACLYSM then return end

-- DO NOT EDIT THIS FILE; run dataminer.lua to regenerate.
local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

-- local ANNIVERSARY = core.conditions.CalendarEvent(1500) -- this needs to be updated each year...
local ANNIVERSARY = core.conditions.CalendarEventStartTexture(6238552)
local GREEDY = core.conditions.AuraActive(1250685) -- core.conditions.CalendarEvent(1382)

core:RegisterMobData("Events", {
    -- Anniversary
    [121818] = {name="Lord Kazzak",locations={[17]={33804860},},loot={150379,150380,150381,150382,150383,150384,150385,150386,150426,150427},quest=47461,vignette=6661,requires=ANNIVERSARY,},
    [121820] = {name="Azuregos",locations={[76]={49608260},},loot={150417,150419,150421,150422,150423,150424,150425,150428,150543,150544,150545},quest=47462,vignette=6660,requires=ANNIVERSARY,},
    [121821] = {name="Lethon",locations={[26]={63602860},},loot={150398,150399,150400,150401,150402,150407,150429,150408,150403,150412,150393,150388,150411},quest=47463,vignette=6662,requires=ANNIVERSARY,},
    [121911] = {name="Taerar",locations={[63]={93904060},},loot={150390,150392,150394,150395,150413,150414,150429,150408,150403,150412,150393,150388,150411},quest=47463,vignette=6664,requires=ANNIVERSARY,},
    [121912] = {name="Ysondre",locations={[69]={51201160},},loot={150387,150389,150391,150396,150397,150409,150429,150408,150403,150412,150393,150388,150411},quest=47463,vignette=6665,requires=ANNIVERSARY,},
    [121913] = {name="Emeriss",locations={[47]={46603940},},loot={150404,150405,150406,150410,150415,150416,150429,150408,150403,150412,150393,150388,150411},quest=47463,vignette=6663,requires=ANNIVERSARY,},
    [167749] = {name="Doomwalker",locations={[71]={58728463}},requires=ANNIVERSARY,vignette=6520,
        quest=60214, -- 85723?
        loot={
            {186469,mount=293,}, -- Illidari Doomhawk
            {208572,mount=1798,}, -- Azure Worldchiller
            {186501,toy=true,}, -- Doomwalker Trophy Stand
            186459, -- Archaic Charm of Presence
            186460, -- Anger-Spark Gloves
            186461, -- Gilded Trousers of Benediction
            186462, -- Black-Iron Battlecloak
            186463, -- Terrorweave Tunic
            186464, -- Fathom-Helm of the Deeps
            186465, -- Faceguard of the Endless Watch
            186466, -- Ethereum Nexus-Reaver
            186467, -- Barrel-Blade Longrifle
            186468, -- Talon of the Tempest
            186475, -- Hellstitched Mantle
            186481, -- Darkcrest Waistguard
            186484, -- Voidforged Greaves
            186506, -- Akama's Edge
        },
    },
    [226646] = {name="Sha of Anger",locations={[71]={33715571}},quest=84282,requires=ANNIVERSARY,vignette=6519,
        loot={},
    },
    [227257] = {name="Archavon the Stonewatcher",locations={[71]={45992897}},requires=ANNIVERSARY,vignette=6518,
        quest=84256, -- 84312?
        loot={},
    },

    -- Greedy Emissary
    [205490] = {
        name="Treasure Goblin",
        locations={
            [84] = {33833434}, -- Stormwind
            -- [85] = {}, -- Orgrimmar
            [1] = {44041934}, -- Durotar
            [2339] = {69879162}, -- Dornogal
            [2248] = {54575484}, -- Isle of Dorn
            [2346] = {}, -- Undermine (any rare)
        },
        loot={
            {245589,quest=91170}, -- Hellcaller Chest (91079, 91080, 91081, 91082, 91083, 91166, 91167, 91168, 91169, 91170, )
            {246264,mount=true,}, -- Inarius' Charger
            {142542,toy=true,}, -- Tome of Town Portal
            {206008,toy=true,}, -- Nightmare Banner
            {206018,pet=true,}, -- Baa'lial Soulstone
            206007, -- Treasure Nabbin' Bag
            246242, -- Blood-Wrapped Treasure Bag
            -- 206039, -- Enmity Bundle:
            206004, -- Enmity Cloak (Bundle)
            206020, -- Enmity Hood (Bundle)
            206005, -- Wirt's Fightin' Leg
            206275, -- Wirt's Haunted Leg
            206276, -- Wirt's Last Leg
            143327, -- Livestock Lochaber Axe
            206003, -- Horadric Haversack (quest=76215?)
            --[[
            245635, -- Rich Elixir
            245636, -- Deafening Elixir
            245749, -- Large Charm of Intelligence
            245887, -- Stalwart's Grand Charm
            245888, -- Serpent's Grand Charm
            245889, -- Large Charm of Dexterity
            245890, -- Large Charm of Strength
            245891, -- Small Charm of Inertia
            245892, -- Small Charm of Life
            245893, -- Small Charm of Alacrity
            245894, -- Small Charm of Proficiency
            245895, -- Small Charm of Savagery
            245896, -- Small Charm of Adaptability
            245899, -- Bat's Grand Charm
            245924, -- Mongoose's Grand Charm
            --]]
        },
        -- quest=76215, 76216, 91091, 91092
        vignette={
            5732, -- Treasure Goblin
            5748, -- Shrouded Portal
            6983, -- Maggot City Portal
            6984, -- Frigid Frostlands Portal
            6985, -- Lava Labrynth Portal,
            6986, -- Poison Forest Portal
            6987, -- Blood Circus Portal
        },
        requires=GREEDY,
        -- notes="First daily kill quest: {quest:}",
    },
}, true)
