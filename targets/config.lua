local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug
local ns = core.NAMESPACE

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local LibWindow = LibStub("LibWindow-1.1")

function module:RegisterConfig()
	local config = core:GetModule("Config", true)
	if not config then return end

	local db = self.db.profile
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
