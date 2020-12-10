local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local Debug = core.Debug
local DebugF = core.DebugF

local function safeunpack(table_or_value)
	if type(table_or_value) == "table" then
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
local function PlayerHasMount(mountid)
	return (select(11, C_MountJournal.GetMountInfoByID(mountid)))
end
local function PlayerHasPet(petid)
	return (C_PetJournal.GetNumCollectedInfo(petid) > 0)
end

ns.Loot = {}

function ns.Loot.HasLoot(id)
	if not (id and ns.mobdb[id]) then
		return false
	end
	return ns.mobdb[id].loot
end
do
	local function make_iter(test)
		return function(t, prestate)
			local state, item = next(t, prestate)
			while state do
				item = test(item)
				if item then
					return state, item
				end
				state, item = next(t, state)
			end
		end
	end
	local mount_iter = make_iter(function(item) return type(item) == "table" and item.mount end)
	local pet_iter = make_iter(function(item) return type(item) == "table" and item.pet end)
	local toy_iter = make_iter(function(item) return type(item) == "table" and item.toy end)
	local regular_iter = make_iter(function(item) return type(item) == "number" and item end)
	local noloot = {}
	function ns.Loot.IterMounts(id)
		return mount_iter, ns.mobdb[id].loot or noloot, nil
	end
	function ns.Loot.IterPets(id)
		return pet_iter, ns.mobdb[id].loot or noloot, nil
	end
	function ns.Loot.IterToys(id)
		return toy_iter, ns.mobdb[id].loot or noloot, nil
	end
	function ns.Loot.IterRegularLoot(id)
		return regular_iter, ns.mobdb[id].loot or noloot, nil
	end
end
function ns.Loot.HasToys(id)
	if not (id and ns.mobdb[id] and ns.mobdb[id].loot) then return false end
	for _ in ns.Loot.IterToys(id) do
		return true
	end
	return false
end
function ns.Loot.HasMounts(id)
	if not (id and ns.mobdb[id] and ns.mobdb[id].loot) then return false end
	for _ in ns.Loot.IterMounts(id) do
		return true
	end
	return false
end
function ns.Loot.HasPets(id)
	if not (id and ns.mobdb[id] and ns.mobdb[id].loot) then return false end
	for _ in ns.Loot.IterPets(id) do
		return true
	end
	return false
end
function ns.Loot.HasKnowableLoot(id)
	return ns.Loot.HasMounts(id) or ns.Loot.HasToys(id) or ns.Loot.HasPets(id)
end
function ns.Loot.HasRegularLoot(id)
	if not (id and ns.mobdb[id] and ns.mobdb[id].loot) then return false end
	for _ in ns.Loot.IterRegularLoot(id) do
		return true
	end
	return false
end

function ns.Loot.Cache(id)
	if not (id and ns.mobdb[id] and ns.mobdb[id].loot) then return false end
	for _, item in ipairs(ns.mobdb[id].loot) do
		C_Item.RequestLoadItemDataByID(type(item) == "table" and item.item or item)
	end
end

ns.Loot.Status = setmetatable({}, {__call = function(_, id)
	-- returns nil if there's no knowable loot
	-- returns true if all knowable loot is collected
	-- returns false if not all knowable loot is collected
	-- if knowable loot, also returns the status for mount,toy,pet after the first return
	if not id or not ns.mobdb[id] then
		return
	end
	local mount = ns.Loot.Status.Mount(id)
	local toy = ns.Loot.Status.Toy(id)
	local pet = ns.Loot.Status.Pet(id)
	if (mount == nil and toy == nil and pet == nil) then
		return nil
	end
	return (mount and toy and pet), mount, toy, pet
end})
function ns.Loot.Status.Toy(id)
	if not id or not ns.mobdb[id] then return end
	local ret = nil
	for _, toyid in ns.Loot.IterToys(id) do
		if not PlayerHasToy(toyid) then
			return false
		end
		ret = true
	end
	return ret
end
function ns.Loot.Status.Mount(id)
	if not id or not ns.mobdb[id] then return end
	local ret = nil
	for _, mountid in ns.Loot.IterMounts(id) do
		if not PlayerHasMount(mountid) then
			return false
		end
		ret = true
	end
	return ret
end
function ns.Loot.Status.Pet(id)
	if not id or not ns.mobdb[id] then return end
	local ret = nil
	for _, petid in ns.Loot.IterPets(id) do
		if not PlayerHasToy(petid) then
			return false
		end
		ret = true
	end
	return ret
end

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

local Details = {
	toy = function(tooltip, i, toyid)
		tooltip:SetHyperlink(("item:%d"):format(toyid))
	end,
	mount = function(tooltip, i, mountid)
		local name, spellid, texture, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountid)
		if not name then
			tooltip:AddLine("mount:" .. mountid)
			tooltip:AddLine(SEARCH_LOADING_TEXT, 0, 1, 1)
			return
		end
		local _, description, source = C_MountJournal.GetMountInfoExtraByID(mountid)

		tooltip:AddLine(name)
		tooltip:AddTexture(texture)
		tooltip:AddLine(description, 1, 1, 1, true)
		tooltip:AddLine(source)
		if isCollected then
			tooltip:AddLine(USED, 1, 0, 0)
		end
	end,
	pet = function(tooltip, i, petid)
		local name, texture, _, mobid, source, description = C_PetJournal.GetPetInfoBySpeciesID(petid)
		if not name then
			tooltip:AddLine("pet:" .. petid)
			tooltip:AddLine(SEARCH_LOADING_TEXT, 0, 1, 1)
			return
		end
		local owned, limit = C_PetJournal.GetNumCollectedInfo(petid)
		tooltip:AddLine(name)
		tooltip:AddTexture(texture)
		tooltip:AddLine(description, 1, 1, 1, true)
		tooltip:AddLine(source)
		tooltip:AddLine(ITEM_PET_KNOWN:format(owned, limit))
	end,
}
ns.Loot.Details = Details

function ns.Loot.Details.UpdateTooltip(tooltip, id, only)
	if not (id and ns.mobdb[id]) then
		return
	end

	local toy = (not only or only == "toy") and ns.Loot.HasToys(id)
	local mount = (not only or only == "mount") and ns.Loot.HasMounts(id)
	local pet = (not only or only == "pet") and ns.Loot.HasPets(id)

	if toy then
		local toytip
		for i, toyid in ns.Loot.IterToys(id) do
			toytip = get_tooltip(toytip or tooltip, i)
			Details.toy(toytip, i, toyid)
		end
	end
	if mount then
		if toy then
			tooltip:AddLine("---")
		end
		for i, mountid in ns.Loot.IterMounts(id) do
			Details.mount(tooltip, i, mountid)
		end
	end
	if pet then
		if toy or mount then
			tooltip:AddLine('---')
		end
		for i, petid in ns.Loot.IterPets(id) do
			Details.pet(tooltip, i, petid)
		end
	end
end

local Summary = {
	toy = function(tooltip, i, toyid)
		local _, name, icon = C_ToyBox.GetToyInfo(toyid)
		local owned = PlayerHasToy(toyid)
		if name then
			tooltip:AddDoubleLine(
				i==1 and TOY or " ",
				"|T" .. icon .. ":0|t " .. name,
				1, 1, 0,
				owned and 0 or 1, owned and 1 or 0, 0
			)
		else
			tooltip:AddDoubleLine(i==1 and TOY or " ", SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end,
	mount = function(tooltip, i, mountid)
		local name, _, icon, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountid)
		if name then
			tooltip:AddDoubleLine(
				i==1 and MOUNT or " ",
				"|T" .. icon .. ":0|t " .. name,
				1, 1, 0,
				isCollected and 0 or 1, isCollected and 1 or 0, 0
			)
		else
			tooltip:AddDoubleLine(i==1 and MOUNT or " ", SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end,
	pet = function(tooltip, i, petid)
		local name, icon = C_PetJournal.GetPetInfoBySpeciesID(petid)
		local owned, limit = C_PetJournal.GetNumCollectedInfo(petid)
		if name then
			local r, g, b = 1, 0, 0
			if owned == limit then
				r, g, b = 0, 1, 0
			elseif owned > 0 then
				r, g, b = 1, 1, 0
			end
			tooltip:AddDoubleLine(
				i==1 and TOOLTIP_BATTLE_PET or " ",
				"|T" .. icon .. ":0|t " .. (ITEM_SET_NAME):format(name, owned, limit),
				1, 1, 0,
				r, g, b
			)
		else
			tooltip:AddDoubleLine(i==1 and TOOLTIP_BATTLE_PET or " ", SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end,
	item = function(tooltip, i, itemid)
		local name, link, quality, _, _, _, _, _, _, icon = GetItemInfo(itemid)
		if name then
			tooltip:AddDoubleLine(
				i==1 and ENCOUNTER_JOURNAL_ITEM or " ",
				"|T" .. icon .. ":0|t " .. name,
				1, 1, 0,
				GetItemQualityColor(quality)
			)
		else
			tooltip:AddDoubleLine(i==1 and ENCOUNTER_JOURNAL_ITEM or " ", SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end,
}
ns.Loot.Summary = Summary

function ns.Loot.Summary.UpdateTooltip(tooltip, id, only_knowable)
	if not (id and ns.mobdb[id]) then
		return
	end

	for i, mountid in ns.Loot.IterMounts(id) do
		Summary.mount(tooltip, i, mountid)
	end
	for i, toyid in ns.Loot.IterToys(id) do
		Summary.toy(tooltip, i, toyid)
	end
	for i, petid in ns.Loot.IterPets(id) do
		Summary.pet(tooltip, i, petid)
	end
	if not only_knowable then
		for i, itemid in ns.Loot.IterRegularLoot(id) do
			Summary.item(tooltip, i, itemid)
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

	local windowPool = CreateFramePool("Frame", UIParent, "BackdropTemplate", function(framePool, frame)
		frame:Hide()
		frame:ClearAllPoints()
		frame:SetParent(UIParent)
		frame:SetFrameStrata("HIGH")
		frame:SetMovable(false)
		frame:RegisterForDrag(false)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnDragStop", nil)
		frame.independent = nil
		if frame.Reset then
			frame:Reset()
		end
	end)
	local buttonPool = CreateFramePool("ItemButton")
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

	local loot_tooltip = ns.Tooltip.Get("Loot")

	local function window_onclick(self, mousebutton)
		if mousebutton == "RightButton" then
			if self.independent then
				ns.Loot.Window.Release(self)
			else
				self:Hide()
			end
		end
	end
	local function button_onenter(self)
		loot_tooltip:SetFrameStrata(self:GetFrameStrata())
		loot_tooltip:SetFrameLevel(self:GetFrameLevel() + 1)
		if self:GetCenter() > UIParent:GetCenter() then
			loot_tooltip:SetOwner(self, "ANCHOR_LEFT")
		else
			loot_tooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
		loot_tooltip:SetHyperlink(self:GetItemLink())
		loot_tooltip:Show()
		self:GetParent().tooltip = loot_tooltip
	end
	local function button_onleave(self)
		loot_tooltip:Hide()
		self:GetParent().tooltip = nil
	end
	local function button_onclick(self, mousebutton)
		if IsModifiedClick() then
			if HandleModifiedItemClick(self:GetItemLink()) then
				return
			end
		end
		if mousebutton == "RightButton" then
			if self:GetParent().independent then
				ns.Loot.Window.Release(self:GetParent())
			else
				self:GetParent():Hide()
			end
		end
	end
	local function close_onclick(self)
		ns.Loot.Window.Release(self:GetParent())
	end

	local WindowMixin = {
		Init = function(self)
			self.buttons = {}

			self:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 },
			})
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
			if self.tooltip then
				self.tooltip:Hide()
				self.tooltip = nil
			end
		end,
		AddItem = function(self, itemid)
			local button, isNew = buttonPool:Acquire()
			button:SetParent(self)
			if isNew then
				button:SetScript("OnClick", button_onclick)
				button:SetScript("OnEnter", button_onenter)
				button:SetScript("OnLeave", button_onleave)
			end

			local numButtons = #self.buttons
			local pos = numButtons / ITEMS_PER_ROW
			if ( math.floor(pos) == pos ) then
				-- This is the first button in a row.
				-- button:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", 0, -(ITEM_HEIGHT - ITEM_YOFFSET) * pos)
				button:SetPoint("TOPLEFT", self, "TOPLEFT", BORDER_WIDTH, -BORDER_WIDTH - (ITEM_HEIGHT - ITEM_YOFFSET) * pos - (self.title:IsShown() and TITLE_SPACING or 0))
			else
				button:SetPoint("TOPLEFT", self.buttons[numButtons], "TOPRIGHT", ITEM_XOFFSET, 0)
			end
			tinsert(self.buttons, button)
			self:SizeForButtons()

			if itemid then
				button:SetItem(itemid)
			end

			button:Show()
			return button
		end,
		AddLoot = function(self, loot)
			for _, item in ipairs(loot) do
				local itemid = type(item) == "table" and item.item or item
				if itemid then
					self:AddItem(itemid)
				end
			end
		end,
		SizeForButtons = function(self)
			local columns = math.min(#self.buttons, ITEMS_PER_ROW)
			local rows = math.ceil(#self.buttons / ITEMS_PER_ROW)
			self:SetSize(
				(2 * BORDER_WIDTH) + math.max((columns * ITEM_WIDTH) + ((columns - 1) * math.abs(ITEM_XOFFSET)), self.title:IsShown() and self.title:GetStringWidth() or 0),
				(self.title:IsShown() and TITLE_SPACING or 0) + (2 * BORDER_WIDTH) + (rows * ITEM_HEIGHT) + ((rows - 1) * math.abs(ITEM_YOFFSET))
			)
		end,
		ClearLoot = function(self)
			for _, button in ipairs(self.buttons) do
				buttonPool:Release(button)
			end
			wipe(self.buttons)
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
		-- this will hide / clearallpoints / clearloot the window
		windowPool:Release(window)

		core.events:Fire("LootWindowReleased", window)
	end

	function ns.Loot.Window.ShowForMob(id, independent)
		if not (id and ns.mobdb[id] and ns.mobdb[id].loot) then
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
		window:AddLoot(ns.mobdb[id].loot)
		window:Show()

		core.events:Fire("LootWindowOpened", window)

		return window
	end

	-- debug:
	-- window:AddLoot({
	-- 	173468, 173468, 173468, 173468, 152739, 152739, 152739, 152739, 152739, 152739, 152739, 152739, 152739,
	-- })

	-- /script SilverDragon:ShowLootWindowForMob(160821)
	function core:ShowLootWindowForMob(id)
		local window = ns.Loot.Window.ShowForMob(id, true)
	end
end
