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
		name = "History",
		get = function(info) return self.db.profile[info[#info]] end,
		set = function(info, v)
			self.db.profile[info[#info]] = v
			module:VIGNETTES_UPDATED()
		end,
		args = {
			about = config.desc("Show a list of recently seen mobs, the easier to work out when future spawns will occur.", 0),
			-- enabled = config.toggle("Enabled", "Extend the range at which minimap vignettes will appear.", 10),
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
			loot = config.toggle("Include loot", "Whether to include treasure vignettes", 20),
		},
	}, }
end
