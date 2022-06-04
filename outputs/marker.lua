local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Marker")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-2.0")

local mod_announce

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Marker", {
		profile = {
			enabled = true,
			safely = true,
			marker = 3,
		},
	})

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.general.plugins.marker = {
			marker = {
				type = "group",
				name = "Marker",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					about = config.desc("We can automatically mark a unit with a raid target marker once we see it. \"See it\" in this context means target it or move the mouse over it.", 0),
					enabled = config.toggle("Mark it", "Set a raid target marker on a mob once you see it.", 30),
					safely = config.toggle("...safely?", "But not if you're in a group!", 31),
					marker = {
						type = "select",
						name = "Which",
						values = {
							[1] = ICON_LIST[1] .. "0|t Star",
							[2] = ICON_LIST[2] .. "0|t Circle",
							[3] = ICON_LIST[3] .. "0|t Diamond",
							[4] = ICON_LIST[4] .. "0|t Triangle",
							[5] = ICON_LIST[5] .. "0|t Moon",
							[6] = ICON_LIST[6] .. "0|t Square",
							[7] = ICON_LIST[7] .. "0|t Cross",
							[8] = ICON_LIST[8] .. "0|t Skull",
						},
					},
				},
			},
		}
	end

	mod_announce = core:GetModule("Announce", true)
end

function module:OnEnable()
	core.RegisterCallback(self, "Seen_Raw")
end

function module:Seen_Raw(callback, id, zone, x, y, dead, source, unit)
	if not unit then
		return
	end
	if not self.db.profile.enabled then
		return
	end
	if IsInGroup() then
		if self.db.profile.safely then
			-- Just don't do anything in groups
			return
		end
		if IsInRaid() and not UnitIsGroupLeader("player") then
			-- In raids, only the leader can set icons
			-- TODO: also assistants, apparently
			return
		end
		-- But in parties, anyone can set icons
	end
	if GetRaidTargetIndex(unit) then
		-- Don't overwrite an existing icon
		return
	end
	if id and core:ShouldIgnoreMob(id, HBD:GetPlayerZone()) then
		return
	end
	if mod_announce and not mod_announce:ShouldAnnounce(id, zone, x, y, dead, source, unit) then
		return
	end
	SetRaidTarget(unit, self.db.profile.marker)
	core.events:Fire("Marked", id, self.db.profile.marker, unit)
end
