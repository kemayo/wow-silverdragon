local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Vignettes", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-2.0")

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Scan_Vignettes", {
		profile = {
			enabled = true,
			pointsofinterest = true,
			visibleOnly = false,
			loot = true,
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
					pointsofinterest = config.toggle("World points-of-interest", "Show alerts for point of interest vignettes added to world map itself", 20),
					visibleOnly = config.toggle("Wait until visible", "Don't notify until the vignette is actually visible on the minimap", 30),
					loot = config.toggle("Scan for treasure", ("Also scan for treasures (%s / %s)"):format(CreateAtlasMarkup("vignetteloot", 16, 16), CreateAtlasMarkup("vignettelootelite", 16, 16)), 40),
				},
			},
		}
	end
end

function module:OnEnable()
	self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	self:RegisterEvent("VIGNETTES_UPDATED")
end

-- handy debug command:
-- /dump C_VignetteInfo.GetVignetteInfo(C_VignetteInfo.GetVignettes()[1])

local already_notified = {
	-- [instanceid] = true
}
local already_notified_loot = {
	-- [vignetteid] = time()
}

local MOB = 1
local LOOT = 2
local visible_overrides = {
	[1550] = LOOT, -- The Shadowlands, because of...
	[1565] = LOOT, -- Ardenweald, where all chests are notified from the entire zone
	-- But also all the Shadowlands zones, because callings quests are fucky about this and I need to work out a heuristic for them
	[1533] = LOOT, -- Bastion
	[1536] = LOOT, -- Maldraxxus
	[1525] = LOOT, -- Revendreth
	[1543] = true, -- Maw
}
local vignette_denylist = {
	[637] = true, -- Garrison Cache
}
local function shouldShowNotVisible(vignetteInfo, zone)
	local variant = (vignetteInfo.atlasName == "VignetteLoot" or vignetteInfo.atlasName == "VignetteLootElite") and LOOT or MOB
	if zone and (visible_overrides[zone] == true or visible_overrides[zone] == variant) then
		return false
	end
	local info = C_Map.GetMapInfo(zone)
	if info and info.parentMapID then
		return shouldShowNotVisible(vignetteInfo, info.parentMapID)
	end
	return not module.db.profile.visibleOnly
end

function module:WorkOutMobFromVignette(instanceid)
	if not self.db.profile.enabled then return end
	if already_notified[instanceid] then return Debug("Skipping notify", "already done", instanceid) end
	if not core.db.profile.instances and IsInInstance() then return end
	local vignetteInfo = C_VignetteInfo.GetVignetteInfo(instanceid)
	if not vignetteInfo then
		return Debug("vignette had no info")
	end
	if vignette_denylist[vignetteInfo.vignetteID or 0] then
		return Debug("Vignette was on the denylist", vignetteInfo.vignetteID)
	end
	local current_zone = HBD:GetPlayerZone()
	if not current_zone or current_zone == 0 then
		return Debug("We don't know what zone we're in", current_zone)
	end
	local source = vignetteInfo.onWorldMap and "point-of-interest" or "vignette"
	local x, y
	if vignetteInfo.vignetteGUID then
		local position = C_VignetteInfo.GetVignettePosition(vignetteInfo.vignetteGUID, current_zone)
		if position then
			x, y = position:GetXY()
		end
	end
	if not vignetteInfo.onMinimap and not shouldShowNotVisible(vignetteInfo, current_zone) then
		return Debug("vignette not visible on minimap and we're only alerting for visibles")
	end
	if vignetteInfo.atlasName == "VignetteLoot" or vignetteInfo.atlasName == "VignetteLootElite" then
		if (not core.db.profile.taxi) and UnitOnTaxi('player') then
			return Debug("skipping notification", "on taxi")
		end
		if already_notified_loot[vignetteInfo.vignetteID] and time() < (already_notified_loot[vignetteInfo.vignetteID] + core.db.profile.delay) then
			return Debug("skipping notification", "delay not exceeded")
		end
		already_notified_loot[vignetteInfo.vignetteID] = time()
		core.events:Fire("SeenLoot", vignetteInfo.name, vignetteInfo.vignetteID, current_zone, x or 0, y or 0)
		return true
	end
	if vignetteInfo.objectGUID then
		-- this *may* be a mob, but it also may be something which you interact with to summon the mob
		local mobid = ns.IdFromGuid(vignetteInfo.objectGUID)
		if mobid and ns.mobdb[mobid] then
			Debug("mob from guid", vignetteInfo.objectGUID, mobid)
			return self:NotifyIfNeeded(mobid, current_zone, x, y, source, instanceid)
		end
	end
	-- And now, comparatively uncommon fallbacks:
	if vignetteInfo.vignetteID and ns.vignetteMobLookup[vignetteInfo.vignetteID] then
		-- IDs are based on https://bnet.marlam.in/dbc.php?dbc=vignette.db2
		Debug("vignetteMobLookup", vignetteInfo.name, vignetteInfo.vignetteID, ns.vignetteMobLookup[vignetteInfo.vignetteID])
		return self:NotifyForMobs(ns.vignetteMobLookup[vignetteInfo.vignetteID], current_zone, x, y, source, instanceid)
	end
	if vignetteInfo.name then
		if ns.vignetteMobLookup[vignetteInfo.name] then
			Debug("vignetteMobLookup", vignetteInfo.name, vignetteInfo.vignetteID, ns.vignetteMobLookup[vignetteInfo.name])
			return self:NotifyForMobs(ns.vignetteMobLookup[vignetteInfo.name], current_zone, x, y, source, instanceid)
		end
		local questid = core:IdForQuest(vignetteInfo.name)
		if questid and ns.questMobLookup[questid] then
			Debug("questMobLookup", vignetteInfo.name, ns.questMobLookup[questid])
			return self:NotifyForMobs(ns.questMobLookup[questid], current_zone, x, y, source, instanceid)
		end
		local mobid = core:IdForMob(vignetteInfo.name)
		if mobid then
			Debug("name", vignetteInfo.name, mobid)
			return self:NotifyIfNeeded(mobid, current_zone, x, y, source, instanceid)
		end
	end
	Debug("Couldn't work out mob from vignette", vignetteInfo.name)
end
function module:NotifyForMobs(mobs, ...)
	for mobid in pairs(mobs) do
		self:NotifyIfNeeded(mobid, ...)
	end
end

function module:VIGNETTE_MINIMAP_UPDATED(event, instanceid, onMinimap, ...)
	Debug("VIGNETTE_MINIMAP_UPDATED", instanceid, onMinimap, ...)
	if not instanceid then
		-- ...just in case
		Debug("No Vignette instanceid")
		return
	end
	self:WorkOutMobFromVignette(instanceid)
end
function module:VIGNETTES_UPDATED()
	-- Debug("VIGNETTES_UPDATED")
	local vignetteids = C_VignetteInfo.GetVignettes()

	-- Interesting point: these show up here before they're on the minimap. This means that VIGNETTE_MINIMAP_UPDATED is actually almost never going to trip this notification now...

	for i=1, #vignetteids do
		self:WorkOutMobFromVignette(vignetteids[i])
	end
end

function module:NotifyIfNeeded(id, current_zone, x, y, variant, instanceid)
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
	already_notified[instanceid] = true
	return core:NotifyForMob(id, current_zone, x, y, false, variant or "vignette", false, nil, force)
end
