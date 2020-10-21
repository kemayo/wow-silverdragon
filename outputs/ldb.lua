local myname, ns = ...

local icon = LibStub("LibDBIcon-1.0", true)

local LibQTip = LibStub("LibQTip-1.0")
local HBD = LibStub("HereBeDragons-2.0")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("LDB", "AceEvent-3.0")

local dataobject, tooltip, db
local rares_seen = {}

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("LDB", {
		profile = {
			minimap = {},
			worldmap = true,
			mounts = true,
			tooltip = "always",
		},
	})
	db = self.db

	self:SetupDataObject()
	self:SetupWorldMap()

	if IsAddOnLoaded("Blizzard_Collections") then
		self:SetupMounts()
	else
		self:RegisterEvent("ADDON_LOADED")
	end

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.broker = {
			broker = {
				type = "group",
				name = "Icon",
				order = 91,
				args = {
					show_lastseen = {
						type = "toggle",
						name = "Show last seen rare",
						desc = "Toggle showing or hiding the last seen rare as the dataobject's text",
						get = function() return db.profile.show_lastseen end,
						set = function(info, v)
							db.profile.show_lastseen = v
							if v then
								if module.last_seen then
									dataobject.text = core:GetMobLabel(module.last_seen)
								else
									dataobject.text = "None"
								end
							else
								dataobject.text = ""
							end
						end,
						order = 10,
						width = "full",
						descStyle = "inline",
					},
					minimap = {
						type = "toggle",
						name = "Show minimap icon",
						desc = "Toggle showing or hiding the minimap icon.",
						get = function() return not db.profile.minimap.hide end,
						set = function(info, v)
							local hide = not v
							db.profile.minimap.hide = hide
							if hide then
								icon:Hide("SilverDragon")
							else
								icon:Show("SilverDragon")
							end
						end,
						order = 30,
						width = "full",
						descStyle = "inline",
						hidden = function() return not icon or not dataobject or not icon:IsRegistered("SilverDragon") end,
					},
					tooltip = {
						type = "select",
						name = "Show tooltip",
						values = {
							always = "Always",
							outofcombat = "Out of Combat",
							never = "Never",
						},
						get = function() return db.profile.tooltip end,
						set = function(info, v)
							db.profile.tooltip = v
						end,
						order = 35,
					},
					worldmap = {
						type = "toggle",
						name = "Show on the world map",
						desc = "Toggle showing the icon in the world map's header",
						get = function() return db.profile.worldmap end,
						set = function(info, v)
							db.profile.worldmap = v
							module.worldmap[v and "Show" or "Hide"](module.worldmap)
						end,
						order = 40,
						width = "full",
						descStyle = "inline",
					},
					mounts = {
						type = "toggle",
						name = "Show on the mount list",
						desc = "Toggle showing the icon in the map list",
						get = function() return db.profile.mounts end,
						set = function(info, v)
							db.profile.mounts = v
							if module.mounts then
								module.mounts[v and "Show" or "Hide"](module.mounts)
							end
						end,
						order = 40,
						width = "full",
						descStyle = "inline",
					},
				},
			},
		}
	end
end

function module:ADDON_LOADED(event, addon)
	if addon ~= "Blizzard_Collections" then
		return
	end
	self:SetupMounts()
	self:UnregisterEvent("ADDON_LOADED")
end

function module:SetupDataObject()
	dataobject = LibStub("LibDataBroker-1.1"):NewDataObject("SilverDragon", {
		type = "data source",
		icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01",
		label = "Rares",
		text = "",
	})

	local tooltip_options = {
		nearby = true,
		recent = true,
		help = true,
	}
	function dataobject:OnEnter()
		if (not tooltip or not tooltip:IsShown()) then
			if module.db.profile.tooltip == "never" then return end
			if module.db.profile.tooltip == "outofcombat" and InCombatLockdown() then return end
			tooltip_options.nearby = HBD:GetPlayerZone()
			module:ShowTooltip(self, tooltip_options)
		end
	end

	function dataobject:OnLeave()
		-- we rely on libqtip's autohide
	end

	function dataobject:OnClick(button)
		if button ~= "RightButton" then
			return
		end
		if IsShiftKeyDown() then
			core:ShowDebugWindow()
		else
			local config = core:GetModule("Config", true)
			if config then
				config:ShowConfig()
			end
		end
	end

	core.RegisterCallback("LDB", "Seen", function(callback, id, zone, x, y, dead, source)
		module.last_seen = id
		if db.profile.show_lastseen then
			dataobject.text = core:GetMobLabel(id)
		end
		table.insert(rares_seen, {
			id = id,
			zone = zone,
			x = x,
			y = y,
			source = source,
			when = time(),
		})
	end)

	if icon then
		icon:Register("SilverDragon", dataobject, self.db.profile.minimap)
	end
	if db.profile.show_lastseen then
		dataobject.text = "None"
	end
end

function module:SetupWorldMap()
	local button_options = {
		help = true,
	}
	local button = CreateFrame("Button", nil, WorldMapFrame.NavBar)
	button:SetSize(20, 20)
	button:SetPoint("RIGHT", -4, 0)
	button:RegisterForClicks("AnyUp")
	button.texture = button:CreateTexture(nil, "ARTWORK")
	button.texture:SetTexture("Interface\\Icons\\INV_Misc_Head_Dragon_01")
	button.texture:SetAllPoints()
	button:SetScript("OnEnter", function()
		button_options.nearby = WorldMapFrame.mapID
		module:ShowTooltip(button, button_options)
	end)
	-- onleave is handled by the tooltip's autohide
	button:SetScript("OnClick", dataobject.OnClick)
	module.worldmap = button
	if not db.profile.worldmap then
		button:Hide()
	end
end

function module:SetupMounts()
	local list = {}
	for source, data in pairs(core.datasources) do
		if core.db.global.datasources[source] then
			for id, mobdata in pairs(data) do
				if mobdata.mount and not core:ShouldIgnoreMob(id) then
					table.insert(list, id)
				end
			end
		end
	end
	local button_options = {
		custom = list,
		help = true,
	}
	local button = CreateFrame("Button", nil, MountJournal.MountCount)
	button:SetSize(20, 20)
	button:SetPoint("LEFT", MountJournal.MountCount, "RIGHT", 4, 0)
	button:RegisterForClicks("AnyUp")
	button.texture = button:CreateTexture(nil, "ARTWORK")
	button.texture:SetTexture("Interface\\Icons\\INV_Misc_Head_Dragon_01")
	button.texture:SetAllPoints()
	button:SetScript("OnEnter", function()
		module:ShowTooltip(button, button_options)
	end)
	-- onleave is handled by the tooltip's autohide
	button:SetScript("OnClick", dataobject.OnClick)
	module.mounts = button
	if not db.profile.mounts then
		button:Hide()
	end
end

do
	local CompletableCellProvider, CompletableCellPrototype = LibQTip:CreateCellProvider()
	function CompletableCellPrototype:InitializeCell()
		if not self.texture then
			self.texture = self:CreateTexture(nil, 'ARTWORK')
			self.texture:SetSize(20, 18)
			self.texture:SetPoint("CENTER", self)
			self.texture:Show()
		end
		if not self.completionTexture then
			self.completionTexture = self:CreateTexture(nil, "OVERLAY")
			self.completionTexture:SetAtlas("Tracker-Check", true)
			self.completionTexture:SetPoint("CENTER", self)
			self.completionTexture:Hide()
		end
	end
	function CompletableCellPrototype:SetupCell(parent, value, justification, font, r, g, b, ...)
		self:SetupTexture(value)
		self:SetupCompletion(value)
		return self.texture:GetSize()
	end
	function CompletableCellPrototype:SetupCompletion(value)
		if value then
			self.completionTexture:Show()
		else
			self.completionTexture:Hide()
		end
	end
	function CompletableCellPrototype:ReleaseCell()
	end
	function CompletableCellPrototype:getContentHeight()
		return self.texture:GetHeight()
	end

	local AchievementCellProvider, AchievementCellPrototype = LibQTip:CreateCellProvider(CompletableCellProvider)
	function AchievementCellPrototype:SetupTexture()
		self.texture:SetAtlas("storyheader-cheevoicon")
	end
	local QuestCellProvider, QuestCellPrototype = LibQTip:CreateCellProvider(CompletableCellProvider)
	function QuestCellPrototype:SetupTexture()
		self.texture:SetAtlas("QuestNormal")
	end
	local MountCellProvider, MountCellPrototype = LibQTip:CreateCellProvider(CompletableCellProvider)
	function MountCellPrototype:SetupTexture()
		self.texture:SetAtlas("StableMaster")
	end
	function MountCellPrototype:SetupCompletion(value)
		local name, _, texture, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(value)
		return CompletableCellPrototype.SetupCompletion(self, isCollected)
	end
	local ToyCellProvider, ToyCellPrototype = LibQTip:CreateCellProvider(CompletableCellProvider)
	function ToyCellPrototype:SetupTexture()
		self.texture:SetAtlas("mechagon-projects")
	end
	function ToyCellPrototype:SetupCompletion(value)
		local isCollected = PlayerHasToy(value)
		return CompletableCellPrototype.SetupCompletion(self, isCollected)
	end
	local PetCellProvider, PetCellPrototype = LibQTip:CreateCellProvider(CompletableCellProvider)
	function PetCellPrototype:SetupTexture()
		self.texture:SetAtlas("WildBattlePetCapturable")
	end
	function PetCellPrototype:SetupCompletion(value)
		local isCollected = C_PetJournal.GetNumCollectedInfo(value) > 0
		return CompletableCellPrototype.SetupCompletion(self, isCollected)
	end

	local function show_loot_tooltip(cell, mobid, only)
		tooltip:SetFrameStrata("DIALOG")
		GameTooltip_SetDefaultAnchor(GameTooltip, cell)
		ns:UpdateTooltipWithLootDetails(GameTooltip, mobid, only)
		GameTooltip:Show()
	end
	local function show_mount_tooltip(cell, mobid) return show_loot_tooltip(cell, mobid, "mount") end
	local function show_toy_tooltip(cell, mobid) return show_loot_tooltip(cell, mobid, "toy") end
	local function show_pet_tooltip(cell, mobid) return show_loot_tooltip(cell, mobid, "pet") end
	local function show_achievement_tooltip(cell, mobid)
		local achievementid = ns:AchievementMobStatus(mobid)

		tooltip:SetFrameStrata("DIALOG")
		GameTooltip_SetDefaultAnchor(GameTooltip, cell)
		GameTooltip:SetHyperlink(GetAchievementLink(achievementid))
		GameTooltip:Show()
	end
	local function show_notes_tooltip(cell, mobid)
		tooltip:SetFrameStrata("DIALOG")
		GameTooltip_SetDefaultAnchor(GameTooltip, cell)
		-- GameTooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(mobid))
		GameTooltip:AddLine(ns.mobdb[mobid] and ns.mobdb[mobid].notes or UNKNOWN)
		GameTooltip:Show()
	end
	local function hide_subtooltip()
		tooltip:SetFrameStrata("TOOLTIP")
		GameTooltip:Hide()
	end

	local function mob_sorter(aid, bid)
		local aname = core:NameForMob(aid)
		local bname = core:NameForMob(bid)
		if not aname or not bname then
			return false
		end
		return tostring(aname):lower() < tostring(bname):lower()
	end

	local sorted_mobs = {}

	function module:ShowTooltip(parent, options)
		if not core.db then
			return
		end

		if not tooltip then
			tooltip = LibQTip:Acquire("SilverDragonTooltip", 9, "LEFT", "CENTER", "RIGHT", "CENTER", "RIGHT", "RIGHT", "RIGHT", "RIGHT", "RIGHT")
			tooltip:SetAutoHideDelay(0.25, parent)
			tooltip:SmartAnchorTo(parent)
			tooltip.OnRelease = function() tooltip = nil end
		end

		tooltip:Clear()
		wipe(sorted_mobs)

		local zone = options.nearby
		if zone and ns.mobsByZone[zone] then
			for id in pairs(ns.mobsByZone[zone]) do
				if core:IsMobInPhase(id, zone) and not core:ShouldIgnoreMob(id, zone) then
					table.insert(sorted_mobs, id)
				end
			end
			if options.recent then
				tooltip:AddHeader("Nearby")
			end
		end

		if options.custom then
			for _, id in ipairs(options.custom) do
				table.insert(sorted_mobs, id);
			end
		end

		if #sorted_mobs > 0 then
			tooltip:AddHeader("Name", "Count", "Last Seen")

			table.sort(sorted_mobs, mob_sorter)

			local notes = CreateAtlasMarkup("poi-workorders")

			for _, id in ipairs(sorted_mobs) do
				local name, questid, vignette, tameable, last_seen, times_seen = core:GetMobInfo(id)
				local label = core:GetMobLabel(id)
				local index, col = tooltip:AddLine(
					(ns.mobdb[id] and ns.mobdb[id].notes) and (label .. " " .. notes) or label,
					times_seen,
					core:FormatLastSeen(last_seen),
					(tameable and 'Tameable' or '')
				)
				if ns.mobdb[id] and ns.mobdb[id].notes then
					tooltip:SetCellScript(index, 1, "OnEnter", show_notes_tooltip, id)
					tooltip:SetCellScript(index, 1, "OnLeave", hide_subtooltip)
				end
				if ns.mobdb[id] and ns.mobdb[id].mount then
					index, col = tooltip:SetCell(index, col, ns.mobdb[id].mount, MountCellProvider)
					tooltip:SetCellScript(index, col - 1, "OnEnter", show_mount_tooltip, id)
					tooltip:SetCellScript(index, col - 1, "OnLeave", hide_subtooltip)
				else
					index, col = tooltip:SetCell(index, col, '')
				end
				if ns.mobdb[id] and ns.mobdb[id].toy then
					index, col = tooltip:SetCell(index, col, ns.mobdb[id].toy, ToyCellProvider)
					tooltip:SetCellScript(index, col -1, "OnEnter", show_toy_tooltip, id)
					tooltip:SetCellScript(index, col -1, "OnLeave", hide_subtooltip)
				else
					index, col = tooltip:SetCell(index, col, '')
				end
				if ns.mobdb[id] and ns.mobdb[id].pet then
					index, col = tooltip:SetCell(index, col, ns.mobdb[id].pet, PetCellProvider)
					tooltip:SetCellScript(index, col - 1, "OnEnter", show_pet_tooltip, id)
					tooltip:SetCellScript(index, col - 1, "OnLeave", hide_subtooltip)
				else
					index, col = tooltip:SetCell(index, col, '')
				end
				local quest, achievement = ns:CompletionStatus(id)
				if quest ~= nil or achievement ~= nil then
					if achievement ~= nil then
						index, col = tooltip:SetCell(index, col, achievement, AchievementCellProvider)
						tooltip:SetCellScript(index, col - 1, "OnEnter", show_achievement_tooltip, id)
						tooltip:SetCellScript(index, col - 1, "OnLeave", hide_subtooltip)
					else
						index, col = tooltip:SetCell(index, col, '')
					end
					if quest ~= nil then
						index, col = tooltip:SetCell(index, col, quest, QuestCellProvider)
					else
						index, col = tooltip:SetCell(index, col, '')
					end
					if quest or achievement then
						if (quest and achievement) or (quest == nil or achievement == nil) then
							-- full completion
							tooltip:SetLineColor(index, 0.33, 1, 0.33) -- green
						else
							-- partial completion
							tooltip:SetLineColor(index, 1, 1, 0.33) -- yellow
						end
					else
						tooltip:SetLineColor(index, 1, 0.33, 0.33) -- red
					end
				end
			end
			if #sorted_mobs == 0 then
				tooltip:AddLine(NONE)
			end
		elseif options.nearby then
			tooltip:AddLine(NONE)
		end

		if options.recent then
			if #rares_seen > 0 then
				if options.nearby then
					tooltip:AddHeader("Seen this session")
				end
				tooltip:AddHeader("Name", "Zone", "Coords", "When", "Source")
				for i,rare in ipairs(rares_seen) do
					tooltip:AddLine(
						core:GetMobLabel(rare.id) or core:NameForMob(rare.id) or UNKNOWN,
						core.zone_names[rare.zone] or UNKNOWN,
						(rare.x and rare.y) and (core.round(rare.x * 100, 1) .. ', ' .. core.round(rare.y * 100, 1)) or UNKNOWN,
						core:FormatLastSeen(rare.when),
						rare.source or UNKNOWN
					)
				end
			else
				tooltip:AddHeader("None seen this session")
			end
		end

		if options.help then
			tooltip:AddSeparator()
			local index = tooltip:AddLine("Right-click to open settings")
			tooltip:SetLineTextColor(index, 0, 1, 1)
			if core.debuggable then
				index = tooltip:AddLine("Shift-right-click to view debug information")
				tooltip:SetLineTextColor(index, 0, 1, 1)
			end
		end

		tooltip:UpdateScrolling()
		tooltip:Show()
	end
end
