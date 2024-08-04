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
					self:Update()
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

function module:Scan()
	if self.timer then return end
	self:Update()
end

function module:Update()
	if self.timer then
		-- Throw this away
		self.timer:Cancel()
	end
	if not self.db.profile.enabled then
		return self.timer and self.timer:Cancel()
	end
	if not core.db.profile.instances and IsInInstance() then
		return self.timer and self.timer:Cancel()
	end
	-- build a cached table of mobs
	local zone = HBD:GetPlayerZone()
	local mobs = zone and ns.mobsByZone[zone]
	if not mobs then
		-- Moving into a different zone that has mobs will have us try again
		return
	end
	-- The name we use here is what's going to be passed as the event arg
	-- later, so wrap gives us something more identifiable than just
	-- coroutine.resume...
	local SDTargetUnitWasForbidden = coroutine.wrap(function()
		for id in pairs(mobs) do
			local name = core:NameForMob(id)
			local attempted
			if
				name and
				(module.db.profile.vignette or not core:MobHasVignette(id)) and
				-- filter out ones we wouldn't notify for anyway
				core:WouldNotifyForMob(id, zone) and
				not core:ShouldIgnoreMob(id, zone) and
				core:IsMobInPhase(id, zone)
			then
				attempted = true
				local bugSackWasOpen = _G.BugSackFrame and _G.BugSackFrame:IsVisible()
				self.currentlyscanning = true
				TargetUnit(name)
				self.currentlyscanning = false
				if self.forbidden then
					self.forbidden = false
					if self.db.profile.suppress then
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
					local x, y = HBD:GetPlayerZonePosition()
					-- id, zone, x, y, is_dead, source, unit, silent, force, GUID
					core:NotifyForMob(id, zone, x, y, false, "darkmagic", false)
				end
			end
			-- yield away because we shouldn't just spam this
			if attempted then
				coroutine.yield()
			end
		end
		if self.timer then
			-- Wait for the core Scan callback to resume
			self.timer:Cancel()
			self.timer = nil
		end
	end)
	-- interestingly, a coroutine.wrap resumeFunc won't be accepted as a
	-- function by C_Timer...
	self.timer = C_Timer.NewTicker(self.db.profile.interval, function()
		SDTargetUnitWasForbidden()
	end)
end

function module:ADDON_ACTION_FORBIDDEN(_, addon, blockedFunction)
	if addon == myname and blockedFunction == "SDTargetUnitWasForbidden()" and self.currentlyscanning then
		self.forbidden = true
	end
end
