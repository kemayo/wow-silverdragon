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
			closeDead = true,
			announce = "IMMEDIATELY", -- or "OPENLAST"
			announceChannel = "CHANNEL",
			sources = {
				target = false,
				grouptarget = true,
				mouseover = true,
				nameplate = true,
				vignette = true,
				['point-of-interest'] = true,
				chat = true,
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
					about = config.desc("Once you've found a rare, it can be nice to actually target it. So this pops up a frame that targets the rare when you click on it.", 0),
					show = config.toggle("Show", "Show the click-target frame.", 10),
					locked = config.toggle("Locked", "Lock the click-target frame in place unless ALT is held down", 15),
					style = {
						type = "select",
						name = "Style",
						desc = "Appearance of the frame",
						values = {},
						order = 20,
					},
					closeAfter = {
						type = "range",
						name = "Close after",
						desc = "How long to leave the target frame up without you interacting with it before it'll go away, in seconds. Every time you mouse over the frame this timer resets.",
						width = "full",
						min = 5,
						max = 600,
						step = 1,
						order = 25,
					},
					closeDead = config.toggle("Close when dead", "Try to close the click-target frame when the mob dies. We'll only be able to *tell* if it dies if we're nearby and in combat. Might have to wait until you're out of combat to do the hiding.", 30),
					announceHeader = {
						type = "header",
						name = "Chat announcements",
						order = 40,
					},
					announceDesc = config.desc("Shift-clicking the target popup will try to send a message about the rare. If you've got it targeted or are near enough to see its nameplate, health will be included.\nIf you have an editbox open, it'll paste the message into that for you to send. If you don't, it'll do whatever these settings say:", 41),
					announce = {
						type = "select",
						name = "Announce to chat",
						values = {
							OPENLAST = "Open last editbox",
							IMMEDIATELY = "Send immediately",
						},
						order = 45,
					},
					announceChannel = {
						type = "select",
						name = "Immediate announce to...",
						values = {
							["CHANNEL"] = COMMUNITIES_DEFAULT_CHANNEL_NAME, -- strictly this isn't correct, but...
							["SAY"] = CHAT_MSG_SAY,
							["YELL"] = CHAT_MSG_YELL,
							["PARTY"] = CHAT_MSG_PARTY,
							["RAID"] = CHAT_MSG_RAID,
							["GUILD"] = CHAT_MSG_GUILD,
							["OFFICER"] = CHAT_MSG_OFFICER,
						},
						order = 46,
					},
					sources = {
						type = "group",
						name = "Rare Sources",
						args = {
							desc = config.desc("Which ways of finding a rare should cause this frame to appear?", 0),
							sources = {
								type="multiselect",
								name = "Sources",
								get = function(info, key) return self.db.profile.sources[key] end,
								set = function(info, key, v) self.db.profile.sources[key] = v end,
								values = {
									target = "Targets",
									grouptarget = "Group targets",
									mouseover = "Mouseover",
									nameplate = "Nameplates",
									vignette = "Vignettes",
									['point-of-interest'] = "Map Points of Interest",
									chat = "Chat yells",
									groupsync = "Group Sync",
									guildsync = "Guild Sync",
								},
								order = 10,
							},
						},
					}
				},
			},
		}
		for key in pairs(self.Looks) do
			config.options.plugins.clicktarget.clicktarget.args.style.values[key] = key:gsub("_", ": ")
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
		Debug("Not showing popup, source disabled", source)
		return
	end
	local data = {
		id = id,
		unit = unit,
		source = source,
		dead = dead,
		zone = zone,
		x = x or 0,
		y = y or 0,
	}
	if InCombatLockdown() then
		Debug("Queueing popup for out-of-combat")
		pending = data
	else
		self:ShowFrame(data)
	end
	FlashClientIcon() -- If you're tabbed out, bounce the WoW icon if we're in a context that supports that
	data.unit = nil -- can't be trusted to remain the same
end

function module:Point()
	local data = self.popup.data
	if data and data.zone and data.x and data.y then
		-- point to it, without a timeout, and ignoring whether it'll be replacing an existing waypoint
		core:GetModule("TomTom"):PointTo(data.id, data.zone, data.x, data.y, 0, true)
	end
end

function module:Marked(callback, id, marker, unit)
	if self.popup.data and self.popup.data.id == id then
		self.popup:SetRaidIcon(marker)
	end
end

function module:PLAYER_REGEN_ENABLED()
	if pending then
		Debug("Showing queued popup")
		self:ShowFrame(pending)
		pending = nil
	end
end

function module:GetGeneralID()
	local channelFormat = GetLocale() == "ruRU" and "%s: %s" or "%s - %s"
	local zoneText = GetZoneText()
	local general = EnumerateServerChannels()
	if zoneText == nil or general == nil then return false end
	return GetChannelName(channelFormat:format(general, zoneText))
end

function module:SendLinkToMob(id, uiMapID, x, y)
	local unit = core:FindUnitWithID(id)
	local text = ("%s %s|cffffff00|Hworldmap:%d:%d:%d|h[%s]|h|r"):format(
		core:NameForMob(id, unit),
		(unit and ('(' .. math.ceil(UnitHealth(unit) / UnitHealthMax(unit) * 100) .. '%) ') or ''),
		uiMapID,
		x * 10000,
		y * 10000,
		-- Can't do this:
		-- core:GetMobLabel(self.data.id) or UNKNOWN
		-- WoW seems to filter out anything which isn't the standard MAP_PIN_HYPERLINK
		MAP_PIN_HYPERLINK
	)
	PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CHAT_SHARE)
	-- if you have an open editbox, just paste to it
	if not ChatEdit_InsertLink(text) then
		-- then do whatever's configured
		if module.db.profile.announce == "OPENLAST" then
			ChatFrame_OpenChat(text)
		elseif module.db.profile.announce == "IMMEDIATELY" then
			local generalID
			if module.db.profile.announceChannel == "CHANNEL" then
				generalID = module:GetGeneralID()
				if not generalID then
					ChatFrame_OpenChat(text)
					return
				end
			end
			Debug("SendChatMessage", text, module.db.profile.announceChannel, generalID)
			SendChatMessage(
				text,
				module.db.profile.announceChannel,
				nil, -- use default language
				module.db.profile.announceChannel == "CHANNEL" and generalID or nil
			)
		end
	end
end
