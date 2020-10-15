local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

local function Loot(self, popup)
    popup:SetSize(302, 119)

    -- left, right, top, bottom
    popup:SetHitRectInsets(20, 0, 15, 15)

    popup.background:SetSize(276, 96)
    popup.background:SetPoint("CENTER")

    popup.close:SetPoint("TOPRIGHT", -26, -24)

    popup.modelbg:SetPoint("TOPLEFT", 36, -32)
    self:SizeModel(popup, 4)

    popup.title:SetHeight(40)
    popup.title:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 11, -16)
    popup.source:SetPoint("BOTTOMRIGHT", -38, 26)

    popup.status:SetSize(152, 22)
    popup.status:SetPoint("TOPLEFT", 107, -28)

    popup.glow:SetSize(286, 109)
    popup.glow:SetPoint("CENTER", 0, 1)

    popup.shine:SetSize(171, 75)
    popup.shine:SetPoint("BOTTOMLEFT", 10, 24)

    popup.raidIcon:SetPoint("BOTTOM", popup.modelbg, "TOP", 0, -8)
    popup.lootIcon:SetPoint("CENTER", popup.modelbg, "BOTTOMLEFT", 0, 0)

    popup.dead:SetAllPoints(popup.modelbg)
end

function module.Looks:Loot_MoreAwesome(popup)
    Loot(self, popup)
    popup.background:SetAtlas("loottoast-moreawesome", true)
end

function module.Looks:Loot_QuestReward(popup)
    Loot(self, popup)
    popup.background:SetAtlas("loottoast-bg-questrewardupgrade", true)
    popup.status:SetPoint("TOPLEFT", 107, -30)
    popup.modelbg:SetPoint("TOPLEFT", 34, -32)
end
function module.Looks:Loot_Alliance(popup)
    Loot(self, popup)
    popup.background:SetAtlas("loottoast-bg-alliance", true)
    popup.status:SetWidth(132)
    popup.source:SetPoint("BOTTOMRIGHT", -58, 26)
end
function module.Looks:Loot_Horde(popup)
    Loot(self, popup)
    popup.background:SetAtlas("loottoast-bg-horde", true)
    popup.status:SetPoint("TOPLEFT", 107, -32)
end
function module.Looks:Loot_Azerite(popup)
    Loot(self, popup)
    popup.background:SetAtlas("loottoast-azerite", true)
end
function module.Looks:Loot_NZoth(popup)
    Loot(self, popup)
    popup.background:SetAtlas("loottoast-nzoth", true)
end

function module.Looks:Loot_Oribos(popup)
    Loot(self, popup)
    popup.background:SetAtlas("loottoast-oribos", true)
end
