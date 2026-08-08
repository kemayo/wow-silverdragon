local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Browser")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-2.0")

--[[
The nav is one flat list of same-height rows with an indent level, not a tree
data provider: a linear view is what the rest of my addons use, and collapsing
just rebuilds the array.

Only an expanded branch adds mob rows, and a header needs no more than a name and
a count, so building the list costs a table insert per row. What a row says is
worked out the first time it is drawn -- see ensureFilled.
]]

local KIND_SOURCE, KIND_ZONE, KIND_MOB = "source", "zone", "mob"

-- What each datasource covers, both ways round: by zone, and by achievement.
-- Rebuilt from scratch on Ready, since that's when datasources get switched on
-- and off.
local zonesBySource, achievementsBySource, lootBySource

-- buildIndex walks every mob in the data, so it must not allocate per mob
local EMPTY = {}

-- Loot categories, in the order the tree lists them rather than alphabetically.
local LOOT_CATEGORIES = {"mount", "pet", "toy", "something", "nothing"}
local LOOT_CATEGORY_NAMES = {
	mount = MOUNT,
	pet = TOOLTIP_BATTLE_PET,
	toy = TOY,
	something = "Other loot",
	nothing = "Nothing known",
}
local LOOT_CATEGORY_ORDER = {}
for i, category in ipairs(LOOT_CATEGORIES) do LOOT_CATEGORY_ORDER[category] = i end

local function lootCategory(id)
	if ns.Loot.HasMounts(id) then return "mount" end
	if ns.Loot.HasPets(id) then return "pet" end
	if ns.Loot.HasToys(id) then return "toy" end
	if ns.Loot.HasLoot(id) then return "something" end
	return "nothing"
end

local function buildIndex()
	zonesBySource, achievementsBySource, lootBySource = {}, {}, {}
	for source, data in pairs(core.datasources) do
		local zones, achievements, loot = {}, {}, {}
		for id, mob in pairs(data) do
			if not mob.hidden then
				local category = lootCategory(id)
				if not loot[category] then loot[category] = {} end
				table.insert(loot[category], id)

				if mob.locations and next(mob.locations) then
					for uiMapID in pairs(mob.locations) do
						if not zones[uiMapID] then zones[uiMapID] = {} end
						table.insert(zones[uiMapID], id)
					end
				end
			end
			-- deliberately outside the hidden check: an achievement criterion is
			-- reason enough to list a mob the zone lists leave out
			for _, achievement in ipairs(ns.mobs_to_achievement[id] or EMPTY) do
				if not achievements[achievement] then achievements[achievement] = {} end
				table.insert(achievements[achievement], id)
			end
		end
		zonesBySource[source] = zones
		achievementsBySource[source] = achievements
		lootBySource[source] = loot
	end
end

local function achievementName(achievementID)
	return select(2, GetAchievementInfo(achievementID)) or ("achievement:" .. achievementID)
end

-- Filters
--
-- "hidden" here means hidden from the browser by the user's filter choices, not
-- the data's own `hidden` flag, which is applied when the index is built.
local function passesFilter(id)
	local db = module.db.profile
	local ignored = core.db.global.ignore[id]
	if db.filterIgnored == "hide" and ignored then return false end
	if db.filterIgnored == "only" and not ignored then return false end
	if db.filterWatched then
		local watched = core.db.global.custom.any[id]
		if not watched then
			for uiMapID, mobs in pairs(core.db.global.custom) do
				if uiMapID ~= "any" and mobs[id] then
					watched = true
					break
				end
			end
		end
		if not watched then return false end
	end
	return true
end
module.passesFilter = passesFilter

local function filtersActive()
	local db = module.db.profile
	return db.filterIgnored ~= "show" or db.filterWatched
end

-- A header counts the rows you would actually find under it, so the filters get
-- a vote. Counting rather than reading a total worked out when the index was
-- built also means the number always matches the grouping in front of you.
local function countBranch(mobs)
	local passing = 0
	for _, id in ipairs(mobs) do
		if passesFilter(id) then
			passing = passing + 1
		end
	end
	return passing
end

local countSeen = {}
local function countSource(branches)
	wipe(countSeen)
	local passing = 0
	for _, mobs in pairs(branches) do
		for _, id in ipairs(mobs) do
			-- a rare in three zones is still one rare
			if not countSeen[id] and passesFilter(id) then
				countSeen[id] = true
				passing = passing + 1
			end
		end
	end
	return passing
end

local function zoneName(uiMapID)
	return core.zone_names[uiMapID] or ("map" .. uiMapID)
end

-- Zone parents, remembered the way the names are. GetMapInfo is asked for the
-- name anyway, so this costs nothing more.
local zoneParent = setmetatable({}, {__index = function(self, uiMapID)
	local info = C_Map.GetMapInfo(uiMapID)
	local parent = info and info.parentMapID
	if parent == 0 then parent = nil end
	rawset(self, uiMapID, parent or false)
	return parent or false
end})

--[[
Which zones sit under which, for the zone grouping.

A zone nests under the nearest ancestor that also has rares of its own. Anything
higher is skipped: a continent almost never has any, and an empty level to open
would be worse than a flat list. Most zones come out as roots for that reason,
which is the intent -- this is for the handful of city and sub-zone maps whose
parent really does have rares too.
]]
local function nestZones(branches)
	local childrenOf, roots = {}, {}
	for zone in pairs(branches) do
		local parent, guard = zoneParent[zone], 0
		while parent and not branches[parent] and guard < 12 do
			parent = zoneParent[parent]
			guard = guard + 1
		end
		if parent and branches[parent] then
			childrenOf[parent] = childrenOf[parent] or {}
			table.insert(childrenOf[parent], zone)
		else
			table.insert(roots, zone)
		end
	end
	return roots, childrenOf
end

-- The zone you are in and every ancestor of it that made the tree, so the chain
-- down to it all sorts first at its own level.
local function pinnedZones(branches)
	local pinned = {}
	local zone, guard = HBD:GetPlayerZone(), 0
	while zone and guard < 12 do
		if branches[zone] then pinned[zone] = true end
		zone = zoneParent[zone] or nil
		guard = guard + 1
	end
	return pinned
end

local function sortZones(list, pinned)
	table.sort(list, function(a, b)
		if pinned[a] ~= pinned[b] then return pinned[a] end
		return zoneName(a) < zoneName(b)
	end)
	return list
end

-- Deduped across the subtree: a rare recorded on both a zone and its parent is
-- still one rare.
local subtreeSeen = {}
local function countZoneSubtree(branches, childrenOf, zone)
	wipe(subtreeSeen)
	local passing = 0
	local function walk(this)
		for _, id in ipairs(branches[this] or EMPTY) do
			if not subtreeSeen[id] and passesFilter(id) then
				subtreeSeen[id] = true
				passing = passing + 1
			end
		end
		for _, child in ipairs(childrenOf[this] or EMPTY) do
			walk(child)
		end
	end
	walk(zone)
	return passing
end

local sortedSources = {}
local function getSortedSources()
	wipe(sortedSources)
	for source in pairs(core.datasources) do
		table.insert(sortedSources, source)
	end
	table.sort(sortedSources)
	return sortedSources
end

-- Entries

local function isExpanded(key)
	return module.db.profile.expanded[key]
end

--[[
Expanding and collapsing splices rows into and out of the data provider rather
than rebuilding the list.

A flush loses the scroll position, and putting it back needs ScrollBox methods
that vary between the versions this addon ships to. With a splice the rows above
the group do not move, so there is nothing to restore.

spliceBranch is defined below, once there is something to build rows with.
]]
local spliceBranch

function module:ToggleExpanded(key)
	local expand = not isExpanded(key)
	self.db.profile.expanded[key] = expand or nil
	if not self.window then return end
	if not spliceBranch(self, key, expand) then
		-- search results, or a row that has gone: a rebuild is always correct
		return self:Refresh()
	end
	self:RefreshRow(key)
end

-- Redraw one row in place, for when only its own state changed
function module:RefreshRow(key)
	if not self.window then return end
	self.window.nav.scrollBox:ForEachFrame(function(line)
		if line.data and line.data.key == key then
			line:SetData(line.data)
		end
	end)
end

-- Building the list

-- Labels are kept rather than asked for on each draw: mob_name does not remember
-- an empty lookup, so a creature the client does not know rebuilds a tooltip
-- every call, which for a recycled row is once per scroll tick.
--
-- Dropped for a mob when it is seen, because that is when its name becomes
-- known, and wholesale when the data is rebuilt.
local mobLabels = {}

local function labelFor(id)
	local label = mobLabels[id]
	if not label then
		label = core:GetMobLabel(id) or tostring(id)
		mobLabels[id] = label
	end
	return label
end

-- A branch's mobs in display order, worked out once and kept.
--
-- Sorted on the label the rows show, so a localised client orders by the names
-- it reads. Each label is looked up once rather than twice per comparison, and
-- lowercased: byte order puts every capitalised name ahead of the rest.
local sortedMobs = {}

local function sortedMobsFor(branchKey, mobs)
	local order = sortedMobs[branchKey]
	if not order then
		order = {}
		local keys = {}
		for _, id in ipairs(mobs) do
			table.insert(order, id)
			keys[id] = labelFor(id):lower()
		end
		table.sort(order, function(a, b)
			if keys[a] ~= keys[b] then
				return keys[a] < keys[b]
			end
			return a < b
		end)
		sortedMobs[branchKey] = order
	end
	return order
end

local function addMobs(entries, source, branchKey, uiMapID, mobs, indent)
	-- filtering after the sort keeps the order, and keeps the cache filter-proof
	for _, id in ipairs(sortedMobsFor(branchKey, mobs)) do
		if passesFilter(id) then
			table.insert(entries, {
				kind = KIND_MOB,
				key = ("%s/%d"):format(branchKey, id),
				indent = indent,
				id = id,
				label = labelFor(id),
				uiMapID = uiMapID,
				source = source or (ns.mobdb[id] and ns.mobdb[id].source),
			})
		end
	end
end

-- One zone and, if it is open, its sub-zones and then its own rares. Sub-zones
-- come first: they are structure, and a long list of rares would bury them.
local function addZone(entries, source, branches, childrenOf, zone, parentKey, indent, filtering, pinned)
	local count = countZoneSubtree(branches, childrenOf, zone)
	if count == 0 and filtering then return end

	local key = parentKey .. "/z/" .. zone
	table.insert(entries, {
		kind = KIND_ZONE,
		key = key,
		indent = indent,
		label = zoneName(zone),
		uiMapID = zone,
		source = source,
		count = count,
		-- enough to rebuild this branch alone when it is opened
		mobs = branches[zone],
		branches = branches,
		childrenOf = childrenOf,
	})
	if not isExpanded(key) then return end

	local children = childrenOf[zone]
	if children then
		local sorted = {}
		for _, child in ipairs(children) do table.insert(sorted, child) end
		for _, child in ipairs(sortZones(sorted, pinned)) do
			addZone(entries, source, branches, childrenOf, child, key, indent + 1, filtering, pinned)
		end
	end
	addMobs(entries, source, key, zone, branches[zone], indent + 1)
end

local function addZones(entries, source, branches, indent)
	local roots, childrenOf = nestZones(branches)
	local pinned = pinnedZones(branches)
	local filtering = filtersActive()
	local prefix = source or "*"
	for _, zone in ipairs(sortZones(roots, pinned)) do
		addZone(entries, source, branches, childrenOf, zone, prefix, indent, filtering, pinned)
	end
end

local sortedBranches = {}
local function addBranches(entries, source, branches, grouping, indent)
	if grouping == "zone" then
		return addZones(entries, source, branches, indent)
	end
	wipe(sortedBranches)
	for branch in pairs(branches) do
		table.insert(sortedBranches, branch)
	end
	local nameFor = grouping == "achievement" and achievementName
		or function(category) return LOOT_CATEGORY_NAMES[category] or category end
	table.sort(sortedBranches, function(a, b)
		if grouping == "loot" then
			return (LOOT_CATEGORY_ORDER[a] or 99) < (LOOT_CATEGORY_ORDER[b] or 99)
		end
		return nameFor(a) < nameFor(b)
	end)
	local filtering = filtersActive()
	for _, branch in ipairs(sortedBranches) do
		local count = countBranch(branches[branch])
		-- with a filter on, a branch that would open onto nothing is only noise
		if count > 0 or not filtering then
			local key = ("%s/%s/%s"):format(source or "*", grouping:sub(1, 1), branch)
			table.insert(entries, {
				kind = KIND_ZONE,
				key = key,
				indent = indent,
				label = nameFor(branch),
				achievementID = grouping == "achievement" and branch or nil,
				source = source,
				count = count,
				-- lets expanding build this branch alone, without the whole index
				mobs = branches[branch],
			})
			if isExpanded(key) then
				addMobs(entries, source, key, nil, branches[branch], indent + 1)
			end
		end
	end
end

-- The rows under a header, including any deeper branches left open.
local function buildChildren(self, header)
	local entries = {}
	local grouping = self.db.profile.grouping
	if header.kind == KIND_SOURCE and header.branches then
		addBranches(entries, header.source, header.branches, grouping, header.indent + 1)
	elseif header.kind == KIND_ZONE and header.childrenOf then
		-- a zone opens onto its sub-zones as well as its own rares
		local pinned = pinnedZones(header.branches)
		local filtering = filtersActive()
		local children = header.childrenOf[header.uiMapID]
		if children then
			local sorted = {}
			for _, child in ipairs(children) do table.insert(sorted, child) end
			for _, child in ipairs(sortZones(sorted, pinned)) do
				addZone(entries, header.source, header.branches, header.childrenOf, child,
					header.key, header.indent + 1, filtering, pinned)
			end
		end
		addMobs(entries, header.source, header.key, header.uiMapID, header.mobs, header.indent + 1)
	elseif header.kind == KIND_ZONE and header.mobs then
		addMobs(entries, header.source, header.key, header.uiMapID, header.mobs, header.indent + 1)
	else
		return
	end
	return entries
end

function spliceBranch(self, key, expand)
	local provider = self.dataProvider
	if self.searchText then return false end
	if not (provider and provider.FindIndexByPredicate and provider.InsertInternal
		and provider.RemoveIndexRange and provider.Find and provider.GetSize
		and provider.TriggerEvent and DataProviderMixin and DataProviderMixin.Event) then
		return false
	end
	local index = provider:FindIndexByPredicate(function(entry) return entry.key == key end)
	if not index then return false end
	local header = provider:Find(index)
	if not header then return false end

	if not expand then
		-- everything underneath is contiguous and carries the header's key as a
		-- prefix, however deep it goes
		local prefix = key .. "/"
		local last, size = index, provider:GetSize()
		for i = index + 1, size do
			local entry = provider:Find(i)
			if not (entry and entry.key and entry.key:find(prefix, 1, true) == 1) then
				break
			end
			last = i
		end
		if last > index then
			-- one OnSizeChanged for the whole range, unlike inserting
			provider:RemoveIndexRange(index + 1, last)
		end
		return true
	end

	local children = buildChildren(self, header)
	if not children then return false end

	--[[
	One event for the whole batch, not one per row.

	InsertAtIndex fires OnSizeChanged each time, and the box answers that by
	recalculating the extent of the whole list. That happens before the Update()
	which SetUpdateLocked suppresses, so the lock does not help: a 1413-row
	branch took 7.1 seconds.

	InsertTableRange fires once at the end, but it can only append. So insert at
	the index we want and fire the one event ourselves. The list view listens for
	OnSizeChanged and OnSort only, so the rows stay invisible until it goes out.
	]]
	for i, entry in ipairs(children) do
		provider:InsertInternal(entry, index + i)
	end
	provider:TriggerEvent(DataProviderMixin.Event.OnSizeChanged, provider:HasSortComparator())
	provider:Sort()
	return true
end

-- With the expansion level switched off the same branches get merged across every
-- datasource, so a zone that several of them know about is one entry rather than
-- one per expansion. Built on demand and dropped whenever the index is.
local mergedIndex

local function buildMergedIndex()
	mergedIndex = {}
	for grouping, index in pairs({zone = zonesBySource, achievement = achievementsBySource, loot = lootBySource}) do
		local merged, seen = {}, {}
		for source, branches in pairs(index) do
			if core.db.global.datasources[source] then
				for branch, mobs in pairs(branches) do
					if not merged[branch] then
						merged[branch] = {}
						seen[branch] = {}
					end
					local into, known = merged[branch], seen[branch]
					for _, id in ipairs(mobs) do
						-- one row per id, even when several datasources have it.
						-- A set, not tInsertUnique: that rescans the whole
						-- list each time, and these run to thousands.
						if not known[id] then
							known[id] = true
							table.insert(into, id)
						end
					end
				end
			end
		end
		mergedIndex[grouping] = merged
	end
end

local indexFor = {}
function module:BuildEntries()
	if not zonesBySource then buildIndex() end
	if self.searchText and self.searchText ~= "" then
		return self:BuildSearchEntries()
	end
	local grouping = self.db.profile.grouping
	local entries = {}

	if not self.db.profile.groupBySource then
		if not mergedIndex then buildMergedIndex() end
		addBranches(entries, nil, mergedIndex[grouping] or mergedIndex.zone, grouping, 0)
		return entries
	end

	indexFor.zone, indexFor.achievement, indexFor.loot = zonesBySource, achievementsBySource, lootBySource
	local index = indexFor[grouping] or zonesBySource
	local filtering = filtersActive()
	for _, source in ipairs(getSortedSources()) do
		local branches = index[source] or {}
		-- rares in here under this grouping, not branches beneath it
		local count = countSource(branches)
		-- an expansion with nothing left to show goes too, but only while a
		-- filter is on: with none, an empty one means its data is switched off
		-- and that is worth seeing
		if count > 0 or not filtering then
			table.insert(entries, {
				kind = KIND_SOURCE,
				key = source,
				indent = 0,
				source = source,
				branches = branches,
				count = count,
			})
			if isExpanded(source) then
				addBranches(entries, source, branches, grouping, 1)
			end
		end
	end
	return entries
end

-- Search ignores the tree. It is the one path that crosses zones, so it caps the
-- results rather than build thousands of rows.
local SEARCH_LIMIT = 200

function module:BuildSearchEntries()
	local needle = self.searchText:lower()
	local matches = {}
	local total = 0
	-- Deliberately not pairs(ns.mobdb): that is a lazy table holding only the
	-- mobs something has already asked for. The datasources are the real list.
	--
	-- Matched against the name in the data and the live one, so a localised
	-- client can search in its own language. The data name is free and goes
	-- first; NameForMob caches, so the live one costs one tooltip read per mob.
	for source, data in pairs(core.datasources) do
		if core.db.global.datasources[source] then
			for id, mob in pairs(data) do
				if not mob.hidden and passesFilter(id) then
					local matched = tostring(id):find(needle, 1, true)
						or (mob.name and mob.name:lower():find(needle, 1, true))
					if not matched then
						local live = core:NameForMob(id)
						matched = live and live:lower():find(needle, 1, true)
					end
					if matched then
						total = total + 1
						if #matches < SEARCH_LIMIT then
							table.insert(matches, id)
						end
					end
				end
			end
		end
	end

	local keys = {}
	for _, id in ipairs(matches) do
		keys[id] = labelFor(id):lower()
	end
	table.sort(matches, function(a, b)
		if keys[a] ~= keys[b] then return keys[a] < keys[b] end
		return a < b
	end)

	local entries = {}
	for _, id in ipairs(matches) do
		local mob = ns.mobdb[id]
		local uiMapID
		if mob.locations then
			uiMapID = next(mob.locations)
		end
		table.insert(entries, {
			kind = KIND_MOB,
			key = "search/" .. id,
			indent = 0,
			id = id,
			label = labelFor(id),
			uiMapID = uiMapID,
			source = mob.source,
		})
	end
	if total > #matches then
		table.insert(entries, {
			kind = KIND_SOURCE,
			key = "search/more",
			indent = 0,
			source = ("showing the first %d of %d"):format(#matches, total),
			noToggle = true,
		})
	end
	return entries
end

function module:SetSearch(text)
	text = text and text:trim()
	if text == "" then text = nil end
	if self.searchText == text then return end
	self.searchText = text
	self:Refresh()
end

function module:SetGrouping(grouping)
	self.db.profile.grouping = grouping
	self:Refresh()
end

-- Every rare that drops a mount, for the mount journal's button. Opens on the
-- loot grouping with that category expanded.
function module:ShowLootCategory(category)
	self:Open()
	self.searchText = nil
	if self.window.search then
		self.window.search:SetText("")
	end
	self.db.profile.grouping = "loot"
	wipe(self.db.profile.expanded)
	if self.db.profile.groupBySource then
		for source in pairs(core.datasources) do
			if core.db.global.datasources[source] then
				self.db.profile.expanded[source] = true
				self.db.profile.expanded[("%s/l/%s"):format(source, category)] = true
			end
		end
	else
		self.db.profile.expanded[("*/l/%s"):format(category)] = true
	end
	self:UpdateHeaderButtons()
	self:Refresh()
end

function module:GetDataProvider()
	if not self.dataProvider then
		self.dataProvider = CreateDataProvider()
	end
	return self.dataProvider
end

-- Only for the rebuilds that replace the list: a grouping change, a search, a
-- datasource going away. Remember what was at the top and put it back.
local function topKey(scrollBox, provider)
	if not (scrollBox.GetDataIndexBegin and provider.Find) then return end
	local index = scrollBox:GetDataIndexBegin()
	local entry = index and index > 0 and provider:Find(index)
	return entry and entry.key
end

local function restoreTop(scrollBox, provider, key)
	if not (key and scrollBox.ScrollToElementDataIndex and provider.FindIndexByPredicate) then return end
	local index
	-- A collapse can remove the row that was at the top. Keys are hierarchical,
	-- so walk up to the nearest ancestor still in the list.
	while key and not index do
		index = provider:FindIndexByPredicate(function(entry)
			return entry.key == key
		end)
		if not index then
			key = key:match("^(.*)/[^/]+$")
		end
	end
	if not (index and index > 0) then return end
	-- the box has not necessarily measured the new rows, and scrolling against
	-- stale extents lands in the wrong place
	if scrollBox.FullUpdate then
		scrollBox:FullUpdate(ScrollBoxConstants.UpdateImmediately)
	end
	-- (dataIndex, alignment, offset, noInterpolation): offset is a number, so
	-- putting the "don't animate" flag in its place is an arithmetic error
	scrollBox:ScrollToElementDataIndex(index, ScrollBoxConstants.AlignBegin, 0, true)
end

function module:Refresh()
	if not self.window then return end
	local scrollBox = self.window.nav.scrollBox
	local provider = self:GetDataProvider()
	local wasAtTop = topKey(scrollBox, provider)

	local entries = self:BuildEntries()
	-- these are fresh entries, so nothing carries over; the map reads this too
	wipe(self.stateCache)
	provider:Flush()
	provider:InsertTable(entries)
	restoreTop(scrollBox, provider, wasAtTop)
	self:AfterRefresh()
end

-- Whatever else has to catch up once the rows have. Shared with SoftRefresh.
function module:AfterRefresh()
	self:UpdateTitle()
	-- just the toggles: rebuilding the whole pane would drop and remake the loot
	-- window on every sighting, which flickers for no gain
	if self.window.detailPane and self.window.detailPane.mobid then
		self.window.detailPane:RefreshName()
		self.window.detailPane:RefreshActions()
	end
	if self.window.mapPane and self.window.mapPane:IsShown() then
		self.window.mapPane:RefreshPins()
	end
end

function module:UpdateTitle()
	if not self.window then return end
	self.window.title:SetFormattedText("%s  |cff999999%d rares|r",
		C_AddOns.GetAddOnMetadata(myname, "Title"), self:CountKnownMobs())
end

local knownMobCount
function module:CountKnownMobs()
	if not knownMobCount then
		knownMobCount = 0
		for _, data in pairs(core.datasources) do
			for _ in pairs(data) do knownMobCount = knownMobCount + 1 end
		end
	end
	return knownMobCount
end

-- Notability state

-- Also keyed by id for the map, whose pins ask about the same mobs the rows do
module.stateCache = {}

--[[
A row works out its state the first time it is drawn, not when the list is built.
A branch of a thousand mobs then costs a thousand table inserts instead of a
thousand trips through the reward system, since only the rows on screen answer.

Rows drawn in the same frame share one set of reward caches. MobState drops them
on every call, so without the hold each row would discard the item lookups the
row above it had just paid for.
]]
--[[
Everything else that draws a mob's state caches its loot first -- the overlay per
pin, the broker per row. Without that the item data is missing, and
itemBindOnEquip deliberately answers "yes" so a rare is not missed while its
items load. That is the right trade for an announcement, but here it puts the
mount icon on every rare that drops one, collected or not.

So ask for the data, and redraw once it lands. A callback rather than a bare
Loot.Cache because these rows stay put; the map and the broker get away with it
by being rebuilt constantly.
]]
local lootRequested = {}
function module:RequestLoot(id)
	if lootRequested[id] then return end
	lootRequested[id] = true
	local immediate = true
	ns.Loot.OnceAllLootLoaded(id, false, function()
		-- already cached: what was just worked out used real data
		if immediate then return end
		self:ScheduleRefresh(true)
	end)
	immediate = false
end

local filling = false
local function ensureFilled(entry)
	if entry.filled or entry.kind ~= KIND_MOB then return end
	module:RequestLoot(entry.id)
	if not filling then
		filling = true
		ns.HoldRunCaches()
		C_Timer.After(0, function()
			filling = false
			ns.ReleaseRunCaches()
		end)
	end
	local id = entry.id
	entry.state = ns.MobState(id)
	entry.color = ns.MobStateColor[entry.state]
	entry.icon = ns.MobStateIcons[module:IconTheme()][entry.state]
	entry.ignored = core.db.global.ignore[id]
	entry.filled = true
	module.stateCache[id] = entry.state
end

-- Spotting or ignoring a rare changes what a row says, not which rows there are,
-- unless a filter decides membership from exactly that. When it does not, redraw
-- in place: a rebuild would lose the scroll position over a badge.
function module:InvalidateMob(_, id)
	-- meeting a mob is how its name becomes known, so drop the kept label
	if type(id) == "number" then
		mobLabels[id] = nil
	end
	if not self.window then return end
	local db = self.db.profile
	local membershipCouldChange = db.filterIgnored ~= "show" or db.filterWatched
	self:ScheduleRefresh(not membershipCouldChange)
end
module.InvalidateAll = module.InvalidateMob

-- Redraw every row from the entries already in the provider. No flush, so the
-- list does not move.
function module:SoftRefresh()
	if not self.window then return end
	wipe(self.stateCache)
	for _, entry in self.dataProvider:Enumerate() do
		entry.filled = nil
		if entry.kind == KIND_MOB then
			entry.label = labelFor(entry.id)
		end
	end
	self.window.nav.scrollBox:ForEachFrame(function(line)
		if line.data then line:SetData(line.data) end
	end)
	self:AfterRefresh()
end

-- Several of these can arrive together -- a datasource toggle fires Ready, which
-- is a whole rebuild -- so coalesce into one pass at the end of the frame.
function module:ScheduleRefresh(soft)
	if not self.window then return end
	if not soft then self.refreshHard = true end
	if self.refreshPending then return end
	self.refreshPending = true
	C_Timer.After(0, function()
		local hard = self.refreshHard
		self.refreshPending, self.refreshHard = nil, nil
		if hard then
			self:Refresh()
		else
			self:SoftRefresh()
		end
	end)
end

-- Ready means the lookup tables were rebuilt, which is how a datasource getting
-- switched on or off reaches us.
function module:OnDataReady()
	zonesBySource = nil
	achievementsBySource = nil
	mergedIndex = nil
	knownMobCount = nil
	wipe(sortedMobs)
	wipe(mobLabels)
	wipe(lootRequested)
	self:ScheduleRefresh()
end

-- The rows and the map pins both describe a mob, and should not describe it
-- differently. Anchoring stays with the caller; only what it says is shared.
function module:FillMobTooltip(tooltip, id, uiMapID, coord)
	tooltip:AddLine(core:GetMobLabel(id))
	if uiMapID then
		local where = core.zone_names[uiMapID] or UNKNOWN
		if coord then
			local x, y = core:GetXY(coord)
			tooltip:AddDoubleLine(where, ("%.1f, %.1f"):format(x * 100, y * 100))
		else
			tooltip:AddDoubleLine(LOCATION_COLON, where)
		end
		if not core:IsMobInPhase(id, uiMapID) then
			tooltip:AddLine("Belongs to a different version of this zone", 1, 0.5, 0.5, true)
		end
	end
	tooltip:AddDoubleLine("Last seen", core:FormatLastSeen(core.db.global.mob_seen[id]))
	ns:UpdateTooltipWithCompletion(tooltip, id)
	ns.Loot.Summary.UpdateTooltip(tooltip, id)
	local data = ns.mobdb[id]
	if data and data.notes then
		tooltip:AddLine(core:RenderString(data.notes, data), 1, 1, 1, true)
	end
end

-- Rows

local NavLineMixin = {}

function NavLineMixin:Init()
	self:SetHeight(module.window.rowHeight)
	self:EnableMouse(true)
	self:RegisterForClicks("AnyUp")

	self.highlight = self:CreateTexture(nil, "HIGHLIGHT")
	self.highlight:SetAllPoints()
	self.highlight:SetColorTexture(1, 1, 1, 0.1)

	self.selected = self:CreateTexture(nil, "BACKGROUND")
	self.selected:SetAllPoints()
	self.selected:SetColorTexture(1, 1, 1, 0.15)
	self.selected:Hide()

	self.toggle = module:CreateRedButton(self)
	self.toggle:SetSize(16, 16)
	self.toggle:SetPoint("LEFT", 2, 0)
	self.toggle:SetScript("OnClick", function()
		if self.data then module:ToggleExpanded(self.data.key) end
	end)

	self.icon = self:CreateTexture(nil, "ARTWORK")
	self.icon:SetSize(14, 14)

	self.title = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	self.title:SetJustifyH("LEFT")
	self.title:SetWordWrap(false)

	self.count = self:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	self.count:SetPoint("RIGHT", -6, 0)
	self.count:SetJustifyH("RIGHT")

	-- watched or ignored, so the state shows while browsing rather than only on
	-- going to look for it
	self.badge = self:CreateTexture(nil, "OVERLAY")
	self.badge:SetSize(12, 12)
	self.badge:SetPoint("RIGHT", self.count, "LEFT", -4, 0)
	self.badge:Hide()

	self:SetScript("OnEnter", self.Scripts.OnEnter)
	self:SetScript("OnLeave", self.Scripts.OnLeave)
	self:SetScript("OnClick", self.Scripts.OnClick)
end

function NavLineMixin:SetData(data)
	self.data = data
	local isMob = data.kind == KIND_MOB
	-- first time this row is drawn, work out what it has to say
	ensureFilled(data)
	local indent = 4 + (data.indent * 12)

	self.toggle:SetShown(not isMob and not data.noToggle)
	self.toggle:ClearAllPoints()
	self.toggle:SetPoint("LEFT", indent, 0)
	if self.toggle:IsShown() then
		self.toggle:SetButtonMode(module.db.profile.expanded[data.key] and "Minus" or "Plus")
	end

	if isMob then
		local watched = core.db.global.custom.any[data.id]
		self.badge:SetShown(data.ignored or watched or false)
		if data.ignored then
			self.badge:SetAtlas("common-icon-redx")
		elseif watched then
			self.badge:SetAtlas("VignetteKill")
		end
	else
		self.badge:Hide()
	end

	self.icon:ClearAllPoints()
	self.title:ClearAllPoints()
	if isMob then
		self.icon:SetShown(data.icon ~= nil)
		if data.icon then
			self.icon:SetAtlas(data.icon.atlas)
			self.icon:SetVertexColor(data.icon.r, data.icon.g, data.icon.b, data.icon.a)
		end
		self.icon:SetPoint("LEFT", indent, 0)
		self.title:SetPoint("LEFT", self.icon, "RIGHT", 4, 0)
		self.title:SetText(data.label or labelFor(data.id))
		if data.color then
			self.title:SetTextColor(unpack(data.color))
		else
			self.title:SetTextColor(1, 1, 1)
		end
		self.title:SetAlpha(data.ignored and 0.4 or 1)
		self.count:SetText("")
	else
		self.icon:Hide()
		self.title:SetPoint("LEFT", self.toggle, "RIGHT", 4, 0)
		self.title:SetTextColor(1, 0.82, 0)
		self.title:SetAlpha(1)
		if data.kind == KIND_SOURCE and data.source and not data.noToggle then
			-- there's no checkbox on the row any more, so say it in the label
			local off = not core.db.global.datasources[data.source]
			self.title:SetText(off and (data.source .. " |cff999999(not loaded)|r") or data.source)
			self.title:SetAlpha(off and 0.5 or 1)
		else
			self.title:SetText(data.kind == KIND_SOURCE and data.source or data.label or "")
		end
		self.count:SetText(data.count or "")
	end
	self.title:SetPoint("RIGHT", self.count, "LEFT", -4, 0)

	self.selected:SetShown(isMob and module.selectedMob == data.id)
end

NavLineMixin.Scripts = {
	OnEnter = function(self)
		local data = self.data
		if not (data and data.kind == KIND_MOB) then return end
		local tooltip = ns.Tooltip.Get("Browser")
		tooltip:SetOwner(self, "ANCHOR_NONE")
		if self:GetCenter() < (UIParent:GetWidth() / 2) then
			tooltip:SetPoint("TOPLEFT", self, "TOPRIGHT")
		else
			tooltip:SetPoint("TOPRIGHT", self, "TOPLEFT")
		end
		module:FillMobTooltip(tooltip, data.id, data.uiMapID)
		tooltip:Show()
	end,

	OnLeave = function()
		ns.Tooltip.Get("Browser"):Hide()
	end,

	OnClick = function(self, button)
		local data = self.data
		if not data then return end
		-- the "showing the first N of M" row is a message, not a control
		if data.noToggle then return end
		if button == "RightButton" then
			-- by value: rows recycle, and a menu holding onto this frame would
			-- act on whatever scrolled into it
			return module:ShowRowMenu(self, data.kind, data.id, data.key, data.uiMapID)
		end
		if data.kind == KIND_MOB then
			return module:SelectMob(data.id, data.uiMapID)
		end
		-- Clicking a zone heading shows the whole zone rather than expanding it:
		-- the +/- does the expanding, and this is the way back to "all of them"
		-- once you've drilled into one rare.
		if data.kind == KIND_ZONE and data.uiMapID then
			return module:SelectZone(data.uiMapID)
		end
		module:ToggleExpanded(data.key)
	end,
}

function module:ShowRowMenu(owner, kind, id, key, uiMapID)
	if not (_G.MenuUtil and MenuUtil.CreateContextMenu) then
		return self:ShowConfigMenu(owner)
	end
	MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
		rootDescription:SetTag("MENU_SILVERDRAGON_BROWSER_ROW")
		if kind == KIND_MOB then
			rootDescription:CreateTitle(core:GetMobLabel(id) or tostring(id))
			rootDescription:CreateCheckbox(IGNORE, function()
				return core.db.global.ignore[id]
			end, function()
				core:SetIgnore(id, not core.db.global.ignore[id])
				return MenuResponse.Refresh
			end)
			rootDescription:CreateCheckbox("Watch everywhere", function()
				return core.db.global.custom.any[id]
			end, function()
				core:SetCustom('any', id, not core.db.global.custom.any[id])
				return MenuResponse.Refresh
			end)
			local overlay = core:GetModule("Overlay", true)
			if overlay then
				rootDescription:CreateCheckbox("Hide from the map", function()
					return overlay.db.profile.hidden[id]
				end, function()
					overlay.db.profile.hidden[id] = not overlay.db.profile.hidden[id] or nil
					overlay:Update()
					return MenuResponse.Refresh
				end)
			end
			return
		end
		-- a header: what the options panel's All / None buttons did, said plainly
		rootDescription:CreateTitle(owner.title:GetText() or "")
		local ids = {}
		for _, entry in module.dataProvider:Enumerate() do
			if entry.kind == KIND_MOB and entry.key:find(key, 1, true) == 1 then
				table.insert(ids, entry.id)
			end
		end
		local function setAll(ignored)
			for _, mobid in ipairs(ids) do
				core:SetIgnore(mobid, ignored, true)
			end
			module:Refresh()
			return MenuResponse.CloseAll
		end
		if #ids == 0 then
			rootDescription:CreateTitle("Expand this to change what's ignored")
			return
		end
		rootDescription:CreateButton(("Ignore all %d of these"):format(#ids), function()
			return setAll(true)
		end)
		rootDescription:CreateButton(("Stop ignoring all %d of these"):format(#ids), function()
			return setAll(false)
		end)
	end)
end

function module:InitNavLine(line, data)
	if not line.Init then
		Mixin(line, NavLineMixin)
		line:Init()
	end
	line:SetData(data)
end

-- Clicking a pin on the map should show you where that rare lives in the list,
-- not leave you hunting for it.
function module:ScrollToMob(id)
	if not self.window then return end
	local scrollBox, provider = self.window.nav.scrollBox, self:GetDataProvider()
	if not (scrollBox.ScrollToNearest and provider.FindIndexByPredicate) then return end
	local index = provider:FindIndexByPredicate(function(entry)
		return entry.kind == KIND_MOB and entry.id == id
	end)
	if not (index and index > 0) then return end
	-- ScrollToNearest leaves it alone when it's already in view, which is what
	-- we want: clicking a pin shouldn't shuffle the list about for no reason
	scrollBox:ScrollToNearest(index, 0, true)
end

function module:SelectZone(uiMapID)
	self.selectedMob = nil
	self.selectedZone = uiMapID
	if not self.window then return end
	self.window.nav.scrollBox:ForEachFrame(function(line)
		if line.data then line:SetData(line.data) end
	end)
	self:SetDetailMob(nil)
	self:SetMapZone(uiMapID)
	self:SetMapFocus(nil)
end

function module:SelectMob(id, uiMapID)
	self.selectedMob = id
	-- keep the map where it is when the mob's in it, otherwise go to whichever
	-- of its zones is nearest to you
	if not uiMapID then
		local data = ns.mobdb[id]
		local current = self.window and self.window.mapPane and self.window.mapPane.uiMapID
		if current and data and data.locations and data.locations[current] then
			uiMapID = current
		else
			uiMapID = core:GetClosestLocationForMob(id)
		end
	end
	self.selectedZone = uiMapID
	if self.window then
		self.window.nav.scrollBox:ForEachFrame(function(line)
			if line.data then line:SetData(line.data) end
		end)
		self:SetDetailMob(id)
		self:SetMapZone(uiMapID)
		self:SetMapFocus(id)
		self:ScrollToMob(id)
	end
	-- the overlay listens for these to focus its map pin; the names are the
	-- broker's because it got there first, and it ships as its own addon
	core.events:Fire("BrokerMobClick", id)
end
