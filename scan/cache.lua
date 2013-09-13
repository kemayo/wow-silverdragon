local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_Cache", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local globaldb
function module:OnInitialize()
	globaldb = core.db.global

	self.db = core.db:RegisterNamespace("Scan_Cache", {
		profile = {
			enabled = true,
			tameable = false,
			location = false,
			always_achievement = true,
		},
	})

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.scanning.plugins.cache = {
			cache = {
				type = "group",
				name = "Cache",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					enabled = config.toggle("Enabled", "Scan the mob cache for never-before-found mobs.", 10),
					tameable = config.toggle("Special treatment for hunter pets", "Tameable mobs can show up absolutely anywhere, and we can't tell whether they're owned by a hunter or not. Checking this will perform extra scanning to look for hunter pets being added to the cache outside of their normal zones, so we can avoid notifying you of them when we later enter the correct zone. Unchecking this means we use appreciably less CPU.", 20),
					location = config.toggle("Record location on cache hit", "Record the mob's location when the cache triggers for it. If this isn't set, it'll wait until you target it and are within interaction range to store the location.", 30),
					always_achievement = config.toggle("Always look for achievement mobs", "Without running an import, we can look for achievement mobs always... but we don't know what zone they're in, so we have to look a bit inefficiently.", 40),
				},
			},
		}
	end
end

function module:OnEnable()
	core.RegisterCallback(self, "Scan")
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
module.is_cached = is_cached
module.already_cached = already_cached

function module:Scan(callback, zone)
	if not self.db.profile.enabled then
		return
	end
	if self.db.profile.tameable then
		-- We are scanning all tameable mobs because if we see one outside its own zone, we don't want
		-- to suddenly notice it's cached the instant we step into its zone. This *does* increase CPU
		-- usage somewhat, thus the tradeoff of only doing it when we're trying to suppress tameables.
		self:ScanMobsInTable(globaldb.mob_tameable, zone)
	end
	self:ScanMobsInTable(first_cachescan and globaldb.mob_name or globaldb.mobs_byzoneid[zone], zone)
	if self.db.profile.always_achievement then
		local tooltip = core:GetModule("Tooltip", true)
		if tooltip then
			self:ScanMobsInTable(tooltip.mobs_to_achievement)
		end
	end
	self:ScanMobsInTable(globaldb.always, zone)
	first_cachescan = false
end

function module:ScanMobsInTable(mobs, zone)
	if not mobs then
		return
	end
	for id in pairs(mobs) do
		if not already_cached[id] and is_cached(id) then
			already_cached[id] = true
			self:NotifyIfNeeded(id, zone)
		end
	end
end

-- Work out whether a mob is completely skippable, as in "suppress future notifications for this"
-- This basically means "is this a mob we know is tameable and know is from another zone?"
function module:IsBypassableMob(id, zone)
	if first_cachescan then
		return true
	end
	if not self.db.profile.tameable then
		return
	end
	if not globaldb.mob_tameable[id] then
		-- first, all non-tamable mobs are fine
		return
	end
	if globaldb.mobs_byzoneid[zone][id] then
		-- if the mob is *supposed* to be in this zone, it's fine
		-- (still some false-positives here, but...)
		return
	end
	return true
end

function module:NotifyIfNeeded(id, zone)
	if already_notified[id] then
		Debug("Skipping notify", "already done")
		return
	end
	if not already_cached[id] then
		Debug("Skipping notify", "not seen")
		return
	end
	if self:IsBypassableMob(id, zone) then
		Debug("Skipping notify", "bypassable")
		already_notified[id] = true
		return
	end
	already_notified[id] = true
	local current_zone, x, y = core:GetPlayerLocation()
	local newloc = false
	if self.db.profile.location and not globaldb.mob_tameable[id] then
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
	first_cachescan = true
end)

module:RegisterChatCommand("sdcached", function()
	local output
	module:Print("The following mobs are in the NPC cache, and so will not be detected by the cache scanner:")
	for id, name in pairs(globaldb.mob_name) do
		if is_cached(id) then
			module:Print(" ", name)
			output = true
		end
	end
	if not output then
		module:Print("Nothing")
	end
end)
