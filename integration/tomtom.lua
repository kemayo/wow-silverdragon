local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("TomTom", "AceEvent-3.0")
local Debug = core.Debug
local db

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("TomTom", {
		profile = {
			enabled = true,
			duration = 120,
			tomtom = true,
			dbm = false,
			replace = false,
		},
	})
	db = self.db.profile

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.tomtom = {
			tomtom = {
				type = "group",
				name = "Waypoints",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					about = config.desc("When we see a mob via its minimap icon, we can ask an arrow to point us to it", 0),
					enabled = config.toggle("Automatically", "Make a waypoint for the mob as soon as it's seen", 20),
					tomtom = config.toggle("Use TomTom", "If TomTom is installed, use it instead", 25, nil, function() return not TomTom end),
					dbm = config.toggle("Use DeadlyBossMods", "If DeadlyBossMods is installed, use it instead", 26, nil, function() return not DBM end),
					replace = config.toggle("Replace waypoints", "Replace an existing waypoint if one is set (doesn't apply to TomTom)", 30),
					duration = {
						type = "range",
						name = "Duration",
						desc = "How long to wait before clearing the waypoint if you don't reach it",
						min = 0, max = (10 * 60), step = 5,
						order = 40,
					}
				},
			},
		}
	end
end

function module:OnEnable()
	core.RegisterCallback(self, "Announce")
end

function module:Announce(_, id, zone, x, y, is_dead, source, unit)
	if not db.enabled then return end
	if source ~= "vignette" then return end
	self:PointTo(id, zone, x, y, db.duration)
end

do
	local waypoint
	function module:PointTo(id, zone, x, y, duration, force)
		if TomTom and db.tomtom then
			if waypoint then
				TomTom:RemoveWaypoint(waypoint)
			end
			waypoint = TomTom:AddWaypoint(zone, x, y, {
				title = core:GetMobLabel(id) or UNKNOWN,
				persistent = false,
				minimap = false,
				world = false,
				cleardistance = 25
			})
			waypoint.mobid = id
			if duration and duration > 0 then
				C_Timer.After(duration, function()
					if waypoint and waypoint.mobid == id then
						TomTom:RemoveWaypoint(waypoint)
						-- tomtom doesn't need to restore a waypoint, because it has a stack
					end
				end)
			end
		end
		if DBM and db.dbm then
			DBM.Arrow:ShowRunTo(
				x * 100,
				y * 100,
				25, -- clear distance
				(duration and duration > 0) and duration or nil,
				true, -- "legacy" which I think means to use per-zone coords rather than world coords
				true, -- unused
				core:GetMobLabel(id) or UNKNOWN,
				zone
			)
		end
		if (DBM and db.dbm) or (TomTom and db.tomtom) then
			return
		end
		if C_Map.CanSetUserWaypointOnMap(zone) and x > 0 and y > 0 then
			local current = C_Map.GetUserWaypoint()
			local wasTracked = C_SuperTrack.IsSuperTrackingUserWaypoint()
			local uiMapPoint = UiMapPoint.CreateFromCoordinates(zone, x, y)
			if (not current) or db.replace or force then
				C_Map.SetUserWaypoint(uiMapPoint)
				C_SuperTrack.SetSuperTrackedUserWaypoint(true)
				waypoint = uiMapPoint
				if duration and duration > 0 then
					C_Timer.After(duration, function()
						local stillCurrent = C_Map.GetUserWaypoint()
						if stillCurrent and waypoint and waypoint.position and waypoint.position:IsEqualTo(stillCurrent.position) then
							C_Map.ClearUserWaypoint()
							if current then
								-- restore the one we replaced
								C_Map.SetUserWaypoint(current)
								C_SuperTrack.SetSuperTrackedUserWaypoint(wasTracked)
							end
						end
					end)
				end
			end
		end
	end
end
