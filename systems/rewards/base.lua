local myname, ns = ...

local ATLAS_CHECK, ATLAS_CROSS = "common-icon-checkmark", "common-icon-redx"

ns.rewards = {}

-- Base reward specification, which should never really be used:
ns.rewards.Reward = ns.Class({
	classname = "Reward",
	note = false,
	requires = false,
	-- todo: consolidate these somehow?
	quest = false,
	questComplete = false,
	warband = false,
})
local Reward = ns.rewards.Reward

Reward.NOTABLE_COLOR = CreateColor(0, 0.8, 1)
Reward.SEARCHING_COLOR = CreateColor(0, 1, 1)

function Reward:init(id, extra)
	self.id = id
	if extra then
		for k, v in pairs(extra) do
			if self[k] == false then
				self[k] = v
			end
		end
	end
end
function Reward:Name(color) return UNKNOWN end
function Reward:Icon() return 134400 end -- question mark
function Reward:Obtained(ignore_notable)
	local result
	if self.quest then
		if C_QuestLog.IsQuestFlaggedCompleted(self.quest) or C_QuestLog.IsOnQuest(self.quest) then
			return true
		end
		if self.warband and C_QuestLog.IsQuestFlaggedCompletedOnAccount(self.quest) then
			return true
		end
		if ignore_notable or ns.db.quest_notable then
			result = false
		end
	end
	if self.questComplete then
		if C_QuestLog.IsQuestFlaggedCompleted(self.questComplete) then
			return true
		end
		if ignore_notable or ns.db.quest_notable then
			result = false
		end
	end
	return result
end
function Reward:Notable()
	-- Is it knowable and not obtained?
	return self:MightDrop() and (self:Obtained() == false)
end
function Reward:Available()
	if self.requires and not ns.conditions.check(self.requires) then
		return false
	end
	-- TODO: profession recipes?
	return true
end
function Reward:MightDrop() return self:Available() end
function Reward:SetTooltip(tooltip) return false end
function Reward:AddToTooltip(tooltip)
	local r, g, b = self:TooltipNameColor():GetRGB()
	local lr, lg, lb = self:TooltipLabelColor():GetRGB()
	tooltip:AddDoubleLine(
		self:TooltipLabel(),
		self:TooltipName(),
		lr, lg, lb,
		r, g, b
	)
end
function Reward:AddToItemButton(button)
	SetItemButtonTexture(button, self:Icon())
end
function Reward:TooltipName()
	local name = self:Name(true)
	local icon = self:Icon()
	if not name then
		name = SEARCH_LOADING_TEXT
	end
	if self.requires then
		name = TEXT_MODE_A_STRING_VALUE_TYPE:format(name, ns.conditions.summarize(self.requires, true))
	end
	if self.note then
		name = TEXT_MODE_A_STRING_VALUE_TYPE:format(name, self.note)
	end
	return ("%s%s%s"):format(
		(icon and (ns.quick_texture_markup(icon) .. " ") or ""),
		ns.render_string(name),
		self:ObtainedTag() or ""
	)
end
function Reward:TooltipNameColor()
	if not self:Name() then
		return self.SEARCHING_COLOR
	end
	return NORMAL_FONT_COLOR
end
function Reward:TooltipLabel() return UNKNOWN end
function Reward:TooltipLabelColor()
	if ns.db.show_npcs_emphasizeNotable and self:Notable() then
		return self.NOTABLE_COLOR
	end
	return NORMAL_FONT_COLOR
end
function Reward:ObtainedTag()
	local known = self:Obtained(true) -- ignore_notable
	if known == nil then return end
	return " " .. CreateAtlasMarkup(known and ATLAS_CHECK or ATLAS_CROSS)
end
function Reward:Cache() end

ns.rewards.Currency = Reward:extends({classname="Currency"})
function ns.rewards.Currency:init(id, amount, ...)
	self:super("init", id, ...)
	self.amount = amount
	self.faction = C_CurrencyInfo.GetFactionGrantedByCurrency(id)
	-- This effect is a little specialized around the rep drops from rares
	-- in War Within; will need to revisit it if there's future warband
	-- currency rewards that are character-gated not account-gated...
	self.warband = self.faction and C_Reputation.IsAccountWideReputation(self.faction)
end
function ns.rewards.Currency:Name(color)
	local info = C_CurrencyInfo.GetBasicCurrencyInfo(self.id, self.amount)
	if info and info.name then
		local name = color and ITEM_QUALITY_COLORS[info.quality].color:WrapTextInColorCode(info.name) or info.name
		return (self.amount and self.amount > 1) and
			("%s x %d"):format(name, self.amount) or
			name
	end
	return self:Super("Name", color)
end
function ns.rewards.Currency:Icon()
	local info = C_CurrencyInfo.GetBasicCurrencyInfo(self.id)
	if info and info.icon then
		return info.icon
	end
end
function ns.rewards.Currency:Notable()
	if self.faction then
		-- if this is faction-reputation, consider it non-notable once your reputation is maxed out
		-- TODO: revisit this for paragon reps later?
		if C_Reputation.IsMajorFaction(self.faction) then
			if C_MajorFactions.HasMaximumRenown(self.faction) then
				return false
			end
		else
			local data = C_Reputation.GetFactionDataByID(self.faction)
			if data and data.currentReactionThreshold == data.nextReactionThreshold then
				return false
			end
		end
	end
	return self:super("Notable")
end
function ns.rewards.Currency:TooltipLabel()
	return self.faction and REPUTATION or CURRENCY
end
function ns.rewards.Currency:SetTooltip(tooltip)
	if tooltip.SetCurrencyByID then
		tooltip:SetCurrencyByID(self.id, self.amount)
	else
		tooltip:SetHyperlink(C_CurrencyInfo.GetCurrencyLink(self.id, self.amount))
	end
end
function ns.rewards.Currency:AddToItemButton(button, ...)
	self:super("AddToItemButton", button, ...)
	local info = C_CurrencyInfo.GetBasicCurrencyInfo(self.id, self.amount)
	if info then
		SetItemButtonQuality(button, info.quality)
	end
	-- could use info.displayAmount here, but I think this makes more sense:
	SetItemButtonCount(button, self.amount)
end

ns.rewards.BattlePet = Reward:extends({classname="BattlePet",
	COLORS={
		[1] = CreateColor(0, 0.66, 1), -- Humanoid
		[2] = CreateColor(0, 0.66, 0), -- Dragonkin
		[3] = CreateColor(0.8, 0.8, 0.3), -- Flying
		[4] = CreateColor(0.6, 0.4, 0.4), -- Undead
		[5] = CreateColor(0.5, 0.33, 0.25), -- Critter
		[6] = CreateColor(0.75, 0.5, 1), -- Magic
		[7] = CreateColor(1, 0.5, 0), -- Elemental
		[8] = CreateColor(0.8, 0.15, 0.15), -- Beast
		[9] = CreateColor(0, 0.6, 0.66), -- Aquatic
		[10] = CreateColor(0.6, 0.6, 0.5), -- Mechanical
	},
})
function ns.rewards.BattlePet:Name(color)
	local name, texture, battlePetTypeID, mobID, source, description = C_PetJournal.GetPetInfoBySpeciesID(self.id)
	if name then
		if color and self.COLORS[battlePetTypeID] then
			name = self.COLORS[battlePetTypeID]:WrapTextInColorCode(name)
		end
		return name
	end
	return self:super("Name", color)
end
function ns.rewards.BattlePet:Icon()
	local name, texture, battlePetTypeID, mobID, source, description = C_PetJournal.GetPetInfoBySpeciesID(self.id)
	if battlePetTypeID and PET_TYPE_SUFFIX[battlePetTypeID] then
		return "Interface\\Icons\\Pet_Type_"..PET_TYPE_SUFFIX[battlePetTypeID]
	end
	return texture
end
function ns.rewards.BattlePet:TooltipLabel() return TOOLTIP_BATTLE_PET end
function ns.rewards.BattlePet:Obtained(...)
	if self:super("Obtained", ...) == false then return false end
	return C_PetJournal.GetNumCollectedInfo(self.id) > 0
end
function ns.rewards.BattlePet:Notable(...) return ns.db.pet_notable and self:super("Notable", ...) end
function ns.rewards.BattlePet:ObtainedTag(...)
	local owned, limit = C_PetJournal.GetNumCollectedInfo(self.id)
	if owned ~= 0 and owned ~= limit then
		-- ITEM_PET_KNOWN is "Collected (%d/%d)" which is a bit long for this
		return " " .. GENERIC_FRACTION_STRING:format(owned, limit) .. self:super("ObtainedTag", ...)
	end
	return self:super("ObtainedTag", ...)
end
function ns.rewards.BattlePet:SetTooltip(tooltip, ...)
	local name, texture, battlePetTypeID, mobID, source, description = C_PetJournal.GetPetInfoBySpeciesID(self.id)
	if not name then
		tooltip:AddLine("pet:" .. self.id)
		tooltip:AddLine(SEARCH_LOADING_TEXT, 0, 1, 1)
		return
	end
	local owned, limit = C_PetJournal.GetNumCollectedInfo(self.id)
	local r, g, b = (self.COLORS[battlePetTypeID] or NORMAL_FONT_COLOR):GetRGB()
	tooltip:AddDoubleLine(name, PET_TYPE_SUFFIX[battlePetTypeID] or UNKNOWN, r, g, b, r, g, b)
	tooltip:AddTexture(texture)
	tooltip:AddLine(description, 1, 1, 1, true)
	tooltip:AddLine(source)
	tooltip:AddLine(ITEM_PET_KNOWN:format(owned, limit))
end
function ns.rewards.BattlePet:Cache()
	self:super("Cache")
	if C_PetJournal then C_PetJournal.GetPetInfoBySpeciesID(self.id) end
end