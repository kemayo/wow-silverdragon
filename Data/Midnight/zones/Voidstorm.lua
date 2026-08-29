local myname, ns = ...

--[[ TODO:
Oh, No You Don't!: 61861
]]

local SINGULARITY = ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50)

ns.RegisterPoints(ns.VOIDSTORM, {
	[49947936] = { label="Final Clutch of Predaxas",
		criteria=111863, quest=93237,
		loot={{257446, mount=true}, SINGULARITY}, -- Reins of the Insatiable Shredclaw
		vignette=7355, path=48927833,
		atlas="VignetteLootElite", scale=1.3,
	},
	[25766728] = { label="Void-Shielded Tomb",
		criteria=111864, quest=92414,
		loot={ns.rewards.Item(246951, 20), SINGULARITY}, -- Stormarion Core x20
		note="Drink the potion, then fetch {item:251519:Key of Fused Darkness} from the adjacent building",
		nearby={25976863, worldmap=false, label="{item:251519:Key of Fused Darkness}"},
		vignette=7498,
		atlas="VignetteLootElite", scale=1.3,
	},
	[64537547] = { label="Bloody Sack",
		criteria=111866, quest=93431,
		loot={{267139, toy=true}, SINGULARITY}, -- Hungry Black Hole
		note="Feed it meat",
		vignette=7359, -- Forgotten Oubliette, then 7360 Bloody Sack
	},
	[53364266] = { label="Malignant Chest",
		criteria=111867, quest=93840,
		loot={{264482, decor=true}},
		vignette=7418,
		related={
			[53474321] = {quest=93812}, -- 1
			[52944333] = {quest=93813, hide_before=ns.conditions.QuestComplete(93812)}, -- 2
			[53534388] = {quest=93814, hide_before=ns.conditions.QuestComplete(93813)}, -- 3
			[53234271] = {quest=93815, hide_before=ns.conditions.QuestComplete(93814)}, -- 4
			texture=ns.atlas_texture("playerpartyblip", {r=0.4, g=0, b=1}), worldmap=false, minimap=true,
		},
		atlas="VignetteLootElite", scale=1.3,
	},
	[46927989] = {criteria=111869, quest=94454, loot={{250319, toy=true}, SINGULARITY}, vignette=7455, path=47987850}, -- Forgotten Researcher's Cache, Researcher's Shadowgraft
	[55367542] = {criteria=111871, quest=93553, loot={266075, SINGULARITY}, vignette=7397}, -- Embedded Spear, Harpoon of Extirpation
	[31514450] = {criteria=111872, quest=93500, loot={{266076, pet=true}, SINGULARITY}, vignette=7393}, -- Quivering Egg, Nether Siphoner
	[28337289] = {criteria=111873, quest=93498, loot={266099, SINGULARITY}, vignette=7392, note="Drink the potion, loot the sword"}, -- Exaliburn, Extinguished Exaliburn
	[35774141] = {criteria=111874, quest=93496, loot={266100, SINGULARITY}, vignette=7391}, -- Discarded Energy Pike, Barbed Riftwalker Dirk
	[43018194] = {criteria=111875, quest=93493, loot={266098, SINGULARITY}, vignette=7368}, -- Faindel's Quiver / Slain Scout's Quiver, Faindel's Longbow
	[37696976] = {criteria=111876, quest=93467, loot={{264303, pet=true}, SINGULARITY}, vignette=7367, path=38076874, note="In cave; on upper level"}, -- Half-Digested Viscera
}, {
	achievement=62126,
})
ns.RegisterPoints(2527, { -- Lair of Predaxas
	[23088392] = {criteria=111869, quest=94454, loot={{250319, toy=true}, SINGULARITY}, vignette=7455}, -- Forgotten Researcher's Cache, Researcher's Shadowgraft
}, {
	achievement=62126,
})
ns.RegisterPoints(ns.SLAYERSRISE, {
	[53203222] = { label="Stellar Stash",
		criteria=111868, quest=93996, -- 94005 after pulling out
		loot={{262467, decor=true}, SINGULARITY}, -- Void Elf Round Table
		note="Inside the building; drag objects out 3x",
		vignette=7441,
		atlas="VignetteLootElite", scale=1.3,
	},
	[49052013] = {criteria=111870, quest=94387, loot={266101, SINGULARITY}, vignette=7447}, -- Scout's Pack, Unused Initiate's Bulwark
}, {
	achievement=62126,
	parent=true,
})

ns.RegisterPoints(ns.VOIDSTORM, {
	[24837001] = {
		quest=94742,
		label="Stormarion Cache", -- or "Void-hoarder's Corpse"
		loot={ns.rewards.Item(246951, 10)}, -- Stormarion Core x10
		vignette=7497,
	},
	[39306383] = {
		quest=91308,
		label="Lost Shadowstep Supplies",
		loot={208856}, -- Pocket Lint
		vignette=7000,
	},
	[53406801] = {
		quest=91699,
		label="Unpublished Manuscript",
		loot={246268}, -- A Steamy Romance Novel: Voidlust
		texture=ns.atlas_texture("profession", {r=0.6, g=0, b=1}),
	},
})

-- Rares

local loot_shared = {
	-- 246951, -- Stormarion Core
	251786, -- Ever-Collapsing Void Fissure
	264694, -- Ultradon Cuirass
	264701, -- Cosmic Bell
	{257085, mount=true,}, -- Augmented Stormray
	{260635, mount=true,}, -- Sanguine Harrower
}

-- The Ultimate Predator
ns.RegisterPoints(ns.VOIDSTORM, {
	[29515008] = { label="Sundereth the Caller",
		criteria=111877, quest=90805,
		npc=244272,
		loot={
			264619, -- Nethersteel Spellblade
			264539, -- Robes of the Voidcaller
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94728}),
		},
		vignette=6949,
	},
	[34028218] = { label="Territorial Voidscythe",
		criteria=111878, quest=91050,
		npc=238498,
		loot={
			264565, -- Voidscale Shoulderpads
			264642, -- Carving Voidscythe
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94729}),
		},
		vignette=6961,
	},
	[36308373] = { label="Tremora",
		criteria=111879, quest=91048,
		npc=241443,
		loot={
			264610, -- Escaped Specimen's ID Tag
			264646, -- Specimen Sinew Longbow
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94730}),
		},
		path=37498452, -- or 35678113
		note="In the tunnel",
		vignette=6962,
	},
	[43685151] = { label="Screammaxa the Matriarch",
		criteria=111880, quest=93966,
		npc=256922,
		loot={
			264545, -- Harrower-Claw Grips
			264583, -- Barbute of the Winged Hunter
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94731}),
		},
		vignette=7436,
	},
	[47058063] = { label="Bane of the Vilebloods",
		criteria=111881, quest=93946,
		npc=256923,
		loot={
			264558, -- Vileblood Resistant Sabatons
			264572, -- Netherplate Clasp
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94732}),
		},
		note="In cave",
		vignette=7433,
	},
	[39246394] = { label="Aeonelle Blackstar",
		criteria=111882, quest=93944,
		npc=256924,
		loot={
			264549, -- Ever-Devouring Shoulderguards
			264637, -- Cosmic Hunter's Glaive
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94751}),
		},
		note="In cave at lowest level",
		vignette=7432,
	},
	[37887178] = { label="Lotus Darkblossom",
		criteria=111883, quest=93947,
		npc=256925,
		loot={
			264632, -- Darkblossom's Crook
			264548, -- Sash of Cosmic Tranquility
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94758}),
		},
		vignette=7434,
	},
	[55727945] = { label="Queen o' War",
		criteria=111884, quest=93934,
		npc=256926,
		loot={
			264533, -- Queen's Tentacle Sash
			264601, -- Queen's Eye Band
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94761}),
		},
		note="Use the Crown",
		vignette=7430,
	},
	[48815317] = { label="Ravengerus",
		criteria=111885, quest=93895,
		npc=256808,
		loot={
			264535, -- Leggings of the Cosmic Harrower
			264589, -- Voidfused Wing Cloak
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94763}),
		},
		vignette=7426,
	},
	[35485023] = { label="Bilemaw the Gluttonous",
		criteria=111887, quest=93884,
		npc=256770,
		loot={
			264579, -- Hungering Wristplates
			264623, -- Shredding Fang
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94752}),
		},
		path=35604931,
		vignette=7422,
	},
	[40154119] = { label="Nightbrood",
		criteria=111889, quest=91051,
		npc=245044,
		loot={
			264551, -- Nightbrood's Jaw
			264574, -- Netherterror's Legplates
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94759}),
		},
		vignette=6964,
	},
	[53946272] = { label="Far'thana the Mad",
		criteria=111890, quest=93896,
		npc=256821,
		loot={
			264912, -- Void-Channeler's Spire
			264913, -- Focused Netherslicer
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94755}),
		},
		vignette=7428,
	},
}, {
	achievement=62130,
	loot_shared=loot_shared,
})

ns.RegisterPoints(ns.SLAYERSRISE, {
	[41268981] = { label="Eruundi",
		criteria=111888, quest=91047,
		npc=245182,
		loot={
			264563, -- Eruundi's Wristguards
			264600, -- Ancient Argussian Band
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94754}),
		},
		vignette=6963, -- vignette position APIs don't work on this one...
	},
	[46384093] = { label="Rakshur the Bonegrinder",
		criteria=111886, quest=93953,
		npc=257027,
		loot={
			264561, -- Primal Bonestompers
			264630, -- Colossal Voidsunderer
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94762}),
		},
		vignette=7435,
	},
}, {
	achievement=62130,
	parent=true,
	loot_shared=loot_shared,
})

ns.RegisterPoints(ns.VOIDSTORM, {
	[30066921] = { label="Voidseer Orivane",
		quest=94459,
		npc=248791,
		loot={
			264556, -- Voidforged Cinch
			264628, -- Spear of Nothingness
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94765}),
		},
		vignette=7140,
	},
	[28827024] = { label="The Many-Broken",
		quest=94458,
		npc=248459, -- 248461, 248462
		loot={
			264577, -- Crystalforged Boots
			264651, -- Resonating Traumatizer
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94764}),
		},
		vignette=7133,
	},
	[28156593] = { label="Abysslick",
		quest=94462,
		npc=248700,
		loot={
			264596, -- Voidthread Veil
			264634, -- Spire of Flowing Void
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94750}),
		},
		vignette=7138,
	},
	[29796799] = { label="Nullspiral",
		quest=94460,
		npc=248068,
		loot={
			264531, -- Shadowthread Slippers
			264588, -- Shawl of Cosmic Whispers
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94760}),
		},
		vignette=7129,
	},
	[24736793] = { label="Blackcore",
		quest=94463,
		npc=248823,
		loot={
			264519, -- Repurposed Voidwalker's Chestplate
			264606, -- Netherlocus Amulet
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94753}),
		},
		note="Gather 3x {item:248680:Unstable Focusing Crystal} from chests and {npc:248483:Crystal Fragment} to the east",
		related={
			[28257044]={label="{npc:248483:Crystal Fragment}", loot={248680}},
		},
		vignette=7142,
	},
}, {
	loot_shared=loot_shared,
})

ns.RegisterPoints(ns.SLAYERSRISE, {
	[28465684] = { label="Hardin Steellock",
		quest=94461,
		npc=257199,
		loot={
			-- 264364, -- Hardin Steellock's Head
			264599, -- Kul'Tiran Signet Ring
			264615, -- Hardin's Backup Blade
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94757}),
		},
		faction="Horde",
		vignette=7442,
	},
	[69687730] = { label="Gar'chak Skullcleave",
		quest=94461,
		npc=257231,
		loot={
			-- 264363, -- Gar'chak Skullcleave's Head
			264609, -- Gar'chak's Mark of Honor
			264641, -- Sharpened Skullcleaver
			ns.rewards.Currency(ns.CURRENCY_SINGULARITY, 50, {quest=94756}),
		},
		faction="Alliance",
		vignette=7445,
	},
}, {
	parent=true,
	loot_shared=loot_shared,
})

-- Invasions

ns.RegisterPoints(ns.VOIDSTORM_NAIGTAL, {
	[29106290] = { label="Auredar's Chassis",
		criteria=114009,
		quest=96316, -- v
		npc=264569,
		loot={
			274873, -- Funeral Attendant's Spire
			275143, -- Draeni Ceremonial Cuffs
			275159, -- Construct Manipulator Bracers
			275167, -- Intact Construct Plates
			274827, -- Draenic Drive Chain
			-- 278116, -- Player Experience
		},
		vignette=7668,
	},
	[76203960] = { label="Swalewing Matriarch",
		criteria=114007,
		quest=96207, -- v
		npc=263954,
		loot={
			274874, -- Flickering Wing Separator
			275137, -- Flickering Soft-Steppers
			275153, -- Flickering Scale Sabatons
			275145, -- Swalewing Skin Footpads
			275161, -- Swamp-Resistant Stompers
			-- 276288, -- Forgotten Sword of Vilaldoun
		},
		vignette=7660,
	},
	[39904270] = { label="Broxion",
		-- [39904270, 41304680, 42004830, 42604800, 44905440, 45505340, 45805370, 46205600]
		criteria=114006,
		quest=96206, -- v
		npc=263950,
		loot={
			275138, -- Spore-Handler's Handwraps
			275146, -- Spore-Membrane Gloves
			275154, -- Swamp Trekker's Grips
			275162, -- Spore-Shined Gloves
			274890, -- Enchanted Spore
			-- 276288, -- Forgotten Sword of Vilaldoun
			-- 278116, -- Player Experience
		},
		vignette=7659,
	},
	[39516103] = { label="Interminable Uarn",
		criteria=114005,
		quest=96205,
		npc=263947,
		loot={
			274862, -- Corrupted Draenei Priest's Kris
			275139, -- Crown of Fungal Spores
			275147, -- Bioluminescent Swamp Mask
			275155, -- Interminable Fungal Helmet
			-- no plate helm?
			274876, -- Reinforced Fungalhide Bulwark
		},
		vignette=7658,
	},
	[68546229] = { label="Lomelith",
		criteria=114008,
		quest=96208,
		npc=263955,
		loot={
			274860, -- Ancient Spore-Coated Axe
			274819, -- Fungal Fold Frock
			274823, -- Spongy Gill Loop
			-- 278116, -- Player Experience
		},
		vignette=7661,
	},
	[69407720] = { label="Warp Agent Xi'grivr",
		criteria=114010,
		quest=96319, -- v
		npc=264574,
		loot={
			274870, -- Assassin's Void-String Bow
			274821, -- Drape of the Hal'hadar Assassin
			274825, -- Hal'hadar Assassin's Signet
		},
		vignette=7670,
	},
	[54206240] = { label="Slaipaan",
		criteria=114012,
		quest=96320, -- v
		npc=264576,
		loot={
			274871, -- Giant Worm Piercer
			275136, -- Leaf-Woven Blouse
			275144, -- Leafy-Hide Coat
			275152, -- Burrower's Linked Hauberk
			275160, -- Slaipaan's Carapace
			-- 276288, -- Forgotten Sword of Vilaldoun
		},
		vignette=7671,
	},
	[48006880] = { label="Indomitable Mk XII",
		criteria=114011,
		quest=96317, -- v
		npc=264571,
		loot={
			276298, -- Forgotten Fel-Shard Talon
			275140, -- Leggings of Tainted Stuffing
			275148, -- Reaver's Padded Trousers
			275156, -- Gear-Linked Leggings
			275164, -- Indomitable Mechanized Legplates
			274891, -- Mk XII Gear Drive
			-- 276288, -- Forgotten Sword of Vilaldoun
			-- 278116, -- Player Experience
		},
		routes={{48006880, 49006576, 49005920, 52425751, 53215440, 53534842, 54254436}},
		vignette=7669,
	},
}, {
	achievement=62883, -- Showdown Slugger: Naigtal
})
ns.RegisterPoints(2646, { -- Naigral (Vilaldoun)
	[73608020] = { label="Auredar's Chassis",
		criteria=114009,
		quest=96316, -- v
		npc=264569,
		loot={
			274873, -- Funeral Attendant's Spire
			275143, -- Draeni Ceremonial Cuffs
			275159, -- Construct Manipulator Bracers
			275167, -- Intact Construct Plates
			274827, -- Draenic Drive Chain
			-- 278116, -- Player Experience
		},
		vignette=7668,
	},
}, {
	achievement=62883, -- Showdown Slugger: Naigtal
})
ns.RegisterPoints(ns.VOIDSTORM_NAIGTAL, {
	[29751928] = { label="Warbringer Thal'kuur",
		quest=97014,
		npc=267422,
		loot={
			276298, -- Forgotten Fel-Shard Talon
			274864, -- Sporebloom Gavel
			275141, -- Spore-Speckled Shoulderpads
			275149, -- Fungal Draped Epaulets
			275157, -- Swampwalker's Spaulders
			275165, -- Petrified Mushroom Shoulderplates
		},
		vignette=7744,
	},
	[48404760] = { label="Voidwarped Sporebat",
		quest=96566, -- v
		npc=265698,
		loot={
			274866, -- Voidwarped Edge
			275142, -- Voidwarped Sash
			275150, -- Sporebat Leather Belt
			275158, -- Voidwarped Scale Girdle
			275166, -- Voidwarped Greatbelt
			-- 278116, -- Player Experience
		},
		vignette=7699,
	},
	[68235161] = { label="Sleepy Mandrake",
		label="{npc:267910:Sleepy Mandrake}",
		loot={
			{262768, pet=true}, -- Sleepy Mandrake
		},
		note=function()
			local function done(q) return C_QuestLog.IsQuestFlaggedCompletedOnAccount(q) and "{a:common-icon-checkmark}" or "{a:common-icon-redx}" end
			return "Feed five mushrooms:\n"..
				done(97091).." {item:276365:Highland Redcap}\n"..
				done(97092).." {item:276366:Dusty Redcap}\n"..
				done(97093).." {item:276367:Marshy Redcap}\n"..
				done(97094).." {item:276368:Partially-Digested Redcap} (mob drop)\n"..
				done(97095).." {item:276369:Airy Redcap}"
		end,
		related={
			[28906176] = { label="Highland Redcap",
				quest=97091, loot={276365}, label="{item:276365}",
				path={28906176, 29786262, 30156525, 30426609, 32676921, 33417072, 36217266, 36637216, 36407136, 31146332, 31316254, 31816023, 33475950},
			},
			[27914996] = {quest=97092, loot={276366}, label="{item:276366}", note="In the crypts"}, -- Dusty Redcap
			[71423705] = {quest=97093, loot={276367}, label="{item:276367}", path=75643814}, -- Marshy Redcap
			-- [] = {quest=97094, loot={276368}}, -- Partially-Digested Redcap
			[95092667] = {quest=97095, loot={276369}, label="{item:276369}", path=88812597, note="On top of the tallest mushroom, bounce up"}, -- Airy Redcap
			atlas="TeleportationNetwork-Ardenweald-32x32", minimap=true,
		},
		path=67505416,
		atlas="VignetteLootElite", scale=1.3, minimap=true,
	},
})
ns.RegisterPoints(2646, { -- Naigral (Vilaldoun)
	[22626135] = {
		quest=97092,
		loot={276366}, -- Dusty Redcap
		-- translate={[ns.VOIDSTORM_NAIGTAL]=true}, -- confusing
		atlas="TeleportationNetwork-Ardenweald-32x32", minimap=true,
	},
})

ns.RegisterPoints(ns.VOIDSTORM_VAL, {
	[33005700] = { label="Nelgothar",
		criteria=114002,
		quest=96374, -- v
		npc=264869,
		loot={
			276298, -- Forgotten Fel-Shard Talon
			274840, -- Pants of the Lost Legion
			274832, -- Fel-Tainted Trousers
			274848, -- Legguards of Fel-Corruption
			274856, -- Felguard's Frozen Greaves
			274892, -- Resilient Felblood Vial
			-- 276354, -- Frozen Fel Core
			-- 278116, -- Player Experience
		},
		vignette=7679,
	},
	[54006700] = { label="Sleet-Rune",
		criteria=113995,
		quest=95939, -- v
		npc=261965,
		loot={
			274869, -- Void-Iced Warglaives
			274828, -- Domanaar Subjugator's Vestments
			274836, -- Sleet-Resistant Jerkin
			274844, -- Sleetlink Hauberk
			274852, -- Sleetstone Chestplate
		},
		vignette=7605,
	},
	[23004100] = { label="The Horror Below",
		criteria=114003,
		quest=96375, -- v
		npc=264870,
		loot={
			274872, -- Darkness' Horrific Barb
			274826, -- Coiling Smoke Chain
			274818, -- Drape of Intense Darkness
		},
		vignette=7680,
	},
	[37007600] = { label="Atomus",
		criteria=113996,
		quest=95940, -- v
		npc=262421,
		loot={
			274868, -- Portal Master's Shortblade
			274831, -- Portal Shaper's Circlet
			274839, -- Cold-World Cover
			274847, -- Atomus's Headcover
			274855, -- Portal-Keeper's Helm
		},
		vignette=7606,
	},
	[49007800] = { label="Mercilus",
		criteria=113998,
		quest=96371, -- v
		npc=264865,
		loot={
			274867, -- Inscribed Domanaar's Sword
			274834, -- Cord of Domineering Resolve
			274842, -- Gatekeeper's Leather Waistguard
			274850, -- Mercilus's Chain Waistguard
			274858, -- Domanaar Battle Belt
		},
		vignette=7676,
	},
	[28007300] = { label="Xirah",
		criteria=113999,
		quest=96370, -- v
		npc=264864,
		loot={
			274875, -- Riftwalker's Lanter
			274820, -- Cloak of the Voracious Gorge
			274824, -- Worldeater's Bone Ring
		},
		vignette=7675,
	},
	[33004200] = { label="Opprimius",
		criteria=114001,
		quest=96373, -- v
		npc=264868,
		loot={
			274863, -- Cudgel of the Twisted Reaper
			274829, -- Creature Corruptor Slippers
			274837, -- Corrupted Hide Boots
			274845, -- Greaves of Corrupted Scale
			274853, -- Creature Crushers
			-- 278116, -- Player Experience
		},
		vignette=7678,
	},
	[44005840] = { label="Krilkan",
		criteria=114000,
		quest=96372, -- v
		npc=264866,
		loot={
			274835, -- Bands of Pincher Sinew
			274843, -- Pincher-Proof Wristguards
			274851, -- Glittering Frostscale Wraps
			274859, -- Klaxid Plate Vambraces
			274893, -- Frosty Klaxid Stinger
			-- 278116, -- Player Experience
		},
		vignette=7677,
	},
	[67104180] = { label="Glacial Broodmother",
		criteria=113997,
		quest=95559, -- v
		npc=261716,
		loot={
			274861, -- Frosty Broodmother's Fang
			274833, -- Icy Spidersilk Mantle
			274841, -- Frigid Cavedweller's Shoulderpads
			274849, -- Frostscale Spider's Monnion
			274857, -- Chitonous Broodmother's Spaulders
		},
		vignette=7558,
	},
	-- Unknown location, displayed to the side
	[11001700] = { label="Shadowguard Destroyer",
		criteria=114004,
		quest=96465, -- v
		npc=265269,
		loot={
			274865, -- Destroyer's Drop Hammer
			274830, -- Ice-Glazed Gloves
			274854, -- Shadowguard Plate Gauntlets
		},
		vignette=7690,
		note="Seems to spawn after other rares are killed",
	},
}, {
	achievement=62881, -- Showdown Slugger: Val
})

ns.RegisterPoints(ns.VOIDSTORM_VAL, {
	[70508429] = {
		label="Enchanted Hilt",
		loot={276290}, -- Ice Guardian's Sleetblade
		note="In {spell:1238870:Heroic World Tier}, use the Hilt to gain {spell:1300397:Testament}, then kill any two rares to gain 2x {spell:1299509:Vanquishing}. Return here for the reward before they expire.",
		path=61457875,
	},
})