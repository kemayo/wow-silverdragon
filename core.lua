local myname, ns = ...

local HBD = LibStub("HereBeDragons-2.0")

local addon = LibStub("AceAddon-3.0"):NewAddon("SilverDragon", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")
SilverDragon = addon
SilverDragon.NAMESPACE = ns -- for separate addons
addon.events = LibStub("CallbackHandler-1.0"):New(addon)

addon.Class = ns.Class
addon.IsObject = ns.IsObject
addon.conditions = ns.conditions

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
BINDING_NAME_SILVERDRAGON_TOGGLE_BROWSER = "Browse rares"

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
	-- [vignetteid] = { [mobid] = true, ... }
}
ns.vignetteMobLookup = vignetteMobLookup
ns.vignetteTreasureLookup = {
	-- [vignetteid] = { data },
}
ns.treasureByZone = {
	-- [zoneid] = { [vignetteid] = {coord, ...}, ... }
}

-- Deliberately not an and/or chain: a treasure that isn't registered must come
-- back nil, not fall through to whatever mob shares its number.
function addon:GetData(id, isTreasure)
	if isTreasure then
		return ns.vignetteTreasureLookup[id]
	end
	return mobdb[id]
end

-- Most imported treasures carry no label: the HandyNotes plugin they come from
-- reads the name off the live vignette, which a map pin never has. This follows
-- the same fallbacks as work_out_label in that plugin's handler, so the two name
-- a point the same way. Steps it has that we don't carry data for (follower,
-- currency, npc) are left out; a currency arrives as loot and is named there.
-- Unresolved ids degrade to "achievement:63359.115313" rather than UNKNOWN,
-- which says what to go and look up.
function addon:GetTreasureLabel(id)
	local data = self:GetData(id, true)
	if not data then
		return UNKNOWN
	end
	if data.name then
		-- parens: drop the substitution count gsub returns alongside the string
		return (self:RenderString(data.name, data))
	end
	local fallback
	if data.achievement and data.criteria and data.criteria ~= true then
		-- one criteria is the same as a list of one, and naming them is
		-- all-or-nothing: a partial list would read as a shorter point
		local ids = type(data.criteria) == "table" and data.criteria or {data.criteria}
		local named = {}
		for _, criteriaid in ipairs(ids) do
			local criteria = ns.GetCriteria(data.achievement, criteriaid)
			if criteria then
				table.insert(named, criteria)
			end
		end
		if #named == #ids then
			return string.join(', ', unpack(named))
		end
		fallback = 'achievement:'..data.achievement..'.'..string.join('+', unpack(ids))
	end
	if data.loot and #data.loot > 0 then
		local name = data.loot[1]:Name(true)
		if name then
			return name
		end
		fallback = 'item:'..data.loot[1].id
	end
	if data.achievement and (not data.criteria or data.criteria == true) then
		local _, achievement = GetAchievementInfo(data.achievement)
		if achievement then
			return achievement
		end
		fallback = 'achievement:'..data.achievement
	end
	return fallback or UNKNOWN
end

function addon:GetLabel(id, isTreasure)
	if isTreasure then
		return self:GetTreasureLabel(id)
	end
	return self:GetMobLabel(id)
end

-- Shared tail of every register path. Safe to re-run: upgradeloot skips entries
-- that are already Reward objects, and RegisterMobAchievement no-ops on repeat.
local function normalizeMobEntry(id, entry)
	entry.loot = ns.upgradeloot(entry.loot)
	entry.loot_shared = ns.upgradeloot(entry.loot_shared)
	if entry.achievement and entry.criteria then
		ns:RegisterMobAchievement(id, entry.achievement, entry.criteria)
	end
end
local function normalizeTreasureEntry(entry)
	entry.loot = ns.upgradeloot(entry.loot)
	entry.loot_shared = ns.upgradeloot(entry.loot_shared)
end
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
	for mobid, mobdata in pairs(data) do
		normalizeMobEntry(mobid, mobdata)
	end
end
function addon:RegisterTreasureData(source, data, updated)
	if not updated then return end
	if not addon.treasuresources[source] then addon.treasuresources[source] = {} end
	MergeTable(addon.treasuresources[source], data)
	for vignetteid, vignettedata in pairs(data) do
		normalizeTreasureEntry(vignettedata)
	end
end
do
	-- HandyNotes' point.faction means "faction required to see this". SilverDragon's
	-- own data.faction means the opposite, "faction this belongs to", so flip it here.
	local opposingFaction = {Horde="Alliance", Alliance="Horde"}

	-- a treasure can have several vignettes, the same as a mob can
	local function addTreasureVignettes(treasures, data, ...)
		for i=1, select("#", ...) do
			local vignetteID = select(i, ...)
			treasures[vignetteID] = data
		end
	end
	-- Fold my HandyNotes plugin point format into datasources/treasuresources.
	-- The field mapping is the `data` table below; the non-obvious parts: a point
	-- with `vignette` and no `npc` is a treasure, `requires` also answers to the
	-- older name `hide_before`, and `faction` is flipped (see above).
	--
	-- `atlas`/`scale` are only honoured for treasures. Rares draw from MobState,
	-- which ranks what's left on them, and a fixed icon would hide that.
	function addon:RegisterHandyNotesData(source, uiMapID, points, defaults)
		-- convenience for me, really...
		addon.datasources[source] = addon.datasources[source] or {}
		addon.treasuresources[source] = addon.treasuresources[source] or {}
		if defaults then
			local nodeType = ns.nodeMaker(defaults)
			for coord, point in pairs(points) do
				points[coord] = nodeType(point)
			end
		end
		for coord, point in pairs(points) do
			if point.npc or point.vignette then
				local data = {
					name=point.label,
					locations={[uiMapID]={coord}},
					loot=point.loot,
					loot_shared=point.loot_shared,
					notes=point.note,
					active=point.active,
					requires=point.requires or point.hide_before,
					vignette=point.vignette,
					quest=point.quest,
					hidden=point.hidden,
					worldquest=point.worldquest,
					achievement=point.achievement, criteria=point.criteria,
					faction=point.faction and opposingFaction[point.faction],
					atlas=point.atlas, scale=point.scale,
				}
				-- variations on "also register this elsewhere":
				if point.translate or point.parent or point.levels then
					local translateTo = {}
					if point.translate then
						for tzone in pairs(point.translate) do
							if tzone ~= uiMapID then
								translateTo[tzone] = true
							end
						end
					end
					if point.parent then
						local mapinfo = C_Map.GetMapInfo(uiMapID)
						if mapinfo and mapinfo.parentMapID and mapinfo.parentMapID ~= 0 then
							local pzone = mapinfo.parentMapID
							translateTo[pzone] = true
						end
					end
					if point.levels then
						-- Show on other levels of the same zone
						local groupID = C_Map.GetMapGroupID(uiMapID)
						if groupID then
							local members = C_Map.GetMapGroupMembersInfo(groupID)
							if members then
								for _, member in pairs(members) do
									if member.mapID ~= uiMapID then
										translateTo[member.mapID] = true
									end
								end
							end
						end
					end
					local x, y = addon:GetXY(coord)
					for tzone in pairs(translateTo) do
						local tx, ty = HBD:TranslateZoneCoordinates(x, y, uiMapID, tzone)
						if tx and ty then
							if not data.locations[tzone] then
								data.locations[tzone] = {}
							end
							local tcoord = addon:GetCoord(tx, ty)
							table.insert(data.locations[tzone], tcoord)
						else
							Debug("translation failed", x, y, uiMapID, tzone)
						end
					end
				end
				if point.additional then
					for _,acoord in pairs(point.additional) do
						table.insert(data.locations[uiMapID], acoord)
					end
				end
				if point.routes then
					data.routes = {[uiMapID] = point.routes}
				end
				if point.npc then
					normalizeMobEntry(point.npc, data)
					if not addon.datasources[source][point.npc] then
						addon.datasources[source][point.npc] = data
					else
						if not addon.datasources[source][point.npc].locations[uiMapID] then
							addon.datasources[source][point.npc].locations[uiMapID] = data.locations[uiMapID]
						else
							for _, pcoord in ipairs(data.locations[uiMapID]) do
								tInsertUnique(addon.datasources[source][point.npc].locations[uiMapID], pcoord)
							end
						end
					end
				else
					normalizeTreasureEntry(data)
					addTreasureVignettes(addon.treasuresources[source], data, ns.safe_unpack(point.vignette))
				end
			end
		end
	end
end
do
	local function mergeLocations(lookup, id, locations)
		if not locations then return end
		for uiMapID, coords in pairs(locations) do
			if not lookup[uiMapID] then
				lookup[uiMapID] = {}
			end
			if not lookup[uiMapID][id] then
				lookup[uiMapID][id] = {}
			end
			for _, coord in ipairs(coords) do
				lookup[uiMapID][id][coord] = true
			end
		end
	end
	local function addQuestMobLookup(lookup, mobid, quest)
		if ns.xtype(quest) == "table" then
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
	local function addVignetteMobLookups(mobid, ...)
		for i=1, select("#", ...) do
			local vignetteID = select(i, ...)
			if not vignetteMobLookup[vignetteID] then
				vignetteMobLookup[vignetteID] = {}
			end
			vignetteMobLookup[vignetteID][mobid] = true
		end
	end
	local function addMobToLookups(mobid, mobdata)
		if mobdata.hidden then
			return
		end
		mergeLocations(mobsByZone, mobid, mobdata.locations)
		-- In the olden days, we had one mob per quest and/or vignette. Alas...
		if mobdata.quest then
			addQuestMobLookup(questMobLookup, mobid, mobdata.quest)
		end
		if mobdata.worldquest then
			addQuestMobLookup(worldQuestMobLookup, mobid, mobdata.worldquest)
		end
		if mobdata.vignette then
			addVignetteMobLookups(mobid, ns.safe_unpack(mobdata.vignette))
		end
	end
	local function addTreasureToLookups(vignetteid, vignettedata)
		ns.vignetteTreasureLookup[vignetteid] = vignettedata
		if vignettedata.hidden then
			return
		end
		mergeLocations(ns.treasureByZone, vignetteid, vignettedata.locations)
	end
	function addon:BuildLookupTables()
		wipe(mobdb)
		wipe(mobsByZone)
		wipe(mobNamesByZone)
		wipe(questMobLookup)
		wipe(vignetteMobLookup)
		wipe(worldQuestMobLookup)
		wipe(ns.treasureByZone)
		wipe(ns.vignetteTreasureLookup)
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
					vignettedata.id = vignetteid
					vignettedata.source = source

					addTreasureToLookups(vignetteid, vignettedata)
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
			custom = {
				-- [uiMapID] = {}
				any = {},
				['*'] = {},
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
			dead = true,
			instances = false,
			taxi = true,
			charloot = true,
			sharedloot = true,
			sharedloot_alerts = false, -- core because it affects the map and announcements
			boeloot = true,
			transmog_specific = false,
			-- What counts as "notable"? These are read by the shared rewards
			-- system via ns.db, so the key names have to match the ones my
			-- HandyNotes plugins use.
			achievement_notable = true,
			mount_notable = true,
			toy_notable = true,
			pet_notable = true,
			transmog_notable = true,
			quest_notable = true,
			decor_notable = true,
			alts_achievements_count = false,
		},
	}, true)
	globaldb = self.db.global
	self.db.RegisterCallback(self, "OnProfileChanged", "MigrateProfileOptions")
	self.db.RegisterCallback(self, "OnProfileCopied", "MigrateProfileOptions")
	self.db.RegisterCallback(self, "OnProfileReset", "MigrateProfileOptions")

	if self.db.locale and self.db.locale.mob_name then
		self.db.locale.mob_name = nil
		self.db.locale.quest_name = nil
	end

	self:MigrateProfileOptions()

	if globaldb.always then
		MergeTable(globaldb.custom.any, globaldb.always)
		globaldb.always = nil
	end
end

-- Profile-scoped option migrations, so they also run when a profile is switched
-- to, copied over or reset, long after OnInitialize. (The locale and global ones
-- above don't need that: neither scope follows the profile.)
function addon:MigrateProfileOptions()
	if self.db.profile.lootappearances ~= nil then
		self.db.profile.transmog_specific = not self.db.profile.lootappearances
		-- has to be cleared, or this re-derives transmog_specific on every login
		-- and the option can never be changed
		self.db.profile.lootappearances = nil
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
function addon:SetCustom(uiMapID, id, watch, quiet)
	-- uiMapID can be 'any' as a special wildcard all-zones scanner
	if not id then return false end
	if (watch and globaldb.custom[uiMapID][id]) or (not watch and not globaldb.custom[uiMapID][id]) then
		-- to avoid the nil/false issue
		return false
	end
	globaldb.custom[uiMapID][id] = watch or nil
	if not quiet then
		self.events:Fire("CustomChanged", id, globaldb.custom[uiMapID][id], uiMapID)
	end
	return true
end

function addon:IsCustom(id, uiMapID, suppressAnyZone)
	if not id then return false end
	if uiMapID and globaldb.custom[uiMapID] and globaldb.custom[uiMapID][id] then return true end
	if not suppressAnyZone and globaldb.custom.any[id] then return true end
	return false
end

do
	local empty = {}
	local function mobsForZone(uiMapID, suppressAnyZone)
		local mobs = ns.mobsByZone[uiMapID] or empty
		for id, coords in pairs(mobs) do
			coroutine.yield(id, next(coords) ~= nil, false)
		end
		if globaldb.custom[uiMapID] then
			for id in pairs(globaldb.custom[uiMapID]) do
				if not mobs[id] then
					coroutine.yield(id, false, true)
				end
			end
		end
		if not suppressAnyZone then
			for id in pairs(globaldb.custom.any) do
				if not mobs[id] then
					coroutine.yield(id, false, true)
				end
			end
		end
	end
	-- Get mobs that're relevant to the a given map; this means known rares, custom mobs for that map, and custom mobs for all maps
	-- iterator returns: id, hasCoords, isCustom
	function addon:IterateRelevantMobs(uiMapID, suppressAnyZone)
		return coroutine.wrap(function()
			return mobsForZone(uiMapID, suppressAnyZone)
		end)
	end
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
function addon:IsMobInZone(id, uiMapID, suppressAnyZone)
	-- returns isInZone
	if uiMapID and mobsByZone[uiMapID] and mobsByZone[uiMapID][id] then
		return true
	end
	return self:IsCustom(id, uiMapID, suppressAnyZone)
end
do
	-- A mob's poi is a flat list of zone / poiID pairs, and each pair names its
	-- own zone because the POI need not sit on the map the mob does.
	local function checkPois(...)
		for i=1, select("#", ...), 2 do
			local zone, poiID = select(i, ...)
			if ns.areaPoi.IsActive(poiID, zone) then
				return true
			end
		end
	end
	function addon:IsMobInPhase(id, zone, isTreasure)
		local phased, poiPresent = true, true
		local data = self:GetData(id, isTreasure)
		if not data then return true end
		if data.art then
			phased = data.art == C_Map.GetMapArtID(zone)
		end
		if data.poi then
			poiPresent = checkPois(unpack(data.poi))
		end
		return phased and poiPresent
	end
end
-- Returns id, addon:GetMobInfo(id)
function addon:GetMobByCoord(zone, coord, include_ignored)
	if not mobsByZone[zone] then return end
	for id, locations in pairs(mobsByZone[zone]) do
		if locations[coord] and self:IsMobInPhase(id, zone) and (include_ignored or not self:ShouldIgnoreMob(id)) then
			return id, self:GetMobInfo(id)
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
	local function seenkey(id, zone) return id..':'..(zone or '?') end
	function addon:NotifyForMob(id, zone, x, y, is_dead, source, unit, silent, force, GUID, vignetteGUID)
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
			Debug("Skipping notification: seen", id, lastseen[seenkey(id, zone)], time() - self.db.profile.delay, source)
			return
		end
		if not self:PlayerIsInteractive() then
			Debug("Skipping notification: taxi", id, source)
			return
		end
		globaldb.mob_count[id] = globaldb.mob_count[id] + 1
		globaldb.mob_seen[id] = time()
		lastseen[seenkey(id, zone)] = time()
		self.events:Fire("Seen", id, zone, x or 0, y or 0, is_dead, source, unit, GUID, vignetteGUID)
		return true
	end
	function addon:WouldNotifyForMob(id, zone)
		return not (lastseen[seenkey(id, zone)] and time() < (lastseen[seenkey(id, zone)] + self.db.profile.delay))
	end
end
-- Shared by mobs and treasures, so both hide on a data.faction match.
-- TODO: add an option for this?
function addon:PassesFactionCheck(data)
	return not (data and data.faction == faction)
end

do
	local zone_ignores = {
		[550] = {
			[32491] = true, -- Time-Lost
		},
	}
	function addon:ShouldShowMob(id, zone)
		if zone and zone_ignores[zone] and zone_ignores[zone][id] then
			return false
		end
		if mobdb[id] then
			if mobdb[id].hidden then
				return false
			end
			if not self:PassesFactionCheck(mobdb[id]) then
				return false
			end
			if mobdb[id].requires and not ns.conditions.check(mobdb[id].requires) then
				return false
			end
		end
		return true
	end
	function addon:ShouldIgnoreMob(id, zone)
		if globaldb.ignore[id] then
			return true
		end
		if self:IsCustom(id, zone) then
			-- If you've manually added a mob we should take that a signal that you always want it announced
			-- (Unless you've also, weirdly, manually told it to be ignored as well.)
			return false
		end
		if mobdb[id] and mobdb[id].source and globaldb.ignore_datasource[mobdb[id].source] then
			return true
		end
		return not self:ShouldShowMob(id, zone)
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
	if not InCombatLockdown() and GetPlayerAuraBySpellID(369968) then
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
