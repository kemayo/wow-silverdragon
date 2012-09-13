local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Mobs")
local Debug = core.Debug

local desc, toggle

local function removable_mob(id)
	local name = core.db.global.mob_name[id]
	return {
		type = "execute",
		name = (name or UNKNOWN) .. ' (id:'..tostring(id)..')',
		desc = not name and "Don't know the name" or nil,
		arg = id,
	}
end

local function mob_list_group(name, order, description, db_table)
	local group = {
		type = "group",
		name = name,
		order = order,
		args = {},
	}
	group.args.about = desc(description, 0)
	group.args.add = {
		type = "input",
		name = "Add",
		desc = "Add a mob by entering its id. (Check wowhead.)",
		get = function(info) return '' end,
		set = function(info, v)
			local id = tonumber(v)
			db_table[id] = true
			group.args.remove.args[tostring(id)] = removable_mob(id)
		end,
		validate = function(info, v)
			if v:match("^%d+$") then
				return true
			end
		end,
		order = 10,
	}
	group.args.remove = {
		type = "group",
		inline = true,
		name = "Remove",
		order = 20,
		func = function(info)
			db_table[info.arg] = false
			group.args.remove.args[info[#info]] = nil
		end,
		args = {
			about = desc("Remove a mob.", 0),
		},
	}
	for id, ignored in pairs(db_table) do
		if ignored then
			group.args.remove.args[tostring(id)] = removable_mob(id)
		end
	end
	return group
end

function module:OnInitialize()
	-- core.RegisterCallback(self, "Seen")

	local config = core:GetModule("Config", true)
	if config then
		desc = config.desc
		toggle = config.toggle

		config.options.plugins.mobs = {
			mobs = {
				type = "group",
				name = "Mobs",
				order = 15,
				args = {
					import = {
						type = "group",
						name = "Import Mobs",
						order = 10,
						inline = true,
						hidden = function()
							return not ( core:GetModule("Data", true) or select(5, GetAddOnInfo("SilverDragon_Data")) )
						end,
						args = {
							about = desc("SilverDragon comes with a pre-built database of known locations of rare mobs. Click the button below to import them all.", 0),
							load = {
								order = 10,
								type = "execute",
								name = "Import Mobs",
								func = function()
									LoadAddOn("SilverDragon_Data")
									local Data = core:GetModule("Data", true)
									if not Data then
										module:Print("Database not found. Aborting import.") -- safety check, just in case.
										return
									end
									local count = Data:Import()
									core.events:Fire("Import")
									module:Print(("Imported %d rares."):format(count))
								end,
							},
						},
					},
					clear = {
						type = "group",
						name = "Clear Data",
						order = 15,
						inline = true,
						args = {
							about = desc("This will forget all the rare mobs that SilverDragon knows about. You might want to do this if you want to import fresh data from a more recent version of SilverDragon.", 0),
							all = {
								type = "execute",
								name = "Clear all rares",
								desc = "Forget all seen rares.",
								order = 10,
								func = function() core:DeleteAllMobs() end,
							},
						},
					},
					always = mob_list_group("Always", 20, "Mobs you always want to scan for", core.db.global.always),
					ignore = mob_list_group("Ignore", 25, "Mobs you just want to ignore, already", core.db.global.ignore),
					list = module:FullList(),
				},
			},
		}
	end
end

function module:FullList()
	Debug("FullList called")
	local list
	list = {
		type = "group",
		name = "List",
		childGroups = "select",
		args = {
			about = desc("A full list of mobs we know about, by zone. Click them to delete them.", 0),
		},
		func = function(info)
			local id = info.arg
			Debug("info", info, info[#info - 1], info[#info])
			list.args[info[#info - 1]].args[info[#info]] = nil
			core:DeleteMob(id)
		end,
		order = 20,
	}
	for zoneid, mobs in pairs(core.db.global.mobs_byzoneid) do
		local arg = {
			type = "group",
			order = zoneid, -- heh
			name = GetMapNameByID(zoneid) or UNKNOWN,
			args = {}
		}
		for id in pairs(mobs) do
			arg.args[tostring(id)] = removable_mob(id)
		end
		list.args[tostring(zoneid)] = arg
	end
	return list
end
