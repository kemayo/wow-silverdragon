local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Minimap", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug
local DebugF = core.DebugF

local HBD = LibStub("HereBeDragons-2.0")

local MinimapPosition

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Minimap", {
		profile = {
			enabled = false,
			-- vignette = false,
			interval = 0.5,
		},
	})
	self:RegisterEvent("MINIMAP_UPDATE_TRACKING", "Update")
	HBD.RegisterCallback(self, "PlayerZoneChanged", "Update")
	core.RegisterCallback(self, "Scan")
	core.RegisterCallback(self, "Seen", "Update")
	core.RegisterCallback(self, "Ready", "Update")
	core.RegisterCallback(self, "IgnoreChanged", "Update")
	core.RegisterCallback(self, "CustomChanged", "Update")

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.scanning.plugins.minimap = {
			minimap = {
				type = "group",
				name = "Minimap tracking",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v)
					self.db.profile[info[#info]] = v
					self:Update(true)
				end,
				disabled = function() return not self:IsAPIAvailable() end,
				args = {
					about = config.desc("Scan for rares by trying to get data from minimap tracking spells",
							0),
					enabled = config.toggle("Enabled",
						"Scan by looking at minimap tracking data",
						10),
					-- vignette = config.toggle("Include mobs with vignettes",
					-- 	"Include mobs with known vignettes in the scan. Filtering them out will reduce the odds of seeing errors when in modern zones. (But the data about which mobs have vignettes is imperfect.)",
					-- 	15),
					interval = {
						type = "range",
						name = "Scan interval",
						desc = "How long to spend scanning the minimap before taking a break and moving on",
						min = 0, max = 1, step = 0.1,
						order = 30,
					},
				},
				order = 99,
			},
		}
	end

	self:Update()
end

-- We divide the minimap up into "cells", each of which is about the size of
-- the tracking dots targeting area. The dots themselves are maybe 8, but
-- there's significant padding around them that triggers the tooltip.
local CELLSIZE = 14
local function IndexToCellCenter(index, width, height)
	if not index then return end
	local columns = math.ceil(width / CELLSIZE)
	local rows = math.ceil(height / CELLSIZE)
	if index < 1 or index > columns * rows then
		return nil
	end
	local i = index - 1
	local col = i % columns
	local row = math.floor(i / columns)
	return (col + 0.5) * CELLSIZE, (row + 0.5) * CELLSIZE
end


local mobs = {}
local index = nil
local timelimit = 0
local function ProgressScan()
	if not (index and next(mobs)) then return end
	if InCombatLockdown() or not Minimap:IsVisible() or not Minimap:GetLeft() then
		-- Minimap data's not available
		return
	end
	Minimap:SetUsingSoftCursor(true)

	local stoptime = debugprofilestop() + timelimit

	local retOK, err = pcall(function()
		local width, height = Minimap:GetSize()
		local left, bottom = Minimap:GetLeft(), Minimap:GetBottom()
		local scale = Minimap:GetEffectiveScale()
		-- Debug("Running scan", debugprofilestop(), stoptime, debugprofilestop() < stoptime)
		repeat
			local x, y = IndexToCellCenter(index, width, height)
			-- Debug("Considering point", index, x, y)
			if not x then
				index = nil
				break
			end
			-- arg seems to be absolute screen coords, not minimap offsets
			-- Debug("UpdateMouseoverAtPoint", (left + x) * scale, (bottom + y) * scale)
			Minimap:UpdateMouseoverAtPoint((left + x) * scale, (bottom + y) * scale)

			-- Tragically, this won't have triggered the TooltipDataProcessor postCall, and so...
			local data = C_TooltipInfo.GetMinimapMouseover()

			Debug("data", data and data.lines and data.lines[1] and data.lines[1].leftText)
			if data and not issecretvalue(data) and data.type == Enum.TooltipDataType.MinimapMouseover and data.lines and data.lines[1] then
				-- I haven't yet seen one that's *not* a single line with
				-- that line's leftText containing \n separated lines of
				-- all the node data, but just in case I'm going to loop over them
				for _, line in ipairs(data.lines) do
					if line.leftText and not issecretvalue(line.leftText) and line.leftText ~= "" then
						for actualLine in line.leftText:gmatch("([^\n]+)") do
							-- There's arrows for above/below tracking that need to be stripped, which are encoded with |T escapes
							actualLine = string.trim(C_StringUtil.StripHyperlinks(actualLine))
							Debug("Considering line", actualLine, mobs[actualLine])
							if mobs[actualLine] then
								local uiMapID, mapX, mapY = MinimapPosition(x / width - 0.5, y / height - 0.5)
								-- id, zone, x, y, is_dead, source, unit, silent, force, GUID
								core:NotifyForMob(mobs[actualLine], uiMapID, mapX, mapY, nil, "minimap", false)
							end
						end
					end
				end
			end
			index = index + 1
		until debugprofilestop() >= stoptime
	end)

	Minimap:SetUsingSoftCursor(false)

	if not retOK then
		Debug("Minimap scan failed", tostring(err))
		index = nil
	end
end

function module:Scan()
	-- Debug("Minimap scan", index)
	index = index or 1
end

function module:IsAPIAvailable()
	if (C_Minimap and C_Minimap.GetNumTrackingTypes and C_Minimap.GetTrackingInfo and C_TooltipInfo and C_TooltipInfo.GetMinimapMouseover and Minimap and Minimap.SetUsingSoftCursor) then
		return true
	end
end

function module:Update(force)
	if not self:IsAPIAvailable() then
		-- APIs we need are not present
		return
	end
	if (not self.db.profile.enabled) or (not core.db.profile.instances and IsInInstance()) then
		if self.timer then self.timer:Cancel() end
		self.timer = nil
		return
	end
	if force and self.timer then
		self.timer:Cancel()
		self.timer = nil
	end

	if not self:HasTracking() then
		return Debug("No valid tracking spell active")
	end

	wipe(mobs)
	index = 1
	local zone = HBD:GetPlayerZone()
	-- Mobs from data, and custom mobs specific to the zone
	local count = 0
	for id in core:IterateRelevantMobs(zone, true) do
		if
			(module.db.profile.vignette or not core:MobHasVignette(id)) and
			-- filter out ones we wouldn't notify for anyway
			core:WouldNotifyForMob(id, zone) and
			not core:ShouldIgnoreMob(id, zone) and
			core:IsMobInPhase(id, zone)
		then
			local name = core:NameForMob(id)
			if name then
				mobs[name] = id
				count = count + 1
			end
		end
	end

	if count > 0 then
		timelimit = 1000 * (self.db.profile.interval / count)
	end

	DebugF("Minimap: update to %d mobs, %d limit", count, timelimit)

	if not self.timer then
		self.timer = C_Timer.NewTicker(self.db.profile.interval, ProgressScan)
	end
end

do
	local trackingSpells = {
		-- Hunter
		[1494] = true, -- Track Beasts
		[19878] = true, -- Track Demons
		[19879] = true, -- Track Dragonkin
		[19880] = true, -- Track Elementals
		[19882] = true, -- Track Giants
		[19883] = true, -- Track Humanoids
		[19884] = true, -- Track Undead
		[19885] = true, -- Track Hidden
		-- Druid
		[5225] = true, -- Track Humanoids
		-- Dwarf
		-- [2481] = true, -- Find Treasure
		-- Profession
		-- [2383] = true, -- Find Herbs
		-- [2580] = true, -- Find Minerals
	}
	function module:HasTracking()
		for i=1, C_Minimap.GetNumTrackingTypes() do
			local info = C_Minimap.GetTrackingInfo(i)
			if info.active and trackingSpells[info.spellID or -1] then
				return true
			end
		end
	end
end

-- (I wrote this for QuestsChanged and am reusing it here wholesale)
do
	-- The classic fallbacks here are from HereBeDragons:
	local GetViewRadius, GetZoneSize
	if C_Minimap and C_Minimap.GetViewRadius then
		GetViewRadius = function() return C_Minimap.GetViewRadius() end
	else
		-- classic / mists
		local f = CreateFrame("FRAME")
		local indoors
		f:SetScript("OnEvent", function(self, event, ...)
			local zoom = Minimap:GetZoom()
			if GetCVar("minimapZoom") == GetCVar("minimapInsideZoom") then
				Minimap:SetZoom(zoom < 2 and zoom + 1 or zoom - 1)
			end
			indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
			Minimap:SetZoom(zoom)
		end)
		f:RegisterEvent("MINIMAP_UPDATE_ZOOM")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")

		local minimap_size = {
			indoor = {
				[0] = 300, -- scale
				[1] = 240, -- 1.25
				[2] = 180, -- 5/3
				[3] = 120, -- 2.5
				[4] = 80,  -- 3.75
				[5] = 50,  -- 6
			},
			outdoor = {
				[0] = 466 + 2/3, -- scale
				[1] = 400,       -- 7/6
				[2] = 333 + 1/3, -- 1.4
				[3] = 266 + 2/6, -- 1.75
				[4] = 200,       -- 7/3
				[5] = 133 + 1/3, -- 3.5
			},
		}
		GetViewRadius = function()
			local zoom = Minimap:GetZoom()
			return minimap_size[indoors][zoom] / 2
		end
	end
	if C_Map and C_Map.GetMapWorldSize then
		GetZoneSize = function(uiMapID) return C_Map.GetMapWorldSize(uiMapID) end
	else
		-- classic and mists again
		local vector00, vector05 = CreateVector2D(0, 0), CreateVector2D(0.5, 0.5)
		GetZoneSize = function(uiMapID)
			local instance, center = C_Map.GetWorldPosFromMapPos(uiMapID, vector05)
			local width, height

			local _, topleft = C_Map.GetWorldPosFromMapPos(uiMapID, vector00)
			if center and topleft then
				local top, left = topleft:GetXY()
				local bottom, right = center:GetXY()
				width = (left - right) * 2
				height = (top - bottom) * 2
			end

			return width, height
		end
	end

	function MinimapPosition(x, y)
		-- x and y are offsets from the center of the minimap at its current
		-- zoom level, between -0.5 and 0.5. They're this because that's what
		-- the arguments to MINIMAP_PING are.
		local mapRadius = GetViewRadius()
		local uiMapID = C_Map.GetBestMapForUnit('player')
		if not uiMapID then return end
		local position = C_Map.GetPlayerMapPosition(uiMapID, 'player')
		if not position then return end
		local px, py = position:GetXY()
		if not (px and py) then return end
		local zoneWidth, zoneHeight = GetZoneSize(uiMapID)
		if not zoneWidth and zoneHeight then return end
		-- Now we work out the yard-offset for the minimap
		local minimapWidth = mapRadius / zoneWidth
		local minimapHeight = mapRadius / zoneHeight
		return uiMapID, px + (2 * x * minimapWidth), py - (2 * y * minimapHeight)
	end
end
