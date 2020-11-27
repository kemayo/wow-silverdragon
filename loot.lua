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
end
function ns.Loot.HasToys(id)
	for toyid in ns.Loot.IterToys(id) do
		return true
	end
	return false
end
function ns.Loot.HasMounts(id)
	for mountid in ns.Loot.IterMounts(id) do
		return true
	end
	return false
end
function ns.Loot.HasPets(id)
	for petid in ns.Loot.IterPets(id) do
		return true
	end
	return false
end

ns.Loot.Status = setmetatable({}, {__call = function(_, id)
	if not id or not ns.mobdb[id] then
		return
	end
	return ns.Loot.Status.Toy(id), ns.Loot.Status.Mount(id), ns.Loot.Status.Pet(id)
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
}
ns.Loot.Summary = Summary

function ns.Loot.Summary.UpdateTooltip(tooltip, id)
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
end

do
	local ITEMS_PER_ROW = 6
	local BORDER_WIDTH = 8
	local ITEM_WIDTH = 37;
	local ITEM_HEIGHT = 37;
	local ITEM_XOFFSET = 4;
	local ITEM_YOFFSET = -5;
	local buttons = {}

	local window = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	window:SetFrameStrata("HIGH")
	window:SetClampedToScreen(true)
	window:SetSize(43, 43)
	window:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	window:SetBackdropColor(0, 0, 0, .5)
	window:Hide()

	window:SetScript("OnHide", function(self)
		self:Clear()
		self:ClearAllPoints()
	end)

	-- local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
	-- close:SetSize(18, 18)
	-- close:SetPoint("CENTER", window, "TOPRIGHT", -4, -4)
	-- close:Show()

	window.itemPool = CreateFramePool("ItemButton", window)
	local function button_onenter(button)
		GameTooltip:SetFrameStrata("DIALOG")
		if button:GetCenter() > UIParent:GetCenter() then
			GameTooltip:SetOwner(button, "ANCHOR_LEFT")
		else
			GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
		end
		GameTooltip:SetHyperlink(button:GetItemLink())
		GameTooltip:Show()
	end
	local function button_onclick(button, mousebutton)
		if IsModifiedClick() then
			if HandleModifiedItemClick(button:GetItemLink()) then
				return
			end
		end
		if mousebutton == "RightButton" then
			window:Hide()
		end
	end
	local function sizeWindow()
		local columns = math.min(#buttons, ITEMS_PER_ROW)
		local rows = math.ceil(#buttons / ITEMS_PER_ROW)
		window:SetSize(
			(2 * BORDER_WIDTH) + (columns * ITEM_WIDTH) + ((columns - 1) * math.abs(ITEM_XOFFSET)),
			(2 * BORDER_WIDTH) + (rows * ITEM_HEIGHT) + ((rows - 1) * math.abs(ITEM_YOFFSET))
		)
	end
	function window:AddItem(itemid)
		local button = window.itemPool:Acquire()
		button:SetScript("OnClick", button_onclick)
		button:SetScript("OnEnter", button_onenter)
		button:SetScript("OnLeave", GameTooltip_Hide)

		local numButtons = #buttons
		local pos = numButtons / ITEMS_PER_ROW
		if ( math.floor(pos) == pos ) then
			-- This is the first button in a row.
			button:SetPoint("TOPLEFT", window, "TOPLEFT", BORDER_WIDTH, -BORDER_WIDTH - (ITEM_HEIGHT - ITEM_YOFFSET) * pos)
		else
			button:SetPoint("TOPLEFT", buttons[numButtons], "TOPRIGHT", ITEM_XOFFSET, 0)
		end
		tinsert(buttons, button)
		sizeWindow()

		if itemid then
			button:SetItem(itemid)
		end

		button:Show()
		return button
	end

	function window:AddLoot(loot)
		for _, item in ipairs(loot) do
			local itemid = type(item) == "table" and item.item or item
			if itemid then
				self:AddItem(itemid)
			end
		end
	end
	function window:Clear()
		wipe(buttons)
		self.itemPool:ReleaseAll()
	end

	local items = {}
	function window:ShowForMob(id)
		if not (id and ns.mobdb[id] and ns.mobdb[id].loot) then
			-- TODO: error message
			return false
		end
		self:AddLoot(ns.mobdb[id].loot)
		self:Show()
	end

	ns.Loot.Window = window

	-- debug:
	-- window:AddLoot({
	-- 	173468, 173468, 173468, 173468, 152739, 152739, 152739, 152739, 152739, 152739, 152739, 152739, 152739,
	-- })

	-- /script SilverDragon:ShowLootWindowForMob(160821)
	function core:ShowLootWindowForMob(id)
		window:Hide()
		window:ShowForMob(id)
		window:SetPoint("CENTER")
	end
end
