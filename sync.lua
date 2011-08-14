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
					nearby = config.toggle("Nearby only", "Only accept syncs from people who are nearby. Information about guild members isn't available, so they'll only count as nearby if they're in your group."),
					quiet = config.toggle("Be quiet", "Don't send rare information to others"),
				},
			},
		}
	end
end

local protocol_version = 1
local function SAM(channel, ...)
	core.Debug("Sending message", channel, protocol_version, ...)
	ChatThrottleLib:SendAddonMessage("NORMAL", "SilverDragon", strjoin("\t", tostringall(protocol_version, ...)), channel)
end
local function deSAM(val)
	if val == "nil" then
		return nil
	end
	if val and val:match("\d+\.?\d*") then
		return tonumber(val)
	end
	return val
end

function module:Seen(callback, zone, name, x, y, dead, newloc, source, unit, id)
	if source and source:match("^sync") then
		-- No feedback loops, kthxbai
		return
	end
	if self.db.profile.quiet then
		return
	end
	local level = globaldb.mob_level[name]
	if IsInGuild() then
		SAM("GUILD", "seen", id, name, zone, level, x, y)
	end
	if GetRealNumRaidMembers() > 0 then
		SAM("RAID", "seen", id, name, zone, level, x, y)
	elseif GetRealNumPartyMembers() > 0 then
		SAM("PARTY", "seen", id, name, zone, level, x, y)
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
		-- note: will only ever detect group members as being nearby
		-- could enhance to include guild members via roster scanning to compare zones,
		-- or by using some guild member position lib.
		return
	end

	local ver, msgType, id, name, zone, level, x, y = strsplit("\t", msg)
	Debug("Message", msgType, id, name, zone, level, x, y)

	ver = deSAM(ver)
	level = deSAM(level)
	x = deSAM(x)
	y = deSAM(y)

	if tonumber(ver or "") ~= protocol_version then
		Debug("Skipping: incompatible version")
		return
	end

	if msgType ~= "seen" then
		-- only one so far
		Debug("Skipping: unknown msgtype")
		return
	end

	if not (msgType and name and zone and level) then
		Debug("Skipping: insufficient data")
		return
	end

	if spam[name] and spam[name] > (time() - core.db.profile.delay) then
		Debug("Skipping: spam for mob", name, spam[name], time() - core.db.profile.delay)
		return
	end
	spam[name] = time()

	-- zone, name, x, y, dead, new_location, source, unit
	core:NotifyMob(zone, name, x, y, false, false, "sync:"..channel..":"..sender, false)
end
