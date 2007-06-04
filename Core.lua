local tablet = AceLibrary("Tablet-2.0")
local L = AceLibrary("AceLocale-2.2"):new("SilverDragon")

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
end

function SilverDragon:OnEnable()
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	if self.db.profile.scan then
		self:ScheduleRepeatingEvent('SilverDragon_Scan', self.CheckNearby, 5, self)
	end
	self:ToggleCartographer(self.db.profile.notes)
	
	self:SecureHook("ShowNameplates", function() nameplatesShowing = true; end)
	self:SecureHook("HideNameplates", function() nameplatesShowing = false; end)
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
					for name in pairs(mobs) do
						local x, y = self:GetMobInfo(zone, name)
						if x > 0 and y > 0 then
							Cartographer_Notes:SetNote(zone, tonumber(x)/100, tonumber(y)/100, 'Rare', 'SilverDragon', 'title', name)
						end
					end
				end
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
	self.db.profile.mobs[zone][name] = string.format("%s:%s:%d:%d:%s:%s:%d", math.floor(x * 1000)/10, math.floor(y * 1000)/10, level, elite, ctype, subzone, self.lastseen[name] or 0)
end
function SilverDragon:GetMobInfo(zone, name)
	if self.db.profile.mobs[zone][name] then
		local x,y,level,elite,ctype,csubzone,lastseen = string.match(self.db.profile.mobs[zone][name], "^(.*):(.*):(-?%d*):(%d*):(.*):(.*):(%d*)")
		return tonumber(x), tonumber(y), tonumber(level), tonumber(elite), ctype, csubzone, tonumber(lastseen)
	else
		return 0, 0, 0, 0, '', '', nil
	end
end

function SilverDragon:IsRare(unit)
	local c12n = UnitClassification(unit)
	if c12n == 'rare' or c12n == 'rareelite' then
		local name = UnitName(unit)
		--[[local distance
		if CheckInteractDistance(unit, 3) then
			distance = 10
		elseif CheckInteractDistance(unit, 4)
			distance = 30
		end--]]
		self:Announce(name, UnitIsDead(unit))
		if UnitIsVisible(unit) and CheckInteractDistance(unit, 4) then -- (Are we 30 yards or less from it; trying to prevent wildly inaccurate notes, here.)
			-- Store as: x:y:level:elite:type:subzone:lastseen
			local x, y = GetPlayerMapPosition("player")
			self:SaveMob(GetRealZoneText(), name, x, y, UnitLevel(unit), c12n=='rareelite' and 1 or 0, UnitCreatureType(unit), GetSubZoneText())
			
			self:Update()
			if self.db.profile.notes and Cartographer_Notes and not (x == 0 and y == 0) then
				self:SetNoteHere(name)
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
	for name in pairs(self.db.profile.mobs[zone]) do
		local x,y,level,elite,ctype,csubzone,lastseen = self:GetMobInfo(zone, name)
		cat:AddLine(
			'text', name, 'textR', subzone == csubzone and 0 or nil, 'textG', subzone == csubzone and 1 or nil, 'textB', subzone == csubzone and 0 or nil,
			'text2', string.format("level %s%s %s", (level and tonumber(level) > 1) and level or '?', elite==1 and '+' or '', ctype and ctype or '?'),
			'text3', csubzone,
			'text4', self:LastSeen(lastseen),
			'text5', string.format("%s, %s", x, y)
		)
	end
end

function SilverDragon:LastSeen(t)
	if t == 0 then return L['Never'] end
	local lastseen
	local currentTime = time()
	local minutes = math.ceil((currentTime - t) / 60)
	if minutes > 59 then
		local hours = math.ceil((currentTime - t) / 3600)
		if hours > 23 then
			lastseen = math.ceil((currentTime - t) / 86400)..L[" day(s)"]
		else
			lastseen = hours..L[" hour(s)"]
		end
	else
		lastseen = minutes..L[" minute(s)"]
	end
	return lastseen
end

function SilverDragon:OnTextUpdate()
	self:SetText(L["Rares"])
end

----------------------------
-- Cartographer Overrides --
----------------------------

function SilverDragon:OnNoteTooltipRequest(zone, id, data, inMinimap)
	local x,y,level,elite,ctype,csubzone,lastseen = self:GetMobInfo(zone, data.title)
	local cat = tablet:AddCategory('text', data.title, 'justify', 'CENTER')
	cat:AddLine('text', string.format("level %s%s %s", (level and tonumber(level) > 1) and level or '?', elite==1 and '+' or '', ctype and ctype or '?'))
	cat:AddLine('text', self:LastSeen(lastseen))
end

function SilverDragon:OnNoteTooltipLineRequest(zone, id, data, inMinimap)
	local x,y,level,elite,ctype,csubzone,lastseen = self:GetMobInfo(zone, data.title)
	return 'text', string.format("%s: level %s%s %s", data.title, (level and tonumber(level) > 1) and level or '?', elite==1 and '+' or '', ctype and ctype or '?')
end

------------------------
-- Nameplate Scanning --
------------------------

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
	--for _, region in ipairs({frame:GetRegions()}) do
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
	--for _, childFrame in ipairs({frame:GetChildren()}) do
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
	--[[if not nameplatesShowing then
		ShowNameplates()
		self:ScheduleEvent(self.NameplateScan, 0, self, true)
		self:ScheduleEvent(HideNameplates, 0)
		return
	end--]]
	if worldchildren ~= WorldFrame:GetNumChildren() then
		for i=1,WorldFrame:GetNumChildren(),1 do
			CheckForNameplate(select(i, WorldFrame:GetChildren()))
		end
		worldchildren = WorldFrame:GetNumChildren()
	end
	local zone = GetRealZoneText()
	for nameplate, regions in pairs(nameplates) do
		if nameplate:IsVisible() and self.db.profile.mobs[zone][regions.name:GetText()] then
			self:Announce(regions.name:GetText()) -- It's probably possible to check the live-ness of a mob by examining the bar frame.  Work out how to do this.
			break
		end
	end
	--[[if hideNameplates then
		HideNameplates()
	end--]]
end

---------------------
-- Target Scanning --
---------------------

function SilverDragon:TargetScan()
	for i=1, GetNumPartyMembers(), 1 do
		self:IsRare(("party%dtarget"):format(i))
		self:IsRare(("partypet%dtarget"):format(i))
	end
end

-------------
-- Imports --
-------------

function SilverDragon:RaretrackerImport()
	if RT_Database then
		for zone, mobs in pairs(RT_Database) do
			for name, info in pairs(mobs) do
				if not self.db.profile.mobs[zone][name] then
					self:SaveMob(zone, name, info.locX or 0, info.locY or 0, info.level, info.elite or 0, info.creatureType or '', info.subZone or '')
				end
			end
		end
	else
		self:Print(L["Raretracker needs to be loaded for this to work."])
	end
end
