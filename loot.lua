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

function ns:HasLoot(id)
	if not (id and ns.mobdb[id]) then
		return false
	end
	return ns.mobdb[id].mount or ns.mobdb[id].toy or ns.mobdb[id].pet
end

function ns:LootStatusToy(id)
	if not id or not ns.mobdb[id] then return end
	return ns.mobdb[id].toy and all(PlayerHasToy, safeunpack(ns.mobdb[id].toy))
end
function ns:LootStatusMount(id)
	if not id or not ns.mobdb[id] then return end
	return ns.mobdb[id].mount and all(PlayerHasMount, safeunpack(ns.mobdb[id].mount))
end
function ns:LootStatusPet(id)
	if not id or not ns.mobdb[id] then return end
	return ns.mobdb[id].pet and all(PlayerHasPet, safeunpack(ns.mobdb[id].pet))
end
function ns:LootStatus(id)
	if not id or not ns.mobdb[id] then
		return
	end
	return ns:LootStatusToy(id), ns:LootStatusMount(id), ns:LootStatusPet(id)
end

local function tooltip_apply(tooltip, func, ...)
	for i=1,select("#", ...) do
		func(tooltip, i, (select(i, ...)))
	end
end

local Details = {
	toy = function(tooltip, i, toyid)
		tooltip:SetHyperlink(("item:%d"):format(toyid))
	end,
	mount = function(tooltip, i, mountid)
		local name, spellid, texture, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountid)
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
		local owned, limit = C_PetJournal.GetNumCollectedInfo(petid)
		tooltip:AddLine(name)
		tooltip:AddTexture(texture)
		tooltip:AddLine(description, 1, 1, 1, true)
		tooltip:AddLine(source)
		tooltip:AddLine(ITEM_PET_KNOWN:format(owned, limit))
	end,
}

function ns:UpdateTooltipWithLootDetails(tooltip, id, only)
	if not (id and ns.mobdb[id]) then
		return
	end

	local toy = ns.mobdb[id].toy and (not only or only == "toy")
	local mount = ns.mobdb[id].mount and (not only or only == "mount")
	local pet = ns.mobdb[id].pet and (not only or only == "pet")

	if toy then
		tooltip_apply(tooltip, Details.toy, safeunpack(ns.mobdb[id].toy))
	end
	if mount then
		if toy then
			tooltip:AddLine("---")
		end
		tooltip_apply(tooltip, Details.mount, safeunpack(ns.mobdb[id].mount))
	end
	if pet then
		if toy or mount then
			tooltip:AddLine('---')
		end
		tooltip_apply(tooltip, Details.pet, safeunpack(ns.mobdb[id].pet))
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

function ns:UpdateTooltipWithLootSummary(tooltip, id)
	if not (id and ns.mobdb[id]) then
		return
	end

	if ns.mobdb[id].mount then
		tooltip_apply(tooltip, Summary.mount, safeunpack(ns.mobdb[id].mount))
	end
	if ns.mobdb[id].pet then
		tooltip_apply(tooltip, Summary.pet, safeunpack(ns.mobdb[id].pet))
	end
	if ns.mobdb[id].toy then
		tooltip_apply(tooltip, Summary.toy, safeunpack(ns.mobdb[id].toy))
	end
end
