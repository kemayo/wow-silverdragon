local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("ClickTarget", "AceEvent-3.0")
local Debug = core.Debug

local LibWindow = LibStub("LibWindow-1.1")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

module.Looks = {}
module.LookConfig = {}
module.defaults = {
	profile = {
		show = true,
		loot = true,
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
		anchor = {
			point = "BOTTOMRIGHT",
			x = -260,
			y =  270,
			scale = 1,
		},
		style_options = {
			['*'] = {},
		},
	},
}

local db
function module:OnInitialize()
	self.db = core.db:RegisterNamespace("ClickTarget", self.defaults)
	db = self.db.profile

	core.RegisterCallback(self, "Announce")
	core.RegisterCallback(self, "AnnounceLoot")
	core.RegisterCallback(self, "Marked")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	self.anchor = self:CreateAnchor()

	local config = core:GetModule("Config", true)
	if config then
		local recreating
		local function _newPopup()
			local oldpopup = self.popup
			self.popup = self:CreatePopup()
			if oldpopup and oldpopup:IsVisible() then
				self:ShowFrame(oldpopup.data)
				oldpopup:Hide()
			end
			recreating = nil
		end
		local function refreshPopup(info)
			if recreating then return end
			if info.arg then
				recreating = true
				C_Timer.After(0.2, _newPopup)
			end
		end
		config.options.plugins.clicktarget = {
			clicktarget = {
				type = "group",
				name = "ClickTarget",
				get = function(info) return db[info[#info]] end,
				set = function(info, v)
					db[info[#info]] = v
					refreshPopup(info)
				end,
				order = 25,
				args = {
					about = config.desc("Once you've found a rare, it can be nice to actually target it. So this pops up a frame that targets the rare when you click on it.", 0),
					show = config.toggle("Show for mobs", "Show the click-target frame for mobs", 10),
					loot = config.toggle("Show for treasure", "Show the click-target frame for treasures", 11),
					appearanceHeader = {
						type = "header",
						name = "Appearance",
						order = 20,
					},
					style = {
						type = "select",
						name = "Style",
						desc = "Appearance of the frame",
						values = function(info)
							local values = {}
							for key in pairs(self.Looks) do
								values[key] = key:gsub("_", ": ")
							end
							-- replace ourself with the built values table
							info.option.values = values
							return values
						end,
						arg = true,
						order = 21,
					},
					anchor = {
						type = "execute",
						name = function() return self.anchor:IsShown() and "Hide Anchor" or "Show Anchor" end,
						descStyle = "inline",
						desc = "Show the anchor frame that the popup will attach to",
						func = function()
							self.anchor[self.anchor:IsShown() and "Hide" or "Show"](self.anchor)
							AceConfigRegistry:NotifyChange(myname)
						end,
						order = 22,
					},
					scale = {
						type = "range",
						name = UI_SCALE,
						width = "full",
						min = 0.5,
						max = 2,
						get = function(info) return db.anchor.scale end,
						set = function(info, value)
							db.anchor.scale = value
							LibWindow.SetScale(self.anchor, value)
							if self.popup then
								self.popup:SetScale(db.anchor.scale)
							end
						end,
						order = 23,
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
								get = function(info, key) return db.sources[key] end,
								set = function(info, key, v) db.sources[key] = v end,
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
					},
					style_options = {
						type = "group",
						name = "Style options",
						get = function(info)
							local value = db.style_options[info[#info - 1]][info[#info]]
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
							db.style_options[info[#info - 1]][info[#info]] = value
							refreshPopup(info)
						end,
						args = module.LookConfig,
					},
				},
			},
		}
		module.LookConfig.about = config.desc("Some styles have options. Change those here.", 0)
	end
end

local pending
function module:Announce(callback, id, zone, x, y, dead, source, unit)
	if not db.show then return end
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" then
			source = "guildsync"
		else
			source = "groupsync"
		end
	end
	if not db.sources[source] then
		Debug("Not showing popup, source disabled", source)
		return
	end
	local data = {
		type = "mob",
		id = id,
		unit = unit,
		source = source,
		dead = dead,
		zone = zone,
		x = x or 0,
		y = y or 0,
	}
	-- if InCombatLockdown() then
	-- 	Debug("Queueing popup for out-of-combat")
	-- 	pending = data
	-- else
		self:ShowFrame(data)
	-- end
	FlashClientIcon() -- If you're tabbed out, bounce the WoW icon if we're in a context that supports that
	data.unit = nil -- can't be trusted to remain the same
end
function module:AnnounceLoot(_, name, id, zone, x, y)
	if not db.loot then return end
	local data = {
		type = "loot",
		id = id,
		name = name,
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
end

function module:Point()
	local data = self.popup and self.popup.data
	if data and data.zone and data.x and data.y then
		-- point to it, without a timeout, and ignoring whether it'll be replacing an existing waypoint
		core:GetModule("TomTom"):PointTo(data.type == "mob" and data.id or data.name, data.zone, data.x, data.y, 0, true)
	end
end

function module:Marked(callback, id, marker, unit)
	if self.popup and self.popup.data and self.popup.data.id == id then
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

function module:SendLink(prefix, uiMapID, x, y)
	local message = ("%s|cffffff00|Hworldmap:%d:%d:%d|h[%s]|h|r"):format(
		prefix,
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
	if not ChatEdit_InsertLink(message) then
		-- then do whatever's configured
		if db.announce == "OPENLAST" then
			ChatFrame_OpenChat(message)
		elseif db.announce == "IMMEDIATELY" then
			local generalID
			if db.announceChannel == "CHANNEL" then
				generalID = module:GetGeneralID()
				if not generalID then
					ChatFrame_OpenChat(message)
					return
				end
			end
			Debug("SendChatMessage", message, db.announceChannel, generalID)
			SendChatMessage(
				message,
				db.announceChannel,
				nil, -- use default language
				db.announceChannel == "CHANNEL" and generalID or nil
			)
		end
	end
end

function module:SendLinkToMob(id, uiMapID, x, y)
	local unit = core:FindUnitWithID(id)
	local prefix = ("%s %s"):format(
		core:NameForMob(id, unit),
		(unit and ('(' .. math.ceil(UnitHealth(unit) / UnitHealthMax(unit) * 100) .. '%) ') or '')
	)
	self:SendLink(prefix, uiMapID, x, y)
end

function module:SendLinkToLoot(name, uiMapID, x, y)
	self:SendLink(name, uiMapID, x, y)
end

function module:SendLinkFromData(data, uiMapID, x, y)
	if data.type == "mob" then
		self:SendLinkToMob(data.id, uiMapID, x, y)
	elseif data.type == "loot" then
		self:SendLinkToLoot(data.name, uiMapID, x, y)
	end
end

function module:CreateAnchor()
	local anchor = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	anchor:SetSize(250, 100)
	anchor:SetFrameStrata("DIALOG")
	anchor:SetBackdrop({
		bgFile = [[Interface\FriendsFrame\UI-Toast-Background]],
		edgeFile = [[Interface\FriendsFrame\UI-Toast-Border]],
		edgeSize = 12,
		tile = true,
		tileSize = 12,
		insets = { left = 5, right = 5, top = 5, bottom = 5, },
	})

	anchor:EnableMouse(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:SetClampedToScreen(true)
	anchor:Hide()

	local title = anchor:CreateFontString(nil, "BORDER", "FriendsFont_Normal")
	title:SetJustifyH("CENTER")
	title:SetJustifyV("MIDDLE")
	title:SetWordWrap(true)
	title:SetPoint("TOPLEFT", anchor, "TOPLEFT", 15, -10)
	title:SetPoint("RIGHT", anchor, "RIGHT", -20, 10)
	title:SetText(myname)
	title:SetWidth(anchor:GetWidth())

	local text = anchor:CreateFontString(nil, "BORDER", "FriendsFont_Normal")
	text:SetSize(anchor:GetWidth() - 20, 24)
	text:SetJustifyH("MIDDLE")
	text:SetJustifyV("TOP")
	text:SetWordWrap(true)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	text:SetText("Target buttons will appear here")

	local close = CreateFrame("Button", nil, anchor, "UIPanelCloseButton")
	close:SetSize(24, 24)
	close:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", -2, -2)

	anchor:SetHeight(text:GetStringHeight() + title:GetStringHeight() + 25)

	LibWindow.RegisterConfig(anchor, db.anchor)
	LibWindow.RestorePosition(anchor)
	LibWindow.MakeDraggable(anchor)

	anchor:HookScript("OnDragStop", function()
		AceConfigRegistry:NotifyChange(myname)
	end)

	return anchor
end

function module:RegisterLookConfig(look, config, defaults)
	self.LookConfig[look] = {
		type = "group",
		name = look:gsub("_", ": "),
		args = config,
		inline = true,
	}
	if defaults then
		self.defaults.profile.style_options[look] = defaults
		if self.db then
			self.db:RegisterDefaults(self.db.defaults)
		end
	end
end
