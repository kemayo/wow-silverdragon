local BCT = LibStub("LibBabble-CreatureType-3.0"):GetUnstrictLookupTable()
local BCTR = LibStub("LibBabble-CreatureType-3.0"):GetReverseLookupTable()

local addon = LibStub("AceAddon-3.0"):NewAddon("SilverDragon", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")
SilverDragon = addon
addon.events = LibStub("CallbackHandler-1.0"):New(addon)

local debugf = tekDebug and tekDebug:GetFrame("SilverDragon")
local function Debug(...) if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end end
addon.Debug = Debug

local mfloor, mpow, mabs = math.floor, math.pow, math.abs
local tinsert, tremove = table.insert, table.remove
local ipairs, pairs = ipairs, pairs
local IsInInstance, GetCurrentMapAreaID, SetMapByID, SetMapToCurrentZone = IsInInstance, GetCurrentMapAreaID, SetMapByID, SetMapToCurrentZone
local wowVersion, buildRevision, _, buildTOC = GetBuildInfo()

local globaldb
function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("SilverDragon2DB", {
		global = {
			mobs_byzoneid = {
				['*'] = { -- zones
					-- 132132 = {encoded_loc, encoded_loc2, etc}
				},
			},
			mob_seen = {
				-- 132132 = time()
			},
			mob_id = {
				-- "Bob the Rare" = 132132
			},
			mob_name = {
				-- 132132 = "Bob the Rare"
			},
			mob_type = {
				-- 132132 = "Critter"
			},
			mob_level = {
				-- 132132 = 73
			},
			mob_elite = {
				-- 132132 = true
			},
			mob_tameable = {
				-- 132132 = nil
			},
			mob_notes = {
				-- 132132 = "Jade"
			},
			mob_vignettes = {
				-- "Something Descriptive That Isn't The Mob Name" = id
			},
			mob_quests = {
				-- mobid = questid
			},
			mob_count = {
				['*'] = 0,
			},
			always = {
			},
			ignore = {
				[32435] = true, -- Vern
				[64403] = true, -- Alani
				[62346] = true, -- Galleon (spawns every 2 hourish)
--				[62346] = true, -- Oondasta (spawns every 2 hoursish now)
				--Throne of Thunder Weekly bosses
				[70243] = true,--Agony and Anima (Archritualist Kelada)
				[70238] = true,--Eyes of the Thunder King
				[70249] = true,--Eyes of the Thunder King
				[70440] = true,--Requiem for a Queen (Monara)
				[70430] = true,--Rocks Fall, People Die (Rocky Horror)
				[70429] = true,--Something Foul is Afoot (Flesh'rok the Diseased)
				[70276] = true,--Taming the Tempest (No'ku Stormsayer)
				[69843] = true,--Zao'cho the Wicked (Zao'cho)
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

	if globaldb.mobs_byzone then
		-- We are in a version of SilverDragon prior to 2.7
		-- That means that everything is still indexed by mapfile and mob name, instead of
		-- by mapid and mobid. So, let's fix that as much as we can...
		local current_mobs_byzone = globaldb.mobs_byzone
		local current_mob_locations = globaldb.mob_locations
		local current_mob_type = globaldb.mob_type
		local current_mob_level = globaldb.mob_level
		local current_mob_elite = globaldb.mob_elite
		local current_mob_tameable = globaldb.mob_tameable
		local current_mob_count = globaldb.mob_count

		globaldb.mob_locations = {}
		globaldb.mob_type = {}
		globaldb.mob_level = {}
		globaldb.mob_elite = {}
		globaldb.mob_tameable = {}
		globaldb.mob_count = {}
		globaldb.mobs_byzone = nil
		globaldb.mob_locations = nil

		for name, id in pairs(globaldb.mob_id) do
			globaldb.mob_type[id] = current_mob_type[name]
			globaldb.mob_level[id] = current_mob_level[name]
			globaldb.mob_elite[id] = current_mob_elite[name]
			globaldb.mob_tameable[id] = current_mob_tameable[name]
			globaldb.mob_count[id] = current_mob_count[name]
		end

		for zone, mobs in pairs(current_mobs_byzone) do
			for name, last in pairs(mobs) do
				local id = globaldb.mob_id[name]
				if id then
					globaldb.mob_name[id] = name
					globaldb.mob_seen[id] = last
					local zoneid = addon.zoneid_from_mapfile(zone)
					if zoneid then
						globaldb.mobs_byzoneid[zoneid][id] = current_mob_locations[name] or {}
					end
				end
			end
		end

		self:Print("Upgraded rare mob database; you may have to reload your UI before everything is 100% there.")
	end

	-- Total hack. I'm very disappointed in myself. Blood Seeker is flagged as tamemable, but really isn't.
	-- (It despawns in 10-ish seconds, and shows up high in the sky.)
	globaldb.mob_tameable[3868] = nil
end

function addon:OnEnable()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	if self.db.profile.scan > 0 then
		self:ScheduleRepeatingTimer("CheckNearby", self.db.profile.scan)
	end
end

local cache_tooltip = CreateFrame("GameTooltip", "SDCacheTooltip")
cache_tooltip:AddFontStrings(
	cache_tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
	cache_tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText")
)
function addon:RequestCacheForMob(id)
	-- this doesn't work with just clearlines and the setowner outside of this, and I'm not sure why
	cache_tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	cache_tooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
	if cache_tooltip:IsShown() then
		local name = SDCacheTooltipTextLeft1:GetText()
		globaldb.mob_id[name] = id
		globaldb.mob_name[id] = name
		return name
	end
end

local valid_unit_types = {
	Creature = true, -- npcs
	Vehicle = true, -- vehicles
}
local function npc_id_from_guid(guid)
	if not guid then return end
	local unit_type, id = guid:match("(%a+)-%d+-%d+-%d+-%d+-(%d+)-.+")
	if not (unit_type and valid_unit_types[unit_type]) then
 		return
 	end
	return tonumber(id)
end
function addon:UnitID(unit)
	return npc_id_from_guid(UnitGUID(unit))
end

function addon:ShouldSave(id)
	local last_saved = globaldb.mob_seen[id]
	if not last_saved then
		return true
	end
	if time() > (last_saved + self.db.profile.delay) then
		return true
	end
	return false
end

local elite_types = {
	elite = true,
	rareelite = true,
	worldboss = true,
}

function addon:SaveMob(id, name, zone, x, y, level, elite, creature_type)
	Debug("SaveMob", id, name, zone, x, y, level, elite, creature_type)
	if not id then return end
	-- saves a mob's information, returns true if this is the first time a mob has been seen at this location
	if not self:ShouldSave(id) then
		Debug("Shouldn't save")
		return
	end

	if type(elite) == 'string' then
		elite = elite_types[elite] or false
	end

	globaldb.mob_seen[id] = time()
	globaldb.mob_level[id] = level
	if elite ~= nil then
		globaldb.mob_elite[id] = elite
	end
	globaldb.mob_type[id] = BCTR[creature_type]
	globaldb.mob_name[id] = name
	globaldb.mob_id[name] = id
	
	if not (zone and x and y and x > 0 and y > 0) then
		return
	end
	if not globaldb.mobs_byzoneid[zone][id] then globaldb.mobs_byzoneid[zone][id] = {} end

	local newloc = true
	for _, coord in ipairs(globaldb.mobs_byzoneid[zone][id]) do
		local loc_x, loc_y = self:GetXY(coord)
		if (mabs(loc_x - x) < 0.03) and (mabs(loc_y - y) < 0.03) then
			-- We've seen it close to here before. (within 3% of the zone)
			newloc = false
			break
		end
	end
	if newloc then
		tinsert(globaldb.mobs_byzoneid[zone][id], self:GetCoord(x, y))
	end
	return newloc
end

-- Returns name, num_locs, level, is_elite, creature_type, last_seen, times_seen, is_tameable, questid
function addon:GetMob(zone, id)
	if not (zone and id and globaldb.mobs_byzoneid[zone][id]) then
		return 0, 0, false, UNKNOWN, nil, 0, nil, nil
	end
	return globaldb.mob_name[id], #globaldb.mobs_byzoneid[zone][id], globaldb.mob_level[id], globaldb.mob_elite[id], BCT[globaldb.mob_type[id]], globaldb.mob_seen[id], globaldb.mob_count[id], globaldb.mob_tameable[name], globaldb.mob_quests[id]
end

function addon:GetMobLabel(id)
	if not globaldb.mob_name[id] then
		return
	end
	return globaldb.mob_name[id] .. (globaldb.mob_notes[id] and (" (" .. globaldb.mob_notes[id] .. ")") or "")
end

do
	local lastseen = {}
	function addon:NotifyMob(id, name, zone, x, y, is_dead, is_new_location, source, unit, silent, force)
		self.events:Fire("Seen_Raw", id, name, zone, x, y, is_dead, is_new_location, source, unit)

		if silent then
			Debug("Skipping notification: silent call", id, name)
			return
		end
		if self:ShouldIgnoreMob(id, zone) then
			Debug("Skipping notification: ignored", id, name)
			return
		end
		if not force and lastseen[id..zone] and time() < lastseen[id..zone] + self.db.profile.delay then
			Debug("Skipping notification: seen", id, name, lastseen[id..zone], time() - self.db.profile.delay)
			return
		end
		if (not self.db.profile.taxi) and UnitOnTaxi('player') then
			Debug("Skipping notification: taxi", id, name)
			return
		end
		globaldb.mob_count[id] = globaldb.mob_count[id] + 1
		lastseen[id..zone] = time()
		self.events:Fire("Seen", id, name, zone, x, y, is_dead, is_new_location, source, unit)
	end
end
do
	local alliance_ignore_mobs = { --Mobs alliance cannot kill
		[51071] = true,--Captain Florence (Vashjir)
		[68318] = true,--Dalan Nightbreaker (Krasarang)
		[68319] = true,--Disha Fearwarden (Krasarang)
		[68317] = true,--Mavis Harms (Krasarang)
		-- draenor quartermasters...
		[82876] = true,--Grand Marshal Tremblade (Ashran)
		[82878] = true,--Marshal Gabriel (Ashran)
		[82880] = true,--Marshal Karsh Stormforge (Ashran)
	}
	local horde_ignore_mobs = { --Mobs horde cannot kill
		[51079] = true,--Captain Foulwind (Vashjir)
		[68321] = true,--Kar Warmaker (Krasarang)
		[68322] = true,--Muerta (Krasarang)
		[68320] = true,--Ubunti the Shade (Krasarang)
		-- draenor quartermasters...
		[82877] = true,--High Warlord Volrath (Ashran)
		[82883] = true,--Warlord Noktyn (Ashran)
		[82882] = true,--General Aved (Ashran)
	}
	local zone_ignores = {
		[950] = {
			[32491] = true, -- Time-Lost
		},
	}
	local faction = UnitFactionGroup("player")
	function addon:ShouldIgnoreMob(id, zone)
		--Maybe add an option for this later. This checks unit faction and ignores mobs your faction cannot do anything with.
		if faction == "Alliance" and alliance_ignore_mobs[id] or faction == "Horde" and horde_ignore_mobs[id] then
			return true
		end
		if globaldb.ignore[id] then
			return true
		end
		if zone and zone_ignores[zone] and zone_ignores[zone][id] then
			return true
		end
	end
end

function addon:ZoneContainsMobs(zone)
	if not globaldb.mobs_byzoneid[zone] then
		return
	end
	for id, locations in pairs(globaldb.mobs_byzoneid[zone]) do
		return true
	end
end

-- Returns id, addon:GetMob(zone, id)
function addon:GetMobByCoord(zone, coord)
	if not globaldb.mobs_byzoneid[zone] then return end
	for id, locations in pairs(globaldb.mobs_byzoneid[zone]) do
		for _, mob_coord in ipairs(locations) do
			if coord == mob_coord then
				return id, self:GetMob(zone, id)
			end
		end
	end
end

function addon:DeleteMobCoord(zone, id, coord)
	if not globaldb.mobs_byzoneid[zone] and globaldb.mobs_byzoneid[zone][id] then return end
	for i, mob_coord in ipairs(globaldb.mobs_byzoneid[zone][id]) do
		if coord == mob_coord then
			tremove(globaldb.mobs_byzoneid[zone][id], i)
			return
		end
	end
end

function addon:DeleteMob(id)
	if not (id and globaldb.mob_name[id]) then return end
	for zone, mobs in pairs(globaldb.mobs_byzoneid) do
		mobs[id] = nil
	end
	globaldb.mob_level[id] = nil
	globaldb.mob_elite[id] = nil
	globaldb.mob_type[id] = nil
	globaldb.mob_count[id] = nil
	globaldb.mob_seen[id] = nil
	globaldb.mob_tameable[id] = nil
	local name = globaldb.mob_name[id]
	globaldb.mob_name[id] = nil
	globaldb.mob_id[name] = nil
end

function addon:DeleteAllMobs()
	local n = 0
	for id in pairs(globaldb.mob_name) do
		self:DeleteMob(id)
		n = n + 1
	end
	globaldb.mob_name = {}
	globaldb.mob_id = {}
	DEFAULT_CHAT_FRAME:AddMessage("SilverDragon: Removed "..n.." rare mobs from database.")
	self.events:Fire("DeleteAll", n)
end

-- Scanning:

function addon:CheckNearby()
	if (not self.db.profile.instances) and IsInInstance() then return end
	local zone = self:GetPlayerZone()
	if not zone then return end

	self.events:Fire("Scan", zone)
end

-- Utility:

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

-- Location

local currentZone

--fix terrain phased zones with multiple IDs
local zone_overrides = {
	[606] = 683, -- hyjal_terrain1
	[720] = 748, -- uldum_terrain1
	[700] = 770, -- twilight highlands
	[905] = 811, -- vale of eternal blossoms
}
function addon:CanonicalZoneId(zoneid)
	return zone_overrides[zoneid] or zoneid
end

function addon:ZONE_CHANGED_NEW_AREA()
	if WorldMapFrame:IsVisible() then--World Map is open
		local Z = GetCurrentMapAreaID()
		SetMapToCurrentZone()
		currentZone = GetCurrentMapAreaID()
		if currentZone ~= Z then
			SetMapByID(Z)--Restore old map settings if they differed to what they were prior to forcing mapchange and user has map open.
		end
	else--Map is not open, no reason to go extra miles, just force map to right zone and get right info.
		SetMapToCurrentZone()
		currentZone = GetCurrentMapAreaID()--Get right info after we set map to right place.
	end

	currentZone = self:CanonicalZoneId(currentZone)
	if currentZone then
		self.events:Fire("ZoneChanged", currentZone)
	end
end

--Zone functions split into 2, location, and coords. There is no reason to spam check player coords and do complex map checks when we only need zone.
--So this should save a lot of wasted calls.

--First, a simpler function that just uses cached zone from last actual zone change to return current zone we are in and scanning.
function addon:GetPlayerZone()
	-- We load AFTER first ZONE_CHANGED_NEW_AREA on login, so we need a hack for initial lack of ZONE_CHANGED_NEW_AREA.
	if currentZone == nil then
		self:ZONE_CHANGED_NEW_AREA()
	end
	return currentZone
end

function addon:GetPlayerLocation()--Advanced function that actually gets the player coords for when we actually find/save a rare. No reason to run this function every second though.
	local set_Z = GetCurrentMapAreaID()
	SetMapToCurrentZone()
	local true_Z = GetCurrentMapAreaID()
	local x, y = GetPlayerMapPosition('player')
	if true_Z ~= set_Z and WorldMapFrame:IsVisible() then
		--Restore old map settings if they differed to what they were prior to forcing mapchange and user has map open.
		SetMapByID(set_Z)
	end
	if x <= 0 and y <= 0 then
		-- I don't *think* this should be possible any more. But just in case...
		x, y = 0, 0
	end
	return self:GetPlayerZone(), x, y
end

function addon:GetCoord(x, y)
	return floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
end

function addon:GetXY(coord)
	return floor(coord / 10000) / 10000, (coord % 10000) / 10000
end

do
	-- need to set up a mapfile-to-mapid mapping
	-- for: imports, and map notes addons
	local MAX_MAPFILE = 1100
	local mapfile_to_zoneid = {}
	local zoneid_to_mapfile = {}
	for zoneid = 1, MAX_MAPFILE do
		local name = GetMapNameByID(zoneid)
		if name then
			SetMapByID(zoneid)
			local mapfile = (GetMapInfo()):gsub("_terrain%d+$", "")
			if mapfile_to_zoneid[mapfile] then
				Debug("Duplicate mapfile", mapfile, zoneid_to_mapfile[zoneid])
			else
				mapfile_to_zoneid[mapfile] = zoneid
			end
			zoneid_to_mapfile[zoneid] = mapfile
		end
	end

	addon.zoneid_from_mapfile = function(mapfile)
		return addon:CanonicalZoneId(mapfile_to_zoneid[mapfile:gsub("_terrain%d+$", "")])
	end
	addon.mapfile_from_zoneid = function(zoneid)
		return zoneid_to_mapfile[zoneid]
	end
	-- addon.mapfile_to_zoneid = mapfile_to_zoneid
end
