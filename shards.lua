local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Shards", "AceConsole-3.0", "AceEvent-3.0")
local Debug = core.Debug

function module:OnEnable()
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	if C_EventUtils.IsEventValid("VIGNETTE_MINIMAP_UPDATED") then
		-- this needs to run in Classic, which doesn't have these
		self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
		self:RegisterEvent("VIGNETTES_UPDATED")
	end
	-- todo: combat log as well?

	-- Can't know it until we see an event
	self.currentShard = "unknown"
end

function module:PLAYER_TARGET_CHANGED()
	self:TrackCurrentShard(UnitGUID("target"))
end
function module:UPDATE_MOUSEOVER_UNIT()
	self:TrackCurrentShard(UnitGUID("mouseover"))
end
function module:NAME_PLATE_UNIT_ADDED(event, unit)
	self:TrackCurrentShard(UnitGUID(unit))
end
function module:VIGNETTE_MINIMAP_UPDATED(event, guid)
	self:TrackCurrentShard(guid)
end
function module:VIGNETTES_UPDATED()
	local vignetteids = C_VignetteInfo.GetVignettes()
	for i=1, #vignetteids do
		self:TrackCurrentShard(vignetteids[i])
	end
end

function module:TrackCurrentShard(guid)
	if not guid then return end
	local shard = core:GUIDShard(guid)
	if shard and self.currentShard ~= shard then
		local lastShard = self.currentShard
		self.currentShard = shard
		Debug("ShardChanged", self.currentShard, lastShard, guid)
		core.events:Fire("ShardChanged", self.currentShard, lastShard, guid)
		return true
	end
end

function module:GetCurrentShard()
	return self.currentShard
end
