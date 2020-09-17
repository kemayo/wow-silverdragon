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
			loot = true,
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
					loot = {
						type = "toggle",
						name = "Show loot",
						desc = "Toggle showing important loot in the popup",
						get = function() return db.profile.loot end,
						set = function(info, v) db.profile.loot = v end,
						order = 40,
					}
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
	function ShieldCellPrototype:getContentHeight()
		return 16
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
	local loot = {}
	local checkmark = CreateAtlasMarkup("Tracker-Check")
	local tooltip
	local function draw_tooltip(self)
		if not core.db then
			return
		end

		if not tooltip then
			tooltip = LibQTip:Acquire("SilverDragonTooltip", 8, "LEFT", "CENTER", "RIGHT", "CENTER", "RIGHT", "RIGHT", "RIGHT", "RIGHT")
			tooltip:SetAutoHideDelay(0.25, self)
			tooltip:SmartAnchorTo(self)
			tooltip.OnRelease = function(self)
				tooltip = nil
			end
		end

		tooltip:Clear()

		local zone = HBD:GetPlayerZone()
		if ns.mobsByZone[zone] then
			tooltip:AddHeader("Nearby")
			tooltip:AddHeader("Name", "Count", "Last Seen", db.profile.loot and LOOT or nil)

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
					core:GetMobLabel(id),
					times_seen,
					core:FormatLastSeen(last_seen),
					(tameable and 'Tameable' or '')
				)
				if db.profile.loot then
					wipe(loot)
					if ns.mobdb[id] and ns.mobdb[id].mount then
						if type(ns.mobdb[id].mount) == 'number' then
							local lname, _, licon, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(ns.mobdb[id].mount)
							if lname then
								table.insert(loot, MOUNT .. " (|T" .. licon .. ":0|t " .. lname .. ')' .. (isCollected and checkmark or ''))
							else
								table.insert(loot, MOUNT .. (isCollected and checkmark or ''))
							end
						else
							table.insert(loot, MOUNT)
						end
					end
					if ns.mobdb[id] and ns.mobdb[id].pet then
						if type(ns.mobdb[id].pet) == 'number' then
							local lname, licon = C_PetJournal.GetPetInfoBySpeciesID(ns.mobdb[id].pet)
							local isCollected = C_PetJournal.GetNumCollectedInfo(ns.mobdb[id].pet) > 0
							if lname then
								table.insert(loot, TOOLTIP_BATTLE_PET .. " (|T" .. licon .. ":0|t " .. lname .. ')' .. (isCollected and checkmark or ''))
							else
								table.insert(loot, TOOLTIP_BATTLE_PET .. (isCollected and checkmark or ''))
							end
						else
							table.insert(loot, TOOLTIP_BATTLE_PET)
						end
					end
					if ns.mobdb[id] and ns.mobdb[id].toy then
						if type(ns.mobdb[id].toy) == 'number' then
							local _, lname, licon = C_ToyBox.GetToyInfo(ns.mobdb[id].toy)
							local isCollected = PlayerHasToy(ns.mobdb[id].toy)
							if lname then
								table.insert(loot, TOY .. " (|T" .. licon .. ":0|t " .. lname .. ')' .. (isCollected and checkmark or ''))
							else
								table.insert(loot, TOY .. (isCollected and checkmark or ''))
							end
						else
							table.insert(loot, TOY)
						end
					end
					if #loot then
						index, col = tooltip:SetCell(index, col, strjoin(', ', unpack(loot)))
					end
				end
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

		tooltip:UpdateScrolling()
		tooltip:Show()
	end

	function dataobject:OnEnter()
		if not tooltip or not tooltip:IsShown() then
			draw_tooltip(self)
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
