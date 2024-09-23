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
