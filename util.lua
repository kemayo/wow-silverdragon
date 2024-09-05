local myname, ns = ...

local addon = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local Debug = addon.Debug
local DebugF = addon.DebugF

local HBD = LibStub("HereBeDragons-2.0")

-- Strings

local function quick_texture_markup(icon)
	-- needs less than CreateTextureMarkup
	return '|T' .. icon .. ':0:0:1:-1|t'
end
ns.quick_texture_markup = quick_texture_markup
local completeColor = CreateColor(0, 1, 0, 1)
local incompleteColor = CreateColor(1, 0, 0, 1)
function addon:RenderString(s, context)
	if type(s) == "function" then s = s(context) end
	return s:gsub("{(%l+):([^:}]+):?([^}]*)}", function(variant, id, fallback)
		local mainid, subid = id:match("(%d+)%.(%d+)")
		mainid, subid = mainid and tonumber(mainid), subid and tonumber(subid)
		id = tonumber(id)
		if variant == "item" then
			local name, link, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(id)
			if link and icon then
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
				return quick_texture_markup(icon) .. " " .. name
			end
		elseif variant == "quest" or variant == "worldquest" or variant == "questname" then
			local name = C_QuestLog.GetTitleForQuestID(id)
			if not (name and name ~= "") then
				-- we bypass the normal fallback mechanism because we want the quest completion status
				name = fallback ~= "" and fallback or (variant .. ':' .. id)
			end
			if variant == "questname" then return name end
			local completed = C_QuestLog.IsQuestFlaggedCompleted(id)
			return CreateAtlasMarkup(variant == "worldquest" and "worldquest-tracker-questmarker" or "questnormal") ..
				(completed and completeColor or incompleteColor):WrapTextInColorCode(name)
		elseif variant == "questid" then
			return CreateAtlasMarkup("questnormal") .. (C_QuestLog.IsQuestFlaggedCompleted(id) and completeColor or incompleteColor):WrapTextInColorCode(id)
		elseif variant == "achievement" or variant == "achievementname" then
			if mainid and subid then
				local criteria, _, completed = ns.GetCriteria(mainid, subid)
				if criteria then
					if variant == "achievementname" then return criteria end
					return (completed and completeColor or incompleteColor):WrapTextInColorCode(criteria)
				end
				id = 'achievement:'..mainid..'.'..subid
			else
				local _, name, _, completed = GetAchievementInfo(id)
				if name and name ~= "" then
					if variant == "achievementname" then return name end
					return CreateAtlasMarkup("storyheader-cheevoicon") .. " " .. (completed and completeColor or incompleteColor):WrapTextInColorCode(name)
				end
			end
		elseif variant == "npc" then
			local name = self:NameForMob(id)
			if name then
				return name
			end
		elseif variant == "currency" then
			local info = C_CurrencyInfo.GetCurrencyInfo(id)
			if info then
				return quick_texture_markup(info.iconFileID) .. " " .. info.name
			end
		elseif variant == "currencyicon" then
			local info = C_CurrencyInfo.GetCurrencyInfo(id)
			if info then
				return quick_texture_markup(info.iconFileID)
			end
		elseif variant == "covenant" then
			local data = C_Covenants.GetCovenantData(id)
			return COVENANT_COLORS[id]:WrapTextInColorCode(data and data.name or ns.covenants[id])
		elseif variant == "majorfaction" then
			local info = C_MajorFactions.GetMajorFactionData(id)
			if info and info.name then
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
				return name
			end
		elseif variant == "garrisontalent" then
			local info = C_Garrison.GetTalentInfo(id)
			if info then
				return quick_texture_markup(info.icon) .. " " .. (info.researched and completeColor or incompleteColor):WrapTextInColorCode(info.name)
			end
		elseif variant == "profession" then
			local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(id)
			if (info and info.professionName and info.professionName ~= "") then
				-- there's also info.parentProfessionName for the general case ("Dragon Isles Inscription" vs "Inscription")
				return info.professionName
			end
		elseif variant == "zone" then
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
		end
		return fallback ~= "" and fallback or (variant .. ':' .. id)
	end)
end
function addon:CacheString(s)
	if not s then return end
	if type(s) == "function" then s = s() end
	for variant, id, fallback in s:gmatch("{(%l+):(%d+):?([^}]*)}") do
		id = tonumber(id)
		if variant == "item" then
			C_Item.RequestLoadItemDataByID(id)
		elseif variant == "spell" then
			C_Spell.RequestLoadSpellData(id)
		elseif variant == "quest" or variant == "worldquest" then
			C_QuestLog.RequestLoadQuestByID(id)
		elseif variant == "npc" then
			self:NameForMob(id)
		end
	end
end
do
	local out = {}
	function addon:RenderStringList(variant, ...)
		if not ... then return "" end
		if ns.xtype(...) == "table" then return self:RenderStringList(variant, unpack(...)) end
		wipe(out)
		for i=1,select("#", ...) do
			table.insert(out, ("{%s:%d}"):format(variant, (select(i, ...))))
		end
		return self:RenderString(string.join(", ", unpack(out)))
	end
end

function addon:ColorTextByCompleteness(complete, text)
	return (complete and completeColor or incompleteColor):WrapTextInColorCode(text)
end

-- GUID / unit

do
	local valid_unit_types = {
		Creature = true, -- npcs
		Vehicle = true, -- vehicles
	}
	local function npcIdFromGuid(guid)
		if not guid then return end
		local unit_type, id = guid:match("(%a+)-%d+-%d+-%d+-%d+-(%d+)-.+")
		if not (unit_type and valid_unit_types[unit_type]) then
			return
		end
		return tonumber(id)
	end
	ns.IdFromGuid = npcIdFromGuid
	function addon:UnitID(unit)
		return npcIdFromGuid(UnitGUID(unit))
	end
	function addon:FindUnitWithID(id)
		if self:UnitID('target') == id then
			return 'target'
		end
		if self:UnitID('mouseover') == id then
			return 'mouseover'
		end
		for _, nameplate in ipairs(C_NamePlate.GetNamePlates()) do
			if self:UnitID(nameplate.namePlateUnitToken) == id then
				return nameplate.namePlateUnitToken
			end
		end
		if IsInGroup() then
			local prefix = IsInRaid() and 'raid' or 'party'
			for i=1, GetNumGroupMembers() do
				local unit = prefix .. i .. 'target'
				if self:UnitID(unit) == id then
					return unit
				end
			end
		end
	end
end
do
	local valid_types = {
		Creature = true, -- npcs
		Vehicle = true, -- vehicles
		Vignette = true, -- vignettes ()
	}
	-- See: https://warcraft.wiki.gg/wiki/GUID#Creature
	function addon:GUIDShard(guid)
		if not guid then return end
		-- local unitType, _, serverID, instanceID, zoneUID, mobID, spawnUID = strsplit("-", guid)
		local guidType, _, serverID, instanceID, zoneUID, id, spawnUID = strsplit("-", guid)
		if not (guidType and valid_types[guidType]) then return end
		return tonumber(zoneUID), tonumber(id)
	end
	function addon:UnitShard(unit)
		return self:GUIDShard(UnitGUID(unit))
	end
end

addon.round = function(num, precision)
	return math.floor(num * math.pow(10, precision) + 0.5) / math.pow(10, precision)
end

function addon:FormatLastSeen(t)
	t = tonumber(t)
	if not t or t == 0 then return NEVER end
	local currentTime = time()
	local minutes = math.floor(((currentTime - t) / 60) + 0.5)
	if minutes > 119 then
		local hours = math.floor(((currentTime - t) / 3600) + 0.5)
		if hours > 23 then
			return math.floor(((currentTime - t) / 86400) + 0.5).." day(s)"
		else
			return hours.." hour(s)"
		end
	else
		return minutes.." minute(s)"
	end
end

addon.zone_names = setmetatable({}, {__index = function(self, mapid)
	if not mapid then
		return
	end
	local mapdata = C_Map.GetMapInfo(mapid)
	if mapdata then
		self[mapid] = mapdata.name
		return mapdata.name
	end
end,})

-- Names

do
	local mobNameToId = {}
	local TextFromHyperlink
	if _G.C_TooltipInfo then
		function TextFromHyperlink(link)
			local info = C_TooltipInfo.GetHyperlink(link)
			if info and info.lines and info.lines[1] and info.lines[1].type == Enum.TooltipDataLineType.UnitName then
				return info.lines[1].leftText
			end
		end
	else
		local cache_tooltip = CreateFrame("GameTooltip", "SDCacheTooltip", _G.UIParent, "GameTooltipTemplate")
		cache_tooltip:SetOwner(_G.WorldFrame, "ANCHOR_NONE")
		function TextFromHyperlink(link)
			cache_tooltip:ClearLines()
			cache_tooltip:SetHyperlink(link)
			local text = SDCacheTooltipTextLeft1:GetText()
			if text and text ~= "" then
				return text
			end
		end
	end
	local function mob_name(id, unit, cache)
		if unit then
			-- refresh the locale when we actually meet the mob, because blizzard fixes typos occasionally
			local name = UnitName(unit)
			if name and name ~= UNKNOWNOBJECT then
				cache[id] = name
			end
		end
		if not cache[id] then
			local name = TextFromHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
			if name and name ~= UNKNOWNOBJECT then
				cache[id] = name
			end
		end
		if cache[id] then
			mobNameToId[cache[id]] = id
		end
		return cache[id] or (ns.mobdb[id] and ns.mobdb[id].name)
	end

	local name_cache = {}
	function addon:NameForMob(id, unit)
		return mob_name(id, unit, name_cache)
	end
	function addon:IdForMob(name, zone)
		if zone then
			if ns.mobsByZone[zone] then
				if not ns.mobNamesByZone[zone] then
					ns.mobNamesByZone[zone] = {}
					for id in pairs(ns.mobsByZone[zone]) do
						local zname = addon:NameForMob(id)
						if zname then
							ns.mobNamesByZone[zone][zname] = id
						end
					end
				end
				if ns.mobNamesByZone[zone][name] then
					-- print("from zone", zone, name)
					return ns.mobNamesByZone[zone][name]
				end
			end
			local info = C_Map.GetMapInfo(zone)
			if info and info.parentMapID then
				-- could also restrict this by info.mapType to stop when we hit a Enum.UIMapType.Zone?
				return self:IdForMob(name, info.parentMapID)
			end
		end
		-- print("from fallback", zone, name)
		return mobNameToId[name]
	end
end

-- Location

function addon:GetCoord(x, y)
	return floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
end

function addon:GetXY(coord)
	return floor(coord / 10000) / 10000, (coord % 10000) / 10000
end

function addon:GetClosestLocationForMob(id)
	if not (ns.mobdb[id] and ns.mobdb[id].locations) then return end
	local x, y, zone = HBD:GetPlayerZonePosition()
	if not (x and y and zone) then return end
	local closest = {distance = 999999999}
	for zone2, coords in pairs(ns.mobdb[id].locations) do
		for i, coord in ipairs(coords) do
			local x2, y2 = self:GetXY(coord)
			local distance = HBD:GetZoneDistance(zone, x, y, zone2, x2, y2)
			if not distance then
				if not closest.zone then
					-- make sure we get one
					closest.zone = zone2
					closest.x = x2
					closest.y = y2
				end
				distance = 999999999
			end
			if distance < closest.distance then
				closest.distance = distance
				closest.zone = zone2
				closest.x = x2
				closest.y = y2
			end
		end
	end
	return closest.zone, closest.x, closest.y, closest.distance
end

-- Tooltip stuff

ns.Tooltip = {
	Get = function(name)
		name = "SilverDragon" .. name .. "Tooltip"
		if _G[name] then
			return _G[name]
		end
		local tooltip = CreateFrame("GameTooltip", name, UIParent, "GameTooltipTemplate")
		if _G.C_TooltipInfo then
			-- Cata-classic has TooltipDataProcessor, but doesn't actually use the new tooltips
			tooltip.shoppingTooltips = {
				CreateFrame("GameTooltip", name.."Shopping1", tooltip, "ShoppingTooltipTemplate"),
				CreateFrame("GameTooltip", name.."Shopping2", tooltip, "ShoppingTooltipTemplate"),
			}
		else
			tooltip.shoppingTooltips = {
				CreateFrame("GameTooltip", name.."Shopping1", tooltip, "GameTooltipTemplate"),
				CreateFrame("GameTooltip", name.."Shopping2", tooltip, "GameTooltipTemplate"),
			}
			tooltip.shoppingTooltips[1]:SetScale(0.8)
			tooltip.shoppingTooltips[2]:SetScale(0.8)

			tooltip:SetScript("OnTooltipSetUnit", GameTooltip_OnTooltipSetUnit)
			tooltip:SetScript("OnTooltipSetItem", GameTooltip_OnTooltipSetItem)
			tooltip:SetScript("OnTooltipSetSpell", GameTooltip_OnTooltipSetSpell)
			tooltip.shoppingTooltips[1]:SetScript("OnTooltipSetItem", GameTooltip_OnTooltipSetShoppingItem)
			tooltip.shoppingTooltips[2]:SetScript("OnTooltipSetItem", GameTooltip_OnTooltipSetShoppingItem)
		end
		tooltip:SetScript("OnUpdate", GameTooltip_OnUpdate)
		return tooltip
	end,
}

-- Compatibility helpers

function ns.IsCosmeticItem(itemInfo)
	if _G.C_Item and C_Item.IsCosmeticItem then
		return C_Item.IsCosmeticItem(itemInfo)
	elseif _G.IsCosmeticItem then
		return IsCosmeticItem(itemInfo)
	end
	return false
end
