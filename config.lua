local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Config", "AceConsole-3.0")

local db

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
				cache_tameable = {
					type = "toggle",
					name = "Cache alert: Tameable",
					desc = "The cache-scanning method has no way to tell whether a mob is a hunter's pet. So to avoid getting spam, you can disable notifications for mobs found through this method that it is possible to tame.",
					order = 30,
				},
			},
		},
		import = {
			type = "group",
			name = "Import Data",
			order = 10,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = "",
				},
				load = {
					order = 10,
					type = "execute",
					name = "Import Data",
					func = function()
						local loaded, reason = LoadAddOn("SilverDragon_Data")
						local Data = core:GetModule("Data")
						if not Data then
							module:Print("Couldn't find SilverDragon_Data.")
						end
						local count = Data:Import()
						module:Print(("Imported %d rares."):format(count))
						core.events:Fire("Import")
					end,
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

