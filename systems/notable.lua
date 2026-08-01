local myname, ns = ...

-- Notability: is a thing still worth showing you?
--
-- Only the test primitives live here, because both the HandyNotes plugins and
-- SilverDragon ask the same questions of the same reward objects. How those
-- answers combine is left to each host: the plugins compose them per map point,
-- SilverDragon per mob id, and the two need different answers for "nothing
-- knowable here".

local function doTestAll(test, input, ...)
	for _, value in ipairs(input) do
		if not test(value, ...) then
			return false
		end
	end
	return true
end
local function doTestAny(test, input, ...)
	for _, value in ipairs(input) do
		if test(value, ...) then
			return true
		end
	end
	return false
end
local doTest, doTestDefaultAny
do
	local function doTestMaker(default)
		return function(test, input, ...)
			if ns.xtype(input) == "table" then
				if input.any then return doTestAny(test, input, ...) end
				if input.all then return doTestAll(test, input, ...) end
				return default(test, input, ...)
			else
				return test(input, ...)
			end
		end
	end
	doTest = doTestMaker(doTestAll)
	doTestDefaultAny = doTestMaker(doTestAny)
end
ns.doTest = doTest
ns.doTestDefaultAny = doTestDefaultAny
local function testMaker(test, override)
	return function(...)
		return (override or doTest)(test, ...)
	end
end
ns.testMaker = testMaker

local allQuestsComplete = testMaker(function(quest, isAccount)
	return C_QuestLog[isAccount and "IsQuestFlaggedCompletedOnAccount" or "IsQuestFlaggedCompleted"](quest)
end)
ns.allQuestsComplete = allQuestsComplete

local temp_criteria = {}
local allCriteriaComplete = testMaker(function(criteria, achievement)
	local _, _, completed, _, _, completedBy = ns.GetCriteria(achievement, criteria)
	-- by this current character, or by any character if the setting says it's okay
	return completed and (not completedBy or completedBy == ns.playerName or ns.db.alts_achievements_count)
end, function(test, input, achievement, ...)
	if input == true then
		wipe(temp_criteria)
		for i=1,GetAchievementNumCriteria(achievement) do
			table.insert(temp_criteria, i)
		end
		input = temp_criteria
	end
	return doTest(test, input, achievement, ...)
end)
ns.allCriteriaComplete = allCriteriaComplete

local hasNotableLoot = testMaker(function(item, notransmog)
	if item:Notable() then
		if notransmog and ns.IsA(item, ns.rewards.Item) then
			-- still notable without transmog involved?
			return item:IsTransmog() == false
		end
		return true
	end
	return false
end, doTestAny)
ns.hasNotableLoot = hasNotableLoot
local hasKnowableLoot = testMaker(function(item, droppable)
	if ns.CLASSIC then return false end
	if droppable and not item:MightDrop() then
		-- a non-droppable item *counts* as unknowable
		return false
	end
	return item:Obtained(true) ~= nil
end, doTestAny)
ns.hasKnowableLoot = hasKnowableLoot
local allLootKnown = testMaker(function(item, droppable)
	-- This returns true if all loot is known-or-unknowable
	-- If the "no knowable loot" case matters this should be gated behind hasKnowableLoot
	if droppable and not item:MightDrop() then
		-- a non-droppable item counts as known regardless of whether it really is
		return true
	end
	-- true-or-nil means known or not-knowable
	return item:Obtained(true) ~= false
end)
ns.allLootKnown = allLootKnown

local function isAchieved(point)
	if point.criteria and point.criteria ~= true then
		return allCriteriaComplete(point.criteria, point.achievement)
	end
	local _, _, _, complete, _, _, _, _, _, _, _, _, completedByMe = GetAchievementInfo(point.achievement)
	return completedByMe or (ns.db.alts_achievements_count and complete)
end
ns.isAchieved = isAchieved
