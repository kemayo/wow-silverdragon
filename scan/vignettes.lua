local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Vignettes", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-2.0")

local globaldb
function module:OnInitialize()
	globaldb = core.db.global

	self.db = core.db:RegisterNamespace("Scan_Vignettes", {
		profile = {
			enabled = true,
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
					pointsofinterest = config.toggle("Show alerts for point of interest vignettes added to world map itself")
				},
			},
		}
	end
end

function module:OnEnable()
	self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	self:RegisterEvent("VIGNETTES_UPDATED")
end

function module:WorkOutMobFromVignette(instanceid)
	local vignetteInfo = C_VignetteInfo.GetVignetteInfo(instanceid)
	if not vignetteInfo then
		return Debug("vignette had no info")
	end
	if vignetteInfo.atlasName == "VignetteLoot" then
		return Debug("skipping loot vignette")
	end
	local source = vignetteInfo.onWorldMap and "point-of-interest" or "vignette"
	local current_zone = HBD:GetPlayerZone()
	local x, y
	if current_zone and vignetteInfo.vignetteGUID then
		local position = C_VignetteInfo.GetVignettePosition(vignetteInfo.vignetteGUID, current_zone)
		if position then
			x, y = position:GetXY()
		end
	end
	if vignetteInfo.objectGUID then
		-- this *may* be a mob, but it also may be something which you interact with to summon the mob
		local mobid = ns.IdFromGuid(vignetteInfo.objectGUID)
		if mobid and ns.mobdb[mobid] then
			Debug("mob from guid", vignetteInfo.objectGUID, mobid)
			return self:NotifyIfNeeded(mobid, current_zone, x, y, source)
		end
	end
	-- And now, comparatively uncommon fallbacks:
	if vignetteInfo.vignetteID and ns.vignetteMobLookup[vignetteInfo.vignetteID] then
		-- IDs are based on https://bnet.marlam.in/dbc.php?dbc=vignette.db2
		Debug("vignetteMobLookup", vignetteInfo.name, vignetteInfo.vignetteID, ns.vignetteMobLookup[vignetteInfo.vignetteID])
		return self:NotifyForMobs(ns.vignetteMobLookup[vignetteInfo.vignetteID], current_zone, x, y, source)
	end
	if vignetteInfo.name then
		if ns.vignetteMobLookup[vignetteInfo.name] then
			Debug("vignetteMobLookup", vignetteInfo.name, vignetteInfo.vignetteID, ns.vignetteMobLookup[vignetteInfo.name])
			return self:NotifyForMobs(ns.vignetteMobLookup[vignetteInfo.name], current_zone, x, y, source)
		end
		local questid = core:IdForQuest(vignetteInfo.name)
		if questid and ns.questMobLookup[questid] then
			Debug("questMobLookup", vignetteInfo.name, ns.questMobLookup[questid])
			return self:NotifyForMobs(ns.questMobLookup[questid], current_zone, x, y, source)
		end
		local mobid = core:IdForMob(vignetteInfo.name)
		if mobid then
			Debug("name", vignetteInfo.name, mobid)
			return self:NotifyIfNeeded(mobid, current_zone, x, y, source)
		end
	end
	Debug("Couldn't work out mob from vignette", vignetteInfo.name)
end
function module:NotifyForMobs(mobs, ...)
	for mobid in pairs(mobs) do
		self:NotifyIfNeeded(mobid, ...)
	end
end

local already_notified = {}
function module:VIGNETTE_MINIMAP_UPDATED(event, instanceid, onMinimap, ...)
	Debug("VIGNETTE_MINIMAP_UPDATED", instanceid, onMinimap, ...)
	if not instanceid then
		-- ...just in case
		Debug("No Vignette instanceid")
		return
	end
	if already_notified[instanceid] then
		Debug("Skipping notify", "already done", instanceid)
		return
	end
	self:WorkOutMobFromVignette(instanceid)
	already_notified[instanceid] = true
end
function module:VIGNETTES_UPDATED()
	-- Debug("VIGNETTES_UPDATED")
	local vignetteids = C_VignetteInfo.GetVignettes()

	-- Interesting point: these show up here before they're on the minimap. This means that VIGNETTE_MINIMAP_UPDATED is actually almost never going to trip this notification now...

	for i=1, #vignetteids do
		local instanceid = vignetteids[i]
		if not already_notified[instanceid] then
			self:WorkOutMobFromVignette(instanceid)
			already_notified[instanceid] = true
		end
	end
end

function module:NotifyIfNeeded(id, current_zone, x, y, variant)
	local force = true
	if x and y then
		--Triggered by map update, vignette has exact location that does not match player, so update x, y
		force = false
	else
		x, y = HBD:GetPlayerZonePosition()
	end
	if not (current_zone and x and y) then
		return
	end
	core:NotifyForMob(id, current_zone, x, y, false, variant or "vignette", false, nil, force)
end
