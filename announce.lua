local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Announce", "LibSink-2.0")

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Announce", {
		profile = {
			sink = true,
			sound = true,
			flash = true,
			sink_opts = {},
		},
	})
	self:SetSinkStorage(self.db.profile.sink_opts)
	core.RegisterCallback(self, "Seen")
	local config = core:GetModule("Config", true)
	if config then
		local function toggle(name, desc)
			return {
				type = "toggle",
				name = name,
				desc = desc,
			}
		end
		config.options.plugins.announce = {
			announce = {
				type = "group",
				name = "Announce",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					sink = {
						type = "group", name = "Message", inline = true,
						args = {
							sink = toggle("Message", "Send a message to whatever scrolling text addon you're using."),
							output = self:GetSinkAce3OptionsDataTable()
						},
					},
					sound = toggle("Sound", "Play a sound."),
					flash = toggle("Flash", "Flash the edges of the screen.")
				},
			},
		}
	end
end

function module:Seen(callback, zone, name, x, y, dead, newloc, source)
	if self.db.profile.sink then
		self:Pour(("Rare seen: %s%s (%s)"):format(name, dead and "... but it's dead" or '', source or ''))
	end
	if self.db.profile.sound then
		--PlaySoundfile(What to play...?)
	end
	if self.db.profile.flash then
		UIFrameFlash(LowHealthFrame, 0.5, 0.5, 6, false, 0.5)
	end
end

