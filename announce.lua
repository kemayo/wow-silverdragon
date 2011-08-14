local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Announce", "LibSink-2.0")
local Debug = core.Debug

local Tourist = LibStub("LibTourist-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local BZ = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()

if LSM then
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
end

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Announce", {
		profile = {
			sink = true,
			sound = true,
			soundfile = "Wham!",
			flash = true,
			instances = true,
			expansions = {
				classic = true,
				bc = true,
				wrath = true,
				cataclysm = true,
				unknown = true,
			},
			sink_opts = {},
		},
	})

	self:SetSinkStorage(self.db.profile.sink_opts)
	core.RegisterCallback(self, "Seen")

	local config = core:GetModule("Config", true)
	if config then
		local toggle = config.toggle
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
					flash = toggle("Flash", "Flash the edges of the screen."),
					instances = toggle("Instances", "Show announcements while in an instance"),
					expansions = {
						type = "group", name = "Expansions", inline = true,
						get = function(info) return self.db.profile.expansions[info[#info]] end,
						set = function(info, v) self.db.profile.expansions[info[#info]] = v end,
						args = {
							desc = {
								type = "description",
								name = "Whether to announce rares in zones from this expansion",
								order = 0,
							},
							classic = toggle("Classic", "Vanilla. Basic. 1-60. Whatevs.", 10),
							bc = toggle("Burning Crusade", "Illidan McGrumpypants. 61-70.", 20),
							wrath = toggle("Wrath of the Lich King", "Emo Arthas. 71-80.", 30),
							cataclysm = toggle("Cataclysm", "Play it off, keyboard cataclysm! 81-85.", 40),
							unknown = toggle(UNKNOWN, "Not sure where they fit.", 50),
						},
					},
				},
			},
		}
		if LSM then
			config.options.plugins.announce.announce.args.sound = toggle("Sound", "Play a sound.")
			config.options.plugins.announce.announce.args.soundfile = {
				type = "select", dialogControl = "LSM30_Sound",
				name = "Sound to Play", desc = "Choose a sound file to play.",
				values = AceGUIWidgetLSMlists.sound,
				disabled = function() return not self.db.profile.sound end,
			}
		end
	end
end

-- next tables are for zones which can't be caught by continent
-- TODO: check instance coverage
local bc_zones = {
	["AzuremystIsle"] = true,
	["BloodmystIsle"] = true,
	["Ghostlands"] = true,
	["SilvermoonCity"] = true,
	["Sunwell"] = true, -- Isle of Quel'Danas
	["TheExodar"] = true,
}
local cata_zones = {
	["Deepholm"] = true,
	["Hyjal"] = true,
	["Kezan"] = true,
	["MoltenFront"] = true,
	["RuinsofGilneas"] = true,
	["RuinsofGilneasCity"] = true,
	["TheLostIsles"] = true,
	["TheMaelstrom"] = true,
	["TolBarad"] = true,
	["TolBaradDailyArea"] = true,
	["TwilightHighlands"] = true,
	["Uldum"] = true,
	["Vashjir"] = true,
	["VashjirDepths"] = true, -- Abyssal Depths
	["VashjirKelpForest"] = true, -- Kelp'thar Forest
	["VashjirRuins"] = true, -- Shimmering Expanse
}
local function guess_expansion(zone)
	if not zone then
		return 'unknown'
	end
	local localized_zone = core.mapfile_to_zone[zone]
	if not localized_zone then
		return 'unknown'
	end
	if bc_zones[zone] then
		return 'bc'
	end
	if cata_zones[zone] then
		return 'cataclysm'
	end
	if Tourist:IsInNorthrend(localized_zone) then
		return 'wrath'
	end
	if Tourist:IsInOutland(localized_zone) then
		return 'bc'
	end
	if Tourist:IsInTheMaelstrom(localized_zone) then
		return 'cataclysm'
	end
	if Tourist:IsInKalimdor(localized_zone) then
		return 'classic'
	end
	if Tourist:IsInEasternKingdoms(localized_zone) then
		return 'classic'
	end
	return 'unknown'
end
core.guess_expansion = guess_expansion

function module:Seen(callback, zone, name, x, y, dead, newloc, source)
	Debug("Announce:Seen", zone, name, x, y, dead, newloc, source)

	if not self.db.profile.instances and IsInInstance() then
		return
	end

	local exp = guess_expansion(zone)
	if exp and not self.db.profile.expansions[exp] then
		Debug("Skipping due to expansion", exp)
		return
	end
	local localized_zone = zone and core.mapfile_to_zone[zone]
	if zone and not localized_zone then
		-- This is probably an instance, so try to localize it
		localized_zone = BZ[zone]
	end
	if not localized_zone then
		localized_zone = UNKNOWN
	end

	if self.db.profile.sink then
		Debug("Pouring message")
		if source:match("^sync") then
			local channel, player = source:match("sync:(.+):(.+)")
			if channel and player then
				source = "by " .. player .. " in your " .. strlower(channel) .. "; " .. localized_zone
				if x and y then
					source = source .. " @ " .. core.round(x* 100, 1) .. "," .. core.round(y * 100, 1)
				end
			end
		end
		self:Pour(("Rare seen: %s%s (%s)"):format(name, dead and "... but it's dead" or '', source or ''))
	end
	if self.db.profile.sound and LSM then
		Debug("Playing sound", self.db.profile.soundfile)
		if self.db.profile.soundfile == "NPCScan" then
			--Override default behavior and force npcscan behavior of two sounds at once
			PlaySoundFile(LSM:Fetch("sound", "War Drums"), "Master")
			PlaySoundFile(LSM:Fetch("sound", "Scourge Horn"), "Master")
		else--Play whatever sound is set
			PlaySoundFile(LSM:Fetch("sound", self.db.profile.soundfile), "Master")
		end
	end
	if self.db.profile.flash then
		Debug("Flashing")
		LowHealthFrame_StartFlashing(0.5, 0.5, 6, false, 0.5)
	end
end

