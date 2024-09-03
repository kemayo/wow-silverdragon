local myname, ns = ...
local Class = ns.Class

local GetPlayerAuraBySpellID = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID or _G.GetPlayerAuraBySpellID

ns.conditions = {}

--[[
API:
condition = ns.conditions.GarrisonTalent(1912, 4)

condition:Matched() -> bool
condition:Label() -> string
]]

local Condition = ns.Class({classname = "Condition"})
function Condition:init(id) self.id = id end
function Condition:Label() return ('{%s:%d}'):format(self.type, self.id) end
function Condition:Matched() return false end

local RankedCondition = Condition:extends{classname = "RankedCondition"}
function RankedCondition:init(id, rank)
	self:super("init", id)
	self.rank = rank
end
function RankedCondition:Label()
	-- this relies greatly on render_string working for self.type
	local label = Condition.Label(self)
	if self.rank then
		return AZERITE_ESSENCE_TOOLTIP_NAME_RANK:format(label, self.rank)
	end
	return label
end

local Negated = function(parent)
	local negated = parent:extends{classname = "Not"..parent.classname}
	function negated:Matched() return not self:super("Matched") end
	return negated
end

ns.conditions._Condition = Condition
ns.conditions._RankedCondition = RankedCondition
ns.conditions._Negated = Negated

ns.conditions.Achievement = Condition:extends{classname = "Achievement", type="achievement"}
function ns.conditions.Achievement:Matched() return (select(4, GetAchievementInfo(self.id))) end

ns.conditions.AchievementIncomplete = Negated(ns.conditions.Achievement)

ns.conditions.AuraActive = Condition:extends{classname = "AuraActive", type = "spell"}
function ns.conditions.AuraActive:Matched() return GetPlayerAuraBySpellID(self.id) end

ns.conditions.AuraInactive = Negated(ns.conditions.AuraActive)

ns.conditions.SpellKnown = Condition:extends{classname = "SpellKnown", type = "spell"}
function ns.conditions.SpellKnown:Matched() return IsSpellKnown(self.id) end

-- See https://wowpedia.fandom.com/wiki/TradeSkillLineID for IDs
-- TODO: make work in Classic? Whole different API.
ns.conditions.Profession = RankedCondition:extends{classname = "Profession", type = "profession"}
function ns.conditions.Profession:Matched()
	-- The problem: this is only reliable for skill levels after the trade skill has been opened
	local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(self.id)
	if not (info and info.skillLevel) then return false end
	if info.skillLevel > 0 then
		-- we have good data
		return info.skillLevel >= (self.rank or 1)
	end
	-- we need to start making guesses
	return self:CheckProfessions(info, GetProfessions())
end
function ns.conditions.Profession:CheckProfessions(info, ...)
	for i = 1, select("#", ...) do
		if self:CheckProfession(info, select(i, ...)) then
			return true
		end
	end
	return false
end
function ns.conditions.Profession:CheckProfession(info, professionid)
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
end

ns.conditions.Covenant = RankedCondition:extends{classname = "Covenant", type = "covenant"}
function ns.conditions.Covenant:Matched()
	if self.id ~= C_Covenants.GetActiveCovenantID() then
		return false
	end
	if self.rank then
		return self.rank <= C_CovenantSanctumUI.GetRenownLevel()
	end
	return true
end

ns.conditions.Faction = RankedCondition:extends{classname = "Faction", type = 'faction'}
function ns.conditions.Faction:Matched()
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
end

ns.conditions.MajorFaction = RankedCondition:extends{classname = "MajorFaction", type = 'majorfaction'}
function ns.conditions.MajorFaction:Matched()
	local info = C_MajorFactions.GetMajorFactionData(self.id)
	if info then
		if self.rank then
			return self.rank <= info.renownLevel
		end
		return info.isUnlocked
	end
end

ns.conditions.GarrisonTalent = Condition:extends{classname = "GarrisonTalent", type = 'garrisontalent'}
function ns.conditions.GarrisonTalent:init(id, rank)
	self.id = id
	self.rank = rank
end
function ns.conditions.GarrisonTalent:Label()
	local info = C_Garrison.GetTalentInfo(self.id)
	local name = info and info.name and ("{garrisontalent:%d}"):format(self.id) or UNKNOWN
	if self.rank then
		return AZERITE_ESSENCE_TOOLTIP_NAME_RANK:format(name, self.rank)
	end
	return name
end
function ns.conditions.GarrisonTalent:Matched()
	local info = C_Garrison.GetTalentInfo(self.id)
	return info and info.researched and (not self.rank or info.talentRank >= self.rank)
end

ns.conditions.Item = Condition:extends{classname = "Item", type = 'item'}
function ns.conditions.Item:init(id, count)
	self.id = id
	self.count = count
end
function ns.conditions.Item:Label()
	if self.count and self.count > 1 then
		return ("{item:%d} x%d"):format(self.id, self.count)
	end
	return Condition.Label(self)
end
function ns.conditions.Item:Matched() return C_Item.GetItemCount(self.id, true) >= (self.count or 1) end

ns.conditions.Toy = Condition:extends{classname = "Toy"}
function ns.conditions.Toy:Matched() return PlayerHasToy(self.id) end

ns.conditions.QuestComplete = Condition:extends{classname = "QuestComplete", type = 'quest'}
function ns.conditions.QuestComplete:Matched() return C_QuestLog.IsQuestFlaggedCompleted(self.id) end

ns.conditions.QuestIncomplete = Negated(ns.conditions.QuestComplete)

ns.conditions.WorldQuestActive = Condition:extends{classname = "WorldQuestActive", type = 'worldquest'}
function ns.conditions.WorldQuestActive:Matched() return C_TaskQuest.IsActive(self.id) or C_QuestLog.IsQuestFlaggedCompleted(self.id) end

ns.conditions.OnQuest = Condition:extends{classname = "OnQuest", type = 'quest'}
function ns.conditions.OnQuest:Matched() return C_QuestLog.IsOnQuest(self.id) end

ns.conditions.Vignette = Condition:extends{classname = "Vignette", type = 'vignette'}
function ns.conditions.Vignette:FindVignette()
	local vignettes = C_VignetteInfo.GetVignettes()
	for _, vignetteGUID in ipairs(vignettes) do
		local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID)
		if vignetteInfo and vignetteInfo.vignetteID == self.id then
			return vignetteInfo
		end
	end
	return false
end
function ns.conditions.Vignette:Matched() return self:FindVignette() end
function ns.conditions.Vignette:Label()
	local vignetteInfo = self:FindVignette()
	if vignetteInfo and vignetteInfo.name then
		return vignetteInfo.name
	end
	return Condition.Label(self)
end

ns.conditions.Level = Condition:extends{classname = "Level", type = 'level'}
function ns.conditions.Level:Label() return UNIT_LEVEL_TEMPLATE:format(self.id) end
function ns.conditions.Level:Matched() return UnitLevel('player') >= self.id end

ns.conditions.Class = Condition:extends{classname = "Class", type = 'class'}
function ns.conditions.Class:Label()
	local className = ((UnitSex("player") == 2) and LOCALIZED_CLASS_NAMES_MALE or LOCALIZED_CLASS_NAMES_FEMALE)[self.id] or self.id
	if RAID_CLASS_COLORS[self.id] then
		return RAID_CLASS_COLORS[self.id]:WrapTextInColorCode(className)
	end
	return className
end
function ns.conditions.Class:Matched() return select(2, UnitClass("player")) == self.id end

ns.conditions.CalendarEvent = Condition:extends{classname = "CalendarEvent", type = 'calendarevent'}
function ns.conditions.CalendarEvent:Label()
	local event = self:getEvent()
	if event and event.title then
		return event.title
	end
	return Condition.Label(self)
end
function ns.conditions.CalendarEvent:Matched()
	if self:getEvent() then
		return true
	end
end
function ns.conditions.CalendarEvent:getEvent()
	local offset, day = self:getOffsets()
	for i=1, C_Calendar.GetNumDayEvents(offset, day) do
		local event = C_Calendar.GetDayEvent(offset, day, i)
		if event.eventID == self.id then
			return true
		end
	end
end
function ns.conditions.CalendarEvent:getOffsets(current)
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
end

ns.conditions.CalendarEventStartTexture = ns.conditions.CalendarEvent:extends{classname = "CalendarEventStartTexture", type = 'calendareventtexture'}
function ns.conditions.CalendarEventStartTexture:getEvent()
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

ns.conditions.DayOfWeek = Condition:extends{classname = "DayOfWeek", type = "weekday",
	DAYS = {
		[0] = "SUNDAY",
		[1] = "MONDAY",
		[2] = "TUESDAY",
		[3] = "WEDNESDAY",
		[4] = "THURSDAY",
		[5] = "FRIDAY",
		[6] = "SATURDAY",
	}
}
function ns.conditions.DayOfWeek:Label()
	if self.DAYS[self.id] then
		return _G["WEEKDAY_" .. self.DAYS[self.id]]
	end
	return "day " .. self.id
end
function ns.conditions.DayOfWeek:Matched()
	return tonumber(date('%w')) == self.id
end

-- Helpers:

do
	local function check(cond) return cond:Matched() end
	ns.conditions.check = function(conditions)
		return conditions and ns.doTest(check, conditions)
	end

	local t = {}
	ns.conditions.summarize = function(conditions, short)
		-- ERR_USE_LOCKED_WITH_ITEM_S
		local fs = short and "%s" or ERR_USE_LOCKED_WITH_ITEM_S
		table.wipe(t)
		if ns.xtype(conditions) == "table" then
			for _, condition in ipairs(conditions) do
				table.insert(t, condition:Label())
			end
			return fs:format(string.join(', ', unpack(t)))
		end
		return fs:format(conditions:Label())
	end
end
