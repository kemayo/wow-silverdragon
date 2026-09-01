local myname, ns = ...

-- ns.foldConditions(zone, point): collapse the pre-ns.conditions point keys
-- (requires_item, requires_buff, art, poi, faction, level, ...) into
-- point.requires and point.hide_before as condition objects, at registration.
-- One path for "can this be seen" instead of a dozen near-identical checks in
-- should_show_point. Called from points.lua's registerPoint; kept in its own
-- file so SilverDragon can sync it.
do
	-- Each takes either a single value or a list, and what a list means isn't
	-- the same for all of them, so the default is spelled out per key.
	local function grouped(value, make, defaultAny, negated)
		if value == nil then return end
		if type(value) ~= "table" then return make(value) end
		local made = {}
		for i, v in ipairs(value) do made[i] = make(v) end
		if #made < 2 then return made[1] end
		local any = value.any or (defaultAny and not value.all)
		if negated then
			-- the key asked about having these, and we're asking about not
			-- having them, so de Morgan flips the grouping: hide if any of them
			-- is up means show only once all of them are down
			any = not any
		end
		if any then return ns.conditions.Any(unpack(made)) end
		return ns.conditions.All(unpack(made))
	end
	-- a requires list is ANDed, so an existing or-group has to become a single
	-- condition before ours can join it
	local function asOne(value)
		if not value or ns.IsObject(value) then return value end
		if #value < 2 then return value[1] end
		if value.any then return ns.conditions.Any(unpack(value)) end
		return ns.conditions.All(unpack(value))
	end
	local function combine(existing, folded)
		if not folded then return existing end
		existing = asOne(existing)
		if existing then table.insert(folded, 1, existing) end
		return #folded < 2 and folded[1] or folded
	end
	function ns.foldConditions(zone, point)
		local hides, upcoming
		local function hide(condition)
			if not condition then return end
			hides = hides or {}
			table.insert(hides, condition)
		end
		local function soon(condition)
			if not condition then return end
			upcoming = upcoming or {}
			table.insert(upcoming, condition)
		end
		hide(grouped(point.requires_item, ns.conditions.Item))
		hide(grouped(point.requires_buff, ns.conditions.AuraActive))
		hide(grouped(point.requires_no_buff, ns.conditions.AuraInactive, false, true))
		hide(grouped(point.requires_worldquest, ns.conditions.WorldQuestActive))
		-- art defaulted to matching any of them, where the rest default to all
		hide(grouped(point.art, function(id) return ns.conditions.MapArt(zone, id) end, true))
		if point.poi then
			-- each entry names its own map, so they aren't necessarily this one
			local made = {}
			for i, poi in ipairs(point.poi) do
				made[i] = ns.conditions.AreaPoi(unpack(poi))
			end
			hide(#made < 2 and made[1] or ns.conditions.Any(unpack(made)))
		end
		if point.outdoors_only then hide(ns.conditions.Outdoors()) end
		if point.faction then hide(ns.conditions.PlayerFaction(point.faction)) end
		-- These two describe something you'll get to rather than something
		-- you're missing, so they mark a point upcoming instead of hiding it.
		if point.level then soon(ns.conditions.Level(point.level)) end
		-- Clearing only reaches keys the point owns: one coming from a
		-- RegisterPoints defaults table stays visible through the metatable,
		-- which costs a redundant check but not a wrong answer.
		point.requires_item, point.requires_buff, point.requires_no_buff = nil, nil, nil
		point.requires_worldquest, point.art, point.poi = nil, nil, nil
		point.outdoors_only, point.faction, point.level = nil, nil, nil
		point.requires = combine(point.requires, hides)
		point.hide_before = combine(point.hide_before, upcoming)
	end
end
