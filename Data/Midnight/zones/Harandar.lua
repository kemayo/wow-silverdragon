local myname, ns = ...

--[[ TODO:
Chronicler of the Haranir: 61344
]]

ns.RegisterPoints(ns.HARANDAR, {
	[50225197] = {
		achievement=61860,
		-- quest=94046,
		atlas="MiniMap-QuestArrow", scale=1.5,
		note="Fly as high as you can",
	},
	[66152547] = {
		label="{npc:242358:Kuri}",
		loot={
			{256424, mount=2749}, -- Echo of Aln'sharan
		},
		note="Bring her 500x {item:255826:Mysterious Skyshards}",
		requires=ns.conditions.QuestComplete(90474),
		atlas="banker", minimap=true,
	},
})

local HARATI = ns.rewards.Currency(ns.CURRENCY_HARATI, 50)

-- Treasure

ns.RegisterPoints(ns.HARANDAR, {
	[71693101] = {criteria=109033, quest=92424, loot={{258963, toy=true}, HARATI}, vignette=7308}, -- Failed Shroom Jumper's Satchel
	[47085027] = {criteria=109034, quest=92426, loot={258900, ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 150), HARATI}, vignette=7309}, -- Burning Branch of the World Tree, Charred World Tree Branch
	[73666536] = {criteria=109035, quest=92427, loot={263289, HARATI}, vignette=7311}, -- Sporelord's Fight Prize, Sporelord's Authority
	[62915125] = {criteria=109036, quest=92431, loot={263287, {246416, decor=true}, HARATI}, vignette=7312}, -- Reliquary's Lost Paintbrush, Reliquary-Keeper's Lost Shortbow, Waterlogged Haranir Pigment Bowl
	[55633942] = {criteria=109037, quest=92436, loot={{258903, pet=true}, HARATI}, vignette=7313}, -- Kemet's Simmering Cauldron, Percival
	[26736759] = { label="Impenatrably Sealed Gourd",
		criteria=110255, quest=93508,
		loot={{260730, pet=true}, HARATI}, -- Perturbed Sporebat
		note="Collect {item:260250:Mysterious Purple Fluid}, {item:260251:Mysterious Red Fluid}, combine in the Durable Vase, use to open the Gourd",
		vignette=7394,
		atlas="VignetteLootElite", scale=1.3,
	},
	[51215293] = { label="Gift of the Cycle",
		criteria=110254, quest=93144,
		loot={{259084, toy=true}, HARATI},
		vignette=7351,
		note="Fetch an item at each of the three altars atop the mountains",
		related={
			[51134751] = {label="Altar of Innocence", quest=93130, nearby={51085048, label="{item:256882:A Tattered Ball}"}, color={r=0,g=0.6,b=1}}, -- Child-like Spirit 254030
			[47175314] = {label="Altar of Vigor", quest=93145, nearby={45105412, label="{item:257024:Lost Hunting Knife}"}, color={r=0.6,g=0.6,b=1}}, -- Huntress Spirit 254104
			[51155855] = {label="Altar of Wisdom", quest=93146, nearby={51355599, label="{item:257054:A Rolled-up Pillow}"}, color={r=1,g=0,b=1}}, -- Elder Spirit 254116
			atlas="poi-soulspiritghost", minimap=true,
			note="Fetch the nearby item and give it to the spirit",
		},
		atlas="VignetteLootElite", scale=1.3,
	},
	[46656778] = { label="Sporespawned Cache, Untainted Grove Crawler",
		criteria=110256, quest=93650, -- 93652 for ringing the gong
		loot={{256423, mount=true}, HARATI},
		vignette=7411,
		related={
			[46636784] = {label="Mycelium Gong", quest=93652, note="Grab the {spell:1266347:Fungal Mallet} and ring this", active=ns.conditions.AuraActive(1266347)},
			[41316800] = {label="{spell:1266347:Fungal Mallet}", quest=93652, note="Lower level; take to the Mycelium Gong within 5m"},
			minimap=true,
		},
		note="Fetch the {spell:1266347:Fungal Mallet} and ring the Mycelium Gong",
		atlas="VignetteLootElite", scale=1.3,
	},
	[40642802] = { label="Peculiar Cauldron, Ruddy Sporeglider",
		criteria=110257, quest=93587, loot={{252017, mount=true}, HARATI}, vignette=7410,
		note="Gather 150x {item:260531:Crystallized Resin Fragment} in the water nearby",
		atlas="VignetteLootElite", scale=1.3,
	},
}, {
	achievement=61263,
})
ns.RegisterPoints(ns.HARANDARDEN, {
	[47235078] = {
		criteria=110254, quest=93144,
		loot={{259084, toy=true}, HARATI},
		vignette=7351,
		note="Find altars outside the Den",
		-- translate plays poorly with all the related points
		atlas="VignetteLootElite", scale=1.3,
	},
}, {achievement=61263})

-- Rares

-- Leaf None Behind
ns.RegisterPoints(ns.HARANDAR, {
	[51174530] = { label="Rhazul",
		criteria=109039, quest=91832,
		npc=248741,
		loot={
			264530, -- Grimfur Mittens
			264622, -- Grimfang Shank
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94712}),
		},
		vignette=7139,
	},
	[68014033] = { label="Chironex",
		criteria=109040, quest=92137,
		npc=249844,
		loot={
			264538, -- Translucent Membrane Slippers
			264544, -- Grounded Death Cap
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94713}),
		},
		vignette=7156,
	},
	[67696228] = { label="Ha'kalawe",
		criteria=109041, quest=92142,
		npc=249849,
		loot={
			264553, -- Deepspore Leather Galoshes
			264592, -- Ha'kalawe's Flawless Wing
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94714}),
		},
		note="Wanders",
		vignette=7157,
	},
	[72636926] = { label="Tallcap the Truthspreader",
		criteria=109042, quest=92148,
		npc=249902,
		loot={
			264532, -- Robes of Flowing Truths
			264650, -- Truthspreader's Truth Spreader
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94715}),
		},
		vignette=7158,
	},
	[59934684] = { label="Queen Lashtongue",
		criteria=109043, quest=92154,
		npc=249962,
		loot={
			264566, -- Lashtongue's Leaffroggers
            264571, -- Ironleaf Wristguards
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94716}),
		},
		vignette=7159,
	},
	[64894814] = { label="Chlorokyll",
		criteria=109044, quest=92161,
		npc=249997,
		loot={
			264604, -- Sludgy Verdant Signet
			264626, -- Scepter of Radiant Conversion
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94717}),
		},
		vignette=7161,
	},
	[65653279] = { label="Stumpy",
		criteria=109045, quest=92168,
		npc=250086,
		loot={
			264635, -- Stumpy's Stump
			264578, -- Stumpy's Terrorplate
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94718}), --v
		},
		vignette=7162,
	},
	[56783422] = { label="Serrasa",
		criteria=109046, quest=92170,
		npc=250180,
		loot={
			264568, -- Serrated Scale Gauntlets
			264639, -- Razorfang Hacker
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94719}), --v
		},
		vignette=7163,
	},
	[46353284] = { label="Mindrot",
		criteria=109047, quest=92172,
		npc=250226,
		loot={
			264550, -- Fungal Stalker's Stockings
			264649, -- Mindrot Claw-Hammer
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94720}),
		},
		vignette=7164,
	},
	[40654299] = { label="Dracaena",
		criteria=109048, quest=92176,
		npc=250231,
		loot={
			264562, -- Plated Grove Vest
			264644, -- Crawler's Mindscythe
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94721}),
		},
		vignette=7165,
	},
	[36597516] = { label="Treetop",
		criteria=109049, quest=92183,
		npc=250246,
		loot={
			264633, -- Treetop Battlestave
			264581, -- Bloombark Spaulders
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94722}),
		},
		vignette=7166,
	},
	[28118181] = { label="Oro'ohna",
		criteria=109050, quest=92190,
		npc=250317,
		loot={
			264591, -- Radiant Petalwing's Feather
			264616, -- Lightblighted Sapdrinker
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94723}),
		},
		vignette=7167,
	},
	[27197021] = { label="Pterrock",
		criteria=109051, quest=92191,
		npc=250321,
		loot={
			264567, -- Rockscale Hood
			264576, -- Slatescale Grips
			{264895, class="HUNTER"}, -- Trials of the Florafaun Hunter
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94724}),
		},
		vignette=7168,
	},
	[39696070] = { label="Ahl'ua'huhi",
		criteria=109052, quest=92193,
		npc=250347,
		loot={
			264534, -- Bogvine Shoulderguards
			264540, -- Mirevine Wristguards
			ns.rewards.Currency(ns.CURRENCY_HARATI, 50, {quest=94725}),
		},
		vignette=7171,
	},
	[44501610] = { label="Annulus the Worldshaker",
		criteria=109053, quest=92194,
		npc=250358,
		loot={
			264607, -- Spore-Laden Choker
			264614, -- Fungal Cap Guard
		},
		vignette=7172,
	},
}, {
	achievement=61264,
	loot_shared={
		251782, -- Withered Saptor's Paw
		264968, -- Telluric Leyblossom
		{255826, mount=2749, note="x500"--[[, requires=ns.conditions.QuestComplete(90474)--]]}, -- Mysterious Skyshards
		{246735, mount=true}, -- Rootstalker Grimlynx
		{252012, mount=true}, -- Vibrant Petalwing
	}
})
