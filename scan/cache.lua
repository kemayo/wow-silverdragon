local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Cache", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local globaldb
function module:OnInitialize()
	globaldb = core.db.global
end

function module:OnEnable()
	core.RegisterCallback(self, "Scan")
	core.RegisterCallback(self, "ZoneChanged")
end

local already_cached = {}
local already_notified = {}
local first_cachescan = true
local cache_tooltip = CreateFrame("GameTooltip", "SDCacheTooltip")
cache_tooltip:AddFontStrings(
	cache_tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
	cache_tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText")
)

local function is_cached(id)
	-- this doesn't work with just clearlines and the setowner outside of this, and I'm not sure why
	cache_tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	cache_tooltip:SetHyperlink(("unit:0xF53%05X00000000"):format(id))
	if cache_tooltip:IsShown() then
		local name = SDCacheTooltipTextLeft1:GetText()
		globaldb.mob_id[name] = id
		globaldb.mob_name[id] = name
		return true
	end
end
module.already_cached = already_cached

function module:ZoneChanged(callback, zone)
	first_cachescan = true
end

function module:Scan(callback, zone)
	if not core.db.profile.cache then
		return
	end
	self:ScanMobsInTable(globaldb.mobs_byzoneid[zone])
	self:ScanMobsInTable(globaldb.always)
	first_cachescan = false
end

function module:ScanMobsInTable(mobs)
	if not mobs then
		return
	end
	for id in pairs(mobs) do
		if not already_cached[id] and is_cached(id) then
			already_cached[id] = true
			self:NotifyIfNeeded(id)
		end
	end
end

function module:NotifyIfNeeded(id)
	if first_cachescan then
		already_notified[id] = true
	end
	if already_notified[id] then
		return
	end
	if not already_cached[id] then
		return
	end
	if globaldb.mob_tameable[id] and not core.db.profile.cache_tameable then
		return
	end
	already_notified[id] = true
	local current_zone, x, y = core:GetPlayerLocation()
	local newloc = false
	if not globaldb.mob_tameable[id] then
		--Pull some info from global database since it's not sent from syncs, and we don't want
		-- to erase that info with savemob function just copy it over.
		local creature_type = globaldb.mob_type[id]
		local elite = globaldb.mob_elite[id]
		local level = globaldb.mob_level[id]
		local name = globaldb.mob_name[id]
		newloc = core:SaveMob(id, name, current_zone, x, y, level, elite, creature_type)
	end
	core:NotifyMob(id, globaldb.mob_name[id], current_zone, x, y, false, newloc, "cache", false)
end

core.RegisterCallback(module, "Import", function()
	if not first_cachescan then
		table.wipe(already_cached)
		first_cachescan = true
	end
end)

module:RegisterChatCommand("sdcached", function()
	local lookup = {}
	for mob, id in pairs(globaldb.mob_id) do
		lookup[id] = mob
	end
	local output
	module:Print("The following mobs are in the NPC cache, and so will not be detected by the cache scanner:")
	for id,_ in pairs(already_cached) do
		module:Print(" ", lookup[id])
		output = true
	end
	if not output then
		module:Print("Nothing")
	end
end)
