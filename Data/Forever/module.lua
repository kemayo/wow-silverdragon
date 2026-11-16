local myname, ns = ...

if WOW_PROJECT_ID ~= WOW_PROJECT_CAMELOT then
	ns.BeginDataModule(nil)
	return
end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

ns.BeginDataModule("Forever")

core:RegisterMobData("Forever", {
	[1720] = {name="Bruegal Ironknuckle",locations={[225]={},},loot={2941,2942,3228},}, -- The Stockade
	[1849] = {name="Dreadwhisper",locations={[ns.WESTERNPLAGUELANDS]={},},},
	[3586] = {name="Miner Johnson",locations={[291]={},},loot={5443,5444},}, -- The Deadmines
	[3872] = {name="Deathsworn Captain",locations={[316]={},},}, -- Shadowfang Keep
	[4425] = {name="Blind Hunter",locations={[301]={},},loot={6695,6696,6697},}, -- Razorfen Kraul
	[4842] = {name="Earthcaller Halmgar",locations={[301]={},},loot={6688,6689},}, -- Razorfen Kraul
	[5348] = {name="Dreamwatcher Forktongue",locations={[ns.SWAMPOFSORROWS]={},},},
	[5399] = {name="Veyzhak the Cannibal",locations={[220]={},},}, -- Sunken Temple
	[5400] = {name="Zekkis",locations={[220]={},},}, -- Sunken Temple
	[5912] = {name="Deviate Faerie Dragon",locations={[279]={},},loot={5243,6632},}, -- Wailing Caverns
	[6228] = {name="Dark Iron Ambassador",locations={[226]={},},loot={9455,9456,9457},}, -- Gnomeregan
	[6488] = {name="Fallen Champion",locations={[302]={},},loot={7689,7690,7691},}, -- Scarlet Monastery Graveyard
	[6489] = {name="Ironspine",locations={[302]={},},loot={7686,7687,7688},}, -- Scarlet Monastery Graveyard
	[6490] = {name="Azshir the Sleepless",locations={[302]={},},loot={7708,7709,7731},}, -- Scarlet Monastery Graveyard
	[8923] = {name="Panzor the Invincible",locations={[243]={},},loot={11785,11786,11787,22245},}, -- Blackrock Depths
	[8924] = {name="The Behemoth",locations={[ns.SEARINGGORGE]={},[ns.BURNINGSTEPPES]={},},},
	[9217] = {name="Spirestone Lord Magus",locations={[250]={},},loot={13261,13282,13283},}, -- Blackrock Spire
	[9218] = {name="Spirestone Battle Lord",locations={[250]={},},loot={13284,13285},}, -- Blackrock Spire
	[9219] = {name="Spirestone Butcher",locations={[250]={},},loot={12608,13286},}, -- Blackrock Spire
	[9596] = {name="Bannok Grimaxe",locations={[250]={},},loot={12621,12634,12637,12838},}, -- Blackrock Spire
	[9718] = {name="Ghok Bashguud",locations={[250]={},},loot={13198,13203,13204},}, -- Blackrock Spire
	[10080] = {name="Sandarr Dunereaver",locations={[219]={},},loot={274659,274660},}, -- Zul'Farrak
	[10081] = {name="Dustwraith",locations={[219]={},},loot={12469,12471},}, -- Zul'Farrak
	[10082] = {name="Zerillis",locations={[219]={},},loot={12470,274658},}, -- Zul'Farrak
	[10263] = {name="Burning Felguard",locations={[250]={},},loot={13181,13182},}, -- Blackrock Spire
	[10376] = {name="Crystal Fang",locations={[250]={},},loot={13184,13185,13218},}, -- Blackrock Spire
	[10393] = {name="Skul",locations={[317]={},},loot={13394,13395,13396},}, -- Stratholme
	[10509] = {name="Jed Runewatcher",locations={[250]={},},loot={12604,12605,12930},}, -- Blackrock Spire
	[10558] = {name="Hearthsinger Forresten",locations={[317]={},},loot={647,13378,{13379,toy=true,},13383,13384,16682},}, -- Stratholme
	[10584] = {name="Urok Doomhowl",locations={[250]={},},loot={12712,13178,13258,13259,18784,22232},}, -- Blackrock Spire
	[10808] = {name="Timmy the Cruel",locations={[317]={},},loot={13400,13401,13402,13403,16724},}, -- Stratholme
	[10809] = {name="Stonespine",locations={[318]={},},loot={13397,13399,13954},}, -- Stratholme
	[10818] = {name="Death Knight Soulbearer",locations={[ns.EASTERNPLAGUELANDS]={},},},
	[10819] = {name="Baron Bloodbane",locations={[ns.EASTERNPLAGUELANDS]={},},},
	[10820] = {name="Duke Ragereaver",locations={[ns.EASTERNPLAGUELANDS]={},},},
	[12237] = {name="Meshlok the Harvester",locations={[280]={},},loot={17741,17742,17767},}, -- Maraudon
	[211764] = {name="Gefell",locations={[310]={},},loot={210212},}, -- Shadowfang Keep
	[211765] = {name="Gemela",locations={[310]={},},loot={210213},}, -- Shadowfang Keep
	-- No known zone; the comments name the area wowhead gives, where it gives one
	-- [601] = {name="Capo the Mean",},
	-- [5367] = {name="Scillia Daggerquil",},
	-- [5789] = {name="Serra Mountainhome",},
	-- [5790] = {name="Lizzle Sprysprocket",},
	-- [5793] = {name="Captain Armistice",},
	-- [5794] = {name="Thurmonde the Devout",},
	-- [5795] = {name="Grash Thunderbrew",},
	-- [5796] = {name="Ben",},
	-- [10203] = {name="Berylgos",},
	-- [10236] = {name="Wep",},
	-- [10237] = {name="Yor",},
	-- [10238] = {name="Staggon",},
	-- [10239] = {name="Tepolar",},
	-- [11580] = {name="Kelemis the Lifeless",},
	-- [12116] = {name="Priestess of Elune",},
	-- [13977] = {name="Gash'nak the Cannibal",},
	-- [14016] = {name="Ushalac the Gloomdweller",},
	-- [14018] = {name="Rezrelek",},
	-- [14019] = {name="Tatterhide",},
	-- [14341] = {name="Felendor the Accuser",},
	-- [17075] = {name="Sandworm",},
	-- [208842] = {name="The Gardener",},
	-- [208843] = {name="Abominable Snowman",},
	-- [208844] = {name="Scarlet Revenant",},
	-- [216670] = {name="Caverndeep Looter",},
	-- [228673] = {name="Wandering Swordsman",},
	-- [231661] = {name="Rahuz",},
	-- [232215] = {name="Rahuz",},
	-- [232216] = {name="Rahuz",},
	-- [232556] = {name="Drake",},
	-- [232557] = {name="Drake",},
	-- [240797] = {name="Scarlet Executioner",}, -- Scarlet Enclave
	-- [242577] = {name="Devouring Hunger",},
	-- [242827] = {name="Captain Bloodcoin",},
	-- [244612] = {name="Wandering Swordsman",},
	-- [245332] = {name="Par'kourc",},
	-- [245423] = {name="Rahuz",},
	-- [247412] = {name="Mopes",},
	-- [249231] = {name="Varkharn the Vigilant",},
	-- [249232] = {name="Ganoloth the Tireless",},
	-- [249233] = {name="Unyielding Eye",},
	-- [249473] = {name="Sarinnia Wormwing",loot={254859},},
	-- [250034] = {name="Tunnelweb Matriarch",loot={280085,280086},}, -- Blackmaw Hold
	-- [250352] = {name="Old Thornpaw",},
	-- [250355] = {name="Defias Vintner",},
	-- [251494] = {name="Boulupulo",},
	-- [255699] = {name="Lordaeron Captain",}, -- Ruins of Lordaeron
	-- [260468] = {name="\"Pyromancer\" Braxton",loot={286650,286651},}, -- The Drowned City
	-- [261662] = {name="Old Ironfang",},
	-- [261993] = {name="King Op",},
	-- [262716] = {name="Kroog",loot={279857,279863},},
	-- [264172] = {name="Umbra",loot={286658,286662},}, -- The Drowned City
	-- [264177] = {name="Gill",loot={286646,286649},}, -- The Drowned City
	-- [269104] = {name="Moontouched Wanderer",loot={280079,280080},}, -- Blackmaw Hold
	-- [269111] = {name="Gortek the Apprentice",loot={280077,280078},},
	-- [269151] = {name="Sabella No-Eyes",loot={280083,280084},},
	-- [277981] = {name="Aidan's Test Creature DNT",},
}, true)
