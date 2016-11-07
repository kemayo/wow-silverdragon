local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
if not HandyNotes then return end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("HandyNotes", "AceEvent-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-1.0")

local db
-- local icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01"
local icon, icon_mount

local nodes = {}
module.nodes = nodes

local handler = {}
do
	local currentLevel, currentZone
	local function should_show_mob(id)
		local _, questid = core:GetMobInfo(id)
		if questid then
			return module.db.profile.questcomplete or not IsQuestFlaggedCompleted(questid)
		end
		local mod_tooltip = core:GetModule("Tooltip", true)
		if mod_tooltip then
			local achievement, achievement_name, completed = mod_tooltip:AchievementMobStatus(id)
			if achievement then
				return not completed or module.db.profile.achieved
			end
		end
		return module.db.profile.achievementless
	end
	local function icon_for_mob(id)
		if not icon then
			local texture, _, _, left, right, top, bottom = GetAtlasInfo("DungeonSkull")
			icon = {
				icon = texture,
				tCoordLeft = left,
				tCoordRight = right,
				tCoordTop = top,
				tCoordBottom = bottom,
				r = 1,
				g = 0.33,
				b = 0.33,
				a = 0.9,
			}
			local texture, _, _, left, right, top, bottom = GetAtlasInfo("VignetteKillElite")
			icon_mount = {
				icon = texture,
				tCoordLeft = left,
				tCoordRight = right,
				tCoordTop = top,
				tCoordBottom = bottom,
			}
		end
		local mod_announce = core:GetModule("Announce", true)
		if not mod_announce then
			return icon
		end
		return mod_announce:HasMount(id) and icon_mount or icon
	end
	local function iter(t, prestate)
		if not t then return nil end
		local state, value = next(t, prestate)
		while state do
			-- Debug("HandyNotes node", state, value, should_show_mob(value))
			if value then
				if should_show_mob(value) then
					return state, nil, icon_for_mob(value), db.icon_scale, db.icon_alpha
				end
			end
			state, value = next(t, state)
		end
		return nil, nil, nil, nil, nil
	end
	function handler:GetNodes(mapFile, minimap, level)
		-- Debug("HandyNotes GetNodes", mapFile, HBD:GetMapIDFromFile(mapFile), nodes[mapFile])
		currentZone = mapFile
		currentLevel = level
		return iter, nodes[mapFile], nil
	end
end

function handler:OnEnter(mapFile, coord)
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if self:GetCenter() > UIParent:GetCenter() then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end
	local zoneid = HBD:GetMapIDFromFile(mapFile)
	local id, name, questid, _, _, lastseen = core:GetMobByCoord(zoneid, coord)
	if not name then
		tooltip:AddLine(UNKNOWN)
		return tooltip:Show()
	end
	tooltip:AddLine(name)
	if core.mobdb[id].note then
		tooltip:AddDoubleLine("Note", core.mobdb[id].note)
	end

	tooltip:AddDoubleLine("Last seen", core:FormatLastSeen(lastseen))
	tooltip:AddDoubleLine("ID", id)

	local mod_tooltip = core:GetModule("Tooltip", true)
	if mod_tooltip then
		local achievement, achievement_name, completed = mod_tooltip:AchievementMobStatus(id)
		if achievement then
			tooltip:AddDoubleLine(achievement_name, completed and ACTION_PARTY_KILL or NEED,
				1, 1, 0,
				completed and 0 or 1, completed and 1 or 0, 0
			)
		end
	end
	if questid then
		local completed = IsQuestFlaggedCompleted(questid)
		tooltip:AddDoubleLine(
			QUESTS_COLON,
			completed and COMPLETE or INCOMPLETE,
			1, 1, 0,
			completed and 0 or 1, completed and 1 or 0, 0
		)
	end
	tooltip:Show()
end

function handler:OnLeave(mapFile, coord)
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

local clicked_zone, clicked_coord
local info = {}

local function deleteWholeMob(button, mapFile, coord)
	local zoneid = HBD:GetMapIDFromFile(mapFile)
	local id = core:GetMobByCoord(zoneid, coord)
	if id then
		core:DeleteMob(id)
		module:UpdateNodes()
		module:SendMessage("HandyNotes_NotifyUpdate", "SilverDragon")
	end
end

local function createWaypoint(button, mapFile, coord)
	if TomTom then
		local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
		local x, y = HandyNotes:getXY(coord)
		local id, name = core:GetMobByCoord(mapId, coord)
		TomTom:AddMFWaypoint(mapId, nil, x, y, {
			title = name,
			persistent = nil,
			minimap = true,
			world = true
		})
	end
end

local function generateMenu(button, level)
	if (not level) then return end
	table.wipe(info)
	if (level == 1) then
		-- Create the title of the menu
		info.isTitle      = 1
		info.text         = "HandyNotes - SilverDragon"
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)

		if TomTom then
			-- Waypoint menu item
			info.disabled     = nil
			info.isTitle      = nil
			info.notCheckable = nil
			info.text = "Create waypoint"
			info.icon = nil
			info.func = createWaypoint
			info.arg1 = clicked_zone
			info.arg2 = clicked_coord
			UIDropDownMenu_AddButton(info, level);
		end

		-- Delete menu item
		info.disabled     = nil
		info.isTitle      = nil
		info.notCheckable = nil
		info.text = "Hide mob"
		info.icon = icon
		info.func = deleteWholeMob
		info.arg1 = clicked_zone
		info.arg2 = clicked_coord
		UIDropDownMenu_AddButton(info, level);

		-- Close menu item
		info.text         = "Close"
		info.icon         = nil
		info.func         = function() CloseDropDownMenus() end
		info.arg1         = nil
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level);
	end
end

local dropdown = CreateFrame("Frame")
dropdown.displayMode = "MENU"
dropdown.initialize = generateMenu
function handler:OnClick(button, down, mapFile, coord)
	if button == "RightButton" and not down then
		clicked_zone = mapFile
		clicked_coord = coord
		ToggleDropDownMenu(1, nil, dropdown, self, 0, 0)
	end
end

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("HandyNotes", {
		profile = {
			icon_scale = 1.0,
			icon_alpha = 1.0,
			achieved = true,
			questcomplete = false,
			achievementless = true,
		},
	})
	db = self.db.profile

	local options = {
		type = "group",
		name = "SilverDragon",
		desc = "Where the rares are",
		get = function(info) return db[info.arg] end,
		set = function(info, v)
			db[info.arg] = v
			module:SendMessage("HandyNotes_NotifyUpdate", "SilverDragon")
		end,
		args = {
			desc = {
				name = "These settings control the look and feel of the icon.",
				type = "description",
				order = 0,
			},
			achieved = {
				type = "toggle",
				name = "Show achieved",
				desc = "Whether to show icons for mobs you have already killed (tested by whether you've got their achievement progress)",
				arg = "achieved",
				order = 10,
			},
			questcomplete = {
				type = "toggle",
				name = "Show quest-complete",
				desc = "Whether to show icons for mobs you have the tracking quest complete for (which probably means they won't drop anything)",
				arg = "questcomplete",
				order = 15,
			},
			achievementless = {
				type = "toggle",
				name = "Show non-achievement mobs",
				desc = "Whether to show icons for mobs which aren't part of the criteria for any known achievement",
				arg = "achievementless",
				order = 20,
			},
			icon_scale = {
				type = "range",
				name = "Icon Scale",
				desc = "The scale of the icons",
				min = 0.25, max = 2, step = 0.01,
				arg = "icon_scale",
				order = 25,
			},
			icon_alpha = {
				type = "range",
				name = "Icon Alpha",
				desc = "The alpha transparency of the icons",
				min = 0, max = 1, step = 0.01,
				arg = "icon_alpha",
				order = 30,
			},
		},
	}

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.addons.plugins.handynotes = {
			handynotes = {
				type = "group",
				name = "HandyNotes",
				get = options.get,
				set = options.set,
				args = options.args,
			},
		}
	end

	HandyNotes:RegisterPluginDB("SilverDragon", handler, options)

	self:RegisterEvent("LOOT_CLOSED")
end

function module:OnEnable()
	self:UpdateNodes()
end

function module:UpdateNodes()
	wipe(nodes)
	for zone, mobs in pairs(core.mobsByZone) do
		local mapFile = HBD:GetMapFileFromID(zone)
		Debug("UpdateNodes", zone, mapFile)
		if mapFile then
			nodes[mapFile] = {}
			for id, locs in pairs(mobs) do
				for _, loc in ipairs(locs) do
					nodes[mapFile][loc] = id
				end
			end
		else
			Debug("No mapfile for zone!", zone)
		end
	end
	self.nodes = nodes
	self:SendMessage("HandyNotes_NotifyUpdate", "SilverDragon")
end


function module:LOOT_CLOSED()
	self:SendMessage("HandyNotes_NotifyUpdate", "SilverDragon")
end
