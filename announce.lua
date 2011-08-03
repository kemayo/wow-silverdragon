local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Announce", "LibSink-2.0")

local LSM = LibStub("LibSharedMedia-3.0")

-- Register some media
LSM:Register("sound", "Rubber Ducky", [[Sound\Doodad\Goblin_Lottery_Open01.wav]])
LSM:Register("sound", "Cartoon FX", [[Sound\Doodad\Goblin_Lottery_Open03.wav]])
LSM:Register("sound", "Explosion", [[Sound\Doodad\Hellfire_Raid_FX_Explosion05.wav]])
LSM:Register("sound", "Shing!", [[Sound\Doodad\PortcullisActive_Closed.wav]])
LSM:Register("sound", "Wham!", [[Sound\Doodad\PVP_Lordaeron_Door_Open.wav]])
LSM:Register("sound", "Simon Chime", [[Sound\Doodad\SimonGame_LargeBlueTree.wav]])
LSM:Register("sound", "War Drums", [[Sound\Event Sounds\Event_wardrum_ogre.wav]])--NPC Scan default
LSM:Register("sound", "Scourge Horn", [[Sound\Events\scourge_horn.wav]])--NPC Scan default
LSM:Register("sound", "Cheer", [[Sound\Event Sounds\OgreEventCheerUnique.wav]])
LSM:Register("sound", "Humm", [[Sound\Spells\SimonGame_Visual_GameStart.wav]])
LSM:Register("sound", "Short Circuit", [[Sound\Spells\SimonGame_Visual_BadPress.wav]])
LSM:Register("sound", "Fel Portal", [[Sound\Spells\Sunwell_Fel_PortalStand.wav]])
LSM:Register("sound", "Fel Nova", [[Sound\Spells\SeepingGaseous_Fel_Nova.wav]])
LSM:Register("sound", "NPCScan", [[Sound\Event Sounds\Event_wardrum_ogre.wav]])--Sound file is actually bogus, this just forces the option NPCScan into menu. We hack it later.

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Announce", {
		profile = {
			sink = true,
			sound = true,
			soundfile = "Wham!",
			flash = true,
			classic = true,
			sink_opts = {},
		},
	})

	self:SetSinkStorage(self.db.profile.sink_opts)
	core.RegisterCallback(self, "Seen")

	local config = core:GetModule("Config", true)
	if config then
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
							sink = config.toggle("Message", "Send a message to whatever scrolling text addon you're using."),
							output = self:GetSinkAce3OptionsDataTable()
						},
					},
					sound = config.toggle("Sound", "Play a sound."),
					soundfile = {
						type = "select", dialogControl = "LSM30_Sound",
						name = "Sound to Play", desc = "Choose a sound file to play.",
						values = AceGUIWidgetLSMlists.sound,
						disabled = function() return not self.db.profile.sound end,
					},
					flash = config.toggle("Flash", "Flash the edges of the screen."),
					classic = config.toggle("Announce lvls 2-60", "Toggle notifications for mobs that are between levels 2-60. Note: Camel Figures are level 1 so that's why this option excludes level 1s."),
				},
			},
		}
	end
end

function module:Seen(callback, zone, name, x, y, dead, newloc, source, _, _, level)
	level = tonumber(level or "")
	if (not self.db.profile.classic) and (level >= 2 and level < 61) then
		return
	end
	if self.db.profile.sink then
		self:Pour(("Rare seen: %s%s (%s)"):format(name, dead and "... but it's dead" or '', source or ''))
	end
	if self.db.profile.sound then
		if self.db.profile.soundfile == "NPCScan" then
			--Override default behavior and force npcscan behavior of two sounds at once
			PlaySoundFile(LSM:Fetch("sound", "War Drums"), "Master")
			PlaySoundFile(LSM:Fetch("sound", "Scourge Horn"), "Master")
		else--Play whatever sound is set
			PlaySoundFile(LSM:Fetch("sound", self.db.profile.soundfile), "Master")
		end
	end
	if self.db.profile.flash then
		LowHealthFrame_StartFlashing(0.5, 0.5, 6, false, 0.5)
	end
end

