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

function module:WorkOutMobFromVignette(name, ...)
	if ns.vignetteMobLookup[name] then
		Debug("vignetteMobLookup", name, ns.vignetteMobLookup[name])
		return self:NotifyForMobs(ns.vignetteMobLookup[name], ...)
	end
	local questid = core:IdForQuest(name)
	if questid and ns.questMobLookup[questid] then
		Debug("questMobLookup", name, ns.questMobLookup[name])
		return self:NotifyForMobs(ns.questMobLookup[questid], ...)
	end
	local mobid = core:IdForMob(name)
	if mobid then
		Debug("name", name, mobid)
		return self:NotifyIfNeeded(mobid, ...)
	end
	Debug("Couldn't work out mob from vignette", name)
end
function module:NotifyForMobs(mobs, ...)
	for mobid in pairs(mobs) do
		self:NotifyIfNeeded(mobid, ...)
	end
end

local already_notified = {}
function module:VIGNETTE_MINIMAP_UPDATED(event, instanceid, onMinimap, ...)
	Debug("VIGNETTE_ADDED", instanceid, onMinimap, ...)
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
	local current_zone = HBD:GetPlayerZone()
	local vignetteInfo = C_VignetteInfo.GetVignetteInfo(instanceid)
	local position = C_VignetteInfo.GetVignettePosition(instanceid, current_zone)

	if not (vignetteInfo and vignetteInfo.name)  then
		Debug("Vignette instanceid bug hit", instanceid, vignetteInfo)
		return
	end
	self:WorkOutMobFromVignette(vignetteInfo.name, position.x, position.y, "vignette")
end
function module:VIGNETTES_UPDATED()
	local vignetteids = C_VignetteInfo.GetVignettes()
	local current_zone = HBD:GetPlayerZone()

	for i=1, #vignetteids do
		local instanceid = vignetteids[i]
		local vignetteInfo = C_VignetteInfo.GetVignetteInfo(instanceid)

		if vignetteInfo and vignetteInfo.onWorldMap and not already_notified[instanceid] then
			local position = C_VignetteInfo.GetVignettePosition(instanceid, current_zone)
			self:WorkOutMobFromVignette(vignetteInfo.name, position.x, position.y, "point-of-interest")
			already_notified[instanceid] = true
		end
	end
end

function module:NotifyIfNeeded(id, x, y, variant)
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
	core:NotifyForMob(id, current_zone, x, y, false, variant or "vignette", false, nil, force)
end
