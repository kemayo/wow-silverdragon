local myname, ns = ...

local icon = LibStub("LibDBIcon-1.0", true)

local LibQTip = LibStub("LibQTip-1.0")
local HBD = LibStub("HereBeDragons-2.0")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("LDB", "AceEvent-3.0")

local dataobject, tooltip, db
local rares_seen = {}

local default_help = {
	"Right-click to open settings",
}
if core.debuggable then
	table.insert(default_help, "Shift-right-click to view debug information")
end

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("LDB", {
		profile = {
			minimap = {},
			worldmap = true,
			tooltip = "always",
		},
	})
	db = self.db

	self:SetupDataObject()
	self:SetupWorldMap()

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
							if v and module.last_seen then
								dataobject.text = core:GetMobLabel(module.last_seen)
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
						hidden = function() return not dataobject end,
					},
				},
			},
		}
	end
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
				if tooltip and tooltip.SDOptions.config_path then
					LibStub("AceConfigDialog-3.0"):SelectGroup("SilverDragon", unpack(tooltip.SDOptions.config_path))
				end
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
end

function module:SetupWorldMap()
	local button = CreateFrame("Button", nil, WorldMapFrame)
	button:SetSize(20, 20)
	button:SetPoint("TOPRIGHT", -28, -2)
	button:RegisterForClicks("AnyUp")
	button.texture = button:CreateTexture(nil, "ARTWORK")
	button.texture:SetTexture("Interface\\Icons\\INV_Misc_Head_Dragon_01")
	button.texture:SetAllPoints()
	button.options = {
		help = true,
	}
	button:SetScript("OnEnter", function()
		module:ShowTooltip(button, button.options)
		-- now redo the anchoring!
		if tooltip then
			tooltip:ClearAllPoints()
			tooltip:SetPoint("TOPLEFT", button, "BOTTOMLEFT")
			tooltip:SetClampedToScreen(true)
		end
	end)
	-- onleave is handled by the tooltip's autohide
	button:SetScript("OnClick", function(self, mButton)
		local overlay = core:GetModule("HandyNotes", true)
		if overlay and mButton == "LeftButton" and not IsModifierKeyDown() then
			overlay.db.profile.worldmap = not overlay.db.profile.worldmap
			self.texture:SetDesaturated(not overlay.db.profile.worldmap)
			overlay:UpdateWorldMapIcons()
			return
		end
		dataobject.OnClick(self, mButton)
	end)
	button:SetScript("OnShow", function(self)
		local overlay = core:GetModule("HandyNotes", true)
		if overlay then
			if not button.options.config_path then
				button.options.config_path = {'overlay'}
				button.options.help = {
					"Click to toggle map icons",
					-- "Shift-click to toggle map icons for this zone only",
				}
				tAppendAll(button.options.help, default_help)
			end
			button.texture:SetDesaturated(not overlay.db.profile.worldmap)
		end
		button.options.nearby = WorldMapFrame.mapID
	end)
	module.worldmap = button
	if not db.profile.worldmap then
		button:Hide()
	end
end

do
	local ShieldCellProvider, ShieldCellPrototype = LibQTip:CreateCellProvider()
	function ShieldCellPrototype:InitializeCell()
		self.texture = self:CreateTexture(nil, 'ARTWORK')
		self.texture:SetSize(16, 16)
		self.texture:SetPoint("CENTER", self)
		self.texture:Show()
	end
	function ShieldCellPrototype:ReleaseCell()
	end
	function ShieldCellPrototype:SetupCell(parent, value)
		self.texture:SetTexture("Interface\\AchievementFrame\\UI-Achievement-TinyShield")
		self.texture:SetTexCoord(0, 0.625, 0, 0.625)
		return self.texture:GetSize()
	end
	function ShieldCellPrototype:getContentHeight()
		return 16
	end

	local QuestCellProvider, QuestCellPrototype = LibQTip:CreateCellProvider(ShieldCellProvider)
	function QuestCellPrototype:SetupCell(parent, value)
		self.texture:SetAtlas("QuestNormal")
		return self.texture:GetSize()
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
			tooltip = LibQTip:Acquire("SilverDragonTooltip", 8, "LEFT", "CENTER", "RIGHT", "CENTER", "RIGHT", "RIGHT", "RIGHT", "RIGHT", "RIGHT")
			tooltip:SetAutoHideDelay(0.25, parent)
			tooltip:SmartAnchorTo(parent)
			tooltip.OnRelease = function() tooltip = nil end
		end

		tooltip:Clear()
		wipe(sorted_mobs)

		tooltip.SDOptions = options

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

			for _, id in ipairs(sorted_mobs) do
				local name, questid, vignette, tameable, last_seen, times_seen = core:GetMobInfo(id)
				local index, col = tooltip:AddLine(
					core:GetMobLabel(id),
					times_seen,
					core:FormatLastSeen(last_seen),
					(tameable and 'Tameable' or '')
				)
				local quest, achievement = ns:CompletionStatus(id)
				if quest ~= nil or achievement ~= nil then
					if achievement ~= nil then
						index, col = tooltip:SetCell(index, col, achievement, ShieldCellProvider)
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
			local index
			for _, line in ipairs(type(options.help) == "table" and options.help or default_help) do
				index = tooltip:AddLine(line)
				tooltip:SetLineTextColor(index, 0, 1, 1)
			end
		end

		tooltip:UpdateScrolling()
		tooltip:Show()

		return tooltip
	end
end
