local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Targets", "AceEvent-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-1.0")

local globaldb
local UnitExists, UnitIsVisible, UnitPlayerControled, UnitName, UnitLevel, UnitCreatureType, UnitGUID = UnitExists, UnitIsVisible, UnitPlayerControled, UnitName, UnitLevel, UnitCreatureType, UnitGUID
function module:OnInitialize()
	globaldb = core.db.global

	self.db = core.db:RegisterNamespace("Scan_Targets", {
		profile = {
			mouseover = true,
			targets = true,
		},
	})

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.scanning.plugins.targets = {
			targets = {
				type = "group",
				name = "Targets",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					mouseover = config.toggle("Mouseover", "Check mobs that you mouse over.", 10),
					targets = config.toggle("Targets", "Check the targets of people in your group.", 20),
				},
			},
		}
	end
end

function module:OnEnable()
	core.RegisterCallback(self, "Scan")

	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function module:PLAYER_TARGET_CHANGED()
	self:ProcessUnit('target', 'target')
end

function module:UPDATE_MOUSEOVER_UNIT()
	self:ProcessUnit('mouseover', 'mouseover')
end

local units_to_scan = {'targettarget', 'party1target', 'party2target', 'party3target', 'party4target', 'party5target'}
function module:Scan(callback, zone)
	if not (self.db.profile.targets and IsInGroup()) then
		return
	end
	for _, unit in ipairs(units_to_scan) do
		self:ProcessUnit(unit, 'grouptarget')
	end
end

--Rares not actually flagged as rare
local rare_nonflags = {
	[3868] = true, -- Blood Seeker
	[50009] = true, -- Mobus
	[50056] = true, -- Garr
	[50061] = true, -- Xariona
	[50063] = true, -- Akma'hat
	[50089] = true, -- Julak-Doom
	[58336] = true, -- Darkmoon Rabbit
	[62346] = true, -- Galleon
	[69161] = true, -- Oondasta
}

function module:ProcessUnit(unit, source)
	if not UnitExists(unit) then return end
	if not UnitIsVisible(unit) then return end
	if UnitPlayerControlled(unit) then return end -- helps filter out player-pets
	local unittype = UnitClassification(unit)
	local id = core:UnitID(unit)
	if id and (globaldb.always[id] or globaldb.mob_name[id] or rare_nonflags[id] or (unittype == 'rare' or unittype == 'rareelite')) then
		-- from this point on, it's a rare
		local x, y, zone = HBD:GetPlayerZonePosition()
		if not zone then return end -- there are only a few places where this will happen

		local name = UnitName(unit)
		local level = (UnitLevel(unit) or -1)
		local creature_type = UnitCreatureType(unit)
		local guid = UnitGUID(unit) or 0

		local newloc
		if CheckInteractDistance(unit, 4) then
			newloc = core:SaveMob(id, name, zone, x, y, level, unittype, creature_type)
		end

		local silent = (source == 'target' and not self.db.profile.targets) or (source == 'mouseover' and not self.db.profile.mouseover)

		core:NotifyMob(id, name, zone, x, y, UnitIsDead(unit), newloc, source or 'target', unit, silent)
		return true
	end
end
