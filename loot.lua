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

local ATLAS_CHECK, ATLAS_CROSS = "common-icon-checkmark", "common-icon-redx"
if ns.CLASSIC then
	ATLAS_CHECK, ATLAS_CROSS = "Tracker-Check", "Objective-Fail"
end

-- we need non-localized covenant names for atlases
-- can't use the texturekit value from covenant data, since the atlas I want doesn't conform to it
local covenants = {
	[Enum.CovenantType.Kyrian] = "Kyrian",
	[Enum.CovenantType.Necrolord] = "Necrolords",
	[Enum.CovenantType.NightFae] = "NightFae",
	[Enum.CovenantType.Venthyr] = "Venthyr",
}

local brokenItems = {
	-- itemid : {appearanceid, sourceid}
	[153268] = {25124, 90807}, -- Enclave Aspirant's Axe
	[153316] = {25123, 90885}, -- Praetor's Ornamental Edge
}
local function GetAppearanceAndSource(itemLinkOrID)
	local itemID = GetItemInfoInstant(itemLinkOrID)
	if not itemID then return end
	local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLinkOrID)
	if not appearanceID then
		-- sometimes the link won't actually give us an appearance, but itemID will
		-- e.g. mythic Drape of Iron Sutures from Shadowmoon Burial Grounds
		appearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemID)
	end
	if not appearanceID and brokenItems[itemID] then
		-- ...and there's a few that just need to be hardcoded
		appearanceID, sourceID = unpack(brokenItems[itemID])
	end
	return appearanceID, sourceID
end
local canLearnCache = {}
local function CanLearnAppearance(itemLinkOrID)
	if not _G.C_Transmog then return false end
	local itemID = GetItemInfoInstant(itemLinkOrID)
	if not itemID then return end
	if canLearnCache[itemID] ~= nil then
		return canLearnCache[itemID]
	end
	-- First, is this a valid source at all?
	local canBeChanged, noChangeReason, canBeSource, noSourceReason = C_Transmog.CanTransmogItem(itemID)
	if canBeSource == nil or noSourceReason == 'NO_ITEM' then
		-- data loading, don't cache this
		return
	end
	if not canBeSource then
		canLearnCache[itemID] = false
		return false
	end
	local appearanceID, sourceID = GetAppearanceAndSource(itemLinkOrID)
	if not appearanceID then
		canLearnCache[itemID] = false
		return false
	end
	local hasData, canCollect = C_TransmogCollection.PlayerCanCollectSource(sourceID)
	if hasData then
		canLearnCache[itemID] = canCollect
	end
	return canLearnCache[itemID]
end
local hasAppearanceCache = {}
local function HasAppearance(itemLinkOrID)
	local itemID = GetItemInfoInstant(itemLinkOrID)
	if not itemID then return end
	if hasAppearanceCache[itemID] ~= nil and core.db.profile.lootappearances then
		-- only use the cache if we need the more expensive checks below...
		-- and so we don't need to care about clearing it when someone
		-- changes their settings.
		return hasAppearanceCache[itemID]
	end
	if C_TransmogCollection.PlayerHasTransmogByItemInfo(itemLinkOrID) then
		-- short-circuit further checks because this specific item is known
		hasAppearanceCache[itemID] = true
		return true
	end
	if not core.db.profile.lootappearances then
		-- No fallback checks, only whether the specific item is known counts
		return false
	end
	-- Although this isn't known, its appearance might be known from another item
	local appearanceID = GetAppearanceAndSource(itemLinkOrID)
	if not appearanceID then
		hasAppearanceCache[itemID] = false
		return
	end
	local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
	if not sources then return end
	for _, sourceID in ipairs(sources) do
		if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID) then
			hasAppearanceCache[itemID] = true
			return true
		end
	end
	return false
end

local function PlayerHasMount(mountid)
	-- TODO: GetCompanionInfo somehow for Wrath?
	if not C_MountJournal then return false end
	return (select(11, C_MountJournal.GetMountInfoByID(mountid)))
end
local function PlayerHasPet(petid)
	-- TODO: GetCompanionInfo somehow for Wrath?
	if not C_PetJournal then return false end
	return (C_PetJournal.GetNumCollectedInfo(petid) > 0)
end
local itemRestricted = function(item)
	if type(item) ~= "table" then return false end
	if item.covenant and C_Covenants and item.covenant ~= C_Covenants.GetActiveCovenantID() then
		return true
	end
	if item.class and select(2, UnitClass("player")) ~= item.class then
		return true
	end
	if item.requires and not core.conditions.check(item.requires) then
		return true
	end
	return false
end
local itemIsKnowable = function(item)
	if ns.CLASSIC then return true end
	if type(item) == "table" then
		return (item.toy or item.mount or item.pet or item.quest or CanLearnAppearance(item[1])) -- and not itemRestricted(item)
	end
	return CanLearnAppearance(item)
end
local itemIsKnown = function(item)
	-- returns true/false/nil for yes/no/not-knowable
	if ns.CLASSIC then
		if type(item) == "table" and item.quest then
			return C_QuestLog.IsQuestFlaggedCompleted(item.quest) or C_QuestLog.IsOnQuest(item.quest)
		end
		return GetItemCount(type(item) == "table" and item[1] or item, true) > 0
	end
	if type(item) == "table" then
		if item.toy then return PlayerHasToy(item[1]) end
		if item.mount then return PlayerHasMount(item.mount) end
		if item.pet then return PlayerHasPet(item.pet) end
		if item.quest then return C_QuestLog.IsQuestFlaggedCompleted(item.quest) or C_QuestLog.IsOnQuest(item.quest) end
		if CanLearnAppearance(item[1]) then return HasAppearance(item[1]) end
	elseif CanLearnAppearance(item) then
		return HasAppearance(item)
	end
end

ns.Loot = {}
-- _G.SDLoot = ns.Loot

function ns.Loot.GetLootTable(id, treasure)
	if not id then return end
	if treasure then
		local data = ns.vignetteTreasureLookup[id]
		return data and data.loot
	end
	return ns.mobdb[id] and ns.mobdb[id].loot
end

local function suitable(item)
	if not core.db.profile.charloot then
		return true
	end
	local id = type(item) == "table" and item[1] or item
	-- show loot for the current character only
	-- can't pass in a reusable table for the second argument because it changes the no-data case
	local specTable = GetItemSpecInfo(id)
	-- Some cosmetic items seem to be flagged as not dropping for any spec. I
	-- could only confirm this for some cosmetic back items but let's play it
	-- safe and say that any cosmetic item can drop regardless of what the
	-- spec info says...
	if specTable and #specTable == 0 and not IsCosmeticItem(id) then
		return false
	end
	-- then catch covenants / classes / etc
	if itemRestricted(item) then return false end
	return true
end
function ns.Loot.HasLoot(id, isTreasure)
	local loot = ns.Loot.GetLootTable(id, isTreasure)
	if not loot or #loot == 0 then
		return false
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
	local continuableContainer = ContinuableContainer:Create()
	for _, item in ipairs(loot) do
		local itemid = type(item) == "table" and item[1] or item
		continuableContainer:AddContinuable(Item:CreateFromItemID(itemid))
	end
	continuableContainer:ContinueOnLoad(function() callback(loot) end)
end
do
	local function make_iter(test)
		return function(t, prestate)
			local state, item = next(t, prestate)
			while state do
				local ret = test(item)
				if ret and suitable(item) then
					return state, ret, item
				end
				state, item = next(t, state)
			end
		end
	end
	local mount_iter = make_iter(function(item) return type(item) == "table" and item.mount, item end)
	local pet_iter = make_iter(function(item) return type(item) == "table" and item.pet, item end)
	local toy_iter = make_iter(function(item) return type(item) == "table" and item.toy and item[1], item end)
	local quest_iter = make_iter(function(item) return type(item) == "table" and item.quest, item end)
	local regular_iter = make_iter(function(item)
		if type(item) == "number" then
			return item
		end
		if not (item.mount or item.pet or item.toy) then
			return item[1], item
		end
	end)
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
function ns.Loot.HasToys(id, only_knowable, ...)
	if not ns.Loot.GetLootTable(id, ...) then return false end
	for _, _, item in ns.Loot.IterToys(id) do
		if (not only_knowable) or (not itemRestricted(item)) then
			return true
		end
	end
	return false
end
function ns.Loot.HasMounts(id, only_knowable, only_boe, ...)
	if not ns.Loot.GetLootTable(id, ...) then return false end
	for _, _, item in ns.Loot.IterMounts(id, ...) do
		if ((not only_knowable) or (not itemRestricted(item)) and ((not only_boe) or item.boe)) then
			return true
		end
	end
	return false
end
function ns.Loot.HasInterestingMounts(id, ...)
	-- This comes up a lot: mounts that you don't know, or which are BoE and so can be sold
	return ns.Loot.Status.Mount(id, ...) == false or ns.Loot.HasMounts(id, true, true, ...)
end
function ns.Loot.HasPets(id, only_knowable, ...)
	if not ns.Loot.GetLootTable(id, ...) then return false end
	for _, _, item in ns.Loot.IterPets(id) do
		if (not only_knowable) or (not itemRestricted(item)) then
			return true
		end
	end
	return false
end
function ns.Loot.HasKnowableLoot(id, ...)
	if not ns.Loot.GetLootTable(id, ...) then return false end
	return any(itemIsKnowable, unpack(ns.mobdb[id].loot))
end
function ns.Loot.HasRegularLoot(id, ...)
	if not ns.Loot.GetLootTable(id, ...) then return false end
	for _ in ns.Loot.IterRegularLoot(id) do
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
		C_Item.RequestLoadItemDataByID(type(item) == "table" and item[1] or item)
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
local function restrictedCheck(test, itemid, item)
	local known = test(itemid)
	if known then return true end
	if known == nil or itemRestricted(item) then return nil end
	return false
end
local function statusChecker(iterator, test)
	return function(id, ...)
		if not ns.Loot.GetLootTable(id, ...) then return end
		local ret = nil
		for _, typeid, item in iterator(id, ...) do
			local known = restrictedCheck(test, typeid, item)
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
ns.Loot.Status.Toy = statusChecker(ns.Loot.IterToys, PlayerHasToy)
ns.Loot.Status.Mount = statusChecker(ns.Loot.IterMounts, PlayerHasMount)
ns.Loot.Status.Pet = statusChecker(ns.Loot.IterPets, PlayerHasPet)
ns.Loot.Status.Quest = statusChecker(ns.Loot.IterQuests, function(questid)
	return C_QuestLog.IsQuestFlaggedCompleted(questid) or C_QuestLog.IsOnQuest(questid)
end)
ns.Loot.Status.Transmog = statusChecker(ns.Loot.IterRegularLoot, function(itemid)
	if CanLearnAppearance(itemid) then
		return HasAppearance(itemid)
	end
end)

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
	toy = function(tooltip, i, toyid, itemdata)
		tooltip:SetHyperlink(("item:%d"):format(toyid))
	end,
	mount = function(tooltip, i, mountid, itemdata)
		if not C_MountJournal then return ns.Loot.Details.item(tooltip, i, itemdata[1], itemdata) end
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
	pet = function(tooltip, i, petid, itemdata)
		if not C_PetJournal then return ns.Loot.Details.item(tooltip, i, itemdata[1], itemdata) end
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
	item = function(tooltip, i, itemid, itemdata)
		tooltip:SetHyperlink(("item:%d"):format(itemid))
	end,
	restrictions = function(tooltip, itemdata)
		if not (itemdata and type(itemdata) == "table") then return end
		if itemdata.covenant then
			local covenant = C_Covenants.GetCovenantData(itemdata.covenant)
			local active = itemdata.covenant == C_Covenants.GetActiveCovenantID()
			tooltip:AddLine(
				ITEM_REQ_SKILL:format(COVENANT_COLORS[itemdata.covenant]:WrapTextInColorCode(covenant and covenant.name or covenants[itemdata.covenant])),
				(active and GREEN_FONT_COLOR or RED_FONT_COLOR):GetRGB()
			)
		end
		if itemdata.class then
			local active = select(2, UnitClass("player")) == itemdata.class
			tooltip:AddLine(
				ITEM_REQ_SKILL:format(RAID_CLASS_COLORS[itemdata.class]:WrapTextInColorCode(LOCALIZED_CLASS_NAMES_FEMALE[itemdata.class])),
				(active and GREEN_FONT_COLOR or RED_FONT_COLOR):GetRGB()
			)
		end
		if itemdata.requires then
			local active = core.conditions.check(itemdata.requires)
			tooltip:AddLine(
				core:RenderString(core.conditions.summarize(itemdata.requires)),
				(active and GREEN_FONT_COLOR or RED_FONT_COLOR):GetRGB()
			)
		end
		tooltip:Show()
	end,
}
ns.Loot.Details = Details

function ns.Loot.Details.UpdateTooltip(tooltip, id, only, ...)
	if not ns.Loot.GetLootTable(id, ...) then return end

	local toy = (not only or only == "toy") and ns.Loot.HasToys(id, ...)
	local mount = (not only or only == "mount") and ns.Loot.HasMounts(id, ...)
	local pet = (not only or only == "pet") and ns.Loot.HasPets(id, ...)
	local regular = (not only or only == "regular") and ns.Loot.HasRegularLoot(id, ...)

	if mount then
		for i, mountid, itemdata in ns.Loot.IterMounts(id, ...) do
			Details.mount(tooltip, i, mountid, itemdata)
			Details.restrictions(tooltip, itemdata)
		end
	end
	if pet then
		if mount then
			tooltip:AddLine("---")
		end
		for i, petid, itemdata in ns.Loot.IterPets(id, ...) do
			Details.pet(tooltip, i, petid, itemdata)
			Details.restrictions(tooltip, itemdata)
		end
	end
	local n = (pet or mount) and 2 or 1
	local itemtip
	if toy then
		for i, toyid, itemdata in ns.Loot.IterToys(id, ...) do
			itemtip = get_tooltip(itemtip or tooltip, n)
			if not itemtip then return end -- out of comparisons
			Details.toy(itemtip, n, toyid, itemdata)
			Details.restrictions(itemtip, itemdata)
			n = n + 1
		end
	end
	if regular then
		for i, itemid, itemdata in ns.Loot.IterRegularLoot(id, ...) do
			itemtip = get_tooltip(itemtip or tooltip, n)
			if not itemtip then return end -- out of comparisons
			Details.item(itemtip, n, itemid, itemdata)
			Details.restrictions(itemtip, itemdata)
			n = n + 1
		end
	end
end

local function requiresLabel(item)
	local ret = " "
	if type(item) == "table" then
		-- todo: faction?
		if item.covenant then
			local data = C_Covenants.GetCovenantData(item.covenant)
			-- local active = item.covenant == C_Covenants.GetActiveCovenantID()
			ret = ret .. PARENS_TEMPLATE:format(COVENANT_COLORS[item.covenant]:WrapTextInColorCode(data and data.name or covenants[item.covenant]))
		end
		if item.class then
			ret = ret .. PARENS_TEMPLATE:format(RAID_CLASS_COLORS[item.class]:WrapTextInColorCode(LOCALIZED_CLASS_NAMES_FEMALE[item.class]))
		end
	end
	if itemIsKnowable(item) then
		local known = itemIsKnown(item)
		if known or not itemRestricted(item) then
			-- don't want to show the x, but might as well show the check
			ret = ret .. CreateAtlasMarkup(known and ATLAS_CHECK or ATLAS_CROSS)
		end
	end
	return ret == " " and "" or ret
end

local Summary = {
	toy = function(tooltip, i, toyid, itemdata)
		if not C_ToyBox then return ns.Loot.Summary.item(tooltip, i, itemdata[1], itemdata) end
		local _, name, icon = C_ToyBox.GetToyInfo(toyid)
		local owned = PlayerHasToy(toyid)
		if name then
			tooltip:AddDoubleLine(
				i==1 and TOY or " ",
				"|T" .. icon .. ":0|t " .. name .. requiresLabel(itemdata),
				1, 1, 0,
				owned and 0 or 1, owned and 1 or 0, 0
			)
		else
			tooltip:AddDoubleLine(i==1 and TOY or " ", SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end,
	mount = function(tooltip, i, mountid, itemdata)
		if not C_MountJournal then return ns.Loot.Summary.item(tooltip, i, itemdata[1], itemdata) end
		local name, _, icon, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountid)
		if name then
			tooltip:AddDoubleLine(
				i==1 and MOUNT or " ",
				"|T" .. icon .. ":0|t " .. name .. requiresLabel(itemdata),
				1, 1, 0,
				isCollected and 0 or 1, isCollected and 1 or 0, 0
			)
		else
			tooltip:AddDoubleLine(i==1 and MOUNT or " ", SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end,
	pet = function(tooltip, i, petid, itemdata)
		if not C_PetJournal then return ns.Loot.Summary.item(tooltip, i, itemdata[1], itemdata) end
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
				"|T" .. icon .. ":0|t " .. (ITEM_SET_NAME):format(name, owned, limit) .. requiresLabel(itemdata),
				1, 1, 0,
				r, g, b
			)
		else
			tooltip:AddDoubleLine(i==1 and TOOLTIP_BATTLE_PET or " ", SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end,
	item = function(tooltip, i, itemid, itemdata)
		local name, link, quality, _, _, _, _, _, _, icon = GetItemInfo(itemid)
		if name then
			tooltip:AddDoubleLine(
				i==1 and ENCOUNTER_JOURNAL_ITEM or " ",
				"|T" .. icon .. ":0|t " .. name .. requiresLabel(itemdata),
				1, 1, 0,
				GetItemQualityColor(quality)
			)
		else
			tooltip:AddDoubleLine(i==1 and ENCOUNTER_JOURNAL_ITEM or " ", SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end,
}
ns.Loot.Summary = Summary

function ns.Loot.Summary.UpdateTooltip(tooltip, id, only_knowable, ...)
	if not ns.Loot.GetLootTable(id, ...) then
		return
	end

	local offset = 0
	local n = 0
	for i, mountid, itemdata in ns.Loot.IterMounts(id, ...) do
		n = n + 1
		Summary.mount(tooltip, i - offset, mountid, itemdata)
	end
	offset = n
	for i, toyid, itemdata in ns.Loot.IterToys(id, ...) do
		n = n + 1
		Summary.toy(tooltip, i - offset, toyid, itemdata)
	end
	offset = n
	for i, petid, itemdata in ns.Loot.IterPets(id, ...) do
		n = n + 1
		Summary.pet(tooltip, i - offset, petid, itemdata)
	end
	if not only_knowable then
		offset = n
		for i, itemid, itemdata in ns.Loot.IterRegularLoot(id, ...) do
			n = n + 1
			Summary.item(tooltip, i - offset, itemid, itemdata)
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
		GetItemButtonIconTexture(button):SetDesaturated(false)

		-- classic
		if not button.SetItem then
			function button:SetItem(item)
				local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(item)
				if itemID then
					self.itemID = itemID
					SetItemButtonTexture(button, icon)
				end
			end
			function button:GetItemID()
				return self.itemID
			end
			function button:GetItemLink()
				return select(2, GetItemInfo(self.itemID))
			end
		end
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
		local loot_tooltip = ns.Tooltip.Get("Loot")
		loot_tooltip:SetFrameStrata(self:GetFrameStrata())
		loot_tooltip:SetFrameLevel(self:GetFrameLevel() + 1)
		if self:GetCenter() > UIParent:GetCenter() then
			loot_tooltip:SetOwner(self, "ANCHOR_LEFT")
		else
			loot_tooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
		local link = self:GetItemLink()
		if link then
			loot_tooltip:SetHyperlink(self:GetItemLink())
		else
			loot_tooltip:AddLine(RETRIEVING_ITEM_INFO, 1, 0, 0)
		end
		ns.Loot.Details.restrictions(loot_tooltip, self.lootdata)
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
		AddItem = function(self, itemid, item)
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
				if type(item) == "table" then
					button.lootdata = item
					if item.count then
						button:SetItemButtonCount(item.count)
					end
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
				end
				if itemIsKnowable(item) then
					local known = itemIsKnown(item)
					if known or not itemRestricted(item) then
						-- don't show the x for restricted items
						button.KnownIcon:SetAtlas(known and ATLAS_CHECK or ATLAS_CROSS)
						button.KnownIcon:Show()
					end
				end
				if not suitable(item) then
					GetItemButtonIconTexture(button):SetDesaturated(true)
				end
			end

			button:Show()
			return button
		end,
		AddLoot = function(self, loot)
			for _, item in ipairs(loot) do
				local itemid = type(item) == "table" and item[1] or item
				if itemid then
					self:AddItem(itemid, item)
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

	function ns.Loot.Window.ShowForMob(id, independent, ...)
		if not ns.Loot.GetLootTable(id, ...) then
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
		window:AddLoot(ns.Loot.GetLootTable(id, ...))
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
