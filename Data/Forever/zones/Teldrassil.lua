local myname, ns = ...

ns.RegisterPoints(ns.TELDRASSIL, {
	[42802860] = { label="Blackmoss the Fetid",
		-- [42702820, 42802860, 43302680, 43802960, 43902930, 44002820]
		quest=nil,
		npc=3535,
		loot={
			{5179,quest=927,}, -- Moss-twined Heart
			284167, -- Blackmoss Robes
		},
	},
	[58007640] = { label="Duskstalker",
		quest=nil,
		npc=14430,
		loot={
			284165, -- Duskstalker's Hide
		},
	},
	[36403880] = { label="Fury Shelda",
		-- [35203480, 35603540, 36403880, 36404000, 36603980]
		quest=nil,
		npc=14431,
		loot={
			18612, -- Bloody Chain Boots
		},
	},
	[40807920] = { label="Grimmaw",
		-- [40407940, 40407960, 40807920, 41007840, 41007970, 41607820, 41607860, 41807960]
		quest=nil,
		npc=14429,
		loot={
			284166, -- Gnarlpine War Staff
		},
	},
	[47403240] = { label="Mowgh",
		-- [46403260, 47203260, 47403240, 47603260, 48003160, 48203140, 48603140]
		quest=nil,
		npc=209928,
	},
	[40105490] = { label="Nightscreech",
		-- [38202750, 40105490, 40305620, 45603230]
		quest=nil,
		npc=276101,
		loot={
			286750, -- Wisesight Wand
		},
	},
	[51605040] = { label="Threggil",
		-- [51205040, 51205060, 51605040, 52005060, 52005200, 52605220]
		quest=nil,
		npc=14432,
		loot={
			18610, -- Keen Machete
		},
	},
	[67305870] = { label="Uruson",
		-- [66405720, 66405820, 66505690, 66605820, 67305870, 67405960, 67505880, 67605960]
		quest=nil,
		npc=14428,
		loot={
			18611, -- Gnarlpine Leggings
		},
	},
	[39603760] = { label="Wandering Swordsman",
		-- [39603760, 39803740, 39806940, 39806960, 43807700, 54806600, 62407180, 62607180]
		quest=nil,
		npc=203079,
		additional={39806940, 62407180},
	},
	[53407040] = { label="Wrathvine",
		-- [53207060, 53407040, 53706990, 53707090, 56006760, 59607200, 59607260]
		quest=nil,
		npc=276099,
		loot={
			286749, -- Wrathroot
		},
	},
})
