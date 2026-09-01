local myname, ns = ...

if LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_SHADOWLANDS or math.huge) then
	ns.BeginDataModule(nil)
	return
end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

ns.BeginDataModule("Shadowlands")

core:RegisterMobData("Shadowlands", {
	[152500] = {name="Deadsoul Amalgam",locations={[1705]={},},},
	[152508] = {name="Dusky Tremorbeast",locations={[1705]={},},},
	[152517] = {name="Deadsoul Lifetaker",locations={[1705]={},},},
	[152612] = {name="Subjugator Klontzas",locations={[1705]={},},},
	[156134] = {name="Ghastly Charger",locations={[1705]={},},},
	[156142] = {name="Seeker of Souls",locations={[1705]={},},},
	[156158] = {name="Adjutant Felipos",locations={[1705]={},},},
	[156237] = {name="Imperator Dara",locations={[1705]={},},},
	[157726] = {name="Scorched Scavenger",locations={[1525]={},},hidden=true,},
	[157727] = {name="Scorched Outcast",locations={[1525]={},},hidden=true,},
	[157733] = {name="Crazed Ash Ghoul",locations={[1525]={},},hidden=true,},
	[160392] = {name="Soulstalker Doina",locations={[1525]={65005640},},loot={180692,180490},quest=58130,hidden=true,},
	[160393] = {name="Soulstalker Doina",locations={[1525]={48604800},},loot={180692,180490},quest=58130,hidden=true,},
	[166726] = {name="Blistering Ash Ghoul",locations={[1525]={},},hidden=true,},
	[170228] = {name="Bone Husk",locations={[1705]={},},},
	[170385] = {name="Writhing Misery",locations={[1705]={},},},
	[170414] = {name="Howling Spectre",locations={[1705]={},},},
	[170417] = {name="Animated Stygia",locations={[1705]={},},},
	[173051] = {name="Suppressor Xelors",locations={[1705]={},},},
	[173080] = {name="Wandering Death",locations={[1705]={},},},
	[173134] = {name="Darksworn Goliath",locations={[1705]={},},},
	[173191] = {name="Soulstalker V'lara",locations={[1705]={},},},
	[173238] = {name="Deadsoul Strider",locations={[1705]={},},},
	-- [173468] = {name="Dead Blanchy",locations={[1525]={63134311},},loot={{182614,mount=1414,}},notes="7 days of quests",quest=62050,},
	-- [173499] = {name="Loyal Gorger",locations={[1525]={59305700},},loot={{182589,mount=1391,}},notes="Kill Worldedge Gorger first",quest=62046,},
	-- [174827] = {name="Gorged Shadehound",locations={[1543]={53507950},},loot={{184167,mount=1304,}},notes="Only during the Hunt: Shadehounds event",},
	[183749] = {name="Helmix",hidden=true},
	[184804] = {name="Helmix",hidden=true},
	-- soulshapes
	-- [181682] = {name="Lost Soul",locations={[1533]={49854685}},loot={{187818, quest=64959, covenant=Enum.CovenantType.NightFae}},notes="/hug",requires=core.conditions.Covenant(Enum.CovenantType.NightFae)},
}, true)
core:RegisterTreasureData("Shadowlands", {
	[4925] = {name="Template Archive",loot={{190060,quest=65527}},},
	[4928] = {name="Provis Cache",loot={{189710,quest=65474}},active=core.conditions.Item(188231),},
	[4929] = {name="Prying Eye Discovery",loot={{190096,quest=65534},{189711,quest=65476}},active={core.conditions.Item(188170),core.conditions.Achievement(15514),any=true},},
	[4968] = {name="Domination Cache",loot={190638,189863},active=core.conditions.Item(189704),},
	[4969] = {name="Mawsworn Supply Chest",loot={{190766,mount=1585}},},
	[4974] = {name="Discarded Automa Scrap",loot={{189717,quest=65483},{189718,quest=65484}},},
	[4978] = {name="Pulp-Covered Relic",loot={{189474,quest=65397}},},
	[4980] = {name="Architect's Reserve",loot={{187833,quest=65528}},active={core.conditions.GarrisonTalent(1931), core.conditions.QuestComplete(65427)},},
	[4981] = {name="Mistaken Ovoid",loot={{189435,quest=65333}},active=core.conditions.Item(190239,5),},
	[4992] = {name="Protomineral Extractor",loot={190942},active=core.conditions.QuestComplete(64889),},
	[4993] = {name="Pilfered Curio",loot={{190098,quest=65538}},active=core.conditions.Achievement(15514),},
	[4997] = {name="Forgotten Treasure Vault",active=core.conditions.Achievement(15514),},
	[4999] = {name="Protopear",loot={{190058,quest=65525}},active=core.conditions.GarrisonTalent(1931),},
	[5019] = {name="Torn Ethereal Drape",loot={188054},active={core.conditions.GarrisonTalent(1902),core.conditions.QuestComplete(65328)},},
	[5021] = {name="Drowned Broker Supplies",loot={{190059,quest=65526}},active=core.conditions.GarrisonTalent(1932),},
}, true)
