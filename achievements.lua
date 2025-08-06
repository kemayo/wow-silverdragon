local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local Debug = core.Debug
local DebugF = core.DebugF

-- a few of these get to be hardcoded, because of bad types in the API
local achievements = {
	[1312] = {}, -- Bloody Rare (BC mobs)
	[2257] = {}, -- Frostbitten (Wrath mobs)
	[7317] = { -- One Many Army (Vale)
		[58771] = 20522, -- Quid
		[58778] = 20521, -- Aetha
		[63510] = 20527, -- Wulon
	},
	[7439] = {}, -- Glorious! (Pandaria mobs)
	[7932] = { -- I'm In Your Base, Killing Your Dudes (Pandara Krasarang Wilds PvP elites)
		[68321] = 1, -- Champion of Arms slain (Kar Warmaker)
		[68318] = 1, -- Champion of Arms slain (Dalan Nightbreaker)
		[68320] = 2, -- Champion of the Shadows slain (Ubunti the Shade)
		[68317] = 2, -- Champion of the Shadows slain (Mavis Harms)
		[68322] = 3, -- Champion of the Light slain (Muerta)
		[68319] = 3, -- Champion of the Light slain (Disha Fearwarden)
	},
	[8103] = {}, -- Champions of Lei Shen (Thunder Isle)
	[8535] = {}, -- Celestial Challenge (Timeless Isle)
	[8714] = {}, -- Timeless Champion (Timeless Isle)
	[9216] = {}, -- High-value targets (Ashran)
	[9400] = {}, -- Gorgrond Monster Hunter
	[9541] = {}, -- The Song of Silence
	[9571] = {}, -- Broke Back Precipice
	[9601] = {}, -- King of the Monsters
	[9617] = {}, -- Making the Cut
	[9633] = {}, -- Cut off the Head (Shatt)
	[9638] = {}, -- Heralds of the Legion (Shatt)
	[9655] = {}, -- Fight the Power (Gorgrond)
	[9678] = {}, -- Ancient No More (Gorgrond)
	[10061] = {}, -- Hellbane (Tanaan)
	[10070] = {}, -- Jungle Stalker (Tanaan)
	[11160] = {}, -- Unleashed Monstrosities
	[11261] = { -- Adventurer of Azsuna
		[89016] = 33377, -- Ravyn-Drath
		[90244] = 33262, --Arcavellus
		[90505] = 33263, -- Syphonus (Syphonus & Leodrath)
		[90803] = 33264, -- Infernal Lord (Cache of Infernals)
		[91100] = 32403, -- Brogozog (Marius & Tehd versus a Fel Lord)
		[91113] = 33267, -- Tide Behemoth
		[91114] = 33267, -- Tide Behemoth
		[91115] = 33267, -- Tide Behemoth
		[91579] = 32402, -- Kazrok (Marius & Tehd versus a Doomlord)
		[105938] = 32401, -- Felwing (Marius & Tehd versus Felbats)
		[107113] = 33373, -- Vorthax
		[107269] = 33374, -- Inquisitor Tivos
		[107657] = 33372, -- Arcanist Shal'iman
		[112636] = 33272, -- Sinister Leyrunner (Treacherous Stallions)
		[112637] = 33272, -- Devious Sunrunner (Treacherous Stallions)
	},
	[11262] = { -- Adventurer of Valsharah
		[92104] = 34537, -- (Unguarded Thistleleaf Treasure)
		[93654] = 33279, -- Skul'vrax (Elindya Featherlight)
		[93679] = 32406, -- Gathenak the Subjugator (Marius & Tehd versus a Satyr)
		[93758] = 33280, -- Antydas Nightcaller
		[94414] = 33281, -- Kiranys Duskwhisper (Haunted Manor)
		[94485] = 33282, -- Pollous the Fetid (Purging the River)
		[95123] = 33284, -- Grelda the Hag
		[95221] = 33285, -- Mad Henryk (Old Bear Trap)
		[95318] = 33286, -- Perrexx the Corruptor
		[97504] = 33287, -- Wraithtalon
		[97517] = 33288, -- Dreadbog
		[98241] = 33289, -- Lyrath Moonfeather
		[109708] = 33290, -- Undergrell Ringleader (Undergrell Attack)
		[110562] = 33291, -- Bahagar
	},
	[11263] = { -- Adventurer of Stormheim
		[90139] = 32404, -- Inquisitor Ernstenbok (Marius & Tehd versus an Inquisitor)
		[91529] = 33293, -- Glimar Ironfist
		[91795] = 33294, -- Stormwing Matriarch
		[91803] = 33295, -- Fathnyr
		[91874] = 33296, -- Bladesquall
		[91892] = 33297, -- Thane Irglov the Merciless (Thane's Mead Hall)
		[92040] = 33298, -- Fenri
		[92152] = 33299, -- Whitewater Typhoon
		[92599] = 33300, -- Worg Pack
		[92685] = 33303, -- Helmouth Raiders
		[92751] = 33304, -- Ivory Sentinel
		[92763] = 33305, -- The Nameless King
		[93166] = 33306, -- Tiptog the Lost (Lost Ettin)
		[93371] = 33307, -- Mordvigbjorn
		[93401] = 33308, -- Urgev the Flayer
		[94413] = 33309, -- Isel the Hammer
		[97630] = 33310, -- Soulthirster
		[98188] = 33311, -- Egyl the Enduring
		[98268] = 33312, -- Tarben
		[98421] = 33313, -- Kottr Vondyr
		[98503] = 33314, -- Grrvrgull the Conquerer
		[107926] = 33315, -- Hannval the Butcher
		[110363] = 33316, -- Roteye
	},
	[11264] = { -- Adventurer of Highmountain
		[95872] = 33318, -- Skullhat (Skywhisker Taskmaster)
		[96410] = 33319, -- Majestic Elderhorn
		[96590] = 33320, -- Gurbog da Basher
		[96621] = 33321, -- Mellok, Son of Torok
		[97093] = 33322, -- Shara Felbreath
		[97102] = 33334, -- Ram'Pag (Totally Safe Treasure Chest)
		[97203] = 33323, -- Tenpak Flametotem (The Exiled Shaman)
		[97220] = 33324, -- Arru (Beastmaster Pao'lek)
		[97326] = 33325, -- Hartli the Snatcher
		[97345] = 33326, -- Crawshuk the Hungry
		[97449] = 33328, -- Bristlemaul
		[97593] = 33329, -- Mynta Talonscreech (Scout Harefoot)
		[97653] = 33330, -- Taurson (The Beastly Boxer)
		[97933] = 33331, -- Crab Rider Grmlrml
		[98024] = 33332, -- Luggut the Eggeater
		[98299] = 33375, -- Bodash the Hoarder
		[98311] = 33333, -- Mrrklr (Captured Survivor)
		[98890] = 33335, -- Slumber (Slumbering Bear)
		[100230] = 33336, -- Ryael (Amateur Hunters)
		[100231] = 33336, -- Dargok (Amateur Hunters)
		[100232] = 33336, -- Sure Shot (Amateur Hunters)
		[100302] = 33340, -- Puck (Unethical Adventurers)
		[100303] = 33340, -- Zenobia (Unethical Adventurers)
		[100495] = 33337, -- Devouring Darkness
		[101077] = 33338, -- Sekhan
		[109498] = 33340, -- Xaander (Unethical Adventurers)
		[109500] = 33340, -- Jak (Unethical Adventurers)
		[109501] = 33340, -- Darkful (Unethical Adventurers)
	},
	[11265] = { -- Adventurer of Suramar
		[99610] = 33341, -- Garvrulg
		[99792] = 33342, -- Elfbane
		[100864] = 33343, -- Cora'kar
		[103183] = 33344, -- Rok'nash
		[103214] = 33345, -- Har'kess the Insatiable
		[103223] = 33346, -- Hertha Grimdottir
		[103575] = 33347, -- Reef Lord Raj'his
		[103841] = 33348, -- Shadowquil
		[105547] = 33349, -- Rauren
		[106351] = 33350, -- Artificer Lothaire
		[107846] = 33351, -- Pinchshank
		[109054] = 33352, -- Shal'an
		[109954] = 33353, -- Magister Phaedris
		[110024] = 33354, -- Mal'Dreth the Corrupter
		[110340] = 33355, -- Myonix
		[110438] = 33356, -- Siegemaster Aedrin
		[110577] = 33357, -- Oreth the Vile
		[110656] = 33358, -- Arcanist Lylandre
		[110726] = 33359, -- Cadraeus
		[110824] = 33360, -- Tideclaw
		[110832] = 33361, -- Gorgroth
		[110870] = 33362, -- Apothecary Faldren
		[110944] = 33363, -- Guardian Thor'el
		[111007] = 33364, -- Randril
		[111063] = 33364, -- Randril
		[111197] = 33365, -- Anax
		[111329] = 33366, -- Matron Hagatha
		[111649] = 33367, -- Ambassador D'vwinn
		[111651] = 33368, -- Degren
		[111653] = 33369, -- Miasu
		[112497] = 33370, -- Maia the White
		[112802] = 33371, -- Mar'tura
		[102303] = 33376, -- Lieutenant Strathmar
	},
	[11786] = {}, -- Terrors of the Shore
	[11841] = {}, -- Naxt Victim
	[12026] = {}, -- Invasion Obliteration
	[12028] = {}, -- Envision Invasion Eradication
	[12078] = { -- Commander of Argus
		[127323] = 37629, -- Ataxon
	},
	[12944] = { -- Adventurer of Zuldazar
		[129961] = 41850, -- Atal'zul Gotaka
		[129954] = 41851, -- Gahz'ralka
		[136428] = 41852, -- Dark Chronicler
		[136413] = 41853, -- Syrawon the Dominus
		[131476] = 41869, -- Zayoos
		[131233] = 41870, -- Lei-zhi
		[129343] = 41871, -- Avatar of Xolotal
		[128699] = 41872, -- Bloodbulge
		[127939] = 41873, -- Torraske the Eternal
		[126637] = 41874, -- Kandak
		[120899] = 41875, -- Kul'krazahn
		[124185] = 41876, -- Golrakahn
		[122004] = 41877, -- Umbra'jin
		[134760] = 41855, -- Darkspeaker Jo'la
		[134738] = 41856, -- Hakbi the Risen
		[134048] = 41858, -- Vukuba
		[133842] = 41859, -- Warcrawler Karkithiss
		[134782] = 41863, -- Murderbeak
		[133190] = 41864, -- Daggerjaw
		[133155] = 41865, -- G'Naat
		[132244] = 41866, -- Kiboku
		[131718] = 41867, -- Bramblewing
		[131687] = 41868, -- Tambano
	},
	[12942] = { -- Adventurer of Nazmir
		[125250] = 41440, -- Ancient Jawbreaker
		[134293] = 41447, -- Azerite-Infused Slag
		[128965] = 41450, -- Uroku the Bound
		[134296] = 41452, -- Chag's Challenge
		[125232] = 41454, -- Cursed Chest
		[121242] = 41456, -- Glompmaw
		[128974] = 41458, -- Queen Tzxi'kik
		[133373] = 41460, -- Jax'teb the Reanimated
		[124397] = 41462, -- Kal'draxa
		[134295] = 41464, -- Lost Scroll
		[127820] = 41467, -- Scout Skrasniss
		[126460] = 41469, -- Tainted Guardian
		[135565] = 41472, -- Urn of Agussu
		[126907] = 41474, -- Wardrummer Zurula
		[129657] = 41476, -- Za'amar the Queen's Blade
		[133539] = 41478, -- Lo'kuno
		[134298] = 41444, -- Azerite-Infused Elemental
		[126635] = 41448, -- Blood Priest Xak'lar
		[129005] = 41451, -- King Kooba
		[126187] = 41453, -- Corpse Bringer Yal'kar
		[127001] = 41455, -- Gwugnug the Cursed
		[128426] = 41457, -- Gutrip
		[124399] = 41459, -- Infected Direhorn
		[133527] = 41461, -- Juba the Scarred
		[125214] = 41463, -- Krubbs
		[126142] = 41466, -- Bajiatha
		[127873] = 41468, -- Scrounger Patriarch
		[126056] = 41470, -- Totem Maker Jash'ga
		[126926] = 41473, -- Venomjaw
		[133531] = 41475, -- Xu'ba
		[133812] = 41477, -- Zanxib
		[128930] = 41479, -- Mala'kili and Rohnkor
		[128935] = 41479, -- Mala'kili and Rohnkor
	},
	[12943] = { -- Adventurer of Vol'Dun
		[135852] = 41606, -- Ak'tar
		[130439] = 41607, -- Ashmane
		[128553] = 41608, -- Azer'tor
		[128497] = 41609, -- Bajiani the Slick
		[129476] = 41610, -- Bloated Krolusk
		[136393] = 41611, -- Bloodwing Bonepicker
		[136346] = 41612, -- Captain Stef "Marrow" Quin
		[124722] = 41613, -- Commodore Calhoun
		[136335] = 41614, -- Enraged Krolusk
		[128674] = 41615, -- Gut-Gut the Glutton
		[130443] = 41616, -- Hivemother Kraxi
		[129283] = 41617, -- Jumbo Sandsnapper
		[136341] = 41618, -- Jungleweb Hunter
		[128686] = 41619, -- Kamid the Trapper
		[137681] = 41620, -- King Clickyclack
		[128951] = 41621, -- Nez'ara
		[136340] = 41622, -- Relic Hunter Hazaak
		[127776] = 41623, -- Scaleclaw Broodmother
		[136336] = 41624, -- Scorpox
		[136338] = 41625, -- Sirokar
		[134571] = 41626, -- Skycaller Teskris
		[134745] = 41627, -- Skycarver Krakit
		[136304] = 41628, -- Songstress Nahjeen
		[130401] = 41629, -- Vathikur
		[129180] = 41630, -- Warbringer Hozzik
		[134638] = 41631, -- Warlord Zothix
		[134625] = 41632, -- Warmother Captive
		[129411] = 41633, -- Zunashi the Exile
	},
	[12939] = { -- Adventurer of Tiragarde Sound
		[132182] = 41793, -- Auditor Dolp
		[129181] = 41795, -- Barman Bill
		[132068] = 41796, -- Bashmu
		[132086] = 41797, -- Black-Eyed Bart
		[139145] = 41798, -- Blackthorne
		[130508] = 41800, -- Broodmother Razora
		[132088] = 41806, -- Captain Wintersail
		[139152] = 41812, -- Carla Smirk
		[132211] = 41813, -- Fowlmouth
		[132127] = 41814, -- Foxhollow Skyterror
		[139233] = 41819, -- Gulliver
		[131520] = 41820, -- Kulett the Ornery
		[134106] = 41821, -- Lumbergrasp Sentinel
		[139290] = 41822, -- Maison the Portable
		[137183] = 41823, -- Imperiled Merchants (Honey-Coated Slitherer)
		[131252] = 41824, -- Merianae
		[139205] = 41825, -- P4-N73R4
		[131262] = 41826, -- Pack Leader Asenya
		[132179] = 41827, -- Raging Swell
		[139278] = 41828, -- Ranja
		[127289] = 41829, -- Saurolisk Tamer Mugg (Mugg)
		[127290] = 41829, -- Saurolisk Tamer Mugg (Mugg)
		[139287] = 41830, -- Sawtooth
		[139285] = 41831, -- Shiverscale the Toxic
		[132280] = 41832, -- Squacks
		[139135] = 41833, -- Squirgle of the Depths
		[139280] = 41834, -- Sythian the Swift
		[133356] = 41835, -- Tempestria
		[139289] = 41836, -- Tentulos the Drifter
		[131389] = 41837, -- Teres
		[139235] = 41838, -- Tort Jaw
		[132076] = 41839, -- Totes
		[131984] = 41840, -- Twin-hearted Construct
	},
	[12941] = { -- Adventurer of Drustvar
		[124548] = 41706, -- Betsy
		[127333] = 41708, -- Barbthorn Queen
		[126621] = 41711, -- Bonesquall
		[127877] = 41713, -- Longfang & Henry Breakwater (Longfang)
		[127901] = 41713, -- Longfang & Henry Breakwater (Henry)
		[129904] = 41715, -- Cottontail Matron
		[128973] = 41718, -- Whargarble the Ill-Tempered
		[127129] = 41720, -- Grozgore
		[129805] = 41722, -- Beshol
		[129995] = 41724, -- Emily Mayville
		[130143] = 41726, -- Balethorn
		[134213] = 41728, -- Executioner Blackwell
		[134754] = 41729, -- Hyo'gi
		[137529] = 41732, -- Arvon the Betrayed
		[137825] = 41736, -- Avalanche
		[138675] = 41742, -- Gorged Boar
		[138866] = 41748, -- Fungi Trio (quest 51887 also?)
		[138870] = 41748, -- Fungi Trio (quest 51887 also?)
		[138871] = 41748, -- Fungi Trio (quest 51887 also?)
		[139322] = 41751, -- Whitney "Steelclaw" Ramsay
		[125453] = 41707, -- Quillrat Matriarch
		[127651] = 41709, -- Vicemaul
		[127844] = 41712, -- Gluttonous Yeti
		-- [] = 41714, -- Ancient Sarcophagus
		[128707] = 41717, -- Rimestone
		-- [] = 41719, -- Seething Cache
		[129835] = 41721, -- Gorehorn
		[129950] = 41723, -- Talon
		[130138] = 41725, -- Nevermore
		[132319] = 41727, -- Bilefang Mother
		[134706] = 42342, -- Deathcap
		[135796] = 41730, -- Captain Leadfist
		[137824] = 41733, -- Arclight
		[138618] = 41739, -- Haywire Golem
		[138863] = 41745, -- Sister Martha
		[139321] = 41750, -- Braedan Whitewall
	},
	[12940] = { -- Adventurer of Stormsong Valley
		[141175] = 41753, -- Song Mistress Dadalea
		[140997] = 41754, -- Severus the Outcast
		[138938] = 41755, -- Seabreaker Skoloth
		[139328] = 41756, -- Sabertron
		[139356] = 41756, -- Sabertron
		[136189] = 41757, -- The Lichen King
		[134884] = 41758, -- Ragna
		[139319] = 41759, -- Slickspill
		[137025] = 41760, -- Broodmother
		[132007] = 41761, -- Galestorm
		[142088] = 41762, -- Whirlwing
		[141029] = 41763, -- Kickers
		[131404] = 41765, -- Foreman Scripps
		[141286] = 41769, -- Poacher Zane
		[139298] = 41772, -- Pinku'shon
		[141059] = 41774, -- Grimscowl the Harebrained
		[139385] = 41775, -- Deepfang
		[140938] = 41776, -- Croaker
		[139968] = 41777, -- Corrupted Tideskipper
		[136183] = 41778, -- Crushtacean
		[134897] = 43470, -- Dagrus the Scorned
		[135939] = 41782, -- Vinespeaker Ratha
		[135947] = 41787, -- Strange Mushroom Ring
		[141226] = 41815, -- Haegol the Hammer
		[141088] = 41816, -- Squall
		[141039] = 41817, -- Ice Sickle
		[130897] = 41818, -- Captain Razorspine
		[129803] = 41841, -- Whiplash
		[141143] = 41842, -- Sister Absinthe
		[130079] = 41843, -- Wagga Snarltusk
		[138963] = 41844, -- Nestmother Acada
		[141239] = 41845, -- Osca the Bloodied
		[139988] = 41846, -- Sandfang
		[139980] = 41847, -- Taja the Tidehowler
		[140925] = 34, -- Doc Marrtens
		[141043] = 34, -- Jakala the Cruel
	},
	[12587] = {}, -- Unbound Monstrosities
	[13027] = {}, -- Mushroom Harvest
	[13470] = { -- Rest In Pistons (Mechagon)
		[151124] = 45117, -- Mechagonian Nullifier
		[151623] = 45118, -- The Scrap King
		[151625] = 45118, -- The Scrap King
		[151672] = 45119, -- Mecharantuala
		[151684] = 45121, -- Jawbreaker
		[151702] = 45122, -- Paol Pondwader
		[150575] = 45123, -- Rumblerocks
		[151934] = 45124, -- Arachnoid Harvester
		[152007] = 45125, -- Killsaw
		[151884] = 45126, -- Fungarian Furor
		[151202] = 45127, -- Foul Manifestation
		[151569] = 45128, -- Deepwater Maw
		[151296] = 45129, -- OOX-Avenger/MG
		[152001] = 45130, -- Bonepicker
		[151308] = 45131, -- Boggac Skullbash
		[151940] = 45132, -- Uncle T'Rogg
		[150937] = 45133, -- Seaspit
		[153000] = 45134, -- Sparkqueen P'Emp
		[152182] = 45135, -- Rustfeather
		[151933] = 45136, -- Malfunctioning Beastbot
		[152569] = 45137, -- Crazed Trogg
		[152570] = 45137, -- Crazed Trogg
		[150342] = 45138, -- Earthbreaker Gulroc
		[153206] = 45145, -- Ol' Big Tusk
		[153205] = 45146, -- Gemicide
		[152764] = 45157, -- Oxidized Leachbeast
		[153200] = 45152, -- Boilburn
		[152113] = 45153, -- The Kleptoboss
		[153226] = 45154, -- Steel Singer Freza
		[153228] = 45155, -- Gear Checker Cogstar
		[151627] = 45156, -- Mr. Fixthis
		[150394] = 45158, -- Vaultbot
		[154153] = 45373, -- Enforcer KX-T57
		[154225] = 45374, -- The Rusty Prince
		[154701] = 45410, -- Gorged Gear-Cruncher
		[154739] = 45411, -- Caustic Mechaslime
		[155060] = 45433, -- The Doppel Gang
		[155583] = 45691, -- Scrapclaw
	},
	[13690] = { -- Nazjatarget Eliminated (Nazjatar)
		[153299] = 45504, -- Szun, Breaker of Slaves
		[153302] = 45505, -- Frozen Winds of Zhiela
		[153300] = 45506, -- Zoko, Her Iron Defender
		[153296] = 45507, -- Tempest-Speaker Shalan'ali
		[153301] = 45508, -- Starseeker of the Shirakess
		[153311] = 45509, -- Azanz, the Slitherblade
		[153304] = 45510, -- Undana, Chilling Assassin
		[153303] = 45511, -- Kassar, Wielder of Dark Blades
		[153305] = 45512, -- The Zanj'ir Brutalizer
		[153314] = 45513, -- Champion Aldrantiss, Defender of Her Kingdom
		[153309] = 45514, -- Champion Alzana, Arrow of Thunder
		[153315] = 45515, -- Champion Eldanar, Shield of Her Glory
		[153312] = 45516, -- Champion Kyx'zhul the Deepspeaker
		[153310] = 45517, -- Champion Qalina, Spear of Ice
		[153313] = 45518, -- Champion Vyz'olgo the Mind-Taker
	},
	[13691] = {}, -- I Thought You Said They'd Be Rare (Nazjatar)
	[14159] = {}, -- Combating the Corruption (Assaults)
	[14276] = {}, -- It's Always Sinny in Revendreth
	[14307] = { -- Adventurer of Bastion
		[158659] = 50582, -- Herculon
		[160721] = 50596, -- Fallen Acolyte Erisne
		[161527] = 50597, -- Sigilback
		[161530] = 50598, -- Cloudtail
		[161529] = 50599, -- Nemaeus
		[160629] = 50592, -- Baedos
		[167078] = 50600, -- Wingflayer the Cruel
		[160882] = 50594, -- Vesper Repair: Sophia's Aria (Nikara Blackheart)
		[163460] = 50595, -- Dionae
		[170548] = 50601, -- Sundancer
		[170659] = 50602, -- Basilofos, King of the Hill
		[170623] = 50603, -- Dark Watcher
		[170932] = 50604, -- Cloudfeather Guardian
		[171009] = 50605, -- Enforcer Aegeon
		[171008] = 50606, -- Unstable Memory
		[171013] = 50607, -- Embodied Hunger
		[171040] = 50608, -- Xixin the Ravening
		[171041] = 50609, -- Worldfeaster Chronn
		[171014] = 50610, -- Collector Astorestes
		[171011] = 50611, -- Demi the Relic Hoarder
		[171189] = 50612, -- Bookkeeper Mnemis
		[171211] = 50613, -- Aspirant Eolis
		[171255] = 50614, -- Echo of Aella
		[171010] = 50615, -- Corrupted Clawguard
		[171327] = 50616, -- Reekmonger
		[161528] = 50617, -- Aethon
		[160985] = 50593, -- Vesper Repair: Sophia's Overture (Selena the Reborn)
		[156339] = 50618, -- Orstus and Sotiros
		[156340] = 50618, -- Orstus and Sotiros
		[170832] = 50619, -- The Ascended Council (Champion of Loyalty)
		[170833] = 50619, -- The Ascended Council (Champion of Wisdom)
		[170834] = 50619, -- The Ascended Council (Champion of Purity)
		[170835] = 50619, -- The Ascended Council (Champion of Courage)
		[170836] = 50619, -- The Ascended Council (Champion of Humility)
	},
	[14308] = {}, -- Adventurer of Maldraxxus
	[14309] = {}, -- Adventurer of Ardenweald
	[14310] = {}, -- Adventurer of Revendreth
	[14353] = {}, -- Ardenweald's a Stage
	[14660] = {}, -- It's About Sending A Message (Maw)
	[14721] = {}, -- It's In The Mix (Maldraxxus)
	[14744] = {}, -- Better to Be Lucky Than Dead (Maw)
	[14779] = {}, -- Wild Hunting (Ardenweald)
	[14788] = { -- Fractured Faerie Tales (Ardenweald)
		[174721] = 50012, -- A Meandering Story
		[174723] = 50013, -- A Wandering Tale
		[174724] = 50014, -- An Escapist Novel
		[174725] = 50015, -- A Travel Journal
		[174726] = 50016, -- A Naughty Story
	},
	[14802] = {}, -- Bloodsport (Maldraxxus)
	[15037] = { -- This Army
		completed = CRITERIA_COMPLETED,
		[177771] = 52044, -- Cutter Fin
		[177769] = 52045, -- Kearnen the Blade
		[177764] = 52046, -- Winslow Swan
		[177767] = 52047, -- Boil Master Yetch
		[158300] = 52048, -- Flytrap
	},
	[15042] = {completed = CRITERIA_COMPLETED}, -- Tea for the Troubled
	[15044] = {}, -- Krrprripripkraak's Heroes
	[15054] = {}, -- Minions of the Cold Dark
	[15107] = { -- Conquering Korthia
		[179755] = 52285, -- Consumption (has multiple ids)
		[179768] = 52285, -- Consumption (has multiple ids)
		[179769] = 52285, -- Consumption (has multiple ids)
	},
	[15211] = {
		completed = CRITERIA_COMPLETED, -- COVENANT_SANCTUM_UPGRADE_ACTIVATING?
		[178835] = 52573, -- Sharpeye Collector
		[179007] = 52565, -- Overgrown Geomental
		[181208] = 52567, -- Enchained Servitor
		[181219] = 52554, -- Moss-Choked Guardian
		[181221] = 52552, -- Bygone Geomental
		[181222] = 52606, -- Over-charged Vespoid
		[181223] = 52553, -- Gaiagantic
		[181287] = 52566, -- Gorged Runefeaster
		[181290] = 52569, -- Corrupted Runehoarder
		[181292] = 52570, -- Misaligned Enforcer
		[181293] = 52571, -- Suspicious Nesmin
		[181294] = 52572, -- Runegorged Bufonid
		[181295] = 52574, -- Runethief Xy'lora
		[181344] = 52575, -- Runefur
		[181349] = 52576, -- Cipherclad
		[181352] = 52577, -- Bitterbeak
		[182798] = 52686, -- Twisted Warpcrafter
		[184819] = 52568, -- Dominated Irregular
	}, -- Completing the Code
	[15391] = {}, -- Adventurer of Zereth Mortis
	[15392] = {}, -- Dune Dominance
	-- TODO: this has overlap with the adventurer mobs, so I need to improve mobs_to_achievement (also all the mobs in the achievement are kill-credit fake mobs, so I need to dig up the actual IDs)
	-- [16446] = { -- That's Pretty Neat!
	-- 	completed = SCREENSHOT_SUCCESS, -- "Screen captured"
	-- },
	[16676] = {}, -- Adventurer of the Waking Shores
	[16677] = {}, -- Adventurer of the Ohn'ahran Plains
	[16678] = {}, -- Adventurer of the Azure Span
	[16679] = {}, -- Adventurer of the Thaldraszus
	[16424] = {need=EMOTE410_CMD1, completed=DONE}, -- Who's A Good Bakar
	[16461] = {}, -- Stormed Off
	[16574] = {need=EMOTE88_CMD1, completed=DONE}, -- Sleeping on the Job
	[17525] = {}, -- Champion of the Forbidden Reach
	[17783] = {}, -- Adventurer of Zaralek Cavern
	[19316] = {}, -- Adventurer of the Emerald Dream
	[40222] = {}, -- Echoes of Danger
	[40435] = {}, -- Adventurer of the Isle of Dorn
	[40475] = { -- To All the Slimes I Love
		need=EMOTE152_CMD1, completed=DONE, -- /love
		[226626] = 68670, -- Spring Mole
		[217756] = 68673, -- Snake
		[220173] = 68674, -- Lightdarter
		[221146] = 68676, -- Tiny Sporbit
		[220369] = 68677, -- Dustcrawler Beetle
		[219581] = 68675, -- Mass of Worms (less-common variant, not sure it works)
		[219585] = 68675, -- Mass of Worms
		[217461] = 68731, -- Grottoscale Hatchling
		[220177] = 68729, -- Crackcreeper
		[214726] = 68730, -- Lava Slug
		[220370] = 68732, -- Earthenwork Stoneskitterer
		[223663] = 68733, -- Cavern Skiplet
		[217316] = 68734, -- Moss Sludglet
		[219366] = 68747, -- Cavern Mote
		[220168] = 68748, -- Stumblegrub
		[219842] = 69805, -- Darkgrotto Hopper
		[220413] = 68749, -- Oozeling
		[217559] = 68750, -- Pebble Scarab
		[216058] = 68751, -- Rock Snail
	},
	[40625] = { -- The Missing Lynx
		need=EMOTE410_CMD1, completed=DONE, -- /pet
		-- The rest have IDs associated, and are picked up fine
		[216549] = 7, -- Nightclaw
		[215590] = 8, -- Shadowpouncer
		[215593] = 9, -- Purrlock
		[215606] = 9, -- Purrlock
		[215041] = 10, -- Miral Murder-Mittens
		[219412] = 11, -- Fuzzy
		[218887] = 12, -- Furball
		[221106] = 13, -- Dander
	},
	[40837] = {}, -- Adventurer of the Ringing Deeps
	[40840] = {}, -- Adventurer of Azj-Kahet
	[40851] = {}, -- Adventurer of Hallowfall
	[40995] = {}, -- The Originals
	[40997] = {}, -- The Gatecrashers (Anniversary)
	[42729] = {need=EMOTE410_CMD1, completed=DONE}, -- Dangerous Prowlers of K'aresh, /pet
	[42761] = {}, -- Remnants of a Shattered World
}
ns.achievements = achievements
local mobs_to_achievement = {
	-- [43819] = 2257,
}
ns.mobs_to_achievement = mobs_to_achievement
local achievements_loaded = false

function ns:AchievementMobStatus(id)
	if not achievements_loaded then
		self:LoadAllAchievementMobs()
	end
	local achievement = mobs_to_achievement[id]
	if not achievement then
		return
	end
	local criteria = achievements[achievement][id]
	local _, name, _, achievement_completed, _, _, _, _, _, _, _, _, completedByMe = GetAchievementInfo(achievement)
	local retOK, _, _, completed = pcall(criteria < 100 and GetAchievementCriteriaInfo or GetAchievementCriteriaInfoByID, achievement, criteria, true)
	if not retOK then
		return
	end
	return achievement, name, completed, achievement_completed and not completedByMe
end

local allQuestsComplete
do
	local faction = UnitFactionGroup("player")
	local function doTestAll(test, input, ...)
		for _, value in ipairs(input) do
			if not test(value, ...) then
				return false
			end
		end
		return true
	end
	local function doTestAny(test, input, ...)
		for _, value in ipairs(input) do
			if test(value, ...) then
				return true
			end
		end
		return false
	end
	local function doTest(test, input, ...)
		if ns.xtype(input) == "table" then
			if input.alliance then
				return doTest(test, faction == "Alliance" and input.alliance or input.horde, ...)
			end
			if input.any then
				return doTestAny(test, input, ...)
			end
			return doTestAll(test, input, ...)
		else
			return test(input, ...)
		end
	end
	local function testMaker(test, override)
		return function(...)
			return (override or doTest)(test, ...)
		end
	end
	-- local itemInBags = testMaker(function(item) return GetItemCount(item, true) > 0 end)
	allQuestsComplete = testMaker(function(quest) return C_QuestLog.IsQuestFlaggedCompleted(quest) end)
	ns.doTest = doTest
end

-- return quest_complete, criteria_complete, achievement_completed_by_alt
-- `nil` if completion not knowable, true/false if knowable
function ns:CompletionStatus(id)
	if not ns.mobdb[id] then return end
	local _, _, criteria_complete, achievement_completed_by_alt = ns:AchievementMobStatus(id)
	local quest_complete
	if ns.mobdb[id].quest then
		quest_complete = allQuestsComplete(ns.mobdb[id].quest)
	end
	return quest_complete, criteria_complete, achievement_completed_by_alt
end

function ns:LoadAllAchievementMobs()
	if ns.CLASSICERA or not _G.GetAchievementInfo then
		-- with API synchronization, the Classic client now *has* achievement functions, just... uselessly.
		achievements_loaded = true
	end
	if achievements_loaded then
		return
	end
	local known = {}
	for achievement in pairs(achievements) do
		local missing = 0
		for k,v in pairs(achievements[achievement]) do
			known[v] = k
		end
		local num_criteria = GetAchievementNumCriteria(achievement)
		for i = 1, num_criteria do
			local description, ctype, completed, _, _, _, _, id, _, criteriaid = GetAchievementCriteriaInfo(achievement, i)
			if not known[criteriaid] then
				if ctype == 0 and id then
					-- "kill a mob"
					achievements[achievement][id] = criteriaid
				-- elseif ctype == 27 then
					-- "complete a quest"
				else
					if missing == 0 then
						local _, name = GetAchievementInfo(achievement)
						Debug('Missing mobs from achievement')
						DebugF('[%s] = { -- %s', achievement, name)
					end
					DebugF('	[] = %d, -- %s', criteriaid, description)
					missing = missing + 1
				end
			end
			achievements_loaded = true
		end
		for mobid, criteriaid in pairs(achievements[achievement]) do
			mobs_to_achievement[mobid] = achievement
		end
		if missing > 0 then
			DebugF('} -- Got %d of %d', num_criteria - missing, num_criteria)
		end
		wipe(known)
	end
end

function ns:UpdateTooltipWithCompletion(tooltip, id)
	if not id then
		return
	end

	local achievement, name, completed = ns:AchievementMobStatus(id)
	if achievement then
		tooltip:AddDoubleLine(
			name,
			completed and (achievements[achievement].completed or BOSS_DEAD) or (achievements[achievement].need or ACTION_PARTY_KILL),
			1, 1, 0,
			completed and 0 or 1, completed and 1 or 0, 0
		)
	end
	if ns.mobdb[id] and ns.mobdb[id].quest then
		completed = allQuestsComplete(ns.mobdb[id].quest)
		tooltip:AddDoubleLine(
			QUESTS_COLON:gsub(":", ""),
			completed and COMPLETE or INCOMPLETE,
			1, 1, 0,
			completed and 0 or 1, completed and 1 or 0, 0
		)
	end
end
