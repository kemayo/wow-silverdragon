local tablet = AceLibrary("Tablet-2.0")
local L = AceLibrary("AceLocale-2.2"):new("SilverDragon")

local BZR = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()
local BCT = LibStub("LibBabble-CreatureType-3.0"):GetLookupTable()
local BCTR = LibStub("LibBabble-CreatureType-3.0"):GetReverseLookupTable()

local nameplatesShowing

SilverDragon = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "AceHook-2.1", "FuBarPlugin-2.0")

SilverDragon.version = "2.0." .. string.sub("$Revision$", 12, -3)
SilverDragon.date = string.sub("$Date$", 8, 17)
SilverDragon.hasIcon = L["DefaultIcon"]

function SilverDragon:OnInitialize()
	SilverDragon:RegisterDB("SilverDragonDB")
	SilverDragon:RegisterDefaults('profile', {
		mobs = {
			--zone
			["*"] = {},
		},
		notes = true,
		scan = true,
		announce = {
			chat = true,
			error = true,
			sound = true,
		},
	})
	local optionsTable = {
		type="group",
		args={
			settings = {
				name=L["Settings"], desc=L["Configuration options"],
				type="group",
				args={
					scan = {
						name=L["Scan"], desc=L["Scan for nearby rares at a regular interval"],
						type="toggle",
						get=function() return self.db.profile.scan end,
						set=function(t)
							self.db.profile.scan = t
							if t then self:ScheduleRepeatingEvent('SilverDragon_Scan', self.CheckNearby, 5, self)
							else self:CancelScheduledEvent('SilverDragon_Scan') end
						end,
					},
					announce = {
						name=L["Announce"], desc=L["Display a message when a rare is detected nearby"],
						type="group", args={
							chat = {
								name=L["Chat"], desc=L["In the chatframe"],
								type="toggle",
								get=function() return self.db.profile.announce.chat end,
								set=function(t) self.db.profile.announce.chat = t end,
							},
							error = {
								name=L["Error"], desc=L["In the errorframe"],
								type="toggle",
								get=function() return self.db.profile.announce.error end,
								set=function(t) self.db.profile.announce.error = t end,
							},
						},
					},
					notes = {
						name=L["Notes"], desc=L["Make notes in Cartographer"],
						type="toggle",
						get = function() return self.db.profile.notes end,
						set = function(t)
							self.db.profile.notes = t
							self:ToggleCartographer(t)
						end,
						disabled = function()
							if Cartographer_Notes then return false
							else return true end
						end,
					}
				},
			},
			scan = {
				name=L["Do scan"], desc=L["Scan for nearby rares"],
				type="execute", func="CheckNearby",
			},
			defaults = {
				name=L["Import defaults"], desc=L["Import a default database of rares"],
				type="execute", func = function() self:ImportDefaults() end,
				disabled = function() return type(self.ImportDefaults) ~= 'function' end,
			},
		},
	}
	self:RegisterChatCommand(L["ChatCommands"], optionsTable)
	self.OnMenuRequest = optionsTable
	self.lastseen = {}
	
	--update the db
	if not self.db.profile.version or self.db.profile.version < 2 then
		for zone, mobs in pairs(self.db.profile.mobs) do
			if zone == "The Stockades" then zone = "The Stockade" end
			if not BZR[zone] then
				self:Print("A translation for the zone '"..zone.."' could not be found.")
			else
				for name, mob in pairs(mobs) do
					if type(mob) == 'string' then
						local x, y, level, elite, ctype, csubzone, lastseen = string.match(mob, "^(.*):(.*):(-?%d*):(%d*):(.*):(.*):(%d*)")
						mob = {}
						mob.locations = {}
						if not (x == 0 and y == 0) or (lastseen and tonumber(lastseen) > 0) then
							table.insert(mob.locations, {tonumber(x), tonumber(y), csubzone, 1})
						end
						mob.level = tonumber(level)
						mob.elite = tonumber(elite)==1
						mob.type = BCTR[ctype]
						mob.lastseen = tonumber(lastseen)
						
						if not self.db.profile.mobs[BZR[zone]] then
							self.db.profile.mobs[BZR[zone]] = {}
						end
						self.db.profile.mobs[BZR[zone]][name] = mob
					end
				end
			end
		end
		self.db.profile.version = 2
	end
end

function SilverDragon:OnEnable()
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	if self.db.profile.scan then
		self:ScheduleRepeatingEvent('SilverDragon_Scan', self.CheckNearby, 5, self)
	end
	self:ToggleCartographer(self.db.profile.notes)
	
	self:SecureHook("ShowNameplates", function() nameplatesShowing = true end)
	self:SecureHook("HideNameplates", function() nameplatesShowing = false end)
	UpdateNameplates() -- Calling this causes ShowNameplates to be called if nameplates are showing, or HideNameplates if they aren't!
end

function SilverDragon:OnDisable()
	self:ToggleCartographer(false)
end

local cartdb = {}
local cartdb_populated
function SilverDragon:ToggleCartographer(enable)
	if Cartographer_Notes then
		if enable then
			Cartographer_Notes:RegisterIcon("Rare", {text = L["Rare mob"], path = "Interface\\Icons\\INV_Misc_Head_Dragon_01", width=12, height=12})
			Cartographer_Notes:RegisterNotesDatabase("SilverDragon", cartdb, SilverDragon)
			if not cartdb_populated then
				for zone, mobs in pairs(self.db.profile.mobs) do
					for name, mob in pairs(mobs) do
						if mob.locations then
							for _, loc in ipairs(mob.locations) do
								if loc[1] and loc[2] and loc[1] > 0 and loc[2] > 0 then
									Cartographer_Notes:SetNote(zone, tonumber(loc[1])/100, tonumber(loc[2])/100, 'Rare', 'SilverDragon', 'title', name)
								end
							end
						end
					end
				end
				cartdb_populated = true
			end
		else
			Cartographer_Notes:UnregisterIcon("Rare")
			Cartographer_Notes:UnregisterNotesDatabase("SilverDragon")
		end
	end
end

function SilverDragon:SetNoteHere(text)
	local x,y = GetPlayerMapPosition('player')
	Cartographer_Notes:SetNote(GetRealZoneText(), x, y, 'Rare', 'SilverDragon', 'title', text)
end

function SilverDragon:PLAYER_TARGET_CHANGED()
	self:IsRare('target')
end

function SilverDragon:UPDATE_MOUSEOVER_UNIT()
	self:IsRare('mouseover')
end

function SilverDragon:SaveMob(zone, name, x, y, level, elite, ctype, subzone)
	if not self.db.profile.mobs[BZR[zone]][name] then self.db.profile.mobs[BZR[zone]][name] = {} end
	local mob = self.db.profile.mobs[BZR[zone]][name]
	mob.level = level
	mob.elite = elite
	mob.ctype = BCTR[ctype] -- saves the english creature type
	if not mob.locations then mob.locations = {} end
	-- convert the raw locs into 'xx.x'.
	x = math.floor(x * 1000)/10
	y = math.floor(y * 1000)/10
	local newloc = true
	for _, loc in ipairs(mob.locations) do
		if (math.abs(loc[1] - x) < 5) and (math.abs(loc[2] - y) < 5) then
			-- We've seen it close to here before. (within 5% of the zone)
			-- So, +1 to number of times seen
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
		if self.db.profile.notes and Cartographer_Notes and not (x == 0 and y == 0) then
			self:SetNoteHere(name)
		end
		return true
	end
end
function SilverDragon:GetMobInfo(zone, name)
	local mob = BZR[zone] and self.db.profile.mobs[BZR[zone]][name]
	if mob then
		return #mob.locations, mob.level, mob.elite, mob.type, mob.lastseen
	else
		return 0, 0, false, nil, nil
	end
end

do
	local distanceCache = {}
	function SilverDragon:IsRare(unit)
		local c12n = UnitClassification(unit)
		if c12n == 'rare' or c12n == 'rareelite' then
			local name = UnitName(unit)
			local distance = 1000
			if CheckInteractDistance(unit, 3) then
				distance = 10
			elseif CheckInteractDistance(unit, 4) then
				distance = 30
			end
			self:Announce(name, UnitIsDead(unit))
			if UnitIsVisible(unit) and distance < (distanceCache[name] or 100) then -- (Are we 30 yards or less from it; trying to prevent wildly inaccurate notes, here.)
				distanceCache[name] = distance
				local x, y = GetPlayerMapPosition("player")
				local newloc = self:SaveMob(GetRealZoneText(), name, x, y, UnitLevel(unit), c12n=='rareelite', UnitCreatureType(unit), GetSubZoneText())
				
				self:Update()
			end
		end
	end
end

function SilverDragon:Announce(name, dead)
	-- Announce the discovery of a rare.  Return true if we announced.
	-- Only announce each rare every 10 minutes, preventing spam while we're in combat.
	-- TODO: Make that time configurable.
	if (not self.lastseen[name]) or (self.lastseen[name] < (time() - 600)) then
		if self.db.profile.announce.error then
			UIErrorsFrame:AddMessage(string.format(L["%s seen!"], name), 1, 0, 0, 1, UIERRORS_HOLD_TIME)
			if dead then
				UIErrorsFrame:AddMessage(L["(it's dead)"], 1, 0, 0, 1, UIERRORS_HOLD_TIME)
			end
		end
		if self.db.profile.announce.chat then
			self:Print(string.format(L["%s seen!"], name), dead and L["(it's dead)"] or '')
		end
		if self.db.profile.announce.sound then
			
		end
		
		self.lastseen[name] = time()
		return true
	end
end

function SilverDragon:CheckNearby()
	if nameplatesShowing then
		self:NameplateScan()
	end
	self:TargetScan()
end

function SilverDragon:OnTooltipUpdate()
	local zone, subzone = GetRealZoneText(), GetSubZoneText()
	cat = tablet:AddCategory('text', zone, 'columns', 5)
	for name, mob in pairs(self.db.profile.mobs[BZR[zone]]) do
		cat:AddLine(
			'text', name,
			'text2', string.format("level %s%s %s", (mob.level and tonumber(mob.level) > 1) and mob.level or '?', mob.elite and '+' or '', mob.type and BCT[mob.type] or '?'),
			'text5', self:LastSeen(mob.lastseen)
		)
		for _, loc in ipairs(mob.locations) do
			local nearby = subzone == loc[3]
			cat:AddLine(
				'text', ' ',
				'text3', loc[3],
				'text3R', nearby and 0 or nil, 'text3G', nearby and 1 or nil, 'text3B', nearby and 0 or nil,
				'text4', string.format("%s, %s", loc[1], loc[2]),
				'text4R', nearby and 0 or nil, 'text4G', nearby and 1 or nil, 'text4B', nearby and 0 or nil,
				'text5', 'x'..loc[4],
				'text5R', nearby and 0 or nil, 'text5G', nearby and 1 or nil, 'text5B', nearby and 0 or nil
			)
		end
	end
end

function SilverDragon:LastSeen(t)
	if not t or t == 0 then return L['Never'] end
	local currentTime = time()
	local minutes = math.ceil((currentTime - t) / 60)
	if minutes > 59 then
		local hours = math.ceil((currentTime - t) / 3600)
		if hours > 23 then
			return math.ceil((currentTime - t) / 86400)..L[" day(s)"]
		else
			return hours..L[" hour(s)"]
		end
	else
		return minutes..L[" minute(s)"]
	end
end

function SilverDragon:OnTextUpdate()
	self:SetText(L["Rares"])
end

-- Cartographer Overrides --

function SilverDragon:OnNoteTooltipRequest(zone, id, data, inMinimap)
	local mob = self.db.profile.mobs[zone][data.title]
	if not mob then return end
	local cat = tablet:AddCategory('text', data.title, 'justify', 'CENTER')
	cat:AddLine('text', string.format("level %s%s %s", (mob.level and tonumber(mob.level) > 1) and mob.level or '?', mob.elite and '+' or '', mob.type and BCT[mob.type] or '?'))
	cat:AddLine('text', self:LastSeen(lastseen))
end

function SilverDragon:OnNoteTooltipLineRequest(zone, id, data, inMinimap)
	local numLocs, level, elite, ctype, lastseen = self:GetMobInfo(zone, data.title)
	return 'text', string.format("%s: level %s%s %s", data.title, (level and tonumber(level) > 1) and level or '?', elite and '+' or '', ctype and BCT[ctype] or '?')
end

-- Nameplate Scanning --

local worldchildren
local nameplates = {}

local function CheckForNameplate(frame)
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

function SilverDragon:NameplateScan(hideNameplates)
	if worldchildren ~= WorldFrame:GetNumChildren() then
		for i=1,WorldFrame:GetNumChildren(),1 do
			CheckForNameplate(select(i, WorldFrame:GetChildren()))
		end
		worldchildren = WorldFrame:GetNumChildren()
	end
	local zone = GetRealZoneText()
	for nameplate, regions in pairs(nameplates) do
		if nameplate:IsVisible() and self.db.profile.mobs[BZR[zone]][regions.name:GetText()] then
			self:Announce(regions.name:GetText()) -- It's probably possible to check the live-ness of a mob by examining the bar frame.  Work out how to do this.
			break
		end
	end
end

-- Target Scanning --

function SilverDragon:TargetScan()
	self:IsRare("target")
	self:IsRare("targettarget")
	for i=1, GetNumPartyMembers(), 1 do
		self:IsRare(("party%dtarget"):format(i))
		self:IsRare(("partypet%dtarget"):format(i))
	end
end

-- Imports --

function SilverDragon:RaretrackerImport()
	if RT_Database then
		for zone, mobs in pairs(RT_Database) do
			for name, info in pairs(mobs) do
				if not self.db.profile.mobs[BZR[zone]][name] then
					self:SaveMob(zone, name, info.locX or 0, info.locY or 0, info.level, info.elite or 0, info.creatureType or '', info.subZone or '')
				end
			end
		end
	else
		self:Print(L["Raretracker needs to be loaded for this to work."])
	end
end
