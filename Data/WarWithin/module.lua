local myname, ns = ...

if LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_WAR_WITHIN or math.huge) then
	ns.BeginDataModule(nil)
	return
end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

ns.BeginDataModule("WarWithin")
ns.MAXLEVEL = ns.conditions.Level(80)

-- Rares

local LOC_allkhazalgar = {[ns.KHAZALGAR]={},[ns.DORNOGAL]={},[ns.ISLEOFDORN]={},[ns.RINGINGDEEPS]={},[ns.HALLOWFALL]={},[ns.AZJKAHET]={},}

core:RegisterMobData("WarWithin", {
	-- World Bosses
	[229334] = {
		name="Kordac",
		quest=81630, -- This is the world quest
		worldquest=81630,
		locations={
			-- [ns.ISLEOFDORN]={50005880},
			[ns.ISLEOFDORN]={},
		},
		loot={
			225730, -- Stone Gaze Ceinture
			225731, -- Lightseeker's Robes
			225732, -- Deep Dweller's Tabi
			225733, -- Abyssal Tendril Tights
			225734, -- Sturdy Chitinous Striders
			225735, -- Dornish Warden's Coat
			225745, -- Crystal Star Cuisses
			225746, -- Girdle of the Gleaming Dawn
			225748, -- Seal of the Silent Vigil
		},
	},
	[220999] = {
		name="Aggregation of Horrors",
		quest=83466,
		worldquest=82653,
		locations={
			-- [ns.RINGINGDEEPS]={60868760},
			[ns.RINGINGDEEPS]={},
		},
		loot={
			225730, -- Stone Gaze Ceinture
			225731, -- Lightseeker's Robes
			225732, -- Deep Dweller's Tabi
			225733, -- Abyssal Tendril Tights
			225734, -- Sturdy Chitinous Striders
			225735, -- Dornish Warden's Coat
			225745, -- Crystal Star Cuisses
			225746, -- Girdle of the Gleaming Dawn
			225749, -- Seal of the Void-Touched
		},
	},
	[221224] = {
		name="Shurrai",
		quest=83467,
		worldquest=81653,
		locations={
			-- [ns.HALLOWFALL]={45401740},
			[ns.HALLOWFALL]={},
		},
		loot={
			225730, -- Stone Gaze Ceinture
			225731, -- Lightseeker's Robes
			225732, -- Deep Dweller's Tabi
			225733, -- Abyssal Tendril Tights
			225734, -- Sturdy Chitinous Striders
			225735, -- Dornish Warden's Coat
			225745, -- Crystal Star Cuisses
			225746, -- Girdle of the Gleaming Dawn
			225750, -- Seal of the Abyssal Terror
		},
	},
	[221067] = {
		name="Orta",
		quest=81624, -- this is the worldquest; a separate one didn't trip
		worldquest=81624,
		locations={
			-- [ns.CITYOFTHREADS]={17103340},
			[ns.CITYOFTHREADS]={},
			[ns.AZJKAHET]={},
			[ns.AZJKAHETLOWER]={},
			[ns.CITYOFTHREADSLOWER]={},
		},
		loot={
			225730, -- Stone Gaze Ceinture
			225731, -- Lightseeker's Robes
			225732, -- Deep Dweller's Tabi
			225733, -- Abyssal Tendril Tights
			225734, -- Sturdy Chitinous Striders
			225735, -- Dornish Warden's Coat
			225745, -- Crystal Star Cuisses
			225746, -- Girdle of the Gleaming Dawn
			225751, -- Seal of the Broken Mountain
		},
	},
	[231821] = {
		name="The Gobfather",
		quest=85088, -- 89401 is the account-loot weekly, I think?
		worldquest=85088, -- The Main Event, also
		-- locations={[ns.UNDERMINE]={49601720}},
		locations={[ns.UNDERMINE]={}},
		loot={
			232725, -- Pilot's Oiled Trousers
			232726, -- Well-Trodden Mechanic's Shoes
			232727, -- Cavern Stalker's Trophy Girdle
			232728, -- Darkfuse Dinner Jacket
			232729, -- Horn-Adorned Chausses
			232730, -- Cauldron Master Cleats
			232731, -- Steadfast Contender's Breastplate
			232732, -- Champion's Gilded Stompers
			232733, -- Gobfather's Gold Medal
		},
	},
	[238319] = {
		name="Reshanor",
		quest=90783, -- 87352 tripped as well, account-wide
		worldquest=87354,
		locations={[ns.KARESH]={}}, -- 71854851
		loot={
			243038, -- Gaze of the Untethered Doom
			243039, -- Devoured Magi's Cinch
			243040, -- Crystalblight Legguards
			243041, -- Umbral Stalker's Footpads
			243042, -- Void-Bound Hauberk
			243043, -- Shadowguard's Rift Wrap
			243044, -- Feasting Fiend's Barbute
			243045, -- Bygone Wastelander's Girdle
			243046, -- Band of Boundless Hunger
		},
	},

	-- Xal'atath appears sometimes to monologue at you, but she's just a non-interactable story/dungeon element:
	[229244] = {name="Xal'atath", hidden=true},
	[229536] = {name="Xal'atath", hidden=true},
	[229635] = {name="Xal'atath", hidden=true},
	[230937] = {name="Xal'atath", hidden=true},
	-- Random things that are flagged as rare for no particular reason
	[209780] = {name="Abandoned Restoration Stone", hidden=true},
	-- Court of Rats adds
	[230935] = {name="Grease", hidden=true},
	[230936] = {name="Grime", hidden=true},
}, true)
