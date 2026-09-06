local myname, ns = ...

local COURT = ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50)

-- Treasures

ns.RegisterPoints(ns.EVERSONGWOODS, {
	[38907607] = { label="Triple-Locked Safebox",
		criteria=111472, quest=93456, loot={{243106, decor=true}, COURT}, vignette=7365, -- Gemmed Eversong Lantern
		note="Pick up the torch, and find three keys in the village",
		related={
			[37637481] = {loot={258768}, inbag=258768, minimap=true, requires=ns.conditions.AuraActive(1263972),}, -- Battered Safebox Key
			[38467346] = {loot={258769}, inbag=258769, minimap=true, requires=ns.conditions.AuraActive(1263972),}, -- Worn Safebox Key
			[40257582] = {loot={258770}, inbag=258770, minimap=true, requires=ns.conditions.AuraActive(1263972),}, -- Tarnished Safebox Key
			color={r=0.6,g=0.6,b=1},
		},
		atlas="VignetteLootElite", scale=1.3,
	},
	[40961945] = { label="Gift of the Phoenix",
		criteria=111473, quest=93544, -- 93545 for placing
		loot={{263211, decor=true}, COURT}, -- Gilded Eversong Cup
		note="Take {spell:1264567:Sunstrider Vessel}, catch 5x{spell:1264565:Phoenix Cinders}",
		vignette=7395,
	},
	[43286948] = {criteria=111474, quest=93893, loot={{262616, decor=true}, COURT}, vignette=7424, note="Upper floor",}, -- Forgotten Ink and Quill
	[44624555] = {criteria=111475, quest=93908, loot={265828, COURT}, vignette=7429, note="Upper floor",}, -- Gilded Armillary Sphere
	[52344543] = {criteria=111476, quest=93455, loot={265814, COURT}, vignette=7364, note="Ground floor",}, -- Antique Nobleman's Signet Ring
	[60696729] = {criteria=111477, quest=93457, loot={265816, COURT}, vignette=7366,}, -- Farstrider's Lost Quiver
	[40446090] = {criteria=111478, quest=93061, loot={{251912, decor=true}, COURT}, vignette=7344, note="On floating platform; pick 10x{item:256232:Bunch of Ripe Grapes}, then get {item:256397:Packet of Instant Yeast} from {npc:251405:Sheri} nearby"}, -- Stone Vat of Wine (also: 86645)
	[48747544] = {criteria=111479, quest=91358, loot={{246314, pet=4974}, COURT}, vignette=7041,}, -- Burbling Paint Pot
}, {
	achievement=61960,
})
ns.RegisterPoints(ns.SILVERMOONCITY, {
	[24346928] = { label="Rookery Cache",
		criteria=111471, quest=93967, -- 94626 for giving the meat
		loot={{267838, pet=true}, COURT}, -- Sunwing Hatchling
		note="In floating building; buy {item:265674:Tasty Meat} from {npc:258550:Farstrider Aerieminder}, give it to the {npc:257049:Mischevious Chick}; may need to relog to be able to place it",
		vignette=7437,
	},
}, {
	achievement=61960,
	parent=true,
})

ns.RegisterPoints(ns.SILVERMOONCITY, {
	[37805238] = { label="Incomplete Book of Sonnets",
		label="{item:265832:Incomplete Booklet of Sonnets}",
		quest=94781,
		loot={{245282, decor=true}}, -- Silvermoon Library Bookcase
		related={
			[40768843] = {loot={265833}, minimap=true, inbag={265833, 265832, any=true}, note="Lower level, on a bridge"}, -- Page 1
			[33299019] = {loot={265834}, minimap=true, inbag={265834, 265832, any=true}, note="Lower level"}, -- Page 2
			[39828048] = {loot={265835}, minimap=true, inbag={265835, 265832, any=true},}, -- Page 3
		},
		vignette=7499,
		atlas="VignetteLootElite", scale=1.3,
	},
}, {
	parent=true,
})

-- Runestone Rush
ns.RegisterPoints(ns.EVERSONGWOODS, {
	-- not 100% on which vignette is which
	[47365864] = {criteria=111480, npc=241578, vignette=6951}, -- Elrendar River Runestone, Sapmaw the Infestor
	[38365554] = {criteria=111481, npc=244142, vignette=6955}, -- Ath'ran Runestone, Commander Viskaj
	[61776177] = {criteria=111482, npc=244432, vignette=6954}, -- Dawnstar Spire Runestone, Hal'nok the Trampler
	[41137383] = {criteria=111483, npc=246145, vignette=6959}, -- Sanctum of the Moon Runestone, Commander Gravok
	[40481361] = {criteria=111484, npc=245611, vignette=7130}, -- Sunstrider Isle Runestone, Claw of the Void
}, {
	achievement=61961,
	-- quest=96527, -- completes when you kill the boss regardless of which runestone
	note="Charge the runestone, complete the event",
	atlas="poi-saltherilssoiree", scale=1.2, minimap=true,
})

-- Ever Painting
ns.RegisterPoints(ns.EVERSONGWOODS, {
	[53967561] = {criteria=111993, --[[object=621707]]}, -- Sway of Red and Gold
	[41805634] = {criteria=112030, --[[object=621734]]}, -- Lost Lamppost
	[50754126] = {criteria=112031, --[[object=621762]]}, -- Anar'alah Belore
	[55135967] = {criteria=112032, note="In the floating building" --[[object=621732]]}, -- Light Consuming
	[46066428] = {criteria=112033, --[[object=621700]]}, -- Babble and Brook
	[39007823] = {criteria=112034, --[[object=621709]]}, -- Memories of Ghosts
	[42636262] = {criteria=112035, --[[object=621711]]}, -- Elrendar's Song
}, {
	achievement=62185,
	texture=ns.atlas_texture("Vehicle-SilvershardMines-MineCartBlue", {r=1, g=1, b=0}), scale=1.2, minimap=true,
})


-- Rares

local loot_shared={
	251788, -- Gift of Light
	251791, -- Holy Retributor's Order
	{257147, mount=true}, -- Cobalt Dragonhawk
	{257156, mount=true}, -- Cerulean Hawkstrider
}

-- A Bloody Song
ns.RegisterPoints(ns.EVERSONGWOODS, {
	[51397502] = { label="Warden of Weeds",
		criteria=110166, quest=91280,
		npc=246332,
		loot={
			264520, -- Warden's Leycrook
			264613, -- Steelbark Bulwark
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94681}),
		},
		vignette=7363,
		note="Wanders",
	},
	[44767846] = { label="Harried Hawkstrider",
		criteria=110167, quest=91315,
		npc=246633,
		loot={
			264521, -- Striderplume Focus
			264522, -- Striderplume Armbands
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94682}),
		},
		vignette=7002,
		note="Runs around nearby",
	},
	[54716019] = { label="Overfester Hydra",
		criteria=110168, quest=92392,
		npc=240129,
		loot={
			264523, -- Hydrafang Blade
			264524, -- Lightblighted Verdant Vest
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94684}),
		},
		vignette=7300, -- Dormant Lightbloom Hydra
	},
	[62964878] = { label="Cre'van",
		criteria=110170, quest=92391,
		npc=250719,
		loot={
			264573, -- Taskmaster's Sadistic Shoulderguards
			264647, -- Cre'van's Punisher
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94686}),
		},
		vignette=7299, -- Cre'van, Cruel Taskmaster
		note="Wanders the camp a bit",
	},
	[36333636] = { label="Coralfang",
		criteria=110171, quest=92389,
		npc=250683,
		loot={
			264602, -- Abyss Coral Band
			264629, -- Coralfang's Hefty Fin
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94687}),
		},
		vignette=7298,
	},
	[36657719] = { label="Lady Liminus",
		criteria=110172, quest=92393,
		npc=250754,
		loot={
			264612, -- Tarnished Gold Locket
			264645, -- Aged Farstrider Bow
			260655, -- Decaying Humanoid Flesh
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94688}),
		},
		vignette=7301,
	},
	[40408532] = { label="Terrinor",
		criteria=110173, quest=92409,
		npc=250876,
		loot={
			264537, -- Winged Terror Gloves
			264546, -- Bat Fur Boots
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94689}), --v
		},
		vignette=7306,
	},
	[49048777] = { label="Bad Zed",
		criteria=110174, quest=92404,
		npc=250841,
		loot={
			264536, -- Zedling Summoning Collar
			264621, -- Bad Zed's Worst Channeler
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94690}),
		},
		vignette=7305,
	},
	[34812098] = { label="Waverly",
		criteria=110175, quest=92395,
		npc=250780, -- 250788 for Lovely Sunflower
		loot={
			264608, -- String of Lovely Blossoms
			264910, -- Shell-Cleaving Poleaxe
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94691}), --v
		},
		vignette=7302,
	},
	[56427760] = { label="Banuran",
		criteria=110176, quest=92403,
		npc=250826,
		loot={
			264526, -- Supremely Slimy Sash
			264552, -- Frogskin Grips
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94692}),
		},
		vignette=7304,
	},
	[59107924] = { label="Lost Guardian",
		criteria=110177, quest=92399,
		npc=250806,
		loot={
			264555, -- Splintered Hexwood Clasps
			264575, -- Hexwood Helm
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94693}),
		},
		vignette=7303,
	},
	[42436906] = { label="Duskburn",
		criteria=110178, quest=93550,
		npc=255302,
		loot={
			264569, -- Void-Gorged Kickers
			264594, -- Netherscale Cloak
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94694}),
		},
		vignette=7396,
	},
	[51694601] = { label="Malfunctioning Construct",
		criteria=110179, quest=93555,
		npc=255329,
		loot={
			264584, -- Stonecarved Smashers
			264603, -- Guardian's Gemstone Loop
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94695}), --v
		},
		vignette=7399,
	},
	[45873904] = { label="Dame Bloodshed",
		criteria=110180, quest=93561,
		npc=255348,
		loot={
			{265609, pet=true}, -- Princess Bloodshed
			264595, -- Lynxhide Shawl
			264624, -- Fang of the Dame
			ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94696}),
		},
		note="Wanders",
		vignette=7404,
	},
}, {
	achievement=61507,
	loot_shared=loot_shared,
})

-- Bloated Snapdragon
ns.RegisterPoints(ns.EVERSONGWOODS, {
	-- Normal
	[36566407] = {requires=ns.conditions.NotAreaPoi(ns.EVERSONGWOODS, 8758)},
	-- Void invasions (8615 for the ritual site would probably also work?)
	[37696427] = {requires=ns.conditions.AreaPoi(ns.EVERSONGWOODS, 8758)},
}, {
	achievement=61507,
	criteria=110169, quest=92366,
	npc=250582,
	loot={
		264543, -- Snapdragon Pantaloons
		264560, -- Sharpclaw Gauntlets
		260647, -- Digested Human Hand
		ns.rewards.Currency(ns.CURRENCY_SILVERMOONCOURT, 50, {quest=94685}),
	},
	loot_shared=loot_shared,
	vignette=7294,
})