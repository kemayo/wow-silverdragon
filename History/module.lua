local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("History", "AceEvent-3.0")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local LibWindow = LibStub("LibWindow-1.1")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local db

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("History", {
		profile = {
			enabled = true,
			collapsed = false,
			-- locked = true,
			-- empty = true,
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

	self:RegisterEvent("PET_BATTLE_OPENING_START")
	self:RegisterEvent("PET_BATTLE_CLOSE")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	self.window:Show()
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

function module:PET_BATTLE_OPENING_START()
	self.window:Hide()
end
function module:PET_BATTLE_CLOSE()
	self.window:Show()
end
function module:PLAYER_REGEN_DISABLED()
	if not self.db.profile.combat then
		self.window:Hide()
	end
end
function module:PLAYER_REGEN_ENABLED()
	self.window:Show()
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
			-- return ns:ShowConfigMenu(w)
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

	local function sizeFrame()
		local size = self.dataProvider:GetSize()
		if size == 0 or db.collapsed then
			frame.container:Hide()
			frame:SetHeight(HEADERHEIGHT)
		else
			frame.container:Show()
			local height = min((size * LINEHEIGHT) + HEADERHEIGHT, MAXHEIGHT)
			frame:SetHeight(height)
			if height == MAXHEIGHT then
				frame.container.scrollBar:Show()
				frame.container.scrollBar:SetPoint("TOPRIGHT", -8, 5)
			else
				frame.container.scrollBar:Hide()
				frame.container.scrollBar:SetPoint("TOPRIGHT", 12, 5)
			end
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

	local collapse = CreateFrame("Button", nil, frame, "UIPanelHideButtonNoScripts")
	collapse:SetSize(24, 24)
	collapse:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
	collapse:SetScript("OnMouseUp", function(button)
		db.collapsed = not db.collapsed
		sizeFrame()
	end)

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

		end

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
	scrollView:SetElementInitializer("Button", initializer)
	container.scrollView = scrollView

	ScrollUtil.InitScrollBoxWithScrollBar(scrollBox, scrollBar, scrollView)

	self.dataProvider:RegisterCallback("OnSizeChanged", function()
		local size = self.dataProvider:GetSize()
		title:SetFormattedText("%d seen", size)
		sizeFrame()
	end, frame)

	frame.container = container

	-- inital collapsed state
	sizeFrame()

	return frame
end
