local myname, ns = ...

ns.RegisterPoints(507, { -- Isle of Giants
    [50005700] = { label="Oondasta",
        quest=32519,
        npc=69161,
        loot={
            {94228,mount=533,}, -- Reins of the Cobalt Primordial Direhorn
            95601, -- Shiny Pile of Refuse
        },
        atlas="VignetteKillElite", scale=1.2,
    },
    [77608220] = { label="War-God Dokah",
        quest=nil,
        npc=70096,
        loot={
            94159, -- Small Bag of Zandalari Supplies
            94158, -- Big Bag of Zandalari Supplies
        },
    },
    [32685411] = { label="Ku'ma",
        label="{npc:70022:Ku'ma}",
        loot={
            {94190, pet=true, requires=ns.conditions.Item(94288, 999)}, -- Spectral Porcupette
            {94290, mount=true, requires=ns.conditions.Item(94288, 9999)}, -- Reins of the Bone-White Primal Raptor
        },
        showallloot=true,
        atlas="banker",
        minimap=true,
        path=27215804,
    }
})
