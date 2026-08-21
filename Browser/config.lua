local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Browser")
local Debug = core.Debug

local LibWindow = LibStub("LibWindow-1.1")

function module:RegisterConfig()
	local config = core:GetModule("Config", true)
	if not config then return end
	config.options.plugins.browser = { browser = {
		type = "group",
		name = "Browser",
		order = 16, -- straight after Mobs, which is where the rest of this lives
		get = function(info) return self.db.profile[info[#info]] end,
		set = function(info, v)
			self.db.profile[info[#info]] = v
			self:Refresh()
		end,
		args = {
			about = config.desc("A window listing every rare SilverDragon knows about, with where to find it and what it drops.", 0),
			open = {
				type = "execute",
				name = "Browse rares",
				func = function() self:Toggle() end,
				order = 5,
			},
			style = {
				type = "select",
				name = "Style",
				desc = "How the window looks",
				values = function(info)
					local values = {}
					for key in pairs(self.Looks) do
						values[key] = key:gsub("_", ": ")
					end
					-- replace ourself with the built values table
					info.option.values = values
					return values
				end,
				set = function(info, v)
					self:SetLook(v)
				end,
				order = 10,
			},
			model = {
				type = "toggle",
				name = "Show 3d model",
				desc = "Whether to show the fully 3d model of the selected rare",
				set = function(info, v)
					self.db.profile[info[#info]] = v
					if self.window then
						self.window.detailPane:SetMob(self.selectedMob)
					end
				end,
				order = 15,
			},
			showMap = {
				type = "toggle",
				name = "Show the map",
				desc = "Whether to show a map of the zone, with the rares marked on it",
				set = function(info, v)
					self.db.profile[info[#info]] = v
					if self.window then
						self.window:Layout()
					end
				end,
				order = 20,
			},
			mapShowAll = {
				type = "toggle",
				name = "Show other rares in the zone",
				desc = "With a rare selected, whether the others in the zone stay on the map, dimmed, or go away entirely",
				set = function(info, v)
					self.db.profile[info[#info]] = v
					self:RefreshMap()
				end,
				order = 25,
			},
			scale = {
				type = "range",
				name = UI_SCALE,
				width = "full",
				min = 0.5, max = 2, step = 0.05, isPercent = true,
				get = function() return self.db.profile.position.scale end,
				set = function(info, v)
					if not self.window then return end
					LibWindow.SetScale(self.window, v)
				end,
				order = 30,
			},
			style_options = {
				type = "group",
				name = "Style options",
				order = 40,
				-- no style has any yet, and an empty tab reads as a fault
				hidden = function()
					return not next(self.LookConfig)
				end,
				get = function(info)
					local value = self.db.profile.style_options[info[#info - 1]][info[#info]]
					if info.type == "color" then
						return unpack(value)
					end
					return value
				end,
				set = function(info, ...)
					local value = ...
					if info.type == "color" then
						value = {...}
					end
					self.db.profile.style_options[info[#info - 1]][info[#info]] = value
					if self.window and self.window.look == info[#info - 1] then
						self:ResetLook(self.window)
						self:ApplyLook(self.window, self.window.look)
					end
				end,
				args = self.LookConfig,
			},
		},
	} }
end
