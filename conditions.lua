local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

-- Keep this in sync with my handynotes handlers...

local GetPlayerAuraBySpellID = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID or _G.GetPlayerAuraBySpellID

local Base = {
	Initialize = function() end,
}
local Class = function(def)
	local class = def or {}
	local class_meta = {
		__index = function(_, index)
			local class_walked = class
			repeat
				local val = rawget(class_walked, index)
				if val ~= nil then return val end
				class_walked = class_walked.__parent
			until class_walked == nil
		end,
	}
	setmetatable(class, {
		__call = function(_, ...)
			local self = {}
			setmetatable(self, class_meta)
			self:Initialize(...)
			return self
		end,
		-- inheritance, this is it:
		__index = def.__parent or Base,
	})

	return class
end

ns.conditions = {}

--[[
API:
condition = ns.conditions.GarrisonTalent(1912, 4)

condition:Matched() -> bool
condition:Label() -> string
]]

local Condition = Class{
	Initialize = function(self, id) self.id = id end,
	Label = function(self) return ('{%s:%d}'):format(self.type, self.id) end,
	Matched = function() return false end,
}
local RankedCondition = Class{
	__parent = Condition,
	Initialize = function(self, id, rank)
		self.id = id
		self.rank = rank
	end,
	Label = function(self)
		-- this relies greatly on render_string working for self.type
		local label = Condition.Label(self)
		if self.rank then
			return AZERITE_ESSENCE_TOOLTIP_NAME_RANK:format(label, self.rank)
		end
		return label
	end
}
local Negated = function(parent) return {
	__parent = parent,
	Matched = function(self) return not parent.Matched(self) end,
} end

ns.conditions.Achievement = Class{
	__parent = Condition,
	type = 'achievement',
	Matched = function(self) return (select(4, GetAchievementInfo(self.id))) end,
}
ns.conditions.AchievementIncomplete = Class(Negated(ns.conditions.Achievement))

ns.conditions.AuraActive = Class{
	__parent = Condition,
	type = 'spell',
	Matched = function(self) return GetPlayerAuraBySpellID(self.id) end,
}
ns.conditions.AuraInactive = Class(Negated(ns.conditions.AuraActive))

ns.conditions.SpellKnown = Class{
	__parent = Condition,
	type = 'spell',
	Matched = function(self) return IsSpellKnown(self.id) end,
}

ns.conditions.Profession = Class{
	-- See https://wowpedia.fandom.com/wiki/TradeSkillLineID for IDs
	-- TODO: make work in Classic? Whole different API.
	__parent = RankedCondition,
	type = "profession",
	Matched = function(self)
		-- The problem: this is only reliable for skill levels after the trade skill has been opened
		local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(self.id)
		if not (info and info.skillLevel) then return false end
		if info.skillLevel > 0 then
			-- we have good data
			return info.skillLevel >= (self.rank or 1)
		end
		-- we need to start making guesses
		return self:CheckProfessions(info, GetProfessions())
	end,
	CheckProfessions = function(self, info, ...)
		for i = 1, select("#", ...) do
			if self:CheckProfession(info, select(i, ...)) then
				return true
			end
		end
		return false
	end,
	CheckProfession = function(self, info, professionid)
		if not professionid then return end
		local skillName, _, skillLevel, maxSkillLevel, _, _, skillLineID, _, _, _, displayName = GetProfessionInfo(professionid)
		if info.professionID == skillLineID then
			-- This is the exact skill!
			return skillLevel >= (self.rank or 1)
		end
		if info.parentProfessionID == skillLineID then
			-- The overall skill is known
			if displayName == info.professionName then
				-- This is the highest expansion skill currently, so the reported skill level is correct
				return skillLevel >= (self.rank or 1)
			end
			-- This is the wrong expansion skill... so ignore the rank check and just claim we know it
			-- TODO: this the worst case, improve it somehow?
			return true
		end
	end,
}

ns.conditions.Covenant = Class{
	__parent = RankedCondition,
	type = 'covenant',
	Matched = function(self)
		if self.id ~= C_Covenants.GetActiveCovenantID() then
			return false
		end
		if self.rank then
			return self.rank <= C_CovenantSanctumUI.GetRenownLevel()
		end
		return true
	end,
}

ns.conditions.Faction = Class{
	__parent = RankedCondition,
	type = 'faction',
	Matched = function(self)
		local name, standingid, _
		if C_Reputation and C_Reputation.GetFactionDataByID then
			local info = C_Reputation.GetFactionDataByID(self.id)
			if info and info.name then
				name = info.name
				standingid = info.currentstanding
			end
		elseif GetFactionInfoByID then
			name, _, standingid = GetFactionInfoByID(self.id)
		end
		if name and standingid then
			return self.rank <= standingid
		end
	end,
}

ns.conditions.MajorFaction = Class{
	__parent = RankedCondition,
	type = 'majorfaction',
	Matched = function(self)
		local info = C_MajorFactions.GetMajorFactionData(self.id)
		if info then
			if self.rank then
				return self.rank <= info.renownLevel
			end
			return info.isUnlocked
		end
	end,
}

ns.conditions.GarrisonTalent = Class{
	__parent = Condition,
	type = 'garrisontalent',
	Initialize = function(self, id, rank)
		self.id = id
		self.rank = rank
	end,
	Label = function(self)
		local info = C_Garrison.GetTalentInfo(self.id)
		local name = info and info.name and ("{garrisontalent:%d}"):format(self.id) or UNKNOWN
		if self.rank then
			return AZERITE_ESSENCE_TOOLTIP_NAME_RANK:format(name, self.rank)
		end
		return name
	end,
	Matched = function(self)
		local info = C_Garrison.GetTalentInfo(self.id)
		return info and info.researched and (not self.rank or info.talentRank >= self.rank)
	end
}

ns.conditions.Item = Class{
	__parent = Condition,
	type = 'item',
	Initialize = function(self, id, count)
		self.id = id
		self.count = count
	end,
	Label = function(self)
		if self.count and self.count > 1 then
			return ("{item:%d} x%d"):format(self.id, self.count)
		end
		return Condition.Label(self)
	end,
	Matched = function(self) return C_Item.GetItemCount(self.id, true) >= (self.count or 1) end,
}

ns.conditions.Toy = Class{
	__parent = ns.conditions.Item,
	Matched = function(self) return PlayerHasToy(self.id) end,
}

ns.conditions.QuestComplete = Class{
	__parent = Condition,
	type = 'quest',
	Matched = function(self) return C_QuestLog.IsQuestFlaggedCompleted(self.id) end,
}
ns.conditions.QuestIncomplete = Class(Negated(ns.conditions.QuestComplete))

ns.conditions.WorldQuestActive = Class{
	__parent = Condition,
	type = 'worldquest',
	Matched = function(self) return C_TaskQuest.IsActive(self.id) or C_QuestLog.IsQuestFlaggedCompleted(self.id) end,
}

ns.conditions.OnQuest = Class{
	__parent = Condition,
	type = 'quest',
	Matched = function(self) return C_QuestLog.IsOnQuest(self.id) end,
}

ns.conditions.Vignette = Class{
	__parent = Condition,
	type = 'vignette',
	FindVignette = function(self)
		local vignettes = C_VignetteInfo.GetVignettes()
		for _, vignetteGUID in ipairs(vignettes) do
			local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID)
			if vignetteInfo and vignetteInfo.vignetteID == self.id then
				return vignetteInfo
			end
		end
		return false
	end,
	Matched = function(self) return self:FindVignette() end,
	Label = function(self)
		local vignetteInfo = self:FindVignette()
		if vignetteInfo and vignetteInfo.name then
			return vignetteInfo.name
		end
		return Condition.Label(self)
	end,
}

ns.conditions.Level = Class{
	__parent = Condition,
	type = 'level',
	Label = function(self) return UNIT_LEVEL_TEMPLATE:format(self.id) end,
	Matched = function(self) return UnitLevel('player') >= self.id end,
}

ns.conditions.Class = Class{
	__parent = Condition,
	type = 'class',
	Label = function(self)
		local className = ((UnitSex("player") == 2) and LOCALIZED_CLASS_NAMES_MALE or LOCALIZED_CLASS_NAMES_FEMALE)[self.id] or self.id
		if RAID_CLASS_COLORS[self.id] then
			return RAID_CLASS_COLORS[self.id]:WrapTextInColorCode(className)
		end
		return className
	end,
	Matched = function(self) return select(2, UnitClass("player")) == self.id end,
}

ns.conditions.CalendarEvent = Class{
	__parent = Condition,
	type = 'calendarevent',
	Label = function(self)
		local event = self:getEvent()
		if event and event.title then
			return event.title
		end
		return Condition.Label(self)
	end,
	Matched = function(self)
		if self:getEvent() then
			return true
		end
	end,
	getEvent = function(self)
		local offset, day = self:getOffsets()
		for i=1, C_Calendar.GetNumDayEvents(offset, day) do
			local event = C_Calendar.GetDayEvent(offset, day, i)
			if event.eventID == self.id then
				return true
			end
		end
	end,
	getOffsets = function(self, current)
		-- we could call C_Calendar.SetMonth, but that'd jump the calendar around if it's open... so instead, work out the actual offset
		current = current or C_DateAndTime.GetCurrentCalendarTime()
		local selected = C_Calendar.GetMonthInfo()
		local offset = (selected.month - current.month) + ((selected.year - current.year) * 12)
		if offset >= 1 or offset <= -1 then
			-- calendar APIs only return information on events within the next month either way
			if not (_G.CalendarFrame and _G.CalendarFrame:IsVisible()) then
				-- calendar's not visible, so it's fine to move it around
				-- SetAbsMonth because when the calendar hasn't been opened yet just SetMonth can jump to an incorrect year...
				C_Calendar.SetAbsMonth(current.month, current.year)
				offset = 0
			end
		end
		return offset, current.monthDay
	end,
}
ns.conditions.CalendarEventStartTexture = Class{
	__parent = ns.conditions.CalendarEvent,
	type = 'calendareventtexture',
	getEvent = function(self)
		local offset, day = self:getOffsets()
		for i=1, C_Calendar.GetNumDayEvents(offset, day) do
			local event = C_Calendar.GetDayEvent(offset, day, i)
			if event and event.startTime then
				local startoffset, startday = self:getOffsets(event.startTime)
				for ii=1, C_Calendar.GetNumDayEvents(startoffset, startday) do
					local startEvent = C_Calendar.GetDayEvent(startoffset, startday, ii)
					if startEvent and startEvent.iconTexture == self.id then
						return event
					end
				end
			end
		end
	end
}

ns.conditions.DayOfWeek = Class{
	__parent = Condition,
	type = "weekday",
	Label = function(self)
		if self.DAYS[self.id] then
			return _G["WEEKDAY_" .. self.DAYS[self.id]]
		end
		return "day " .. self.id
	end,
	Matched = function(self)
		return tonumber(date('%w')) == self.id
	end,

	DAYS = {
		[0] = "SUNDAY",
		[1] = "MONDAY",
		[2] = "TUESDAY",
		[3] = "WEDNESDAY",
		[4] = "THURSDAY",
		[5] = "FRIDAY",
		[6] = "SATURDAY",
	},
}

-- Helpers:

do
	local function check(cond) return cond:Matched() end
	ns.conditions.check = function(conditions)
		if conditions then
			return ns.doTest(check, conditions)
		end
	end

	local t = {}
	ns.conditions.summarize = function(conditions)
		-- ERR_USE_LOCKED_WITH_ITEM_S
		table.wipe(t)
		if type(conditions) == "table" and not conditions.__parent then
			for _, condition in ipairs(conditions) do
				table.insert(t, condition:Label())
			end
			return ERR_USE_LOCKED_WITH_ITEM_S:format(string.join(', ', unpack(t)))
		end
		return ERR_USE_LOCKED_WITH_ITEM_S:format(conditions:Label())
	end
end

-- cross-addon...
core.conditions = ns.conditions
