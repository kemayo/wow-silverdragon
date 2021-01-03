local myname, ns = ...

local HBD = LibStub("HereBeDragons-2.0")

local addon = LibStub("AceAddon-3.0"):NewAddon("SilverDragon", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")
SilverDragon = addon
SilverDragon.NAMESPACE = ns -- for separate addons
addon.events = LibStub("CallbackHandler-1.0"):New(addon)

local Debug
do
	local TextDump = LibStub("LibTextDump-1.0")
	local debuggable = GetAddOnMetadata(myname, "Version") == '@project-version@'
	local _window
	local function GetDebugWindow()
		if not _window then
			_window = TextDump:New(myname)
		end
		return _window
	end
	addon.GetDebugWindow = GetDebugWindow
	addon.Debug = function(...)
		if not debuggable then return end
		-- if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end
		GetDebugWindow():AddLine(string.join(', ', tostringall(...)))
	end
	addon.DebugF = function(...)
		if not debuggable then return end
		Debug(string.format(...))
	end
	function addon:ShowDebugWindow()
		local window = self.GetDebugWindow()
		if window:Lines() == 0 then
			window:AddLine("Nothing has happened yet")
			window:Display()
			window:Clear()
			return
		end
		window:Display()
	end
	addon.debuggable = debuggable
	Debug = addon.Debug
end

local mfloor, mpow, mabs = math.floor, math.pow, math.abs
local tinsert, tremove = table.insert, table.remove
local ipairs, pairs = ipairs, pairs
local IsInInstance, GetCurrentMapAreaID, SetMapByID, SetMapToCurrentZone = IsInInstance, GetCurrentMapAreaID, SetMapByID, SetMapToCurrentZone
local wowVersion, buildRevision, _, buildTOC = GetBuildInfo()

BINDING_HEADER_SILVERDRAGON = "SilverDragon"
_G["BINDING_NAME_CLICK SilverDragonPopupButton:LeftButton"] = "Target last found mob"
_G["BINDING_NAME_CLICK SilverDragonMacroButton:LeftButton"] = "Scan for nearby mobs"

addon.escapes = {
	-- |TTexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2|t
	-- |A:atlas:height:width[:offsetX:offsetY]|a
	-- leftClick = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:19:11:-1:0:512:512:9:67:227:306|t]],
	-- rightClick = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:20:12:0:-1:512:512:9:66:332:411|t]],
	leftClick = CreateAtlasMarkup("newplayertutorial-icon-mouse-leftbutton", 12, 15),
	rightClick = CreateAtlasMarkup("newplayertutorial-icon-mouse-rightbutton", 12, 15),
	keyDown = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:0:0:0:-1:512:512:9:66:437:490|t]],
	green = _G.GREEN_FONT_COLOR_CODE,
	red = _G.RED_FONT_COLOR_CODE,
}


addon.datasources = {
	--[[
	["source name"] = {
		[54321] = {
			name = "Bob",
			vignette = "something that isn't the name",
			quest = 12345,
			tameable = isTameable,
			notes = "notes",
			mount = hasMount,
			boss = isBoss,
			locations = {[zoneid] = {coord,...}},
			-- TODO, phase should really be per-zone in locations, but that's more of a data-model change than I want to make right now.
			phase = artID,
			hidden = isHidden,
		},
		...
	}
	--]]
}
local mobdb = setmetatable({}, {
	__index = function(t, id)
		for source, data in pairs(addon.datasources) do
			if data[id] and addon.db.global.datasources[source] then
				t[id] = data[id]
				return data[id]
			end
		end
		t[id] = false
		return false
	end,
})
ns.mobdb = mobdb
local mobsByZone = {
	-- [zoneid] = { [mobid] = {coord, ...}
}
ns.mobsByZone = mobsByZone
local mobNamesByZone = {
	-- [zoneid] = { [mobname] = mobid, ... }
}
ns.mobNamesByZone = mobNamesByZone
local questMobLookup = {
	-- [questid] = { [mobid] = true, ... }
}
ns.questMobLookup = questMobLookup
local vignetteMobLookup = {
	-- [name] = { [mobid] = true, ... }
}
ns.vignetteMobLookup = vignetteMobLookup
function addon:RegisterMobData(source, data)
	addon.datasources[source] = data
end
do
	local function addMobToLookups(mobid, mobdata)
		if mobdata.hidden then
			return
		end
		if mobdata.locations then
			for zoneid, coords in pairs(mobdata.locations) do
				if not mobsByZone[zoneid] then
					mobsByZone[zoneid] = {}
				end
				mobsByZone[zoneid][mobid] = coords
			end
		end
		-- In the olden days, we had one mob per quest and/or vignette. Alas...
		local quest = addon:QuestForMob(mobid)
		if quest then
			local questMobs = questMobLookup[quest]
			if not questMobs then
				questMobs = {}
				questMobLookup[mobdata.quest] = questMobs
			end
			questMobs[mobid] = true
		end
		if mobdata.vignette then
			local vignetteMobs = vignetteMobLookup[mobdata.vignette]
			if not vignetteMobs then
				vignetteMobs = {}
				vignetteMobLookup[mobdata.vignette] = vignetteMobs
			end
			vignetteMobs[mobid] = true
		end
	end
	function addon:BuildLookupTables()
		wipe(mobdb)
		wipe(mobsByZone)
		wipe(questMobLookup)
		wipe(vignetteMobLookup)
		for source, data in pairs(addon.datasources) do
			if addon.db.global.datasources[source] then
				for mobid, mobdata in pairs(data) do
					self:NameForMob(mobid) -- prime cache

					mobdata.id = mobid
					mobdata.source = source

					addMobToLookups(mobid, mobdata)
				end
			end
		end

		self.events:Fire("Ready")
	end
end

local globaldb
function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("SilverDragon3DB", {
		global = {
			mob_seen = {
				-- 132132 = time()
			},
			mob_count = {
				['*'] = 0,
			},
			datasources = {
				['*'] = true,
			},
			always = {
			},
			ignore = {
				[64403] = true, -- Alani
			},
			ignore_datasource = {
				-- "BurningCrusade" = true,
			},
		},
		locale = {
			quest_name = {
				-- store localized quest names
				-- [id] = "name"
			},
			mob_name = {
				-- store localized mob names
				-- [id] = "name"
			},
		},
		profile = {
			scan = 1, -- scan interval, 0 for never
			delay = 1200, -- number of seconds to wait between recording the same mob
			instances = false,
			taxi = true,
		},
	}, true)
	globaldb = self.db.global

	if SilverDragon2DB and SilverDragon2DB.global then
		-- Migrating some data from v2

		for mobid, when in pairs(SilverDragon2DB.global.mob_seen or {}) do
			if when > 0 then
				globaldb.mob_seen[mobid] = when
			end
		end
		for mobid, count in pairs(SilverDragon2DB.global.mob_count or {}) do
			globaldb.mob_count[mobid] = count
		end
		for mobid, watching in pairs(SilverDragon2DB.global.always or {}) do
			globaldb.always[mobid] = watching
		end
		for mobid, ignored in pairs(SilverDragon2DB.global.ignore or {}) do
			globaldb.ignore[mobid] = ignored
		end

		_G["SilverDragon2DB"] = nil
	end
end

function addon:OnEnable()
	self:BuildLookupTables()
	if self.db.profile.scan > 0 then
		self:ScheduleRepeatingTimer("CheckNearby", self.db.profile.scan)
	end
end

-- returns true if the change had an effect
function addon:SetIgnore(id, ignore, quiet)
	if not id then return false end
	if (ignore and globaldb.ignore[id]) or (not ignore and not globaldb.ignore[id]) then
		-- to avoid the nil/false issue
		return false
	end
	globaldb.ignore[id] = ignore
	if not quiet then
		self.events:Fire("IgnoreChanged", id, globaldb.ignore[id])
	end
	return true
end

-- returns true if the change had an effect
function addon:SetCustom(id, watch, quiet)
	if not id then return false end
	if (watch and globaldb.always[id]) or (not watch and not globaldb.always[id]) then
		-- to avoid the nil/false issue
		return false
	end
	globaldb.always[id] = watch or nil
	if not quiet then
		self.events:Fire("CustomChanged", id, globaldb.always[id])
	end
	return true
end

do
	local mobNameToId = {}
	local questNameToId = {}

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
			local name = TextFromHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
			if unit and not name then
				name = UnitName(unit)
			end
			if name and name ~= UNKNOWNOBJECT then
				self.db.locale.mob_name[id] = name
			end
		end
		if self.db.locale.mob_name[id] then
			mobNameToId[self.db.locale.mob_name[id]] = id
		end
		return self.db.locale.mob_name[id] or (mobdb[id] and mobdb[id].name)
	end
	function addon:IdForMob(name, zone)
		if zone and mobNamesByZone[zone] and mobNamesByZone[zone][name] then
			return mobNamesByZone[zone][name]
		end
		return mobNameToId[name]
	end
	function addon:NameForQuest(id)
		if not self.db.locale.quest_name[id] then
			-- TODO: after 9.0.1 this check can be removed
			local name = C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(id) or C_QuestLog.GetQuestInfo(id)
			if name then
				name = name:gsub("Vignette: ", "")
				self.db.locale.quest_name[id] = name
			end
		end
		if self.db.locale.quest_name[id] then
			questNameToId[self.db.locale.quest_name[id]] = id
		end
		return self.db.locale.quest_name[id]
	end
	function addon:IdForQuest(name)
		return questNameToId[name]
	end
end

-- returns name, questid, vignette, tameable, last_seen, times_seen
function addon:GetMobInfo(id)
	if mobdb[id] then
		local m = mobdb[id]
		local name = self:NameForMob(id)
		return name, self:QuestForMob(id), m.vignette or name, m.tameable, globaldb.mob_seen[id], globaldb.mob_count[id]
	end
end
function addon:IsMobInZone(id, zone)
	if mobsByZone[zone] then
		return mobsByZone[zone][id]
	end
end
do
	local poi_expirations = {}
	local poi_zone_expirations = {}
	local pois_byzone = {}
	local function refreshPois(zone)
		local now = time()
		if not poi_zone_expirations[zone] or now > poi_zone_expirations[zone] then
			Debug("Refreshing zone POIs", zone)
			pois_byzone[zone] = wipe(pois_byzone[zone] or {})
			for _, poi in ipairs(C_AreaPoiInfo.GetAreaPOIForMap(zone)) do
				pois_byzone[zone][poi] = true
				poi_expirations[poi] = now + (C_AreaPoiInfo.GetAreaPOISecondsLeft(poi) or 60)
			end
			poi_zone_expirations[zone] = now + 1
		end
	end
	local function checkPois(...)
		for i=1, select("#", ...), 2 do
			local zone, poi = select(i, ...)
			local now = time()
			if now > (poi_expirations[poi] or 0) then
				refreshPois(zone)
				poi_expirations[poi] = poi_expirations[poi] or (now + 60)
			end
			if pois_byzone[zone][poi] then
				return true
			end
		end
	end
	function addon:IsMobInPhase(id, zone)
		local phased, poi = true, true
		if not mobdb[id] then return end
		if mobdb[id].phase then
			phased = mobdb[id].phase == C_Map.GetMapArtID(zone)
		end
		if mobdb[id].poi then
			poi = checkPois(unpack(mobdb[id].poi))
		end
		return phased and poi
	end
end
-- Returns id, addon:GetMobInfo(id)
function addon:GetMobByCoord(zone, coord, include_ignored)
	if not mobsByZone[zone] then return end
	for id, locations in pairs(mobsByZone[zone]) do
		if self:IsMobInPhase(id, zone) and include_ignored or not self:ShouldIgnoreMob(id) then
			for _, mob_coord in ipairs(locations) do
				if coord == mob_coord then
					return id, self:GetMobInfo(id)
				end
			end
		end
	end
end

function addon:GetMobLabel(id)
	local name = self:NameForMob(id)
	if not name then
		return UNKNOWN
	end
	if not (mobdb[id] and mobdb[id].variant) then
		return name
	end
	return name .. (" (" .. mobdb[id].variant .. ")")
end

do
	local lastseen = {}
	function addon:NotifyForMob(id, zone, x, y, is_dead, source, unit, silent, force)
		self.events:Fire("Seen_Raw", id, zone, x, y, is_dead, source, unit)

		if silent then
			Debug("Skipping notification: silent call", id, source)
			return
		end
		if self:ShouldIgnoreMob(id, zone) then
			Debug("Skipping notification: ignored", id, source)
			return
		end
		if not force and lastseen[id..zone] and time() < lastseen[id..zone] + self.db.profile.delay then
			Debug("Skipping notification: seen", id, lastseen[id..zone], time() - self.db.profile.delay, source)
			return
		end
		if (not self.db.profile.taxi) and UnitOnTaxi('player') then
			Debug("Skipping notification: taxi", id, source)
			return
		end
		globaldb.mob_count[id] = globaldb.mob_count[id] + 1
		globaldb.mob_seen[id] = time()
		lastseen[id..zone] = time()
		self.events:Fire("Seen", id, zone, x or 0, y or 0, is_dead, source, unit)
		return true
	end
end
do
	local zone_ignores = {
		[550] = {
			[32491] = true, -- Time-Lost
		},
	}
	local faction = UnitFactionGroup("player")
	function addon:ShouldIgnoreMob(id, zone)
		if globaldb.ignore[id] then
			return true
		end
		if globaldb.always[id] then
			-- If you've manually added a mob we should take that a signal that you always want it announced
			-- (Unless you've also, weirdly, manually told it to be ignored as well.)
			return false
		end
		if zone and zone_ignores[zone] and zone_ignores[zone][id] then
			return true
		end
		if mobdb[id] then
			if mobdb[id].hidden then
				return true
			end
			if mobdb[id].faction == faction then
				--This checks unit faction and ignores mobs your faction cannot do anything with.
				--TODO: add an option for this?
				return true
			end
			if mobdb[id].source and globaldb.ignore_datasource[mobdb[id].source] then
				return true
			end
		end
	end
	function addon:QuestForMob(id)
		if mobdb[id] and mobdb[id].quest then
			if type(mobdb[id].quest) == "table" then
				-- some mobs have faction-based questids; they get stored as {alliance, horde}
				return mobdb[id].quest[faction == "Alliance" and 1 or 2]
			end
			return mobdb[id].quest
		end
	end
end

-- Scanning:

function addon:CheckNearby()
	if (not self.db.profile.instances) and IsInInstance() then return end
	local zone = HBD:GetPlayerZone()
	if not zone then return end

	self.events:Fire("Scan", zone)
end

-- Utility:

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
	return mfloor(num * mpow(10, precision) + 0.5) / mpow(10, precision)
end

function addon:FormatLastSeen(t)
	t = tonumber(t)
	if not t or t == 0 then return NEVER end
	local currentTime = time()
	local minutes = mfloor(((currentTime - t) / 60) + 0.5)
	if minutes > 119 then
		local hours = mfloor(((currentTime - t) / 3600) + 0.5)
		if hours > 23 then
			return mfloor(((currentTime - t) / 86400) + 0.5).." day(s)"
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

-- utility tooltip stuff

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
