local myname, ns = ...

local materials = {
	[Enum.ItemArmorSubclass.Cloth] = true,
	[Enum.ItemArmorSubclass.Leather] = true,
	[Enum.ItemArmorSubclass.Mail] = true,
	[Enum.ItemArmorSubclass.Plate] = true,
}

ns.rewards.Item = ns.rewards.Reward:extends({classname="Item"})

ns.rewards.Item.COSMETIC_COLOR = CreateColor(1, 0.5, 1)
ns.rewards.Item.NOTABLE_TRANSMOG_COLOR = CreateColor(1, 0, 1)

function ns.rewards.Item:Name(color)
	local name, link = C_Item.GetItemInfo(self.id)
	if link then
		return color and link:gsub("[%[%]]", "") or name
	end
end
function ns.rewards.Item:TooltipLabel()
	local _, itemType, itemSubtype, equipLoc, icon, classID, subclassID = C_Item.GetItemInfoInstant(self.id)
	local label = ENCOUNTER_JOURNAL_ITEM
	if classID == Enum.ItemClass.Armor and subclassID ~= Enum.ItemArmorSubclass.Shield then
		label = _G[equipLoc] or label
		if materials[subclassID] and equipLoc ~= "INVTYPE_CLOAK" then
			label = TEXT_MODE_A_STRING_VALUE_TYPE:format(label, itemSubtype)
		end
	else
		label = itemSubtype
	end
	if label and ns.IsCosmeticItem(self.id) then
		label = TEXT_MODE_A_STRING_VALUE_TYPE:format(label, self.COSMETIC_COLOR:WrapTextInColorCode(ITEM_COSMETIC))
	end
	return label
end
function ns.rewards.Item:TooltipLabelColor()
	if ns.db.show_npcs_emphasizeNotable and self:Notable() and self.CanLearnAppearance(self.id) then
		return self.NOTABLE_TRANSMOG_COLOR
	end
	return self:super('TooltipLabelColor')
end
function ns.rewards.Item:Icon() return (select(5, C_Item.GetItemInfoInstant(self.id))) end
function ns.rewards.Item:Obtained(ignore_notable, ...)
	local result = self:super("Obtained", ignore_notable, ...)
	if ns.CLASSICERA then return result and GetItemCount(self.id, true) > 0 end
	if not result and (ignore_notable or ns.db.transmog_notable) and self.CanLearnAppearance(self.id) then
		return self.HasAppearance(self.id, ns.db.transmog_specific)
	end
	return result
end
function ns.rewards.Item:IsTransmog()
	return self.CanLearnAppearance(self.id)
end
function ns.rewards.Item:MightDrop()
	-- We think an item might drop if it either has no spec information, or
	-- returns any spec information at all (because the game will only give
	-- specs for the current character)
	-- can't pass in a reusable table for the second argument because it changes the no-data case
	local specTable = C_Item.GetItemSpecInfo(self.id)
	-- Some cosmetic items seem to be flagged as not dropping for any spec. I
	-- could only confirm this for some cosmetic back items but let's play it
	-- safe and say that any cosmetic item can drop regardless of what the
	-- spec info says...
	if specTable and #specTable == 0 and not ns.IsCosmeticItem(self.id) then
		return false
	end
	-- parent catches covenants / classes / etc
	return self:super("MightDrop")
end
function ns.rewards.Item:SetTooltip(tooltip)
	tooltip:SetItemByID(self.id)
end
function ns.rewards.Item:AddToItemButton(button)
	button:SetItem(self.id)
	if self.count or self.amount then
		button:SetItemButtonCount(self.count or self.amount)
	end
end
function ns.rewards.Item:Cache()
	C_Item.RequestLoadItemDataByID(self.id)
end

do
	local brokenItems = {
		-- itemid : {appearanceid, sourceid}
		[153268] = {25124, 90807}, -- Enclave Aspirant's Axe
		[153316] = {25123, 90885}, -- Praetor's Ornamental Edge
	}
	local function GetAppearanceAndSource(itemLinkOrID)
		local itemID = C_Item.GetItemInfoInstant(itemLinkOrID)
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

	local canLearnCache = {}
	function ns.rewards.Item.CanLearnAppearance(itemLinkOrID)
		if not _G.C_Transmog then return false end
		local itemID = C_Item.GetItemInfoInstant(itemLinkOrID)
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
	ns.run_caches.appearances = {}
	function ns.rewards.Item.HasAppearance(itemLinkOrID, specific)
		local itemID = C_Item.GetItemInfoInstant(itemLinkOrID)
		if not itemID then return end
		if ns.run_caches.appearances[itemID] ~= nil then
			return ns.run_caches.appearances[itemID]
		end
		if hasAppearanceCache[itemID] ~= nil then
			-- We cache unchanging things: true or false-because-not-knowable
			-- *Technically* this could persist a false-positive if you obtain something and then trade/refund it
			ns.run_caches.appearances[itemID] = hasAppearanceCache[itemID]
			return hasAppearanceCache[itemID]
		end
		if PlayerHasTransmogByItemInfo(itemLinkOrID) then
			-- short-circuit further checks because this specific item is known
			hasAppearanceCache[itemID] = true
			return true
		end
		local appearanceID, sourceID = GetAppearanceAndSource(itemLinkOrID)
		if not appearanceID then
			-- This just isn't knowable according to the API
			hasAppearanceCache[itemID] = false
			return
		end
		local fromCurrentItem = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
		if fromCurrentItem then
			-- It might *also* be from another item, but we don't care or need to find out
			hasAppearanceCache[itemID] = true
			return true
		end
		-- Although this isn't known, its appearance might be known from another item
		if specific then
			ns.run_caches.appearances[itemID] = false
			return false
		end
		local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
		if not sources then return end
		for _, otherSourceID in ipairs(sources) do
			if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(otherSourceID) then
				hasAppearanceCache[itemID] = true
				return true
			end
		end
		ns.run_caches.appearances[itemID] = false
		return false
	end
end

-- These are all Items becuase the loot is an actual item, but they're very
-- overridden to support whatever thing that item teaches you:

ns.rewards.Toy = ns.rewards.Item:extends({classname="Toy"})
function ns.rewards.Toy:TooltipLabel() return TOY end
function ns.rewards.Toy:Obtained(...)
	if ns.CLASSICERA then return GetItemCount(self.id, true) > 0 end
	return self:super("Obtained", ...) ~= false and PlayerHasToy(self.id)
end
function ns.rewards.Toy:Notable(...) return ns.db.toy_notable and self:super("Notable", ...) end
function ns.rewards.Toy:Cache()
	self:super("Cache")
	PlayerHasToy(self.id)
end

ns.rewards.Mount = ns.rewards.Item:extends({classname="Mount"})
function ns.rewards.Mount:init(id, mountid, ...)
	self:super("init", id, ...)
	self.mountid = mountid
end
function ns.rewards.Mount:MountID()
	if not self.mountid then
		self.mountid = C_MountJournal and C_MountJournal.GetMountFromItem and C_MountJournal.GetMountFromItem(self.id)
	end
	return self.mountid
end
function ns.rewards.Mount:TooltipLabel() return MOUNT end
function ns.rewards.Mount:Obtained(...)
	if self:super("Obtained", ...) == false then return false end
	if ns.CLASSICERA then return GetItemCount(self.id, true) > 0 end
	if not _G.C_MountJournal then return false end
	return self:MountID() and (select(11, C_MountJournal.GetMountInfoByID(self:MountID())))
end
function ns.rewards.Mount:Notable(...) return ns.db.mount_notable and self:super("Notable", ...) end
function ns.rewards.Mount:SetTooltip(tooltip, ...)
	if not (C_MountJournal and self:MountID()) then
		return self:super("SetTooltip", tooltip, ...)
	end
	local name, spellid, texture, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(self:MountID())
	if not name then
		tooltip:AddLine("mount:" .. self:MountID())
		tooltip:AddLine(SEARCH_LOADING_TEXT, 0, 1, 1)
		return
	end
	local _, description, source = C_MountJournal.GetMountInfoExtraByID(self:MountID())

	tooltip:AddLine(name)
	tooltip:AddTexture(texture)
	tooltip:AddLine(description, 1, 1, 1, true)
	tooltip:AddLine(source)
	if isCollected then
		tooltip:AddLine(USED, 1, 0, 0)
	end
end
function ns.rewards.Mount:Cache()
	self:super("Cache")
	if C_MountJournal and self:MountID() then C_MountJournal.GetMountInfoByID(self:MountID()) end
end

ns.rewards.Pet = ns.rewards.Item:extends({classname="Pet"})
function ns.rewards.Pet:init(id, petid, ...)
	self:super("init", id, ...)
	self.petid = petid
end
function ns.rewards.Pet:PetID()
	if not self.petid then
		self.petid = C_PetJournal and select(13, C_PetJournal.GetPetInfoByItemID(self.id))
	end
	return self.petid
end
function ns.rewards.Pet:TooltipLabel() return TOOLTIP_BATTLE_PET end
function ns.rewards.Pet:Obtained(...)
	if self:super("Obtained", ...) == false then return false end
	if ns.CLASSICERA then return GetItemCount(self.id, true) > 0 end
	return self:PetID() and C_PetJournal.GetNumCollectedInfo(self:PetID()) > 0
end
function ns.rewards.Pet:Notable(...) return ns.db.pet_notable and self:super("Notable", ...) end
function ns.rewards.Pet:ObtainedTag(...)
	if self:PetID() then
		local owned, limit = C_PetJournal.GetNumCollectedInfo(self:PetID())
		if owned ~= 0 and owned ~= limit then
			-- ITEM_PET_KNOWN is "Collected (%d/%d)" which is a bit long for this
			return " " .. GENERIC_FRACTION_STRING:format(owned, limit) .. self:super("ObtainedTag", ...)
		end
	end
	return self:super("ObtainedTag", ...)
end
function ns.rewards.Pet:SetTooltip(tooltip, ...)
	if not (C_PetJournal and self:PetID()) then
		return self:super("SetTooltip", tooltip, ...)
	end
	local name, texture, _, mobid, source, description = C_PetJournal.GetPetInfoBySpeciesID(self:PetID())
	if not name then
		tooltip:AddLine("pet:" .. self:PetID())
		tooltip:AddLine(SEARCH_LOADING_TEXT, 0, 1, 1)
		return
	end
	local owned, limit = C_PetJournal.GetNumCollectedInfo(self:PetID())
	tooltip:AddLine(name)
	tooltip:AddTexture(texture)
	tooltip:AddLine(description, 1, 1, 1, true)
	tooltip:AddLine(source)
	tooltip:AddLine(ITEM_PET_KNOWN:format(owned, limit))
end
function ns.rewards.Pet:Cache()
	self:super("Cache")
	if self:PetID() and C_PetJournal then C_PetJournal.GetPetInfoBySpeciesID(self:PetID()) end
end

ns.rewards.Set = ns.rewards.Item:extends({classname="Set"})
function ns.rewards.Set:init(id, setid, ...)
	self:super("init", id, ...)
	self.setid = setid
end
function ns.rewards.Set:Name()
	local info = C_TransmogSets.GetSetInfo(self.setid)
	if info then
		return info.name
	end
	return self:Super("Name")
end
function ns.rewards.Set:TooltipLabel() return WARDROBE_SETS end
function ns.rewards.Set:Obtained(...)
	if not self:super("Obtained", ...) then return false end
	if ns.CLASSIC then return GetItemCount(self.id, true) > 0 end
	local info = C_TransmogSets.GetSetInfo(self.setid)
	if info then
		if info.collected then return true end
		-- we want to fall through and return nil for sets the current class can't learn:
		if info.classMask and bit.band(info.classMask, ns.playerClassMask) == ns.playerClassMask then return false end
	end
end
function ns.rewards.Set:ObtainedTag()
	local info = C_TransmogSets.GetSetInfo(self.setid)
	if not info then return end
	if not info.collected then
		local sources = C_TransmogSets.GetSetPrimaryAppearances(self.setid)
		if sources and #sources > 0 then
			local numKnown = 0
			for _, source in pairs(sources) do
				if source.collected then
					numKnown = numKnown + 1
				end
			end
			return RED_FONT_COLOR:WrapTextInColorCode(GENERIC_FRACTION_STRING:format(numKnown, #sources))
		end
	end
	return self:super("ObtainedTag")
end

ns.rewards.Recipe = ns.rewards.Item:extends{classname="Recipe"}
function ns.rewards.Recipe:init(id, spellid, ...)
	self:super("init", id, ...)
	self.spellid = spellid
end
function ns.rewards.Recipe:Obtained(...)
	if self:super("Obtained", ...) then
		-- covers quests etc
		return true
	end
	-- can't use the tradeskill functions + the recipe-spell because that data's only available after the tradeskill window has been opened...
	local info = C_TooltipInfo.GetItemByID(self.id)
	if info then
		for _, line in ipairs(info.lines) do
			if line.leftText and string.match(line.leftText, _G.ITEM_SPELL_KNOWN) then
				return true
			end
		end
	end
	return false
end
function ns.rewards.Recipe:Cache()
	self:super("Cache")
	C_Spell.RequestLoadSpellData(self.spellid)
end
