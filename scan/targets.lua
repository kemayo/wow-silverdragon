local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Targets", "AceEvent-3.0")

function module:OnEnable()
	core.RegisterCallback(self, "Scan")

	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function module:PLAYER_TARGET_CHANGED()
	if core.db.profile.targets then
		self:ProcessUnit('target', 'target')
	end
end

function module:UPDATE_MOUSEOVER_UNIT()
	if core.db.profile.mouseover then
		self:ProcessUnit('mouseover', 'mouseover')
	end
end

local units_to_scan = {'targettarget', 'party1target', 'party2target', 'party3target', 'party4target', 'party5target'}
function module:Scan(callback, zone)
	if not (core.db.profile.targets and IsInGroup()) then
		return
	end
	for _, unit in ipairs(units_to_scan) do
		self:ProcessUnit(unit, 'grouptarget')
	end
end

function module:ProcessUnit(unit, source)
	if not UnitExists(unit) then return end
	if UnitPlayerControlled(unit) then return end -- helps filter out player-pets
	local unittype = UnitClassification(unit)
	local id = core:UnitID(unit)
	if (core.db.global.always[id] or (unittype == 'rare' or unittype == 'rareelite')) and UnitIsVisible(unit) then
		-- from this point on, it's a rare
		local zone, x, y = core:GetPlayerLocation()
		if not zone then return end -- there are only a few places where this will happen

		local name = UnitName(unit)
		local level = (UnitLevel(unit) or -1)
		local creature_type = UnitCreatureType(unit)

		local newloc = core:SaveMob(id, name, zone, x, y, level, unittype=='rareelite', creature_type)

		core:NotifyMob(id, name, zone, x, y, UnitIsDead(unit), newloc, source or 'target', unit)
		return true
	end
end
