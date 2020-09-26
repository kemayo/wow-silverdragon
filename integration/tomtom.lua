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
		},
	})
	db = self.db.profile

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.tomtom = {
			tomtom = {
				type = "group",
				name = "TomTom",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					about = config.desc("When we see a mob via its minimap icon, we can ask TomTom to point us to it", 0),
					enabled = config.toggle("Point to it", "Tell TomTom about the mob", 30),
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

do
	local waypoint
	function module:Announce(_, id, zone, x, y, is_dead, source, unit)
		if not TomTom then return end
		if not db.enabled then return end
		if source ~= "vignette" then return end
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
		if db.duration and db.duration > 0 then
			C_Timer.After(db.duration, function()
				if waypoint and waypoint.mobid == id then
					TomTom:RemoveWaypoint(waypoint)
				end
			end)
		end
	end
end
