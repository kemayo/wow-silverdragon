local myname, ns = ...

ns.RegisterPoints(ns.MOUNTHYJAL, {
	[59604920] = {
		-- Blizzard is back to their classical "random NPCs are rare" days
		quest=nil,
		label="{npc:266901:Pexmit}",
		loot={
			251468, -- Plans: Bold Dirk
			252877, -- Pattern: Tooled Leather Armor
			252933, -- Pattern: Supple Scorpid Vest
			254124, -- Pattern: Runecloth Cuffs
			255729, -- Manual: Major Healing Potion
			264233, -- Schematic: Dimensional Transporter: Mt. Hyjal
		},
		atlas="banker",
	},
})

-- Rares

ns.RegisterPoints(ns.MOUNTHYJAL, {
	[71805420] = { label="Bannerwing Survivor",
		quest=nil,
		npc=256830,
	},
	[23605480] = { label="Death Wailer",
		-- [21405800, 22605280, 22605660, 22805580, 23004880, 23605480, 24004920, 26005300, 27605420]
		quest=nil,
		npc=249226,
	},
	[48003100] = { label="Jezerelle the Swaying",
		-- [47603240, 48003100, 48403040]
		quest=nil,
		npc=255183,
	},
	[60603620] = { label="Legion Hulk",
		quest=nil,
		npc=249238,
	},
	[54006880] = { label="Old Rusthowl",
		-- [54006880, 54606780]
		quest=nil,
		npc=263935,
	},
	[51407260] = { label="Overseer Myoleth",
		-- [50607400, 51207240, 51407260, 51607280, 52007220]
		quest=nil,
		npc=260823,
	},
})
