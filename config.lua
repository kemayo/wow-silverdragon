local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Config", "AceConsole-3.0")

local db

local function toggle(name, desc, order, inline)
	return {
		type = "toggle",
		name = name,
		desc = desc,
		order = order,
		descStyle = (inline or (inline == nil)) and "inline" or nil,
		width = (inline or (inline == nil)) and "full" or nil,
	}
end
module.toggle = toggle
local function desc(text, order)
	return {
		type = "description",
		name = text,
		order = order,
		fontSize = "medium",
	}
end
module.desc = desc

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

local options = {
	type = "group",
	name = "SilverDragon",
	get = function(info) return db[info[#info]] end,
	set = function(info, v) db[info[#info]] = v end,
	args = {
		about = {
			type = "group",
			name = "About",
			args = {
				about = desc("SilverDragon keeps an eye out for rare mobs for you.\n\n"..
						"If you want to change how it does that, go to the \"Scanning\" section "..
						"of the config. You can enable or disable the different methods used, and "..
						"adjust how some of them behave.\n\n"..
						"If you want to change how it tells you about seeing a rare, check out the "..
						"\"Outputs\" section.\n\n"..
						"If you want to add a custom mob to scan for, look at \"Always\" in the \"Mobs\" "..
						"section.\n\n"..
						"If you want SilverDragon to please, please stop telling you about a certain "..
						"mob, look at \"Ignore\" in the \"Mobs\" section.\n\n"..
						"If you think SilverDragon hasn't told you about a rare that it should have, "..
						"make sure that (a) you've imported the bundled rares in the \"Mobs\", and (b) "..
						"you've cleared your mob cache by quitting WoW and deleting Cache\\WDB\\enUS\\creaturecache.wdb "..
						"from your WoW install directory. Check the website you downloaded SilverDragon from "..
						"for more detailed instructions if you need help with that."),
			},
			order = 0,
		},
		scanning = {
			type = "group",
			name = "Scanning",
			order = 10,
			args = {
				about = desc("SilverDragon is all about scanning for rare mobs. The options you see in this tab apply generally to all the scanning methods used. For more specific controls, check out the sub-sections.", 0),
				scan = {
					type = "range",
					name = "Scan frequency",
					desc = "How often to scan for nearby rares (0 disables scanning)",
					min = 0, max = 10, step = 0.1,
					order = 10,
				},
				delay = {
					type = "range",
					name = "Recording delay",
					desc = "How long to wait before recording the same rare again",
					min = 30, max = (60 * 60), step = 10,
					order = 20,
				},
				instances = toggle("Scan in instances", "There aren't that many actual rares in instances, and scanning might slow things down at a time when you'd like the most performance possible.", 50),
				taxi = toggle("Scan on taxis", "Keep scanning for rares while flying on a taxi. Just hope that it'll still be there after you land and make your way back...", 55),
			},
			plugins = {},
		},
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
					order = 20,
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
			},
		},
		outputs = {
			type = "group",
			name = "Outputs",
			order = 20,
			args = {
				about = desc("SilverDragon wants to tell you things. Check out the sub-sections here to adjust how it does that.", 0),
			},
			plugins = {},
		},
		addons = {
			type = "group",
			name = "Addons",
			order = 30,
			args = {
				about = desc("SilverDragon can integrate with some other addons. If you don't see anything here, you don't have any of these addons installed. I'm very sad. ;_;", 0),
			},
			plugins = {},
		},
	},
	plugins = {
	},
}
module.options = options

function module:OnInitialize()
	db = core.db.profile

	options.args.mobs.args.always = mob_list_group("Always", 20, "Mobs you always want to scan for", core.db.global.always)
	options.args.mobs.args.ignore = mob_list_group("Ignore", 25, "Mobs you just want to ignore, already", core.db.global.ignore)

	options.plugins["profiles"] = {
		profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(core.db)
	}
	options.plugins.profiles.profiles.order = -1 -- last!

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SilverDragon", options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SilverDragon", "SilverDragon")
	self:RegisterChatCommand("silverdragon", function() LibStub("AceConfigDialog-3.0"):Open("SilverDragon") end)
end

function module:ShowConfig()
	LibStub("AceConfigDialog-3.0"):Open("SilverDragon")
end
