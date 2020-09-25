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
	[8103] = {}, -- Champions of Lei Shen (Thunder Isle)
	[8714] = {}, -- Timeless Champion (Timeless Isle)
	[9216] = {}, -- High-value targets (Ashran)
	[9400] = {}, -- Gorgrond Monster Hunter
	[9541] = {}, -- The Song of Silence
	[9571] = {}, -- Broke Back Precipice
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
	[13690] = {}, -- Nazjatarget Eliminated (Nazjatar)
	[13691] = {}, -- I Thought You Said They'd Be Rare (Nazjatar)
	[14159] = {}, -- Combating the Corruption (Assaults)
}
core.achievements = achievements
local mobs_to_achievement = {
	-- [43819] = 2257,
}
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
	local completed
	if criteria < 40 then
		_, _, completed = GetAchievementCriteriaInfo(achievement, criteria)
	else
		_, _, completed = GetAchievementCriteriaInfoByID(achievement, criteria)
	end
	return achievement, name, completed, achievement_completed and not completedByMe
end

-- return quest_complete, criteria_complete, achievement_completed_by_alt
-- `nil` if completion not knowable, true/false if knowable
function ns:CompletionStatus(id)
	local _, questid = core:GetMobInfo(id)
	local _, _, criteria_complete, achievement_completed_by_alt = ns:AchievementMobStatus(id)
	local quest_complete
	if questid then
		quest_complete = C_QuestLog.IsQuestFlaggedCompleted(questid)
	end
	return quest_complete, criteria_complete, achievement_completed_by_alt
end

function ns:LoadAllAchievementMobs()
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
					DebugF('    [] = %d, -- %s', criteriaid, description)
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
		tooltip:AddDoubleLine(name, completed and ACTION_PARTY_KILL or NEED,
			1, 1, 0,
			completed and 0 or 1, completed and 1 or 0, 0
		)
	end
	local _, questid = core:GetMobInfo(id)
	if questid then
		completed = C_QuestLog.IsQuestFlaggedCompleted(questid)
		tooltip:AddDoubleLine(
			QUESTS_COLON:gsub(":", ""),
			completed and COMPLETE or INCOMPLETE,
			1, 1, 0,
			completed and 0 or 1, completed and 1 or 0, 0
		)
	end
end

function ns:LootStatus(id)
	if not id or not ns.mobdb[id] then
		return
	end

	local toy = ns.mobdb[id].toy and PlayerHasToy(ns.mobdb[id].toy)
	local mount = ns.mobdb[id].mount and select(11, C_MountJournal.GetMountInfoByID(ns.mobdb[id].mount))
	local pet = ns.mobdb[id].pet and (C_PetJournal.GetNumCollectedInfo(ns.mobdb[id].pet) > 0)

	return toy, mount, pet
end
function ns:UpdateTooltipWithLootDetails(tooltip, id, only)
	if not (id and ns.mobdb[id]) then
		return
	end

	local toy = ns.mobdb[id].toy and (not only or only == "toy")
	local mount = ns.mobdb[id].mount and (not only or only == "mount")
	local pet = ns.mobdb[id].pet and (not only or only == "pet")

	if toy then
		tooltip:SetHyperlink(("item:%d"):format(ns.mobdb[id].toy))
	end
	if mount then
		if toy then
			tooltip:AddLine("---")
		end
		local name, spellid, texture, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(ns.mobdb[id].mount)
		local _, description, source = C_MountJournal.GetMountInfoExtraByID(ns.mobdb[id].mount)

		tooltip:AddLine(name)
		tooltip:AddTexture(texture)
		tooltip:AddLine(description, 1, 1, 1, true)
		tooltip:AddLine(source)
		if isCollected then
			tooltip:AddLine(USED, 1, 0, 0)
		end
	end
	if pet then
		if toy or mount then
			tooltip:AddLine('---')
		end
		local name, texture, _, mobid, source, description = C_PetJournal.GetPetInfoBySpeciesID(ns.mobdb[id].pet)
		local owned, limit = C_PetJournal.GetNumCollectedInfo(ns.mobdb[id].pet)
		tooltip:AddLine(name)
		tooltip:AddTexture(texture)
		tooltip:AddLine(description, 1, 1, 1, true)
		tooltip:AddLine(source)
		tooltip:AddLine(ITEM_PET_KNOWN:format(owned, limit))
	end
end
function ns:UpdateTooltipWithLootSummary(tooltip, id)
	if not (id and ns.mobdb[id]) then
		return
	end

	if ns.mobdb[id].mount then
		local name, _, icon, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(ns.mobdb[id].mount)
		if name then
			tooltip:AddDoubleLine(
				MOUNT,
				"|T" .. icon .. ":0|t " .. name,
				1, 1, 0,
				isCollected and 0 or 1, isCollected and 1 or 0, 0
			)
		end
	end
	if ns.mobdb[id].pet then
		local name, icon = C_PetJournal.GetPetInfoBySpeciesID(ns.mobdb[id].pet)
		local owned, limit = C_PetJournal.GetNumCollectedInfo(ns.mobdb[id].pet)
		if name then
			local r, g, b = 1, 0, 0
			if owned == limit then
				r, g, b = 0, 1, 0
			elseif owned > 0 then
				r, g, b = 1, 1, 0
			end
			tooltip:AddDoubleLine(
				TOOLTIP_BATTLE_PET,
				"|T" .. icon .. ":0|t " .. (ITEM_SET_NAME):format(name, owned, limit),
				1, 1, 0,
				r, g, b
			)
		end
	end
	if ns.mobdb[id].toy then
		local _, name, icon = C_ToyBox.GetToyInfo(ns.mobdb[id].toy)
		local owned = PlayerHasToy(ns.mobdb[id].toy)
		if name then
			tooltip:AddDoubleLine(
				TOY,
				"|T" .. icon .. ":0|t " .. name,
				1, 1, 0,
				owned and 0 or 1, owned and 1 or 0, 0
			)
		end
	end
end
