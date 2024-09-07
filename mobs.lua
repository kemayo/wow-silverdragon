local myname, ns = ...

local HBD = LibStub("HereBeDragons-2.0")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Mobs", "AceConsole-3.0")
local Debug = core.Debug

local function toggle_mob(id)
	return {
		arg = id,
		name = core:GetMobLabel(id),
		desc = "ID: " .. id,
		type = "toggle",
		-- width = "double",
		descStyle = "inline",
		order = id,
	}
end

local mob_names = {}
local function input_to_mobid(value)
	if not value then return end
	value = value:trim()
	if value == "target" or value == "mouseover" then
		return core:UnitID(value)
	end
	if value:match("^%d+$") then
		return tonumber(value)
	end
	return mob_names[value] or core:IdForMob(value)
end
ns.input_to_mobid = input_to_mobid

local function mob_input(name, desc, order, setter)
	return {
		type = "input",
		name = name,
		desc = desc,
		get = function() return "" end,
		set = function(info, value)
			setter(info, input_to_mobid(value))
		end,
		validate = function(info, value)
			if input_to_mobid(value) then
				return true
			end
		end,
		order = order,
	}
end

function module:OnEnable()
	local config = core:GetModule("Config", true)
	if not config then return end

	core.RegisterCallback(self, "OptionsRequested")
	core.RegisterCallback(self, "IgnoreChanged")
	core.RegisterCallback(self, "CustomChanged")
	core.RegisterCallback(self, "Seen")
end

function module:Seen(callback, id, zone, x, y, dead, source)
	local name = core:NameForMob(id)
	if name then
		mob_names[name] = id
	end
	local config = core:GetModule("Config", true)
	if config and config.options.plugins.mobs then
		local args = config.options.plugins.mobs.mobs.args.ignore.args.mobs.args
		args["mob"..id] = args["mob"..id] or toggle_mob(id)
	end
end

function module:IgnoreChanged(callback, id, ignored)
	if not ignored then return end
	local config = core:GetModule("Config", true)
	if config and config.options.plugins.mobs then
		config.options.plugins.mobs.mobs.args.ignore.args.mobs.args["mob"..id] = toggle_mob(id)
	end
end
function module:CustomChanged(callback, id, watched, uiMapID)
	if not watched then return end
	local config = core:GetModule("Config", true)
	if config and config.options.plugins.mobs then
		if not config.options.plugins.mobs.mobs.args.custom.args["map"..uiMapID] then
			self:BuildCustomList(config.options)
		else
			config.options.plugins.mobs.mobs.args.custom.args["map"..uiMapID].args["mob"..id] = toggle_mob(id)
		end
	end
end

function module:OptionsRequested(callback, options)
	options.plugins.mobs = {
		mobs = {
			type = "group",
			name = "Mobs",
			childGroups = "tab",
			order = 15,
			args = {
				custom = {
					type = "group",
					name = CUSTOM,
					order = 1,
					args = {
						add = {
							type = "input",
							name = ADD,
							desc = "Add a new zone to watch by entering its id or 'current'",
							get = function() return "" end,
							set = function(info, value)
								if value == "current" then
									value = HBD:GetPlayerZone()
								end
								value = tonumber(value)
								if value and not core.db.global.custom[value] then
									core.db.global.custom[value] = {}
								end
								self:BuildCustomList(options)
							end,
							validate = function(info, value)
								if value == "current" then return true end
								return tonumber(value)
							end,
							order = 1,
						},
						zones = {
							type = "group",
							name = ZONE,
							inline = false,
							childGroups = "tree",
							args = {},
							order = 10,
						},
					},
				},
				ignore = {
					type = "group",
					name = IGNORE,
					desc = "Mobs you just want to ignore, already",
					args = {
						add = mob_input(ADD, "Add a mob by entering its id, name, 'target', or 'mouseover'.", 1, function(info, id)
							core:SetIgnore(id, true)
						end),
						mobs = {
							type = "group",
							name = REMOVE,
							inline = true,
							get = function(info) return core.db.global.ignore[info.arg] end,
							set = function(info, value)
								core:SetIgnore(info.arg, not core.db.global.ignore[info.arg])
							end,
							args = {
								desc = core:GetModule("Config").desc("This will fill in as rare mobs are seen in the current session.", 0),
							},
						}
					},
					order = 2,
				},
			},
		},
	}
	self:BuildIgnoreList(options)
	self:BuildCustomList(options)
	self:BuildMobList(options)

	core.UnregisterCallback(self, "OptionsRequested")
end

function module:BuildIgnoreList(options)
	-- wipe(options.plugins.mobs.mobs.args.ignore.args.mobs.args)
	local args = options.plugins.mobs.mobs.args.ignore.args.mobs.args
	for id, ignored in pairs(core.db.global.ignore) do
		if ignored then
			args["mob"..id] = args["mob"..id] or toggle_mob(id)
		end
	end
	for name, id in pairs(mob_names) do
		args["mob"..id] = args["mob"..id] or toggle_mob(id)
	end
end

function module:BuildCustomList(options)
	-- wipe(options.plugins.mobs.mobs.args.custom.args.mobs.args)
	local args = options.plugins.mobs.mobs.args.custom.args.zones.args
	for uiMapID, mobs in pairs(core.db.global.custom) do
		args["map"..uiMapID] = {
			type = "group",
			get = function(info)
				return core.db.global.custom[uiMapID][info.arg]
			end,
			set = function(info, value)
				core:SetCustom(uiMapID, info.arg, value)
			end,
			inline = false,
			name = uiMapID == "any" and ALL or core.zone_names[uiMapID] or ("map"..uiMapID),
			desc = "ID: " .. uiMapID,
			args = {
				add = mob_input(ADD, "Add a mob by entering its id, name, 'target', or 'mouseover'", 1, function(info, id)
					core:SetCustom(uiMapID, id, true)
				end),
			},
			order = uiMapID == "any" and 0 or uiMapID,
		}
		for mobid, enabled in pairs(mobs) do
			if enabled then
				args["map"..uiMapID].args["mob"..mobid] = toggle_mob(mobid)
			end
		end
	end
end

function module:BuildMobList(options)
	ns:LoadAllAchievementMobs()
	for source, data in pairs(core.datasources) do
		local group = {
			type = "group",
			name = source,
			get = function(info)
				return not core.db.global.ignore[info.arg]
			end,
			set = function(info, value)
				core:SetIgnore(info.arg, not value)
			end,
			args = {
				enabled = {
					type = "toggle",
					name = ENABLE,
					desc = "If you disable this, SilverDragon will just not know about these mobs. They'll still be announced when you mouse over them, like any unknown rare.",
					arg = source,
					get = function(info) return core.db.global.datasources[info.arg] end,
					set = function(info, value)
						core.db.global.datasources[info.arg] = value
						core:BuildLookupTables()
					end,
					disabled = false,
				},
				ignore = {
					type = "toggle",
					name = IGNORE,
					desc = "Ignore every mob provided by this module. This will make them all not be announced, regardless of any other settings.",
					arg = source,
					get = function(info) return core.db.global.ignore_datasource[info.arg] end,
					set = function(info, value)
						core.db.global.ignore_datasource[info.arg] = value
						core:BuildLookupTables()
					end,
					disabled = function(info)
						return not core.db.global.datasources[info.arg]
					end,
				},
				zones = {
					type = "group",
					name = ZONE,
					inline = false,
					childGroups = "tree",
					args = {},
				},
			},
		}
		local mob_toggle_disabled = function(info)
			return not core.db.global.datasources[info[#info - 3]]
		end
		for id, mob in pairs(data) do
			if ns.mobs_to_achievement[id] then
				local achievement = ns.mobs_to_achievement[id]
				if not group.args.achievements then
					group.args.achievements = {
						type = "group",
						name = ACHIEVEMENTS,
						inline = false,
						childGroups = "tree",
						args = {},
					}
				end
				if not group.args.achievements.args["achievement"..achievement] then
					group.args.achievements.args["achievement"..achievement] = {
						type = "group",
						inline = false,
						name = 	select(2, GetAchievementInfo(achievement)) or "achievement:"..achievement,
						desc = "ID: " .. achievement,
						args = {
							all = {
								type = "execute",
								name = ALL,
								desc = "Select every mob in the list",
								func = function(info)
									if not ns.achievements[achievement] then return end
									for mobid, criteria in pairs(ns.achievements[achievement]) do
										core:SetIgnore(mobid, false, true)
									end
									self:BuildIgnoreList(info.options)
								end,
								width = "half",
								order = 1,
							},
							none = {
								type = "execute",
								name = NONE,
								desc = "Deselect every mob in the list",
								func = function(info)
									if not ns.achievements[achievement] then return end
									for mobid, criteria in pairs(ns.achievements[achievement]) do
										core:SetIgnore(mobid, true, true)
									end
									self:BuildIgnoreList(info.options)
								end,
								width = "half",
								order = 2,
							},
						},
					}
				end
				local toggle = toggle_mob(id)
				toggle.disabled = mob_toggle_disabled
				group.args.achievements.args["achievement"..achievement].args["mob"..id] = toggle
			end
			if not mob.hidden and mob.locations then
				for zone in pairs(mob.locations) do
					if not group.args.zones.args["map"..zone] then
						group.args.zones.args["map"..zone] = {
							type = "group",
							inline = false,
							name = core.zone_names[zone] or ("map"..zone),
							desc = "ID: " .. zone,
							args = {
								all = {
									type = "execute",
									name = ALL,
									desc = "Select every mob in the list",
									func = function(info)
										if not ns.mobsByZone[zone] then return end
										for mobid, locations in pairs(ns.mobsByZone[zone]) do
											core:SetIgnore(mobid, false, true)
										end
										self:BuildIgnoreList(info.options)
									end,
									width = "half",
									order = 1,
								},
								none = {
									type = "execute",
									name = NONE,
									desc = "Deselect every mob in the list",
									func = function(info)
										if not ns.mobsByZone[zone] then return end
										for mobid, locations in pairs(ns.mobsByZone[zone]) do
											core:SetIgnore(mobid, true, true)
										end
										self:BuildIgnoreList(info.options)
									end,
									width = "half",
									order = 2,
								},
							},
						}
					end
					local toggle = toggle_mob(id)
					toggle.disabled = mob_toggle_disabled
					group.args.zones.args["map"..zone].args["mob"..id] = toggle
				end
			end
		end
		options.plugins.mobs.mobs.args[source] = group
	end
end
