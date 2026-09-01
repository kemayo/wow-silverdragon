local myname, ns = ...

ns.RegisterPoints(550, { -- NagrandDraenor
    -- steamwheedle supplies
    [50108220]={quest=35577, loot={ns.rewards.Currency(824)}, label="Steamwheedle Supplies", note="Use a glider"},
    [52708010]={quest=35583, loot={ns.rewards.Currency(824)}, label="Steamwheedle Supplies", note="Use a glider"},
    [64601760]={quest=35648, loot={ns.rewards.Currency(824)}, label="Steamwheedle Supplies", note="Use a glider"},
    [70601860]={quest=35646, loot={ns.rewards.Currency(824)}, label="Steamwheedle Supplies", note="Use a glider"},
    [77805190]={quest=35591, loot={ns.rewards.Currency(824)}, label="Steamwheedle Supplies", note="Use a glider"},
    [87602030]={quest=35662, loot={ns.rewards.Currency(824)}, label="Steamwheedle Supplies", note="Use a glider"},
    [88204260]={quest=35616, loot={ns.rewards.Currency(824)}, label="Steamwheedle Supplies", note="Use a glider"},
    -- glider-required
    [70501390]={quest=35643, loot={ns.rewards.Currency(824)}, label="Mountain Climber's Pack", note="Use a glider"},
    [73007040]={quest=35678, loot={ns.rewards.Currency(824)}, label="Warsong Lockbox", note="Use a glider"},
    [76107000]={quest=35682, loot={118678}, label="Warsong Spear, use a glider"},
    [80606060]={quest=35593, loot={ns.rewards.Currency(824)}, label="Warsong Spoils", note="Use a glider"},
    [81103720]={quest=35661, loot={118262}, label="Brilliant Dreampetal, use a glider"},
    [87504500]={quest=35622, loot={ns.rewards.Currency(824)}, label="Hidden Stash", note="Use a glider"},
    [88901820]={quest=35660, loot={ns.rewards.Currency(824)}, label="Fungus-Covered Chest", note="Use a glider"},
    -- generic garrison supplies
    [37707060]={quest=34760, loot={ns.rewards.Currency(824)}, label="Treasure of Kull'krosh"},
    [43305750]={quest=35987, loot={ns.rewards.Currency(824)}, label="Genedar Debris"},
    [44606750]={quest=36002, loot={ns.rewards.Currency(824)}, label="Genedar Debris"},
    [47207430]={quest=35576, loot={ns.rewards.Currency(824)}, label="Goblin Pack"},
    [48006010]={quest=35999, loot={ns.rewards.Currency(824)}, label="Genedar Debris"},
    [48607270]={quest=36008, loot={ns.rewards.Currency(824)}, label="Genedar Debris"},
    [51706030]={quest=35695, loot={ns.rewards.Currency(824)}, label="Warsong Cache"},
    [55306820]={quest=36011, loot={ns.rewards.Currency(824)}, label="Genedar Debris"},
    [56607290]={quest=36050, loot={ns.rewards.Currency(824)}, label="Adventurer's Pouch"},
    [73001090]={quest=35951, loot={ns.rewards.Currency(824)}, label="A Pile of Dirt", note="Jump down"},
    [73006220]={quest=35590, loot={ns.rewards.Currency(824)}, label="Goblin Pack"},
    [73107550]={quest=35673, loot={ns.rewards.Currency(824)}, label="Appropriated Warsong Supplies"},
    [77101660]={quest=36174, loot={ns.rewards.Currency(824)}, label="Bounty of the Elements", note="Cave, use the Elemental Stones for access"},
    [89103310]={quest=36857, loot={ns.rewards.Currency(824)}, label="Smuggler's Cache", note="In a cave, dodge the tripwires"},
    [89406580]={quest=35976, loot={ns.rewards.Currency(824)}, label="Warsong Supplies"},
    -- treasures
    [38305880]={quest=36109, npc=84068, loot={114054}, label="Goldtoe's Plunder", note="Gold, parrot has the key"},
    [45605200]={quest=35969, label="Adventurer's Pack", note="Gold, random green"},
    [45806630]={quest=36020, loot={117981}, label="Fragment of Oshu'gun"},
    [50006650]={quest=35579, loot={118264}, label="Void-Infused Crystal"},
    [52404440]={quest=36073, loot={118250}, label="Warsong Helm"},
    [53406430]={quest=36088, label="Adventurer's Pouch", note="Random green, in the cave"}, -- todo: confirm location
    [57806220]={quest=36115, loot={118278}, label="Pale Elixir"},
    [58205260]={quest=35694, loot={118266}, label="Golden Kaliri Egg"},
    [58305940]={quest=36021, loot={116688}, label="Pokkar's Thirteenth Axe"},
    [61805740]={quest=36082, label="Lost Pendant", note="Green amulet"},
    [62506710]={quest=36116, label="Bag of Herbs", note="Assorted herbs"},
    [64703580]={quest=36071, loot={118235}, label="Watertight Bag"},
    [64706580]={quest=36046, loot={118253}, label="Telaar Defender Shield"},
    [66901950]={quest=35954, loot={118234}, label="Elemental Offering", note="jump down"},
    [67404900]={quest=36039, loot={118252}, label="Highmaul Sledge"},
    [67605980]={quest=35759, label="Abandoned Cargo", note="Gold, random green"},
    [69905240]={quest=35597, label="Adventurer's Pack", note="Gold, random green"},
    [72706100]={quest=36035, loot={118254}, label="Polished Saberon Skull", note="Circuitous path up the cliff from in Sabermaw, past the Adventuer's Mace"},
    [73102160]={quest=35692, loot={118233}, label="Freshwater Clam"},
    [73901410]={quest=35955, label="Adventurer's Sack", note="Gold"},
    [75206500]={quest=36102, label="Saberon Stash", note="Gold, jump down"},
    [75306570]={quest=36099, loot={61986}, label="Important Exploration Supplies"},
    [75404710]={quest=36074, loot={118236}, label="Gambler's Purse"},
    [75806200]={quest=36077, label="Adventurer's Mace", note="Gold, green mace; circuitous path up the cliff from in Sabermaw"},
    [77302820]={quest=35986, loot={116760}, label="Bone-Carved Dagger"},
    [78901550]={quest=36036, loot={118251}, label="Elemental Shackles"},
    [81007980]={quest=36049, loot={118255}, label="Ogre Beads"},
    [81501300]={quest=35953, loot={116640}, label="Adventurer's Staff"},
    [82305660]={quest=35765, label="Adventurer's Pack", note="Gold, random green"},
    [85405340]={quest=35696, label="Burning Blade Cache", note="In tower, jump from cliff"},
    [87107290]={quest=36051, loot={118054}, label="Grizzlemaw's Bonepile"},
}, {
    achievement=9728,
    hide_quest=36468,
    minimap=true,
})
--[[
-- TODO: need the name
["ACaveInNagrand"] = {
    [66305730]={quest=36088, label="Adventurer's Pouch", note="Random green"},
}
-- "Vault of the Titan"
["StonecragGorge"] = {
}
--]]

ns.RegisterPoints(550, { -- NagrandDraenor
    [40406860]={quest=37435, loot={ns.rewards.Currency(824)}, group="junk", label="Spirit Coffer"},
    -- abu'gar
    [38404940]={quest=36711, loot={114245}, inbag=114245, label="Abu'Gar's Favorite Lure", note="Won't show complete until you get Abu'Gar"}, -- 36072
    [65906120]={quest=36711, loot={114242}, inbag=114242, label="Abu'gar's Vitality", note="Won't show complete until you get Abu'Gar"}, -- 35711
    [85403870]={quest=36711, loot={114243}, inbag=114243, label="Abu'gar's Missing Reel", note="Won't show complete until you get Abu'Gar"}, -- 36089
    -- followers
    [40307610]=ns.follower{quest=35596, loot={ns.rewards.GarrisonFollower(170)}, note="Kill Bolkar nearby to get the key"}, -- Goldmane
    [46401600]=ns.follower{quest=34466, loot={ns.rewards.GarrisonFollower(190)}, label="Mysterious Staff", note="Collect all the Mysterious items across Draenor"}, -- Archmage Vargoth
    [67205600]=ns.follower{quest=36711, --[[npc=82746,]] loot={ns.rewards.GarrisonFollower(209)}, note="Rebuild his fishing rod by gathering the pieces @ 38.4,49.3, 65.8,61.1, 85.4,38.7"}, -- Abu'gar
}, {
    minimap=true,
})

-- Rares

ns.RegisterPoints(550, { -- NagrandDraenor
    [34607700]={quest=34727, npc=79725, loot={{118244, toy=true}, 116809}}, -- Captain Ironbeard
    [42207860]={quest=34725, npc=80122, loot={116798, ns.rewards.Currency(824)}, note="In a cave"}, -- Gaz'orda
    [42804920]={quest=35875, npc=83409, loot={116765}}, -- Ophiis
    [45801520]={quest=36229, npc=84435, loot={118690}}, -- Mr. Pinchy Sr.
    [47607080]={quest=35865, npc=83401, loot={{116815, pet=1524}}}, -- Netherspawn
    [52009000]={quest=37408, npc=80370, note="No loot"}, -- Lernaea
    [52205580]={quest=35715, npc=82764, loot={118246}}, -- Gar'lua
    [54806120]={quest=35931, npc=83634, loot={116797}}, -- Scout Pokhar
    [58008400]={quest=35900, npc=83526, loot={118688}}, -- Ru'klaa
    [58201200]={quest=37398, npc=88210, loot={119384}, achievement=9617}, -- Krud the Eviscerator
    [58201800]={quest=37637, npc=88208, loot={120317}}, -- Pit Beast
    [61804720]={quest=35912, npc=83542, loot={116834}}, -- Sean Whitesea
    [61806900]={quest=35943, npc=83680, loot={116800}}, -- Outrider Duretha
    [65003900]={quest=35920, npc=83591, loot={116814}}, -- Tura'aka
    [66605660]={quest=35717, npc=82778, loot={116824}}, -- Gnarlhoof the Rabid
    [66805120]={quest=35714, npc=82758, loot={116795}}, -- Greatfeather
    [70004180]={quest=35893, npc=83483, loot={116807}}, -- Flinthide
    [70602940]={quest=35877, npc=83428, loot={116808}}, -- Windcaller Korast
    [73605780]={quest=35712, npc=82755, loot={118243}}, -- Redclaw the Feral
    [74801180]={quest=35836, npc=82975, loot={116836}, note="Use the fishing rod at 75.3,10.9"}, -- Fangler
    [75606500]={quest=36128, npc=80057, loot={116806}}, -- Soulfang
    [77006400]={quest=35735, npc=82826, loot={116823}, note="In a cave, use the switch"}, -- Berserk T-300 Series Mark II
    [80603040]={quest=35923, npc=83603, loot={118245}}, -- Hunter Blacktooth
    [81206000]={quest=35932, npc=83643, loot={116796}}, -- Malroc Stonesunder
    [81406040]={ label="Warleader Tome",
        npc=81330, loot={{120276, toy=true}},
        routes={{
            81406040, 79606620, 77406780, 71806800, 67007300, 63607220, 59806700, 60406100, 60005700, 56805300,
            53405200, 51404970, 50204480, 48804160, 43204180, 40803860, 44403100, 45602140, 50001900, 55202280,
            58902420, 62702060, 64102550, 62603040, 63603480, 67804020, 71903870, 76804260, 82104990, 80905550,
            loop=true, r=0.8, g=0, b=0.8,
        }},
        note="Spawns here, and patrols clockwise around the entire zone with a dozen adds"
    },
    [82607620]={quest=34645, npc=79024, loot={116805}}, -- Warmaster Blugthol
    [84603660]={quest=36159, npc=84263, loot={118689}}, -- Graveltooth
    [84605340]={quest=35778, npc=82899, loot={116832}}, -- Ancient Blademaster
    [86007160]={quest=35784, npc=82912, loot={118687}}, -- Grizzlemaw
    [87005500]={quest=34862, npc=78161, loot={116799}}, -- Hyperious
    [89004120]={quest=35623, npc=82486, loot={118679}}, -- Explorer Nozzand
    [93202820]={quest=35898, npc=83509, loot={116916}}, -- Gorepetal
    [28182969]={quest=40073, npc=98199, loot={{129217, pet=1766}}}, -- Pugg
    [23783851]={quest=40074, npc=98200, loot={{129218, pet=1765}}}, -- Guk
    [26033460]={quest=40075, npc=98198, loot={{129216, pet=1764}}}, -- Rukdug
    -- steamwheedle rares
    [62601680]={quest=37211, npc=86732, loot={118655}}, -- Bergruu
    [64203040]={quest=37221, npc=86743, loot={118656}}, -- Dekorhan
    [60802780]={quest=37225, npc=86750, loot={118660}}, -- Thek'talon
    [48202220]={quest=37223, npc=86771, loot={118658}}, -- Gagrog the Brutal
    [41004400]={quest=37226, npc=86835, loot={118661}}, -- Xelganak
    [51001600]={quest=37210, npc=86774, loot={118654}}, -- Aogexon
    [60003800]={quest=37222, npc=86729, loot={118657}}, -- Direhoof
    [34005100]={quest=37224, npc=87666, loot={118659}}, -- Mu'gra
    [37003800]={quest=37520, npc=88951, loot={120172}}, -- Vileclaw
})
ns.RegisterPoints(550, { -- NagrandDraenor
    [43003640]={criteria=26141, quest=37400, npc=87234, loot={119380}, label="{npc:87234:Brutag Grimblade}"}, -- Brutag Grimblade
    [45803480]={criteria=26140, quest=37399, npc=86959, loot={119355}, label="{npc:86959:Karosh Blackwind}"}, -- Karosh Blackwind
    [42603620]={criteria={26142, 26143}, quest={37472, 37473}, npc=87239, label="Secret Meeting", note="Find the {item:120290} and use {npc:87361}, which will summon {npc:87239} and {npc:87344}"}, -- Secret Meeting: Krahl Deadeye, Gortag Steelgrip
    -- [43803440]={criteria=26142, quest=37473, npc=87239, achievement=9541}, -- Krahl Deadeye
    -- [45003640]={criteria=26143, quest=37472, npc=87344, achievement=9541}, -- Gortag Steelgrip
}, {
    achievement=9541,
})
ns.RegisterPoints(550, { -- NagrandDraenor
    [38001960]={criteria=26320, quest=37397, npc=87846, loot={119389}}, -- Pit Slayer
    [38602240]={criteria=26318, quest=37395, npc=87788, loot={119405}}, -- Durg Spinecrusher
    [40001600]={criteria=26319, quest=37396, npc=87837, loot={119370}}, -- Bonebreaker
}, {
    achievement=9571,
})
