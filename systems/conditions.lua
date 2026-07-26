local myname, ns = ...
local Class = ns.Class

local GetPlayerAuraBySpellID = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID or _G.GetPlayerAuraBySpellID
local issecretvalue = _G.issecretvalue or function() return false end
local issecrettable = _G.issecrettable or function() return false end
local InChatMessagingLockdown = _G.C_ChatInfo and C_ChatInfo.InChatMessagingLockdown or function() return false end

ns.conditions = {}
-- _G.COND = ns.conditions

--[[
API:
condition = ns.Condition.GarrisonTalent(1912, 4)

condition:Test() -> bool -- what you want; caches for the current frame
condition:Matched() -> bool -- the implementation, which subclasses override
condition:Label() -> string
]]

-- KEYFIELDS names whatever makes two of a condition different from each other;
-- subclasses that carry more than an id redeclare it. SILENT is for the ones
-- with nothing to tell anybody -- you only ever have one faction, map art is an
-- internal id -- which summarize leaves out of its explanations.
local Condition = ns.Class({classname = "Condition", CACHEABLE = true, KEYFIELDS = {"id"}, SILENT = false})
function Condition:init(id) self.id = id end
function Condition:Label() return ('{%s:%s}'):format(self.type, self.id) end
function Condition:Matched() return false end
-- Identity for the cache below: two conditions sharing a key are
-- interchangeable, so only the first of them has to ask the game. Built from
-- the stored fields rather than the init arguments, because some of those get
-- translated on the way in, and kept because Test() asks for it constantly.
function Condition:CacheKey()
	if not self._cachekey then
		local parts = {self.classname}
		for i, field in ipairs(self.KEYFIELDS) do
			parts[i + 1] = tostring(self[field])
		end
		self._cachekey = table.concat(parts, ":")
	end
	return self._cachekey
end
-- Identity of what's being watched, for Remember/Recall below; CacheKey is the
-- identity of the condition doing the watching. Override this when your Matched
-- reads something another condition also reads, so the two share one memory
-- instead of each keeping their own and disagreeing about it. A negation is the
-- case that arises here: it runs its parent's Matched with itself as self, so
-- without the override AuraActive and AuraInactive would separately remember
-- whether the same aura was up, and contradict each other once combat hid it.
function Condition:WatchKey() return self:CacheKey() end
do
	-- A miss and a cached nil have to be distinguishable
	local NOTHING = {}
	local cache = {}
	ns.run_caches.conditions = cache
	-- Wiping every frame means a result can't outlive the draw that asked for
	-- it, and wiping early would only ever cost a re-check, never correctness.
	local clearer = CreateFrame("Frame")
	clearer:Hide()
	clearer:SetScript("OnUpdate", function(self)
		table.wipe(cache)
		self:Hide()
	end)
	function Condition:Test()
		if not self.CACHEABLE then return self:Matched() end
		local key = self:CacheKey()
		local cached = cache[key]
		if cached ~= nil then
			if cached == NOTHING then return end
			return cached
		end
		local result = self:Matched()
		cache[key] = result == nil and NOTHING or result
		clearer:Show()
		return result
	end
end

do
	-- Some things can't be read at all some of the time: auras go secret in
	-- combat, calendar data during chat lockdown. What those conditions
	-- describe is long-lived -- a zone-wide buff, a running holiday -- so
	-- answering "no" while we can't look would blink points out at exactly the
	-- wrong moment. Keep answering with the last value we could actually see.
	-- Deliberately not in ns.run_caches: this has to outlive the frame. Keyed on
	-- WatchKey rather than CacheKey, so a condition and its negation share one
	-- memory instead of contradicting each other while neither can look.
	local remembered = {}
	function Condition:Remember(value)
		remembered[self:WatchKey()] = value
		return value
	end
	function Condition:Recall()
		return remembered[self:WatchKey()]
	end
end

local RankedCondition = Condition:extends{classname = "RankedCondition", KEYFIELDS = {"id", "rank"}}
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
	-- We run our parent's Matched, so anything it remembers has to land under
	-- its identity, not ours: strip the prefix added just above.
	function negated:WatchKey() return (self:CacheKey():gsub("^Not", "", 1)) end
	return negated
end

ns.conditions._Condition = Condition
ns.conditions._RankedCondition = RankedCondition
ns.conditions._Negated = Negated

-- Groups don't otherwise nest: doTest calls :Matched() on each member, so a
-- {any=true, ...} can't itself be a member of another group. These wrap one up
-- as a condition in its own right, which can.
ns.conditions.All = Condition:extends{classname = "All", JOINER = ", ", CACHEABLE = false}
function ns.conditions.All:init(...)
	self.conditions = {...}
	self.SILENT = true
	for _, condition in ipairs(self.conditions) do
		if not condition.SILENT then
			self.SILENT = false
			break
		end
	end
end
function ns.conditions.All:Matched()
	return ns.conditions.check(self.conditions)
end
function ns.conditions.All:Label()
	-- deliberately not ns.conditions.summarize: it accumulates into a table it
	-- shares between calls, so nesting would clobber the outer one
	local labels = {}
	for i, condition in ipairs(self.conditions) do
		labels[i] = condition:Label()
	end
	return ("(%s)"):format(string.join(self.JOINER, unpack(labels)))
end

ns.conditions.Any = ns.conditions.All:extends{classname = "Any", JOINER = " / ", CACHEABLE = false}
function ns.conditions.Any:init(...)
	self:super("init", ...)
	self.conditions.any = true
end

ns.conditions.Achievement = Condition:extends{classname = "Achievement", type="achievement", KEYFIELDS = {"id", "criteria", "currentCharacter"}}
function ns.conditions.Achievement:init(id, criteria, currentCharacter)
	self:super("init", id)
	self.criteria = criteria
	self.currentCharacter = currentCharacter
	if currentCharacter then
		self.type = "achievement.character"
	end
end
function ns.conditions.Achievement:Label()
	if self.criteria then
		return ('{%s:%d.%d}'):format(self.type, self.id, self.criteria)
	end
	return self:super("Label")
end
function ns.conditions.Achievement:Matched()
	if self.criteria then
		local _, _, completed, _, _, completedBy = ns.GetCriteria(self.id, self.criteria)
		if self.currentCharacter then return completedBy == ns.playerName end
		return completed
	end
	return (select(self.currentCharacter and 13 or 4, GetAchievementInfo(self.id)))
end

ns.conditions.AchievementIncomplete = Negated(ns.conditions.Achievement)

ns.conditions.AuraActive = Condition:extends{classname = "AuraActive", type = "spell"}
function ns.conditions.AuraActive:Matched()
	local aura = GetPlayerAuraBySpellID(self.id)
	if issecretvalue(aura) then
		-- reads as secret for the duration of combat
		return self:Recall()
	end
	return self:Remember(not not aura)
end

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

ns.conditions.Faction = RankedCondition:extends{classname = "Faction", type = 'faction',
	RANKS = {
		["Unknown"] = 0,
		["Hated"] = 1,
		["Hostile"] = 2,
		["Unfriendly"] = 3,
		["Neutral"] = 4,
		["Friendly"] = 5,
		["Honored"] = 6,
		["Revered"] = 7,
		["Exalted"] = 8,
	},
}
function ns.conditions.Faction:init(id, rank)
	return self:super("init", id, self.RANKS[rank] or rank)
end
function ns.conditions.Faction:Matched()
	local name, standingid, _
	if C_Reputation and C_Reputation.GetFactionDataByID then
		local info = C_Reputation.GetFactionDataByID(self.id)
		if info and info.name then
			name = info.name
			-- info.currentStanding exists but is your total rep with the faction
			standingid = info.reaction
		end
	elseif GetFactionInfoByID then
		name, _, standingid = GetFactionInfoByID(self.id)
	end
	if name and standingid then
		return self.rank <= standingid
	end
end
function ns.conditions.Faction:Label()
	if self.rank then
		return ('{%s:%d.%d}'):format(self.type, self.id, self.rank)
	end
	return self:super("Label")
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

ns.conditions.NotMajorFaction = Negated(ns.conditions.MajorFaction)

ns.conditions.GarrisonTalent = RankedCondition:extends{classname = "GarrisonTalent", type = 'garrisontalent'}
function ns.conditions.GarrisonTalent:Matched()
	local info = C_Garrison.GetTalentInfo(self.id)
	return info and info.researched and (not self.rank or info.talentRank >= self.rank)
end

ns.conditions.Trait = RankedCondition:extends{classname = "Trait", type = 'trait'}
function ns.conditions.Trait:init(treeID, nodeID, rank)
	self.treeID = treeID
	self.nodeID = nodeID
	self.rank = rank

	self.id = ("%d.%d"):format(treeID, nodeID) -- for Label
end
function ns.conditions.Trait:Matched()
	local configID = C_Traits.GetConfigIDByTreeID(self.treeID)
	local nodeInfo = configID and C_Traits.GetNodeInfo(configID, self.nodeID)
	return nodeInfo and nodeInfo.ID ~= 0 and nodeInfo.ranksPurchased > 0
end

ns.conditions.Item = Condition:extends{classname = "Item", type = 'item', KEYFIELDS = {"id", "count"}}
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

ns.conditions.Toy = ns.conditions.Item:extends{classname = "Toy"}
function ns.conditions.Toy:Matched() return PlayerHasToy(self.id) end

ns.conditions.QuestComplete = Condition:extends{classname = "QuestComplete", type = 'quest'}
function ns.conditions.QuestComplete:Matched() return C_QuestLog.IsQuestFlaggedCompleted(self.id) end

ns.conditions.QuestIncomplete = Negated(ns.conditions.QuestComplete)

ns.conditions.QuestCompleteOnAccount = Condition:extends{classname = "QuestCompleteOnAccount", type = 'quest'}
function ns.conditions.QuestCompleteOnAccount:Matched() return C_QuestLog.IsQuestFlaggedCompletedOnAccount(self.id) end

ns.conditions.QuestIncompleteOnAccount = Negated(ns.conditions.QuestCompleteOnAccount)

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

-- Which map the poi belongs to is part of the condition rather than something
-- passed in at check time, because the map being drawn isn't necessarily the
-- one the point was registered against.
ns.conditions.AreaPoi = Condition:extends{classname = "AreaPoi", type = 'areapoi', KEYFIELDS = {"uiMapID", "id"}}
function ns.conditions.AreaPoi:init(uiMapID, id)
	self.uiMapID = uiMapID
	self.id = id
end
do
	-- A map answers with all of its pois at once, so ask it at most once a
	-- second however many conditions are watching it.
	local byMap, expires = {}, {}
	local function poisIn(uiMapID)
		local now = time()
		if not byMap[uiMapID] or now > expires[uiMapID] then
			byMap[uiMapID] = wipe(byMap[uiMapID] or {})
			for _, poi in ipairs(C_AreaPoiInfo.GetAreaPOIForMap(uiMapID) or {}) do
				byMap[uiMapID][poi] = true
			end
			expires[uiMapID] = now + 1
		end
		return byMap[uiMapID]
	end
	function ns.conditions.AreaPoi:Matched()
		return poisIn(self.uiMapID)[self.id] or false
	end
end
function ns.conditions.AreaPoi:Label()
	local info = C_AreaPoiInfo.GetAreaPOIInfo(self.uiMapID, self.id)
	if info and info.name then
		return info.name
	end
	return Condition.Label(self)
end

-- Same reasoning as AreaPoi for taking the map explicitly.
ns.conditions.MapArt = Condition:extends{classname = "MapArt", type = 'mapart', KEYFIELDS = {"uiMapID", "id"}, SILENT = true}
function ns.conditions.MapArt:init(uiMapID, id)
	self.uiMapID = uiMapID
	self.id = id
end
function ns.conditions.MapArt:Matched() return C_Map.GetMapArtID(self.uiMapID) == self.id end

ns.conditions.Level = Condition:extends{classname = "Level", type = 'level', CACHEABLE = false}
function ns.conditions.Level:Label() return UNIT_LEVEL_TEMPLATE:format(self.id) end
function ns.conditions.Level:Matched() return UnitLevel('player') >= self.id end

ns.conditions.Class = Condition:extends{classname = "Class", type = 'class', CACHEABLE = false}
function ns.conditions.Class:Label()
	local className = ((UnitSex("player") == 2) and LOCALIZED_CLASS_NAMES_MALE or LOCALIZED_CLASS_NAMES_FEMALE)[self.id] or self.id
	if RAID_CLASS_COLORS[self.id] then
		return RAID_CLASS_COLORS[self.id]:WrapTextInColorCode(className)
	end
	return className
end
function ns.conditions.Class:Matched() return select(2, UnitClass("player")) == self.id end

-- Distinct from Faction above, which is a reputation standing
ns.conditions.PlayerFaction = Condition:extends{classname = "PlayerFaction", CACHEABLE = false, SILENT = true}
function ns.conditions.PlayerFaction:Label() return _G["FACTION_" .. strupper(self.id)] or self.id end
function ns.conditions.PlayerFaction:Matched() return self.id == ns.playerFaction end

ns.conditions.Outdoors = Condition:extends{classname = "Outdoors"}
function ns.conditions.Outdoors:Label() return "Outdoors" end
function ns.conditions.Outdoors:Matched() return not IsIndoors() end

ns.conditions.Indoors = Negated(ns.conditions.Outdoors)
function ns.conditions.Indoors:Label() return "Indoors" end

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
	-- C_Calendar.GetDayEvent returns secrets when in chat messaging lockdown
	if InChatMessagingLockdown() then return self:Recall() end
	local offset, day = self:getOffsets()
	for i=1, C_Calendar.GetNumDayEvents(offset, day) do
		local event = C_Calendar.GetDayEvent(offset, day, i)
		if event.eventID == self.id then
			return self:Remember(event)
		end
	end
	return self:Remember(nil)
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
	-- C_Calendar.GetDayEvent returns secrets when in chat messaging lockdown
	if InChatMessagingLockdown() then return self:Recall() end
	local offset, day = self:getOffsets()
	for i=1, C_Calendar.GetNumDayEvents(offset, day) do
		local event = C_Calendar.GetDayEvent(offset, day, i)
		if event and event.startTime then
			local startoffset, startday = self:getOffsets(event.startTime)
			for ii=1, C_Calendar.GetNumDayEvents(startoffset, startday) do
				local startEvent = C_Calendar.GetDayEvent(startoffset, startday, ii)
				if startEvent and startEvent.iconTexture == self.id then
					return self:Remember(event)
				end
			end
		end
	end
	return self:Remember(nil)
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

ns.conditions.Vehicle = Condition:extends{classname = "Vehicle", type = "npc"}
function ns.conditions.Vehicle:Matched()
	return UnitInVehicle("player") and self:UnitID("vehicle") == self.id
end
do
	local valid_unit_types = {
		Creature = true, -- npcs
		Vehicle = true, -- vehicles
	}
	function ns.conditions.Vehicle:UnitID(unit)
		local guid = UnitGUID(unit)
		if not guid then return end
		local unit_type, id = guid:match("(%a+)-%d+-%d+-%d+-%d+-(%d+)-.+")
		if not (unit_type and valid_unit_types[unit_type]) then
			return
		end
		return tonumber(id)
	end
end

ns.conditions.Expansion = Condition:extends{classname = "Expansion", type = "expansion", CACHEABLE = false}
function ns.conditions.Expansion:Matched()
	return self.id <= LE_EXPANSION_LEVEL_CURRENT
end

-- Helpers:

do
	local function check(cond) return cond:Test() end
	ns.conditions.check = function(conditions)
		return conditions and ns.doTest(check, conditions)
	end

	local t = {}
	-- Returns nil when there's nothing worth saying, so callers can drop the
	-- line rather than print an empty "Requires ".
	ns.conditions.summarize = function(conditions, short)
		-- ERR_USE_LOCKED_WITH_ITEM_S
		local fs = short and "%s" or ERR_USE_LOCKED_WITH_ITEM_S
		table.wipe(t)
		if ns.xtype(conditions) == "table" then
			for _, condition in ipairs(conditions) do
				if not condition.SILENT then
					table.insert(t, condition:Label())
				end
			end
			if #t == 0 then return end
			return fs:format(string.join(', ', unpack(t)))
		end
		if conditions.SILENT then return end
		return fs:format(conditions:Label())
	end
end
