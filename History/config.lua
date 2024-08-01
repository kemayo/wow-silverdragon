local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("History")
local Debug = core.Debug
local ns = core.NAMESPACE

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
			loot = config.toggle("Include loot", "Whether to include treasure vignettes", 25),
		},
	}, }
end
