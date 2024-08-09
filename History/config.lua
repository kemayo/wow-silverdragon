local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("History")
local Debug = core.Debug
local ns = core.NAMESPACE

local LibWindow = LibStub("LibWindow-1.1")

function module:RegisterConfig()
	local config = core:GetModule("Config", true)
	if not config then return end
	config.options.plugins.history = { history = {
		type = "group",
		name = HISTORY,
		get = function(info) return self.db.profile[info[#info]] end,
		set = function(info, v)
			self.db.profile[info[#info]] = v
			self:Refresh()
		end,
		args = {
			about = config.desc("Show a list of recently seen mobs, the easier to work out when future spawns will occur.", 0),
			enabled = {
				type = "toggle",
				name = "Enabled",
				set = function(info, v)
					self.db.profile[info[#info]] = v
					if v then
						self:Enable()
					else
						self:Disable()
					end
				end,
				order = 10,
			},
			combat = config.toggle("Show in combat", "Whether to hide away when combat starts", 15),
			empty = config.toggle("Show when empty", "Whether to show the window before you've seen anything", 20),
			grow = config.toggle("Grow to max height", "Whether to fit the window to its contents until you reach the maximum height", 25),
			relative = config.toggle("Use relative time", "Whether to show time in the window as relative or absolute", 30),
			loot = config.toggle("Include loot", "Whether to include treasure vignettes", 35),
			othershard = {
				type = "select", name = "Mobs from other shards",
				desc = "How to treat mobs which are not from your current shard, and so which are probably inaccessible to you right now",
				values = {
					show = "Show",
					dim = "Dim",
					hide = "Hide",
				},
				order = 40,
			},
			scale = {
				type = "range",
				name = UI_SCALE,
				width = "full",
				min = 0.5,
				max = 2,
				step = 0.05,
				get = function(info) return self.db.profile.position.scale end,
				set = function(info, value)
					self.db.profile.position.scale = value
					LibWindow.SetScale(self.window, value)
				end,
				order = 50,
			},
		},
	}, }
end
