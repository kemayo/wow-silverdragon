#!/usr/bin/python

# This is here because wowhead doesn't expose zoneids anywhere, that I could see.

# wowdb and wowhead use the same numeric zoneids, which aren't in-game mapids
zoneid_to_mapid = {
    1: 27,  # Dun Morogh
    3: 17,  # Badlands
    4: 19,  # Blasted Lands
    8: 38,  # Swamp of Sorrows
    10: 34,  # Duskwood
    11: 40,  # Wetlands
    12: 30,  # Elwynn Forest
    14: 4,  # Durotar
    15: 141,  # Dustwallow Marsh
    16: 181,  # Azshara
    17: 11,  # Northern Barrens
    28: 22,  # Western Plaguelands
    33: 37,  # Northern Stranglethorn
    38: 35,  # Loch Modan
    40: 39,  # Westfall
    41: 32,  # Deadwind Pass
    44: 36,  # Redridge Mountains
    45: 16,  # Arathi Highlands
    46: 29,  # Burning Steppes
    47: 26,  # The Hinterlands
    51: 28,  # Searing Gorge
    65: 488,  # Dragonblight
    66: 496,  # Zul'Drak
    67: 495,  # The Storm Peaks
    85: 20,  # Tirisfal Glades
    130: 21,  # Silverpine Forest
    139: 23,  # Eastern Plaguelands
    141: 41,  # Teldrassil
    148: 42,  # Darkshore
    206: 523,  # Utgarde Keep
    209: 764,  # Shadowfang Keep
    210: 492,  # Icecrown
    215: 9,  # Mulgore
    267: 24,  # Hillsbrad Foothills
    331: 43,  # Ashenvale
    357: 121,  # Feralas
    361: 182,  # Felwood
    394: 490,  # Grizzly Hills
    400: 61,  # Thousand Needles
    405: 101,  # Desolace
    406: 81,  # Stonetalon Mountains
    440: 161,  # Tanaris
    490: 201,  # Un'Goro Crater
    491: 761,  # Razorfen Kraul
    493: 241,  # Moonglade
    495: 491,  # Howling Fjord
    616: 683,  # Mount Hyjal
    618: 281,  # Winterspring
    717: 690,  # The Stockade
    718: 749,  # Wailing Caverns
    719: 688,  # Blackfathom Deeps
    721: 691,  # Gnomeregan
    722: 760,  # Razorfen Downs
    1176: 686,  # Zul'Farrak
    1196: 524,  # Utgarde Pinnacle
    1337: 692,  # Uldaman
    1377: 261,  # Silithus
    1497: 382,  # Undercity
    1517: 692,  # Uldaman
    1519: 301,  # Stormwind City
    1537: 341,  # Ironforge
    1581: 756,  # The Deadmines
    1583: 721,  # Blackrock Spire
    1584: 704,  # Blackrock Depths
    1637: 321,  # Orgrimmar
    1638: 362,  # Thunder Bluff
    1657: 381,  # Darnassus
    1977: 793,  # Zul'Gurub
    2017: 765,  # Stratholme
    2100: 750,  # Maraudon
    2159: 718,  # Onyxia's Lair
    2366: 733,  # The Black Morass
    2367: 734,  # Old Hillsbrad Foothills
    2437: 680,  # Ragefire Chasm
    2557: 699,  # Dire Maul
    2597: 401,  # Alterac Valley
    2677: 755,  # Blackwing Lair
    2717: 696,  # Molten Core
    2817: 510,  # Crystalsong Forest
    3277: 443,  # Warsong Gulch
    3358: 461,  # Arathi Basin
    3428: 766,  # Temple of Ahn'Qiraj
    3429: 717,  # Ruins of Ahn'Qiraj
    3430: 462,  # Eversong Woods
    3433: 463,  # Ghostlands
    3456: 535,  # Naxxramas
    3457: 799,  # Karazhan
    3483: 465,  # Hellfire Peninsula
    3487: 480,  # Silvermoon City
    3518: 477,  # Nagrand
    3519: 478,  # Terokkar Forest
    3520: 473,  # Shadowmoon Valley
    3521: 467,  # Zangarmarsh
    3522: 475,  # Blade's Edge Mountains
    3523: 479,  # Netherstorm
    3524: 464,  # Azuremyst Isle
    3525: 476,  # Bloodmyst Isle
    3537: 486,  # Borean Tundra
    3557: 471,  # The Exodar
    3562: 797,  # Hellfire Ramparts
    3606: 775,  # Hyjal Summit
    3607: 780,  # Serpentshrine Cavern
    3703: 481,  # Shattrath City
    3711: 493,  # Sholazar Basin
    3713: 725,  # The Blood Furnace
    3714: 710,  # The Shattered Halls
    3715: 727,  # The Steamvault
    3716: 726,  # The Underbog
    3717: 728,  # The Slave Pens
    3789: 724,  # Shadow Labyrinth
    3790: 722,  # Auchenai Crypts
    3791: 723,  # Sethekk Halls
    3792: 732,  # Mana-Tombs
    3805: 781,  # Zul'Aman
    3820: 813,  # Eye of the Storm
    3836: 779,  # Magtheridon's Lair
    3845: 782,  # The Eye
    3847: 729,  # The Botanica
    3848: 731,  # The Arcatraz
    3849: 730,  # The Mechanar
    3923: 776,  # Gruul's Lair
    3959: 796,  # Black Temple
    4075: 789,  # Sunwell Plateau
    4080: 499,  # Isle of Quel'Danas
    4100: 521,  # The Culling of Stratholme
    4131: 798,  # Magisters' Terrace
    4196: 534,  # Drak'Tharon Keep
    4197: 501,  # Wintergrasp
    4228: 528,  # The Oculus
    4264: 526,  # Halls of Stone
    4265: 803,  # The Nexus
    4272: 525,  # Halls of Lightning
    4273: 529,  # Ulduar
    4277: 533,  # Azjol-Nerub
    4298: 502,  # Plaguelands: The Scarlet Enclave
    4384: 512,  # Strand of the Ancients
    4395: 504,  # Dalaran
    4415: 536,  # The Violet Hold
    4416: 530,  # Gundrak
    4493: 531,  # The Obsidian Sanctum
    4494: 522,  # Ahn'kahet: The Old Kingdom
    4500: 527,  # The Eye of Eternity
    4603: 532,  # Vault of Archavon
    4706: 684,  # Ruins of Gilneas
    4709: 607,  # Southern Barrens
    4710: 540,  # Isle of Conquest
    4714: 679,  # Gilneas
    4720: 682,  # The Lost Isles
    4722: 543,  # Trial of the Crusader
    4723: 542,  # Trial of the Champion
    4737: 605,  # Kezan
    4742: 541,  # Hrothgar's Landing
    4755: 611,  # Gilneas City
    4809: 601,  # The Forge of Souls
    4812: 604,  # Icecrown Citadel
    4813: 602,  # Pit of Saron
    4815: 610,  # Kelp'thar Forest
    4820: 603,  # Halls of Reflection
    4922: 770,  # Twilight Highlands
    4926: 753,  # Blackrock Caverns
    4945: 759,  # Halls of Origination
    4950: 757,  # Grim Batol
    4987: 609,  # The Ruby Sanctum
    5004: 767,  # Throne of the Tides
    5031: 626,  # Twin Peaks
    5034: 748,  # Uldum
    5035: 769,  # The Vortex Pinnacle
    5042: 640,  # Deepholm
    5088: 768,  # The Stonecore
    5094: 754,  # Blackwing Descent
    5095: 708,  # Tol Barad
    5144: 615,  # Shimmering Expanse
    5145: 614,  # Abyssal Depths
    5146: 613,  # Vashj'ir
    5287: 673,  # The Cape of Stranglethorn
    5334: 758,  # The Bastion of Twilight
    5339: 689,  # Stranglethorn Vale
    5389: 709,  # Tol Barad Peninsula
    5396: 747,  # Lost City of the Tol'vir
    5416: 751,  # The Maelstrom
    5449: 736,  # The Battle for Gilneas
    5495: 691,  # Gnomeregan
    5600: 752,  # Baradin Hold
    5638: 773,  # Throne of the Four Winds
    5695: 772,  # Ahn'Qiraj: The Fallen Kingdom
    5723: 800,  # Firelands
    5733: 795,  # Molten Front
    5736: 808,  # The Wandering Isle
    5785: 806,  # The Jade Forest
    5788: 816,  # Well of Eternity
    5789: 820,  # End Time
    5805: 807,  # Valley of the Four Winds
    5840: 811,  # Vale of Eternal Blossoms
    5841: 809,  # Kun-Lai Summit
    5842: 810,  # Townlong Steppes
    5844: 819,  # Hour of Twilight
    5861: 823,  # Darkmoon Island
    5892: 824,  # Dragon Soul
    5918: 877,  # Shado-Pan Monastery
    5956: 867,  # Temple of the Jade Serpent
    5963: 876,  # Stormstout Brewery
    5976: 875,  # Gate of the Setting Sun
    6006: 873,  # The Veiled Stair
    6040: 851,  # Theramore's Fall (H)
    6051: 881,  # Temple of Kotmogu
    6052: 871,  # Scarlet Halls
    6066: 898,  # Scholomance
    6067: 886,  # Terrace of Endless Spring
    6101: 878,  # A Brewing Storm
    6109: 874,  # Scarlet Monastery
    6125: 896,  # Mogu'shan Vaults
    6126: 860,  # Silvershard Mines
    6134: 857,  # Krasarang Wilds
    6138: 858,  # Dread Wastes
    6141: 903,  # Shrine of Two Moons
    6142: 905,  # Shrine of Seven Stars
    6170: 864,  # Northshire
    6176: 866,  # Coldridge Valley
    6182: 885,  # Mogu'shan Palace
    6208: 900,  # Crypt of Forgotten Kings
    6209: 880,  # Greenstone Village
    6214: 887,  # Siege of Niuzao Temple
    6219: 899,  # Arena of Annihilation
    6297: 897,  # Heart of Fear
    6309: 882,  # Unga Ingoo
    6328: 883,  # Assault on Zan'vess
    6426: 884,  # Brewmoon Festival
    6450: 888,  # Shadowglen
    6451: 889,  # Valley of Trials
    6452: 890,  # Camp Narache
    6453: 891,  # Echo Isles
    6454: 892,  # Deathknell
    6455: 893,  # Sunstrider Isle
    6456: 894,  # Ammen Vale
    6457: 895,  # New Tinkertown
    6500: 906,  # Theramore's Fall (A)
    6507: 928,  # Isle of Thunder
    6510: 756,  # The Deadmines
    6511: 749,  # Wailing Caverns
    6514: 750,  # Maraudon
    6565: 914,  # Dagger in the Dark
    6567: 940,  # Battle on the High Seas
    6575: 911,  # Lion's Landing
    6615: 920,  # Domination Point
    6616: 912,  # A Little Patience
    6622: 930,  # Throne of Thunder
    6661: 929,  # Isle of Giants
    6662: 946,  # Talador
    6678: 939,  # Blood in the Snow
    6719: 947,  # Shadowmoon Valley
    6720: 941,  # Frostfire Ridge
    6721: 949,  # Gorgrond
    6722: 948,  # Spires of Arak
    6723: 945,  # Tanaan Jungle
    6731: 938,  # The Secrets of Ragefire
    6733: 937,  # Dark Heart of Pandaria
    6738: 953,  # Siege of Orgrimmar
    6755: 950,  # Nagrand
    6757: 951,  # Timeless Isle
    6771: 955,  # Celestial Tournament
    6852: 899,  # Proving Grounds
    6874: 964,  # Bloodmaul Slag Mines
    6912: 984,  # Auchindoun
    6932: 969,  # Shadowmoon Burial Grounds
    6941: 978,  # Ashran
    6951: 987,  # Iron Docks
    6967: 988,  # Blackrock Foundry
    6980: 481,  # Shattrath City
    6984: 993,  # Grimrail Depot
    6988: 989,  # Skyreach
    6996: 994,  # Highmaul
    7004: 976,  # Frostwall
    7025: 945,  # Tanaan Jungle
    7078: 971,  # Lunarfall
    7109: 1008,  # The Everbloom
    7307: 995,  # Upper Blackrock Spire
    7332: 1009,  # Stormshield
    7333: 1011,  # Warspear
    # Missing:
    25: False,  # Blackrock Mountain
    34: False,  # Echo Ridge Mine
    54: False,  # Jasperlode Mine
    57: False,  # Fargodeep Mine
    111: False,  # Jangolode Mine
    113: False,  # Gold Coast Quarry
    134: False,  # Gol'Bolar Quarry
    135: False,  # Frostmane Hold
    136: False,  # The Grizzled Den
    155: False,  # Night Web's Hollow
    257: False,  # Shadowthread Cave
    258: False,  # Fel Rock
    262: False,  # Ban'ethil Barrow Den
    360: False,  # The Venture Co. Mine
    365: False,  # Burning Blade Coven
    371: False,  # Dustwind Cave
    457: False,  # The Veiled Sea
    540: False,  # The Slithering Scar
    800: False,  # Coldridge Pass
    817: False,  # Skull Rock
    818: False,  # Palemane Rock
    876: False,  # GM Island
    981: False,  # The Gaping Chasm
    982: False,  # The Noxious Lair
    1477: False,  # Sunken Temple
    2257: False,  # Deeprun Tram
    2300: False,  # Caverns of Time
    3446: False,  # Twilight's Run
    3510: False,  # Amani Catacombs
    3569: False,  # Tides' Hollow
    3572: False,  # Stillpine Hold
    3698: False,  # Nagrand Arena
    3702: False,  # Blade's Edge Arena
    3968: False,  # Ruins of Lordaeron
    4378: False,  # Dalaran Arena
    4406: False,  # The Ring of Valor
    4732: False,  # Emberstone Mine
    4766: False,  # Kaja'mine
    4778: False,  # Kaja'mite Cavern
    4817: False,  # Greymane Manor
    4911: False,  # Volcanoth's Lair
    4913: False,  # Spitescale Cavern
    4924: False,  # Gallywix Labor Mine
    5511: False,  # Scarlet Monastery Entrance
    5955: False,  # Greenstone Quarry
    6074: False,  # Guo-Lai Halls
    6084: False,  # The Deeper
    6088: False,  # Knucklethump Hole
    6099: False,  # Pranksters' Hollow
    6137: False,  # Frostmane Hovel
    6201: False,  # Tomb of Conquerors
    6296: False,  # Tol'viron Arena
    6298: False,  # Brawl'gar Arena
    6311: False,  # Niuzao Catacombs
    6376: False,  # The Ancient Passage
    6389: False,  # Howlingwind Cavern
    6419: False,  # Peak of Serenity
    6466: False,  # Cavern of Endless Echoes
    6512: False,  # The Widow's Wail
    6513: False,  # Oona Kagu
    6553: False,  # Shrine of Seven Stars
    6589: False,  # Lightning Vein Mine
    6592: False,  # The Swollen Vault
    6609: False,  # Ruins of Ogudei
    6611: False,  # The Situation in Dalaran
    6613: False,  # Pursuing the Black Harvest
    6619: False,  # Ruins of Korune
    6665: False,  # Deepwind Gorge
    6666: False,  # Stormsea Landing
    6673: False,  # To the Skies
    6675: False,  # The Thunder Forge
    6677: False,  # Fall of Shan Bu
    6681: False,  # Lightning Vein Mine
    6716: False,  # Troves of the Thunder King
    6732: False,  # The Tiger's Peak
    6745: False,  # Grulloc's Grotto
    6756: False,  # Faralohn
    6780: False,  # Cavern of Lost Spirits
    6848: False,  # Turgall's Den
    6849: False,  # Sootstained Mines
    6851: False,  # The Purge of Grommar
    6861: False,  # Grulloc's Lair
    6863: False,  # The Secret Ingredient
    6864: False,  # Bladespire Citadel
    6868: False,  # Hall of the Great Hunt
    6875: False,  # Bladespire Throne
    6885: False,  # Cragplume Cauldron
    6939: False,  # Butcher's Rise
    6960: False,  # The Battle of Thunder Pass
    6976: False,  # Bloodthorn Cave
    6979: False,  # Tomb of Souls
    7005: False,  # Snowfall Alcove
    7042: False,  # Umbral Halls
    7083: False,  # Defense of Karabor
    7089: False,  # Tomb of Lights
    7107: False,  # Tarren Mill vs Southshore
    7124: False,  # The Masters' Cavern
    7160: False,  # Fissure of Fury
    7185: False,  # Moira's Reach
    7203: False,  # The Underpale
    7204: False,  # Sanctum of the Naaru
    7209: False,  # Bladespire Span
    7267: False,  # Vault of the Titan
    7324: False,  # Lunarfall Excavation
    7325: False,  # Lunarfall Excavation
    7326: False,  # Lunarfall Excavation
    7327: False,  # Frostwall Mine
    7328: False,  # Frostwall Mine
    7329: False,  # Frostwall Mine
    7381: False,  # The Trial of Faith
    7460: False,  # Den of Secrets
    7462: False,  # The Coliseum
    7510: False,  # The Burning Nether
    7519: False,  # Edge of Reality
    7545: False,  # Hellfire Citadel
    7548: False,  # Ashran Mine
    7622: False,  # The Breached Ossuary
    7771: False,  # Tanaan Invasion
}
