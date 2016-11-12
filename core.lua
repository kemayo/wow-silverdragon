local myname, ns = ...

local HBD = LibStub("HereBeDragons-1.0")

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

BINDING_HEADER_SILVERDRAGON = "SilverDragon"
_G["BINDING_NAME_CLICK SilverDragonPopupButton:LeftButton"] = "Target last found mob"
_G["BINDING_NAME_CLICK SilverDragonMacroButton:LeftButton"] = "Scan for nearby mobs"

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
			locations = {[zoneid] = {coord,...}}
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
					local questMobs = questMobLookup[mobdata.quest]
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
		end
	end

	self.events:Fire("Ready")
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

	if SilverDragon2DB then
		-- Migrating some data from v2

		for mobid, when in pairs(SilverDragon2DB.global.mob_seen) do
			if when > 0 then
				globaldb.mob_seen[mobid] = when
			end
		end
		for mobid, count in pairs(SilverDragon2DB.global.mob_count) do
			globaldb.mob_count[mobid] = count
		end

		_G["SilverDragon2DB"] = nil
	end

	-- TODO: move to miner, remove at the source
	-- Total hack. I'm very disappointed in myself. Blood Seeker is flagged as tamemable, but really isn't.
	-- (It despawns in 10-ish seconds, and shows up high in the sky.)
	-- globaldb.mob_tameable[3868] = nil
end

function addon:OnEnable()
	self:BuildLookupTables()
	if self.db.profile.scan > 0 then
		self:ScheduleRepeatingTimer("CheckNearby", self.db.profile.scan)
	end
end

do
	local mobNameToId = {}
	local questNameToId = {}

	local cache_tooltip = CreateFrame("GameTooltip", "SDCacheTooltip", _G.UIParent, "GameTooltipTemplate")
	cache_tooltip:SetOwner(_G.WorldFrame, "ANCHOR_NONE")
	local function TextFromHyperlink(link)
		cache_tooltip:SetHyperlink(link)
		local text = SDCacheTooltipTextLeft1:GetText()
		if text and text ~= "" then
			return text
		end
	end
	function addon:NameForMob(id)
		if not self.db.locale.mob_name[id] then
			local name = TextFromHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
			if name then
				self.db.locale.mob_name[id] = name
				mobNameToId[name] = id
			end
		end
		return self.db.locale.mob_name[id]
	end
	function addon:IdForMob(name)
		return mobNameToId[name]
	end
	function addon:NameForQuest(id)
		if not self.db.locale.quest_name[id] then
			local name = TextFromHyperlink(("quest:%d"):format(id))
			if name then
				name = name:gsub("Vignette: ", "")
				self.db.locale.quest_name[id] = name
				questNameToId[name] = id
			end
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
		local name = addon:NameForMob(id)
		return name, m.quest, m.vignette or name, m.tameable, globaldb.mob_seen[id], globaldb.mob_count[id]
	end
end
function addon:IsMobInZone(id, zone)
	if mobsByZone[zone] then
		return mobsByZone[zone][id]
	end
end
-- Returns id, addon:GetMobInfo(id)
function addon:GetMobByCoord(zone, coord)
	if not mobsByZone[zone] then return end
	for id, locations in pairs(mobsByZone[zone]) do
		for _, mob_coord in ipairs(locations) do
			if coord == mob_coord then
				return id, self:GetMobInfo(id)
			end
		end
	end
end

function addon:GetMobLabel(id)
	local name = self:NameForMob(id)
	if not name then
		return UNKNOWN
	end
	if not mobdb[id] then
		return name
	end
	return name .. (mobdb[id].notes and (" (" .. mobdb[id].notes .. ")") or "")
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
			Debug("Skipping notification: taxi", id, name, source)
			return
		end
		globaldb.mob_count[id] = globaldb.mob_count[id] + 1
		globaldb.mob_seen[id] = time()
		lastseen[id..zone] = time()
		self.events:Fire("Seen", id, zone, x, y, is_dead, source, unit)
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
		-- legion
		[92951] = true, --Houndmaster Ely
		[94313] = true, -- Daniel "Boomer" Vorick
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
		-- legion
		[92611] = true,--deathsquad: daggerfang
		[92626] = true,--deathsquad: adams
		[92631] = true,--deathsquad: jess
		[92633] = true,--deathsquad: huwe
		[92634] = true,--deathsquad: perez
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
	function addon:UnitID(unit)
		return npcIdFromGuid(UnitGUID(unit))
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

-- Location

function addon:GetCoord(x, y)
	return floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
end

function addon:GetXY(coord)
	return floor(coord / 10000) / 10000, (coord % 10000) / 10000
end
