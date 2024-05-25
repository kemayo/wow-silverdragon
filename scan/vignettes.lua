local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Vignettes", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-2.0")

local function vignetteToggle(vignetteid, name)
	return {
		type = "toggle",
		name = name,
		desc = "ID: " .. vignetteid,
		arg = vignetteid,
		-- width = "double",
		descStyle = "inline",
		order = vignetteid,
	}
end

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Scan_Vignettes", {
		profile = {
			enabled = true,
			pointsofinterest = true,
			visibleOnly = false,
			zoneInfinite = true,
			ignore = {
				-- [id] = "name",
			},
			ignore_type = {
				-- [atlas:lower()] = true
			},
		},
	})

	self.compat_disabled = (LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_MISTS_OF_PANDARIA or 999)) -- missing on classic_era

	-- migrate!
	local db = self.db.profile
	if db.loot == false then
		db.ignore_type.vignetteloot = true
		db.ignore_type.vignettelootelite = true
		db.loot = nil
	end

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
					zoneInfinite = config.toggle("Infinite distance vignettes", "Show alerts for vignettes that can be seen from across the entire zone (this can get really spammy in some zones)", 25),
					visibleOnly = config.toggle("Wait until visible", "Don't notify until the vignette is actually visible on the minimap", 30),
					ignore = {
						type="group",
						name=IGNORE,
						args={
							desc = config.desc("These lists will fill in as vignettes are announced. Check a box, and we'll remember to never announce that specific vignette again.", 0),
							type = {
								type = "multiselect",
								name = "Types",
								get = function(info, key) return self.db.profile.ignore_type[key] end,
								set = function(info, key, value)
									self.db.profile.ignore_type[key] = value
								end,
								values = {
									vignettekill = CreateAtlasMarkup("vignettekill", 20, 20) .. " Kill",
									vignettekillelite = CreateAtlasMarkup("vignettekillelite", 24, 24) .. " Kill elite",
									vignetteloot = CreateAtlasMarkup("vignetteloot", 20, 20) .. " Loot",
									vignettelootelite = CreateAtlasMarkup("vignettelootelite", 24, 24) .. " Loot elite",
									vignetteevent = CreateAtlasMarkup("vignetteevent", 20, 20) .. " Event",
									vignetteeventelite = CreateAtlasMarkup("vignetteeventelite", 24, 24) .. " Event elite",
									["warfront-neutralhero"] = CreateAtlasMarkup("warfront-neutralhero", 20, 20) .. " Bonus boss",
								},
								order=10,
							},
							specific = {
								type="group",
								name="Specific",
								inline=true,
								get=function(info) return self.db.profile.ignore[info.arg] end,
								set=function(info, v) self.db.profile.ignore[info.arg] = v and info.option.name or nil end,
								args={},
								order=20,
							},
						},
					},
				},
			},
		}
		local vignettes = config.options.args.scanning.plugins.vignettes.vignettes.args.ignore.args.specific.args
		for vignetteid, name in pairs(self.db.profile.ignore) do
			vignettes['vignette:'..vignetteid] = vignetteToggle(vignetteid, name)
		end
	end
end

function module:OnEnable()
	if self.compat_disabled then return end
	self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	self:RegisterEvent("VIGNETTES_UPDATED")

	core.RegisterCallback(self, "SeenVignette")
end

function module:SeenVignette(event, name, vignetteid, atlas)
	local config = core:GetModule("Config", true)
	if not config then return end
	local vignetteconfig = config.options.args.scanning.plugins.vignettes.vignettes.args.ignore.args.specific.args
	if not vignetteconfig["vignette:"..vignetteid] then
		vignetteconfig["vignette:"..vignetteid] = vignetteToggle(vignetteid, name)
	end
	local typeconfig = config.options.args.scanning.plugins.vignettes.vignettes.args.ignore.args.type.values
	if not typeconfig[atlas:lower()] then
		typeconfig[atlas:lower()] = CreateAtlasMarkup(atlas, 20, 20) .. " " .. atlas
	end
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
local visible_zonedeny = {
	-- [1550] = LOOT, -- The Shadowlands, because of...
	-- [1565] = LOOT, -- Ardenweald, where all chests are notified from the entire zone
	-- But also all the Shadowlands zones, because callings quests are fucky about this and I need to work out a heuristic for them
	-- [1533] = LOOT, -- Bastion
	-- [1536] = LOOT, -- Maldraxxus
	-- [1525] = LOOT, -- Revendreth
	[1543] = true, -- Maw (where there's just so *many*)
}
local visible_noparents = {
	[1961] = true, -- Korthia is a child of the Maw
}
local vignette_denylist = {
	[637] = true, -- Garrison Cache
}
local function shouldShowNotVisible(vignetteInfo, zone)
	local variant = (vignetteInfo.atlasName == "VignetteLoot" or vignetteInfo.atlasName == "VignetteLootElite") and LOOT or MOB
	if vignetteInfo.onWorldMap and module.db.profile.pointsofinterest and variant == MOB then
		-- If it's on the world map, it's cool
		-- BUT don't alert for treasures on the world map, because there's no time-sensitive ones so far (9.1), and
		-- it results in bursts of alerts when zoning into the Shadowlands area with the daily chests
		return not module.db.profile.visibleOnly
	end
	if vignetteInfo.zoneInfiniteAOI and not module.db.profile.zoneInfinite then
		-- It can be semi-seen from the entire zone, and so we should wait until it's actually-visible
		return false
	end
	if visible_zonedeny[zone] == true or visible_zonedeny[zone] == variant then
		return false
	end
	local info = C_Map.GetMapInfo(zone)
	if not visible_noparents[zone] and info and info.parentMapID and info.parentMapID ~= 0 then
		return shouldShowNotVisible(vignetteInfo, info.parentMapID)
	end
	return not module.db.profile.visibleOnly
end

function module:WorkOutMobFromVignette(instanceid)
	if not self.db.profile.enabled then return end
	if already_notified[instanceid] then
		return --Debug("Skipping notify", "already done", instanceid)
	end
	if not core.db.profile.instances and IsInInstance() then return end
	local vignetteInfo = C_VignetteInfo.GetVignetteInfo(instanceid)
	if not vignetteInfo then
		return -- Debug("vignette had no info")
	end
	if vignette_denylist[vignetteInfo.vignetteID or 0] then
		return -- Debug("Vignette was on the denylist", vignetteInfo.vignetteID)
	end
	if self.db.profile.ignore[vignetteInfo.vignetteID] then
		return -- Debug("Vignette was ignored", vignetteInfo.vignetteID, vignetteInfo.name)
	end
	if self.db.profile.ignore_type[vignetteInfo.atlasName:lower()] then
		return -- Debug("Vignette type not enabled", vignetteInfo.atlasName, vignetteInfo.vignetteID, vignetteInfo.name)
	end
	local current_zone = HBD:GetPlayerZone()
	if not current_zone or current_zone == 0 then
		return -- Debug("We don't know what zone we're in", current_zone)
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
		return -- Debug("vignette not visible on minimap and we're only alerting for visibles")
	end
	if vignetteInfo.atlasName == "VignetteLoot" or vignetteInfo.atlasName == "VignetteLootElite" then
		if not core:PlayerIsInteractive() then
			return -- Debug("skipping notification", "on taxi")
		end
		if already_notified_loot[vignetteInfo.vignetteGUID] and time() < (already_notified_loot[vignetteInfo.vignetteGUID] + core.db.profile.delay) then
			return -- Debug("skipping notification", "delay not exceeded")
		end
		local treasure = ns.vignetteTreasureLookup[vignetteInfo.vignetteID]
		if treasure then
			if treasure.requires and not ns.conditions.check(treasure.requires) then
				-- Debug("skipping notification", "vignette requirements not met", ns.conditions.summarize(treasure.requires))
				return
			end
			if treasure.active and not ns.conditions.check(treasure.active) then
				-- Debug("skipping notification", "vignette not active", ns.conditions.summarize(treasure.active))
				return
			end
		end
		already_notified_loot[vignetteInfo.vignetteGUID] = time()
		core.events:Fire("SeenVignette", vignetteInfo.name, vignetteInfo.vignetteID, vignetteInfo.atlasName, current_zone, x or 0, y or 0, instanceid)
		core.events:Fire("SeenLoot", vignetteInfo.name, vignetteInfo.vignetteID, current_zone, x or 0, y or 0, instanceid)
		return true
	end
	if ns.vignetteTreasureLookup[vignetteInfo.vignetteID] and ns.vignetteTreasureLookup[vignetteInfo.vignetteID].hidden then
		return -- Debug("skipping notification", "ignored by vignette-id")
	end
	if vignetteInfo.objectGUID then
		-- this *may* be a mob, but it also may be something which you interact with to summon the mob
		local mobid = ns.IdFromGuid(vignetteInfo.objectGUID)
		if mobid and ns.mobdb[mobid] then
			--Debug("mob from guid", vignetteInfo.objectGUID, mobid)
			return self:NotifyIfNeeded(mobid, current_zone, x, y, source, instanceid)
		end
	end
	-- And now, comparatively uncommon fallbacks:
	if vignetteInfo.vignetteID and ns.vignetteMobLookup[vignetteInfo.vignetteID] then
		-- IDs are based on https://bnet.marlam.in/dbc.php?dbc=vignette.db2
		--Debug("vignetteMobLookup", vignetteInfo.name, vignetteInfo.vignetteID, ns.vignetteMobLookup[vignetteInfo.vignetteID])
		return self:NotifyForMobs(ns.vignetteMobLookup[vignetteInfo.vignetteID], current_zone, x, y, source, instanceid)
	end
	if vignetteInfo.name then
		local mobid = core:IdForMob(vignetteInfo.name)
		if mobid then
			--Debug("name", vignetteInfo.name, mobid)
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
	if not (x and y) then
		x, y = HBD:GetPlayerZonePosition()
	end
	if not (current_zone and x and y) then
		return
	end
	local mob = ns.mobdb[id]
	if mob then
		if mob.requires and not ns.conditions.check(mob.requires) then
			-- Debug("skipping notification", "mob requirements not met", ns.conditions.summarize(mob.requires))
			return
		end
		if mob.active and not ns.conditions.check(mob.active) then
			-- Debug("skipping notification", "mob not active", ns.conditions.summarize(mob.active))
			return
		end
	end
	already_notified[instanceid] = true
	local vignetteInfo = C_VignetteInfo.GetVignetteInfo(instanceid)
	local ret = core:NotifyForMob(id, current_zone, x, y, false, variant or "vignette", false, nil, false, instanceid)
	core.events:Fire("SeenVignette", vignetteInfo.name, vignetteInfo.vignetteID, vignetteInfo.atlasName, current_zone, x, y, instanceid, id)
	return ret
end
