-- DO NOT EDIT THIS FILE; run dataminer.lua to regenerate.
local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Data_Shadowlands")

function module:OnInitialize()
	core:RegisterMobData("Shadowlands", {
		[152500] = {name="Deadsoul Amalgam",locations={[1705]={},},},
		[152508] = {name="Dusky Tremorbeast",locations={[1705]={},},},
		[152517] = {name="Deadsoul Lifetaker",locations={[1705]={},},},
		[152612] = {name="Subjugator Klontzas",locations={[1705]={},},},
		[154330] = {name="Eternas the Tormentor",locations={[1543]={27584966},},quest=57509,},
		[155779] = {name="Tomb Burster",locations={[1525]={43007910},},pet=2891,quest=56877,},
		[156134] = {name="Ghastly Charger",locations={[1705]={},},},
		[156142] = {name="Seeker of Souls",locations={[1705]={},},},
		[156158] = {name="Adjutant Felipos",locations={[1705]={},},},
		[156237] = {name="Imperator Dara",locations={[1705]={},},},
		[156339] = {name="Eliminator Sotiros",locations={[1533]={22452285},},notes="Requires Kyrian",quest=61634,},
		[156676] = {name="Ogre Overseer",locations={[1409]={60406000},},quest=56051,},
		[156916] = {name="Inquisitor Sorin",locations={[1525]={69604780},},},
		[156919] = {name="Inquisitor Petre",locations={[1525]={67404380},},},
		[156986] = {name="Ogre Taskmaster",locations={[1409]={57404080},},quest=59611,},
		[157058] = {name="Corpsecutter Moroc",locations={[1536]={26392633},},quest=58335,},
		[157294] = {name="Pulsing Leech",locations={[1536]={58407420},},},
		[157308] = {name="Corrupted Sediment",locations={[1536]={58607400},},},
		[157833] = {name="Borr-Geth",locations={[1543]={39014119},},quest=57469,},
		[157964] = {name="Adjutant Dekaris",locations={[1543]={},},},
		[158025] = {name="Darklord Taraxis",locations={[1543]={49128175},},quest=62282,},
		[158278] = {name="Nascent Devourer",locations={[1543]={45507376},},quest=57573,},
		[158406] = {name="Scunner",locations={[1536]={62107580},},pet=2957,quest=58006,},
		[158659] = {name="Herculon",locations={[1533]={42808240},},quest=57705,},
		[159105] = {name="Collector Kash",locations={[1536]={49012351},},quest=58005,},
		[159151] = {name="Inquisitor Traian",locations={[1525]={76005180},},},
		[159152] = {name="High Inquisitor Gabi",locations={[1525]={75204420},},},
		[159153] = {name="High Inquisitor Radu",locations={[1525]={71204200},},},
		[159155] = {name="High Inquisitor Dacian",locations={[1525]={72005280},},},
		[159496] = {name="Forgemaster Madalav",locations={[1525]={32651545},},notes="Requires Venthyr",quest=61618,},
		[159503] = {name="Stonefist",locations={[1525]={31312324},},quest=62220,},
		[159753] = {name="Ravenomous",locations={[1536]={53841877},},pet=2964,quest=58004,},
		[159886] = {name="Sister Chelicerae",locations={[1536]={55502361},},pet=2948,quest=58003,},
		[160059] = {name="Taskmaster Xox",locations={[1536]={50562011},},quest=58091,},
		[160385] = {name="Soulstalker Doina",item=180692,locations={[1525]={78934975},},quest=58130,},
		[160392] = {name="Soulstalker Doina",locations={[1525]={65005640},},hidden=true,},
		[160393] = {name="Soulstalker Doina",locations={[1525]={48604800},},hidden=true,},
		[160448] = {name="Hunter Vivanna",item=179596,locations={[1565]={67005140},},quest=59221,},
		[160629] = {name="Baedos",locations={[1533]={51344080},},quest=58648,},
		[160640] = {name="Innervus",locations={[1525]={21803590},},quest=58210,},
		[160675] = {name="Scrivener Lenua",locations={[1525]={38316914},},pet=2893,quest=58213,},
		[160721] = {name="Fallen Acolyte Erisne",locations={[1533]={60007340},},quest=58222,},
		[160770] = {name="Darithis the Bleak",locations={[1543]={60964805},},quest=62281,},
		[160821] = {name="Worldedge Gorger",item=180583,locations={[1525]={38607200},},mount=1391,notes="Starts a quest in the Endmire for the mount",quest=58259,},
		[160857] = {name="Sire Ladinas",locations={[1525]={34045555},},quest=58263,toy=180873,},
		[160882] = {name="Nikara Blackheart",locations={[1533]={51406800},},notes="Needs three players to summon",quest=58319,},
		[160985] = {name="Nikara the Reborn",item=174038,locations={[1533]={51406840},},quest=58320,},
		[161105] = {name="Indomitable Schmitd",locations={[1536]={38794333},},quest=58332,},
		[161310] = {name="Executioner Adrastia",locations={[1525]={43055183},},quest=58441,},
		[161481] = {name="Vinyeti",locations={[1565]={40205300},},},
		[161527] = {name="Sigilback",item=179486,locations={[1533]={55208040},},toy=174445,quest=60570,vignette=4032,},
		[161528] = {name="Aethon",item=179487,locations={[1533]={55208020},},quest=58526,vignette=4032,},
		[161529] = {name="Nemaeus",item=179485,locations={[1533]={55008020},},quest=60569,vignette=4032,},
		[161530] = {name="Cloudtail",item=179488,locations={[1533]={55208040},},quest=60571,vignette=4032,},
		[161857] = {name="Pesticide",locations={[1536]={50346328},},quest=58629,},
		[161891] = {name="Lord Mortegore",locations={[1525]={75976161},},quest=58633,},
		[162180] = {name="Thread Mistress Leeda",locations={[1536]={24184297},},quest=58678,},
		[162481] = {name="Sinstone Hoarder",item=180677,locations={[1525]={67443048},},quest=62252,},
		[162528] = {name="Smorgas the Feaster",item=181266,locations={[1536]={42465345},},notes="Drops two pets",pet=2955,quest=58768,},
		[162586] = {name="Tahonta",locations={[1536]={44215132},},mount=1370,quest=58783,},
		[162588] = {name="Gristlebeak",item=182196,locations={[1536]={57795155},},quest=58837,},
		[162669] = {name="Devour'us",locations={[1536]={45052842},},quest=58835,},
		[162690] = {name="Nerissa Heartless",locations={[1536]={66023532},},mount=1373,quest=58851,},
		[162711] = {name="Deadly Dapperling",locations={[1536]={76835707},},pet=2953,quest=58868,},
		[162727] = {name="Bubbleblood",locations={[1536]={52663542},},quest=58870,},
		[162741] = {name="Gieger",locations={[1536]={31603540},},mount=1411,quest=58872,},
		[162767] = {name="Nirvaska the Summoner",locations={[1536]={50406240},},quest=58875,},
		[162797] = {name="Deepscar",item=182191,locations={[1536]={46734550},},quest=58878,},
		[162819] = {name="Zargox the Reborn",locations={[1536]={28965138},},quest=62079,},
		[162849] = {name="Morguliax",locations={[1543]={16945102},},quest=60987,},
		[163229] = {name="Dustbrawl",locations={[1565]={48407580},},quest=58987,},
		[163370] = {name="Gormbore",locations={[1565]={53807580},},pet=3035,quest=59006,},
		[163460] = {name="Dionae",locations={[1533]={41354887},},quest=62650,},
		[164064] = {name="Obolos",locations={[1543]={48801830},},quest=60667,},
		[164093] = {name="Macabre",locations={[1565]={},},pet=2907,},
		[164107] = {name="Gormtamer Tizo",locations={[1565]={27885248},},mount=1362,quest=59145,},
		[164112] = {name="Humon'gozz",locations={[1565]={31803040},},mount=1415,quest=59157,},
		[164147] = {name="Wrigglemortis",locations={[1565]={58006160},},quest=59170,},
		[164238] = {name="Deifir the Untamed",locations={[1565]={46202180,47002740},},notes="So tame him",pet=2920,quest=59201,},
		[164388] = {name="Amalgamation of Light",locations={[1525]={25304850},},quest=59584,},
		[164391] = {name="Old Ardeite",locations={[1565]={51005740},},quest=60273,},
		[164415] = {name="Skuld Vit",item=182183,locations={[1565]={37405960},},notes="Be Night Fae",quest=59220,},
		[164477] = {name="Deathbinder Hroth",locations={[1565]={34606800},},quest=59226,},
		[164547] = {name="Mystic Rainbowhorn",item=182179,locations={[1565]={49402040},},quest=59235,},
		[165053] = {name="Mymaen",locations={[1565]={62102460},},},
		[165152] = {name="Leeched Soul",locations={[1525]={67978179},},pet=2897,quest=59580,},
		[165175] = {name="Prideful Hulk",locations={[1525]={67808200},},},
		[165206] = {name="Endlurker",locations={[1525]={66555946},},quest=59582,},
		[165253] = {name="Tollkeeper Varaboss",item=179363,locations={[1525]={66507080},},quest=59595,},
		[165290] = {name="Harika the Horrid",locations={[1525]={45847919},},mount=1310,notes="Be Venthyr",quest=59612,},
		[166292] = {name="Bog Beast",locations={[1525]={33403240},},pet=2896,},
		[166393] = {name="Amalgamation of Filth",locations={[1525]={53247300},},quest=59854,},
		[166398] = {name="Soulforger Rhovus",locations={[1543]={34803980},},},
		[166521] = {name="Famu the Infinite",locations={[1525]={62484716},},mount=1379,quest=59869,},
		[166576] = {name="Azgar",locations={[1525]={35817052},},quest=59893,},
		[166679] = {name="Hopecrusher",locations={[1525]={51985179},},mount=1298,quest=59900,},
		[166710] = {name="Executioner Aatron",item=180696,locations={[1525]={37084742},},quest=59913,},
		[166993] = {name="Huntmaster Petrus",item=180705,locations={[1525]={61717949},},quest=60022,},
		[167078] = {name="Wingflayer the Cruel",item=182749,locations={[1533]={40405340},},notes="Be Kyrian",quest=60314,},
		[167464] = {name="Grand Arcanist Dimitri",locations={[1525]={20485298},},quest=60173,},
		[167721] = {name="The Slumbering Emperor",locations={[1565]={59204660},},quest=60290,},
		[167724] = {name="Rotbriar Changeling",locations={[1565]={65602400},},quest=60258,},
		[167726] = {name="Rootwrithe",locations={[1565]={64604400},},},
		[167851] = {name="Egg-Tender Leh'go",locations={[1565]={58002940},},quest=60266,},
		[168135] = {name="Night Mare",locations={[1565]={57874983},},mount=1306,notes="Be Night Fae; summoning quest chain",quest=60306,},
		[168147] = {name="Sabreil the Bonecleaver",locations={[1536]={50404820},},mount=1374,},
		[168148] = {name="Drolkrad",locations={[1536]={50204840},},},
		[168647] = {name="Valfir the Unrelenting",item=182176,locations={[1565]={29605540},},mount=1393,notes="Be Night Fae",quest=61632,},
		[168693] = {name="Cyrixia",locations={[1543]={27602380},},},
		[169827] = {name="Ekphoras, Herald of Grief",item=182328,locations={[1543]={42342108},},quest=60666,},
		[170048] = {name="Manifestation of Wrath",locations={[1525]={49003500},},pet=2897,quest=60729,},
		[170228] = {name="Bone Husk",locations={[1705]={},},},
		[170301] = {name="Apholeias, Herald of Loss",item=182327,locations={[1543]={19324172},},quest=60788,},
		[170302] = {name="Talaporas, Herald of Pain",item=182326,locations={[1543]={28701204},},quest=60789,},
		[170303] = {name="Exos, Herald of Domination",locations={[1543]={20586935},},quest=62260,},
		[170385] = {name="Writhing Misery",locations={[1705]={},},},
		[170414] = {name="Howling Spectre",locations={[1705]={},},},
		[170417] = {name="Animated Stygia",locations={[1705]={},},},
		[170434] = {name="Amalgamation of Sin",locations={[1525]={},},quest=60836,},
		[170548] = {name="Sundancer",locations={[1533]={60109350},},mount=1307,notes="Use the statue and a Skystrider Glider",},
		[170623] = {name="Dark Watcher",locations={[1533]={27803000},},quest=60883,},
		[170634] = {name="Shadeweaver Zeris",locations={[1543]={29805960},},quest=60884,},
		[170659] = {name="Basilofos, King of the Hill",locations={[1533]={48605080},},quest=60897,},
		[170711] = {name="Dolos",locations={[1543]={32946646},},quest=60909,},
		[170731] = {name="Thanassos",locations={[1543]={27407150},},quest=60914,},
		[170774] = {name="Eketra",locations={[1543]={23205300},},quest=60915,},
		[170833] = {name="Champion of Wisdom",locations={[1533]={39002040},},},
		[170932] = {name="Cloudfeather Guardian",locations={[1533]={49805900},},pet=2925,quest=60978,},
		[171008] = {name="Unstable Memory",locations={[1533]={43502524},},quest=60997,},
		[171009] = {name="Enforcer Aegeon",locations={[1533]={50801960},},quest=58222,},
		[171010] = {name="Corrupted Clawguard",locations={[1533]={56904778},},quest=60999,},
		[171011] = {name="Demi the Relic Hoarder",locations={[1533]={36804180},},quest=61069,},
		[171013] = {name="Embodied Hunger",locations={[1533]={47004240,55801440,59805200},},quest=61001,},
		[171014] = {name="Collector Astorestes",locations={[1533]={66004370},},quest=61002,},
		[171040] = {name="Xixin the Ravening",item=183605,locations={[1533]={47404280,59805220,63603580},},quest=61046,},
		[171041] = {name="Worldfeaster Chronn",item=183605,locations={[1533]={47404280,51803260,56001460},},quest=61047,},
		[171189] = {name="Bookkeeper Mnemis",locations={[1533]={55206220},},quest=59022,},
		[171211] = {name="Aspirant Eolis",item=183607,locations={[1533]={32602340},},quest=61083,},
		[171255] = {name="Echo of Aella",item=180062,locations={[1533]={44806460},},quest=61082,},
		[171317] = {name="Conjured Death",locations={[1543]={27731305},},quest=61106,},
		[171327] = {name="Reekmonger",locations={[1533]={30365517},},},
		[171451] = {name="Soultwister Cero",item=180164,locations={[1565]={72405160},},quest=61177,},
		[171688] = {name="Faeflayer",locations={[1565]={68402860},},quest=61184,},
		[172577] = {name="Orophea",locations={[1543]={23692139},},quest=61519,toy=181794,},
		[172862] = {name="Yero the Skittish",locations={[1543]={37406200},},quest=61568,},
		[173051] = {name="Suppressor Xelors",locations={[1705]={},},},
		[173080] = {name="Wandering Death",locations={[1705]={},},},
		[173134] = {name="Darksworn Goliath",locations={[1705]={},},},
		[173191] = {name="Soulstalker V'lara",locations={[1705]={},},},
		[173238] = {name="Deadsoul Strider",locations={[1705]={},},},
		[174108] = {name="Necromantic Anomaly",locations={[1536]={72872891},},quest=62369,},
	})
end
