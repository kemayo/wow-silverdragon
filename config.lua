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
		scanning = {
			type = "group",
			name = "Scanning",
			order = 10,
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
				taxi = toggle("Scan on taxis", "Keep scanning for rares while flying on a taxi. Just hope that it'll still be there after you land and make your way back...", 55),
			},
			plugins = {},
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
	options.plugins.profiles.profiles.order = -1 -- last!

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SilverDragon", options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SilverDragon", "SilverDragon")
	self:RegisterChatCommand("silverdragon", "OnChatCommand")
end

function module:OnChatCommand(input)
	local command, args = self:GetArgs(input, 2)
	if command then
		command = command:lower()
		if command == 'debug' then
			core:ShowDebugWindow()
		end
	else
		self:ShowConfig()
	end
end

function module:ShowConfig()
	LibStub("AceConfigDialog-3.0"):Open("SilverDragon")
end
