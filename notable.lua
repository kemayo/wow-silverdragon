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
