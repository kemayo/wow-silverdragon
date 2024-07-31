local myname, ns = ...

local HBD = LibStub("HereBeDragons-2.0")

local addon = LibStub("AceAddon-3.0"):NewAddon("SilverDragon", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")
SilverDragon = addon
SilverDragon.NAMESPACE = ns -- for separate addons
addon.events = LibStub("CallbackHandler-1.0"):New(addon)

ns.CLASSIC = WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE -- rolls forward
ns.CLASSICERA = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC -- forever vanilla

local GetPlayerAuraBySpellID = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID or _G.GetPlayerAuraBySpellID

local faction = UnitFactionGroup("player")

local Debug
do
	local TextDump = LibStub("LibTextDump-1.0")
	local debuggable = C_AddOns.GetAddOnMetadata(myname, "Version") == '@'..'project-version@'
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

BINDING_HEADER_SILVERDRAGON = "SilverDragon"
_G["BINDING_NAME_CLICK SilverDragonPopupButton:LeftButton"] = "Target last found mob"
_G["BINDING_NAME_CLICK SilverDragonMacroButton:LeftButton"] = "Scan for nearby mobs"

addon.escapes = {
	-- |TTexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2|t
	-- |A:atlas:height:width[:offsetX:offsetY]|a
	leftClick = CreateAtlasMarkup("newplayertutorial-icon-mouse-leftbutton", 12, 15),
	rightClick = CreateAtlasMarkup("newplayertutorial-icon-mouse-rightbutton", 12, 15),
	keyDown = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:0:0:0:-1:512:512:9:66:437:490|t]],
	green = _G.GREEN_FONT_COLOR_CODE,
	red = _G.RED_FONT_COLOR_CODE,
}
if ns.CLASSIC then
	addon.escapes.leftClick = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:19:11:-1:0:512:512:9:67:227:306|t]]
	addon.escapes.rightClick = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:20:12:0:-1:512:512:9:66:332:411|t]]
end


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
addon.treasuresources = {}
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
local worldQuestMobLookup = {
	-- [questid] = { [mobid] = true, ... }
}
ns.worldQuestMobLookup = worldQuestMobLookup
local vignetteMobLookup = {
	-- [name] = { [mobid] = true, ... }
}
ns.vignetteMobLookup = vignetteMobLookup
ns.vignetteTreasureLookup = {
	-- [vignetteid] = { data },
}
function addon:RegisterMobData(source, data, updated)
	if not updated then
		if not self.HASWARNEDABOUTOLDDATA then
			self.HASWARNEDABOUTOLDDATA = true
			return self:Print(("You have an old SilverDragon_%s folder, which can be removed"):format(source))
		end
		return
	end
	if not addon.datasources[source] then addon.datasources[source] = {} end
	MergeTable(addon.datasources[source], data)
	-- pick up achievements if needed
	for mobid, mobdata in pairs(data) do
		if mobdata.achievement and mobdata.criteria then
			if not ns.achievements[mobdata.achievement] then
				ns.achievements[mobdata.achievement] = {}
			end
			ns.achievements[mobdata.achievement][mobid] = mobdata.criteria
			ns.mobs_to_achievement[mobid] = mobdata.achievement
		end
	end
end
function addon:RegisterTreasureData(source, data, updated)
	if not updated then return end
	if not addon.treasuresources[source] then addon.treasuresources[source] = {} end
	MergeTable(addon.treasuresources[source], data)
end
do
	function addon:RegisterHandyNotesData(source, uiMapID, points, defaults)
		-- convenience for me, really...
		addon.datasources[source] = addon.datasources[source] or {}
		addon.treasuresources[source] = addon.treasuresources[source] or {}
		for coord, point in pairs(points) do
			if point.npc or point.vignette then
				if defaults then
					for k,v in pairs(defaults) do
						if k == "note" and point[k] then
							point[k] = v .. "\n" .. point[k]
						end
						point[k] = point[k] or v
					end
				end
				local data = {
					name=point.label,
					locations={[uiMapID]={coord}},
					loot=point.loot,
					notes=point.note,
					active=point.active,
					requires=point.require or point.hide_before,
					vignette=point.vignette,
					quest=point.quest,
					hidden=point.hidden,
					worldquest=point.worldquest,
				}
				if point.additional then
					for _,acoord in pairs(point.additional) do
						table.insert(data.locations[uiMapID], acoord)
					end
				end
				if point.route and type(point.route) == "table" then
					data.routes = {[uiMapID] = {point.route}}
				end
				if point.routes then
					data.routes = {[uiMapID] = point.routes}
				end
				if point.npc then
					if not addon.datasources[source][point.npc] then
						addon.datasources[source][point.npc] = data
					else
						addon.datasources[source][point.npc].locations[uiMapID] = data.locations[uiMapID]
					end
					if point.achievement and point.criteria then
						if not ns.achievements[point.achievement] then
							ns.achievements[point.achievement] = {}
						end
						ns.achievements[point.achievement][point.npc] = point.criteria
						ns.mobs_to_achievement[point.npc] = point.achievement
					end
				else
					addon.treasuresources[source][point.vignette] = data
				end
			end
		end
	end
end
do
	local function addQuestMobLookup(lookup, mobid, quest)
		if type(quest) == "table" then
			if quest.alliance then
				return addQuestMobLookup(lookup, mobid, faction == "Alliance" and quest.alliance or quest.horde)
			end
			for _, questid in ipairs(quest) do
				if not lookup[questid] then
					lookup[questid] = {}
				end
				lookup[questid][mobid] = true
			end
		else
			if not lookup[quest] then
				lookup[quest] = {}
			end
			lookup[quest][mobid] = true
		end
	end
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
		if mobdata.quest then
			addQuestMobLookup(questMobLookup, mobid, mobdata.quest)
		end
		if mobdata.worldquest then
			addQuestMobLookup(worldQuestMobLookup, mobid, mobdata.worldquest)
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
					mobdata.id = mobid
					mobdata.source = source

					addMobToLookups(mobid, mobdata)
				end
			end
		end
		for source, data in pairs(addon.treasuresources) do
			if addon.db.global.datasources[source] then
				for vignetteid, vignettedata in pairs(data) do
					ns.vignetteTreasureLookup[vignetteid] = vignettedata
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
				['*'] = false,
				[64403] = true, -- Alani
			},
			ignore_datasource = {
				-- "BurningCrusade" = true,
			},
		},
		profile = {
			scan = 1, -- scan interval, 0 for never
			delay = 1200, -- number of seconds to wait between recording the same mob
			instances = false,
			taxi = true,
			charloot = false,
			lootappearances = true,
		},
	}, true)
	globaldb = self.db.global

	if self.db.locale and self.db.locale.mob_name then
		self.db.locale.mob_name = nil
		self.db.locale.quest_name = nil
	end

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

-- returns name, vignette, tameable, last_seen, times_seen
function addon:GetMobInfo(id)
	if mobdb[id] then
		local m = mobdb[id]
		local name = self:NameForMob(id)
		return name, m.vignette or name, m.tameable, globaldb.mob_seen[id], globaldb.mob_count[id]
	end
end
function addon:MobHasVignette(id)
	return mobdb[id] and mobdb[id].vignette
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
		if mobdb[id].art then
			phased = mobdb[id].art == C_Map.GetMapArtID(zone)
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
	function addon:NotifyForMob(id, zone, x, y, is_dead, source, unit, silent, force, GUID)
		self.events:Fire("Seen_Raw", id, zone, x, y, is_dead, source, unit)

		if silent then
			Debug("Skipping notification: silent call", id, source)
			return
		end
		if self:ShouldIgnoreMob(id, zone) then
			Debug("Skipping notification: ignored", id, source)
			return
		end
		if not force and not self:WouldNotifyForMob(id, zone) then
			Debug("Skipping notification: seen", id, lastseen[id..zone], time() - self.db.profile.delay, source)
			return
		end
		if not self:PlayerIsInteractive() then
			Debug("Skipping notification: taxi", id, source)
			return
		end
		globaldb.mob_count[id] = globaldb.mob_count[id] + 1
		globaldb.mob_seen[id] = time()
		lastseen[id..zone] = time()
		self.events:Fire("Seen", id, zone, x or 0, y or 0, is_dead, source, unit, GUID)
		return true
	end
	function addon:WouldNotifyForMob(id, zone)
		return not (lastseen[id..zone] and time() < (lastseen[id..zone] + self.db.profile.delay))
	end
end
do
	local zone_ignores = {
		[550] = {
			[32491] = true, -- Time-Lost
		},
	}
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
end

function addon:PlayerIsInteractive()
	if (not self.db.profile.taxi) and UnitOnTaxi('player') then
		return false
	end
	if IsInCinematicScene() or InCinematic() then
		-- TODO: should I repurpose the taxi preference to just apply to any
		-- not-interactive state?
		return false
	end
	if GetPlayerAuraBySpellID(369968) then
		-- Dragon race is occurring
		return false
	end
	return true
end

-- Scanning:

function addon:CheckNearby()
	if (not self.db.profile.instances) and IsInInstance() then return end
	local zone = HBD:GetPlayerZone()
	if not zone then return end

	self.events:Fire("Scan", zone)
end
