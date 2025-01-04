local myname = ...
local myfullname = C_AddOns.GetAddOnMetadata(myname, "Title")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("History", "AceEvent-3.0")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local LibWindow = LibStub("LibWindow-1.1")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local db

local LineMixin
local RedButtonMixin
local CreateRedButton

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("History", {
		profile = {
			enabled = true,
			collapsed = false,
			grow = true,
			-- locked = true,
			relative = true,
			empty = true,
			combat = false,
			othershard = "dim", -- show / dim / hide
			sources = {
				target = false,
				grouptarget = true,
				mouseover = true,
				nameplate = true,
				vignette = true,
				['point-of-interest'] = true,
				chat = true,
				groupsync = true,
				guildsync = false,
				darkmagic = true,
				fake = true,
			},
			loot = true,
			position = {
				point = "LEFT",
				x = 50,
				y =  0,
				scale = 1,
				width = 240,
				height = 250,
			},
		},
	})
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

	self.data = {}
	self.rares = {}
	self.removed = {}
	self.dataProvider = self:CreateDataProvider()

	self:RegisterConfig()
	self:RefreshConfig()

	self:SetEnabledState(self.db.profile.enabled)
end

function module:RefreshConfig()
	db = self.db.profile
	if self.window then
		-- already loaded
		LibWindow.RegisterConfig(self.window, db.position)
		LibWindow.RestorePosition(self.window)
		self:Refresh()
		self[db.enabled and "Enable" or "Disable"](self)
	end
end

local currentShardSources = {
	target = true,
	-- grouptarget = true,
	mouseover = true,
	nameplate = true,
	vignette = true,
	['point-of-interest'] = true,
	chat = true,
	groupsync = false,
	guildsync = false,
	darkmagic = true,
	fake = true,
}
function module:OnEnable()
	if not self.window then
		self.window = self:CreateWindow()
	end
	core.RegisterCallback("History", "Seen", function(callback, id, zone, x, y, dead, source, unit, guid)
		if not self.db.profile.sources[source] then
			return
		end
		local data = {
			id = id,
			zone = zone,
			x = x,
			y = y,
			source = source,
			when = time(),
			guid = guid,
			mob = true,
			type = "mob",
		}
		table.insert(self.rares, data)
		self:AddData(data)
	end)
	core.RegisterCallback("History", "SeenLoot", function(callback, name, id, zone, x, y, guid)
		local vignetteInfo = guid and C_VignetteInfo.GetVignetteInfo(guid)
		self:AddData{
			id = id,
			name = name,
			zone = zone,
			x = x,
			y = y,
			source = "vignette",
			when = time(),
			atlas = vignetteInfo and vignetteInfo.atlasName,
			guid = guid,
			loot = true,
			type = "loot",
		}
	end)
	core.RegisterCallback("History", "ShardChanged", function(callback, currentShard, previousShard, guid)
		self.currentShard = currentShard
		if self.dataProvider and previousShard == "unknown" then
			for _, data in ipairs(self.dataProvider:GetCollection()) do
				if currentShardSources[data.source] and not data.shard then
					data.shard = currentShard
				end
			end
		end
		self:Refresh()
	end)

	self:RegisterEvent("PET_BATTLE_OPENING_START", "Refresh")
	self:RegisterEvent("PET_BATTLE_CLOSE", "Refresh")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "Refresh")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	self:Refresh()
end

function module:PLAYER_REGEN_DISABLED()
	-- InCombatLockdown starts returning true *after* this event, so we can't
	-- just hook this up to Refresh.
	if not db.combat then
		self.window:Hide()
	end
end

function module:AddData(data)
	if self.data[#self.data] and self.data[#self.data].when == data.when then
		-- time is in seconds, so moments when we see multiples can be a problem
		data.when = data.when + 0.01
	end
	-- Fix up the shard if it wasn't available from the source
	data.shard = core:GUIDShard(data.guid) or (currentShardSources[data.source] and self.currentShard) or nil
	-- DevTools_Dump(data)
	table.insert(self.data, data)
	if self:ShouldAddToDataProvider(data) then
		self.dataProvider:Insert(data)
	end
end

function module:OnDisable()
	core.UnregisterCallback(self, "Seen")
	core.UnregisterCallback(self, "SeenLoot")

	self.window:Hide()
end

function module:GetRares()
	return self.rares
end

function module:CreateDataProvider()
	local dataProvider = CreateDataProvider()
	-- It's stored in an append-table, but I want the new events at the top:
	dataProvider:SetSortComparator(function(lhs, rhs)
		return lhs.when > rhs.when
	end)
	return dataProvider
end

function module:RebuildDataProvider()
	Debug("History: rebuilding data provider")
	self.dataProvider:Flush()
	local newdata = {}
	for _, data in ipairs(self.data) do
		if self:ShouldAddToDataProvider(data) then
			table.insert(newdata, data)
		end
	end
	self.dataProvider:Insert(unpack(newdata))
end

function module:ShouldAddToDataProvider(data)
	if data.loot and not self.db.profile.loot then
		return
	end
	if db.othershard == "hide" and data.shard ~= self.currentShard then
		return
	end
	if self.removed[data] then
		return
	end
	return true
end

local MAXHEIGHT = 250
local HEADERHEIGHT = 28
local LINEHEIGHT = 26
function module:CreateWindow()
	local frame = CreateFrame("Frame", "SilverDragonHistoryFrame", UIParent, "BackdropTemplate")
	frame:SetSize(db.position.width, db.position.height)
	frame:SetBackdrop({
		edgeFile = [[Interface\Buttons\WHITE8X8]],
		bgFile = [[Interface\Buttons\WHITE8X8]],
		edgeSize = 1,
	})

	frame.dataProvider = self.dataProvider

	LibWindow.RegisterConfig(frame, self.db.profile.position)
	LibWindow.RestorePosition(frame)
	LibWindow.MakeDraggable(frame)

	frame:HookScript("OnDragStop", function()
		AceConfigRegistry:NotifyChange(myname)
	end)

	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:SetResizable(true)
	frame:SetResizeBounds(160, 100, 320, 600)

	frame:SetScript("OnMouseUp", function(w, button)
		if button == "RightButton" then
			return module:ShowConfigMenu(w)
		end
		if core.debuggable and button == "MiddleButton" then
			core.events:Fire(unpack(GetRandomTableValue{
				-- id, zone, x, y, is_dead, source, unit
				{"Seen", 160821, 1525, 0.5, 0.5, false, "fake"}, -- Worldedge Gorger (mount)
				{"Seen", 126900, 882, 0.5, 0.5, false, "fake"}, -- Instructor Tarahna (multi-toy)
				{"Seen", 162690, 1536, 0.5, 0.5, false, "fake"}, -- Nerissa Heartless (mount)
				{"Seen", 151625, 1462, 0.5, 0.5, false, "fake"}, -- Scrap King (loot)
				{"Seen", 159105, 1536, 0.5, 0.5, false, "fake"}, -- Collector Kash (lots of loot)
				{"Seen", 193266, 2022, 0.5, 0.5, false, "fake"}, -- Lepidoralia the Resplendent (long name)
				-- name, id, zone, x, y, guid
				{"SeenLoot", "Waterlogged Chest", 3341, 37, 0.318, 0.628},
				{"SeenLoot", "Mawsworn Supply Chest", 4969, 1970, 0.318, 0.628},
			}))
		end
	end)

	function frame:RefreshForContents()
		local size = self.dataProvider:GetSize()
		self.title:SetFormattedText("%d seen", size)

		if db.collapsed then
			self.container:Hide()
			self.resize:Hide()
			self:SetHeight(HEADERHEIGHT)
		else
			self.container:Show()
			self.resize:Show()
			if db.grow then
				-- self.container.scrollBox:GetExtent() doesn't play well here, sadly
				local scrollHeight = size * LINEHEIGHT
				self:SetHeight(min(scrollHeight + HEADERHEIGHT, db.position.height))
			else
				self:SetHeight(db.position.height)
			end
		end
		self.clearButton:SetEnabled(size > 0)
		self.collapseButton:SetEnabled(size > 0)
		self.collapseButton:SetButtonMode(db.collapsed and "Plus" or "Minus")

		if
			(C_PetBattles and C_PetBattles.IsInBattle()) or
			((not db.combat) and InCombatLockdown()) or
			(size == 0 and not db.empty)
		then
			self:Hide()
		else
			self:Show()
		end
	end

	frame:SetBackdropColor(0, 0, 0, .5)
	frame:SetBackdropBorderColor(0, 0, 0, .5)

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	frame.title = title
	title:SetJustifyH("CENTER")
	title:SetJustifyV("MIDDLE")
	title:SetPoint("TOPLEFT", 0, -8)
	title:SetPoint("TOPRIGHT", 0, -8)
	title:SetText("None seen")

	local icon = frame:CreateTexture()
	icon:SetSize(24, 24)
	icon:SetPoint("TOPLEFT", 2, -2)
	icon:SetTexture("Interface\\Icons\\INV_Misc_Head_Dragon_01")
	icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

	local collapse = CreateRedButton(nil, frame)
	collapse:SetSize(24, 24)
	collapse:SetButtonMode("Plus")
	collapse:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
	collapse:SetScript("OnMouseUp", function(button)
		db.collapsed = not db.collapsed
		-- Goal: have the frame's top-left point still be in the exact same
		-- Needed because LibWindow does tricks with the points to keep it
		-- in a sensible place (which it will restore when we call save)
		local frameMinX, frameMinY, frameWidth, frameHeight = frame:GetRect()
		local frameMaxX, frameMaxY = frameMinX + frameWidth, frameMinY + frameHeight
		frame:RefreshForContents() -- does the resizing
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", frameMinX, frameMaxY)
		LibWindow.SavePosition(frame)
	end)
	frame.collapseButton = collapse

	local clear = CreateRedButton(nil, frame)
	clear:SetSize(24, 24)
	clear:SetButtonMode("Delete")
	clear:SetPoint("RIGHT", collapse, "LEFT", -2, 0)
	clear:SetScript("OnMouseUp", function(button)
		for _, data in ipairs(self.data) do
			self.removed[data] = true
		end
		self:RebuildDataProvider()
	end)
	frame.clearButton = clear

	local resize = CreateFrame("Button", nil, frame)
	resize:EnableMouse(true)
	resize:SetPoint("BOTTOMRIGHT", 1, -1)
	resize:SetSize(16,16)
	resize:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	resize:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight", "ADD")
	resize:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	resize:SetScript("OnMouseDown", function()
		-- to counter grow:
		frame:SetHeight(db.position.height)
		frame:StartSizing("BOTTOMRIGHT")
	end)
	resize:SetScript("OnMouseUp", function()
		frame:StopMovingOrSizing("BOTTOMRIGHT")
		db.position.width = frame:GetWidth()
		db.position.height = frame:GetHeight()
		frame:RefreshForContents()
	end)
	frame.resize = resize

	-- scrollframe with dataprovider:

	local container = CreateFrame("Frame", nil, frame)
	container:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -HEADERHEIGHT)
	container:SetPoint("BOTTOMRIGHT")

	local scrollBox = CreateFrame("Frame", nil, container, "WowScrollBoxList")
	-- setpoint handled by manager below
	container.scrollBox = scrollBox

	local scrollBar = CreateFrame("EventFrame", nil, container, "MinimalScrollBar")
	scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 4, -3)
	scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 4, 3)
	scrollBar:SetHideTrackIfThumbExceedsTrack(true)
	container.scrollBar = scrollBar

	local scrollView = CreateScrollBoxListLinearView()
	scrollView:SetDataProvider(self.dataProvider)
	scrollView:SetElementExtent(LINEHEIGHT)  -- Fixed height for each row; required as we're not using XML.
	scrollView:SetElementInitializer("InsecureActionButtonTemplate", function(line, data)
		if not line.Init then
			Mixin(line, LineMixin)
			line:Init()
		end

		line:SetData(data)
	end)
	container.scrollView = scrollView

	ScrollUtil.InitScrollBoxWithScrollBar(scrollBox, scrollBar, scrollView)
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(scrollBox, scrollBar,
		{  -- with bar
			CreateAnchor("TOPLEFT", container),
			CreateAnchor("BOTTOMRIGHT", container, "BOTTOMRIGHT", -18, 0),
		},
		{ -- without bar
			CreateAnchor("TOPLEFT", container),
			CreateAnchor("BOTTOMRIGHT", container, "BOTTOMRIGHT", -4, 0),
		}
	)

	self.dataProvider:RegisterCallback("OnSizeChanged", function()
		frame:RefreshForContents()
	end, frame)

	frame.container = container

	frame:RefreshForContents()

	return frame
end

function module:Refresh()
	if not self.window then return end
	self:RebuildDataProvider()
	-- Force a redraw of the frames in the scrollbox
	self.window.container.scrollBox:Rebuild(true) --retainScrollPosition
	-- Resize the window around the redrawn scrollbox
	self.window:RefreshForContents()
end

local isChecked = function(key) return db[key] end
local toggleChecked = function(key)
	db[key] = not db[key]
	module:Refresh()
	AceConfigRegistry:NotifyChange(myname)

	if not module.window:IsVisible() then
		-- empty and combat could both result in it being hidden
		return MenuResponse.CloseAll
	end
end
local openConfig = function()
	local config = core:GetModule("Config", true)
	if config then
		config:ShowConfig()
		LibStub("AceConfigDialog-3.0"):SelectGroup("SilverDragon", "history")
	end
end
function module:ShowConfigMenu(frame)
	if not (_G.MenuUtil and MenuUtil.CreateContextMenu) then
		return openConfig()
	end
	MenuUtil.CreateContextMenu(frame, function(owner, rootDescription)
		rootDescription:SetTag("MENU_SILVERDRAGON_HISTORY_CONTEXT")
		rootDescription:CreateTitle(myfullname .. " " .. HISTORY)
		rootDescription:CreateCheckbox("Enabled", isChecked, function()
			db.enabled = false
			module:Disable()
			return MenuResponse.CloseAll
		end, "enabled")
		rootDescription:CreateCheckbox("Show during combat", isChecked, toggleChecked, "combat")
		rootDescription:CreateCheckbox("Show when empty", isChecked, toggleChecked, "empty")
		rootDescription:CreateCheckbox("Grow to max height", isChecked, toggleChecked, "grow")
		rootDescription:CreateCheckbox("Use relative time", isChecked, toggleChecked, "relative")
		rootDescription:CreateCheckbox("Include treasure vignettes", isChecked, toggleChecked, "loot")

		local shardIsSelected = function(val) return db.othershard == val end
		local shardSelect = function(val)
			db.othershard = val
			module:Refresh()
			AceConfigRegistry:NotifyChange(myname)
			return MenuResponse.Close
		end
		local othershard = rootDescription:CreateButton("Mobs from other shards...")
		othershard:CreateRadio("Show", shardIsSelected, shardSelect, "show")
		othershard:CreateRadio("Dim", shardIsSelected, shardSelect, "dim")
		othershard:CreateRadio("Hide", shardIsSelected, shardSelect, "hide")

		rootDescription:CreateDivider()
		rootDescription:CreateButton(CLEAR_ALL, function()
			module.dataProvider:Flush()
			return MenuResponse.CloseAll
		end)
		rootDescription:CreateButton("Open options...", openConfig)
	end)
end

function module:GetPositionFromData(data, allowFallback)
	local x, y, uiMapID = data.x, data.y, data.zone
	if uiMapID and data.GUID and data.source == "vignette" then
		local position = C_VignetteInfo.GetVignettePosition(data.GUID, uiMapID)
		if position then
			x, y = position:GetXY()
		end
	end
	if not (x and y and x > 0 and y > 0) and data.type == "mob" then
		uiMapID, x, y = core:GetClosestLocationForMob(data.id)
	end
	if allowFallback and not (x and y and x > 0 and y > 0) then
		-- fall back to sending a link to the current position
		x, y, uiMapID = HBD:GetPlayerZonePosition()
	end
	return uiMapID, x, y
end

function module:FormatRelativeTime(t)
	-- return hours:minutes from a timestamp
	t = tonumber(t)
	if not t or t == 0 then return NEVER end
	local currentTime = time()
	local hours = math.max(math.floor((currentTime - t) / 3600), 0)
	local minutes = math.max(math.floor(math.fmod(currentTime - t, 3600) / 60), 0)
	return ("%dh %02dm"):format(hours, minutes)
end

--

LineMixin = {
	Init = function(self)
		self:SetHeight(LINEHEIGHT)
		self.icon = self:CreateTexture()
		self.icon:SetSize(LINEHEIGHT - 2, LINEHEIGHT - 2)
		self.icon:SetPoint("LEFT", 4, 0)
		self.title = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		self.title:SetPoint("LEFT", self.icon, "RIGHT", 4, 0)
		self.title:SetPoint("RIGHT")
		self.title:SetJustifyH("LEFT")
		self.title:SetMaxLines(2)
		self.time = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		self.time:SetPoint("TOPRIGHT", 0, -2)
		self.title:SetPoint("RIGHT", self.time, "LEFT")
		self.source = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		self.source:SetPoint("BOTTOMRIGHT", 0, 2)
		self.source:SetTextColor(1, 1, 1, 0.6)
		self.title:SetPoint("RIGHT", self.time, "LEFT")
		self:SetScript("OnEnter", self.Scripts.OnEnter)
		self:SetScript("OnLeave", self.Scripts.OnLeave)
		self:SetScript("OnMouseUp", self.Scripts.OnMouseUp)
		self:EnableMouse(true)
		self:RegisterForClicks("AnyUp", "AnyDown")
		self:SetAttribute("type", "macro")

		-- *not* anything that divides into 60:
		self.ticker = C_Timer.NewTicker(13, self.Scripts.OnTick)
		self.ticker.line = self
	end,
	SetData = function(self, data)
		self:SetAttribute("macrotext1", "")
		self:SetAlpha(1)

		self.data = data
		self.title:SetText(data.name or core:GetMobLabel(data.id) or data.id)
		if db.relative then
			self.time:SetText(module:FormatRelativeTime(data.when))
		else
			self.time:SetText(date("%H:%M", data.when))
		end
		self.source:SetText(data.source)

		if data.mob then
			-- `nil` if completion not knowable, true/false if knowable
			local quest, achievement, by_alt = ns:CompletionStatus(data.id)
			if quest or achievement then
				if (quest and achievement) or (quest == nil or achievement == nil) then
					-- full completion
					self.title:SetTextColor(0.33, 1, 0.33) -- green
				else
					-- partial completion
					self.title:SetTextColor(1, 1, 0.33) -- yellow
				end
			elseif quest ~= nil or achievement ~= nil then
				self.title:SetTextColor(1, 0.33, 0.33) -- red
			else
				self.title:SetTextColor(1, 1, 1, 1)
			end
			if ns.Loot.HasInterestingMounts(data.id) then
				-- an unknown mount or a BoE mount
				self.icon:SetAtlas("VignetteKillBoss")
			elseif ns.Loot.Status.Toy(data.id) == false or ns.Loot.Status.Pet(data.id) == false then
				-- but toys and pets are only special until you loot them
				self.icon:SetAtlas("VignetteKillElite")
			else
				self.icon:SetAtlas("VignetteKill")
			end

			-- set up targeting
			local name = core:NameForMob(data.id)
			if name then
				local macrotext = "/cleartarget \n/targetexact " .. name
				self:SetAttribute("macrotext1", macrotext)
			end
		else
			self.title:SetTextColor(1, 1, 1, 1)
			self.icon:SetAtlas(data.atlas or "VignetteLoot")
		end

		if db.othershard ~= "show" and data.shard ~= module.currentShard then
			-- the "hide" case was filtered out earlier
			self:SetAlpha(0.5)
		end
	end,
	Refresh = function(self)
		self:SetData(self.data)
	end,

	Scripts = {
		OnEnter = function(self)
			local data = self.data
			if not data then return end

			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			if self:GetCenter() < (UIParent:GetWidth() / 2) then
				GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT")
			else
				GameTooltip:SetPoint("TOPRIGHT", self, "TOPLEFT")
			end
			if data.mob then
				GameTooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(data.id))
			else
				GameTooltip:AddLine(data.name)
				-- tooltip, id, only_knowable, is_treasure
				ns.Loot.Summary.UpdateTooltip(GameTooltip, data.id, nil, true)
				if ns.vignetteTreasureLookup[data.id] and ns.vignetteTreasureLookup[data.id].notes then
					GameTooltip:AddLine(core:RenderString(ns.vignetteTreasureLookup[data.id].notes), 1, 1, 1, true)
				end
			end
			if data.source == "vignette" and data.guid then
				local _, vignetteID = core:GUIDShard(data.guid)
				GameTooltip:AddDoubleLine("Vignette ID",  vignetteID, 0, 1, 1, 0, 1, 1)
			end
			local uiMapID, x, y = module:GetPositionFromData(data, false)
			if uiMapID and x and y and x ~= 0 and y ~= 0 then
				GameTooltip:AddDoubleLine(core.zone_names[uiMapID] or UNKNOWN, ("%.1f, %.1f"):format(x * 100, y * 100))
			else
				GameTooltip:AddDoubleLine(core.zone_names[uiMapID] or UNKNOWN, UNKNOWN)
			end
			GameTooltip:AddDoubleLine("Seen", core:FormatLastSeen(data.when))
			GameTooltip:AddDoubleLine("Shard", core:ColorTextByCompleteness(data.shard == module.currentShard, data.shard or UNKNOWN))
			if data.mob and not InCombatLockdown() then
				GameTooltip:AddLine("Click to target if nearby", 0, 1, 1)
			end
			GameTooltip:AddLine("Control-click to set a waypoint", 0, 1, 1)
			GameTooltip:AddLine("Shift-click to link location in chat", 0, 1, 1)
			GameTooltip:AddLine("Right-click to remove this entry", 1, 0, 1)
			GameTooltip:Show()
		end,

		OnLeave = GameTooltip_Hide,

		OnMouseUp = function(self, button)
			if not self.data then return end
			if button == "RightButton" then
				module.removed[self.data] = true
				module.dataProvider:Remove(self.data)
				return
			end
			if button ~= "LeftButton" then return end
			-- local zone, x, y = core:GetClosestLocationForMob(self.data.id)
			if IsControlKeyDown() then
				local idOrName, zone, x, y = self.data.id or self.data.name, self.data.zone, self.data.x, self.data.y
				if zone and x and y then
					core:GetModule("TomTom"):PointTo(idOrName, zone, x, y, 0, true)
				end
				return
			end
			if IsShiftKeyDown() then
				core:GetModule("ClickTarget"):SendLinkFromData(self.data)
				return
			end
		end,

		OnTick = function(ticker)
			local line = ticker and ticker.line
			if not (line and line.data) then return end
			line:Refresh()
		end,
	}
}

--

function CreateRedButton(name, parent, template)
	local button = CreateFrame("Button", name, parent, template)
	return Mixin(button, RedButtonMixin)
end

RedButtonMixin = {
	SetButtonMode = function(self, mode)
		-- ArrowUp, ArrowDownGlow, Minus, Plus, Delete, Refresh
		if ns.CLASSIC then
			-- Doesn't have the redbutton textures
			-- TODO: add other modes if I use them
			if mode == "Plus" then
				self:SetNormalTexture([[Interface\Buttons\UI-PlusButton-UP]])
				self:SetPushedTexture([[Interface\Buttons\UI-PlusButton-Down]])
				self:SetHighlightTexture([[Interface\Buttons\UI-PlusButton-Hilight]], "ADD")
				self:SetDisabledTexture([[Interface\Buttons\UI-PlusButton-Disabled]])
			elseif mode == "Minus" then
				self:SetNormalTexture([[Interface\Buttons\UI-MinusButton-UP]])
				self:SetPushedTexture([[Interface\Buttons\UI-MinusButton-Down]])
				self:SetHighlightTexture([[Interface\Buttons\UI-MinusButton-Hilight]], "ADD")
				self:SetDisabledTexture([[Interface\Buttons\UI-MinusButton-Disabled]])
			elseif mode == "Delete" then
				self:SetNormalTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Up]])
				self:SetPushedTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Down]])
				self:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]], "ADD")
				self:SetDisabledTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Disabled]])
			end
		else
			self:SetNormalAtlas("128-RedButton-" .. mode)
			self:SetPushedAtlas("128-RedButton-" .. mode .. "-Pressed")
			self:SetDisabledAtlas("128-RedButton-" .. mode .. "-Disabled")
			self:SetHighlightAtlas("128-RedButton-" .. mode .. "-Highlight", "ADD")
		end
	end,
}
