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
	[9216] = {}, -- HighValueTargets
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
		[100302] = 33340, -- Zenobia (Unethical Adventurers)
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
	[12078] = {}, -- Commander of Argus
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
	local _, name = GetAchievementInfo(achievement)
	local _, _, completed = GetAchievementCriteriaInfoByID(achievement, criteria)
	return achievement, name, completed
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
-- return complete, completion_knowable
function ns:IsMobComplete(id)
	local name, questid, vignette, tameable, last_seen, times_seen = core:GetMobInfo(id)
	if questid then
		return IsQuestFlaggedCompleted(questid), true
	end
	if mobs_to_achievement[id] then
		achievement, achievement_name, complete = ns:AchievementMobStatus(id)
		return complete, achievement
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
		completed = IsQuestFlaggedCompleted(questid)
		tooltip:AddDoubleLine(
			QUESTS_COLON:gsub(":", ""),
			completed and COMPLETE or INCOMPLETE,
			1, 1, 0,
			completed and 0 or 1, completed and 1 or 0, 0
		)
	end
end