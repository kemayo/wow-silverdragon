local myname, ns = ...

-- Rendering for the {variant:id:fallback} tokens used in labels and notes.
-- This file is kept in sync with SilverDragon, so it takes ns.mob_name from
-- its host rather than owning one -- the two have quite different lookups.

local issecretvalue = _G.issecretvalue or function() return false end

-- Looking a creature's name up from its id. The guards matter: before the data
-- has loaded this answers UNKNOWNOBJECT, and caching that would stick for the
-- rest of the session with no retry. The secret check has to come first --
-- comparing a secret string against a normal one is itself the error, so a
-- guard sitting after that comparison never gets the chance to run.
local name_from_creature_id
if _G.C_TooltipInfo then
	name_from_creature_id = function(id)
		local info = C_TooltipInfo.GetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
		if info and info.lines and info.lines[1] and info.lines[1].type == Enum.TooltipDataLineType.UnitName then
			local name = info.lines[1].leftText
			if name and not issecretvalue(name) and name ~= UNKNOWNOBJECT then
				return name
			end
		end
	end
else
	-- pre-10.0.2
	local tooltipName = myname .. "CacheScanningTooltip"
	local cache_tooltip, leftText = _G[tooltipName], _G[tooltipName .. "TextLeft1"]
	if not cache_tooltip then
		cache_tooltip = CreateFrame("GameTooltip", tooltipName)
		leftText = cache_tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText")
		cache_tooltip:AddFontStrings(leftText, cache_tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"))
	end
	name_from_creature_id = function(id)
		-- this doesn't work with just clearlines and the setowner outside of this, and I'm not sure why
		cache_tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
		cache_tooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
		if cache_tooltip:IsShown() then
			local name = leftText:GetText()
			if name and not issecretvalue(name) and name ~= UNKNOWNOBJECT then
				return name
			end
		end
	end
end
ns.name_from_creature_id = name_from_creature_id

do
	local name_cache = {}
	-- Hosts with their own mob database (SilverDragon) replace this with a
	-- wrapper that falls back to it; everything here goes through ns.mob_name.
	ns.mob_name = function(id)
		if not name_cache[id] then
			name_cache[id] = name_from_creature_id(id)
		end
		return name_cache[id]
	end
end

local function quick_texture_markup(icon)
	-- needs less than CreateTextureMarkup
	return icon and ('|T' .. icon .. ':0:0:1:-1|t') or ''
end
ns.quick_texture_markup = quick_texture_markup
local completeColor = CreateColor(0, 1, 0, 1)
local incompleteColor = CreateColor(1, 0, 0, 1)
local function render_replacer(variant, id, fallback)
	local mainid, subid = id:match("(%d+)%.(%d+)")
	mainid, subid = mainid and tonumber(mainid), subid and tonumber(subid)
	id = mainid or (id:match('^%d+$') and tonumber(id) or id)
	-- TODO: multiple variants?
	local mainvariant, subvariant = variant:match("(%l+)%.(%l+)")
	if subvariant then
		variant = mainvariant
	end
	if variant == "item" then
		local name, link, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(id)
		if link and icon then
			if subvariant == "plain" then return name end
			return quick_texture_markup(icon) .. " " .. link:gsub("[%[%]]", "")
		end
	elseif variant == "spell" then
		local name, icon, _
		if C_Spell and C_Spell.GetSpellInfo then
			local info = C_Spell.GetSpellInfo(id)
			if info then
				name, icon = info.name, info.iconID
			end
		else
			name, _, icon = GetSpellInfo(id)
		end
		if name and icon then
			if subvariant == "plain" then return name end
			return quick_texture_markup(icon) .. " " .. name
		end
	elseif variant == "quest" or variant == "worldquest" or variant == "questname" then
		local name = (C_QuestLog.GetTitleForQuestID or C_QuestLog.GetQuestInfo)(id)
		if not (name and name ~= "") then
			-- we bypass the normal fallback mechanism because we want the quest completion status
			name = fallback ~= "" and fallback or (variant .. ':' .. id)
		end
		if variant == "questname" or subvariant == "plain" then return name end
		local completed = C_QuestLog.IsQuestFlaggedCompleted(id)
		return CreateAtlasMarkup(variant == "worldquest" and "worldquest-tracker-questmarker" or "questnormal") ..
			(completed and completeColor or incompleteColor):WrapTextInColorCode(name)
	elseif variant == "questid" then
		if subvariant == "plain" then return id end
		return CreateAtlasMarkup("questnormal") .. (C_QuestLog.IsQuestFlaggedCompleted(id) and completeColor or incompleteColor):WrapTextInColorCode(id)
	elseif variant == "achievement" or variant == "achievementname" then
		if mainid and subid then
			local criteria, _, completed, _, _, completedBy = ns.GetCriteria(mainid, subid)
			if criteria then
				if variant == "achievementname" or subvariant == "plain" then return criteria end
				if subvariant == "character" then
					completed = completedBy == ns.playerName
				end
				return (completed and completeColor or incompleteColor):WrapTextInColorCode(criteria)
			end
			id = 'achievement:'..mainid..'.'..subid
		else
			local _, name, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe = GetAchievementInfo(id)
			if name and name ~= "" then
				if variant == "achievementname" or subvariant == "plain" then return name end
				if subvariant == "character" then
					completed = wasEarnedByMe
				end
				return CreateAtlasMarkup("storyheader-cheevoicon") .. " " .. (completed and completeColor or incompleteColor):WrapTextInColorCode(name)
			end
		end
	elseif variant == "npc" then
		local name = ns.mob_name(id)
		if name then
			return name
		end
	elseif variant == "currency" then
		local info = C_CurrencyInfo.GetCurrencyInfo(id)
		if info then
			if subvariant == "plain" then return info.name end
			return quick_texture_markup(info.iconFileID) .. " " .. info.name
		end
	elseif variant == "currencyicon" then
		local info = C_CurrencyInfo.GetCurrencyInfo(id)
		if info then
			return quick_texture_markup(info.iconFileID)
		end
	elseif variant == "covenant" then
		local data = C_Covenants.GetCovenantData(id)
		local name = data and data.name or ns.covenants[id]
		if subvariant == "plain" then return name end
		return COVENANT_COLORS[id]:WrapTextInColorCode(name)
	elseif variant == "majorfaction" then
		local info = C_MajorFactions.GetMajorFactionData(id)
		if info and info.name then
			if subvariant == "plain" then return info.name end
			return CreateAtlasMarkup(("majorFactions_icons_%s512"):format(info.textureKit)) .. " " .. info.name
		end
	elseif variant == "faction" then
		local name
		if C_Reputation and C_Reputation.GetFactionDataByID then
			local info = C_Reputation.GetFactionDataByID(id)
			if info and info.name then
				name = info.name
			end
		elseif GetFactionInfoByID then
			name = GetFactionInfoByID(id)
		end
		if name then
			if subid then
				return TEXT_MODE_A_STRING_VALUE_TYPE:format(name, GetText("FACTION_STANDING_LABEL"..subid, UnitSex("player")) or tostring(subid))
			end
			return name
		end
	elseif variant == "garrisontalent" then
		local info = C_Garrison.GetTalentInfo(id)
		if info then
			if subvariant == "plain" then return info.name end
			return quick_texture_markup(info.icon) .. " " .. (info.researched and completeColor or incompleteColor):WrapTextInColorCode(info.name)
		end
	elseif variant == "trait" then
		local treeID, nodeID = mainid, subid
		local configID = C_Traits.GetConfigIDByTreeID(treeID)
		local nodeInfo = configID and C_Traits.GetNodeInfo(configID, nodeID)
		if nodeInfo and nodeInfo.ID ~= 0 then
			local known = nodeInfo.ranksPurchased > 0
			local entryID = nodeInfo.activeEntry and nodeInfo.activeEntry.entryID
			local entryInfo = entryID and C_Traits.GetEntryInfo(configID, entryID)
			if entryInfo and entryInfo.definitionID then
				local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
				local name = TalentUtil.GetTalentNameFromInfo(definitionInfo)
				if name and name ~= "" then
					if subvariant == "plain" then return name end
					name = (known and completeColor or incompleteColor):WrapTextInColorCode(name)
					local texture = TalentButtonUtil.CalculateIconTextureFromInfo(definitionInfo)
					if texture then
						return quick_texture_markup(texture) .. " " .. name
					end
					return name
				end
			end
		end
	elseif variant == "profession" then
		local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(id)
		if (info and info.professionName and info.professionName ~= "") then
			-- there's also info.parentProfessionName for the general case ("Dragon Isles Inscription" vs "Inscription")
			return info.professionName
		end
	elseif variant == "zone" or variant == "map" then
		local info = C_Map.GetMapInfo(id)
		if info and info.name then
			return info.name
		end
	elseif variant == "area" then
		-- See: https://wago.tools/db2/AreaTable or C_MapExplorationInfo.GetExploredAreaIDsAtPosition
		local name = C_Map.GetAreaInfo(id)
		if name then
			return name
		end
	elseif variant == "expansion" then
		if _G["EXPANSION_NAME"..id] then
			return _G["EXPANSION_NAME"..id]
		end
	elseif variant == "gc" and fallback then
		if _G[strupper(id).."_FONT_COLOR"] then
			return "|cn" .. strupper(id).."_FONT_COLOR:" .. fallback .. "|r"
		end
	elseif variant == "a" then
		if id == "*" then
			id = "PlayerPartyBlip"
		end
		return CreateAtlasMarkup(id)
	end
	return fallback ~= "" and fallback or (variant .. ':' .. id)
end
local function safe_render_replacer(...)
	local replacement = render_replacer(...)
	if issecretvalue(replacement) then
		return "<secret>"
	end
	return replacement
end
local function render_string(s, context)
	if type(s) == "function" then s = s(context) end
	return s:gsub("{([^:}]+):([^:}]+):?([^}]*)}", safe_render_replacer)
end
local function cache_string(s, context)
	if not s then return end
	if type(s) == "function" then s = s(context) end
	for variant, id, fallback in s:gmatch("{(%l+):(%d+):?([^}]*)}") do
		id = tonumber(id)
		if variant == "item" then
			C_Item.RequestLoadItemDataByID(id)
		elseif variant == "spell" then
			C_Spell.RequestLoadSpellData(id)
		elseif variant == "quest" or variant == "worldquest" or variant == "questname" then
			if C_QuestLog.RequestLoadQuestByID then
				-- Not present in classic
				C_QuestLog.RequestLoadQuestByID(id)
			end
		elseif variant == "npc" then
			ns.mob_name(id)
		end
	end
end
local render_string_list
do
	local out = {}
	function render_string_list(point, variant, ...)
		if not ... then return "" end
		if ns.xtype(...) == "table" then return render_string_list(point, variant, unpack(...)) end
		wipe(out)
		for i=1,select("#", ...) do
			table.insert(out, ("{%s:%d}"):format(variant, (select(i, ...))))
		end
		return render_string(string.join(", ", unpack(out)), point)
	end
end
ns.render_string = render_string
ns.render_string_list = render_string_list
ns.cache_string = cache_string
