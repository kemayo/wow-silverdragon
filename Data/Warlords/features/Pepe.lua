local myname, ns = ...

local pepe = ns.nodeMaker{ achievement=10053, minimap=true, icon=true, }

ns.RegisterPoints(543, { -- Gorgrond
    [47504130]={ quest=39267, loot={127867}, achievement=10053, criteria=28182, }, -- Ninja Pepe
})
ns.RegisterPoints(550, { -- NagrandDraenor
    [80105040]={ quest=39265, loot={127865}, achievement=10053, criteria=28184, }, -- Viking Pepe
})
ns.RegisterPoints(542, { -- SpiresOfArak
    [54108360]={ quest=39268, loot={127870}, achievement=10053, criteria=28185, }, -- Pirate Pepe
})
ns.RegisterPoints(535, { -- Talador
    [51006330]={ quest=39266, loot={127869}, achievement=10053, criteria=28183, }, -- Knight Pepe
})
