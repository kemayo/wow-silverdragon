local tablet = AceLibrary("Tablet-2.0")

local L = AceLibrary("AceLocale-2.2"):new("SilverDragon")

SilverDragon = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0")

SilverDragon.version = "2.0." .. string.sub("$Revision$", 12, -3)
SilverDragon.date = string.sub("$Date$", 8, 17)
SilverDragon.hasIcon = L["DefaultIcon"]

function SilverDragon:OnInitialize()
	SilverDragon:RegisterDB("SilverDragonDB")
	SilverDragon:RegisterDefaults('profile', {
		mobs = {
			--zone
			["*"] = {},
		},
	})
	self.lastsaw = {}
end

function SilverDragon:OnEnable()
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function SilverDragon:PLAYER_TARGET_CHANGED()
	self:RareScan('target')
end

function SilverDragon:UPDATE_MOUSEOVER_UNIT()
	self:RareScan('mouseover')
end

function SilverDragon:RareScan(unit)
	local c12n = UnitClassification(unit)
	if c12n == 'rare' or c12n == 'rareelite' then
		local x, y = GetPlayerMapPosition("player")
		if x == 0 and y == 0 then return end
		
		local name = UnitName(unit)
		if self.lastseen[name] and self.lastseen[name] < (time() - 600) then
			-- Only grab each rare every 10 minutes, preventing spam.
			-- Store as: x:y:name:level:elite:type:subzone
			self.db.profile.mobs[GetRealZoneText()] = string.format("%d:%d:%s:%d:%d:%s:%s", x, y, name, UnitLevel(unit), c12n=='rareelite' and 1 or 0, UnitCreatureType(unit), GetSubZoneText())
			self.lastseen[name] = time()
			
			self:Update()
		end
	end
end

function SilverDragon:OnTooltipUpdate()
	local zone, subzone = GetRealZoneText(), GetSubZoneText()
	cat = tablet:AddCategory('text', zone, 'columns', 4)
	for mob in pairs(self.db.profile.mobs[zone]) do
		local _,_,x,y,name,level,elite,ctype,csubzone = string.find(mob, "(%d):(%d):(%s):(%d):(%d):(%s):(%s)")
		cat:AddLine(
			'text', name, 'textR', subzone == csubzone and 0 or nil, 'textR', subzone == csubzone and 1 or nil, 'textR', subzone == csubzone and 0 or nil,
			'text2', string.format("level %d%s %s", level, elite==1 and '+' or '', ctype),
			'text3', csubzone,
			'text4', string.format("%d, %d", x, y)
		)
	end
end

function SilverDragon:OnTextUpdate()
	self:SetText(L["Rares"])
end
