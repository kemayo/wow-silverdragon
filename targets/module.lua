local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("ClickTarget", "AceEvent-3.0")
local Debug = core.Debug

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("ClickTarget", {
		profile = {
			show = true,
			locked = true,
			style = "SilverDragon",
			closeAfter = 30,
			sources = {
				target = false,
				grouptarget = true,
				mouseover = true,
				nameplate = true,
				vignette = true,
				['point-of-interest'] = true,
				groupsync = true,
				guildsync = false,
				fake = true,
			},
		},
	})
	core.RegisterCallback(self, "Announce")
	core.RegisterCallback(self, "Marked")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.clicktarget = {
			clicktarget = {
				type = "group",
				name = "ClickTarget",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v)
					self.db.profile[info[#info]] = v
					local oldpopup = self.popup
					self.popup = self:CreatePopup()
					if oldpopup:IsVisible() then
						self:ShowFrame(oldpopup.data)
					end
					oldpopup:Hide()
				end,
				order = 25,
				args = {
					about = config.desc("Once you've found a rare, it can be nice to actually target it. So this pops up a frame that targets the rare when you click on it. It can show a 3d model of that rare, but only if we already know the ID of the rare (though a data import), or if it was found by being targetted. Nameplates are right out.", 0),
					show = config.toggle("Show", "Show the click-target frame.", 10),
					locked = config.toggle("Locked", "Lock the click-target frame in place unless ALT is held down", 15),
					closeAfter = {
						type = "range",
						name = "Close after",
						desc = "How long to leave the target frame up without you interacting with it before it'll go away, in seconds",
						width = "full",
						min = 5,
						max = 600,
						step = 1,
					},
					sources = {
						type="multiselect",
						name = "Rare Sources",
						desc = "Which ways of finding a rare should cause this frame to appear?",
						get = function(info, key) return self.db.profile.sources[key] end,
						set = function(info, key, v) self.db.profile.sources[key] = v end,
						values = {
							target = "Targets",
							grouptarget = "Group targets",
							mouseover = "Mouseover",
							nameplate = "Nameplates",
							vignette = "Vignettes",
							['point-of-interest'] = "Map Points of Interest",
							groupsync = "Group Sync",
							guildsync = "Guild Sync",
						},
					},
					style = {
						type = "select",
						name = "Style",
						desc = "Appearance of the frame",
						values = {},
					},
				},
			},
		}
		for key in pairs(self.Looks) do
			config.options.plugins.clicktarget.clicktarget.args.style.values[key] = key
		end
	end

	self.popup = self:CreatePopup()
end

local pending
function module:Announce(callback, id, zone, x, y, dead, source, unit)
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" then
			source = "guildsync"
		else
			source = "groupsync"
		end
	end
	if not self.db.profile.sources[source] then
		return
	end
	local data = {
		id = id,
		unit = unit,
		source = source,
		dead = dead,
	}
	if InCombatLockdown() then
		pending = data
	else
		self:ShowFrame(data)
	end
	FlashClientIcon() -- If you're tabbed out, bounce the WoW icon if we're in a context that supports that
	data.unit = nil -- can't be trusted to remain the same
end

function module:Marked(callback, id, marker, unit)
	if self.popup.data and self.popup.data.id == id then
		self.popup:SetRaidIcon(marker)
	end
end

function module:PLAYER_REGEN_ENABLED()
	if pending then
		pending = nil
		self:ShowFrame(pending)
	end
end
