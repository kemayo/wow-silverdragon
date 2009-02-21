local BZR = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()
local BCT = LibStub("LibBabble-CreatureType-3.0"):GetUnstrictLookupTable()
local BCTR = LibStub("LibBabble-CreatureType-3.0"):GetReverseLookupTable()

local addon = LibStub("AceAddon-3.0"):NewAddon("SilverDragon", "AceEvent-3.0")
SilverDragon = addon
addon.events = LibStub("CallbackHandler-1.0"):New(addon)

local mobs
function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("SilverDragon2DB", {
		profile = {
			mobs = {
				['*'] = {}, -- zones
			},
			scan = 0.5, -- scan interval, 0 for never
			delay = 600, -- number of seconds to wait between recording the same mob
		},
	})
	mobs = self.db.profile.mobs
end

function addon:OnEnable()
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	--self:RegisterEvent("CVAR_UPDATE")
end

function addon:PLAYER_TARGET_CHANGED()
	self:ProcessUnit('target')
end

function addon:UPDATE_MOUSEOVER_UNIT()
	self:ProcessUnit('mouseover')
end

local lastseen = {}
function addon:ProcessUnit(unit)
	local unittype = UnitClassification(unit)
	if not (unittype == 'rare' or unittype == 'rareelite') then return end
	local name = UnitName(unit)
	if not (UnitIsVisible(unit) and (not lastseen[name]) or (lastseen[name] < (time() - self.db.profile.delay))) then return end

	local x, y = GetPlayerMapPosition('player') -- 'player' because 'target' doesn't work on mobs
	local zone = GetRealZoneText()
	local subzone = GetSubZoneText()
	local level = UnitLevel(unit)
	local creature_type = UnitCreatureType(unit)
	
	self:SaveMob(GetRealZoneText(), name, x, y, UnitLevel(unit), unittype=='rareelite', UnitCreatureType(unit), GetSubZoneText())

	lastseen[name] = time()
	self.events:Fire("Seen", zone, name, x, y, UnitIsDead(unit))
end

function addon:SaveMob(zone, name, x, y, level, elite, creature_type, subzone)
	-- saves a mob's information, returns true if this is the first time a mob has been seen at this location
	zone = BZR[zone]
	creature_type = BCTR[creature_type]
	
	if not mobs[zone][name] then mobs[zone][name] = {} end
	local mob = mobs[zone][name]
	if not mob.locations then mob.locations = {} end
	
	mob.level = level
	mob.elite = elite
	mob.creature_type = creature_type
	mob.lastseen = time()
	
	-- convert the raw locs into 'xx.x'.
	x = math.floor(x * 1000)/10
	y = math.floor(y * 1000)/10

	local newloc = true
	for _, loc in ipairs(mob.locations) do
		if (math.abs(loc[1] - x) < 5) and (math.abs(loc[2] - y) < 5) then
			-- We've seen it close to here before. (within 5% of the zone)
			if loc[4] == 0 and loc[3] == '' then
				loc[3] = subzone
			end
			loc[4] = loc[4] + 1
			newloc = false
			break
		end
	end
	if newloc then
		table.insert(mob.locations, {x, y, subzone, 1})
		return true
	end
end

function addon:GetMob(zone, name)
	local mob = BZR[zone] and mobs[BZR[zone]][name]
	if mob then
		return #mob.locations, mob.level, mob.elite, mob.creature_type, mob.lastseen
	else
		return 0, 0, false, nil, nil
	end
end

-- Scanning:

function addon:CheckNearby()
	addon:ScanTargets()
	addon:ScanNameplates()
end

local units_to_scan = {'target', 'targettarget', 'party1target', 'party2target', 'party3target', 'party4target', 'party5target'}
function addon:ScanTargets()
	for _, unit in ipairs(units_to_scan) do
		self:ProcessUnit(unit)
	end
end

local nameplates = {}
local function process_possible_nameplate(frame)
	-- This was mostly copied from "Nameplates - Nameplate Modifications" by Biozera.
	-- Nameplates are unnamed children of WorldFrame.
	-- So: drop it if it's not the right type, has a name, or we already know about it.
	if frame:GetObjectType() ~= "Frame" or frame:GetName() or nameplates[frame] then
		return
	end
	local name, level, bar, icon, border, glow
	for i=1,frame:GetNumRegions(),1 do
		local region = select(i, frame:GetRegions())
		if region then
			local oType = region:GetObjectType()
			if oType == "FontString" then
				local point, _, relativePoint = region:GetPoint()
				if point == "BOTTOM" and relativePoint == "CENTER" then
					name = region
				elseif point == "CENTER" and relativePoint == "BOTTOMRIGHT" then
					level = region
				end
			elseif oType == "Texture" then
				local path = region:GetTexture()
				if path == "Interface\\TargetingFrame\\UI-RaidTargetingIcons" then
					icon = region
				elseif path == "Interface\\Tooltips\\Nameplate-Border" then
					border = region
				elseif path == "Interface\\Tooltips\\Nameplate-Glow" then
					glow = region
				end
			end
		end
	end
	for i=1,frame:GetNumChildren(),1 do
		local childFrame = select(i, frame:GetChildren())
		if childFrame:GetObjectType() == "StatusBar" then
			bar = childFrame
		end
	end
	if name and level and bar and border and glow then -- We have a nameplate!
		nameplates[frame] = {name = name, level = level, bar = bar, border = border, glow = glow}
		return true
	end
end

local num_worldchildren
function addon:ScanNameplates()
	if GetCVar("nameplateShowEnemies") ~= 1 then
		return
	end
	if num_worldchildren ~= WorldFrame:GetNumChildren() then
		num_worldchildren = WorldFrame:GetNumChildren()
		for i=1, num_worldchildren, 1 do
			process_possible_nameplate(select(i, WorldFrame:GetChildren()))
		end
	end
	local zone = GetRealZoneText()
	if not BZR[zone] then return end
	local zone_mobs = mobs[BZR[GetRealZoneText()]]
	for nameplate, regions in pairs(nameplates) do
		if nameplate:IsVisible() and zone_mobs[regions.name:GetText()] then
			local x, y = GetPlayerMapPosition('player')
			self.events:Fire("Seen", zone, name, x, y, false)
			break -- it's pretty unlikely there'll be two rares on screen at once
		end
	end
end

-- Utility:

function addon:FormatLastSeen(t)
	t = tonumber(t)
	if not t or t == 0 then return 'Never' end
	local currentTime = time()
	local minutes = math.ceil((currentTime - t) / 60)
	if minutes > 59 then
		local hours = math.ceil((currentTime - t) / 3600)
		if hours > 23 then
			return math.ceil((currentTime - t) / 86400).." day(s)"
		else
			return hours.." hour(s)"
		end
	else
		return minutes.." minute(s)"
	end
end

