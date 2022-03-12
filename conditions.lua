local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

-- Keep this in sync with my handynotes handlers...

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
local Negated = function(parent) return {
	__parent = parent,
	Matched = function(self) return not self.__parent.Matched(self) end,
} end

ns.conditions.Achievement = Class{
	__parent = Condition,
	type = 'achievement',
	Matched = function(self) return (select(4, GetAchievementInfo(self.id))) end,
}

ns.conditions.AuraActive = Class{
	__parent = Condition,
	type = 'spell',
	Matched = function(self) return GetPlayerAuraBySpellID(self.id) end,
}
ns.conditions.AuraInactive = Class(Negated(ns.conditions.AuraActive))

ns.conditions.Covenant = Class{
	__parent = Condition,
	type = 'covenant',
	Matched = function(self) return self.id == C_Covenants.GetActiveCovenantID() end,
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
		else
			return name
		end
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
		return self.__parent.Label(self)
	end,
	Matched = function(self) return GetItemCount(self.id, true) >= (self.count or 1) end,
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
	Matched = function(self) return C_TaskQuest.IsActive(self.id) end,
}

-- Helpers:

do
	local function check(cond) return cond:Matched() end
	ns.conditions.check = function(conditions)
		return ns.doTest(check, conditions)
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
