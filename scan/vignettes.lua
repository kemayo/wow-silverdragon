local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Vignettes", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-1.0")

local globaldb
function module:OnInitialize()
	globaldb = core.db.global

	self.db = core.db:RegisterNamespace("Scan_Vignettes", {
		profile = {
			enabled = true,
			location = false,
			pointsofinterest = true,
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
					pointsofinterest = config.toggle("Show alerts for point of interest vignettes added to world map itself")
				},
			},
		}
	end
end

function module:OnEnable()
	self:RegisterEvent("VIGNETTE_ADDED")
	self:RegisterEvent("WORLD_MAP_UPDATE")
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
	-- iconid seems to be 40:chests, 41:mobs, 4733:star (most Legion stuff)
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
	-- Legion mobs/events generic alert and print for now since no data yet
	-- TODO: get data, and remove this
	if iconid == 4733 then
		core:Print("Vignette Nearby: "..name)
		PlaySoundFile("Sound\\Doodad\\PortcullisActive_Closed.ogg", "Master")
	end
end

local GetNumMapLandmarks = GetNumMapLandmarks
local GetMapLandmarkInfo = GetMapLandmarkInfo
function module:WORLD_MAP_UPDATE(event)
	if not self.db.profile.pointsofinterest then return end
	-- local poiCount = GetNumMapLandmarks()
	for i=1, NUM_WORLDMAP_POIS do
		local name, description, texture_index, x, y = GetMapLandmarkInfo(i)
		if name and texture_index ~= 197 then
			local mob_id = globaldb.mob_id[name] or globaldb.mob_vignettes[name]
			if mob_id then
				-- it's a rare that we know about!
				self:NotifyIfNeeded(mob_id, nil, x, y, "point-of-interest")
			end
		end
	end
end

function module:NotifyIfNeeded(id, instanceid, x, y, variant)
	local current_zone
	local force = true
	if x and y then
		--Triggered by map update, vignette has exact location that does not match player, so update x, y
		current_zone = HBD:GetPlayerZone()
		force = false
	else
		x, y, current_zone = HBD:GetPlayerZonePosition()
	end
	if not (current_zone and x and y) then
		return
	end
	local newloc = false
	if self.db.profile.location and not globaldb.mob_tameable[id] then
		--Pull some info from global database since it's not sent from syncs, and we don't want
		-- to erase that info with savemob function just copy it over.
		if globaldb.mob_name[id] then
			newloc = core:SaveMob(id, globaldb.mob_name[id], current_zone, x, y, globaldb.mob_level[id], globaldb.mob_elite[id], globaldb.mob_type[id])
		end
	end
	core:NotifyMob(id, globaldb.mob_name[id], current_zone, x, y, false, newloc, variant or "vignette", false, nil, force)
end
