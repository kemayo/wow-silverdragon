local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Config", "AceConsole-3.0")

local function toggle(name, desc, order, inline, disabled)
	return {
		type = "toggle",
		name = name,
		desc = desc,
		order = order,
		descStyle = (inline or (inline == nil)) and "inline" or nil,
		width = (inline or (inline == nil)) and "full" or nil,
		disabled = disabled,
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

local options = {
	type = "group",
	name = "SilverDragon",
	get = function(info) return core.db.profile[info[#info]] end,
	set = function(info, v) core.db.profile[info[#info]] = v end,
	args = {
		about = {
			type = "group",
			name = "About",
			args = {
				about = desc("SilverDragon keeps an eye out for rare mobs for you.\n\n"..
						"If you want to change how it does that, go to the \"Scanning\" section "..
						"of the config. You can enable or disable the different methods used, and "..
						"adjust how some of them behave.\n\n"..
						"If you want to adjust the way the targeting popup appears, go to the \"ClickTarget\" "..
						"section.\n\n"..
						"If you want to change how you're told about seeing a rare, check out the "..
						"\"Outputs\" section.\n\n"..
						"If you want to add a custom mob to scan for, look at \"Custom\" in the \"Mobs\" "..
						"section.\n\n"..
						"If you want SilverDragon to please, please stop telling you about a certain "..
						"mob, look at \"Ignore\" in the \"Mobs\" section."),
			},
			order = 0,
		},
		general = {
			type = "group",
			name = "General",
			order = 10,
			args = {
				about = desc("SilverDragon wants to tell you things. Check out the sub-sections here to adjust how it does that.", 0),
				loot = {
					type = "group",
					name = "Loot",
					inline = true,
					order = 5,
					args = {
						about = desc("Some options for how SilverDragon will treat loot drops from mobs", 0),
						charloot = toggle("Current character only", "Only show loot that should drop for your current character.", 10),
						lootappearances = toggle("Appearances not items", "Count an item as obtained if you know its appearance, even if it's from a different item", 20),
					}
				},
			},
			plugins = {},
		},
		scanning = {
			type = "group",
			name = "Scanning",
			order = 20,
			args = {
				about = desc("SilverDragon is all about scanning for rare mobs. The options you see in this tab apply generally to all the scanning methods used. For more specific controls, check out the sub-sections.", 0),
				scan = {
					type = "range",
					name = "Scan interval",
					desc = "How often to scan for nearby rares, in seconds (0 disables scanning)",
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
				taxi = toggle("Scan on taxis", "Keep scanning for rares while flying on a taxi or in a dragon race. Just hope that it'll still be there after you land and make your way back...", 55),
			},
			plugins = {},
		},
	},
	plugins = {
	},
}
module.options = options

function module:OnInitialize()
	options.plugins["profiles"] = {
		profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(core.db)
	}
	options.plugins.profiles.profiles.order = -1 -- last!

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SilverDragon", function()
		core.events:Fire("OptionsRequested", options)
		return options
	end)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SilverDragon", "SilverDragon")
end

function module:ShowConfig(...)
	LibStub("AceConfigDialog-3.0"):Open("SilverDragon", ...)
end
