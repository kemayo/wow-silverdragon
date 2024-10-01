local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("DarkMagic", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug
local DebugF = core.DebugF

local HBD = LibStub("HereBeDragons-2.0")

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("DarkMagic", {
		profile = {
			enabled = false,
			suppress = false,
			vignette = false,
			interval = 0.5,
		},
	})
	self:RegisterEvent("ADDON_ACTION_FORBIDDEN")
	HBD.RegisterCallback(self, "PlayerZoneChanged", "Update")
	core.RegisterCallback(self, "Scan")
	core.RegisterCallback(self, "Seen", "Update")
	core.RegisterCallback(self, "Ready", "Update")
	core.RegisterCallback(self, "IgnoreChanged", "Update")
	core.RegisterCallback(self, "CustomChanged", "Update")

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.scanning.plugins.darkmagic = {
			darkmagic = {
				type = "group",
				name = "Dark Magic",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v)
					self.db.profile[info[#info]] = v
					self:Update(true)
				end,
				args = {
					about = config.desc("Scan for rares by trying to target them with a protected function and watching out for whether Blizzard blocks us. This might cause taint issues for your UI, so it's disabled by default.",
							0),
					enabled = config.toggle("Enabled",
						"Scan through semi-forbidden means",
						10),
					vignette = config.toggle("Include mobs with vignettes",
						"Include mobs with known vignettes in the scan. Filtering them out will reduce the odds of seeing errors when in modern zones. (But the data about which mobs have vignettes is imperfect.)",
						15),
					suppress = config.toggle("Suppress error",
						"Stop the Blizzard action-forbidden error from appearing, probably tainting your UI in the process. Also hide BugSack if you have it installed.",
						20),
					interval = {
						type = "range",
						name = "Scan interval",
						desc = "How long to wait between trying to target each rare. Some zones can have a lot of rares, so higher values can make it possible to miss a rare entirely. Setting this to 0 will mean you're trying to target one rare every game-tick.",
						min = 0, max = 10, step = 0.1,
						order = 30,
					},
				},
				-- order = 99,
			},
		}
	end

	self:Update()
end

local mobs = {}
local index = nil
local AttemptTargetUnit = function()
	local newindex, id = next(mobs, index)
	if not id then return false end
	index = newindex
	local name = core:NameForMob(id)
	-- print("considered", id, name)
	if name then
		local bugSackWasOpen = _G.BugSackFrame and _G.BugSackFrame:IsVisible()
		module.currentlyscanning = true
		TargetUnit(name)
		module.currentlyscanning = false
		if module.forbidden then
			module.forbidden = false
			if module.db.profile.suppress then
				local alert = StaticPopup_FindVisible("ADDON_ACTION_FORBIDDEN", myname)
				if alert then
					-- if they ever change `StaticPopupDialogs["ADDON_ACTION_FORBIDDEN"]` I may need to revisit this, but...
					StaticPopup_HideExclusive()
				end
				if _G.BugSack and _G.BugSackFrame and not bugSackWasOpen then
					-- CloseSack will error if the bugsack window isn't created yet
					_G.BugSack:CloseSack()
				end
			end
			local x, y, zone = HBD:GetPlayerZonePosition()
			-- id, zone, x, y, is_dead, source, unit, silent, force, GUID
			core:NotifyForMob(id, zone, x, y, nil, "darkmagic", false)
		end
	end
	return true
end

function module:Scan()
	if not next(mobs, index) then
		index = nil
	end
end

function module:Update(force)
	if (not self.db.profile.enabled) or (not core.db.profile.instances and IsInInstance()) then
		if self.timer then self.timer:Cancel() end
		self.timer = nil
		return
	end
	if force and self.timer then
		self.timer:Cancel()
		self.timer = nil
	end

	wipe(mobs)
	index = nil
	local zone = HBD:GetPlayerZone()
	-- Mobs from data, and custom mobs specific to the zone
	for id in core:IterateRelevantMobs(zone, true) do
		if
			(module.db.profile.vignette or not core:MobHasVignette(id)) and
			-- filter out ones we wouldn't notify for anyway
			core:WouldNotifyForMob(id, zone) and
			not core:ShouldIgnoreMob(id, zone) and
			core:IsMobInPhase(id, zone)
		then
			table.insert(mobs, id)
		end
	end

	if not self.timer then
		self.timer = C_Timer.NewTicker(self.db.profile.interval, AttemptTargetUnit)
	end
end

function module:ADDON_ACTION_FORBIDDEN(_, addon, blockedFunction)
	if addon == myname and blockedFunction == "TargetUnit()" and self.currentlyscanning then
		self.forbidden = true
	end
end
