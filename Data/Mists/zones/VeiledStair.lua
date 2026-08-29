local myname, ns = ...

ns.RegisterPoints(433, { -- Veiled Stair, TheHiddenPass
    [74937648] = ns.riches{ loot={86473}, quest=31428, }, -- The Hammer of Folly
    [55107200] = ns.junk{ label="Forgotten Lockbox", quest=31867, },
})

ns.RegisterPoints(433, { -- The Veiled Stair
    [62407460] = { label="Willy Wilder",
        quest=nil,
        npc=70126,
        loot={93194}, -- Bloodied Scroll
        routes={{62407460, 55607360}},
    },
})
