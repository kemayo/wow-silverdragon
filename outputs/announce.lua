local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Announce", "AceTimer-3.0", "LibSink-2.0")
local Debug = core.Debug

local LSM = LibStub("LibSharedMedia-3.0")

if LSM then
	-- Register some media
	LSM:Register("sound", "Rubber Ducky", 566121)
	LSM:Register("sound", "Cartoon FX", 566543)
	LSM:Register("sound", "Explosion", 566982)
	LSM:Register("sound", "Shing!", 566240)
	LSM:Register("sound", "Wham!", 566946)
	LSM:Register("sound", "Simon Chime", 566076)
	LSM:Register("sound", "War Drums", 567275)--NPC Scan default
	LSM:Register("sound", "Scourge Horn", 567386)--NPC Scan default
	LSM:Register("sound", "Pygmy Drums", 566508)
	LSM:Register("sound", "Cheer", 567283)
	LSM:Register("sound", "Humm", 569518)
	LSM:Register("sound", "Short Circuit", 568975)
	LSM:Register("sound", "Fel Portal", 569215)
	LSM:Register("sound", "Fel Nova", 568582)
	LSM:Register("sound", "PVP Flag", 569200)
	LSM:Register("sound", "Algalon: Beware!", 543587)
	LSM:Register("sound", "Yogg Saron: Laugh", 564859)
	LSM:Register("sound", "Illidan: Not Prepared", 552503)
	LSM:Register("sound", "Magtheridon: I am Unleashed", 554554)
	LSM:Register("sound", "Loatheb: I see you", 554236)
	LSM:Register("sound", "NPCScan", 567275)--Sound file is actually bogus, this just forces the option NPCScan into menu. We hack it later.
end

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
			soundfile = "Loatheb: I see you",
			soundfile_mount = "Illidan: Not Prepared",
			soundfile_boss = "Magtheridon: I am Unleashed",
			sound_loop = 1,
			sound_mount_loop = 3,
			sound_boss_loop = 1,
			flash = true,
			instances = false,
			dead = true,
			already = false,
			sink_opts = {},
		},
	})

	self:SetSinkStorage(self.db.profile.sink_opts)

	core.RegisterCallback(self, "Seen")

	local config = core:GetModule("Config", true)
	if config then
		local toggle = config.toggle
		local get = function(info) return self.db.profile[info[#info]] end
		local set = function(info, v) self.db.profile[info[#info]] = v end

		local sink_config = self:GetSinkAce3OptionsDataTable()
		sink_config.inline = true
		sink_config.order = 15

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

		local options = {
			general = {
				type = "group", name = "General", inline = true,
				order = 10,
				get = get, set = set,
				args = {
					already = toggle("Already found", "Announce when we see rares we've already killed / achieved (if known)"),
					dead = toggle("Dead rares", "Announce when we see dead rares, if known. Not all scanning methods know whether a rare is dead or not, so this isn't entirely reliable."),
					flash = toggle("Flash", "Flash the edges of the screen."),
					instances = toggle("Instances", "Show announcements while in an instance"),
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
				args = {
					-- id, name, zone, x, y, is_dead, is_new_location, source, unit
					time = faker(32491, "Time-Lost Proto Drake (Mount!)", 495, 0.490, 0.362),
					anger = faker(60491, "Sha of Anger (Boss!)", 809, 0.5, 0.5),
					vyragosa = faker(32630, "Vyragosa (Boring)", 495, 0.5, 0.5),
					deathmaw = faker(10077, "Deathmaw (Pet!)", 29, 0.5, 0.5),
					haakun = faker(83008, "Haakun", 946, 0.5, 0.5),
				},
			},
		}
		if LSM then
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
			options.sound = {
				type = "group", name = "Sounds",
				get = get, set = set,
				order = 10,
				args = {
					about = config.desc("Play sounds to announce rare mobs? Can do special things for special mobs. You *really* don't want to miss, say, the Time-Lost Proto Drake, after all...", 0),
					sound = toggle("Enabled", "Play sounds at all!", 10),
					drums = toggle("The Sound of Drums", "Underneath it all, the constant drumming", 12),
					soundgroup = toggle("Group Sync Sounds", "Play sounds from synced mobs from party/raid members", 13),
					soundguild = toggle("Guild Sync Sounds", "Play sounds from synced mobs from guild members not in group", 14),
					soundfile = soundfile("sound", 15),
					sound_loop = soundrange(17),
					mount = {type="header", name="", order=20,},
					sound_mount = toggle("Mount sounds", "Play a special sound for mobs that drop a mount", 21),
					soundfile_mount = soundfile("sound_mount", 25),
					sound_mount_loop = soundrange(27),
					boss = {type="header", name="", order=30,},
					sound_boss = toggle("Boss sounds", "Play a special sound for mobs that require a group", 31),
					soundfile_boss = soundfile("sound_boss", 35),
					sound_boss_loop = soundrange(37),
				},
			}
		end
		config.options.args.outputs.plugins.announce = options
	end
end

function module:Seen(callback, id, zone, x, y, is_dead, source, ...)
	Debug("Announce:Seen", id, zone, x, y, is_dead, ...)

	if not self.db.profile.instances and IsInInstance() then
		return
	end

	if not self:ShouldAnnounce(id, zone, x, y, is_dead, source, ...) then
		return
	end

	core.events:Fire("Announce", id, zone, x, y, is_dead, source, ...)
end

function module:ShouldAnnounce(id, zone, x, y, is_dead, source, ...)
	if is_dead and not self.db.profile.dead then
		return
	end

	if not self.db.profile.already then
		-- hide already-completed mobs
		local quest, achievement = ns:CompletionStatus(id)
		if quest ~= nil or achievement ~= nil then
			-- knowable
			if achievement ~= nil then
				-- achievement knowable
				if quest ~= nil then
					-- quest also knowable
					return not quest
				end
				if source == 'vignette' then
					-- No quest known, but the vignette wouldn't be present if the quest was complete, so...
					return true
				end
				-- can just fall back on achievement
				return not achievement
			else
				-- just quest knowable
				return not quest
			end
		end
	end

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
	if x and y then
		source = source .. " @ " .. core.round(x * 100, 1) .. "," .. core.round(y * 100, 1)
	end
	local prefix = "Rare seen: "
	module:Pour((prefix .. "%s%s (%s)"):format(core:GetMobLabel(id) or UNKNOWN, dead and "... but it's dead" or '', source or ''))
end)

function module:PlaySound(s)
	-- Arg is a table, to make scheduling the loops easier. I am lazy.
	Debug("Playing sound", s.soundfile, s.loops)
	-- boring check:
	if not s.loops or s.loops == 0 then return end
	-- now, noise!
	local drums = self.db.profile.drums
	if s.soundfile == "NPCScan" then
		--Override default behavior and force npcscan behavior of two sounds at once
		drums = true
		PlaySoundFile(LSM:Fetch("sound", "Scourge Horn"), "Master")
	else
		--Play whatever sound is set
		PlaySoundFile(LSM:Fetch("sound", s.soundfile), "Master")
	end
	if drums then
		PlaySoundFile(LSM:Fetch("sound", "War Drums"), "Master")
	end
	s.loops = s.loops - 1
	if s.loops > 0 then
		self:ScheduleTimer("PlaySound", 4.5, s)
	end
end
core.RegisterCallback("SD Announce Sound", "Announce", function(callback, id, zone, x, y, dead, source)
	if not (module.db.profile.sound and LSM) then
		return
	end
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" and not module.db.profile.soundguild or (channel == "PARTY" or channel == "RAID") and not module.db.profile.soundgroup then return end
	end
	local soundfile, loops
	if module.db.profile.sound_mount and ns.mobdb[id] and ns.mobdb[id].mount then
		soundfile = module.db.profile.soundfile_mount
		loops = module.db.profile.sound_mount_loop
	elseif module.db.profile.sound_boss and ns.mobdb[id] and ns.mobdb[id].boss then
		soundfile = module.db.profile.soundfile_boss
		loops = module.db.profile.sound_boss_loop
	else
		soundfile = module.db.profile.soundfile
		loops = module.db.profile.sound_loop
	end
	module:PlaySound{soundfile = soundfile, loops = loops}
end)

do
	local flashframe
	core.RegisterCallback("SD Announce Flash", "Announce", function(callback)
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
			texture:SetTexture([[Interface\FullScreenTextures\OutOfControl]])
			texture:SetBlendMode("ADD")
			texture:SetAllPoints()

			texture = flashframe:CreateTexture(nil, "BACKGROUND")
			texture:SetTexture([[Interface\FullScreenTextures\LowHealth]])
			texture:SetBlendMode("ADD")
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
				group:Play()
			end)
		end

		Debug("Flashing")
		flashframe:Show()
	end)
end
