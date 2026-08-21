local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Browser")
local Debug = core.Debug

local LibWindow = LibStub("LibWindow-1.1")

--[[
Every part a look is allowed to touch is built here, once, and nowhere else. A
look positions and skins them; it never creates. Anything one look wants and the
others don't still gets made here, and the others hide it.

	window            SetBackdrop and the border are the look's to set
	window.header     strip along the top
	window.icon       the dragon-head icon, top left
	window.title      window title
	window.close      close button
	window.search     search box
	window.grouping   picks what the second level of the tree lists
	window.filter     opens the filter menu
	window.nav        left-hand container, holding scrollBox/scrollBar/scrollView
	window.splitter   divider between nav and detail
	window.detail     right-hand container
	window.solidBG, window.portraitMask, window.nineSlice,
	window.navInset, window.detailInset -- chrome only Traditional shows

A look sets window.headerHeight and window.rowHeight rather than assuming either,
then calls window:Layout(). The scrollbar's anchors within window.nav are fixed:
looks move window.nav itself, which is the same thing with less to go wrong.
]]

-- Fixed width, with the height worked out from the contents. The detail column
-- reserves a set amount (see Browser/details.lua), and the map below it spans
-- the full width of that column, so its height follows the zone art's shape.
-- That leaves nothing to drag, hence no resize grip.
-- The nav is a fixed share of that. Dragging the divider would only trade one
-- column's width for the other's, and would move the window's height with it,
-- the map being sized from what the detail column has left.
local WIDTH = ns.CLASSIC and 660 or 800
local NAV_WIDTH = 260
module.NAV_WIDTH = NAV_WIDTH
local MIN_MAP, MAX_MAP = 140, 380

local RedButtonMixin = {
	SetButtonMode = function(self, mode)
		-- ArrowUp, ArrowDownGlow, Minus, Plus, Delete, Refresh
		if ns.CLASSIC then
			-- Doesn't have the redbutton textures
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
			end
		else
			self:SetNormalAtlas("128-RedButton-" .. mode)
			self:SetPushedAtlas("128-RedButton-" .. mode .. "-Pressed")
			self:SetDisabledAtlas("128-RedButton-" .. mode .. "-Disabled")
			self:SetHighlightAtlas("128-RedButton-" .. mode .. "-Highlight", "ADD")
		end
	end,
}
function module:CreateRedButton(parent)
	return Mixin(CreateFrame("Button", nil, parent), RedButtonMixin)
end

function module:CreateWindow()
	local frame = CreateFrame("Frame", "SilverDragonBrowserFrame", UIParent, "BackdropTemplate")
	frame:SetWidth(WIDTH)
	frame:SetFrameStrata("HIGH")
	frame:Hide()

	-- read module.db.profile where it's wanted, never held: a profile switch
	-- hands out a different table, and a captured one goes on being the old
	LibWindow.RegisterConfig(frame, self.db.profile.position)
	LibWindow.RestorePosition(frame)
	LibWindow.MakeDraggable(frame)

	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)

	tinsert(UISpecialFrames, frame:GetName())

	frame.headerHeight = 28
	frame.rowHeight = 22

	-- Header

	local header = CreateFrame("Frame", nil, frame)
	frame.header = header
	header:SetPoint("TOPLEFT")
	header:SetPoint("TOPRIGHT")

	local icon = header:CreateTexture(nil, "ARTWORK")
	frame.icon = icon
	icon:SetTexture("Interface\\Icons\\INV_Misc_Head_Dragon_01")
	icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

	-- Traditional's chrome, built here with the rest and hidden by the looks that
	-- do not want it. A frame cannot inherit PortraitFrameTemplate after
	-- creation, so the nine-slice is applied in code. It is only a border, so the
	-- panel also needs something opaque behind it.
	frame.background = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
	-- frame.background:SetPoint("TOPLEFT", 6, -6)
	-- frame.background:SetPoint("BOTTOMRIGHT", -6, 6)
	frame.background:SetPoint("TOPLEFT", 2, -2)
	frame.background:SetPoint("BOTTOMRIGHT", -2, 2)
	frame.background:Hide()

	-- PortraitFrameTemplate rounds its portrait with a mask. The metal ring is
	-- part of the nine-slice's top-left corner, not a texture of its own.
	frame.portraitMask = header:CreateMaskTexture()
	frame.portraitMask:SetTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]],
		"CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")

	local nineSliceOK, nineSlice = pcall(CreateFrame, "Frame", nil, frame, "NineSliceCodeTemplate")
	if nineSliceOK and nineSlice then
		frame.nineSlice = nineSlice
		nineSlice:SetAllPoints()
		nineSlice:SetFrameLevel(frame:GetFrameLevel())
		nineSlice:Hide()
	end

	frame.navInset = frame:CreateTexture(nil, "BACKGROUND")
	frame.navInset:Hide()

	frame.detailInset = frame:CreateTexture(nil, "BACKGROUND")
	frame.detailInset:Hide()

	local title = header:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	frame.title = title
	title:SetJustifyH("LEFT")
	title:SetJustifyV("MIDDLE")
	title:SetText(C_AddOns.GetAddOnMetadata(myname, "Title"))

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	frame.close = close
	close:SetScript("OnClick", function() frame:Hide() end)

	local search = CreateFrame("EditBox", nil, header, "SearchBoxTemplate")
	frame.search = search
	search:SetHeight(22) -- same as the two buttons beside it, so they line up
	search:SetScript("OnTextChanged", function(self)
		-- the template's own handler drives its placeholder text and clear button
		SearchBoxTemplate_OnTextChanged(self)
		-- deliberately not gated on userInput: the template's clear button sets
		-- the text itself, and that must reset the list as deleting it does
		module:SetSearch(self:GetText())
	end)
	search:SetScript("OnEscapePressed", function(self)
		self:SetText("")
		self:ClearFocus()
		module:SetSearch(nil)
	end)

	local grouping = CreateFrame("DropdownButton", nil, header, "WowStyle1DropdownTemplate")
	frame.grouping = grouping
	grouping:SetupMenu(function(_, rootDescription)
		for _, value in ipairs(module.groupings) do
			rootDescription:CreateRadio(module.groupingNames[value], function(v)
				return module.db.profile.grouping == v
			end, function(v)
				module:SetGrouping(v)
				module:UpdateHeaderButtons()
			end, value)
		end
	end)
	grouping:SetSize(130, 22)

	local filter = CreateFrame("Button", nil, header, "UIPanelButtonTemplate")
	frame.filter = filter
	filter:SetSize(60, 20)
	filter:SetText(FILTER)
	filter:SetScript("OnClick", function(self)
		module:ShowFilterMenu(self)
	end)

	-- Nav

	local nav = CreateFrame("Frame", nil, frame)
	frame.nav = nav

	local scrollBox = CreateFrame("Frame", nil, nav, "WowScrollBoxList")
	nav.scrollBox = scrollBox

	local scrollBar = CreateFrame("EventFrame", nil, nav, "MinimalScrollBar")
	nav.scrollBar = scrollBar
	scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 4, -3)
	scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 4, 3)
	scrollBar:SetHideTrackIfThumbExceedsTrack(true)

	local scrollView = CreateScrollBoxListLinearView()
	nav.scrollView = scrollView
	scrollView:SetElementExtent(frame.rowHeight)  -- Fixed height for each row; required as we're not using XML.
	scrollView:SetElementInitializer("Button", function(line, data)
		module:InitNavLine(line, data)
	end)
	scrollView:SetDataProvider(self:GetDataProvider())

	ScrollUtil.InitScrollBoxWithScrollBar(scrollBox, scrollBar, scrollView)
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(scrollBox, scrollBar,
		{  -- with bar
			CreateAnchor("TOPLEFT", nav),
			CreateAnchor("BOTTOMRIGHT", nav, "BOTTOMRIGHT", -18, 0),
		},
		{ -- without bar
			CreateAnchor("TOPLEFT", nav),
			CreateAnchor("BOTTOMRIGHT", nav, "BOTTOMRIGHT", -4, 0),
		}
	)

	-- Splitter

	local splitter = CreateFrame("Frame", nil, frame)
	frame.splitter = splitter
	splitter:SetWidth(4)
	splitter.texture = splitter:CreateTexture(nil, "ARTWORK")
	splitter.texture:SetAllPoints()

	-- Detail

	local detail = CreateFrame("Frame", nil, frame)
	frame.detail = detail

	local mapPane = self:CreateMapPane(detail)
	frame.mapPane = mapPane

	local detailPane = self:CreateDetailPane(detail)
	frame.detailPane = detailPane
	detailPane:ClearAllPoints()
	detailPane:SetPoint("TOPLEFT")
	detailPane:SetPoint("TOPRIGHT")

	-- Everything that depends on a look-supplied measurement. A look sets
	-- headerHeight or rowHeight and calls this, rather than move the tree itself.
	function frame:Layout()
		local db = module.db.profile
		local insetLeft = self.insetLeft or 0
		local insetRight = self.insetRight or 0
		local insetBottom = self.insetBottom or 0

		-- The map spans the detail column, so its height is that width over the
		-- zone art's aspect. What sits above it is a fixed reservation.
		local detailWidth = WIDTH - insetLeft - insetRight - NAV_WIDTH - self.splitter:GetWidth() - 8
		local mapHeight = 0
		if db.showMap then
			mapHeight = math.max(MIN_MAP, math.min(MAX_MAP, detailWidth / self.mapPane:GetAspect()))
		end
		self:SetHeight(self.headerHeight + module.DETAIL_HEIGHT + mapHeight + insetBottom + 4)

		self.header:SetHeight(self.headerHeight)

		self.nav:ClearAllPoints()
		self.nav:SetPoint("TOPLEFT", self, "TOPLEFT", insetLeft, -self.headerHeight)
		self.nav:SetPoint("BOTTOM", self, "BOTTOM", 0, insetBottom)
		self.nav:SetWidth(NAV_WIDTH)

		self.splitter:ClearAllPoints()
		self.splitter:SetPoint("TOPLEFT", self.nav, "TOPRIGHT")
		self.splitter:SetPoint("BOTTOMLEFT", self.nav, "BOTTOMRIGHT")

		self.detail:ClearAllPoints()
		self.detail:SetPoint("TOPLEFT", self.splitter, "TOPRIGHT")
		self.detail:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -insetRight, insetBottom)

		-- Detail on top with its fixed reservation, map below. The reservation is
		-- what stops the two overlapping.
		self.detailPane:SetHeight(module.DETAIL_HEIGHT)
		self.mapPane:SetShown(db.showMap)
		self.mapPane:ClearAllPoints()
		if db.showMap then
			self.mapPane:SetPoint("TOPLEFT", self.detailPane, "BOTTOMLEFT", 4, 0)
			self.mapPane:SetPoint("TOPRIGHT", self.detailPane, "BOTTOMRIGHT", -4, 0)
			self.mapPane:SetHeight(mapHeight)
		end

		self.navInset:ClearAllPoints()
		self.navInset:SetPoint("TOPLEFT", self.nav, -2, 2)
		self.navInset:SetPoint("BOTTOMRIGHT", self.nav, 2, -2)
		self.detailInset:ClearAllPoints()
		self.detailInset:SetPoint("TOPLEFT", self.detail, -2, 2)
		self.detailInset:SetPoint("BOTTOMRIGHT", self.detail, 2, -2)

		-- Tracked, not read back off the view: a look can change it, and
		-- SetElementExtent alone does not redraw what is already on screen.
		if self.appliedRowHeight ~= self.rowHeight then
			self.appliedRowHeight = self.rowHeight
			self.nav.scrollView:SetElementExtent(self.rowHeight)
			self.nav.scrollBox:FullUpdate(true) -- retain scroll position
		end
	end

	frame:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			return module:ShowConfigMenu(self)
		end
	end)

	frame:HookScript("OnDragStop", function()
		LibStub("AceConfigRegistry-3.0"):NotifyChange("SilverDragon")
	end)

	return frame
end

module.groupings = {"zone", "achievement", "loot"}
module.groupingNames = {
	zone = ZONE,
	achievement = ACHIEVEMENTS,
	loot = LOOT,
}

function module:UpdateHeaderButtons()
	if not self.window then return end
	-- a dropdown takes its own label from the selection, once told to look again
	self.window.grouping:GenerateMenu()
end

local filterIgnoredLabels = {
	show = "Show ignored",
	hide = "Hide ignored",
	only = "Only ignored",
}

-- The per-expansion switches, the only settings here that reach outside the
-- window. The wording has to be plain about that: unticking an expansion does
-- not tidy up this list, it takes those rares away from the whole addon.
local sources = {}
local function sortedSources()
	wipe(sources)
	for source in pairs(core.datasources) do
		table.insert(sources, source)
	end
	table.sort(sources)
	return sources
end

function module:AddDatasourceMenu(rootDescription)
	local known = rootDescription:CreateButton("Sources SilverDragon knows...")
	for _, source in ipairs(sortedSources()) do
		known:CreateCheckbox(source, function(value)
			return core.db.global.datasources[value]
		end, function(value)
			core.db.global.datasources[value] = not core.db.global.datasources[value]
			core:BuildLookupTables()
			return MenuResponse.Refresh
		end, source):SetTitleAndTextTooltip(nil, "If you disable this, SilverDragon will just not know about these mobs. They'll still be announced when you mouse over them, like any unknown rare.")
	end

	local silenced = rootDescription:CreateButton("Sources to ignore...")
	for _, source in ipairs(sortedSources()) do
		silenced:CreateCheckbox(source, function(value)
			return core.db.global.ignore_datasource[value]
		end, function(value)
			core.db.global.ignore_datasource[value] = not core.db.global.ignore_datasource[value] or nil
			core:BuildLookupTables()
			return MenuResponse.Refresh
		end, source):SetTitleAndTextTooltip(nil, "Ignore every mob provided by this module. This will make them all not be announced, regardless of any other settings.")
	end
end
function module:ShowFilterMenu(owner)
	if not (_G.MenuUtil and MenuUtil.CreateContextMenu) then return end
	MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
		rootDescription:SetTag("MENU_SILVERDRAGON_BROWSER_FILTER")
		rootDescription:CreateTitle(FILTER)
		rootDescription:CreateCheckbox("Group by expansion", function()
			return module.db.profile.groupBySource
		end, function()
			module.db.profile.groupBySource = not module.db.profile.groupBySource
			module:Refresh()
			return MenuResponse.Refresh
		end)
		rootDescription:CreateDivider()
		for _, value in ipairs({"show", "hide", "only"}) do
			rootDescription:CreateRadio(filterIgnoredLabels[value], function(v)
				return module.db.profile.filterIgnored == v
			end, function(v)
				module.db.profile.filterIgnored = v
				module:Refresh()
				return MenuResponse.Refresh
			end, value)
		end
		rootDescription:CreateDivider()
		rootDescription:CreateCheckbox("Only mobs I've added", function()
			return module.db.profile.filterWatched
		end, function()
			module.db.profile.filterWatched = not module.db.profile.filterWatched
			module:Refresh()
			return MenuResponse.Refresh
		end)
		rootDescription:CreateDivider()
		module:AddDatasourceMenu(rootDescription)

		rootDescription:CreateDivider()
		rootDescription:CreateButton("Edit custom mobs...", function()
			local config = core:GetModule("Config", true)
			if not config then return end
			config:ShowConfig()
			LibStub("AceConfigDialog-3.0"):SelectGroup("SilverDragon", "mobs", "custom")
			return MenuResponse.CloseAll
		end)
	end)
end

function module:ShowConfigMenu(owner)
	if not (_G.MenuUtil and MenuUtil.CreateContextMenu) then
		local config = core:GetModule("Config", true)
		if config then config:ShowConfig() end
		return
	end
	MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
		rootDescription:SetTag("MENU_SILVERDRAGON_BROWSER_CONTEXT")
		rootDescription:CreateTitle("Rare browser")
		local styles = rootDescription:CreateButton("Style")
		for look in pairs(module.Looks) do
			styles:CreateRadio(look:gsub("_", ": "), function(value)
				return module.db.profile.style == value
			end, function(value)
				module:SetLook(value)
				return MenuResponse.Close
			end, look)
		end
		rootDescription:CreateCheckbox("Show the map", function()
			return module.db.profile.showMap
		end, function()
			module.db.profile.showMap = not module.db.profile.showMap
			module.window:Layout()
			return MenuResponse.Refresh
		end)
		rootDescription:CreateCheckbox("Show the model", function()
			return module.db.profile.model
		end, function()
			module.db.profile.model = not module.db.profile.model
			module.window.detailPane:SetMob(module.selectedMob)
			return MenuResponse.Refresh
		end)
		rootDescription:CreateCheckbox("Show other rares in the zone", function()
			return module.db.profile.mapShowAll
		end, function()
			module.db.profile.mapShowAll = not module.db.profile.mapShowAll
			module:RefreshMap()
			return MenuResponse.Refresh
		end)
		rootDescription:CreateDivider()
		local config = core:GetModule("Config", true)
		if config then
			rootDescription:CreateButton(OPTIONS, function()
				config:ShowConfig()
				LibStub("AceConfigDialog-3.0"):SelectGroup("SilverDragon", 'browser')
			end)
		end
		rootDescription:CreateButton(CLOSE, function()
			module.window:Hide()
			return MenuResponse.CloseAll
		end)
	end)
end
