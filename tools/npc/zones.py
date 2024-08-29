#!/usr/bin/python

# This is here because wowhead doesn't expose zoneids anywhere, that I could see.

zoneid_ignore = {
    9424: 1016,  # Waycrest Manor (upstairs)
    # Various island scenarions
    9440: 1034,  # Verdant Wilds
    9466: 1033,  # The Rotting Mire
    9469: 981,  # Un'gol Ruins
    9496: 1035,  # Molten Cay
    9497: 1032,  # Skittering Hollow
    9548: 1336,  # Havenswood
    9576: 1036,  # The Dread Chain
    9591: 1037,  # Whispering Reef
    9616: 1337,  # Jorundall
}

# wowdb and wowhead use the same numeric zoneids, which aren't in-game mapids
zoneid_to_mapid = {
    1: 27,  # Dun Morogh
    3: 15,  # Badlands
    4: 17,  # Blasted Lands
    8: 51,  # Swamp of Sorrows
    10: 47,  # Duskwood
    11: 56,  # Wetlands
    12: 37,  # Elwynn Forest
    14: 1,  # Durotar
    15: 70,  # Dustwallow Marsh
    16: 76,  # Azshara
    17: 10,  # Northern Barrens
    25: 33,  # Blackrock Mountain
    28: 22,  # Western Plaguelands
    33: 50,  # Northern Stranglethorn
    38: 48,  # Loch Modan
    40: 52,  # Westfall
    41: 42,  # Deadwind Pass
    44: 49,  # Redridge Mountains
    45: 14,  # Arathi Highlands
    46: 36,  # Burning Steppes
    47: 26,  # The Hinterlands
    51: 32,  # Searing Gorge
    54: 40,  # Jasperlode Mine
    57: 38,  # Fargodeep Mine
    65: 115,  # Dragonblight
    66: 121,  # Zul'Drak
    67: 120,  # The Storm Peaks
    85: 18,  # Tirisfal Glades
    111: 54,  # Jangolode Mine
    130: 21,  # Silverpine Forest
    135: 470,  # Frostmane Hold
    139: 23,  # Eastern Plaguelands
    141: 57,  # Teldrassil
    148: 62,  # Darkshore
    206: 133,  # Utgarde Keep
    209: 310,  # Shadowfang Keep
    210: 118,  # Icecrown
    215: 7,  # Mulgore
    258: 59,  # Fel Rock
    267: 25,  # Hillsbrad Foothills
    331: 63,  # Ashenvale
    357: 69,  # Feralas
    361: 77,  # Felwood
    394: 116,  # Grizzly Hills
    400: 64,  # Thousand Needles
    405: 66,  # Desolace
    406: 65,  # Stonetalon Mountains
    440: 71,  # Tanaris
    490: 78,  # Un'Goro Crater
    491: 301,  # Razorfen Kraul
    493: 80,  # Moonglade
    495: 117,  # Howling Fjord
    616: 198,  # Mount Hyjal
    618: 83,  # Winterspring
    717: 225,  # The Stockade
    718: 279,  # Wailing Caverns
    719: 221,  # Blackfathom Deeps
    721: 226,  # Gnomeregan
    722: 300,  # Razorfen Downs
    1176: 219,  # Zul'Farrak
    1196: 136,  # Utgarde Pinnacle
    1337: 230,  # Uldaman
    1377: 81,  # Silithus
    1497: 998,  # Undercity
    1517: 230,  # Uldaman
    1519: 84,  # Stormwind City
    1537: 87,  # Ironforge
    1581: 55,  # The Deadmines
    1583: 34,  # Blackrock Spire
    1584: 35,  # Blackrock Depths
    1637: 86,  # Orgrimmar
    1638: 88,  # Thunder Bluff
    1657: 89,  # Darnassus
    1977: 337,  # Zul'Gurub
    2017: 317,  # Stratholme
    2100: 280,  # Maraudon
    2159: 248,  # Onyxia's Lair
    2366: 273,  # The Black Morass
    2367: 274,  # Old Hillsbrad Foothills
    2437: 213,  # Ragefire Chasm
    2557: 235,  # Dire Maul
    2597: 91,  # Alterac Valley
    2677: 287,  # Blackwing Lair
    2717: 232,  # Molten Core
    2817: 127,  # Crystalsong Forest
    3277: 92,  # Warsong Gulch
    3358: 93,  # Arathi Basin
    3428: 319,  # Temple of Ahn'Qiraj
    3429: 247,  # Ruins of Ahn'Qiraj
    3430: 94,  # Eversong Woods
    3433: 95,  # Ghostlands
    3456: 162,  # Naxxramas
    3457: 350,  # Karazhan
    3483: 100,  # Hellfire Peninsula
    3487: 110,  # Silvermoon City
    3518: 107,  # Nagrand
    3519: 108,  # Terokkar Forest
    3520: 104,  # Shadowmoon Valley
    3521: 102,  # Zangarmarsh
    3522: 105,  # Blade's Edge Mountains
    3523: 109,  # Netherstorm
    3524: 97,  # Azuremyst Isle
    3525: 106,  # Bloodmyst Isle
    3537: 114,  # Borean Tundra
    3557: 103,  # The Exodar
    3562: 347,  # Hellfire Ramparts
    3606: 329,  # Hyjal Summit
    3607: 332,  # Serpentshrine Cavern
    3703: 111,  # Shattrath City
    3711: 119,  # Sholazar Basin
    3713: 261,  # The Blood Furnace
    3714: 246,  # The Shattered Halls
    3715: 263,  # The Steamvault
    3716: 262,  # The Underbog
    3717: 265,  # The Slave Pens
    3789: 260,  # Shadow Labyrinth
    3790: 256,  # Auchenai Crypts
    3791: 258,  # Sethekk Halls
    3792: 272,  # Mana-Tombs
    3805: 333,  # Zul'Aman
    3820: 397,  # Eye of the Storm
    3836: 331,  # Magtheridon's Lair
    3845: 334,  # The Eye
    3847: 266,  # The Botanica
    3848: 269,  # The Arcatraz
    3849: 267,  # The Mechanar
    3923: 330,  # Gruul's Lair
    3959: 340,  # Black Temple
    4075: 336,  # Sunwell Plateau
    4080: 122,  # Isle of Quel'Danas
    4100: 131,  # The Culling of Stratholme
    4131: 348,  # Magisters' Terrace
    4196: 160,  # Drak'Tharon Keep
    4197: 123,  # Wintergrasp
    4228: 143,  # The Oculus
    4264: 140,  # Halls of Stone
    4265: 370,  # The Nexus
    4272: 138,  # Halls of Lightning
    4273: 148,  # Ulduar
    4277: 157,  # Azjol-Nerub
    4298: 124,  # Plaguelands: The Scarlet Enclave
    4384: 128,  # Strand of the Ancients
    4395: 125,  # Dalaran
    4415: 168,  # The Violet Hold
    4416: 154,  # Gundrak
    4493: 155,  # The Obsidian Sanctum
    4494: 132,  # Ahn'kahet: The Old Kingdom
    4500: 141,  # The Eye of Eternity
    4603: 156,  # Vault of Archavon
    4706: 217,  # Ruins of Gilneas
    4709: 199,  # Southern Barrens
    4710: 169,  # Isle of Conquest
    4722: 172,  # Trial of the Crusader
    4723: 171,  # Trial of the Champion
    4737: 194,  # Kezan
    4742: 170,  # Hrothgar's Landing
    4755: 202,  # Gilneas City
    4809: 183,  # The Forge of Souls
    4812: 186,  # Icecrown Citadel
    4813: 184,  # Pit of Saron
    4815: 201,  # Kelp'thar Forest
    4820: 185,  # Halls of Reflection
    4922: 241,  # Twilight Highlands
    4926: 283,  # Blackrock Caverns
    4945: 297,  # Halls of Origination
    4950: 293,  # Grim Batol
    4987: 200,  # The Ruby Sanctum
    5004: 322,  # Throne of the Tides
    5031: 206,  # Twin Peaks
    5034: 249,  # Uldum
    5035: 325,  # The Vortex Pinnacle
    5042: 207,  # Deepholm
    5088: 324,  # The Stonecore
    5094: 285,  # Blackwing Descent
    5095: 244,  # Tol Barad
    5144: 205,  # Shimmering Expanse
    5145: 204,  # Abyssal Depths
    5146: 203,  # Vashj'ir
    5287: 210,  # The Cape of Stranglethorn
    5334: 294,  # The Bastion of Twilight
    5339: 224,  # Stranglethorn Vale
    5389: 245,  # Tol Barad Peninsula
    5396: 277,  # Lost City of the Tol'vir
    5449: 275,  # The Battle for Gilneas
    5495: 226,  # Gnomeregan
    5600: 282,  # Baradin Hold
    5638: 328,  # Throne of the Four Winds
    5695: 327,  # Ahn'Qiraj: The Fallen Kingdom
    5723: 368,  # Firelands
    5733: 338,  # Molten Front
    5736: 378,  # The Wandering Isle
    5785: 371,  # The Jade Forest
    5788: 398,  # Well of Eternity
    5789: 402,  # End Time
    5805: 376,  # Valley of the Four Winds
    5840: 390,  # Vale of Eternal Blossoms
    5841: 379,  # Kun-Lai Summit
    5842: 388,  # Townlong Steppes
    5844: 400,  # Hour of Twilight
    5861: 408,  # Darkmoon Island
    5892: 410,  # Dragon Soul
    5918: 444,  # Shado-Pan Monastery
    5956: 429,  # Temple of the Jade Serpent
    5963: 439,  # Stormstout Brewery
    5976: 437,  # Gate of the Setting Sun
    6006: 433,  # The Veiled Stair
    6040: 416,  # Theramore's Fall (H)
    6051: 449,  # Temple of Kotmogu
    6052: 431,  # Scarlet Halls
    6066: 476,  # Scholomance
    6067: 456,  # Terrace of Endless Spring
    6101: 447,  # A Brewing Storm
    6109: 435,  # Scarlet Monastery
    6125: 471,  # Mogu'shan Vaults
    6126: 423,  # Silvershard Mines
    6134: 418,  # Krasarang Wilds
    6138: 422,  # Dread Wastes
    6141: 391,  # Shrine of Two Moons
    6142: 391,  # Shrine of Seven Stars
    6170: 425,  # Northshire
    6176: 427,  # Coldridge Valley
    6182: 453,  # Mogu'shan Palace
    6208: 481,  # Crypt of Forgotten Kings
    6209: 448,  # Greenstone Village
    6214: 458,  # Siege of Niuzao Temple
    6219: 480,  # Arena of Annihilation
    6297: 474,  # Heart of Fear
    6309: 450,  # Unga Ingoo
    6328: 451,  # Assault on Zan'vess
    6426: 452,  # Brewmoon Festival
    6450: 460,  # Shadowglen
    6451: 461,  # Valley of Trials
    6452: 462,  # Camp Narache
    6453: 463,  # Echo Isles
    6454: 465,  # Deathknell
    6455: 467,  # Sunstrider Isle
    6456: 468,  # Ammen Vale
    6457: 469,  # New Tinkertown
    6500: 483,  # Theramore's Fall (A)
    6507: 505,  # Isle of Thunder
    6510: 291,  # The Deadmines
    6511: 279,  # Wailing Caverns
    6514: 280,  # Maraudon
    6565: 489,  # Dagger in the Dark
    6567: 524,  # Battle on the High Seas
    6575: 486,  # Lion's Landing
    6615: 498,  # Domination Point
    6616: 487,  # A Little Patience
    6622: 508,  # Throne of Thunder
    6661: 507,  # Isle of Giants
    6662: 535,  # Talador
    6678: 523,  # Blood in the Snow
    6719: 539,  # Shadowmoon Valley
    6720: 525,  # Frostfire Ridge
    6721: 543,  # Gorgrond
    6722: 542,  # Spires of Arak
    6723: 534,  # Tanaan Jungle
    6731: 522,  # The Secrets of Ragefire
    6733: 521,  # Dark Heart of Pandaria
    6738: 557,  # Siege of Orgrimmar
    6755: 550,  # Nagrand
    6757: 554,  # Timeless Isle
    6771: 571,  # Celestial Tournament
    6852: 480,  # Proving Grounds
    6874: 573,  # Bloodmaul Slag Mines
    6912: 593,  # Auchindoun
    6932: 574,  # Shadowmoon Burial Grounds
    6941: 588,  # Ashran
    6951: 595,  # Iron Docks
    6967: 596,  # Blackrock Foundry
    6980: 111,  # Shattrath City
    6984: 606,  # Grimrail Depot
    6988: 601,  # Skyreach
    6996: 611,  # Highmaul
    7025: 534,  # Tanaan Jungle
    7109: 621,  # The Everbloom
    7307: 616,  # Upper Blackrock Spire
    7332: 622,  # Stormshield
    7333: 624,  # Warspear
    7334: 630,  # Azsuna
    7502: 625,  # Dalaran
    7503: 650,  # Highmountain
    7541: 634,  # Stormheim
    7543: 646,  # Broken Shore
    7558: 641,  # Val'sharah
    7578: 790,  # Eye of Azshara
    7588: 649,  # Helheim
    7637: 680,  # Suramar
    7672: 704,  # Halls of Valor
    7673: 733,  # Darkheart Thicket
    7731: 750,  # Thunder Totem
    7787: 710,  # Vault of the Wardens
    7805: 751,  # Black Rook Hold
    7814: 710,  # Vault of the Wardens
    7897: 628,  # The Underbelly
    8000: 630,  # Azsuna
    8026: 777,  # The Emerald Nightmare
    8040: 790,  # Eye of Azshara
    8499: 862,  # Zuldazar
    8500: 863,  # Nazmir
    8501: 864,  # Vol'dun
    8567: 895,  # Tiragarde Sound
    8568: 1161,  # Boralus
    8574: 830,  # Krokuun
    8670: 1165,  # Dazar'alor
    8701: 882,  # Eredath
    8721: 896,  # Drustvar
    8899: 885,  # Antoran Wastes
    9042: 942,  # Stormsong Valley
    9105: 1530,  # Vale of Eternal Blossoms
    10052: 1355,  # Nazjatar
    10290: 1462,  # Mechagon
    10413: 1525,  # Revendreth
    10424: 1409,  # Exile's Reach
    10472: 1705,  # Torghast, Tower of the Damned
    10534: 1533,  # Bastion
    10833: 1527,  # Uldum
    11400: 1543,  # The Maw
    11462: 1536,  # Maldraxxus
    11510: 1565,  # Ardenweald
    12924: 1565,  # Ardenweald
    13178: 1536,  # Maldraxxus
    13313: 1536,  # Maldraxxus
    13332: 1543,  # The Maw
    13387: 1565,  # Ardenweald
    13476: 1543,  # The Maw
    13570: 1961,  # Korthia
    13577: 1989,  # Tazavesh, the Veiled Market
    13672: 1993,  # Tazavesh, the Veiled Market
    # Missing:
    5: False,  # - QA and DVD GLOBAL -
    34: False,  # Echo Ridge Mine
    36: False,  # Alterac Mountains
    113: False,  # Gold Coast Quarry
    134: False,  # Gol'Bolar Quarry
    136: False,  # The Grizzled Den
    155: False,  # Night Web's Hollow
    257: False,  # Shadowthread Cave
    262: False,  # Ban'ethil Barrow Den
    360: False,  # The Venture Co. Mine
    365: False,  # Burning Blade Coven
    371: False,  # Dustwind Cave
    457: False,  # The Veiled Sea
    540: False,  # The Slithering Scar
    796: False,  # Scarlet Monastery
    800: False,  # Coldridge Pass
    817: False,  # Skull Rock
    818: False,  # Palemane Rock
    876: False,  # GM Island
    981: False,  # The Gaping Chasm
    982: False,  # The Noxious Lair
    1477: False,  # Sunken Temple
    2057: False,  # Scholomance
    2257: False,  # Deeprun Tram
    2300: False,  # Caverns of Time
    3446: False,  # Twilight's Run
    3455: False,  # The North Sea
    3479: False,  # The Veiled Sea
    3510: False,  # Amani Catacombs
    3569: False,  # Tides' Hollow
    3572: False,  # Stillpine Hold
    3698: False,  # Nagrand Arena
    3702: False,  # Blade's Edge Arena
    3968: False,  # Ruins of Lordaeron
    4378: False,  # Dalaran Arena
    4406: False,  # The Ring of Valor
    4714: False,  # Gilneas
    4720: False,  # The Lost Isles
    4732: False,  # Emberstone Mine
    4766: False,  # Kaja'mine
    4778: False,  # Kaja'mite Cavern
    4817: False,  # Greymane Manor
    4821: False,  # Bilgewater Harbor
    4911: False,  # Volcanoth's Lair
    4913: False,  # Spitescale Cavern
    4924: False,  # Gallywix Labor Mine
    5166: False,  # Cleft of Shadow
    5351: False,  # Ruins of Gilneas City
    5416: False,  # The Maelstrom
    5511: False,  # Scarlet Monastery Entrance
    5786: False,  # The Nexus
    5799: False,  # Eye of the Storm
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
    6384: False,  # Forlorn Cloister
    6386: False,  # Chapel Gardens
    6389: False,  # Howlingwind Cavern
    6419: False,  # Peak of Serenity
    6449: False,  # Temple of Kotmogu
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
    6749: False,  # Vault of Y'Shaarj
    6756: False,  # Faralohn
    6780: False,  # Cavern of Lost Spirits
    6848: False,  # Turgall's Den
    6849: False,  # Sootstained Mines
    6851: False,  # The Purge of Grommar
    6861: False,  # Grulloc's Lair
    6862: False,  # The Halfhill Market
    6863: False,  # The Secret Ingredient
    6864: False,  # Bladespire Citadel
    6868: False,  # Hall of the Great Hunt
    6875: False,  # Bladespire Throne
    6885: False,  # Cragplume Cauldron
    6939: False,  # Butcher's Rise
    6960: False,  # The Battle of Thunder Pass
    6976: False,  # Bloodthorn Cave
    6979: False,  # Tomb of Souls
    7004: False,  # Frostwall
    7005: False,  # Snowfall Alcove
    7042: False,  # Umbral Halls
    7078: False,  # Lunarfall
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
    7343: False,  # [UNUSED]
    7381: False,  # The Trial of Faith
    7460: False,  # Den of Secrets
    7462: False,  # The Coliseum
    7510: False,  # The Burning Nether
    7519: False,  # Edge of Reality
    7534: False,  # Broken Shore
    7545: False,  # Hellfire Citadel
    7546: False,  # Neltharion's Lair
    7548: False,  # Ashran Mine
    7576: False,  # Twisting Nether
    7622: False,  # The Breached Ossuary
    7634: False,  # Feralas (copy)
    7638: False,  # Sanctum of Light
    7656: False,  # The Great Sea
    7658: False,  # The Cove of Nashal
    7674: False,  # Legion Dungeon
    7679: False,  # Acherus: The Ebon Hold
    7690: False,  # The Skyfire
    7691: False,  # Small Battleground D
    7695: False,  # Icecrown Citadel
    7705: False,  # Mardum, the Shattered Abyss
    7734: False,  # Icecrown Citadel
    7737: False,  # Niskara
    7744: False,  # Shield's Rest
    7745: False,  # The Maelstrom
    7767: False,  # Suramar
    7771: False,  # Tanaan Invasion
    7777: False,  # The Violet Hold
    7796: False,  # Broken Shore
    7811: False,  # The Naglfar
    7812: False,  # Maw of Souls
    7813: False,  # Skyhold
    7816: False,  # Black Rook Hold Arena
    7822: False,  # Nagrand Arena
    7827: False,  # Southshore vs. Tarren Mill
    7830: False,  # Helmouth Shallows
    7834: False,  # Netherlight Temple
    7838: False,  # Azshara
    7846: False,  # The Dreamgrove
    7855: False,  # The Arcway
    7856: False,  # Tanaan Jungle Flight Bounds
    7875: False,  # Dreadscar Rift
    7877: False,  # Trueshot Lodge
    7879: False,  # Hall of the Guardian
    7884: False,  # The Silver Enclave
    7885: False,  # Antonidas Memorial
    7886: False,  # Dalaran City
    7887: False,  # Circle of Wills
    7888: False,  # The Violet Citadel
    7889: False,  # The Violet Citadel Spire
    7890: False,  # Sewer Exit Pipe
    7891: False,  # Sewer Exit Pipe
    7892: False,  # Dalaran Floating Rocks
    7893: False,  # Sunreaver's Sanctuary
    7894: False,  # Dalaran Island
    7895: False,  # The Violet Hold
    7896: False,  # Runeweaver Square
    7898: False,  # The Eventide
    7899: False,  # Magus Commerce Exchange
    7900: False,  # Vargoth's Retreat
    7901: False,  # Violet Citadel Balcony
    7902: False,  # The Wandering Isle
    7903: False,  # Temple of Five Dawns
    7918: False,  # Dreadscar Rift
    7921: False,  # Stormheim
    7945: False,  # Mardum, the Shattered Abyss
    7952: False,  # Kun-Lai Summit
    7955: False,  # Deepholm
    7960: False,  # Skywall
    7967: False,  # Boost Experience [TEMP NAME]
    7969: False,  # Karazhan
    7974: False,  # Ursoc's Lair
    7976: False,  # Tirisfal Glades
    7979: False,  # Emerald Dreamway
    7996: False,  # Violet Hold
    8005: False,  # Terrace of Endless Spring
    8006: False,  # [TEMP] Tech Test - Seamless World Transition A (JT)
    8007: False,  # [TEMP] Tech Test - Seamless World Transition B (JT)
    8008: False,  # Ashamane's Fall
    8012: False,  # Chamber of Shadows
    8013: False,  # [PH]Mardum Treasures
    8017: False,  # Gloaming Reef
    8022: False,  # Mardum, the Shattered Abyss
    8023: False,  # The Fel Hammer
    8025: False,  # The Nighthold
    8044: False,  # Tirisfal Glades
    8046: False,  # The Maelstrom
    8053: False,  # The Greater Sea (Don't Use)
    8054: False,  # Thal'dranath
    8057: False,  # [TEMP] Dummy Area - Dev Test (JT)
    8058: False,  # Dev Area - A
    8059: False,  # Dev Area - B
    8060: False,  # Dev Area - C
    8061: False,  # Dev Area - D
    8062: False,  # Dev Area - E
    8063: False,  # Dev Area - F
    8064: False,  # The MOTHERLODE!!
    8079: False,  # Court of Stars
    8091: False,  # Nordrassil
    8093: False,  # The Vortex Pinnacle
    8094: False,  # The Beyond
    8098: False,  # Test Dungeon
    8105: False,  # Niskara
    8106: False,  # Abyssal Maw
    8124: False,  # Sword of Dawn
    8125: False,  # Firelands
    8142: False,  # Shadowgore Citadel
    8161: False,  # Ulduar
    8180: False,  # Malorne's Nightmare
    8205: False,  # Realm of the Mage Hunter
    8239: False,  # Black Temple
    8250: False,  # Rescue Koltira
    8252: False,  # The Oculus
    8262: False,  # Temple of the Jade Serpent
    8265: False,  # Karazhan
    8275: False,  # Azuremyst Isle
    8276: False,  # The Veiled Sea
    8277: False,  # The Exodar
    8285: False,  # Scarlet Monastery
    8309: False,  # Tol Barad
    8330: False,  # [TEMP] Placeholder Area - Level Design Land - Wind Test
    8344: False,  # The Crystal Hall
    8347: False,  # Sanctum of Light
    8348: False,  # Shal'dorei Terrace
    8392: False,  # Dalaran Sewers
    8406: False,  # Black Rook Hold
    8422: False,  # Tempest's Roar
    8423: False,  # The Arcway
    8439: False,  # Great Dark Beyond
    8440: False,  # Trial of Valor
    8443: False,  # Return to Karazhan
    8445: False,  # The Great Sea
    8448: False,  # [TEMP] JT Zandalar Swamp
    8449: False,  # xxOLD - Zuldazar City
    8451: False,  # Temple of the White Tiger Flight Bounds
    8457: False,  # Escape from the Vault
    8460: False,  # Death Knight Campaign Flight Bounds
    8469: False,  # The Maelstrom
    8470: False,  # VictorCortisLand
    8473: False,  # Dungeon Blockout
    8474: False,  # Dalaran (Northrend)
    8476: False,  # Viperville
    8479: False,  # Broken Shore DO NOT USE
    8480: False,  # 8DesertCanyonTest
    8482: False,  # Blade's Edge Arena
    8483: False,  # The Eye of Eternity
    8485: False,  # Ashran
    8488: False,  # Underrot
    8489: False,  # Islands
    8490: False,  # Winter AB
    8491: False,  # [TEMP] CV Kul Tiras Island
    8502: False,  # South Seas
    8508: False,  # Arathi Blizzard
    8514: False,  # Gnomeregan
    8518: False,  # The Eye of Eternity
    8520: False,  # The Heartland
    8524: False,  # Tomb of Sargeras
    8525: False,  # Underrot
    8526: False,  # Arathi Basin
    8527: False,  # Cathedral of Eternal Night
    8528: False,  # Wailing Caverns
    8529: False,  # Pit of Saron
    8531: False,  # Stormstout Brewery
    8535: False,  # Dalaran (Deadwind Pass)
    8538: False,  # Twisting Nether
    8546: False,  # Cave of the Bloodtotem
    8549: False,  # The Maelstrom
    8556: False,  # Stratholme
    8561: False,  # The Twisting Nether
    8566: False,  # The Great Sea
    8570: False,  # Val'sharah
    8573: False,  # MSandersTest2016
    8579: False,  # Isle of Blizzcon
    8581: False,  # Assault on Broken Shore
    8582: False,  # AI Test Map 8 - Arathi Basin
    8583: False,  # Black Rook Hold
    8591: False,  # Shwayder's Tavern
    8594: False,  # Halls of Valor
    8596: False,  # Stormheim
    8597: False,  # Battle for Blackrock Mountain
    8598: False,  # Warden Tower TEMP
    8600: False,  # The Great Sea
    8601: False,  # Animation Playground
    8624: False,  # Shado-Pan Showdown
    8625: False,  # Azsuna
    8630: False,  # The Deadmines
    8634: False,  # [TEMP] Hackaton CV
    8635: False,  # The Frozen Throne
    8636: False,  # [TEMP] Hackaton Race
    8637: False,  # [TEMP] Hackaton Race
    8638: False,  # Antorus, the Burning Throne
    8639: False,  # Test Dungeon
    8640: False,  # Coldridge Valley
    8641: False,  # Fields of the Eternal Hunt
    8645: False,  # Halls of Valor
    8646: False,  # Highmountain
    8647: False,  # Gnomeregan
    8651: False,  # Mardum, the Shattered Abyss
    8656: False,  # CharacterTestSpaceArea_ECannon
    8657: False,  # Hall of Communion
    8660: False,  # Throne of the Four Winds
    8661: False,  # [PH] JT Test World
    8665: False,  # Port of Zandalar
    8666: False,  # Grand Bazaar
    8667: False,  # Tal'farrak
    8668: False,  # Tal'aman
    8672: False,  # The Ruby Sanctum
    8676: False,  # The Lost Glacier
    8684: False,  # AI Test Map - Arathi Basin (Debug Version)
    8685: False,  # Warsong Gulch
    8699: False,  # Nazmir [DEVLAND COPY]
    8700: False,  # The Exodar
    8709: False,  # Akazamzarak's Hat
    8712: False,  # The Trial of Style
    8713: False,  # Animation Playground
    8714: False,  # The Vindicaar
    8716: False,  # Proudmoore Keep
    8717: False,  # Boralus Harbor
    8718: False,  # Tradewinds Market
    8726: False,  # Zanchul
    8729: False,  # The Sliver
    8801: False,  # Dustwallow Marsh UNUSED
    8840: False,  # Azuremyst Isle
    8842: False,  # The Exodar
    8910: False,  # The Seat of the Triumvirate
    8911: False,  # Arcatraz
    8915: False,  # The Vindicaar
    8916: False,  # The Vindicaar
    8950: False,  # Ruins of Lordaeron
    8955: False,  # Dev Area - H (copy)
    8956: False,  # Gol Thovas
    8957: False,  # Dev Area - I
    8978: False,  # Tol Dagor
    8979: False,  # Warfronts Prototype Main
    8980: False,  # Endless Halls
    9010: False,  # Shadow of Azeroth
    9012: False,  # Forge of Aeons
    9023: False,  # [Test] Environment Art - Tina 01
    9024: False,  # Invasion Point
    9028: False,  # Atal'Dazar
    9029: False,  # Hozen Island
    9043: False,  # Silithus Brawl
    9051: False,  # The Deaths of Chromie
    9099: False,  # [TEMP] CV JulienTest
    9100: False,  # Invasion Point: Aurinor
    9101: False,  # Tropical Isle 8.0
    9102: False,  # Invasion Point: Naigtal
    9126: False,  # Invasion Point: Cen'gar
    9127: False,  # Invasion Point: Val
    9128: False,  # Invasion Point: Sangua
    9136: False,  # Seething Shore
    9147: False,  # The Old Seawall
    9163: False,  # Julien Test Land
    9164: False,  # Freehold
    9168: False,  # Arathi Highlands
    9172: False,  # Terrace of the Chosen
    9173: False,  # The Zocalo
    9180: False,  # Invasion Point: Bonich
    9183: False,  # RiverZone_Art
    9188: False,  # Telogrus Rift
    9278: False,  # Kul Tiras Arena
    9279: False,  # Hook Point
    9295: False,  # Greater Invasion Point: Matron Folnuna
    9296: False,  # Greater Invasion Point: Pit Lord Vilemus
    9297: False,  # Greater Invasion Point: Inquisitor Meto
    9298: False,  # Greater Invasion Point: Occularus
    9299: False,  # Greater Invasion Point: Sotanathor
    9300: False,  # Greater Invasion Point: Mistress Alluradel
    9313: False,  # Silvermoon City
    9318: False,  # The Sunwell
    9327: False,  # Tol Dagor
    9331: False,  # Gilneas Island
    9354: False,  # Siege of Boralus
    9355: False,  # Little Tortolla
    9359: False,  # The Vindicaar
    9361: False,  # Terrace of the Speakers
    9382: False,  # Sacrificial Pits
    9383: False,  # BlizzCon 2017
    9386: False,  # Allied - Highmountain Tauren Unlock
    9387: False,  # Allied - Lightforged Draenei Unlock
    9388: False,  # Hero Stage LD Demo Area
    9389: False,  # Uldir
    9391: False,  # The Underrot
    9394: False,  # Allied - Orgrimmar
    9395: False,  # Allied - Stormwind
    9396: False,  # Allied - Void Elf Unlock
    9397: False,  # Allied - Nightborne Unlock
    9407: False,  # Ashvane Company Yards
    9415: False,  # Telogrus Rift
    9424: False,  # Waycrest Manor
    9439: False,  # Arathi Highlands
    9440: False,  # Verdant Wilds
    9443: False,  # Titan Island
    9462: False,  # IsleCVTest
    9463: False,  # A Dark Place
    9466: False,  # The Rotting Mire
    9467: False,  # White Mesa Isles
    9468: False,  # IsleCVTest2
    9469: False,  # Un'gol Ruins
    9481: False,  # CursedPrototype
    9483: False,  # Katalina Island
    9485: False,  # Wonderland
    9486: False,  # lost world [ph]
    9488: False,  # Swamp Island
    9489: False,  # Rock Spire
    9496: False,  # Molten Cay
    9497: False,  # Skittering Hollow
    9525: False,  # Shrine of the Storm
    9526: False,  # Kings' Rest
    9527: False,  # Temple of Sethraliss
    9529: False,  # Alliance Airship
    9535: False,  # Francesco test - internal only
    9540: False,  # Snowblossom Village
    9541: False,  # Pandaren Farm Dev
    9548: False,  # Havenswood
    9552: False,  # Quest Training
    9553: False,  # Stormwind City
    9554: False,  # Stormsong Monastery
    9562: False,  # Thornheart
    9564: False,  # The Maiden's Virtue
    9570: False,  # Zuldazar
    9576: False,  # The Dread Chain
    9588: False,  # Hook Point
    9591: False,  # Whispering Reef
    9593: False,  # Unity Square
    9598: False,  # The Great Seal
    9599: False,  # Spirits Be With You
    9602: False,  # Mariner's Row
    9616: False,  # Jorundall
    9627: False,  # Crosswind Commons
    9651: False,  # Model Test World
    9653: False,  # Hall of Communion
    9660: False,  # The Drunken Drummer
    9661: False,  # Lost Spirit Lounge
    9662: False,  # Hot House
    9663: False,  # War Campaign - Alliance
    9664: False,  # War Campaign - Horde
    9665: False,  # Atal'Jani
    9666: False,  # Blackrock Depths
    9667: False,  # Chamber of Heart
    9669: False,  # South Seas
    9679: False,  # Arathi Highlands
    9692: False,  # Damarcus_World
    9698: False,  # Saltstone Mine
    9703: False,  # Allied - Dark Iron Dwarf Unlock
    9704: False,  # Allied - Mag'har Orc Unlock
    9734: False,  # Arathi Highlands
    9764: False,  # Thros, the Blighted Lands
    9765: False,  # Proudmoore Academy
    9771: False,  # Proudmoore Barracks
    9772: False,  # Rastakhan's Might
    9778: False,  # Uncharted Island
    9786: False,  # Gorgrond
    9800: False,  # The Great Sea
    9808: False,  # Eastern Kingdoms
    9826: False,  # Sword of Dawn
    9830: False,  # Tempest's Roar
    9937: False,  # The Great Sea
    9960: False,  # 8.0 Islands - Ship - Player Alliance - Kul'Tiras Medium 01 With Gangplank
    9962: False,  # Watertusk Inn
    9970: False,  # Hall of Strength
    9979: False,  # Dampwick Ward
    9980: False,  # Ashvane Docks
    9992: False,  # Mugambala
    9994: False,  # Chamber of Rezan
    10015: False,  # Tol Dagor
    10022: False,  # Firelands
    10028: False,  # Blackrock Depths
    10034: False,  # Upton Borough
    10041: False,  # The Battle for Stromgarde
    10043: False,  # Tol Dagor
    10047: False,  # Siege of Orgrimmar
    10053: False,  # Arathi Basin
    10057: False,  # Crucible of Storms
    10058: False,  # Darkshore
    10059: False,  # Darkshore
    10061: False,  # [TEMP] Underwater Ideation
    10062: False,  # Test Dungeon - White Area
    10063: False,  # Test Dungeon - Gray Area
    10076: False,  # Battle of Dazar'alor
    10084: False,  # Darkshore
    10085: False,  # The Battle for Darkshore
    10088: False,  # Allied - Zandalari Unlock
    10154: False,  # Dragonblight
    10155: False,  # Icecrown
    10156: False,  # Borean Tundra
    10157: False,  # Sholazar Basin
    10176: False,  # Wintergrasp
    10213: False,  # Nzoth
    10218: False,  # Warsong Gulch
    10222: False,  # Crestfall
    10225: False,  # Operation: Mechagon
    10226: False,  # Darkshore
    10227: False,  # Darkshore
    10260: False,  # Tenebrous Vault
    10261: False,  # Uncharted Territory
    10263: False,  # Gnomeregan
    10266: False,  # Crucible of Storms
    10267: False,  # Questfall
    10270: False,  # Zandalari Treasury
    10271: False,  # Dev Smoketest Area
    10272: False,  # Tol Dagor
    10273: False,  # Shadow Core
    10288: False,  # Darkshore
    10292: False,  # zzOLDBastion
    10348: False,  # Prototype
    10355: False,  # Icecrown Citadel
    10358: False,  # Gnomeregan
    10366: False,  # Halls of Stone
    10367: False,  # Shadow Core
    10378: False,  # Shadow Core
    10380: False,  # Allied - Kul Tiran Unlock
    10397: False,  # Mulgore
    10416: False,  # Abandoned Mines
    10421: False,  # Uldir
    10425: False,  # The Eternal Palace
    10429: False,  # The Prison of Ink
    10430: False,  # Val'sharah
    10431: False,  # The Dreamgrove
    10440: False,  # Arathi Basin
    10448: False,  # Darkest Depths
    10451: False,  # Stratholme
    10456: False,  # The Obsidian Sanctum
    10458: False,  # Alterac Valley
    10473: False,  # Hearthstone Tavern
    10474: False,  # Emerald Dreamway
    10475: False,  # The Emerald Dream
    10476: False,  # Stormwind
    10477: False,  # The Dragon's Spine
    10478: False,  # Twilight Highlands
    10488: False,  # Vision of Stormwind
    10489: False,  # Gilneas City
    10492: False,  # Vision of Orgrimmar
    10497: False,  # The Robodrome
    10501: False,  # Scarlet Halls
    10504: False,  # Chamber of Heart
    10508: False,  # Baine Rescue
    10522: False,  # Ny'alotha, the Waking City
    10524: False,  # The Maelstrom
    10526: False,  # The Eye of Eternity
    10565: False,  # Oribos
    10581: False,  # Darkmaul Citadel
    10582: False,  # Caverns of Time
    10584: False,  # Halls of Origination
    10625: False,  # Durotar
    10638: False,  # Karazhan Catacombs
    10639: False,  # The North Sea
    10713: False,  # Highmountain
    10714: False,  # Stormheim
    10727: False,  # Suramar
    10731: False,  # The Great Sea
    10886: False,  # Deepwind Gorge
    10887: False,  # Solesa naksu [DNT]
    10920: False,  # The Veiled Stair
    10986: False,  # Sinfall
    11012: False,  # Elysian Hold
    11024: False,  # The Jade Forest
    11025: False,  # Valley of the Four Winds
    11026: False,  # Kun-Lai Summit
    11027: False,  # Townlong Steppes
    11054: False,  # The Veiled Stair
    11356: False,  # Continent
    11375: False,  # The Eternal Palace
    11382: False,  # 8.2.5 War Campaign
    11384: False,  # Mogu'shan Palace
    11395: False,  # Mogu'shan Vaults
    11397: False,  # Temple of the Jade Serpent
    11401: False,  # The Dranosh'ar Blockade
    11402: False,  # Orgrimmar
    11403: False,  # Durotar
    11419: False,  # Cinematic Test Map
    11455: False,  # Crapopolis
    11463: False,  # MalDoodadtest
    11464: False,  # MalPestDoodadTest
    11475: False,  # Blackwing Descent
    11476: False,  # EnvArtDevMaldraxxus- Pestilence
    11477: False,  # EnvArtMaldraxxus- Battlefield
    11479: False,  # Crapopolis
    11508: False,  # SinewTestArea
    11539: False,  # Allied - Mechagnome Unlock
    11540: False,  # Alllied - Vulpera Unlock
    12622: False,  # Vale of Eternal Twilight
    12623: False,  # Vale of Eternal Twilight
    12765: False,  # Vision of the Twisting Sands
    12766: False,  # Vision of the Twisting Sands
    12825: False,  # Mechagon City
    12831: False,  # Halls of Atonement
    12837: False,  # Spires of Ascension
    12841: False,  # Theater of Pain
    12842: False,  # Sanguine Depths
    12847: False,  # Bastion - Vignettes
    12848: False,  # Bastion - Treasures
    12857: False,  # Blackrock Depths
    12858: False,  # Heart of the Forest
    12876: False,  # Seat of the Primus
    12882: False,  # Val'sharah
    12883: False,  # Temple of Elune
    12905: False,  # Chamber of Heart
    12916: False,  # The Necrotic Wake
    12952: False,  # Icecrown Citadel
    13195: False,  # The Umbral Forests
    13224: False,  # Castle Nathria
    13228: False,  # Plaguefall
    13308: False,  # Castle Nathria (Scenario)
    13309: False,  # De Other Side
    13329: False,  # The Ember Court
    13334: False,  # Mists of Tirna Scithe
    13343: False,  # Not Doug Land
    13366: False,  # Shattered Grove
    13367: False,  # Queen's Conservatory
    13377: False,  # The North Sea
    13400: False,  # Skoldus Hall
    13403: False,  # The Fracture Chambers
    13404: False,  # The Soulforges
    13409: False,  # Progenitor Zone Area 1
    13411: False,  # Coldheart Interstitia
    13412: False,  # Mort'regar
    13413: False,  # The Upper Reaches
    13416: False,  # DEV Lowlands (DO NOT USE)
    13428: False,  # Empyrean Domain
    13433: False,  # The In-Between
    13462: False,  # Ascension Coliseum
    13469: False,  # Map 2437 [DEV AREA]
    13494: False,  # Level Design [DEV MAP]
    13496: False,  # Chill's Reach
    13497: False,  # The Fracture Chambers
    13506: False,  # awood_dev1
    13507: False,  # sbenyona_dev1
    13532: False,  # Zone2lDoodadtest
    13536: False,  # Zereth Mortis
    13546: False,  # Torghast, Tower of the Damned
    13548: False,  # Boralus Harbor
    13549: False,  # Stormheim
    13553: False,  # Escape from the Maw
    13554: False,  # 10 Canyon
    13556: False,  # Revendreth
    13561: False,  # Sanctum of Domination
    13574: False,  # PTH Test Area
    13575: False,  # The Adamant Vaults
    13576: False,  # Zone2lDoodadtest2
    13580: False,  # Fungal Wasteland
    13581: False,  # Overgrown Canopy
    13582: False,  # Edge of Darkness
    13583: False,  # Lug'thun's Crater
    13585: False,  # Interactive World - Night Test
    13587: False,  # The Maw
    13619: False,  # Ardenweald
    13633: False,  # 9.1 Campaign
    13635: False,  # Zone4TyrholdTest
    13636: False,  # 10 Highlands
    13637: False,  # Skyhold
    13642: False,  # Dragon Isles
    13643: False,  # The Great Sea
    13644: False,  # The Waking Shores
    13645: False,  # Ohn'ahran Plains
    13646: False,  # The Azure Span
    13647: False,  # Thaldraszus
    13699: False,  # Seat of the Archon
    13708: False,  # Plain of Actualization
    13742: False,  # Sepulcher of the First Ones
    13753: False,  # Crypts of the Eternal
    13769: False,  # The Forbidden Reach
    13790: False,  # zsewell
    13802: False,  # Tyrhold Reservoir
    13844: False,  # Traitor's Rest
    13862: False,  # Valdrakken
    13863: False,  # Oribos
    13870: False,  # mesten_dev1
    13891: False,  # Gravid Repose
    13898: False,  # Catalyst Wards
    13928: False,  # Blooming Foundry
    13936: False,  # Marie Lazar Land
    13946: False,  # Marie Lazar Land Panda Farm
    13952: False,  # Locrian Esper
    13954: False,  # The Azure Vault
    13955: False,  # LDNewHire
    13968: False,  # Uldaman
    13970: False,  # Enigma Arena
    13971: False,  # Maldraxxus Coliseum
    13972: False,  # Maldraxxus Coliseum
    13975: False,  # Tirisfal Glades
    13982: False,  # The Nokhud Offensive
    13983: False,  # Tirisfal Glades
    13991: False,  # Brackenhide Hollow
    13992: False,  # The Primalist Future
    13993: False,  # The Gnoll War
    13994: False,  # War of the Shifting Sands
    13995: False,  # Pandaren Revolution
    13996: False,  # The Black Empire
    14009: False,  # The Waking Shores [DNT]
    14011: False,  # Neltharus
    14014: False,  # Content Playground
    14022: False,  # Zaralek Cavern
    14023: False,  # JrzTest
    14030: False,  # Vault of the Incarnates
    14032: False,  # Algeth'ar Academy
    14038: False,  # Env Art Land - Detail Doodad Test
    14045: False,  # Tirisfal Glades
    14063: False,  # Ruby Life Pools
    14082: False,  # Halls of Infusion
    14083: False,  # Enigma Crucible
    14084: False,  # Emerald Dreamway
    14092: False,  # Azmerloth
    14098: False,  # Azmerloth - Timeless Area
    14143: False,  # The Dig
    14144: False,  # Hall of the Keepers
    14149: False,  # Pandaren Revolution - No Man's Land
    14151: False,  # The Gnoll War- No Man's Land
    14152: False,  # War of the Shifting Sands - No Man's Land
    14357: False,  # Arathi Highlands
    14433: False,  # The Forbidden Reach
    14436: False,  # Nokhudon Proving Grounds
    14457: False,  # Sully Test Start
    14459: False,  # Sully Test Plains
    14460: False,  # Sully Test Desert
    14461: False,  # Sully Test Forest
    14484: False,  # 10.2 Devland
    14510: False,  # The Great Sea
    14512: False,  # RebornTree
    14513: False,  # The Rugged Dragonscale
    14514: False,  # Dawn of the Infinite
    14517: False,  # 11Test1
    14518: False,  # The Eastern Glades
    14519: False,  # 10Zone6-Devland
    14523: False,  # 11 Zone3
    14525: False,  # Alterac Valley
    14529: False,  # Emerald Dream
    14615: False,  # 11Test2
    14616: False,  # Darkglow Hollows
    14617: False,  # The Seat of the Aspects
    14618: False,  # Azure Vault (delete me)
    14620: False,  # Blue Dragon Choice
    14643: False,  # Amirdrassil, the Dream's Hope
    14657: False,  # WB New Hires
    14658: False,  # 11Test3
    14661: False,  # 11Test4
    14662: False,  # 11Test5
    14663: False,  # Aberrus, the Shadowed Crucible
    14665: False,  # Khaz Algar
    14667: False,  # The Throughway
    14668: False,  # ZZ_AlexandraDD
    14686: False,  # Professions Land
    14705: False,  # Aberrus, the Shadowed Crucible
    14706: False,  # The Maelstrom
    14707: False,  # Amy Test Forest
    14708: False,  # Amy Test Town
    14709: False,  # Shane Test Area
    14717: False,  # Isle of Dorn
    14723: False,  # 11Test6
    14727: False,  # The Azure Vault
    14730: False,  # Abandoned Creche
    14747: False,  # Zone 4 Dev Land
    14748: False,  # Khaz Algar
    14750: False,  # Dragon Isles
    14751: False,  # The Waking Shores
    14752: False,  # Azj-Kahet
    14753: False,  # City of Threads
    14765: False,  # Twitching Gorge
    14769: False,  # The Maddening Deep
    14770: False,  # Azmerloth
    14771: False,  # Dornogal
    14776: False,  # The Proscenium
    14795: False,  # The Ringing Deeps
    14838: False,  # Hallowfall
    14840: False,  # A.Z.E.R.O.T.H.
    14841: False,  # Azq'roth
    14842: False,  # Ulderoth
    14843: False,  # Azewrath
    14844: False,  # Azmourne
    14845: False,  # The Warlands
    14846: False,  # Ulderoth
    14849: False,  # Halls of Valor
    14853: False,  # Test Dungeon
    14855: False,  # 11Test7
    14872: False,  # Scarlet Monastery
    14882: False,  # Darkflame Cleft
    14883: False,  # The Stonevault
    14908: False,  # 11.0 - Underground Test
    14936: False,  # The Nighthold
    14938: False,  # The Rookery
    14954: False,  # Priory of the Sacred Flame
    14957: False,  # Fungal Folly
    14962: False,  # De Other Side
    14963: False,  # Dev Map - Quest Training
    14966: False,  # Dev Map - Exile's Reach
    14967: False,  # Dev Map - Zereth Mortis
    14968: False,  # Dev Map - Mechagon
    14969: False,  # Amirdrassil
    14970: False,  # The Black Empire
    14971: False,  # The Dawnbreaker
    14979: False,  # City of Threads
    14980: False,  # Nerub-ar Palace
    14987: False,  # James's Dynamic Mount Testground
    14990: False,  # Deephaul Ravine
    14998: False,  # Mycomancer Cavern
    14999: False,  # Earthcrawl Mines
    15000: False,  # Kriegval's Rest
    15001: False,  # Zekvir's Lair
    15002: False,  # The Waterworks
    15003: False,  # The Dread Pit
    15004: False,  # Skittering Breach
    15005: False,  # Nightfall Sanctum
    15006: False,  # The Sinkhole
    15007: False,  # The Spiral Weave
    15008: False,  # Tak-Rethan Abyss
    15009: False,  # The Underkeep
    15010: False,  # The Timeways
    15011: False,  # FX - Test Dungeon
    15027: False,  # 2510 Coreway
    15028: False,  # Aberrus, the Shadowed Crucible
    15041: False,  # Felwood
    15048: False,  # Hall of Awakening
    15051: False,  # Chamber of Heart
    15052: False,  # Darkflame Cleft
    15055: False,  # zzoldPriory of the Sacred Flame
    15058: False,  # Arathi Highlands
    15083: False,  # Brew Bay
    15093: False,  # Ara-Kara, City of Echoes
    15098: False,  # The High Gate
    15103: False,  # Cinderbrew Meadery
    15105: False,  # Amirdrassil
    15109: False,  # Sound Room - Audio Smoketest
    15133: False,  # Awakening The Machine
    15134: False,  # The Burrows
    15145: False,  # Hallowfall
    15175: False,  # The Sinkhole
    15177: False,  # Dalaran
    15180: False,  # 11.0 warband camp
    15327: False,  # Tak-Rethan Abyss
    15342: False,  # Hall of Awakening
    15343: False,  # KVigue Test
    15387: False,  # Warband Camp
    15513: False,  # Pocket Dimension
    15525: False,  # The Great Sea
    15667: False,  # Delves
}
