local myname, ns = ...

local icon = LibStub("LibDBIcon-1.0", true)

local LibQTip = LibStub("LibQTip-1.0")
local HBD = LibStub("HereBeDragons-2.0")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("LDB")

local dataobject
local db

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("LDB", {
		profile = {
			minimap = {},
		},
	})
	db = self.db

	self:SetupDataObject()

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
								if last_seen then
									dataobject.text = last_seen
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

	local ShieldCellProvider, ShieldCellPrototype = LibQTip:CreateCellProvider()
	function ShieldCellPrototype:InitializeCell()
		self.texture = self:CreateTexture(nil, 'ARTWORK')
		self.texture:SetSize(16, 16)
		self.texture:SetPoint("CENTER", self)
		self.texture:Show()
	end
	function ShieldCellPrototype:ReleaseCell()
	end
	function ShieldCellPrototype:SetupCell(tooltip, value)
		self.texture:SetTexture("Interface\\AchievementFrame\\UI-Achievement-TinyShield")
		self.texture:SetTexCoord(0, 0.625, 0, 0.625)
		return self.texture:GetSize()
	end
	local QuestCellProvider, QuestCellPrototype = LibQTip:CreateCellProvider(ShieldCellProvider)
	function QuestCellPrototype:SetupCell(tooltip, value)
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

	local rares_seen = {}
	local sorted_mobs = {}
	local tooltip
	function dataobject:OnEnter()
		if not core.db then
			return
		end

		tooltip = LibQTip:Acquire("SilverDragonTooltip", 8, "LEFT", "CENTER", "RIGHT", "CENTER", "RIGHT", "RIGHT", "RIGHT", "RIGHT")

		local zone = HBD:GetPlayerZone()
		if ns.mobsByZone[zone] then
			tooltip:AddHeader("Nearby")
			tooltip:AddHeader("Name", "Count", "Last Seen")

			wipe(sorted_mobs)
			for id in pairs(ns.mobsByZone[zone]) do
				if core:IsMobInPhase(id, zone) and not core:ShouldIgnoreMob(id, zone) then
					table.insert(sorted_mobs, id)
				end
			end
			table.sort(sorted_mobs, mob_sorter)

			for _, id in ipairs(sorted_mobs) do
				local name, questid, vignette, tameable, last_seen, times_seen = core:GetMobInfo(id)
				local index, col = tooltip:AddLine(
					core:GetMobLabel(id) or UNKNOWN,
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
				tooltip:AddLine("None")
			end
		end

		if #rares_seen > 0 then
			tooltip:AddHeader("Seen this session")
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

		tooltip:AddSeparator()
		local index = tooltip:AddLine("Right-click to open settings")
		tooltip:SetLineTextColor(index, 0, 1, 1)
		if core.debuggable then
			index = tooltip:AddLine("Shift-right-click to view debug information")
			tooltip:SetLineTextColor(index, 0, 1, 1)
		end

		tooltip:SmartAnchorTo(self)
		tooltip:Show()
	end

	function dataobject:OnLeave()
		LibQTip:Release(tooltip)
		tooltip = nil
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

	local last_seen
	core.RegisterCallback("LDB", "Seen", function(callback, id, zone, x, y, dead, source)
		last_seen = id
		if db.profile.show_lastseen then
			dataobject.text = name
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
