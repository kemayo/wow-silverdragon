local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local Debug = core.Debug

-- "Is this rare still worth telling you about?"
--
-- The shared rewards system answers that per reward (Reward:Notable, and the
-- *_notable options it reads), and systems/notable.lua aggregates a loot table.
-- This is the per-mob composition. Unlike the one in my HandyNotes plugins it's
-- three-valued: true wanted, false knowably not wanted, nil nothing knowable.
--
-- nil has to stay distinct from false. Plenty of mobs have no loot, quest or
-- achievement to go on (Deathmaw), and item data is often still loading the
-- moment a rare is spotted, where CanLearnAppearance answers nil until it isn't.
-- Callers suppress on false alone, so both cost a spurious alert rather than
-- eating a real one.
function ns.MobIsNotable(id, isTreasure)
	-- not an and/or chain: a treasure id that's missing from the treasure lookup
	-- must not fall through to being read as a mob id
	local data
	if isTreasure then
		data = ns.vignetteTreasureLookup[id]
	else
		data = ns.mobdb[id]
	end
	if not data then return end

	-- the rewards system memoises within a run, and this is a fresh one
	ns.ClearRunCaches()

	-- The mob's own quest gates its loot off entirely, so it decides alone: once
	-- it's complete there's nothing left to kill the mob for, and an unfinished
	-- achievement criteria can't be progressed either. The lootable filter agrees.
	-- Not quest_notable's business -- that's about loot with quests attached.
	--
	-- Treasures are exempt: they only ever reach us from a vignette, and the game
	-- drops a looted treasure's vignette itself, so a complete quest there only
	-- means our data contradicts a marker still on screen. A vignette-sourced mob
	-- never gets this far for that same reason, leaving this to judge the ones we
	-- spot some other way.
	if data.quest and not isTreasure then
		if ns.allQuestsComplete(data.quest) then
			Debug("MobIsNotable", id, false, "quest complete")
			return false
		end
		Debug("MobIsNotable", id, true, "quest incomplete")
		return true
	end

	local knowable = false

	-- Achievements come from AchievementMobStatus rather than data.achievement:
	-- mobs imported from HandyNotes data don't carry the field, and a mob can
	-- count for more than one achievement anyway.
	if ns.db.achievement_notable and not isTreasure then
		for _, _, _, criteria_complete, by_alt in ns:AchievementMobStatus(id) do
			knowable = true
			if not criteria_complete and not (by_alt and ns.db.alts_achievements_count) then
				Debug("MobIsNotable", id, true, "achievement incomplete")
				return true
			end
		end
	end

	if data.loot then
		if ns.hasNotableLoot(data.loot) then
			Debug("MobIsNotable", id, true, "notable loot")
			return true
		end
		if ns.hasKnowableLoot(data.loot, core.db.profile.charloot) then
			knowable = true
		end
	end

	-- A mount you already know can still be worth the kill, and Announce already
	-- knows what makes one interesting: BoE mounts sell, and "known mounts are
	-- boring" decides whether the rest count.
	if ns.db.mount_notable then
		local announce = core:GetModule("Announce", true)
		if announce and announce:HasInterestingMounts(id, isTreasure) then
			Debug("MobIsNotable", id, true, "interesting mount")
			return true
		end
	end

	if knowable then
		Debug("MobIsNotable", id, false, "nothing wanted")
		return false
	end
	Debug("MobIsNotable", id, nil, "nothing knowable")
	return nil
end

-- handy for poking at from a macro:
-- /dump SilverDragon.MobIsNotable(32491)
core.MobIsNotable = ns.MobIsNotable
