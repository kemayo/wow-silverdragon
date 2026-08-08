local myname, ns = ...

local HBD = LibStub("HereBeDragons-2.0")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Mobs", "AceConsole-3.0")
local Debug = core.Debug

local function toggle_mob_desc(id)
	if ns.mobdb[id] and ns.mobdb[id].requires then
		return core:RenderString(
			string.format("ID: %d, %s", id, core.conditions.summarize(ns.mobdb[id].requires))
		)
	end
	return "ID: " .. id
end

local function toggle_mob(id)
	return {
		arg = id,
		name = core:GetMobLabel(id),
		desc = toggle_mob_desc(id),
		type = "toggle",
		width = "double",
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
	-- Deliberately left in place when unwatched: the toggle goes unchecked, and
	-- keeping it around is the easy way to re-add a mob you removed by mistake.
	if not watched then return end
	local config = core:GetModule("Config", true)
	if config and config.options.plugins.mobs then
		local args = config.options.plugins.mobs.mobs.args.custom.args.zones.args
		if not args["map"..uiMapID] then
			self:BuildCustomList(config.options)
		else
			args["map"..uiMapID].args["mob"..id] = toggle_mob(id)
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
				browse = {
					type = "group",
					name = "Browse",
					order = 0,
					args = {
						about = core:GetModule("Config").desc("Every rare SilverDragon knows about, with where to find it and what it drops.", 0),
						open = {
							type = "execute",
							name = "Browse rares",
							func = function() core:GetModule("Browser"):Toggle() end,
							order = 1,
						},
					},
				},
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
