local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local Debug = core.Debug

-- A mount you already know still counts if it's BoE, because it sells. Announce
-- uses this to pick the mount sound and flash, not just for the filter.
function ns.HasNotableMounts(id, isTreasure)
	if not ns.db.mount_notable then
		return false
	end
	if ns.Loot.HasInterestingMounts(id, isTreasure) then
		return true
	end
	-- Only count a shared mount as specifically a notable-mount if the user has opted
	-- in, since the mount warnings are a lot more emphatic.
	-- (GetLootTable won't check both at once.)
	if ns.db.sharedloot and ns.db.sharedloot_alerts
		and ns.Loot.HasInterestingMounts(id, isTreasure, true)
	then
		return true
	end
	return false
end

-- Something you already have can still be interesting if it's bind-on-equip,
-- because it sells. Unowned ones are hasNotableLoot's business. Returns which kind,
-- for the debug log.
function ns.HasSellableLoot(id, isTreasure, shared)
	if not ns.db.boeloot then return false end
	if ns.db.mount_notable and ns.Loot.HasMounts(id, true, true, isTreasure, shared) then return "mount" end
	if ns.db.toy_notable and ns.Loot.HasToys(id, true, true, isTreasure, shared) then return "toy" end
	if ns.db.pet_notable and ns.Loot.HasPets(id, true, true, isTreasure, shared) then return "pet" end
	-- No transmog here, because that's so many rares and so variable for whether people would care.
	return false
end

-- Three-valued: true wanted, false knowably not wanted, nil nothing to go on.
-- nil must stay distinct from false, because plenty of mobs have nothing to judge
-- and item data is often still loading when one is spotted. Callers suppress on
-- false alone, so an unknown costs a spurious alert rather than eating a real one.
function ns.MobIsNotable(id, isTreasure, fromVignette)
	-- not an and/or chain: a missing treasure must not fall through to the mob db
	local data
	if isTreasure then
		data = ns.vignetteTreasureLookup[id]
	else
		data = ns.mobdb[id]
	end
	if not data then return end

	-- the rewards system memoises within a run, and this is a fresh one
	ns.ClearRunCaches()

	-- Gate: a finished quest means there's nothing left to hand over. A vignette
	-- overrules it, since the game only shows one while something remains, and
	-- treasures always arrive by vignette. Not quest_notable, which is about loot.
	if data.quest and not (isTreasure or fromVignette) and ns.allQuestsComplete(data.quest) then
		Debug("MobIsNotable", id, false, "quest complete")
		return false
	end

	local knowable = false

	-- AchievementMobStatus, not data.achievement: a mob can count towards several
	if ns.db.achievement_notable and not isTreasure then
		for _, _, _, criteria_complete, by_alt in ns:AchievementMobStatus(id) do
			knowable = true
			if not criteria_complete and not (by_alt and ns.db.alts_achievements_count) then
				Debug("MobIsNotable", id, true, "achievement incomplete")
				return true
			end
		end
	end

	if data.loot and ns.hasNotableLoot(data.loot) then
		Debug("MobIsNotable", id, true, "notable loot")
		return true
	end
	-- Only count shared loot if requested
	local shared = ns.db.sharedloot and data.loot_shared or nil
	if shared and ns.hasNotableLoot(shared) then
		Debug("MobIsNotable", id, true, "notable shared loot")
		return true
	end

	if data.loot and ns.hasKnowableLoot(data.loot, ns.db.charloot) then
		knowable = true
	end
	if shared and ns.hasKnowableLoot(shared, ns.db.charloot) then
		knowable = true
	end

	local sellable = ns.HasSellableLoot(id, isTreasure)
		or (ns.db.sharedloot and ns.HasSellableLoot(id, isTreasure, true))
	if sellable then
		Debug("MobIsNotable", id, true, "sellable", sellable)
		return true
	end
	if ns.HasNotableMounts(id, isTreasure) then
		Debug("MobIsNotable", id, true, "interesting mount")
		return true
	end

	if knowable then
		Debug("MobIsNotable", id, false, "nothing wanted")
		return false
	end
	-- A registered entry can still end up here with nothing pending: no quest gate,
	-- loot recorded as explicitly empty (nil is untouched -- nobody's checked, so
	-- it stays unknown, not confirmed-empty), no shared loot either. Unlike an
	-- unregistered id, nothing here can later load in and change the answer, so
	-- it's a confirmed no rather than an unknown.
	if not data.quest and data.loot and #data.loot == 0 and (not shared or #shared == 0) then
		Debug("MobIsNotable", id, false, "registered, nothing to check")
		return false
	end
	Debug("MobIsNotable", id, nil, "nothing knowable")
	return nil
end

-- handy for poking at from a macro:
-- /dump SilverDragon.MobIsNotable(32491)
-- (without the vignette argument, so it answers as if you'd walked up to it)
core.MobIsNotable = ns.MobIsNotable

-- One word for the places that show a mob's standing rather than decide whether to
-- mention it, so the map, the browser and the broker can't disagree.
function ns.MobState(id)
	local quest, achievement, by_alt = ns:CompletionStatus(id)
	-- Quest first, as in MobIsNotable: the only state meaning "finished".
	if quest then
		return "done"
	end
	if by_alt and ns.db.alts_achievements_count then
		achievement = true
	end
	-- A mount outranks an unfinished achievement, which outranks ordinary loot.
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
	-- Worth telling apart from "something you want" where there's room to show it,
	-- even though the filter announces both.
	if notable == nil then
		return "unknown"
	end
	return "something"
end

-- Mount and achievement share a colour; the icon and the broker's own columns tell
-- them apart. "unknown" is deliberately absent: callers leave a state they have no
-- colour for alone, which is how it should look.
ns.MobStateColor = {
	mount = {1, 0.33, 0.33},
	achievement = {1, 0.33, 0.33},
	something = {0.5, 1, 1},
	nothing = {0.7, 0.7, 0.7},
	done = {0.33, 1, 0.33},
}

-- The icons for those states, in three themes. Here rather than in the overlay
-- because the overlay ships as its own addon and the browser wants the same icons,
-- and two copies would drift. The theme *choice* stays the overlay's, since that's
-- where the option lives.
--
-- DungeonSkull = skull
-- VignetteKillElite = Skull with star around it
-- Islands-AzeriteBoss = more detailed skull
-- nazjatar-nagaevent = more detailed skull, glowing
-- WhiteCircle-RaidBlips / PlayerPartyBlip = white circle
-- WhiteDotCircle-RaidBlips / PlayerRaidBlip = white circle with dot
-- PlayerDeadBlip = black circle with white X
-- QuestSkull = gold glowy circle
-- Warfront-NeutralHero-Silver = silver dragon on gold circle
--
-- Grey for "nothing" so it recedes, and plain white for "unknown", which is
-- making no claim either way.
do
	local function tex(atlas, r, g, b, scale)
		return {
			atlas = atlas,
			r = r, g = g, b = b, a = 0.9,
			scale = scale or 1,
		}
	end
	ns.MobStateIcons = {
		circles = {
			achievement = tex("PlayerPartyBlip", 1, 0.33, 0.33, 1.3), -- red
			something = tex("Warfront-NeutralHero-Silver", 0.5, 1, 1, 1.3), -- cyan dragon
			nothing = tex("PlayerPartyBlip", 0.7, 0.7, 0.7, 1.3), -- grey
			unknown = tex("PlayerPartyBlip", 1, 1, 1, 1.3), -- plain white
			done = tex("PlayerDeadBlip", 0.33, 1, 0.33, 1), -- green
			mount = tex("PlayerRaidBlip", 1, 0.33, 0.33, 1.3), -- red, dotted
		},
		skulls = {
			achievement = tex("Islands-AzeriteBoss", 1, 0.33, 0.33, 1.8), -- red skull
			something = tex("nazjatar-nagaevent", 0.5, 1, 1, 1.8), -- cyan glowing skull
			nothing = tex("Islands-AzeriteBoss", 0.7, 0.7, 0.7, 1.5), -- grey skull
			unknown = tex("Islands-AzeriteBoss", 1, 1, 1, 1.8), -- plain white skull
			done = tex("Islands-AzeriteBoss", 0.33, 1, 0.33, 1.5), -- green skull
			mount = tex("VignetteKillElite", 1, 0.33, 0.33, 1.8), -- red shiny skull
		},
		stars = {
			achievement = tex("VignetteKill", 1, 0.33, 1, 1.6), -- magenta star
			something = tex("VignetteLootElite", 0.5, 1, 1, 1.6), -- cyan shiny star
			nothing = tex("VignetteKill", 0.7, 0.7, 0.7, 1.3), -- grey star
			unknown = tex("VignetteKill", 1, 1, 1, 1.6), -- plain white star
			-- was 0,1,1 and labelled green, but that's a cyan too close to the
			-- "something you want" one to tell apart at icon size
			done = tex("VignetteKill", 0.33, 1, 0.33, 1.3), -- green star
			mount = tex("VignetteKillElite", 1, 0.33, 1, 1.8), -- magenta shiny star
		},
	}
	if ns.CLASSIC then
		ns.MobStateIcons.skulls = {
			achievement = tex("DungeonSkull", 1, 0.33, 0.33, 1.3), -- red skull
			something = tex("VignetteKillElite", 0.5, 1, 1, 1.3), -- cyan glowing skull
			nothing = tex("DungeonSkull", 0.7, 0.7, 0.7, 1.3), -- grey skull
			unknown = tex("DungeonSkull", 1, 1, 1, 1.3), -- plain white skull
			done = tex("DungeonSkull", 0.33, 1, 0.33, 1), -- green skull
			mount = tex("VignetteKillElite", 1, 0.33, 0.33, 1.8), -- red shiny skull
		}
	end
end
