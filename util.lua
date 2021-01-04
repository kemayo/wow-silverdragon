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
local completeColor = CreateColor(0, 1, 0, 1)
local incompleteColor = CreateColor(1, 0, 0, 1)
function addon:RenderString(s)
	if type(s) == "function" then s = s() end
	return s:gsub("{(%l+):(%d+):?([^}]*)}", function(variant, id, fallback)
		id = tonumber(id)
		if variant == "item" then
			local name, link, _, _, _, _, _, _, _, icon = GetItemInfo(id)
			if link and icon then
				return quick_texture_markup(icon) .. link
			end
		elseif variant == "spell" then
			local name, _, icon = GetSpellInfo(id)
			if name and icon then
				return quick_texture_markup(icon) .. name
			end
		elseif variant == "quest" then
			local name = C_QuestLog.GetTitleForQuestID(id)
			if not (name and name ~= "") then
				name = tostring(id)
			end
			local completed = C_QuestLog.IsQuestFlaggedCompleted(id)
			return CreateAtlasMarkup("questnormal") .. (completed and completeColor or incompleteColor):WrapTextInColorCode(name)
		elseif variant == "questid" then
			return CreateAtlasMarkup("questnormal") .. (C_QuestLog.IsQuestFlaggedCompleted(id) and completeColor or incompleteColor):WrapTextInColorCode(id)
		elseif variant == "npc" then
			local name = self:NameForMob(id)
			if name then
				return name
			end
		elseif variant == "currency" then
			local info = C_CurrencyInfo.GetCurrencyInfo(id)
			if info then
				return quick_texture_markup(info.iconFileID) .. info.name
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
		elseif variant == "quest" then
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
		if type(...) == "table" then return self:RenderStringList(variant, unpack(...)) end
		wipe(out)
		for i=1,select("#", ...) do
			table.insert(out, ("{%s:%d}"):format(variant, (select(i, ...))))
		end
		return self:RenderString(string.join(", ", unpack(out)))
	end
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

	local cache_tooltip = CreateFrame("GameTooltip", "SDCacheTooltip", _G.UIParent, "GameTooltipTemplate")
	cache_tooltip:SetOwner(_G.WorldFrame, "ANCHOR_NONE")
	local function TextFromHyperlink(link)
		cache_tooltip:ClearLines()
		cache_tooltip:SetHyperlink(link)
		local text = SDCacheTooltipTextLeft1:GetText()
		if text and text ~= "" and text ~= UNKNOWN then
			return text
		end
	end
	function addon:NameForMob(id, unit)
		if not self.db.locale.mob_name[id] then
			local name = unit and UnitName(unit) or TextFromHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
			if name and name ~= UNKNOWNOBJECT then
				self.db.locale.mob_name[id] = name
				mobNameToId[self.db.locale.mob_name[id]] = id
			end
		end
		return self.db.locale.mob_name[id] or (ns.mobdb[id] and ns.mobdb[id].name)
	end
	function addon:IdForMob(name, zone)
		if zone and ns.mobNamesByZone[zone] and ns.mobNamesByZone[zone][name] then
			return ns.mobNamesByZone[zone][name]
		end
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
		tooltip:SetScript("OnTooltipSetUnit", GameTooltip_OnTooltipSetUnit)
		tooltip:SetScript("OnTooltipSetItem", GameTooltip_OnTooltipSetItem)
		tooltip:SetScript("OnTooltipSetSpell", GameTooltip_OnTooltipSetSpell)
		tooltip:SetScript("OnUpdate", GameTooltip_OnUpdate)
		tooltip.shoppingTooltips = {
			CreateFrame("GameTooltip", name.."Shopping1", tooltip, "GameTooltipTemplate"),
			CreateFrame("GameTooltip", name.."Shopping2", tooltip, "GameTooltipTemplate"),
		}
		tooltip.shoppingTooltips[1]:SetScript("OnTooltipSetItem", GameTooltip_OnTooltipSetShoppingItem)
		tooltip.shoppingTooltips[1]:SetScale(0.8)
		tooltip.shoppingTooltips[2]:SetScript("OnTooltipSetItem", GameTooltip_OnTooltipSetShoppingItem)
		tooltip.shoppingTooltips[2]:SetScale(0.8)
		return tooltip
	end,
}
