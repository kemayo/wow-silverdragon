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

local RedButtonMixin
local CreateRedButton

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("History", {
		profile = {
			enabled = true,
			collapsed = false,
			-- locked = true,
			empty = true,
			combat = false,
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
			},
		},
	})
	db = self.db.profile

	self.rares = {}
	self.dataProvider = self:CreateDataProvider()

	self:RegisterConfig()

	self:SetEnabledState(db.enabled)
end

function module:OnEnable()
	if not self.window then
		self.window = self:CreateWindow()
	end
	core.RegisterCallback("History", "Seen", function(callback, id, zone, x, y, dead, source)
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
			mob = true,
			type = "mob",
		}
		table.insert(self.rares, data)
		self:AddData(data)
	end)
	core.RegisterCallback("History", "SeenLoot", function(callback, name, id, zone, x, y, GUID)
		if not self.db.profile.loot then
			return
		end
		local vignetteInfo = GUID and C_VignetteInfo.GetVignetteInfo(GUID)
		self:AddData{
			id = id,
			name = name,
			zone = zone,
			x = x,
			y = y,
			source = "vignette",
			when = time(),
			atlas = vignetteInfo and vignetteInfo.atlasName,
			guid = GUID,
			loot = true,
			type = "loot",
		}
	end)

	self:RegisterEvent("PET_BATTLE_OPENING_START", "Refresh")
	self:RegisterEvent("PET_BATTLE_CLOSE", "Refresh")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "Refresh")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "Refresh")

	self:Refresh()
end

function module:AddData(data)
	if not self.dataProvider then return end
	local collection = self.dataProvider:GetCollection()
	if collection[#collection] and collection[#collection].when == data.when then
		-- time is in seconds, so moments when we see multiples can be a problem
		data.when = data.when + 0.01
	end
	self.dataProvider:Insert(data)
end

function module:OnDisable()
	core.UnregisterCallback(self, "Seen")

	self.window:Hide()
end

function module:GetRares()
	return self.rares
end

function module:CreateDataProvider()
	local dataProvider = CreateDataProvider(self.vignetteLogOrder)
	-- It's stored in an append-table, but I want the new events at the top:
	dataProvider:SetSortComparator(function(lhs, rhs)
		return lhs.when > rhs.when
	end)
	return dataProvider
end

function module:CreateWindow()
	local MAXHEIGHT = 250
	local HEADERHEIGHT = 28
	local LINEHEIGHT = 26
	local frame = CreateFrame("Frame", "SilverDragonHistoryFrame", UIParent, "BackdropTemplate")
	frame:SetSize(240, MAXHEIGHT)
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

		if size == 0 or db.collapsed then
			self.container:Hide()
			self:SetHeight(HEADERHEIGHT)
		else
			self.container:Show()
			local height = min((size * LINEHEIGHT) + HEADERHEIGHT, MAXHEIGHT)
			self:SetHeight(height)
			if height == MAXHEIGHT then
				self.container.scrollBar:Show()
				self.container.scrollBar:SetPoint("TOPRIGHT", -8, 5)
			else
				self.container.scrollBar:Hide()
				self.container.scrollBar:SetPoint("TOPRIGHT", 12, 5)
			end
		end
		self.clearButton:SetEnabled(size > 0)
		self.collapseButton:SetEnabled(size > 0)
		self.collapseButton:SetButtonMode(db.collapsed and "Plus" or "Minus")

		if
			(C_PetBattles and C_PetBattles.IsInBattle()) or
			(not db.combat and InCombatLockdown()) or
			size == 0 and not db.empty
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
		frame:RefreshForContents()
	end)
	frame.collapseButton = collapse

	local clear = CreateRedButton(nil, frame)
	clear:SetSize(24, 24)
	clear:SetButtonMode("Delete")
	clear:SetPoint("RIGHT", collapse, "LEFT", -2, 0)
	clear:SetScript("OnMouseUp", function(button)
		frame.dataProvider:Flush()
	end)
	frame.clearButton = clear

	local function Line_OnEnter(line)
		local data = line.data
		if not data then return end

		GameTooltip:SetOwner(line, "ANCHOR_NONE")
		if line:GetCenter() < (UIParent:GetWidth() / 2) then
			GameTooltip:SetPoint("TOPLEFT", line, "TOPRIGHT")
		else
			GameTooltip:SetPoint("TOPRIGHT", line, "TOPLEFT")
		end
		if data.mob then
			GameTooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(data.id))
		else
			GameTooltip:AddLine(data.name)
			-- tooltip, id, only_knowable, is_treasure
			ns.Loot.Summary.UpdateTooltip(GameTooltip, data.id, nil, true)
		end
		local uiMapID, x, y = self:GetPositionFromData(data, false)
		if uiMapID and x and y then
			GameTooltip:AddDoubleLine(core.zone_names[uiMapID] or UNKNOWN, ("%.1f, %.1f"):format(x * 100, y * 100))
		else
			GameTooltip:AddDoubleLine(core.zone_names[uiMapID] or UNKNOWN, UNKNOWN)
		end
		if data.mob and not InCombatLockdown() then
			GameTooltip:AddLine("Click to target if nearby", 0, 1, 1)
		end
		GameTooltip:AddLine("Control-click to set a waypoint", 0, 1, 1)
		GameTooltip:AddLine("Shift-click to link location in chat", 0, 1, 1)
		GameTooltip:Show()
	end

	local function Line_OnMouseUp(line, button)
		if button ~= "LeftButton" then return end
		if not line.data then return end
		-- local zone, x, y = core:GetClosestLocationForMob(line.data.id)
		if IsControlKeyDown() then
			local idOrName, zone, x, y = line.data.id or line.data.name, line.data.zone, line.data.x, line.data.y
			if zone and x and y then
				core:GetModule("TomTom"):PointTo(idOrName, zone, x, y, 0, true)
			end
			return
		end
		if IsShiftKeyDown() then
			core:GetModule("ClickTarget"):SendLinkFromData(line.data)
			return
		end
	end

	local initializer = function(line, data)
		if not line.icon then
			line:SetHeight(LINEHEIGHT)
			line.icon = line:CreateTexture()
			line.icon:SetSize(LINEHEIGHT - 2, LINEHEIGHT - 2)
			line.icon:SetPoint("LEFT", 4, 0)
			line.title = line:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			line.title:SetPoint("LEFT", line.icon, "RIGHT", 4, 0)
			line.title:SetPoint("RIGHT")
			line.title:SetJustifyH("LEFT")
			line.title:SetMaxLines(2)
			line.time = line:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			line.time:SetPoint("TOPRIGHT", 0, -2)
			line.title:SetPoint("RIGHT", line.time, "LEFT")
			line.source = line:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			line.source:SetPoint("BOTTOMRIGHT", 0, 2)
			line.source:SetTextColor(1, 1, 1, 0.6)
			line.title:SetPoint("RIGHT", line.time, "LEFT")
			line:SetScript("OnEnter", Line_OnEnter)
			line:SetScript("OnLeave", GameTooltip_Hide)
			line:SetScript("OnMouseUp", Line_OnMouseUp)
			line:EnableMouse(true)
			line:RegisterForClicks("AnyUp", "AnyDown")
			line:SetAttribute("type", "macro")
		end

		line:SetAttribute("macrotext1", "")

		line.data = data
		line.title:SetText(data.name or core:GetMobLabel(data.id) or data.id)
		line.time:SetText(date("%H:%M", data.when))
		line.source:SetText(data.source)

		if data.mob then
			-- `nil` if completion not knowable, true/false if knowable
			local quest, achievement, by_alt = ns:CompletionStatus(data.id)
			if quest or achievement then
				if (quest and achievement) or (quest == nil or achievement == nil) then
					-- full completion
					line.title:SetTextColor(0.33, 1, 0.33) -- green
				else
					-- partial completion
					line.title:SetTextColor(1, 1, 0.33) -- yellow
				end
			elseif quest ~= nil or achievement ~= nil then
				line.title:SetTextColor(1, 0.33, 0.33) -- red
			else
				line.title:SetTextColor(1, 1, 1, 1)
			end
			if ns.Loot.HasInterestingMounts(data.id) then
				-- an unknown mount or a BoE mount
				line.icon:SetAtlas("VignetteKillBoss")
			elseif ns.Loot.Status.Toy(data.id) == false or ns.Loot.Status.Pet(data.id) == false then
				-- but toys and pets are only special until you loot them
				line.icon:SetAtlas("VignetteKillElite")
			else
				line.icon:SetAtlas("VignetteKill")
			end

			-- set up targeting
			local name = core:NameForMob(data.id)
			if name then
				local macrotext = "/cleartarget \n/targetexact " .. name
				line:SetAttribute("macrotext1", macrotext)
			end
		else
			line.title:SetTextColor(1, 1, 1, 1)
			line.icon:SetAtlas(data.atlas or "VignetteLoot")
		end
	end

	-- scrollframe with dataprovider:

	local container = CreateFrame("Frame", nil, frame)
	container:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -HEADERHEIGHT)
	container:SetPoint("BOTTOMRIGHT")

	local scrollBar = CreateFrame("EventFrame", nil, container, "MinimalScrollBar")
	scrollBar:SetPoint("BOTTOMRIGHT")
	container.scrollBar = scrollBar

	local scrollBox = CreateFrame("Frame", nil, container, "WowScrollBoxList")
	scrollBox:SetPoint("TOPLEFT")
	scrollBox:SetPoint("BOTTOMRIGHT", scrollBar, "BOTTOMLEFT", -6, 0)
	container.scrollBox = scrollBox

	local scrollView = CreateScrollBoxListLinearView()
	scrollView:SetDataProvider(self.dataProvider)
	scrollView:SetElementExtent(LINEHEIGHT)  -- Fixed height for each row; required as we're not using XML.
	scrollView:SetElementInitializer("InsecureActionButtonTemplate", initializer)
	container.scrollView = scrollView

	ScrollUtil.InitScrollBoxWithScrollBar(scrollBox, scrollBar, scrollView)

	self.dataProvider:RegisterCallback("OnSizeChanged", function()
		frame:RefreshForContents()
	end, frame)

	frame.container = container

	frame:RefreshForContents()

	return frame
end

function module:Refresh()
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
		rootDescription:CreateCheckbox("Include treasure vignettes", isChecked, toggleChecked, "loot")
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
