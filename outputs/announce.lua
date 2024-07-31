local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Announce", "AceTimer-3.0", "LibSink-2.0")
local Debug = core.Debug

local LSM = LibStub("LibSharedMedia-3.0")

-- testing snippet:
-- /script C_Timer.After(2, function() SilverDragon:GetModule("Announce"):Seen("_", 32491, 120, 0.490, 0.362, false, "fake") end)

-- Register some media
LSM:Register("sound", "Rubber Ducky", 566121)
LSM:Register("sound", "Cartoon FX", 566543)
LSM:Register("sound", "Explosion", 566982)
LSM:Register("sound", "Shing!", 566240)
LSM:Register("sound", "Wham!", 566946)
LSM:Register("sound", "Simon Chime", 566076)
LSM:Register("sound", "War Drums", 567275)--NPC Scan default
LSM:Register("sound", "Scourge Horn", 567386)--NPC Scan default
LSM:Register("sound", "Dwarf Horn", 566064)
LSM:Register("sound", "Pygmy Drums", 566508)
LSM:Register("sound", "Cheer", 567283)
LSM:Register("sound", "Humm", 569518)
LSM:Register("sound", "Short Circuit", 568975)
LSM:Register("sound", "Fel Portal", 569215)
LSM:Register("sound", "Fel Nova", 568582)
LSM:Register("sound", "PVP Flag", 569200)
LSM:Register("sound", "PvP Flag Horde", 568165) -- PVPFlagTakenHorde
LSM:Register("sound", "Thunder crack", 566202) -- doodad/fx_thundercrack04.ogg
LSM:Register("sound", "Algalon: Beware!", 543587)
LSM:Register("sound", "Yogg Saron: Laugh", 564859)
LSM:Register("sound", "Illidan: Not Prepared", 552503)
LSM:Register("sound", "Magtheridon: I am Unleashed", 554554)
LSM:Register("sound", "Loatheb: I see you", 554236)
LSM:Register("sound", "Ikiss: Trinkets", 561403)
LSM:Register("sound", "NPCScan", 567275)--Sound file is actually bogus, this just forces the option NPCScan into menu. We hack it later.
LSM:Register("sound", "PvP Alliance", 568320) -- PVPWarningAllianceLong
LSM:Register("sound", "PvP Horde", 569112) -- PVPWarningHordeLong
LSM:Register("sound", "Grimrail Train Horn", 1023633)
LSM:Register("sound", "Squire Horn", 598079)
LSM:Register("sound", "Gruntling Horn", 598196)

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Announce", {
		profile = {
			sink = true,
			drums = true,
			sound = true,
			soundgroup = true,
			soundguild = false,
			sound_mount = true,
			sound_boss = true,
			sound_loot = true,
			soundfile = "Loatheb: I see you",
			soundfile_mount = "Illidan: Not Prepared",
			soundfile_boss = "Magtheridon: I am Unleashed",
			soundfile_loot = "Ikiss: Trinkets",
			sound_loop = 1,
			sound_mount_loop = 1,
			sound_boss_loop = 1,
			sound_loot_loop = 1,
			flash = true,
			flash_texture = "Blizzard Low Health",
			flash_color = {r=1,g=0,b=1,a=1,},
			flash_mount = true,
			flash_texture_mount = "Blizzard Low Health",
			flash_color_mount = {r=0,g=1,b=0,a=1,},
			flash_boss = false,
			flash_texture_boss = "Blizzard Low Health",
			flash_color_boss = {r=1,g=0,b=1,a=1,},
			vibrate = true,
			vibrate_type = "High",
			vibrate_intensity = 1,
			vibrate_mount = true,
			vibrate_type_mount = "Low",
			vibrate_intensity_mount = 1,
			vibrate_boss = true,
			vibrate_type_boss = "High",
			vibrate_intensity_boss = 1,
			vibrate_loot = true,
			vibrate_type_loot = "High",
			vibrate_intensity_loot = 0.8,
			instances = false,
			dead = true,
			already = false,
			already_drop = true,
			already_transmog = false,
			already_alt = true,
			sink_opts = {},
			channel = "Master",
			unmute = false,
			background = false,
			loot = true,
			known_mounts = true,
		},
	})

	self:SetSinkStorage(self.db.profile.sink_opts)

	if self.db.profile.sink_opts.sink20OutputSink == "Channel" then
		-- 8.2.5 / Classic removed the ability to output to channels, outside of hardware-driven events
		self.db.profile.sink_opts.sink20OutputSink = "Default"
	end

	core.RegisterCallback(self, "Seen")
	core.RegisterCallback(self, "SeenLoot")

	local config = core:GetModule("Config", true)
	if config then
		local toggle = config.toggle
		local get = function(info) return self.db.profile[info[#info]] end
		local set = function(info, v) self.db.profile[info[#info]] = v end

		local sink_config = self:GetSinkAce3OptionsDataTable()
		local sink_args = {}
		for k,v in pairs(sink_config.args) do
			if k ~= "Channel" then
				sink_args[k] = v
			end
		end
		sink_config.args = sink_args
		sink_config.inline = true
		sink_config.order = 15
		sink_config.args.Channel = nil

		local faker = function(id, name, zone, x, y)
			return {
				type = "execute", name = name,
				desc = "Fake seeing " .. name,
				func = function()
					-- id, zone, x, y, is_dead, source, unit
					core.events:Fire("Seen", id, zone, x, y, false, "fake", false)
				end,
			}
		end
		local soundfile = function(enabled_key, order)
			return {
				type = "select", dialogControl = "LSM30_Sound",
				name = "Sound to Play", desc = "Choose a sound file to play",
				values = AceGUIWidgetLSMlists.sound,
				disabled = function() return not self.db.profile[enabled_key] end,
				order = order,
			}
		end
		local soundrange = function(order)
			return {
				type = "range",
				name = "Repeat...",
				desc = "How many times to repeat the sound",
				min = 1, max = 10, step = 1,
				order = order,
			}
		end
		local colorget = function(info)
			local color = self.db.profile[info[#info]]
			return color.r, color.g, color.b, color.a
		end
		local colorset = function(info, r, g, b, a)
			local color = self.db.profile[info[#info]]
			color.r, color.g, color.b, color.a = r, g, b, a
		end

		local fake_args = {
			-- this is a vanilla mob
			deathmaw = faker(10077, "Deathmaw (Tame!)", 29, 0.5, 0.5),
		}
		if LE_EXPANSION_LEVEL_CURRENT >= (LE_EXPANSION_WRATH_OF_THE_LICH_KING or 999) then
			fake_args.time = faker(32491, "Time-Lost Proto Drake (Mount!)", 120, 0.490, 0.362)
			fake_args.vyragosa = faker(32630, "Vyragosa (Boring)", 120, 0.5, 0.5)
		end
		if not ns.CLASSIC then
			-- id, name, zone, x, y, is_dead, is_new_location, source, unit
			-- ishak = faker(157134, "Ishak of the Four Winds (Mount!)", 1527, 0.73, 0.83)
			fake_args.anger = faker(60491, "Sha of Anger (Boss!)", 809, 0.5, 0.5)
			-- haakun = faker(83008, "Haakun", 946, 0.5, 0.5)
			fake_args.yiphrim = faker(157473, "Yiphrim the Will Ravager (Toy!)", 1527, 0.5, 0.786)
			fake_args.amalgamation = faker(157593, "Amalgamation of Flesh (Pet!)", 1527, 0.598, 0.724)
			-- alash = faker(148787, "Alash'anir", 62, 0.598, 0.724)
			-- burninator = faker(149141, "Burninator Mk V (Pet!)", 62, 0.414, 0.764)
			fake_args.worldedge = faker(160821, "Worldedge Gorger (mount)", 1525, 0.5, 0.5)
			fake_args.tarahna = faker(126900, "Instructor Tarahna (multi-toy)", 882, 0.5, 0.5)
			fake_args.nerissa = faker(162690, "Nerissa Heartless (mount)", 1536, 0.5, 0.5)
			-- faeflayer = faker(171688, "Faeflayer", 1536, 0.5, 0.5)
			fake_args.scrapking = faker(151625, "Scrap King (loot)", 1462, 0.5, 0.5)
			fake_args.kash = faker(159105, "Collector Kash (lots of loot)", 1536, 0.5, 0.5)
			-- worldcracker = faker(180032, "Wild Worldcracker", 1961, 0.5, 0.5)
			-- blanchy = faker(173468, "Dead Blanchy", 1525, 0.5, 0.5)
			fake_args.chest = {
				type = "execute", name = "Waterlogged Chest",
				desc = "Fake seeing a Waterlogged Chest",
				func = function()
					-- id, zone, x, y, instanceid
					core.events:Fire("SeenLoot", "Waterlogged Chest", 3341, 37, 0.318, 0.628)
				end
			}
			fake_args.mount_chest = {
				type = "execute", name = "Mawsworn Supply Chest (mount)",
				desc = "Fake seeing a Mawsworn Supply Chest, which contains a mount",
				func = function()
					-- id, zone, x, y, instanceid
					core.events:Fire("SeenLoot", "Mawsworn Supply Chest", 4969, 1970, 0.318, 0.628)
				end
			}
		end

		local options = {
			general = {
				type = "group", name = "Announcements", inline = true,
				order = 10,
				get = get, set = set,
				args = {
					already = toggle("Already found", "Announce when we see rares we've already killed / achieved (if known)", 0),
					already_drop = toggle("Got the loot", "Still announce when we see rares which drop a mount / toy / pet you already have", 10),
					already_transmog = toggle("...include transmog as loot", "Count transmog appearances as knowable loot", 11),
					already_alt = toggle("Completed by an alt", "Announce when we see rares for an achievement that the current character doesn't have, but an alt has completed already", 20),
					known_mounts = toggle("Known mounts are boring", "Treat mount-dropping rares whose mount you already know as if they're regular rares (unless the mount is BoE)", 25),
					dead = toggle("Dead rares", "Announce when we see dead rares, if known. Not all scanning methods know whether a rare is dead or not", 30),
					instances = toggle("Instances", "Show announcements while in an instance", 50),
					loot = toggle("Treasures", "Show announcements when treasure appears on the minimap", 60),
				},
			},
			message = {
				type = "group", name = "Messages",
				order = 20,
				get = get, set = set,
				args = {
					sink = toggle("Enabled", "Send a message to whatever scrolling text addon you're using.", 10),
					output = sink_config,
				},
			},
			test = {
				type = "group", name = "Test it!",
				inline =  true,
				args = fake_args,
			},
			sound = {
				type = "group", name = "Sounds",
				get = get, set = set,
				order = 10,
				args = {
					about = config.desc("Play sounds to announce rare mobs? Can do special things for special mobs. You *really* don't want to miss, say, the Time-Lost Proto Drake, after all...", 0),
					channel = {
						type = "select",
						name = _G.SOUND_CHANNELS or _G.AUDIO_CHANNELS, -- dragonflight
						descStyle = "inline",
						values = {
							Ambience = _G.AMBIENCE_VOLUME,
							Master = _G.MASTER,
							Music = _G.MUSIC_VOLUME,
							SFX = _G.SOUND_VOLUME,
							Dialog = _G.DIALOG_VOLUME,
						},
						order = 11,
					},
					unmute = toggle("Ignore mute", "Play sounds even when muted", 12),
					background = toggle(_G.ENABLE_BGSOUND, _G.OPTION_TOOLTIP_ENABLE_BGSOUND, 13),
					drums = toggle("The Sound of Drums", "Underneath it all, the constant drumming", 14),
					soundgroup = toggle("Group Sync Sounds", "Play sounds from synced mobs from party/raid members", 15),
					soundguild = toggle("Guild Sync Sounds", "Play sounds from synced mobs from guild members not in group", 16),
					regular = {type="header", name="", order=20,},
					sound = toggle("Sounds", "Play sounds for regular mobs", 21),
					soundfile = soundfile("sound", 22),
					sound_loop = soundrange(23),
					mount = {type="header", name="", order=25,},
					sound_mount = toggle("Mount sounds", "Play a sound for mobs that drop a mount", 26),
					soundfile_mount = soundfile("sound_mount", 27),
					sound_mount_loop = soundrange(28),
					boss = {type="header", name="", order=30,},
					sound_boss = toggle("Boss sounds", "Play a sound for mobs that require a group", 31),
					soundfile_boss = soundfile("sound_boss", 35),
					sound_boss_loop = soundrange(37),
					loot = {type="header", name="", order=40,},
					sound_loot = toggle("Loot sounds", "Play a sound for treasures", 41),
					soundfile_loot = soundfile("sound_loot", 45),
					sound_loot_loop = soundrange(47),
				},
			},
			flash = {
				type = "group", name = "Flash",
				get = get, set = set,
				order = 15,
				args = {
					about = config.desc("Flash the screen when a rare is seen.", 0),
					flash = toggle("Enabled", "Flash the screen?", 1),
					flash_color = {
						name = COLOR,
						type = "color",
						hasAlpha = true,
						descStyle = "inline",
						get = colorget,
						set = colorset,
						order = 2,
					},
					flash_texture = {
						name = TEXTURES_SUBHEADER,
						type = "select",
						descStyle = "inline",
						dialogControl = "LSM30_Background",
						values = AceGUIWidgetLSMlists.background,
						order = 3,
					},
					preview = {
						name = PREVIEW,
						type = "execute",
						func = function()
							module:Flash(50065) -- Armagedillo
						end,
						order = 4,
					},
					mount = {type="header", name="", order=10,},
					flash_mount = toggle("Mount flash", "Flash the screen differently when we see a mob with a mount?", 11),
					flash_color_mount = {
						name = COLOR,
						type = "color",
						hasAlpha = true,
						descStyle = "inline",
						get = colorget,
						set = colorset,
						order = 12,
					},
					flash_texture_mount = {
						name = TEXTURES_SUBHEADER,
						type = "select",
						descStyle = "inline",
						dialogControl = "LSM30_Background",
						values = AceGUIWidgetLSMlists.background,
						order = 13,
					},
					preview_mount = {
						name = PREVIEW,
						type = "execute",
						func = function()
							module:Flash(32491) -- time lost
						end,
						order = 14,
					},
					boss = {type="header", name="", order=20,},
					flash_boss = toggle("Boss flash", "Flash the screen differently when we see a boss rare?", 21),
					flash_color_boss = {
						name = COLOR,
						type = "color",
						hasAlpha = true,
						descStyle = "inline",
						get = colorget,
						set = colorset,
						order = 22,
					},
					flash_texture_boss = {
						name = TEXTURES_SUBHEADER,
						type = "select",
						descStyle = "inline",
						dialogControl = "LSM30_Background",
						values = AceGUIWidgetLSMlists.background,
						order = 23,
					},
					preview_boss = {
						name = PREVIEW,
						type = "execute",
						func = function()
							module:Flash(70096) -- War-God Dokah
						end,
						order = 24,
					},
				},
			},
			controller = {
				type = "group", name = "Controller",
				get = get, set = set,
				disabled = function(info) return info[#info] ~= "controller" and not C_GamePad.IsEnabled() end,
				order = 15,
				args = {
					about = config.desc("Vibrate a connected controller when a rare is seen. Only works if controller support is enabled. You can turn it on by typing `/console GamePadEnable 1` in the chat box.", 0),
				},
			},
		}

		local function vibrate_section(t, key, order, heading)
			key = key and ("_"..key) or ""
			if heading then
				t["vibrate_heading" .. key] = {type="header", name="", order=order,}
			end
			t["vibrate" .. key] = toggle(heading or "Vibrate", "Vibrate the controller?", order + 1)
			t["vibrate_type" .. key] = {
				type = "select", name = "Type",
				desc = "What type of vibration to use",
				values = {
					Low = "Low",
					High = "High",
					LTrigger = "LTrigger (PS5 only)",
					RTrigger = "RTrigger (PS5 only)",
				},
				order = order + 2,
			}
			t["vibrate_intensity" .. key] = {
				type = "range", name = "Intensity",
				desc = "How strong the vibration should be",
				min = 0, max = 1, step = 0.1,
				order = order + 3,
			}
			t["preview" .. key] = {
				type = "execute", name = PREVIEW,
				func = function(info)
					C_GamePad.SetVibration(self.db.profile["vibrate_type" .. key], self.db.profile["vibrate_intensity" .. key])
				end,
				order = order + 4,
			}
			return order + 5
		end
		local order = 1
		order = vibrate_section(options.controller.args, nil, 1)
		order = vibrate_section(options.controller.args, "mount", order, "Vibrate for mounts")
		order = vibrate_section(options.controller.args, "boss", order, "Vibrate for bosses")
		order = vibrate_section(options.controller.args, "loot", order, "Vibrate for loot")

		config.options.args.general.plugins.announce = options
	end
end

function module:HasInterestingMounts(id, isloot)
	if not module.db.profile.known_mounts then
		return ns.Loot.HasMounts(id, nil, nil, isloot)
	end
	return ns.Loot.HasInterestingMounts(id, isloot)
end

function module:Seen(callback, id, zone, x, y, is_dead, source, ...)
	Debug("Announce:Seen", id, zone, x, y, is_dead, source, ...)

	if not self.db.profile.instances and IsInInstance() then
		return
	end

	if not self:ShouldAnnounce(id, zone, x, y, is_dead, source, ...) then
		return
	end

	core.events:Fire("Announce", id, zone, x, y, is_dead, source, ...)
end

function module:SeenLoot(callback, name, id, zone, x, y, ...)
	Debug("Announce:SeenLoot", name, id, zone, x, y, ...)

	if not self.db.profile.instances and IsInInstance() then
		return
	end

	if not self.db.profile.loot then
		return
	end

	core.events:Fire("AnnounceLoot", name, id, zone, x, y, ...)
end

function module:ShouldAnnounce(id, zone, x, y, is_dead, source, ...)
	if is_dead and not self.db.profile.dead then
		Debug("ShouldAnnounce", false, "dead")
		return false
	end
	if core.db.global.always[id] then
		-- If you've manually added a mob, bypass any other checks
		Debug("ShouldAnnounce", true, "always")
		return true
	end
	if not self.db.profile.already_drop and ns.Loot.Status(id, self.db.profile.already_transmog) == true and not ns.Loot.HasMounts(id, true, true) then
		-- hide mobs which have a mount/pet/toy which you already own... apart from BoE mounts
		-- this means there's knowable loot, and it's all known
		Debug("ShouldAnnounce", false, "already got loot")
		return false
	end
	if ns.mobdb[id] and (
		(ns.mobdb[id].requires and not ns.conditions.check(ns.mobdb[id].requires)) or
		(ns.mobdb[id].active and not ns.conditions.check(ns.mobdb[id].active))
	) then
		Debug("ShouldAnnounce", false, "requirements not met")
		return false
	end
	if not self.db.profile.already then
		-- hide already-completed mobs
		local quest, achievement, by_alt = ns:CompletionStatus(id)
		if by_alt and not self.db.profile.already_alt then
			-- an alt has completed the achievement, and we don't want to know about that
			Debug("ShouldAnnounce", false, "alt got achievement")
			return false
		end
		if source == "vignette" or source == "point-of-interest" then
			-- The vignette's presence implies no quest completion
			Debug("ShouldAnnounce", true, "vignette implies quest")
			return true
		end
		if quest ~= nil then
			Debug("ShouldAnnounce", not quest, "quest")
			return not quest
		end
		if achievement ~= nil then
			-- can just fall back on achievement
			Debug("ShouldAnnounce", not achievement, "achievement")
			return not achievement
		end
	end

	Debug("ShouldAnnounce", true, "fallback")
	return true
end

core.RegisterCallback("SD Announce Sink", "Announce", function(callback, id, zone, x, y, dead, source)
	if not module.db.profile.sink then
		return
	end

	Debug("Pouring")
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel and player then
			local localized_zone = core.zone_names[zone] or UNKNOWN
			source = "by " .. player .. " in your " .. strlower(channel) .. "; " .. localized_zone
		end
	end
	local pin = ""
	if x and y then
		if x == 0 and y == 0 then
			source = source .. " @ unknown location"
		else
			source = source .. (" @ %.1f, %.1f"):format(x * 100, y * 100)
			if module.db.profile.sink_opts.sink20OutputSink == "ChatFrame" and MAP_PIN_HYPERLINK then
				pin = (" |cffffff00|Hworldmap:%d:%d:%d|h[%s]|h|r"):format(
					zone, x * 10000, y * 10000, MAP_PIN_HYPERLINK
				)
			end
		end
	end
	module:Pour(("Rare seen: %s%s (%s)%s"):format(core:GetMobLabel(id), dead and "... but it's dead" or '', source or '', pin))
end)
core.RegisterCallback("SD AnnounceLoot Sink", "AnnounceLoot", function(callback, name, id, zone, x, y, instanceid)
	if not module.db.profile.sink then
		return
	end

	Debug("Pouring")
	local pin = ""
	local location = UNKNOWN
	if x and y and x > 0 and y > 0 then
		location = ("%.1f, %.1f"):format(x * 100, y * 100)
		if module.db.profile.sink_opts.sink20OutputSink == "ChatFrame" and MAP_PIN_HYPERLINK then
			pin = (" |cffffff00|Hworldmap:%d:%d:%d|h[%s]|h|r"):format(
				zone, x * 10000, y * 10000, MAP_PIN_HYPERLINK
			)
		end
	end
	module:Pour(("Treasure seen: %s (%s)%s"):format(name, location, pin))
end)

local cvar_overrides
local channel_cvars = {
	Ambience = "Sound_EnableAmbience",
	Master = "Sound_EnableAllSound",
	Music = "Sound_EnableMusic",
	SFX = "Sound_EnableSFX",
	Dialog = "Sound_EnableDialog",
}
local delays = {
	["Ikiss: Trinkets"] = 5.7,
}
local nowplaying
function module:PlaySound(s)
	-- Arg is a table, to make scheduling the loops easier. I am lazy.
	Debug("Playing sound", s.soundfile, s.loops)
	-- boring check:
	if s and s.handle then
		StopSound(s.handle)
		if s.drumshandle then
			StopSound(s.drumshandle)
		end
		s.handle = nil
		s.drumshandle = nil
	end
	if not s.loops or s.loops == 0 then
		if cvar_overrides and s.cvars then
			for cvar, value in pairs(s.cvars) do
				SetCVar(cvar, value)
			end
			cvar_overrides = false
		end
		nowplaying = false
		return
	end
	if not cvar_overrides then
		if self.db.profile.background and GetCVar("Sound_EnableSoundWhenGameIsInBG") == "0" then
			cvar_overrides = true
			s.cvars = s.cvars or {}
			s.cvars["Sound_EnableSoundWhenGameIsInBG"] = GetCVar("Sound_EnableSoundWhenGameIsInBG")
			SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
		end
		if self.db.profile.unmute and GetCVar(channel_cvars[self.db.profile.channel]) == "0" then
			cvar_overrides = true
			s.cvars = s.cvars or {}
			s.cvars[channel_cvars[self.db.profile.channel]] = GetCVar(channel_cvars[self.db.profile.channel])
			SetCVar(channel_cvars[self.db.profile.channel], "1")
		end
	end
	-- now, noise!
	local drums = self.db.profile.drums
	if s.soundfile == "NPCScan" then
		--Override default behavior and force npcscan behavior of two sounds at once
		drums = true
		local _, handle = PlaySoundFile(LSM:Fetch("sound", "Scourge Horn"), self.db.profile.channel)
		s.handle = handle
	else
		--Play whatever sound is set
		local _, handle = PlaySoundFile(LSM:Fetch("sound", s.soundfile), self.db.profile.channel)
		s.handle = handle
	end
	if drums then
		local _, handle = PlaySoundFile(LSM:Fetch("sound", "War Drums"), self.db.profile.channel)
		s.drumshandle = handle
	end
	s.loops = s.loops - 1
	-- we guarantee one callback, in case we need to do cleanup
	self:ScheduleTimer("PlaySound", delays[s.soundfile] or 4.5, s)
	nowplaying = true
end
core.RegisterCallback("SD Announce Sound", "Announce", function(callback, id, zone, x, y, dead, source)
	if not LSM then return end
	if nowplaying then return end
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" and not module.db.profile.soundguild or (channel == "PARTY" or channel == "RAID") and not module.db.profile.soundgroup then return end
	end
	local soundfile, loops
	if module:HasInterestingMounts(id) then
		if not module.db.profile.sound_mount then return end
		soundfile = module.db.profile.soundfile_mount
		loops = module.db.profile.sound_mount_loop
	elseif ns.mobdb[id] and ns.mobdb[id].boss then
		if not module.db.profile.sound_boss then return end
		soundfile = module.db.profile.soundfile_boss
		loops = module.db.profile.sound_boss_loop
	else
		if not module.db.profile.sound then return end
		soundfile = module.db.profile.soundfile
		loops = module.db.profile.sound_loop
	end
	module:PlaySound{soundfile = soundfile, loops = loops}
end)
core.RegisterCallback("SD AnnounceLoot Sound", "AnnounceLoot", function(callback, name, id, zone, x, y, instanceid)
	if not (module.db.profile.sound_loot and LSM) then
		return
	end
	if nowplaying then return end
	local soundfile, loops
	if module:HasInterestingMounts(id, true) then
		if not module.db.profile.sound_mount then return end
		soundfile = module.db.profile.soundfile_mount
		loops = module.db.profile.sound_mount_loop
	else
		soundfile = module.db.profile.soundfile_loot
		loops = module.db.profile.sound_loot_loop
	end
	module:PlaySound{soundfile = soundfile, loops = loops}
end)

do
	local flashframe
	function module:Flash(id, isloot)
		if not module.db.profile.flash then
			return
		end
		if not flashframe then
			flashframe = CreateFrame("Frame", nil, WorldFrame)
			flashframe:SetClampedToScreen(true)
			flashframe:SetFrameStrata("FULLSCREEN_DIALOG")
			flashframe:SetToplevel(true)
			flashframe:SetAllPoints(UIParent)
			flashframe:Hide()

			-- Use the OutOfControl (blue) and LowHealth (red) textures to get a purple flash
			local texture = flashframe:CreateTexture(nil, "BACKGROUND")
			texture:SetBlendMode("ADD")
			texture:SetDesaturated(true)
			texture:SetAllPoints()

			local group = flashframe:CreateAnimationGroup()
			group:SetLooping("BOUNCE")
			local pulse = group:CreateAnimation("Alpha")
			pulse:SetFromAlpha(0.3)
			pulse:SetToAlpha(0.75)
			pulse:SetDuration(0.5236)

			local loops = 0
			group:SetScript("OnLoop", function(frame, state)
				loops = loops + 1
				if loops == 9 then
					group:Finish()
				end
			end)
			group:SetScript("OnFinished", function(self)
				loops = 0
				flashframe:Hide()
			end)

			flashframe:SetScript("OnShow", function(self)
				local background = module.db.profile.flash_texture
				local color = module.db.profile.flash_color
				if self.id and ns.mobdb[self.id] then
					if module.db.profile.flash_mount and module:HasInterestingMounts(id, isloot) then
						background = module.db.profile.flash_texture_mount
						color = module.db.profile.flash_color_mount
					elseif ns.mobdb[self.id].boss and module.db.profile.flash_boss then
						background = module.db.profile.flash_texture_boss
						color = module.db.profile.flash_color_boss
					end
				end
				texture:SetTexture(LSM:Fetch("background", background))
				texture:SetVertexColor(color.r, color.g, color.b, color.a)

				group:Play()
			end)
		end

		Debug("Flashing")
		flashframe.id = id
		flashframe:Hide()
		flashframe:Show()
	end

	core.RegisterCallback("SD Announce Flash", "Announce", function(callback, id)
		module:Flash(id)
	end)
	core.RegisterCallback("SD AnnounceLoot Flash", "AnnounceLoot", function(callback, name, id)
		module:Flash(id, true)
	end)
end

core.RegisterCallback("SD Announce Controller", "Announce", function(callback, id, zone, x, y, dead, source)
	local vibrate_type, vibrate_intensity
	if module:HasInterestingMounts(id) then
		if not module.db.profile.vibrate_mount then return end
		vibrate_type = module.db.profile.vibrate_type_mount
		vibrate_intensity = module.db.profile.vibrate_intensity_mount
	elseif ns.mobdb[id] and ns.mobdb[id].boss then
		if not module.db.profile.vibrate_boss then return end
		vibrate_type = module.db.profile.vibrate_type_boss
		vibrate_intensity = module.db.profile.vibrate_intensity_boss
	else
		if not module.db.profile.vibrate then return end
		vibrate_type = module.db.profile.vibrate_type
		vibrate_intensity = module.db.profile.vibrate_intensity
	end
	C_GamePad.SetVibration(vibrate_type, vibrate_intensity)
end)
core.RegisterCallback("SD AnnounceLoot Controller", "AnnounceLoot", function(callback, name, id, zone, x, y, instanceid)
	if not module.db.profile.vibrate_loot then
		return
	end
	C_GamePad.SetVibration(module.db.profile.vibrate_type_loot, module.db.profile.vibrate_intensity_loot)
end)

