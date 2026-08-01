local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local Debug = core.Debug

-- A mount you already know can still be worth the kill, because a BoE one sells.
-- Announce leans on this too, for whether a sighting earns the mount sound and
-- flash rather than the ordinary ones -- if mounts aren't what you're here for,
-- there's no reason to single them out either.
function ns.HasNotableMounts(id, isTreasure)
	return ns.db.mount_notable and ns.Loot.HasInterestingMounts(id, isTreasure)
end

-- "Is this rare still worth telling you about?"
--
-- Two questions in order: can it still give you anything at all, and if so is any
-- of it something you want. The first is a gate -- fail it and there's no point
-- announcing whatever it might theoretically drop -- and only then do the reward
-- checks get a say.
--
-- The shared rewards system answers the second per reward (Reward:Notable, and
-- the *_notable options it reads), and systems/notable.lua aggregates a loot
-- table. This is the per-mob composition. Unlike the one in my HandyNotes plugins
-- it's three-valued: true wanted, false knowably not wanted, nil nothing knowable.
--
-- nil has to stay distinct from false. Plenty of mobs have no loot, quest or
-- achievement to go on (Deathmaw), and item data is often still loading the
-- moment a rare is spotted, where CanLearnAppearance answers nil until it isn't.
-- Callers suppress on false alone, so both cost a spurious alert rather than
-- eating a real one.
function ns.MobIsNotable(id, isTreasure, fromVignette)
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

	-- The gate: a completed quest means the mob has nothing left to give, so don't
	-- bother weighing up loot it can't drop. A vignette overrules that, because the
	-- game only puts one up while something remains -- trust it over our own quest
	-- data. Treasures always arrive by vignette, so they never fail this.
	--
	-- Note this is unrelated to quest_notable, which is about loot that has a quest
	-- attached to it.
	if data.quest and not (isTreasure or fromVignette) and ns.allQuestsComplete(data.quest) then
		Debug("MobIsNotable", id, false, "quest complete")
		return false
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

	if ns.HasNotableMounts(id, isTreasure) then
		Debug("MobIsNotable", id, true, "interesting mount")
		return true
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
-- (without the vignette argument, so it answers as if you'd walked up to it)
core.MobIsNotable = ns.MobIsNotable

-- Boil the above down to one word, for the places that show a mob's standing
-- rather than deciding whether to mention it: the map pins and the broker's
-- tooltip rows. Both want the same five answers, and the same colours for them,
-- so neither should be working them out for itself.
function ns.MobState(id)
	local quest, achievement, by_alt = ns:CompletionStatus(id)
	-- The quest goes first for the same reason MobIsNotable gates on it: with it
	-- done the mob can't hand anything over, so what it carries is academic. This
	-- is the one state meaning "finished" rather than "nothing you happen to want".
	if quest then
		return "done"
	end
	if by_alt and ns.db.alts_achievements_count then
		achievement = true
	end
	-- A mount outranks the rest, being what people are usually out here for, and
	-- an unfinished achievement outranks ordinary loot.
	if ns.HasNotableMounts(id) then
		return "mount"
	end
	if achievement == false and ns.db.achievement_notable then
		return "achievement"
	end
	local notable = ns.MobIsNotable(id)
	if notable == false then
		return "nothing"
	end
	-- Showing "we have nothing to go on" apart from "there's something here you
	-- want" is worth it where there's room to say so, even though the filter
	-- treats them alike and announces both -- claiming a mob is worth your time
	-- is a different thing from admitting we can't tell.
	if notable == nil then
		return "unknown"
	end
	return "something"
end

-- Mount and achievement share a colour: the map tells them apart by their icon,
-- and the broker's tooltip has columns of its own for both.
--
-- "unknown" is deliberately absent. Callers leave anything they have no colour
-- for alone, which is what we want for it -- there's nothing to report, so the
-- row should look like it.
ns.MobStateColor = {
	mount = {1, 0.33, 0.33},
	achievement = {1, 0.33, 0.33},
	something = {0.5, 1, 1},
	nothing = {0.7, 0.7, 0.7},
	done = {0.33, 1, 0.33},
}
