local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local Debug = core.Debug
local DebugF = core.DebugF

local function safeunpack(table_or_value)
	if ns.xtype(table_or_value) == "table" then
		return unpack(table_or_value)
	end
	return table_or_value
end
local function all(test, ...)
	for i=1,select("#", ...) do
		if not test((select(i, ...))) then
			return false
		end
	end
	return true
end
local function any(test, ...)
	for i=1,select("#", ...) do
		if test((select(i, ...))) then
			return true
		end
	end
	return false
end

local ATLAS_CHECK, ATLAS_CROSS = "common-icon-checkmark", "common-icon-redx"

local COSMETIC_COLOR = CreateColor(1, 0.5, 1)

local function PlayerHasTransmogByItemInfo(itemLinkOrID)
	-- Cata classic is specifically missing C_TransmogCollection.PlayerHasTransmogByItemInfo
	if C_TransmogCollection.PlayerHasTransmogByItemInfo then
		return C_TransmogCollection.PlayerHasTransmogByItemInfo(itemLinkOrID)
	end
	local itemID = C_Item.GetItemInfoInstant(itemLinkOrID)
	if itemID then
		-- this is a bit worse, because of items with varying appearances based on the link-details
		-- but because this path should only be hit in classic, we should be fine
		return C_TransmogCollection.PlayerHasTransmog(itemID)
	end
end

-- we need non-localized covenant names for atlases
-- can't use the texturekit value from covenant data, since the atlas I want doesn't conform to it
local covenants = {
	[Enum.CovenantType.Kyrian] = "Kyrian",
	[Enum.CovenantType.Necrolord] = "Necrolords",
	[Enum.CovenantType.NightFae] = "NightFae",
	[Enum.CovenantType.Venthyr] = "Venthyr",
}

local itemRestricted = function(item)
	return not item:Available()
end
local itemIsKnowable = function(item)
	return item:Obtained() ~= nil
end
local itemIsKnown = function(item)
	return item:Obtained()
end
local itemBindOnEquip = function(item)
	local bindType = select(14, C_Item.GetItemInfo(item.id))
	if bindType == nil then
		-- The item isn't cached yet, and asking has just started fetching it. Say
		-- yes for now: this decides whether a mount you already own is still worth
		-- announcing because it sells, and a rare going unmentioned for the first
		-- minute after a login is a worse trade than an extra mention.
		return true
	end
	return bindType == Enum.ItemBind.OnEquip or bindType == Enum.ItemBind.OnUse
end

ns.Loot = {}
-- _G.SDLoot = ns.Loot

function ns.Loot.GetLootTable(id, treasure, shared)
	if not id then return end
	local data = ns[treasure and "vignetteTreasureLookup" or "mobdb"][id]
	if not data then return end
	if shared then
		return data.loot_shared
	end
	return data.loot
end

local function suitable(item)
	if not core.db.profile.charloot then
		return true
	end
	return item:MightDrop()
end
function ns.Loot.HasLoot(id, isTreasure, shared)
	local loot = ns.Loot.GetLootTable(id, isTreasure, shared)
	if not loot or #loot == 0 then
		return false, 0, 0
	end
	local lootCount = 0
	for _, item in ipairs(loot) do
		if suitable(item) then
			lootCount = lootCount + 1
		end
	end
	return true, #loot, lootCount
end
function ns.Loot.OnceAllLootLoaded(id, isTreasure, callback)
	local loot = ns.Loot.GetLootTable(id, isTreasure)
	if not loot or #loot == 0 then return callback(loot) end
	local continuableLoot = {}
	for _, item in ipairs(loot) do
		if ns.IsA(item, ns.rewards.Item) then
			-- Todo: upstream this?
			table.insert(continuableLoot, Item:CreateFromItemID(item.id))
		end
	end
	if #continuableLoot == 0 then return callback(loot) end
	local continuableContainer = ContinuableContainer:Create()
	-- AddContinuables isn't available in classic, so we need to do this:
	for _, continuable in pairs(continuableLoot) do
		continuableContainer:AddContinuable(continuable)
	end
	continuableContainer:ContinueOnLoad(function() callback(loot) end)
end
do
	local function make_iter(test)
		return function(t, prestate)
			local state, item = next(t, prestate)
			while state do
				if test(item) and suitable(item) then
					return state, item
				end
				state, item = next(t, state)
			end
		end
	end
	local function make_class_iter(class) return make_iter(function(item) return ns.IsA(item, class) end) end
	local mount_iter = make_class_iter(ns.rewards.Mount)
	local pet_iter = make_class_iter(ns.rewards.Pet)
	local toy_iter = make_class_iter(ns.rewards.Toy)
	local handledClasses = {[ns.rewards.Mount]=true, [ns.rewards.Pet]=true, [ns.rewards.Toy]=true}
	local regular_iter = make_iter(function(item)
		return not handledClasses[item:getClass()]
	end)
	local quest_iter = make_iter(function(item) return item.quest end)

	local noloot = {}
	function ns.Loot.IterMounts(id, ...)
		return mount_iter, ns.Loot.GetLootTable(id, ...) or noloot, nil
	end
	function ns.Loot.IterPets(id, ...)
		return pet_iter, ns.Loot.GetLootTable(id, ...) or noloot, nil
	end
	function ns.Loot.IterToys(id, ...)
		return toy_iter, ns.Loot.GetLootTable(id, ...) or noloot, nil
	end
	function ns.Loot.IterQuests(id, ...)
		return quest_iter, ns.Loot.GetLootTable(id, ...) or noloot, nil
	end
	function ns.Loot.IterRegularLoot(id, ...)
		-- this includes any transmog loot
		return regular_iter, ns.Loot.GetLootTable(id, ...) or noloot, nil
	end
end
local function hasMaker(iterator)
	return function(id, only_knowable, only_boe, ...)
		if not ns.Loot.GetLootTable(id, ...) then return false end
		for _, item in iterator(id, ...) do
			if (not only_knowable) or (item:Available() and ((not only_boe) or itemBindOnEquip(item))) then
				return true
			end
		end
		return false
	end
end
ns.Loot.HasMounts = hasMaker(ns.Loot.IterMounts)
ns.Loot.HasToys = hasMaker(ns.Loot.IterToys)
ns.Loot.HasPets = hasMaker(ns.Loot.IterPets)
function ns.Loot.HasInterestingMounts(id, ...)
	-- This comes up a lot: mounts that you don't know, or which are BoE and so can be sold
	return ns.Loot.Status.Mount(id, ...) == false
		or (core.db.profile.boeloot and ns.Loot.HasMounts(id, true, true, ...) or false)
end
function ns.Loot.HasKnowableLoot(id, ...)
	local loot = ns.Loot.GetLootTable(id, ...)
	if not loot then return false end
	return any(itemIsKnowable, unpack(loot))
end
function ns.Loot.HasRegularLoot(id, ...)
	if not ns.Loot.GetLootTable(id, ...) then return false end
	for _ in ns.Loot.IterRegularLoot(id, ...) do
		return true
	end
	return false
end

function ns.Loot.Cache(id, ...)
	local loot = ns.Loot.GetLootTable(id, ...)
	if loot then
		ns.Loot.CacheLootTable(loot)
	end
end
function ns.Loot.CacheLootTable(loot)
	for _, item in ipairs(loot) do
		item:Cache()
	end
end

ns.Loot.Status = setmetatable({}, {__call = function(_, id, include_transmog, ...)
	-- returns nil if there's no knowable loot
	-- returns true if all knowable loot is collected
	-- returns false if not all knowable loot is collected
	-- if knowable loot, also returns the status for mount,toy,pet after the first return
	-- knowable loot that's restricted from the current character will still return true if collected, but nil if not
	if not ns.Loot.GetLootTable(id, ...) then
		return
	end
	ns.ClearRunCaches()
	local mount = ns.Loot.Status.Mount(id, ...)
	local toy = ns.Loot.Status.Toy(id, ...)
	local pet = ns.Loot.Status.Pet(id, ...)
	local quest = ns.Loot.Status.Quest(id, ...)
	local transmog
	if include_transmog then transmog = ns.Loot.Status.Transmog(id, ...) end
	if (mount == nil and toy == nil and pet == nil and quest == nil and transmog == nil) then
		return nil
	end
	return (mount ~= false and toy ~= false and pet ~= false and quest ~= false and transmog ~= false), mount, toy, pet, quest, transmog
end})

local function statusChecker(iterator, test)
	return function(id, ...)
		if not ns.Loot.GetLootTable(id, ...) then return end
		local ret = nil
		for _, item in iterator(id, ...) do
			local known = test(item)
			if known then
				ret = true
			elseif known == false then
				return false
			end
		end
		return ret
	end
end
-- these all have mobid as the argument and return true/false/nil for known/unknown/none
-- Obtained first: you still own it on a character that can't loot it. Restricted
-- and unowned answers nil, not false -- you're not missing what you can't get.
local function obtained(item)
	local known = item:Obtained(true)
	if known then return true end
	if not item:Available() then return nil end
	return known
end

ns.Loot.Status.Toy = statusChecker(ns.Loot.IterToys, obtained)
ns.Loot.Status.Mount = statusChecker(ns.Loot.IterMounts, obtained)
ns.Loot.Status.Pet = statusChecker(ns.Loot.IterPets, obtained)
ns.Loot.Status.Quest = statusChecker(ns.Loot.IterQuests, function(item)
	return C_QuestLog.IsQuestFlaggedCompleted(item.quest) or C_QuestLog.IsOnQuest(item.quest)
end)
ns.Loot.Status.Transmog = statusChecker(ns.Loot.IterRegularLoot, obtained)

local function get_tooltip(tooltip, i)
	if i > 1 then
		local comparison = _G['ShoppingTooltip'..(i-1)]
		if not comparison then return end
		comparison:SetOwner(tooltip, "ANCHOR_NONE")
		comparison:ClearAllPoints()

		local anchor = tooltip:GetOwner()

		local side
		local topPos = anchor:GetTop() or 0
		local bottomPos = anchor:GetBottom() or 0
		local bottomDist = GetScreenHeight() - bottomPos
		if bottomDist > topPos then
			side = "top"
		else
			side = "bottom"
		end
		if side == "top" then
			comparison:SetPoint("BOTTOMLEFT", tooltip, "TOPLEFT", 0, 10)
		else
			comparison:SetPoint("TOPLEFT", tooltip, "BOTTOMLEFT", 0, -10)
		end

		return comparison
	end
	return tooltip
end

local SHARED_HEADER = "Shared loot"

ns.Loot.Details = {}

local showRestrictions = function(tooltip, item)
	if not ns.IsA(item, ns.rewards.Reward) then return end
	if item.requires then
		local active = core.conditions.check(item.requires)
		tooltip:AddLine(
			core:RenderString(core.conditions.summarize(item.requires)),
			(active and GREEN_FONT_COLOR or RED_FONT_COLOR):GetRGB()
		)
	end
	tooltip:Show()
end
function ns.Loot.Details.UpdateTooltip(tooltip, id, only, ...)
	if not ns.Loot.GetLootTable(id, ...) then return end

	-- ... is the (treasure, shared) tail that GetLootTable / the iterators take,
	-- so it has to be pushed past these functions' own leading arguments
	local toy = (not only or only == "toy") and ns.Loot.HasToys(id, nil, nil, ...)
	local mount = (not only or only == "mount") and ns.Loot.HasMounts(id, nil, nil, ...)
	local pet = (not only or only == "pet") and ns.Loot.HasPets(id, nil, nil, ...)
	local regular = (not only or only == "regular") and ns.Loot.HasRegularLoot(id, ...)

	if mount then
		for i, item in ns.Loot.IterMounts(id, ...) do
			item:SetTooltip(tooltip)
			showRestrictions(tooltip, item)
		end
	end
	if pet then
		if mount then
			tooltip:AddLine("---")
		end
		for i, item in ns.Loot.IterPets(id, ...) do
			item:SetTooltip(tooltip)
			showRestrictions(tooltip, item)
		end
	end
	local n = (pet or mount) and 2 or 1
	local itemtip
	if toy then
		for i, item in ns.Loot.IterToys(id, ...) do
			itemtip = get_tooltip(itemtip or tooltip, n)
			if not itemtip then return end -- out of comparisons
			item:SetTooltip(itemtip)
			showRestrictions(itemtip, item)
			n = n + 1
		end
	end
	if regular then
		for i, item in ns.Loot.IterRegularLoot(id, ...) do
			itemtip = get_tooltip(itemtip or tooltip, n)
			if not itemtip then return end -- out of comparisons
			item:SetTooltip(itemtip)
			showRestrictions(itemtip, item)
			n = n + 1
		end
	end
end

ns.Loot.Summary = {}
do
	local function shouldShow(item, only_knowable)
		return (not only_knowable or item:Obtained() ~= nil)
			and (not core.db.profile.charloot or IsShiftKeyDown() or item:MightDrop())
	end
	function ns.Loot.Summary.UpdateTooltip(tooltip, id, only_knowable, ...)
		local hidden

		local loot = ns.Loot.GetLootTable(id, ...)
		if loot then
			for _, item in ipairs(loot) do
				if shouldShow(item, only_knowable) then
					item:AddToTooltip(tooltip)
				else
					hidden = true
				end
			end
		end

		local sharedLoot = ns.Loot.GetLootTable(id, ..., true)
		if sharedLoot then
			local sharedShown = false
			for _, item in ipairs(sharedLoot) do
				if shouldShow(item, only_knowable) then
					if not sharedShown then
						tooltip:AddLine(SHARED_HEADER, NORMAL_FONT_COLOR:GetRGB())
						sharedShown = true
					end
					item:AddToTooltip(tooltip)
				else
					hidden = true
				end
			end
		end

		if hidden then
			tooltip:AddLine("Items for other characters hidden", BLUE_FONT_COLOR:GetRGB())
		end
	end
end

do
	local ITEMS_PER_ROW = 6
	local BORDER_WIDTH = 8
	local ITEM_WIDTH = 37
	local ITEM_HEIGHT = 37
	local ITEM_XOFFSET = 4
	local ITEM_YOFFSET = -5
	local TITLE_SPACING = 16

	local function isMouseOver(...)
		for i=1, select("#", ...) do
			local frame = select(i, ...)
			if not frame then
				break
			end
			if frame.IsMouseOver then
				if frame:IsMouseOver() and frame:IsVisible() then
					return true
				end
			elseif isMouseOver(unpack(frame)) then
				-- this was a table, not an actual frame
				return true
			end
		end
		return false
	end

	local function timer_onupdate(self, elapsed)
		self.checkThreshold = self.checkThreshold + elapsed
		if self.checkThreshold > 0.1 then
			if isMouseOver(self.watch, self.additional) then
				self.timeOffFrame = 0
			else
				self.timeOffFrame = self.timeOffFrame + self.checkThreshold
				if self.timeOffFrame > self.allowedTimeOffFrame then
					self.timeOffFrame = 0
					if not self.callback or self.callback(self.watch) ~= false then
						ns.Loot.Window.Release(self.watch)
					end
				end
			end
			self.checkThreshold = 0
		end
	end

	-- from ItemButtonTemplate.lua
	local function GetItemButtonIconTexture(button)
		return button.Icon or button.icon or _G[button:GetName().."IconTexture"]
	end

	local windowPool = CreateFramePool("Frame", UIParent, "BackdropTemplate", function(framePool, frame)
		frame:Hide()
		frame:ClearAllPoints()
		frame:SetParent(UIParent)
		frame:SetFrameStrata("HIGH")
		frame:SetMovable(false)
		frame:RegisterForDrag()
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnDragStop", nil)
		frame.independent = nil
		frame.embedded = nil
		frame.itemsPerRow = nil
		frame.rowBreaks = nil
		if frame.Reset then
			frame:Reset()
		end
	end)
	local buttonPool = CreateFramePool(ns.CLASSIC and "BUTTON" or "ItemButton", nil, ns.CLASSIC and "ItemButtonTemplate" or nil, function(framePool, button)
		if button.RestrictionIcon then
			button.RestrictionIcon:Hide()
			button.KnownIcon:Hide()
		end
		button.lootdata = nil
		button:ClearAllPoints()
		button:SetParent(nil)
		button:Hide()
		SetItemButtonDesaturated(button, false)

		-- classic
		if not button.SetItem then
			function button:SetItem(item)
				local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID
				if item then
					itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = C_Item.GetItemInfoInstant(item)
				end
				if itemID then
					self.item = item
					self.itemID = itemID
					SetItemButtonTexture(button, icon)
				else
					self.item = nil
					self.itemID = nil
					SetItemButtonTexture(button, false)
				end
			end
			function button:GetItem()
				return self.item
			end
			function button:GetItemID()
				return self.itemID
			end
			function button:GetItemLink()
				if not self.itemID then return nil end
				return select(2, C_Item.GetItemInfo(self.itemID))
			end
		end

		button:SetItem(nil)
	end)
	local timerPool = CreateFramePool("Frame", UIParent, nil, function(framePool, frame)
		frame:Hide()
		frame:SetParent(nil)
		frame.checkThreshold = 0
		frame.timeOffFrame = 0
		frame.additional = false
		frame.callback = nil
		frame.watch = nil
		frame:SetScript("OnUpdate", timer_onupdate)
	end)

	ns.Loot.Window = {}

	local function button_onenter(self)
		local loot_tooltip = ns.Tooltip.Get("Loot")
		loot_tooltip:SetFrameStrata(self:GetFrameStrata())
		loot_tooltip:SetFrameLevel(self:GetFrameLevel() + 1)
		if self:GetCenter() > UIParent:GetCenter() then
			loot_tooltip:SetOwner(self, "ANCHOR_LEFT")
		else
			loot_tooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
		self.lootdata:SetTooltip(loot_tooltip)
		showRestrictions(loot_tooltip, self.lootdata)
		if core.debuggable then
			loot_tooltip:AddDoubleLine(ID, self:GetItemID())
		end
		loot_tooltip:Show()
		self:GetParent().tooltip = loot_tooltip
	end
	local function button_onleave(self)
		ns.Tooltip.Get("Loot"):Hide()
		self:GetParent().tooltip = nil
	end
	local function button_onclick(self, mousebutton)
		if IsModifiedClick() then
			if HandleModifiedItemClick(self:GetItemLink()) then
				return
			end
		end
		if mousebutton ~= "RightButton" then return end
		local window = self:GetParent()
		-- an embedded window isn't the user's to dismiss: whatever it's sitting
		-- in owns the right-click, and hiding it would leave a hole
		if window.embedded then return end
		if window.independent then
			ns.Loot.Window.Release(window)
		else
			window:Hide()
		end
	end
	local function close_onclick(self)
		ns.Loot.Window.Release(self:GetParent())
	end

	-- Six across suits a window that floats free next to a tooltip. A host that
	-- gives the window a width to fill wants as many as fit, so this is per
	-- window rather than a constant.
	--
	-- rowBreaks[index] = section heading. The button at that index starts a fresh
	-- row with the heading above it, which is how merged shared loot stays
	-- distinguishable from the rest instead of just running on.
	local ROW_STEP = ITEM_HEIGHT - ITEM_YOFFSET
	local SHARED_LOOT_LABEL = "Shared loot"

	local function layoutButtons(window)
		local perRow = window:GetItemsPerRow()
		local y = BORDER_WIDTH + (window.title:IsShown() and TITLE_SPACING or 0)
		local column, widest, used = 0, 0, 0
		window.sectionLabels = window.sectionLabels or {}
		for _, label in ipairs(window.sectionLabels) do
			label:Hide()
		end

		for index, button in ipairs(window.buttons) do
			local heading = window.rowBreaks and window.rowBreaks[index]
			if column > 0 and (heading or column >= perRow) then
				column, y = 0, y + ROW_STEP
			end
			if heading then
				used = used + 1
				local label = window.sectionLabels[used]
				if not label then
					label = window:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
					window.sectionLabels[used] = label
				end
				label:ClearAllPoints()
				label:SetPoint("TOPLEFT", window, "TOPLEFT", BORDER_WIDTH, -y)
				label:SetText(heading)
				label:Show()
				y = y + TITLE_SPACING
			end
			button:ClearAllPoints()
			if column == 0 then
				button:SetPoint("TOPLEFT", window, "TOPLEFT", BORDER_WIDTH, -y)
			else
				button:SetPoint("TOPLEFT", window.buttons[index - 1], "TOPRIGHT", ITEM_XOFFSET, 0)
			end
			column = column + 1
			widest = math.max(widest, column)
		end

		window.gridColumns = widest
		window.contentHeight = #window.buttons > 0
			and (y + ITEM_HEIGHT + BORDER_WIDTH)
			or (2 * BORDER_WIDTH)
	end

	-- How many buttons fit across a given width, for hosts sizing one to a panel
	function ns.Loot.Window.ColumnsForWidth(width)
		local step = ITEM_WIDTH + math.abs(ITEM_XOFFSET)
		local usable = (width or 0) - (2 * BORDER_WIDTH) + math.abs(ITEM_XOFFSET)
		return math.max(1, math.floor(usable / step))
	end

	-- The other way round: how tall a window holding this much comes out, so a
	-- host reserving space for one doesn't have to guess at these numbers.
	function ns.Loot.Window.HeightForRows(rows, headings)
		rows = math.max(1, rows or 1)
		return (2 * BORDER_WIDTH) + ITEM_HEIGHT + ((rows - 1) * ROW_STEP)
			+ ((headings or 0) * TITLE_SPACING)
	end

	local WINDOW_BACKDROP = {
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	}

	local WindowMixin = {
		Init = function(self)
			self.buttons = {}

			self:SetBackdrop(WINDOW_BACKDROP)
			self:SetClampedToScreen(true)
			self:SetSize(43, 43)
			self:SetBackdropColor(0, 0, 0, .5)
			self:EnableMouse(true)

			self.title = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
			self.title:SetPoint("TOPLEFT", BORDER_WIDTH, -BORDER_WIDTH)
			self.title:SetPoint("TOPRIGHT", -BORDER_WIDTH, -BORDER_WIDTH)
			self.title:Hide()

			self.close = CreateFrame("Button", nil, self, "UIPanelCloseButtonNoScripts")
			self.close:SetSize(18, 18)
			self.close:SetPoint("CENTER", self, "TOPRIGHT", -4, -4)
			self.close:SetScript("OnClick", close_onclick)
			self.close:Hide()
		end,
		Reset = function(self)
			self:SetAutoHideDelay(0)
			self:ClearLoot()
			self.title:Hide()
			self.close:Hide()
			-- an embedded window drops the backdrop to sit flush in its host, and
			-- the pool hands the same frame out again afterwards
			self:SetBackdrop(WINDOW_BACKDROP)
			self:SetBackdropColor(0, 0, 0, .5)
			if self.tooltip then
				self.tooltip:Hide()
				self.tooltip = nil
			end
		end,
		AddItem = function(self, item)
			local button, isNew = buttonPool:Acquire()
			button:SetParent(self)
			if isNew then
				button:SetScript("OnClick", button_onclick)
				button:SetScript("OnEnter", button_onenter)
				button:SetScript("OnLeave", button_onleave)
				local sublevel = 4
				if button.IconOverlay then
					sublevel = select(2, button.IconOverlay:GetDrawLayer()) + 1
				end
				button.RestrictionIcon = button:CreateTexture(nil, "OVERLAY", nil, sublevel)
				button.RestrictionIcon:SetPoint("TOPRIGHT", 4, 4)
				button.KnownIcon = button:CreateTexture(nil, "OVERLAY", nil, sublevel)
				button.KnownIcon:SetPoint("BOTTOMRIGHT", 4, -4)
				button.KnownIcon:SetSize(16, 16)
			end

			tinsert(self.buttons, button)
			layoutButtons(self)
			self:SizeForButtons()

			if item then
				item:AddToItemButton(button)
				button.lootdata = item

				-- TODO: show icon for spec if GetItemSpecInfo says it doesn't drop for the current spec
				if item.covenant and covenants[item.covenant] then
					button.RestrictionIcon:SetAtlas(("covenantchoice-panel-sigil-%s"):format(covenants[item.covenant]))
					button.RestrictionIcon:SetSize(16, 20) -- these are 73x96 natively
					button.RestrictionIcon:Show()
				elseif item.class then
					button.RestrictionIcon:SetAtlas(("groupfinder-icon-class-%s"):format(item.class))
					button.RestrictionIcon:SetSize(20, 20)
					button.RestrictionIcon:Show()
				end

				local known = item:Obtained(true)
				if known ~= nil then
					if known or item:Available() then
						-- don't show the x for restricted items
						button.KnownIcon:SetAtlas(known and ATLAS_CHECK or ATLAS_CROSS)
						button.KnownIcon:Show()
					end
				end
				if not suitable(item) then
					SetItemButtonDesaturated(button, true)
				end
			end

			button:Show()
			return button
		end,
		-- A heading only makes sense once there's something for it to sit below;
		-- a window whose whole contents are one section says so in its title.
		AddLoot = function(self, loot, heading)
			if heading and #self.buttons > 0 then
				self.rowBreaks = self.rowBreaks or {}
				self.rowBreaks[#self.buttons + 1] = heading
			end
			for _, item in ipairs(loot) do
				self:AddItem(item)
			end
		end,
		GetItemsPerRow = function(self)
			return self.itemsPerRow or ITEMS_PER_ROW
		end,
		SetItemsPerRow = function(self, count)
			count = math.max(1, math.floor(count or 0))
			if count == self:GetItemsPerRow() then return end
			self.itemsPerRow = count
			layoutButtons(self)
			self:SizeForButtons()
		end,
		-- Both measurements come from the layout pass, so the frame always fits
		-- what's actually in it -- section headings and part-filled rows included.
		SizeForButtons = function(self)
			local columns = self.gridColumns or 0
			self:SetSize(
				(2 * BORDER_WIDTH) + math.max(
					(columns * ITEM_WIDTH) + ((columns - 1) * math.abs(ITEM_XOFFSET)),
					self.title:IsShown() and self.title:GetStringWidth() or 0
				),
				self.contentHeight or (2 * BORDER_WIDTH)
			)
		end,
		ClearLoot = function(self)
			for _, button in ipairs(self.buttons) do
				buttonPool:Release(button)
			end
			wipe(self.buttons)
			self.rowBreaks = nil
			for _, label in ipairs(self.sectionLabels or {}) do
				label:Hide()
			end
			self.gridColumns, self.contentHeight = 0, nil
		end,
		SetTitle = function(self, title)
			if title then
				self.title:Show()
				self.title:SetText(title)
			else
				self.title:Hide()
			end
		end,
		SetAutoHideDelay = function(self, delay, additional, callback)
			-- this is *highly* based on LibQTip-1.0's function
			delay = tonumber(delay) or 0
			if delay > 0 then
				self.timer = self.timer or timerPool:Acquire()
				self.timer.allowedTimeOffFrame = delay
				self.timer.additional = additional
				self.timer.callback = callback
				self.timer.watch = self
				if self.sharedWindow then
					self.timer.additional = self.timer.additional or {}
					tinsert(self.timer.additional, self.sharedWindow)
				end
				self.timer:Show()
			elseif self.timer then
				timerPool:Release(self.timer)
				self.timer = nil
			end
		end,
		MakeIndependent = function(self)
			self.close:Show()
			self:SetMovable(true)
			self:RegisterForDrag("LeftButton")
			self:SetScript("OnDragStart", self.OnDragStart)
			self:SetScript("OnDragStop", self.StopMovingOrSizing)

			self.independent = true
		end,
		OnDragStart = function(self)
			self:StartMoving()
		end
	}

	local function GetWindow()
		local window, isNew = windowPool:Acquire()
		if isNew then
			Mixin(window, WindowMixin)
			window:Init()
		end

		return window
	end
	ns.Loot.Window.Get = GetWindow

	ns.Loot.Window.Release = function(window)
		if not window then return end
		if window.sharedWindow then
			windowPool:Release(window.sharedWindow)
			core.events:Fire("LootWindowReleased", window.sharedWindow)
			window.sharedWindow = nil
		end
		-- this will hide / clearallpoints / clearloot the window
		windowPool:Release(window)

		core.events:Fire("LootWindowReleased", window)
	end

	local function lootFilter(filter, loot)
		if loot then
			if filter then
				loot = tFilter(loot, filter, true)
			end
			if #loot == 0 then
				return nil
			end
		end
		return loot
	end
	-- mergeShared puts shared loot in the same grid rather than a second window
	-- hanging off the bottom. For a host that's given the window a fixed space to
	-- sit in there's nowhere for that second one to go.
	function ns.Loot.Window.ShowForMob(id, independent, treasure, shared, extraFilter, mergeShared)
		local filter = function(item)
			if extraFilter and not extraFilter(item) then return false end
			return not core.db.profile.charloot or IsShiftKeyDown() or item:MightDrop()
		end
		local loot = lootFilter(filter, ns.Loot.GetLootTable(id, treasure))
		local sharedLoot = lootFilter(filter, shared and ns.Loot.GetLootTable(id, treasure, true))
		if not (loot or sharedLoot) then
			-- TODO: error message
			return false
		end
		local window
		if independent then
			for other in windowPool:EnumerateActive() do
				if other.independent then
					window = other
					break
				end
			end
			if window then
				window:ClearLoot()
			else
				window = GetWindow()
				window:MakeIndependent()
				window:SetPoint("CENTER")
			end
			window:SetTitle(core:GetMobLabel(id))
		else
			window = GetWindow()
		end
		if sharedLoot and not loot then
			-- needs to be set before addloot for sizing reasons
			window:SetTitle(SHARED_LOOT_LABEL)
		end
		window:AddLoot(loot or sharedLoot)
		if loot and sharedLoot and mergeShared then
			window:AddLoot(sharedLoot, SHARED_LOOT_LABEL)
		elseif loot and sharedLoot then
			local sharedWindow = GetWindow()
			window.sharedWindow = sharedWindow
			sharedWindow:SetParent(window)
			sharedWindow:SetPoint("TOPLEFT", window, "BOTTOMLEFT")
			sharedWindow:SetTitle(SHARED_LOOT_LABEL)
			sharedWindow:AddLoot(sharedLoot)
			sharedWindow:Show()
			core.events:Fire("LootWindowOpened", sharedWindow)
		end
		window:Show()

		-- get this ready:
		ns.Tooltip.Get("Loot")

		core.events:Fire("LootWindowOpened", window)

		return window
	end

	-- debug:
	-- window:AddLoot({
	-- 	173468, 173468, 173468, 173468, 152739, 152739, 152739, 152739, 152739, 152739, 152739, 152739, 152739,
	-- })

	-- /script SilverDragon:ShowLootWindowForMob(160821)
	function core:ShowLootWindowForMob(id, ...)
		local window = ns.Loot.Window.ShowForMob(id, true, ...)
	end
end
