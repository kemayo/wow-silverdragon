local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Cache", "AceEvent-3.0", "AceConsole-3.0")

local globaldb
function module:OnInitialize()
	globaldb = core.db.global
	core.RegisterCallback(self, "Scan")
end

local already_cached = {}
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
	return cache_tooltip:IsShown()
end
module.already_cached = already_cached

function module:Scan(callback, zone)
	if first_cachescan then
		for mob, id in pairs(globaldb.mob_id) do
			if is_cached(id) then
				already_cached[id] = true
			end
		end
		first_cachescan = false
		return
	end
	-- Debug("Scanning Cache", zone, globaldb.mobs_byzone[zone])
	
	local zone_mobs = globaldb.mobs_byzone[zone]
	if not zone_mobs then return end
	for mob, lastseen in pairs(zone_mobs) do
		local id = globaldb.mob_id[mob]
		-- Debug("Checking for", id, mob, lastseen)
		if id and (not globaldb.mob_tameable[mob] or core.db.profile.cache_tameable) and not already_cached[id] and is_cached(id) then
			-- Debug("They're new!")
			already_cached[id] = true
			local current_zone, x, y = core:GetPlayerLocation()
			core:NotifyMob(current_zone, mob, x, y, false, false, "cache", false)
		end
	end
	first_cachescan = false
end
core.RegisterCallback(module, "Import", function()
	if first_cachescan then
		table.wipe(already_cached)
		first_cachescan = true
	end
end)

module:RegisterChatCommand("sdcached", function()
	local lookup = {}
	for mob,id in pairs(globaldb.mob_id) do
		lookup[id] = mob
	end
	local output
	self:Print("The following mobs are in the NPC cache, and so will not be detected by the cache scanner.")
	for id,_ in pairs(already_cached) do
		self:Print(" ", lookup[id])
		output = true
	end
	if not output then
		self:Print("Nothing")
	end
end)
