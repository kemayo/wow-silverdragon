local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Sync", "AceEvent-3.0")
local Debug = core.Debug

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Sync", {
		profile = {
			party = true,
			raid = true,
			guild = false,
			nearby = false,
			quiet = false,
		},
	})

	core.RegisterCallback(self, "Seen")
	self:RegisterEvent("CHAT_MSG_ADDON")

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.sync = {
			sync = {
				type = "group",
				name = "Sync",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					party = config.toggle("Party", "Accept syncs from party members"),
					raid = config.toggle("Raid", "Accept syncs from raid members"),
					guild = config.toggle("Guild Sync", "Accept syncs from guild members"),
					nearby = config.toggle("Nearby only", "Only accept syncs from people who are nearby"),
					quiet = config.toggle("Be quiet", "Don't send rare information to others"),
				},
			},
		}
	end
end

local function SAM(channel, ...)
	core.Debug("Sending message", channel, ...)
	SendAddonMessage("SilverDragon", strjoin("\t", ...), channel)
end

function module:Seen(callback, zone, name, x, y, dead, newloc, source, unit, id, level)
	if source and source:match("^sync") then
		-- No feedback loops, kthxbai
		return
	end
	if self.db.profile.quiet then
		return
	end
	if IsInGuild() then
		SAM("GUILD", name, zone, level, x, y)
	end
	if GetRealNumRaidMembers() > 0 then
		SAM("RAID", name, zone, level, x, y)
	elseif GetRealNumPartyMembers() > 0 then
		SAM("PARTY", name, zone, level, x, y)
	end
end

local spam = {}
function module:CHAT_MSG_ADDON(event, prefix, msg, channel, sender)
	if prefix ~= "SilverDragon" or sender == UnitName("player") then
		return
	end
	if channel == "GUILD" and not self.db.profile.guild then
		return
	end
	if channel == "RAID" and not self.db.profile.raid then
		return
	end
	if channel == "PARTY" and not self.db.profile.party then
		return
	end
	if self.db.profile.nearby and not CheckInteractDistance(sender, 4) then
		return
	end

	local msgType, name, zone, level, x, y = strsplit("\t", msg)
	Debug("Message", msgType, name, zone, level, x, y)

	if msgType ~= "seen" then
		-- only one so far
		return
	end

	if not (msgType and name and zone and level) then
		return
	end

	if spam[name] and spam[name] > (time() - core.db.profile.delay) then
		return
	end
	spam[name] = time()

	level = tonumber(level or "")
	x = tonumber(x or "")
	y = tonumber(y or "")

	-- zone, name, x, y, dead, new_location, source, unit, id, level
	core.events:Fire("Seen", zone, name, x, y, false, false, "sync:"..channel..":"..sender, false, core.db.global.mob_id[name], level)
end
