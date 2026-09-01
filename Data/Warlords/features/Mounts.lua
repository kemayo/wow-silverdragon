local myname, ns = ...

-- mount runners

local mount = ns.nodeMaker{ atlas="VignetteKillElite", scale=1.2, }

local pathrunner = mount{ npc=50883, loot={116773},} -- Pathrunner
ns.RegisterPoints(539, {
    [38803640] = pathrunner,
    [42603080] = pathrunner,
    [44404340] = pathrunner,
    [45806860] = pathrunner,
    [52803100] = pathrunner,
    [56205240] = pathrunner,
})

local poundfist = mount{ npc=50985, loot={116792},} -- Poundfist
ns.RegisterPoints(543, {
    [40602580] = poundfist,
    [43205550] = poundfist,
    [45404750] = poundfist,
    [48405680] = poundfist,
    [51404310] = poundfist,
})

local nakk = mount{ npc=50990, loot={116659},} -- Nakk the Thunderer
local lukhok = mount{ npc=50981, loot={116661},} -- Luk'hok
ns.RegisterPoints(550, {
    [48803420] = nakk,
    [54403540] = nakk,
    [60203280] = nakk,
    [62201500] = nakk,
    [64402040] = nakk,
    [65604180] = lukhok,
    [71005660] = lukhok,
    [76003000] = lukhok,
    [77404060] = lukhok,
    [79205680] = lukhok,
    [83806480] = lukhok,
})

local gorok = mount{ npc=50992, loot={116674},} -- Gorok
ns.RegisterPoints(525, {
    [22406620] = gorok,
    [51205020] = gorok,
    [57401820] = gorok,
    [63407960] = gorok,
    [64605200] = gorok,
})

local silthide = mount{ npc=51015, loot={116767},} -- Silthide
ns.RegisterPoints(535, {
    [51408120] = silthide,
    [61803120] = silthide,
    [62004540] = silthide,
    [67206040] = silthide,
    [78405500] = silthide,
})

-- Voidtalon

local voidtalon = {
    quest=37864,
    loot={{121815,mount=682,}},
    atlas="vehicle-templeofkotmogu-purpleball", scale=1.2, minimap=true,
    note="Rarely spawning Edge of Reality portal",
}
ns.RegisterPoints(525, { -- FrostfireRidge
    [51001990] = voidtalon,
    [52301830] = voidtalon,
    [53841721] = voidtalon,
    [47702750] = voidtalon,
})
ns.RegisterPoints(543, { -- Gorgrond
    -- Voidtalon
    [51603880] = voidtalon,
    [54004500] = voidtalon,
    [56004000] = voidtalon,
    [43203420] = voidtalon,
})
ns.RegisterPoints(550, { -- NagrandDraenor
    [57302670] = voidtalon,
    [45903140] = voidtalon,
    [40504750] = voidtalon,
})
ns.RegisterPoints(539, { -- ShadowmoonValleyDR
    -- Voidtalon
    [49607160] = voidtalon,
    [43207100] = voidtalon,
    [50907250] = voidtalon,
    [41907570] = voidtalon,
    [48706990] = voidtalon,
    [46607000] = voidtalon,
})
ns.RegisterPoints(542, { -- SpiresOfArak
    [47002010] = voidtalon,
    [50400610] = voidtalon,
    [60801120] = voidtalon,
    [36501820] = voidtalon,
})
ns.RegisterPoints(535, { -- Talador
    [47004800] = voidtalon,
    [39705540] = voidtalon,
    [51904120] = voidtalon,
    [46205260] = voidtalon,
})
