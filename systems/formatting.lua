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

local function status_color(done, text)
	return (done and completeColor or incompleteColor):WrapTextInColorCode(text)
end
local function icon_and_text(icon, text)
	return quick_texture_markup(icon) .. " " .. text
end

local GetQuestTitle = C_QuestLog.GetTitleForQuestID or C_QuestLog.GetQuestInfo
local function get_spell_info(id)
	if C_Spell and C_Spell.GetSpellInfo then
		local info = C_Spell.GetSpellInfo(id)
		if info then
			return info.name, info.iconID
		end
	else
		local name, _, icon = GetSpellInfo(id)
		return name, icon
	end
end
local function get_faction_name(id)
	if C_Reputation and C_Reputation.GetFactionDataByID then
		local info = C_Reputation.GetFactionDataByID(id)
		return info and info.name
	elseif GetFactionInfoByID then
		return (GetFactionInfoByID(id))
	end
end

-- Each renderer is called as renderer(id, subid, subvariant, fallback) and
-- returns the plain text, then (optionally) a decorated version with icons and
-- completion colours. A `.plain` subvariant picks the first. Returning nothing
-- means "not available yet", and the caller uses the fallback instead.
-- id is a number for numeric tokens; for `main.sub` ids it's the main part.
local renderers = {}

renderers.item = function(id)
	local name, link, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(id)
	if link and icon then
		return name, icon_and_text(icon, (link:gsub("[%[%]]", "")))
	end
end

renderers.spell = function(id)
	local name, icon = get_spell_info(id)
	if name and icon then
		return name, icon_and_text(icon, name)
	end
end

local function quest_renderer(variant)
	local atlas = variant == "worldquest" and "worldquest-tracker-questmarker" or "questnormal"
	return function(id, _, _, fallback)
		local name = GetQuestTitle(id)
		if not (name and name ~= "") then
			-- we bypass the normal fallback mechanism because we want the quest completion status
			name = fallback ~= "" and fallback or (variant .. ':' .. id)
		end
		if variant == "questname" then return name end
		return name, CreateAtlasMarkup(atlas) .. status_color(C_QuestLog.IsQuestFlaggedCompleted(id), name)
	end
end
renderers.quest = quest_renderer("quest")
renderers.worldquest = quest_renderer("worldquest")
renderers.questname = quest_renderer("questname")

renderers.questid = function(id)
	return tostring(id), CreateAtlasMarkup("questnormal") .. status_color(C_QuestLog.IsQuestFlaggedCompleted(id), id)
end

local function questline_text(questLine)
	if questLine then
		local completed = questLine.isAccountCompleted and not questLine.inProgress
		return questLine.questLineName,
			CreateAtlasMarkup("questlog-storylineicon") .. " " .. status_color(completed, questLine.questLineName)
	end
end
-- questlinebyquest:questID[.uiMapID]
renderers.questlinebyquest = function(id, subid)
	return questline_text(C_QuestLine.GetQuestLineInfo(id, subid))
end
-- questline:uiMapID.questLineID
renderers.questline = function(id, subid)
	for _, line in ipairs(C_QuestLine.GetAvailableQuestLines(id) or {}) do
		if line.questLineID == subid then
			return questline_text(line)
		end
	end
end

renderers.achievement = function(id, subid, subvariant)
	if subid then
		local criteria, _, completed, _, _, completedBy = ns.GetCriteria(id, subid)
		if criteria then
			if subvariant == "character" then
				completed = completedBy == ns.playerName
			end
			return criteria, status_color(completed, criteria)
		end
	else
		local _, name, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe = GetAchievementInfo(id)
		if name and name ~= "" then
			if subvariant == "character" then
				completed = wasEarnedByMe
			end
			return name, CreateAtlasMarkup("storyheader-cheevoicon") .. " " .. status_color(completed, name)
		end
	end
end
renderers.achievementname = function(...)
	return (renderers.achievement(...))
end

renderers.npc = function(id)
	return ns.mob_name(id)
end

renderers.currency = function(id)
	local info = C_CurrencyInfo.GetCurrencyInfo(id)
	if info then
		return info.name, icon_and_text(info.iconFileID, info.name)
	end
end
renderers.currencyicon = function(id)
	local info = C_CurrencyInfo.GetCurrencyInfo(id)
	if info then
		return quick_texture_markup(info.iconFileID)
	end
end

renderers.covenant = function(id)
	local data = C_Covenants.GetCovenantData(id)
	local name = data and data.name or ns.covenants[id]
	if name then
		local color = COVENANT_COLORS[id]
		return name, color and color:WrapTextInColorCode(name) or name
	end
end

renderers.majorfaction = function(id)
	local info = C_MajorFactions.GetMajorFactionData(id)
	if info and info.name then
		local icon = info.textureKit and CreateAtlasMarkup(("majorFactions_icons_%s512"):format(info.textureKit)) .. " " or ""
		return info.name, icon .. info.name
	end
end

renderers.faction = function(id, subid)
	local name = get_faction_name(id)
	if name then
		if subid then
			return TEXT_MODE_A_STRING_VALUE_TYPE:format(name, GetText("FACTION_STANDING_LABEL"..subid, UnitSex("player")) or tostring(subid))
		end
		return name
	end
end

renderers.garrisontalent = function(id)
	local info = C_Garrison.GetTalentInfo(id)
	if info then
		return info.name, icon_and_text(info.icon, status_color(info.researched, info.name))
	end
end

-- trait:treeID.nodeID
renderers.trait = function(treeID, nodeID)
	if not nodeID then return end
	local configID = C_Traits.GetConfigIDByTreeID(treeID)
	local nodeInfo = configID and C_Traits.GetNodeInfo(configID, nodeID)
	if nodeInfo and nodeInfo.ID ~= 0 then
		local entryID = nodeInfo.activeEntry and nodeInfo.activeEntry.entryID
		local entryInfo = entryID and C_Traits.GetEntryInfo(configID, entryID)
		if entryInfo and entryInfo.definitionID then
			local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
			local name = TalentUtil.GetTalentNameFromInfo(definitionInfo)
			if name and name ~= "" then
				local colored = status_color(nodeInfo.ranksPurchased > 0, name)
				local texture = TalentButtonUtil.CalculateIconTextureFromInfo(definitionInfo)
				return name, texture and icon_and_text(texture, colored) or colored
			end
		end
	end
end

renderers.profession = function(id)
	local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(id)
	-- there's also info.parentProfessionName for the general case ("Dragon Isles Inscription" vs "Inscription")
	if info and info.professionName and info.professionName ~= "" then
		return info.professionName
	end
end

renderers.zone = function(id, _, subvariant)
	if subvariant == "group" then
		local groupID = C_Map.GetMapGroupID(id)
		-- GetMapGroupMembersInfo can come back nil rather than an empty table
		if groupID then
			for _, groupInfo in ipairs(C_Map.GetMapGroupMembersInfo(groupID) or {}) do
				if groupInfo.mapID == id then
					return groupInfo.name
				end
			end
		end
	end
	local info = C_Map.GetMapInfo(id)
	return info and info.name
end
renderers.map = renderers.zone

-- See: https://wago.tools/db2/AreaTable or C_MapExplorationInfo.GetExploredAreaIDsAtPosition
renderers.area = function(id)
	return C_Map.GetAreaInfo(id)
end

renderers.expansion = function(id)
	return _G["EXPANSION_NAME"..id]
end

-- {gc:colorname:text}, with the colour from the global COLORNAME_FONT_COLOR
renderers.gc = function(id, _, _, fallback)
	if fallback ~= "" and _G[strupper(id).."_FONT_COLOR"] then
		return "|cn" .. strupper(id).."_FONT_COLOR:" .. fallback .. "|r"
	end
end

renderers.a = function(id)
	return CreateAtlasMarkup(id == "*" and "PlayerPartyBlip" or id)
end

local function render_replacer(variant, id, fallback)
	local baseVariant, baseID = variant, id
	local mainid, subid = id:match("^(%d+)%.(%d+)$")
	if mainid then
		id, subid = tonumber(mainid), tonumber(subid)
	elseif id:match("^%d+$") then
		id = tonumber(id)
	end
	-- TODO: multiple variants?
	local mainvariant, subvariant = variant:match("^(%l+)%.(%l+)$")
	if subvariant then
		variant = mainvariant
	end
	local renderer = renderers[variant]
	if renderer then
		local plain, decorated = renderer(id, subid, subvariant, fallback)
		local result = (subvariant ~= "plain" and decorated) or plain
		if result then
			return result
		end
	end
	return fallback ~= "" and fallback or (baseVariant .. ':' .. baseID)
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
	if not s then return nil end
	return (s:gsub("{([%l.]+):([^:}]+):?([^}]*)}", safe_render_replacer))
end
local function cache_string(s, context)
	if type(s) == "function" then s = s(context) end
	if not s then return end
	for variant, id in s:gmatch("{([%l.]+):(%d+)[:}]") do
		id = tonumber(id)
		variant = variant:match("^%l+")
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
local function render_string_list(point, variant, ...)
	if not ... then return "" end
	if ns.xtype(...) == "table" then return render_string_list(point, variant, unpack(...)) end
	local out = {...}
	for i = 1, select("#", ...) do
		out[i] = ("{%s:%d}"):format(variant, out[i])
	end
	return render_string(table.concat(out, ", "), point)
end
ns.render_string = render_string
ns.render_string_list = render_string_list
ns.cache_string = cache_string
