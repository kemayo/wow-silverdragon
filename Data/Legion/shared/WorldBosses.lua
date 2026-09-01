local myname, ns = ...

local boss = {
    group="worldboss",
    achievement=11160, -- Unleashed Monstrosities
}

ns.RegisterPoints(ns.SURAMAR, {
    [31006580] = { label="Ana-Mouz",
        criteria=32100, 
        quest=44501,
        worldquest=43512,
        npc=109943,
        loot={
            137778, -- Vantus Rune Technique: Tichondrius
            141413, -- Low-Cut Chestplate
            141419, -- Skimpy Demonleather Tunic
            141423, -- Crop Top Chain Hauberk
            141427, -- Sheer Felthreaded Robe
            141448, -- Imp Mother's Loincloth
            141486, -- Demonic Birthstone Ring
        },
    },
}, boss)
ns.RegisterPoints(685, { -- Falanaar Tunnels, Suramar
    [36606700] = { label="Na'zak the Fiend",
        criteria=32097,
        quest=nil,
        worldquest=43513,
        npc=110321,
        loot={
            141417, -- Desiccated Leather Pants
            141488, -- Mana-Dowsing Ring
            141534, -- Loop of Polished Pebbles
            141415, -- nazaks-dusty-pantaloons
            141421, -- venomscarred-chain-leggings
            141425, -- avalanche-resistant-legplates
            141515, -- leystone-nugget
            142121, -- recipe-potion-of-prolonged-power
        },
        parent=true,
    },
}, boss)

ns.RegisterPoints(ns.STORMHEIM, {
    [46603000] = { label="Nithogg",
        criteria=32096,
        qquest=44508,
        worldquest=42270, -- Scourge of the Skies
        npc=107544,
        loot={
            {140658, class="WARRIOR"}, -- Skull of Nithogg
            141414, -- Hood of Scorned Brood
            141418, -- Helm of the Mountain Recluse
            141420, -- Coif of Unstable Discharge
            141424, -- Stormbattered Casque
            141519, -- Pillaged Titan Disc
            141541, -- Windwhipped Greatcloak
            141546, -- Cursed Warden's Keepsake
        },
    },
    [77800780] = { label="Soultrapper Mevra, Soultakers",
        criteria=8,
        quest=nil,
        worldquest=42269, -- The Soultakers
        npc=106984,
        loot={
            {139547, class="DEATHKNIGHT"}, -- Runes of the Darkening
            141434, -- Cord of Kept Souls
            141436, -- Helchain Waistguard
            141506, -- Soultrapper's Pendant
            141444, -- hel-cursed-belt
            141442, -- sea-reavers-girdle
            141514, -- barnacled-mistcaller-orb
            141537, -- thrice-accursed-compass
        },
    },
}, boss)

ns.RegisterPoints(ns.AZSUNA, {
    [38008440] = { label="Calamir (also 56606660?)",
        criteria=32101,
        quest=nil,
        worldquest=43193, -- Calamitous Intent
        npc=109331,
        loot={
            137847, -- Design: Sorcerous Shadowruby Pendant
            141430, -- Mana-Tanned Sandals
            141432, -- Frostburned Sabatons
            141437, -- Warboots of Smoldering Fury
            141438, -- Pendant of Cold Flame
            141443, -- Sandals of Frozen Ash
            141522, -- Calamir's Jaw
            141533, -- Ring of Frozen Magic
        },
    },
    [43006740] = { label="Levantus",
        criteria=32102,
        quest=nil,
        worldquest=43192, -- Terror of the Deep
        npc=108829,
        loot={
            {139573, class="SHAMAN"}, -- The Warmace of Shirvallah
            141431, -- Hook-Fingered Gauntlets
            141435, -- Whirlpool Gloves
            141440, -- Seaweed "Leather" Mitts
            141441, -- Chum-Chopper Gauntlets
            141473, -- Krakentooth Necklace
            141523, -- Fel-Scented Bait
            141545, -- Ring of Deep Sea Pearls
            142109, -- Vantus Rune Technique: Helya
        },
    },
    [52408040] = { label="Withered J'im",
        criteria=35022,
        quest=nil,
        worldquest=44287, -- DEADLY: Withered J'im
        npc=112350,
        loot={
            141449, -- Mana Scavenger's Mask
            141453, -- Magic-Warped Hood
            141455, -- Cave Skulker's Helm
            141459, -- Manacrystal-Adorned Helmet
            141482, -- Unstable Arcanocrystal
            141492, -- Dingy Suramar Mercantile Signet
            141543, -- Drape of the Mana-Starved
        },
    },
}, boss)

ns.RegisterPoints(ns.HIGHMOUNTAIN, {
    [58207140] = { label="Drugon the Frostblood",
        criteria=32094,
        quest=44503,
        worldquest=43448, -- The Frozen King
        npc=110378,
        loot={
            141428, -- Snowdrift Bracers
            141429, -- Wax-Sealed Leather Bracers
            141433, -- Assorted Dragonscale Bracers
            141439, -- Ettinbone Bracers
            141517, -- Drugon's Snowglobe
            141535, -- Ettin Fingernail
            141538, -- Giant's Handkerchief
            142108, -- Vantus Rune Technique: Guarm
        },
    },
    [49200740] = { label="Flotsam",
        criteria=32095,
        quest=41126,
        worldquest=43985, -- A Dark Tide
        npc=99929,
        loot={
            {139573, class="SHAMAN"}, -- The Warmace of Shirvallah
            141466, -- Blackwater Raider Handguards
            141470, -- Faded Bloodsail Handwraps
            141475, -- Salt-Stained Tuskarr Gloves
            141476, -- Kezan Pirate's Mitts
            141516, -- "Liberated" Un'goro Relic
            141539, -- Ragged Azsharan Sail Fragment
            141544, -- Marshstomper Oracle's Loop
        },
    },
}, boss)

ns.RegisterPoints(ns.VALSHARAH, {
    [24406940] = { label="Humongris",
        criteria=32099,
        quest=42819,
        worldquest=42819, -- Pocket Wizard
        npc=108879,
        loot={
            139895, -- Skinning Technique: Legion Butchery
            141416, -- Padawsen's Squished Pauldrons
            141422, -- Shoulderguards of Unimaginative Magic
            141426, -- Shoulderplates of Oversized Sorcery
            141445, -- Mantle of the Aspiring Spellgiant
            141521, -- Sea Giant Toothpick Fragment
            141536, -- Padawsen's Unlucky Charm
            141540, -- Coerced Wizard's Cloak
        },
    },
    [55404240] = { label="Shar'thos",
        criteria=32098,
        quest=nil,
        worldquest=42779,
        npc=108678,
        loot={
            {140659, class="WARRIOR"}, -- Skull of Shar'thos
            141481, -- Chestplate of Blackened Emeralds
            141487, -- Raiments of Waking Nightmares
            141495, -- Robe of Fever Dreams
            141518, -- Decaying Dragonfang
            141542, -- Despoiled Dreamthread Cloak
            141547, -- Choker of Dreamthorns
            141491, -- hauberk-of-the-snarled-vale
        },
    },
}, boss)
