local myname, ns = ...

if LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_MIDNIGHT or math.huge) then
	ns.BeginDataModule(nil)
	return
end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

-- Rares, treasures and mob data, curated in SilverDragon's own shape. The ids
-- come from constants.lua; the zone point data below is copied out of
-- HandyNotes_MidnightTreasures (see Data/Midnight/sync.files). ns.RegisterPoints and
-- friends are wired to core in systems/_glue.lua.
ns.BeginDataModule("Midnight")
ns.MAXLEVEL = ns.conditions.Level(90)

-- Treasures

core:RegisterTreasureData("Midnight", {
	-- Junk
	-- Technically these contain some healing potions, grey gear, profession knowledge weekly items, and housing dyes
	-- Eversong
	[6931] = {name="Misplaced Tome", loot={}},
	[7438] = {name="Dead Drop", loot={}},
	[7439] = {name="Coalesced Light", loot={}},
	[7440] = {name="Ranger's Cache", loot={}},
	-- Zul'Aman
	[7044] = {name="Forgotten Amani Cache", loot={}},
	[7336] = {name="Spiritpaw Satchel", loot={}},
	[7337] = {name="Twilight Ordinance", loot={}},
	[7338] = {name="Maisara Vilevessel", loot={}},
	[7339] = {name="Stonewash Supplies", loot={}},
	[7348] = {name="Giant Grab Bag", loot={}},
	[7349] = {name="Shabby Stockpile", loot={}},
	-- Harandar
	[7317] = {name="Fungalcap Crock", loot={}},
	[7318] = {name="Budding Barrel", loot={}},
	[7320] = {name="Leaf-Wrapped Package", loot={}},
	-- Voidstorm
	[7342] = {name="Stashed Singularity Supplies", loot={}},
	[7343] = {name="Mysterious Domanaar Vessel", loot={}},
	-- Naigtal
	[7706] = {name="Hal'hadar Pocket-Storage", loot={}},
	-- Val
	[7707] = {name="Domanaar Storage Vessel", loot={}},
	-- Coiled Isle
	[7704] = {name="Decrepit Cache", loot={}},
	[7705] = {name="Cracked Canopic Jar", loot={}},
	[7712] = {name="Venom-Clotted Bauble", loot={}},
	[7713] = {name="Singing Shell", loot={}},
	-- Vaults of Atal'Utek
	[7654] = {name="Soulcoiler's Cache", loot={}},
	[7655] = {name="Soulcoiler's Trove", loot={}},
}, true)

local moth = {name="Glowing Moth", achievement=61052, loot={ns.rewards.Currency(3385)}}
local moths = {}
for i=7173,7293 do
	moths[i] = moth
end
core:RegisterTreasureData("Midnight", moths, true)

-- Rares

core:RegisterMobData("Midnight", {
	-- World bosses
	[244762] = {
		name="Lu'ashal",
		quest=92560,
		worldquest=92560,
		locations={[ns.EVERSONGWOODS]={}}, -- 45245997
		loot={
			250447, -- Radiant Eversong Scepter
			250451, -- Dawncrazed Beast Cleaver
			250453, -- Scepter of the Unbound Light
			250456, -- Wretched Scholar's Gilded Robe
			250457, -- Devouring Outrider's Chausses
			250458, -- Host Commander's Casque
			250459, -- Bramblestalker's Feathered Cowl
			250462, -- Forgotten Farstrider's Insignia
		},
	},
	[244424] = {
		name="Cragpine",
		quest=92123,
		worldquest=92123,
		locations={[ns.ZULAMAN]={}}, -- 45244790
		loot={
			250446, -- Cragtender Bulwark
			250450, -- Forest Sentinel's Savage Longbow
			250456, -- Wretched Scholar's Gilded Robe
			250457, -- Devouring Outrider's Chausses
			250458, -- Host Commander's Casque
			250459, -- Bramblestalker's Feathered Cowl
			250461, -- Chain of the Ancient Watcher
			250462, -- Forgotten Farstrider's Insignia
		},
	},
	[249776] = {
		name="Thorm'belan",
		quest=92034,
		worldquest=92034,
		locations={[ns.HARANDAR]={}}, -- 39026691
		loot={
			250449, -- Skulking Nettledirk
			250452, -- Blooming Thornblade
			250455, -- Beastly Blossombarb
			250456, -- Wretched Scholar's Gilded Robe
			250457, -- Devouring Outrider's Chausses
			250458, -- Host Commander's Casque
			250459, -- Bramblestalker's Feathered Cowl
			250462, -- Forgotten Farstrider's Insignia
		},
	},
	[248864] = {
		name="Predaxas",
		quest=92636,
		worldquest=92636,
		locations={[ns.VOIDSTORM]={}}, -- 49078651
		loot={
			250448, -- Voidbender's Spire
			250454, -- Devouring Vanguard's Soulcleaver
			250456, -- Wretched Scholar's Gilded Robe
			250457, -- Devouring Outrider's Chausses
			250458, -- Host Commander's Casque
			250459, -- Bramblestalker's Feathered Cowl
			250460, -- Encroaching Shadow Signet
			250462, -- Forgotten Farstrider's Insignia
		},
	},

	[252959] = {
		name="Nymrissa Wavecaller",
		quest=97128,
		worldquest=97128,
		-- areaPoi=8896,
		locations={[ns.COILEDISLE]={}}, -- 59996622
		loot={
			268199, -- Tidepiercer's Bubble Popper
			268217, -- Rising Tide Wristguards
			268221, -- Tidebound Sorcereress's Robes
			268226, -- Swelling Sea Spaulders
			268232, -- Cincture of the Abyssal Grotto
			268238, -- Grips of Swirling Fury
			268244, -- Forgotten Grotto Girdle
			268247, -- Breakwater Boots
			268262, -- Bubblefin Splash Guard
			268263, -- Frostscale's Mystic Frond
			268266, -- Alluring Bubbleband
			270167, -- Wavecaller's Seastone
			{279112, decor=true}, -- Clumped Asteroidea
		},
	},

	--[[
	-- Prepatch, Twilight Highlands / Two Minutes to Midnight
	-- rotation rares:
	-- listen to Umbric gets 92103
	-- first kill seems to get 91468
	[237853] = {name="Berg the Spellfist", locations={[241]={57537539}}, achievement=42300, criteria=105727, vignette=6755, poi={241, 8244}, notes="Next up: {npc:237997}"},
	[237997] = {name="Corla, Herald of Twilight", locations={[241]={70973060}}, achievement=42300, criteria=105730, vignette=6761, poi={241, 8244}, notes="Next up: {npc:246272}"},
	[246272] = {name="Void Zealot Devinda", locations={[241]={46802511}}, achievement=42300, criteria=105733, vignette=6988, poi={241, 8244}, notes="Next up: {npc:246343}"},
	[246343] = {name="Asira Dawnslayer", locations={[241]={45414908}}, achievement=42300, criteria=105737, vignette=6994, poi={241, 8244}, notes="Next up: {npc:246462}"},
	[246462] = {name="Archbishop Benedictus", locations={[241]={42581723}}, achievement=42300, criteria=105740, vignette=6996, poi={241, 8244}, notes="Next up: {npc:246577}"},
	[246577] = {name="Nedrand the Eyegorger", locations={[241]={64905253}}, achievement=42300, criteria=105743, vignette=7008, poi={241, 8244}, notes="Next up: {npc:246840}"},
	[246840] = {name="Executioner Lynthelma", locations={[241]={57537539}}, achievement=42300, criteria=105728, vignette=7042, poi={241, 8244}, notes="Next up: {npc:246565}"},
	[246565] = {name="Gustavan, Herald of the End", locations={[241]={70973060}}, achievement=42300, criteria=105731, vignette=7005, poi={241, 8244}, notes="Next up: {npc:246578}"},
	[246578] = {name="Voidclaw Hexathor", locations={[241]={46812510}}, achievement=42300, criteria=105734, vignette=7009, poi={241, 8244}, notes="Next up: {npc:246566}"},
	[246566] = {name="Mirrorvise", locations={[241]={45414908}}, achievement=42300, criteria=105738, vignette=7006, poi={241, 8244}, notes="Next up: {npc:246558}"},
	[246558] = {name="Saligrum the Observer", locations={[241]={42581723}}, achievement=42300, criteria=105741, vignette=7003, poi={241, 8244}, notes="Next up: {npc:246572}"},
	[246572] = {name="Redeye the Skullchewer", locations={[241]={64905253}}, achievement=42300, criteria=105744, vignette=7007, poi={241, 8244}, notes="Next up: {npc:246844}"},
	[246844] = {name="T'aavihan the Unbound", locations={[241]={57537539}}, achievement=42300, criteria=105729, vignette=7043, poi={241, 8244}, notes="Next up: {npc:246460}"},
	[246460] = {name="Ray of Putrescence", locations={[241]={70973060}}, achievement=42300, criteria=105732, vignette=6995, poi={241, 8244}, notes="Next up: {npc:246471}"},
	[246471] = {name="Ix the Bloodfallen", locations={[241]={46802511}}, achievement=42300, criteria=105736, vignette=6997, poi={241, 8244}, notes="Next up: {npc:246478}"},
	[246478] = {name="Commander Ix'vaarha", locations={[241]={45414908}}, achievement=42300, criteria=105739, vignette=6998, poi={241, 8244}, notes="Next up: {npc:246559}"},
	[246559] = {name="Sharfadi, Bulwark of the Night", locations={[241]={42581723}}, achievement=42300, criteria=105742, vignette=7004, poi={241, 8244}, notes="Next up: {npc:246549}"},
	[246549] = {name="Ez'Haadosh the Liminality", locations={[241]={64905253}}, achievement=42300, criteria=105745, vignette=7001, poi={241, 8244}, notes="Next up: {npc:237853}"},
	-- ephemeral void:
	[253378] = {name="Voice of the Eclipse", locations={[241]={56537321,40051423,48692396,69122952,66975337,47194500,}}, achievement=42300, criteria=109583, vignette=7340, poi={241, 8244},},
	--]]

	-- Ignored
	[250788] = {name="Lovely Sunflower", hidden=true}, -- Waverly's spawn
	[209781] = {name="Empowered Restoration Stone", hidden=true},
}, true)
