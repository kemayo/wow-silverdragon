local myname, ns = ...

ns.RegisterPoints(942, { -- Stormsong Valley
    [66901200] = {quest=51449, criteria=41061,}, -- Weathered Treasure Chest
    [42854723] = {quest=50089, criteria=41062, note="In cave",}, -- Old Ironbound Chest
    [48968407] = {quest=50526, criteria=41063,}, -- Frosty Treasure Chest
    [67224321] = {quest=50734, criteria=41064, note="Under ship",}, -- Sunken Strongbox
    [59913907] = {quest=50937, criteria=41065, note="On roof",}, -- Hidden Scholar's Chest
    [58608388] = {quest=49811, criteria=41066, note="Under platform",}, -- Smuggler's Stash
    [58216368] = {quest=52326, criteria=41067, note="Top shelf inside shed",}, -- Discarded Lunchbox
    [44447353] = {quest=52429, loot={162000}, criteria=41068, note="Jump down onto platform",}, -- Carved Wooden Chest
    [36692323] = {quest=52976, criteria=41069, note="Climb ladder onto ship",}, -- Venture Co. Supply Chest
    [46003069] = {quest=52980, criteria=41070, note="Behind pillar",}, -- Forgotten Chest
}, {
    achievement=12853,
})
ns.RegisterPoints(1183, { -- Thornheart
    [60804121] = {quest=52429, loot={162000}, achievement=12853, criteria=41068, note="Jump down from here",}, -- Carved Wooden chest
})

-- These Hills Sing
ns.RegisterPoints(942, { -- Stormsong Valley
    [41256950] = {achievement=13046, atlas="Food", minimap=true, note="Open an Unforgettable Luncheon here; buy them at the Inn, or loot one from the Discarded Lunchbox in Brennadam",},
})

-- Legends of the Tidesages
ns.RegisterPoints(942, { -- Stormsong Valley
    [49518090] = {criteria=41425,}, -- Part 1 (Near the waterfall)
    [59025954] = {criteria=41426,}, -- Part 2 (On top of the hill)
    [31957291] = {criteria=41427,}, -- Part 3 (Near the lake)
    [33813323] = {criteria=41428,}, -- Part 4 (On top of the island)
    [56023853] = {criteria=41429,}, -- Part 5 (Up the mountain right of Warfang Hold)
    [44183660] = {criteria=41430,}, -- Part 6 (Up the mountain left of Warfang Hold)
    [62083022] = {criteria=41431,}, -- Part 7
    [75073113] = {criteria=41432,}, -- Part 8 (Near the Shrine of the Storm entrance)
}, {
    achievement=13051,
    atlas="poi-workorders",
    minimap=true,
})

-- junk
ns.RegisterPoints(942, { -- Stormsong Valley
    [66567107] = {quest=50576, loot={154476}, label="Honey Vat", note="Strangely, not part of the achievement",},
    [32126620] = {quest=53635, label="Curious Grain Sack",},
    [32946967] = {quest=53652, label="Curious Grain Sack",},
    [62056563] = {quest=51184,},
    [51796523] = {quest=51184,},
    [70265958] = {quest=51927,},
    [75103513] = {quest=51938,},
    [64366899] = {quest=51939,},
    [68067158] = {quest=51939, note="In a bush",},
    [48406562] = {quest=51940,},
    [44107300] = {quest=51942,},
    [29776948] = {quest=51943,},
    [29985150] = {quest=51944,},
    [36272737] = {quest=51945,},
    [57645092] = {quest=51946,},
    [60865118] = {quest=51946,},
    [46915393] = {quest=51949,},
}, {
    label='Small Treasure Chest',
    group="junk",
})

-- Rares

-- Adventurer of Stormsong Valley
ns.RegisterPoints(942, { -- Stormsong Valley
    [71003200] = {quest=52448, npc=141175, loot={158218}, criteria=41753}, -- Song Mistress Dadalea
    [22607300] = {quest=50938, npc=140997, loot={163679}, criteria=41754}, -- Severus the Outcast
    [33603800] = {quest=51757, npc=138938, loot={160477}, criteria=41755}, -- Seabreaker Skoloth
    [34203240] = {quest=51956, npc=139328, loot={154664}, criteria=41756}, -- Sabertron
    [51807960] = {quest=50974, npc=136189, loot={155222}, criteria=41757}, -- The Lichen King
    [41607360] = {quest=50725, npc=134884, loot={160465}, criteria=41758}, -- Ragna
    [41302920] = {quest=51958, npc=139319, loot={158216}, criteria=41759}, -- Slickspill
    [29206960] = {quest=51298, npc=137025, loot={160470}, criteria=41760}, -- Broodmother
    [71305430] = {quest=50075, npc=132007, loot={155568}, criteria=41761}, -- Galestorm
    [47004220] = {quest=52457, npc=142088, loot={158215}, criteria=41762}, -- Whirlwing
    [31406260] = {quest=52318, npc=141029, loot={154475}, criteria=41763}, -- Kickers
    [64406560] = {quest=49951, npc=131404, loot={160471}, criteria=41765}, -- Foreman Scripps
    [34406760] = {quest=52469, npc=141286, loot={{163036, count=10}}, criteria=41769}, -- Poacher Zane
    [37905040] = {quest=51959, npc=139298, loot={163678}, criteria=41772}, -- Pinku'shon
    [62007340] = {quest=52329, npc=141059, loot={155572}, criteria=41774}, -- Grimscowl the Harebrained
    [53005200] = {quest=50692, npc=139385, loot={160464}, criteria=41775}, -- Deepfang
    [63003300] = {quest=52303, npc=140938, loot={154460}, criteria=41776}, -- Croaker
    [66905200] = {quest=52121, npc=139968, loot={154183}, criteria=41777}, -- Corrupted Tideskipper (also i:162028)
    [51405540] = {quest=52466, npc=136183, loot={154857}, criteria=41778}, -- Crushtacean
    [67804000] = {quest=50731, npc=134897, loot={160476}, criteria=43470}, -- Dagrus the Scorned
    [49807000] = {quest=50037, npc=135939, loot={158299}, criteria=41782}, -- Vinespeaker Ratha
    [53106910] = {quest=50024, npc=135947, criteria=41787,}, -- Strange Mushroom Ring
    [33607500] = {quest=52460, npc=141226, loot={154273}, criteria=41815}, -- Haegol the Hammer
    [57007580] = {quest=52433, npc=141088, loot={158224}, criteria=41816}, -- Squall
    [63408320] = {quest=52327, npc=141039, loot={154464}, criteria=41817}, -- Ice Sickle
    [47206580] = {quest=50170, npc=130897, loot={155287}, criteria=41818}, -- Captain Razorspine
    [47306590] = {quest=52296, npc=129803, criteria=41841, note="Requires a world quest to be up",}, -- Whiplash
    [61605700] = {quest=52441, npc=141143, loot={155164}, criteria=41842}, -- Sister Absinthe
    [42807500] = {quest=50819, npc=130079, loot={154431}, criteria=41843}, -- Wagga Snarltusk
    [43404490] = {quest=51762, npc=138963, loot={160458}, criteria=41844}, -- Nestmother Acada
    [42006280] = {quest=52461, npc=141239, loot={159169}, criteria=41845}, -- Osca the Bloodied
    [73806080] = {quest=52125, npc=139988, loot={154389}, criteria=41846}, -- Sandfang
    [60004600] = {quest=52123, npc=139980, loot={154449}, criteria=41847}, -- Taja the Tidehowler
    [53406450] = {quest=52323, npc=140925, loot={154453}, criteria=34, faction="Horde"}, -- Doc Marrtens
    [53416451] = {quest=52324, npc=141043, loot={159179}, criteria=34, faction="Alliance", note="Talk to Doc Marrtens"}, -- Jakala the Cruel
}, {achievement=12940,})

-- Adherent of the Abyss
local adherent = {
    npc=140474,
    loot={
        {161479, mount=1057}
    },
    atlas="stablemaster", scale=1.2,
    notes="Needs 20 Abyssal Fragments to summon. They're *very* rare drops, so you may want to just buy them on the AH",
}
ns.RegisterPoints(942, {
    [46463606] = adherent,
})
ns.RegisterPoints(1182, {
    [59365421] = adherent,
})

-- world quest rares
-- [72545052] = {quest=nil, npc=139515,}, -- Sandscour
-- [68745147] = {quest=nil, npc=132047,}, -- Reinforced Hullbreaker
-- [40143732] = {quest=nil, npc=137649,}, -- Pest Remover Mk. II
-- [67217525] = {quest=nil, npc=134147,}, -- Beehemoth

-- Honey:
ns.RegisterPoints(942, {
    [59401700] = { label="Honey Smasher",
        quest=57674,
        npc=154154,
        loot={
            {172493,pet=2794},
            {172405, class="SHAMAN"},
        },
    },
})
ns.RegisterPoints(942, {
    [25677331] = {},
    [33423284] = {},
    [40936214] = {},
    [43003300] = {},
    [47333217] = {},
    [57185121] = {},
    [61843091] = {},
    [62922125] = {},
    [66217000] = {},
    [69007000] = {},
    [72295224] = {},
}, {
    npc=155069,
    active={ns.conditions.QuestIncomplete(56414)}, -- hourly
    note="You can loot the Jelly hourly",
    atlas="bags-icon-scrappable",
    faction="Alliance",
})
