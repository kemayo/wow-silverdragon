local myname, ns = ...

-- When an area POI is running, and when the next one starts. Blizzard answers
-- this in three places that don't know about each other: the map lists the POIs
-- on it, the POI says how long it has left, and the event scheduler says when a
-- future one begins. This asks all three as one question.
--
-- Everything taking `pois` accepts one id or a list of them, because a point can
-- name several: the POI that appears on the map while the event runs is often
-- not the POI the scheduler knows it by. They answer at different times, so the
-- list is ranked and only the most informative one is reported.
--
--[[
API:
status = ns.areaPoi.GetStatus(areaPoiID[, uiMapID]) -- nil if nothing is known
	status.active       -- bool, it is running now
	status.secondsLeft  -- number?, how much longer it runs
	status.secondsUntil -- number?, how long until the next one starts

ns.areaPoi.GetBestStatus(pois[, uiMapID])   -> status?
ns.areaPoi.IsActive(pois[, uiMapID])        -> bool
ns.areaPoi.IsImminent(pois[, uiMapID])      -> bool -- starts within SOON
ns.areaPoi.GetName(areaPoiID[, uiMapID])    -> string?
ns.areaPoi.Describe(pois[, uiMapID][, fallbackName]) -> string, colour
ns.areaPoi.RegisterCallback(func)           -- called when one of the above changes
]]

ns.areaPoi = {}
local areaPoi = ns.areaPoi

-- What counts as "about to start". Blizzard's own reminders warn at 300; ten
-- minutes is long enough to travel there.
areaPoi.SOON = 600

local CLASSIC = WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE

-- Blizzard's wording, so it needs no translating. The two reminder strings
-- belong to the event scheduler, which the classic clients do not have.
local TIME_LEFT = _G.MAP_TOOLTIP_TIME_LEFT or "Time left: %s"
local HAS_STARTED = _G.EVENT_SCHEDULER_CHAT_REMINDER_NOW or "%s has started!"
local STARTS_IN = _G.EVENT_SCHEDULER_CHAT_REMINDER_SOON or "%1$s starts in %2$s!"

local callbacks = {}
function areaPoi.RegisterCallback(func)
	table.insert(callbacks, func)
end
local function fireCallbacks()
	for _, func in ipairs(callbacks) do
		func()
	end
end

-- The three sources below are independent. A POI can be known to one of them and
-- not the others, and its status then carries fewer fields: not every timed POI
-- has a scheduler entry, so no source is a precondition for another.

---------------------------------------------------------
-- Which POIs are on a map

local presence
do
	-- A map answers with all of its POIs at once, so ask it at most this often
	-- however many callers watch it. AREA_POIS_UPDATED clears the cache early.
	local TTL = 10
	-- Five separate lists: a POI in one is not in the others, and the plain one
	-- misses events. The classic clients have only the first two, hence the
	-- existence check below.
	local methods = {
		"GetAreaPOIForMap",
		"GetEventsForMap",
		"GetQuestHubsForMap",
		"GetDelvesForMap",
		"GetDragonridingRacesForMap",
	}
	local byMap, expires = {}, {}
	function presence(uiMapID)
		local now = time()
		-- ClearPresence drops the expiry but keeps the table it belongs to, so a
		-- missing expiry has to read as "ask again"
		if not byMap[uiMapID] or now > (expires[uiMapID] or 0) then
			local pois = wipe(byMap[uiMapID] or {})
			byMap[uiMapID] = pois
			for _, method in ipairs(methods) do
				if C_AreaPoiInfo[method] then
					for _, poi in ipairs(C_AreaPoiInfo[method](uiMapID) or {}) do
						pois[poi] = true
					end
				end
			end
			expires[uiMapID] = now + TTL
		end
		return byMap[uiMapID]
	end
	function areaPoi.ClearPresence()
		wipe(expires)
	end
end

---------------------------------------------------------
-- How long a running POI has left

local secondsLeftFor
do
	-- The time left comes from the server and goes missing for long stretches, so
	-- store it as an absolute expiry and count down from that instead of asking
	-- again every draw.
	local expires = {}
	-- Not cached, although the answer is documented as static: it is a local
	-- lookup, and a cache would keep a POI we asked about before it existed
	-- marked untimed for the rest of the session.
	local function isTimed(areaPoiID)
		if not C_AreaPoiInfo.IsAreaPOITimed then return false end
		-- the second return is hideTimerInTooltip, which Blizzard's own tooltip
		-- obeys; showing the timer it hides is the point of this file
		local poiIsTimed, hideTimerInTooltip = C_AreaPoiInfo.IsAreaPOITimed(areaPoiID)
		return poiIsTimed or false
	end
	local function ask(areaPoiID)
		if C_AreaPoiInfo.GetAreaPOISecondsLeft then
			return C_AreaPoiInfo.GetAreaPOISecondsLeft(areaPoiID)
		end
		if C_AreaPoiInfo.GetAreaPOITimeLeft then
			-- the classic clients have this instead, and it counts in minutes
			local minutes = C_AreaPoiInfo.GetAreaPOITimeLeft(areaPoiID)
			return minutes and minutes * 60
		end
	end
	function secondsLeftFor(areaPoiID)
		if not isTimed(areaPoiID) then return end
		local now = time()
		local expiry = expires[areaPoiID]
		if not expiry or now >= expiry then
			local left = ask(areaPoiID)
			expiry = (left and left > 0) and (now + left) or nil
			expires[areaPoiID] = expiry
		end
		return expiry and (expiry - now) or nil
	end
	function areaPoi.ClearExpiries()
		wipe(expires)
	end
end

---------------------------------------------------------
-- The event scheduler

local scheduledFor, ongoing, mapFor
do
	-- Scheduled entries carry absolute start and end times, so they do not go
	-- stale the way a countdown does. A refresh only drops the entries that have
	-- finished and picks up newly announced ones.
	local TTL = 10
	local scheduled, running = {}, {}
	local checked = 0
	local function refresh()
		local now = time()
		if now < checked then return end
		checked = now + TTL
		wipe(scheduled)
		wipe(running)
		local answered = false
		local events = C_EventScheduler.GetScheduledEvents()
		if events then
			answered = true
			for _, event in ipairs(events) do
				if event.endTime > now then
					-- a repeating event lists every instance; keep the soonest
					-- one that has not finished
					local existing = scheduled[event.areaPoiID]
					if not existing or event.startTime < existing.startTime then
						scheduled[event.areaPoiID] = event
					end
				end
			end
		end
		local current = C_EventScheduler.GetOngoingEvents()
		if current then
			answered = true
			for _, event in ipairs(current) do
				running[event.areaPoiID] = true
			end
		end
		if not answered then
			-- one server response feeds both lists, and it has not arrived yet;
			-- ask for it, and look again sooner than the full interval
			C_EventScheduler.RequestEvents()
			checked = now + 2
		end
	end
	if C_EventScheduler then
		function scheduledFor(areaPoiID)
			refresh()
			return scheduled[areaPoiID]
		end
		function ongoing(areaPoiID)
			refresh()
			return running[areaPoiID] or false
		end
		-- Only answers for POIs the scheduler knows, so a miss is kept askable:
		-- caching it would outlive the POI gaining an entry.
		local maps = {}
		function mapFor(areaPoiID)
			if not maps[areaPoiID] then
				maps[areaPoiID] = C_EventScheduler.GetEventUiMapID(areaPoiID)
			end
			return maps[areaPoiID]
		end
		function areaPoi.ClearSchedule()
			checked = 0
		end
	else
		-- The classic clients have no scheduler, so nothing here reports a start
		-- time and the other two sources answer alone.
		scheduledFor = function() end
		ongoing = function() return false end
		mapFor = function() end
		areaPoi.ClearSchedule = function() end
	end
end

---------------------------------------------------------
-- Putting them together

local tracked = {}
local scheduleNextCheck

-- One table per POI, refilled in place by GetStatus. A caller reads it and moves
-- on, and two calls about the same POI agree anyway, so a fresh table each time
-- would buy nothing.
local statuses = setmetatable({}, {__index = function(self, key)
	self[key] = {}
	return self[key]
end})

function areaPoi.GetStatus(areaPoiID, uiMapID)
	if not areaPoiID then return end
	uiMapID = uiMapID or mapFor(areaPoiID)
	if not tracked[areaPoiID] then
		tracked[areaPoiID] = true
		scheduleNextCheck()
	end

	local now = time()
	local status = wipe(statuses[areaPoiID])
	status.areaPoiID = areaPoiID
	status.uiMapID = uiMapID
	status.active = (uiMapID and presence(uiMapID)[areaPoiID]) or ongoing(areaPoiID) or false
	if status.active then
		status.secondsLeft = secondsLeftFor(areaPoiID)
	end

	local event = scheduledFor(areaPoiID)
	-- The schedule is rebuilt on an interval, so an entry can finish between
	-- refreshes. Using one then would count backwards.
	if event and event.endTime > now then
		if event.startTime > now then
			status.secondsUntil = event.startTime - now
		else
			-- the schedule outranks a map that has not caught up, or the wrong map
			status.active = true
			status.secondsLeft = status.secondsLeft or (event.endTime - now)
		end
	end

	if not (status.active or status.secondsUntil) then return end
	return status
end

-- Running beats upcoming, and a countdown beats no countdown. Where both count,
-- the nearer deadline wins: the ids for one event measure slightly different
-- things, so this has to order them the same way whichever comes first.
local function betterThan(status, best)
	if status.active ~= best.active then return status.active end
	if not status.active then return status.secondsUntil < best.secondsUntil end
	if not best.secondsLeft then return status.secondsLeft ~= nil end
	if not status.secondsLeft then return false end
	return status.secondsLeft < best.secondsLeft
end

-- Safe to hold the winner: GetStatus refills one table per POI, and the ids
-- after it in the list have tables of their own.
function areaPoi.GetBestStatus(pois, uiMapID)
	if type(pois) ~= "table" then return areaPoi.GetStatus(pois, uiMapID) end
	local best
	for _, areaPoiID in ipairs(pois) do
		local status = areaPoi.GetStatus(areaPoiID, uiMapID)
		if status and (not best or betterThan(status, best)) then
			best = status
		end
	end
	return best
end

function areaPoi.IsActive(pois, uiMapID)
	local status = areaPoi.GetBestStatus(pois, uiMapID)
	return (status and status.active) or false
end

function areaPoi.IsImminent(pois, uiMapID)
	local status = areaPoi.GetBestStatus(pois, uiMapID)
	return (status and status.secondsUntil and status.secondsUntil <= areaPoi.SOON) or false
end

-- Kept out of GetStatus: this allocates a table on every call, and only the
-- tooltip ever wants a name.
function areaPoi.GetInfo(areaPoiID, uiMapID)
	uiMapID = uiMapID or mapFor(areaPoiID)
	-- uiMapID became optional once the client started filling in whichever map
	-- the POI belongs to, but not far enough back to rely on
	if CLASSIC and not uiMapID then return end
	return C_AreaPoiInfo.GetAreaPOIInfo(uiMapID, areaPoiID)
end

function areaPoi.GetName(areaPoiID, uiMapID)
	local info = areaPoi.GetInfo(areaPoiID, uiMapID)
	return info and info.name
end

-- One line saying where the POI is in its cycle, and the colour to draw it in.
-- The wording is Blizzard's, so it needs no translating and agrees with what the
-- event scheduler says. A POI usually names itself before it starts, but
-- Blizzard guards against it not doing so, so a caller with a name of its own
-- can offer one.
function areaPoi.Describe(pois, uiMapID, fallbackName)
	local status = areaPoi.GetBestStatus(pois, uiMapID)
	if not status then return end
	if status.active and status.secondsLeft then
		return TIME_LEFT:format(SecondsToTime(status.secondsLeft)), GREEN_FONT_COLOR
	end
	-- the two remaining lines are sentences about the POI, so they need its name
	local name = areaPoi.GetName(status.areaPoiID, status.uiMapID) or fallbackName
	if not name then return end
	if status.active then
		return HAS_STARTED:format(name), GREEN_FONT_COLOR
	end
	local color = status.secondsUntil <= areaPoi.SOON and NORMAL_FONT_COLOR or HIGHLIGHT_FONT_COLOR
	return STARTS_IN:format(name, SecondsToTime(status.secondsUntil)), color
end

---------------------------------------------------------
-- Staying current
--
-- Two events cover a POI appearing and the schedule changing. Neither covers the
-- passage of time, so a timer is armed for the next moment an answer above can
-- change: a countdown running out, or a start crossing SOON. It is only armed
-- while something is watched, so an idle session costs nothing.

do
	local timer
	local function nextChangeFor(areaPoiID)
		local soonest
		local function consider(seconds)
			if seconds and seconds > 0 and (not soonest or seconds < soonest) then
				soonest = seconds
			end
		end
		local event = scheduledFor(areaPoiID)
		if event then
			local now = time()
			consider(event.startTime - now - areaPoi.SOON)
			consider(event.startTime - now)
			consider(event.endTime - now)
		end
		consider(secondsLeftFor(areaPoiID))
		return soonest
	end
	function scheduleNextCheck()
		if timer then
			timer:Cancel()
			timer = nil
		end
		local soonest
		for areaPoiID in pairs(tracked) do
			local seconds = nextChangeFor(areaPoiID)
			if seconds and (not soonest or seconds < soonest) then
				soonest = seconds
			end
		end
		if not soonest then return end
		-- a second past the boundary, so it has gone by when we look
		timer = C_Timer.NewTimer(soonest + 1, function()
			timer = nil
			fireCallbacks()
			scheduleNextCheck()
		end)
	end

	local watcher = CreateFrame("Frame")
	watcher:RegisterEvent("AREA_POIS_UPDATED")
	if C_EventScheduler then
		watcher:RegisterEvent("EVENT_SCHEDULER_UPDATE")
	end
	watcher:SetScript("OnEvent", function(_, event)
		if event == "AREA_POIS_UPDATED" then
			areaPoi.ClearPresence()
			areaPoi.ClearExpiries()
		else
			areaPoi.ClearSchedule()
		end
		scheduleNextCheck()
		fireCallbacks()
	end)
end
