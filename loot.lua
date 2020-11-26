local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local Debug = core.Debug
local DebugF = core.DebugF

function ns:HasLoot(id)
	if not (id and ns.mobdb[id]) then
		return false
	end
	return ns.mobdb[id].mount or ns.mobdb[id].toy or ns.mobdb[id].pet
end

function ns:LootStatus(id)
	if not id or not ns.mobdb[id] then
		return
	end

	local toy = ns.mobdb[id].toy and PlayerHasToy(ns.mobdb[id].toy)
	local mount = ns.mobdb[id].mount and select(11, C_MountJournal.GetMountInfoByID(ns.mobdb[id].mount))
	local pet = ns.mobdb[id].pet and (C_PetJournal.GetNumCollectedInfo(ns.mobdb[id].pet) > 0)

	return toy, mount, pet
end

function ns:UpdateTooltipWithLootDetails(tooltip, id, only)
	if not (id and ns.mobdb[id]) then
		return
	end

	local toy = ns.mobdb[id].toy and (not only or only == "toy")
	local mount = ns.mobdb[id].mount and (not only or only == "mount")
	local pet = ns.mobdb[id].pet and (not only or only == "pet")

	if toy then
		tooltip:SetHyperlink(("item:%d"):format(ns.mobdb[id].toy))
	end
	if mount then
		if toy then
			tooltip:AddLine("---")
		end
		local name, spellid, texture, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(ns.mobdb[id].mount)
		local _, description, source = C_MountJournal.GetMountInfoExtraByID(ns.mobdb[id].mount)

		tooltip:AddLine(name)
		tooltip:AddTexture(texture)
		tooltip:AddLine(description, 1, 1, 1, true)
		tooltip:AddLine(source)
		if isCollected then
			tooltip:AddLine(USED, 1, 0, 0)
		end
	end
	if pet then
		if toy or mount then
			tooltip:AddLine('---')
		end
		local name, texture, _, mobid, source, description = C_PetJournal.GetPetInfoBySpeciesID(ns.mobdb[id].pet)
		local owned, limit = C_PetJournal.GetNumCollectedInfo(ns.mobdb[id].pet)
		tooltip:AddLine(name)
		tooltip:AddTexture(texture)
		tooltip:AddLine(description, 1, 1, 1, true)
		tooltip:AddLine(source)
		tooltip:AddLine(ITEM_PET_KNOWN:format(owned, limit))
	end
end

function ns:UpdateTooltipWithLootSummary(tooltip, id)
	if not (id and ns.mobdb[id]) then
		return
	end

	if ns.mobdb[id].mount then
		local name, _, icon, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(ns.mobdb[id].mount)
		if name then
			tooltip:AddDoubleLine(
				MOUNT,
				"|T" .. icon .. ":0|t " .. name,
				1, 1, 0,
				isCollected and 0 or 1, isCollected and 1 or 0, 0
			)
		else
			tooltip:AddDoubleLine(MOUNT, SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end
	if ns.mobdb[id].pet then
		local name, icon = C_PetJournal.GetPetInfoBySpeciesID(ns.mobdb[id].pet)
		local owned, limit = C_PetJournal.GetNumCollectedInfo(ns.mobdb[id].pet)
		if name then
			local r, g, b = 1, 0, 0
			if owned == limit then
				r, g, b = 0, 1, 0
			elseif owned > 0 then
				r, g, b = 1, 1, 0
			end
			tooltip:AddDoubleLine(
				TOOLTIP_BATTLE_PET,
				"|T" .. icon .. ":0|t " .. (ITEM_SET_NAME):format(name, owned, limit),
				1, 1, 0,
				r, g, b
			)
		else
			tooltip:AddDoubleLine(TOOLTIP_BATTLE_PET, SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end
	if ns.mobdb[id].toy then
		local _, name, icon = C_ToyBox.GetToyInfo(ns.mobdb[id].toy)
		local owned = PlayerHasToy(ns.mobdb[id].toy)
		if name then
			tooltip:AddDoubleLine(
				TOY,
				"|T" .. icon .. ":0|t " .. name,
				1, 1, 0,
				owned and 0 or 1, owned and 1 or 0, 0
			)
		else
			tooltip:AddDoubleLine(TOY, SEARCH_LOADING_TEXT, 1, 1, 0, 0, 1, 1)
		end
	end
end
