local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("VignetteStretch")
local Debug = core.Debug
local ns = core.NAMESPACE

function module:RegisterConfig()
	local config = core:GetModule("Config", true)
	if not config then return end
	config.options.plugins.rangeextender = { rangeextender = {
		type = "group",
		name = "Range Extender",
		get = function(info) return self.db.profile[info[#info]] end,
		set = function(info, v)
			self.db.profile[info[#info]] = v
			module:VIGNETTES_UPDATED()
		end,
		args = {
			about = config.desc("Minimap vignettes tell us where various things are. Blizzard lets us know about them before they'll be shown on the minimap sometimes, whether because of zoom levels or something concealing the vignette from your view. As such we can fake those hidden vignettes, to give you early warning of things you might want to pursue.", 0),
			enabled = config.toggle("Enabled", "Extend the range at which minimap vignettes will appear.", 10),
			mystery = config.toggle("Mystery vignettes", "Show mysterious vignettes that don't return any information from the API", 15),
			types_desc = config.desc("You can adjust the types of vignettes to extend. This is inherently fuzzy because we don't get much information about them, so it's just going off their internal icon names. There's nothing stopping Blizzard from categorizing things weirdly, or making new icons.", 20),
			types = {
				type = "multiselect",
				name = "Types",
				get = function(info, key) return self.db.profile[info[#info]][key] end,
				set = function(info, key, value)
					self.db.profile[info[#info]][key] = value
					module:VIGNETTES_UPDATED()
				end,
				values = {
					vignettekill = CreateAtlasMarkup("vignettekill", 20, 20) .. " Kill",
					vignettekillelite = CreateAtlasMarkup("vignettekillelite", 24, 24) .. " Kill elite",
					vignetteloot = CreateAtlasMarkup("vignetteloot", 20, 20) .. " Loot",
					vignettelootelite = CreateAtlasMarkup("vignettelootelite", 24, 24) .. " Loot elite",
					vignetteevent = CreateAtlasMarkup("vignetteevent", 20, 20) .. " Event",
					vignetteeventelite = CreateAtlasMarkup("vignetteeventelite", 24, 24) .. " Event elite",
				},
				order=21,
			},
		},
	}, }
	if self.compat_disabled then
		config.options.plugins.rangeextender.rangeextender.args.enabled.disabled = true
		config.options.plugins.rangeextender.rangeextender.args.disabled = config.desc("Disabled because MinimapRangeExtender is installed and loaded, which does the same thing", 15)
	end
end
