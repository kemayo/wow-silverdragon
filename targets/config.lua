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

	config.options.plugins.clicktarget = {
		clicktarget = {
			type = "group",
			name = "ClickTarget",
			get = function(info) return self.db.profile[info[#info]] end,
			set = function(info, v)
				self.db.profile[info[#info]] = v
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
					set = function(info, v)
						self.db.profile[info[#info]] = v
						module:Redraw()
					end,
					order = 21,
				},
				model = {
					type = "toggle",
					name = "Show 3d model",
					desc = "Whether to show the fully 3d model of the mob. In some styles this will fall back to a 2d icon, in others it'll go away entirely.",
					set = function(info, v)
						self.db.profile[info[#info]] = v
						module:Redraw()
					end,
					order = 23,
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
					order = 25,
				},
				stacksize = {
					type = "range",
					name = "Stack size",
					desc = "How many popups to show at once",
					min = 1,
					max = 6,
					step = 1,
					order = 30,
				},
				scale = {
					type = "range",
					name = UI_SCALE,
					width = "full",
					min = 0.5,
					max = 2,
					get = function(info) return self.db.profile.anchor.scale end,
					set = function(info, value)
						self.db.profile.anchor.scale = value
						LibWindow.SetScale(self.anchor, value)
						for _, popup in ipairs(self.stack) do
							popup:SetScale(self.db.profile.anchor.scale)
							self:SetModel(popup)
						end
					end,
					order = 35,
				},
				closeAfter = {
					type = "range",
					name = "Close after",
					desc = "How long to leave the target frame up without you interacting with it before it'll go away, in seconds. Every time you mouse over the frame this timer resets.",
					width = "full",
					min = 5,
					max = 600,
					step = 1,
					order = 40,
				},
				closeDead = config.toggle("Close when dead", "Try to close the click-target frame when the mob dies. We'll only be able to *tell* if it dies if we're nearby and in combat. Might have to wait until you're out of combat to do the hiding.", 30),
				announceHeader = {
					type = "header",
					name = "Chat announcements",
					order = 50,
				},
				announceDesc = config.desc("Shift-clicking the target popup will try to send a message about the rare. If you've got it targeted or are near enough to see its nameplate, health will be included.\nIf you have an editbox open, it'll paste the message into that for you to send. If you don't, it'll do whatever these settings say:", 41),
				announce = {
					type = "select",
					name = "Announce to chat",
					values = {
						OPENLAST = "Open last editbox",
						IMMEDIATELY = "Send immediately",
					},
					order = 55,
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
					order = 60,
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
								darkmagic = "Dark Magic",
							},
							order = 10,
						},
					},
				},
				style_options = {
					type = "group",
					name = "Style options",
					get = function(info)
						local value = self.db.profile.style_options[info[#info - 1]][info[#info]]
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
						self.db.profile.style_options[info[#info - 1]][info[#info]] = value
						for popup, look in self:EnumerateActive() do
							if look == info[#info - 1] then
								self:ResetLook(popup)
							end
						end
					end,
					args = module.LookConfig,
				},
			},
		},
	}
	module.LookConfig.about = config.desc("Some styles have options. Change those here.", 0)
end

function module:RegisterLookConfig(look, config, defaults, reset)
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
	self.LookReset[look] = reset
end
