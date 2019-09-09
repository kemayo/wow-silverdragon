#!/usr/bin/python

# This is here because wowhead doesn't expose zoneids anywhere, that I could see.

zoneid_ignore = {
}

# wowdb and wowhead use the same numeric zoneids, which aren't in-game mapids
zoneid_to_mapid = {
    1: 1426,  # Dun Morogh
    3: 1418,  # Badlands
    4: 1419,  # Blasted Lands
    8: 1435,  # Swamp of Sorrows
    10: 1431,  # Duskwood
    11: 1437,  # Wetlands
    12: 1429,  # Elwynn Forest
    14: 1411,  # Durotar
    15: 1445,  # Dustwallow Marsh
    16: 1447,  # Azshara
    17: 1413,  # The Barrens
    28: 1422,  # Western Plaguelands
    33: 1434,  # Stranglethorn Vale
    36: 1416,  # Alterac Mountains
    38: 1432,  # Loch Modan
    40: 1436,  # Westfall
    41: 1430,  # Deadwind Pass
    44: 1433,  # Redridge Mountains
    45: 1417,  # Arathi Highlands
    46: 1428,  # Burning Steppes
    47: 1425,  # The Hinterlands
    51: 1427,  # Searing Gorge
    85: 1420,  # Tirisfal Glades
    130: 1421,  # Silverpine Forest
    139: 1423,  # Eastern Plaguelands
    141: 1438,  # Teldrassil
    148: 1439,  # Darkshore
    215: 1412,  # Mulgore
    267: 1424,  # Hillsbrad Foothills
    331: 1440,  # Ashenvale
    357: 1444,  # Feralas
    361: 1448,  # Felwood
    400: 1441,  # Thousand Needles
    405: 1443,  # Desolace
    406: 1442,  # Stonetalon Mountains
    440: 1446,  # Tanaris
    490: 1449,  # Un'Goro Crater
    493: 1450,  # Moonglade
    618: 1452,  # Winterspring
    1377: 1451,  # Silithus
    1497: 1458,  # Undercity
    1519: 1453,  # Stormwind City
    1537: 1455,  # Ironforge
    1637: 1454,  # Orgrimmar
    1638: 1456,  # Thunder Bluff
    1657: 1457,  # Darnassus
    2597: 1459,  # Alterac Valley
    3277: 1460,  # Warsong Gulch
    3358: 1461,  # Arathi Basin
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
    207: False,  # The Great Sea
    209: False,  # Shadowfang Keep
    257: False,  # Shadowthread Cave
    258: False,  # Fel Rock
    262: False,  # Ban'ethil Barrow Den
    360: False,  # The Venture Co. Mine
    365: False,  # Burning Blade Coven
    371: False,  # Dustwind Cave
    457: False,  # The Veiled Sea
    491: False,  # Razorfen Kraul
    540: False,  # The Slithering Scar
    717: False,  # The Stockade
    718: False,  # Wailing Caverns
    719: False,  # Blackfathom Deeps
    721: False,  # Gnomeregan
    722: False,  # Razorfen Downs
    796: False,  # Scarlet Monastery
    800: False,  # Coldridge Pass
    817: False,  # Skull Rock
    818: False,  # Palemane Rock
    981: False,  # The Gaping Chasm
    982: False,  # The Noxious Lair
    1176: False,  # Zul'Farrak
    1337: False,  # Uldaman
    1397: False,  # Emerald Forest
    1417: False,  # Sunken Temple
    1477: False,  # The Temple of Atal'Hakkar
    1517: False,  # Uldaman
    1581: False,  # The Deadmines
    1583: False,  # Blackrock Spire
    1584: False,  # Blackrock Depths
    1941: False,  # Caverns of Time
    1977: False,  # Zul'Gurub
    2017: False,  # Stratholme
    2057: False,  # Scholomance
    2100: False,  # Maraudon
    2159: False,  # Onyxia's Lair
    2257: False,  # Deeprun Tram
    2300: False,  # Caverns of Time
    2437: False,  # Ragefire Chasm
    2557: False,  # Dire Maul
    2677: False,  # Blackwing Lair
    2717: False,  # Molten Core
    3428: False,  # Ahn'Qiraj
    3429: False,  # Ruins of Ahn'Qiraj
    3446: False,  # Twilight's Run
    3456: False,  # Naxxramas
}
