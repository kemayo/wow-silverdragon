local myname, ns = ...

ns.RegisterPoints(622, { -- AshranAllianceFactionHub
    [45307020] = ns.follower{ loot={ns.rewards.GarrisonFollower(467)}, faction="Alliance", note="Outside the town hall", }, -- Fen Tao
})
ns.RegisterPoints(624, { -- AshranHordeFactionHub
    [47004500] = ns.follower{ loot={ns.rewards.GarrisonFollower(467)}, faction="Horde", note="Outside the inn", }, -- Fen Tao
})
