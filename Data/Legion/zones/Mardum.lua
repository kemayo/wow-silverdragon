local myname, ns = ...

-- DH starter
ns.RegisterPoints(672, { -- Mardum the Shattered Abyss
    [23065389] = {quest=40797, loot={129210}, label=ns.CHEST_SM, note="Cave entrance @ 23.6, 54.2"},
    [23605420] = ns.path{quest=40797},
    [34857020] = {quest=39970, loot={129210}, label=ns.CHEST_SM},
    [41763761] = {quest=40759, loot={129196}, label=ns.CHEST_SM},
    [42194916] = {quest=40223, loot={129210}, label=ns.CHEST_SM},
    [45017785] = {quest=39971, loot={129192}, label=ns.CHEST_SM},
    [51135079] = {quest=40743, loot={129210}, label=ns.CHEST_SM},
    [63702360] = {quest=40772, loot={129210}, label=ns.CHEST_SM}, -- in soul engine
    [66922767] = {quest=39974, loot={129210}, label=ns.CHEST_SM},
    [69704240] = {quest=39976, loot={129210}, label=ns.CHEST_SM},
    [73494892] = {quest=39975, loot={129195}, label=ns.CHEST_SM},
    [74285453] = {quest=39977, loot={129210}, label=ns.CHEST_SM, note="Cave entrance @ 70.7, 54.0"},
    [70705400] = ns.path{quest=39977},
    [76243899] = {quest=40338, loot={129210}, label=ns.CHEST_SM},
    [78755047] = {quest=40274, loot={129210}, label=ns.CHEST_SM},
    [82075043] = {quest=40820, loot={129196}, label=ns.CHEST_SM},
})
ns.RegisterPoints(673, { -- Cryptic Hollow, Mardum
    [48761530] = {quest=39972, loot={129196}, label=ns.CHEST_SM},
    [54855845] = {quest=39973, loot={128946}, label=ns.CHEST_SM},
})
ns.RegisterPoints(674, { -- Soul Engine, Lower, Mardum
    [46803320] = {quest=40772, loot={129210}, label=ns.CHEST_SM},
})
ns.RegisterPoints(675, {-- Soul Engine, Upper, Mardum
    [49844883] = {quest=40772, loot={129210}, label=ns.CHEST_SM},
})
ns.RegisterPoints(677, { -- Illidari Ward, Vault of the Wardens
    [58693475] = {quest=40909, loot={129210}, label=ns.CHEST_SM},
    [47325464] = {quest=40910, loot={129210}, label=ns.CHEST_SM},
})
ns.RegisterPoints(678, { -- Vault of the Wardens
    [32104817] = {quest=40911, loot={129196}, label=ns.CHEST_SM},
    [41506361] = {quest=40914, loot={129196}, label=ns.CHEST_SM},
    [56994013] = {quest=40913, loot={129210}, label=ns.CHEST_SM},
    [41413287] = {quest=40912, loot={129210}, label=ns.CHEST_SM},
})
ns.RegisterPoints(679, { -- Warden's Court, Vault of the Wardens
    [24421005] = {quest=40915, loot={129210}, label=ns.CHEST_SM},
    [23268157] = {quest=40916, loot={129210}, label=ns.CHEST_SM},
})

-- Rares

ns.RegisterPoints(672, { -- MardumtheShatteredAbyss
    [63502350] = {quest=40231, npc=97058, loot={128948}}, -- Count Nefarious
    [68852760] = {quest=40234, npc=82877, loot={128947}}, -- General Volroth
    [74455730] = {quest=40232, npc=97059, loot={128944}}, -- King Voras
    [81054125] = {quest=40233, npc=97057, loot={133580}}, -- Overseer Brutarg
})
ns.RegisterPoints(674, { -- SoulEngine
    [51255740] = {quest=40231, npc=97058, loot={128948}}, -- Count Nefarious
})
ns.RegisterPoints(677, { -- VaultOfTheWardensDH
    [49553285] = {quest=40251, npc=96997, loot={128945}}, -- Kethrazor
    [68753630] = {quest=40301, npc=97069, loot={128958}}, -- Wrath-Lord Lekos
})
