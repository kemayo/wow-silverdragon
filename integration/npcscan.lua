if not (_NPCScan and _NPCScan.Overlay) then return end

-- https://sites.google.com/site/wowsaiket/Add-Ons/NPCScanOverlay/API

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("_NPCScan", "AceEvent-3.0")
local Debug = core.Debug

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("_NPCScan", {
		profile = {
			enabled = true,
			sync = false,
		},
	})
	local config = core:GetModule("Config", true)
	if config then
		local toggle = config.toggle
		config.options.plugins.npcscan = {
			npcscan = {
				type = "group",
				name = "_NPCScan.Overlay",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					desc = {
						type = "description",
						name = "Tell _NPCScan.Overlay about rares when we see them. This will only produce an effect on certain rares which it knows about.",
						order = 0,
					},
					enabled = toggle("Enabled", "Whether to do anything at all", 10),
					-- sync = toggle("Sync", "Show when the source is syncs", 20),
				},
			},
		}
	end

	core.RegisterCallback(self, "Seen")

	-- self:SendMessage("NpcOverlay_RegisterScanner", "SilverDragon")
end

function module:Seen(callback, id, name, zone, x, y, dead, newloc, source, unit)
	if not id then return end
	if not self.db.profile.enabled then return end
	if source and source:match("^sync") then return end -- this is disabled until I get around to switching to mapids
	self:SendMessage("NpcOverlay_Found", id)
end
