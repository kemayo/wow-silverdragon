local myname, ns = ...

local unbound = {
    achievement=12587,
    note="Available on a six week rotation with other {achievement:12587}",
    atlas="VignetteKillElite", scale=1.1,
}

ns.RegisterPoints(942, { -- Stormsong Valley
    [83204960] = { label="Warbringer Yenajz",
        quest=52166,
        worldquest=52166,
        criteria=40529,
        npc=140163,
        loot={
            161349, -- Amice of the Rending Abyss
            161351, -- Wristwraps of Warped Reality
            161353, -- Shadow-Wreathed Gloves
            161354, -- Leggings of the Endless Void
            161355, -- Yenajz's Chitinous Stompers
            161357, -- Spaulders of the Enveloping Maw
            161358, -- Existence-Shattering Gauntlets
            161359, -- Band of Intense Gravitation
            161376, -- Prism of Dark Intensity
        },
    },
}, unbound)

ns.RegisterPoints(896, { -- Drustvar
    [49207460] = { label="Hailstone Construct",
        quest=52157,
        worldquest=52157,
        criteria=40530,
        npc=140252,
        loot={
            161361, -- Ice-Rimed Slippers
            161362, -- Frostbreath Leggings
            161364, -- Chill's End Wristguards
            161366, -- Ice Stalker Boots
            161367, -- Hailstone Hauberk
            161368, -- Freezing Tempest Waistguard
            161370, -- Glacial Spike Gauntlets
            161372, -- Ice-Carved Shoulderplates
            161380, -- Drust-Runed Icicle
            161381, -- Permafrost-Encrusted Heart
            164386, -- Girdle of Biting Winds
            168141, -- Ice-Encased Ancient Blood Pigment
        },
    },
}, unbound)

ns.RegisterPoints(863, { -- Nazmir
    [35603360] = { label="T'zane",
        quest=52181,
        worldquest=52181,
        criteria=40531,
        npc=132701,
        loot={
            161387, -- Wailing Terror Leggings
            161389, -- Cinch of All-Consuming Death
            161391, -- Deathshambler's Shoulderpads
            161392, -- Bindings of Eternal Fears
            161393, -- Legguards of the Barkbound Dead
            161395, -- Swampwalker's Soul-Treads
            161396, -- Petrified Mask of the Afterlife
            161397, -- Soulplank Vambraces
            161411, -- T'zane's Barkspines
            161412, -- Spiritbound Voodoo Burl
            164383, -- Death Devouring Girdle
        },
    },
}, unbound)

ns.RegisterPoints(862, { -- Zuldazar
    [69003100] = { label="Ji'arak",
        quest=52169,
        worldquest=52169,
        criteria=40532,
        npc=132253,
        loot={
            161371, -- Galebreaker's Sabatons
            161388, -- Gloves of Enveloping Winds
            161390, -- Savage Terrorwing Leggings
            161394, -- Hurricane Cinch
            161401, -- Matriarch's Shadowveil
            161403, -- Avian Clutch Belt
            161407, -- Windshear Leggings
            161409, -- Stormcrash Chestguard
            164384, -- Windswept Dinorider's Cape
        },
    },
}, unbound)

ns.RegisterPoints(864, { -- Voldun
    [43805560] = { label="Dunegorger Kraulok",
        npc=138794,
        quest=52196,
        worldquest=52196,
        criteria=40533,
        loot={
            161399, -- Cord of Flowing Sands
            161400, -- Raider's Shrouding Thobe
            161402, -- Gloves of the Desert Assassin
            161404, -- Hood of the Sinuous Devilsaur
            161405, -- Dunegorger's Grips
            161408, -- Sandswept Legionnaire's Legplates
            161419, -- Kraulok's Claw
            164385, -- Desert Nomad's Wrap
            {174842, mount=1250}, -- Slightly Damp Pile of Fur (Mollie)
        },
    },
}, unbound)

ns.RegisterPoints(895, { --  Tiragarde Sound
    [62002400] = { label="Azurethos",
        quest=52163,
        worldquest=52163,
        criteria=40534,
        npc=136385,
        loot={
            161350, -- Windcaller's Down Handwraps
            161352, -- Chestguard of Dire Winds
            161356, -- Feathered Galeforce Crest
            161360, -- Roost-Defender's Legguards
            161363, -- Sandals of Rustling Rage
            161365, -- Footpads of the Encircling Storm
            161369, -- Bindings of the Winged Typhoon
            161377, -- Azurethos' Singed Plumage
            161378, -- Plume of the Seaborne Avian
            161379, -- Galecaller's Beak
            161398, -- Talonscored Azure Vambraces
        },
    },
}, unbound)
