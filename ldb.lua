local BCT = LibStub("LibBabble-CreatureType-3.0"):GetUnstrictLookupTable()
local BCTR = LibStub("LibBabble-CreatureType-3.0"):GetReverseLookupTable()
local icon = LibStub("LibDBIcon-1.0", true)

local LibQTip = LibStub("LibQTip-1.0")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("LDB")

local dataobject = LibStub("LibDataBroker-1.1"):NewDataObject("SilverDragon", {
	type = "data source",
	icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01",
	label = "Rares",
	text = "",
})

local db

local tooltip
function dataobject:OnEnter()
	local zone, x, y = core:GetPlayerLocation()

	tooltip = LibQTip:Acquire("SilverDragonTooltip", 5, "LEFT", "CENTER", "RIGHT", "RIGHT", "RIGHT")
	tooltip:AddHeader("Name", "Level", "Type", "Count", "Last Seen")
	
	local n = 0
	for name in pairs(core.db.global.mobs_byzone[zone]) do
		n = n + 1
		local num_locations, level, elite, creature_type, lastseen, count = core:GetMob(zone, name)
		tooltip:AddLine(name, ("%s%s"):format(level > 0 and level or '?', elite and '+' or ''), BCT[creature_type], count, core:FormatLastSeen(lastseen))
	end
	if n == 0 then
		tooltip:AddLine("None")
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
	local config = core:GetModule("Config", true)
	if config then
		config:ShowConfig()
	end
end

local last_seen
core.RegisterCallback("LDB", "Seen", function(callback, zone, name)
	last_seen = name
	if db.show_lastseen then
		dataobject.text = name
	end
end)

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("LDB", {
		profile = {
			minimap = {},
		},
	})
	db = self.db.profile
	if icon then
		icon:Register("SilverDragon", dataobject, self.db.profile.minimap)
	end
	if db.show_lastseen then
		dataobject.text = "None"
	end
	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.broker = {
			broker = {
				type = "group",
				name = "LDB",
				args = {
					show_lastseen = {
						type = "toggle",
						name = "Show last seen rare",
						desc = "Toggle showing or hiding the last seen rare as the dataobject's text",
						get = function() return db.show_lastseen end,
						set = function(info, v)
							db.show_lastseen = v
							if v then
								if last_seen then
									dataobject.text = last_seen
								else
									dataobject.text = "None"
								end
							end
						end,
						order = 10,
						width = "full",
					},
					minimap = {
						type = "toggle",
						name = "Show minimap icon",
						desc = "Toggle showing or hiding the minimap icon.",
						get = function() return not db.minimap.hide end,
						set = function(info, v)
							local hide = not v
							db.minimap.hide = hide
							if hide then
								icon:Hide("SilverDragon")
							else
								icon:Show("SilverDragon")
							end
						end,
						order = 30,
						width = "full",
						hidden = function() return not icon or not dataobject or not icon:IsRegistered("SilverDragon") end,
					},
				},
			},
		}
	end
end

