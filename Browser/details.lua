local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Browser")
local Debug = core.Debug

--[[
The right-hand pane: everything known about one rare. Nothing here works out an
answer for itself -- the loot summary, the completion lines and the condition
summaries all belong to code the map pins and the broker tooltip already share.

The pane is a fixed height, so the map below it always starts in the same place.
The two parts that can run long, the notes and the loot, scroll instead.
]]

local MODEL_SIZE = 120
local PADDING = 10
local ACTIONS_HEIGHT = 52
local LABEL_HEIGHT = 16
local SCROLL_INSET = 4

-- Two rows and a heading: a row of the mob's own loot, the "Shared loot"
-- heading, and the first row of that. Asked of loot.lua, so it keeps up if those
-- metrics change.
local LOOT_HEIGHT = ns.Loot.Window.HeightForRows(2, 1) + (2 * SCROLL_INSET)

-- Two lines, and it scrolls, so a long note is still reachable
local NOTES_HEIGHT = 30

-- What the window has to reserve for this pane, so the map can sit below it
-- without ever landing on the loot.
module.DETAIL_HEIGHT = PADDING + MODEL_SIZE + PADDING + NOTES_HEIGHT + PADDING
	+ ACTIONS_HEIGHT + PADDING + LABEL_HEIGHT + LOOT_HEIGHT + PADDING

local DetailMixin = {}

-- A plain ScrollFrame, not WowScrollBox: that errors on load unless its scroll
-- target already exists, which XML can arrange and CreateFrame cannot. There is
-- no scroll bar, so the arrow in the corner is what shows there is more.
local function updateScrollHint(scroll)
	local overflow = scroll.canvas:GetHeight() - scroll:GetHeight()
	scroll.more:SetShown(overflow > 1 and scroll:GetVerticalScroll() < (overflow - 1))
end

local function createScrollPane(parent)
	local scroll = CreateFrame("ScrollFrame", nil, parent)
	scroll:EnableMouseWheel(true)

	scroll.canvas = CreateFrame("Frame", nil, scroll)
	scroll.canvas:SetSize(1, 1)
	scroll:SetScrollChild(scroll.canvas)

	scroll.more = parent:CreateTexture(nil, "OVERLAY")
	scroll.more:SetSize(14, 14)
	scroll.more:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", 2, -2)
	-- forwardarrow points right; a quarter turn clockwise points it down
	scroll.more:SetAtlas("common-icon-forwardarrow")
	scroll.more:SetRotation(-math.pi / 2)
	scroll.more:SetAlpha(0.6)
	scroll.more:Hide()

	scroll:SetScript("OnMouseWheel", function(frame, delta)
		local limit = math.max(0, frame.canvas:GetHeight() - frame:GetHeight())
		frame:SetVerticalScroll(math.min(limit, math.max(0, frame:GetVerticalScroll() - (delta * 20))))
		updateScrollHint(frame)
	end)
	-- the arrow hangs off the parent so the scroll frame can't clip it, which
	-- also means it doesn't follow the scroll frame's own shown state
	scroll:SetScript("OnHide", function(frame) frame.more:Hide() end)
	scroll:SetScript("OnShow", updateScrollHint)

	function scroll:SetContentHeight(height)
		self.canvas:SetSize(math.max(1, self:GetWidth()), math.max(1, height or 1))
		updateScrollHint(self)
	end

	function scroll:Reset()
		self:SetVerticalScroll(0)
		self.canvas:SetHeight(1)
		self.more:Hide()
	end

	return scroll
end

function module:CreateDetailPane(parent)
	local pane = CreateFrame("Frame", nil, parent)
	Mixin(pane, DetailMixin)
	pane:SetAllPoints()
	pane:Build()
	return pane
end

function DetailMixin:Build()
	-- Model, with the marble backing the click-target popup uses
	self.modelbg = self:CreateTexture(nil, "BORDER")
	self.modelbg:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
	self.modelbg:SetSize(MODEL_SIZE, MODEL_SIZE)
	self.modelbg:SetPoint("TOPLEFT", PADDING, -PADDING)

	self.model = CreateFrame("PlayerModel", nil, self)
	self.model:SetAllPoints(self.modelbg)
	self.model:EnableMouse(true)

	self.modelFallback = self.model:CreateTexture(nil, "ARTWORK")
	self.modelFallback:SetPoint("CENTER")
	self.modelFallback:SetSize(64, 64)
	self.modelFallback:Hide()

	-- drag to turn it. The click-target popup cannot do this: its frame is secure.
	self.model:SetScript("OnMouseDown", function(model)
		model.rotating = GetCursorPosition()
		model.startFacing = model.facing or 0
	end)
	self.model:SetScript("OnMouseUp", function(model)
		model.rotating = nil
	end)
	self.model:SetScript("OnUpdate", function(model, elapsed)
		if model.rotating then
			local x = GetCursorPosition()
			model.facing = model.startFacing + ((x - model.rotating) / 60)
			model:SetFacing(model.facing)
		end
		module:PollModel(model, elapsed)
	end)

	-- Meta block, beside the model. Anchors are set by Arrange, which knows
	-- whether the model's there to sit next to.
	self.name = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	self.name:SetJustifyH("LEFT")
	self.name:SetWordWrap(false)

	self.meta = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	self.meta:SetPoint("TOPLEFT", self.name, "BOTTOMLEFT", 0, -6)
	self.meta:SetPoint("RIGHT", -PADDING, 0)
	self.meta:SetJustifyH("LEFT")
	self.meta:SetJustifyV("TOP")
	self.meta:SetSpacing(2)

	self.notesScroll = createScrollPane(self)
	self.notesScroll:SetPoint("TOPLEFT", self, "TOPLEFT", PADDING, -(PADDING + MODEL_SIZE + PADDING))
	self.notesScroll:SetPoint("RIGHT", -PADDING, 0)
	self.notesScroll:SetHeight(NOTES_HEIGHT)

	self.notes = self.notesScroll.canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	self.notes:SetPoint("TOPLEFT")
	self.notes:SetJustifyH("LEFT")
	self.notes:SetJustifyV("TOP")
	self.notes:SetWordWrap(true)
	self.notes:SetSpacing(2)

	-- after the fontstring exists, since that's what it measures
	self.notesScroll:SetScript("OnSizeChanged", function() self:FitNotes() end)

	self:BuildActions()

	self.lootAnchor = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	self.lootAnchor:SetPoint("TOPLEFT", self.actions, "BOTTOMLEFT", 0, -PADDING)
	self.lootAnchor:SetHeight(LABEL_HEIGHT)
	self.lootAnchor:SetJustifyH("LEFT")
	self.lootAnchor:SetText(LOOT)

	self.lootBG = CreateFrame("Frame", nil, self, "BackdropTemplate")
	self.lootBG:SetPoint("TOPLEFT", self.lootAnchor, "BOTTOMLEFT", 0, -2)
	self.lootBG:SetPoint("RIGHT", -PADDING, 0)
	self.lootBG:SetHeight(LOOT_HEIGHT)
	self.lootBG:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8X8]],
		edgeFile = [[Interface\Buttons\WHITE8X8]],
		edgeSize = 1,
	})
	self.lootBG:SetBackdropColor(0, 0, 0, 0.3)
	self.lootBG:SetBackdropBorderColor(1, 1, 1, 0.08)
	-- a look's insets change how wide this is, and with it how many fit across
	self.lootBG:SetScript("OnSizeChanged", function() self:FitLoot() end)

	self.lootScroll = createScrollPane(self.lootBG)
	self.lootScroll:SetPoint("TOPLEFT", SCROLL_INSET, -SCROLL_INSET)
	self.lootScroll:SetPoint("BOTTOMRIGHT", -SCROLL_INSET, SCROLL_INSET)

	self.lootEmpty = self.lootBG:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	self.lootEmpty:SetPoint("CENTER")
	self.lootEmpty:SetText("Nothing known")

	self.empty = self:CreateFontString(nil, "ARTWORK", "GameFontDisableLarge")
	self.empty:SetPoint("CENTER")
	self.empty:SetText("Pick a rare from the list")

	self:SetScript("OnHide", function(pane) pane:ReleaseLoot() end)
	self:SetMob(nil)
end

-- The model is optional. With it off, the text starts at the pane edge instead.
function DetailMixin:Arrange()
	local showModel = module.db.profile.model and self.mobid ~= nil
	self.modelbg:SetShown(showModel)
	self.model:SetShown(showModel)

	self.name:ClearAllPoints()
	if showModel then
		self.name:SetPoint("TOPLEFT", self.modelbg, "TOPRIGHT", PADDING, 0)
	else
		self.name:SetPoint("TOPLEFT", PADDING, -PADDING)
	end
	self.name:SetPoint("RIGHT", -PADDING, 0)
end

-- Actions

local function checkbox(parent, label, tooltip)
	local check = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	check:SetSize(20, 20)
	-- our own label, since where the template keeps its own has moved about
	check.label = check:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	check.label:SetPoint("LEFT", check, "RIGHT", 2, 0)
	check.label:SetText(label)
	check.tooltipText = tooltip
	check:SetScript("OnEnter", function(self)
		if not self.tooltipText then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	check:SetScript("OnLeave", GameTooltip_Hide)
	return check
end

function DetailMixin:BuildActions()
	local actions = CreateFrame("Frame", nil, self)
	self.actions = actions
	actions:SetPoint("TOPLEFT", self.notesScroll, "BOTTOMLEFT", 0, -PADDING)
	actions:SetPoint("RIGHT", -PADDING, 0)
	actions:SetHeight(52)

	self.ignore = checkbox(actions, IGNORE, "Never tell me about this one again.")
	self.ignore:SetPoint("TOPLEFT")
	self.ignore:SetScript("OnClick", function(check)
		if self.mobid then core:SetIgnore(self.mobid, check:GetChecked()) end
	end)

	-- No per-zone "watch here". In here a rare is always shown under a zone it is
	-- already known for, so adding it as a custom mob there would do nothing.
	-- The Custom tab is where a mob goes somewhere it is not expected.
	self.watchEverywhere = checkbox(actions, "Watch everywhere", "Keep scanning for this rare in every zone, not just where it's expected.")
	self.watchEverywhere:SetPoint("LEFT", self.ignore.label, "RIGHT", PADDING, 0)
	self.watchEverywhere:SetScript("OnClick", function(check)
		if self.mobid then core:SetCustom('any', self.mobid, check:GetChecked()) end
	end)

	local function actionButton(label, width, onClick)
		local button = CreateFrame("Button", nil, actions, "UIPanelButtonTemplate")
		button:SetSize(width, 22)
		button:SetText(label)
		button:SetScript("OnClick", onClick)
		return button
	end

	self.link = actionButton(TRADESKILL_POST, 90, function()
		if not self.mobid then return end
		core:GetModule("ClickTarget"):SendLinkToMob(self.mobid, self:Where())
	end)
	self.link:SetPoint("BOTTOMLEFT")

	self.showOnMap = actionButton("Show on map", 110, function()
		local uiMapID = self:Where()
		if not uiMapID then return end
		if WorldMapFrame.SetMapID then
			if not WorldMapFrame:IsShown() then ToggleWorldMap() end
			WorldMapFrame:SetMapID(uiMapID)
		else
			ToggleWorldMap()
		end
		core.events:Fire("BrokerMobClick", self.mobid)
	end)
	self.showOnMap:SetPoint("LEFT", self.link, "RIGHT", 4, 0)

	if _G.MAP_PIN then
		self.waypoint = actionButton(MAP_PIN, 90, function()
			local uiMapID, x, y = self:Where()
			if uiMapID and x and y then
				core:GetModule("TomTom"):PointTo(self.mobid, uiMapID, x, y, 0, true)
			end
		end)
		self.waypoint:SetPoint("LEFT", self.showOnMap, "RIGHT", 4, 0)
	end
end

-- Where to point at for this rare: the zone it was picked in, or the nearest of
-- its locations.
function DetailMixin:Where()
	if not self.mobid then return end
	local data = ns.mobdb[self.mobid]
	local zone = module.selectedZone
	-- a zone can be listed with no coordinates, which is not a place to point at
	local coords = zone and data and data.locations and data.locations[zone]
	if coords and coords[1] then
		local x, y = core:GetXY(coords[1])
		return zone, x, y
	end
	return core:GetClosestLocationForMob(self.mobid)
end

-- Separate from SetMob so it can be redone when a late loot fetch changes the
-- answer. The row this was picked from has usually worked the state out already.
function DetailMixin:RefreshName()
	local id = self.mobid
	if not id then return end
	local color = ns.MobStateColor[module:MobStateFor(id)]
	self.name:SetText(core:GetMobLabel(id))
	self.name:SetTextColor(color and color[1] or 1, color and color[2] or 1, color and color[3] or 1)
end

function DetailMixin:RefreshActions()
	local id = self.mobid
	self.ignore:SetChecked(id and core.db.global.ignore[id] or false)
	self.watchEverywhere:SetChecked((id and core.db.global.custom.any[id]) or false)

	local where = self:Where()
	self.link:SetEnabled(where ~= nil)
	self.showOnMap:SetEnabled(where ~= nil)
	if self.waypoint then
		self.waypoint:SetEnabled(core:GetModule("TomTom"):CanPointTo(where))
	end
end

-- Models sometimes don't load the first time they're asked for, and asking again
-- fixes it. Inherited from the click-target popup, where the note dates it to
-- 70100 -- worth retesting, but it costs nothing to keep until then.
function module:PollModel(model, elapsed)
	if not model.mobid then return end
	model.elapsed = (model.elapsed or 0) + elapsed
	if model.elapsed < 0.5 then return end
	model.elapsed = 0
	if not model:GetModelFileID() and not model:GetParent().modelFallback:IsShown() then
		Debug("Browser: poll for model reload", model.mobid)
		model:GetParent():SetModel(model.mobid)
	end
end

function DetailMixin:SetModel(id)
	local model = self.model
	-- a fresh creature inherits whatever the last one was left at otherwise
	model:ClearModel()
	model:SetModelScale(1)
	model:SetModelAlpha(1)
	model:SetPosition(0, 0, 0)
	model:SetFacing(0)
	model.facing = 0
	model.mobid = id
	self.modelFallback:Hide()

	self:Arrange()
	if not (id and module.db.profile.model) then return end

	model:SetCreature(id)
	model:SetPortraitZoom(0)
	if not model:GetModelFileID() then
		self.modelFallback:SetAtlas("sniper_shot-icon")
		self.modelFallback:Show()
	end
end

local function locationLines(id)
	local data = ns.mobdb[id]
	if not (data and data.locations) then return end
	local lines = {}
	for uiMapID, coords in pairs(data.locations) do
		local where = core.zone_names[uiMapID] or ("map" .. uiMapID)
		if #coords == 0 then
			-- plenty of mobs are known to be in a zone without anyone having
			-- written down where
			table.insert(lines, where)
		elseif #coords == 1 then
			local x, y = core:GetXY(coords[1])
			table.insert(lines, ("%s |cffaaaaaa%.1f, %.1f|r"):format(where, x * 100, y * 100))
		else
			table.insert(lines, ("%s |cffaaaaaa(%d)|r"):format(where, #coords))
		end
	end
	table.sort(lines)
	return lines
end

function DetailMixin:SetMob(id)
	self.mobid = id
	self:ReleaseLoot()

	local data = id and ns.mobdb[id]
	self.empty:SetShown(not data)
	for _, region in ipairs({self.name, self.meta, self.notesScroll, self.lootAnchor, self.actions, self.lootBG}) do
		region:SetShown(data ~= nil)
	end
	self:SetModel(data and id or nil)
	if not data then return end
	self:RefreshActions()

	self:RefreshName()

	local meta = {}
	table.insert(meta, ("|cffaaaaaaFrom|r %s  |cffaaaaaaID|r %d"):format(data.source or UNKNOWN, id))
	table.insert(meta, ("|cffaaaaaaLast seen|r %s  |cffaaaaaaTimes|r %d"):format(
		core:FormatLastSeen(core.db.global.mob_seen[id]), core.db.global.mob_count[id] or 0))
	local locations = locationLines(id)
	if locations then
		table.insert(meta, "|cffaaaaaaFound in|r " .. table.concat(locations, ", "))
	end
	-- straight off the iterator rather than through UpdateTooltipWithCompletion,
	-- which can only write into a tooltip
	for _, _, name, complete in ns:AchievementMobStatus(id) do
		table.insert(meta, ("|cff%s%s|r"):format(complete and "33ff33" or "ff3333", name))
	end
	if data.quest then
		local complete = ns.allQuestsComplete(data.quest)
		table.insert(meta, ("|cffaaaaaaQuest|r |cff%s%s|r"):format(
			complete and "33ff33" or "ff3333", complete and COMPLETE or INCOMPLETE))
	end
	for _, field in ipairs({"requires", "active"}) do
		if data[field] then
			local met = core.conditions.check(data[field])
			table.insert(meta, ("|cff%s%s|r"):format(
				met and "33ff33" or "ff3333",
				core:RenderString(core.conditions.summarize(data[field]), data)
			))
		end
	end
	self.meta:SetText(table.concat(meta, "\n"))

	if data.notes then
		self.notes:SetText(core:RenderString(data.notes, data))
	else
		self.notes:SetText("")
	end
	self.notesScroll:SetVerticalScroll(0)
	self:FitNotes()

	self:SetLoot(id)
end

function DetailMixin:SetLoot(id)
	-- Merged rather than the usual second window for shared loot: this one has a
	-- box of its own to sit in, and a second window below it lands on the map.
	-- The merge keeps its heading, so the two are still told apart. This forces
	-- all loot to be visible, regardless of the character loot setting.
	local window = ns.Loot.Window.ShowForMob(id, false, false, true, nil, true, true)
	self.lootEmpty:SetShown(not window)
	if not window then
		self.lootScroll:Reset()
		return
	end
	-- ours to keep until we say otherwise: right-click must not dismiss it, and
	-- it has to sit flush rather than inside a tooltip border
	window.embedded = true
	window:SetParent(self.lootScroll.canvas)
	window:SetBackdrop(nil)
	window:SetAutoHideDelay(0)
	window:ClearAllPoints()
	window:SetPoint("TOPLEFT")
	self.lootwindow = window
	self.lootScroll:SetVerticalScroll(0)
	self:FitLoot()
end

-- The default six across is sized for a window floating beside a tooltip; here
-- there's a whole panel to fill, so wrapping at six leaves the line half empty.
function DetailMixin:FitLoot()
	local window = self.lootwindow
	if not (window and window.SetItemsPerRow) then return end
	local width = self.lootScroll:GetWidth()
	if not width or width < 1 then return end
	window:SetItemsPerRow(ns.Loot.Window.ColumnsForWidth(width))
	self.lootScroll:SetContentHeight(window:GetHeight())
end

function DetailMixin:FitNotes()
	local width = self.notesScroll:GetWidth()
	if not width or width < 1 then return end
	self.notes:SetWidth(width)
	self.notesScroll:SetContentHeight(self.notes:GetStringHeight())
end

function DetailMixin:ReleaseLoot()
	self.lootScroll:Reset()
	if not self.lootwindow then return end
	ns.Loot.Window.Release(self.lootwindow)
	self.lootwindow = nil
end

function module:SetDetailMob(id)
	if not (self.window and self.window.detailPane) then return end
	self.window.detailPane:SetMob(id)
end
