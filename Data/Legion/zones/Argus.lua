local myname, ns = ...

--[[
invasion point: Val, poi 5360, quest 49210
invasion point: Sangua, poi 5369, quest 49212
--]]

ns.RegisterVignettes(905, { -- Argus
    [2284] = { label="Matron Folnuna",
        areaPoi=5381,
        quest=nil,
        criteria=37452,
        npc=124514,
        loot={
            152053, -- Essence of the Burgeoning Brood
            152346, -- Frigid Earring
            152349, -- Nefarious Light-Step Slippers
            152354, -- Accursed Defiler's Mantle
            152356, -- Fel-Absorbant Wristbands
            152358, -- Imp-Overseer's Vest
            152359, -- Vile Drifter's Footpads
            152360, -- Gloves of Barbarous Feats
            152369, -- Helm of the Vigilant Eye
            152371, -- Shoulderguards of the Despondent Masses
            152372, -- Waistguard of Devilish Deeds
            152375, -- Gauntlets of Barbaric Cruelty
            152376, -- Crown of Burning Resolve
            152380, -- Waistguard of Fel Magics
        },
    },
    [2287] = { label="Mistress Alluradel",
        areaPoi=5375,
        quest=nil,
        criteria=37454,
        npc=124625,
        loot={
            152030, -- Scourge of Perverse Desire
            152294, -- Fel Mistress' Brand
            152349, -- Nefarious Light-Step Slippers
            152351, -- Mesmerizing Soul Hood
            152354, -- Accursed Defiler's Mantle
            152362, -- Leggings of Heinous Acts
            152363, -- Fel-Spike Shoulderpads
            152364, -- Cinch of Detestable Guile
            152366, -- Enthralling Chain Armor
            152372, -- Waistguard of Devilish Deeds
            152373, -- Poison-Barbed Bracers
            152374, -- Soul Crushing Stompers
            152378, -- Breastplate of Terminal End
            152379, -- Spaulders of Vile Determination
        },
    },
    [2286] = { label="Inquisitor Meto",
        areaPoi=5379,
        quest=49170,
        criteria=37453,
        npc=124592,
        loot={
            152290, -- Censer of Dark Intent
            152344, -- Meto's Orb of Entropy
            152349, -- Nefarious Light-Step Slippers
            152350, -- Gloves of Grim Direction
            152353, -- Robes of Demonic Purpose
            152359, -- Vile Drifter's Footpads
            152361, -- Horned Hood of Retaliation
            152364, -- Cinch of Detestable Guile
            152368, -- Fel-Linked Crushers
            152370, -- Legguards of Doomed Chattel
            152371, -- Shoulderguards of the Despondent Masses
            152378, -- Breastplate of Terminal End
            152380, -- Waistguard of Fel Magics
            152381, -- Tainted Corruptor's Vambraces
        },
    },
    [2283] = { label="Occularus",
        areaPoi=5376,
        quest=nil,
        criteria=37450,
        npc=124492,
        loot={
            152347, -- Occularus' Unblemished Lens
            152351, -- Mesmerizing Soul Hood
            152354, -- Accursed Defiler's Mantle
            152355, -- Sash of Diabolic Preparation
            152358, -- Imp-Overseer's Vest
            152360, -- Gloves of Barbarous Feats
            152367, -- Sabatons of Ceaseless Assault
            152369, -- Helm of the Vigilant Eye
            152373, -- Poison-Barbed Bracers
            152374, -- Soul Crushing Stompers
            152377, -- Gore-Soaked Legplates
            152381, -- Tainted Corruptor's Vambraces
        },
    },
    [2285] = { label="Sotanathor",
        areaPoi=5380,
        quest=nil,
        criteria=37451,
        npc=124555,
        loot={
            152292, -- Spike of Immortal Command
            152348, -- Sotanathor's Thundering Hoof
            152350, -- Gloves of Grim Direction
            152352, -- Subjugated Drudge's Leggings
            152353, -- Robes of Demonic Purpose
            152361, -- Horned Hood of Retaliation
            152362, -- Leggings of Heinous Acts
            152365, -- Bracers of Diabolic Fury
            152366, -- Enthralling Chain Armor
            152368, -- Fel-Linked Crushers
            152372, -- Waistguard of Devilish Deeds
            152375, -- Gauntlets of Barbaric Cruelty
            152377, -- Gore-Soaked Legplates
            152379, -- Spaulders of Vile Determination
        },
    },
    [2288] = { label="Pit Lord Vilemus",
        areaPoi=5377,
        quest=49168,
        criteria=37455,
        npc=124719,
        loot={
            152345, -- Vilemus' Bile
            152352, -- Subjugated Drudge's Leggings
            152355, -- Sash of Diabolic Preparation
            152356, -- Fel-Absorbant Wristbands
            152360, -- Gloves of Barbarous Feats
            152363, -- Fel-Spike Shoulderpads
            152365, -- Bracers of Diabolic Fury
            152367, -- Sabatons of Ceaseless Assault
            152368, -- Fel-Linked Crushers
            152370, -- Legguards of Doomed Chattel
            152374, -- Soul Crushing Stompers
            152376, -- Crown of Burning Resolve
            152378, -- Breastplate of Terminal End
        },
    },
}, {
    achievement=12026, -- Invasion Obliteration
})