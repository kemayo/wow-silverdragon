local myname, ns = ...

ns.RegisterPoints(ns.MULGORE, {
	[40401700] = { label="Enforcer Emilgund",
		quest=nil,
		npc=5787,
		loot={
			284361, -- Venture Company Legguards
		},
	},
	[39502390] = { label="Ghost Howl",
		-- [39502390, 48002410]
		quest=nil,
		npc=3056,
		loot={
			{4854,quest=770,}, -- Demon Scarred Cloak
		},
	},
	[39404420] = { label="Mazzranache",
		-- [35404720, 37104840, 38204380, 39404420, 40004400, 40604970, 41004320, 54204340]
		quest=nil,
		npc=3068,
		loot={
			4861, -- Sleek Feathered Tunic
		},
	},
	[35805720] = { label="Mokwa",
		-- [35205720, 35205760, 35605760, 35805720, 36005620, 36605660, 37805560, 37805680]
		quest=nil,
		npc=205382,
	},
	[37602060] = { label="Sister Hatelash",
		quest=nil,
		npc=5785,
		loot={
			4772, -- Warm Cloak
		},
	},
	[48507200] = { label="Snagglespear",
		-- [47707290, 47907160, 48107090, 48507200, 48607140, 51707420, 53207220, 53207300, 53607300, 53807240]
		quest=nil,
		npc=5786,
	},
	[33006380] = { label="Snarlsnout",
		-- [32206560, 32406360, 32606560, 33006380, 33006470, 33206340, 33606320]
		quest=nil,
		npc=276109,
		loot={
			286753, -- Snarlsnout Shooter
		},
	},
	[60205860] = { label="Stormherald Ukta",
		-- [59405740, 60005820, 60205860, 60405970, 60605880]
		quest=nil,
		npc=276105,
		loot={
			286754, -- Ukta's Conduit
		},
	},
	[49902630] = { label="The Rake",
		-- [48401700, 49401500, 49902630, 51302670, 51803080]
		quest=nil,
		npc=5807,
		loot={
			17922, -- Lionfur Armor
		},
	},
	[59303110] = { label="Thornstarter Igleg",
		-- [58403340, 59003040, 59203160, 59303110, 59603100]
		quest=nil,
		npc=276108,
		loot={
			286752, -- Igleggings
		},
	},
	[38205420] = { label="Wandering Swordsman",
		-- [38005500, 38205420, 40405280, 40605320, 45403640, 45603640, 52003920, 60206740, 60206760]
		quest=nil,
		npc=203079,
		additional={45403640, 60206740},
	},
})
