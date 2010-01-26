local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Config", "AceConsole-3.0")

local db

local function toggle(name, desc, order)
	return {type = "toggle", name = name, desc = desc, order=order,}
end

local options = {
	type = "group",
	name = "SilverDragon",
	get = function(info) return db[info[#info]] end,
	set = function(info, v) db[info[#info]] = v end,
	args = {
		general = {
			type = "group",
			name = "General",
			order = 10,
			args = {
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
				methods = {
					type = "group",
					name = "Scan methods",
					desc = "Which approaches to use for scanning.",
					order = 30,
					inline = true,
					args = {
						about = {
							type = "description",
							name = "Choose the approaches to be used when searching for rare mobs. Note that if you disable all of them, this addon becomes pretty useless...",
							order = 0,
						},
						mouseover = toggle("Mouseover", "Check mobs that you mouse over.", 10),
						targets = toggle("Targets", "Check the targets of people in your group.", 20),
						nameplates = toggle("Nameplates", "Check nameplates of mobs that you are close to", 30),
						cache = toggle("Cache", "Scan the mob cache for never-before-found mobs.", 40),
					},
				},
				cache_tameable = {
					type = "toggle",
					name = "Cache alert: Tameable",
					desc = "The cache-scanning method has no way to tell whether a mob is a hunter's pet. So to avoid getting spam, you can disable notifications for mobs found through this method that it is possible to tame.",
					order = 40,
				},
				instances = {
					type = "toggle",
					name = "Scan in instances",
					desc = "There aren't that many actual rares in instances, and scanning might slow things down at a time when you'd like the most performance possible.",
					order = 50,
				},
				taxi = {
					type = "toggle",
					name = "Scan on taxis",
					desc = "Keep scanning for rares while flying on a taxi. Just hope that it'll still be there after you land and make your way back...",
					order = 55,
				},
			},
		},
		data = {
			type = "group",
			name = "Data Management",
			order = 15,
			args = {
				import = {
					type = "group",
					name = "Import Data",
					order = 10,
					inline = true,
					hidden = function()
						return not ( core:GetModule("Data", true) or select(5, GetAddOnInfo("SilverDragon_Data")) )
					end,
					args = {
						desc = {
							order = 0,
							type = "description",
							name = "SilverDragon comes with a pre-built database of known locations of rare mobs. Click the button below to import the data.",
						},
						load = {
							order = 10,
							type = "execute",
							name = "Import Data",
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
						desc = {
							order = 0,
							type = "description",
							name = "This will forget all the rare mobs that SilverDragon knows about. You might want to do this if you want to import fresh data from a more recent version of SilverDragon.",
						},
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
	},
	plugins = {
	},
}
module.options = options

function module:OnInitialize()
	db = core.db.profile

	options.plugins["profiles"] = {
		profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(core.db)
	}

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SilverDragon", options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SilverDragon", "SilverDragon")
	self:RegisterChatCommand("silverdragon", function() LibStub("AceConfigDialog-3.0"):Open("SilverDragon") end)
end

function module:ShowConfig()
	LibStub("AceConfigDialog-3.0"):Open("SilverDragon")
end
