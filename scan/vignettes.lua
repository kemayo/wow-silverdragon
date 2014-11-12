local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Vignettes", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local globaldb
function module:OnInitialize()
	globaldb = core.db.global

	self.db = core.db:RegisterNamespace("Scan_Vignettes", {
		profile = {
			enabled = true,
			location = false,
		},
	})

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.scanning.plugins.vignettes = {
			vignettes = {
				type = "group",
				name = "Vignettes",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					enabled = config.toggle("Enabled", "Scan minimap vignettes (it's what Blizzard calls them, okay?)", 10),
					location = config.toggle("Record location on vignette appearance", "Record the mob's location when the vignette triggers for it. If this isn't set, it'll wait until you target it and are within interaction range to store the location.", 30),
				},
			},
		}
	end
end

function module:OnEnable()
	self:RegisterEvent("VIGNETTE_ADDED")
end

local already_notified = {}
function module:VIGNETTE_ADDED(event, instanceid, mysterious_number)
	if not instanceid then
		-- ...just in case
		Debug("No Vignette instanceid")
		return
	end
	if already_notified[instanceid] then
		Debug("Skipping notify", "already done", id)
		return
	end
	already_notified[instanceid] = true
	local x, y, name, iconid = C_Vignettes.GetVignetteInfoFromInstanceID(instanceid)
	-- iconid seems to be 40:chests, 41:mobs
	if not name then
		Debug("Vignette instanceid bug hit", instanceid)
		return
	end
	local mob_id = globaldb.mob_id[name] or globaldb.mob_vignettes[name]
	if mob_id then
		-- it's a rare that we know about!
		-- note, we could instead try using just iconid==41, but I don't know if that's going to actually be all rares yet
		self:NotifyIfNeeded(mob_id)
	end
end

function module:NotifyIfNeeded(id)
	local current_zone, x, y = core:GetPlayerLocation()
	local newloc = false
	if self.db.profile.location and not globaldb.mob_tameable[id] then
		--Pull some info from global database since it's not sent from syncs, and we don't want
		-- to erase that info with savemob function just copy it over.
		local creature_type = globaldb.mob_type[id]
		local elite = globaldb.mob_elite[id]
		local level = globaldb.mob_level[id]
		local name = globaldb.mob_name[id]
		newloc = core:SaveMob(id, name, current_zone, x, y, level, elite, creature_type)
	end
	core:NotifyMob(id, globaldb.mob_name[id], current_zone, x, y, false, newloc, "vignette", false, nil, true)
end
