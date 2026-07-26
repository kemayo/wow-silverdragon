local myname, ns = ...

local addon = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local Debug = addon.Debug
local DebugF = addon.DebugF

local HBD = LibStub("HereBeDragons-2.0")

local issecretvalue = _G.issecretvalue or function() return false end

-- Strings

local mob_name

local completeColor = CreateColor(0, 1, 0, 1)
local incompleteColor = CreateColor(1, 0, 0, 1)
-- The implementation lives in systems/formatting.lua so it stays in sync with
-- the HandyNotes handler; these are just the addon: entry points.
function addon:RenderString(...)
	return ns.render_string(...)
end
function addon:CacheString(...)
	return ns.cache_string(...)
end
function addon:RenderStringList(variant, ...)
	-- the shared version takes a render context first; we have none to give
	return ns.render_string_list(nil, variant, ...)
end

function addon:ColorTextByCompleteness(complete, text)
	return (complete and completeColor or incompleteColor):WrapTextInColorCode(text)
end

-- Tables

function ns.safe_unpack(val)
	-- When a value could be a table or a single value
	if ns.xtype(val) == "table" then
		return unpack(val)
	end
	return val
end

-- GUID / unit

do
	local valid_unit_types = {
		Creature = true, -- npcs
		Vehicle = true, -- vehicles
	}
	local function npcIdFromGuid(guid)
		if not guid then return end
		if issecretvalue(guid) then return end
		if C_CreatureInfo and C_CreatureInfo.GetCreatureID then
			return C_CreatureInfo.GetCreatureID(guid)
		end
		local unit_type, id = guid:match("(%a+)-%d+-%d+-%d+-%d+-(%d+)-.+")
		if not (id and unit_type and valid_unit_types[unit_type]) then
			return
		end
		return tonumber(id)
	end
	ns.IdFromGuid = npcIdFromGuid
	function addon:UnitID(unit)
		if not unit then return end
		-- In some situations some units will cause a "bad argument #1
		-- to 'UnitGUID' (Compound unit tokens (example: boss1targetpet) are
		-- not allowed for this call", and detecting those situations is
		-- opaque. As such, pcall this.
		local _, guid = pcall(UnitGUID, unit)
		if not guid then return end
		return npcIdFromGuid(guid)
	end
	function addon:FindUnitWithID(id)
		if self:UnitID('target') == id then
			return 'target'
		end
		if self:UnitID('mouseover') == id then
			return 'mouseover'
		end
		for _, nameplate in ipairs(C_NamePlate.GetNamePlates()) do
			if self:UnitID(nameplate.unitToken or nameplate.namePlateUnitToken) == id then
				return nameplate.unitToken or nameplate.namePlateUnitToken
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
		if issecretvalue(guid) then return end
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
	local mobIdToName = {}
	local mobNameToId = {}
	function mob_name(id, unit, cache)
		cache = cache or mobIdToName
		if unit then
			-- refresh the locale when we actually meet the mob, because blizzard fixes typos occasionally
			local name = UnitName(unit)
			if not issecretvalue(name) and name and name ~= UNKNOWNOBJECT then
				cache[id] = name
			end
		end
		if not cache[id] then
			cache[id] = ns.name_from_creature_id(id)
		end
		if cache[id] then
			mobNameToId[cache[id]] = id
		end
		return cache[id] or (ns.mobdb[id] and ns.mobdb[id].name)
	end
	-- the shared render code goes through this, so it picks up the mobdb fallback
	ns.mob_name = mob_name

	function addon:NameForMob(id, unit)
		return mob_name(id, unit)
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

function ns.isanyvaluesecret(...)
    for i=1, select("#", ...) do
        if issecretvalue((select(i, ...))) then
            return true
        end
    end
    return false
end
