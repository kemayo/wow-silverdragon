local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

function module.Looks:Store(popup)
    popup:SetSize(253, 75)

    popup.background:SetSize(253, 75)
    popup.background:SetTexture([[Interface\Store\Store-Main]])
    popup.background:SetTexCoord(0.50878906, 0.79589844, 0.54199219 ,0.62402344)
    popup.background:SetPoint("CENTER")

    popup.close:SetPoint("TOPRIGHT", -12, -12)

    popup.modelbg:SetPoint("LEFT", 10, 0)
    self:SizeModel(popup, 7)

    -- /script SilverDragonPopupButton.modelhighlight
    popup.modelhighlight = popup.model:CreateTexture(nil, "OVERLAY", nil, -1)
    popup.modelhighlight:SetSize(70, 70) -- slightly oversize it
    popup.modelhighlight:SetTexture([[Interface\Store\store-item-highlight]])
    popup.modelhighlight:SetPoint("CENTER")

    popup.source:SetPoint("BOTTOMRIGHT", -18, 18)

    popup.title:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 4, -6)
    popup.title:SetPoint("BOTTOM", popup.source, "TOP", 0, 0)
    popup.title:SetJustifyV("MIDDLE")

    popup.status:SetFontObject("GameFontNormalSmallLeft")
    popup.status:SetJustifyH("LEFT")
    popup.status:SetSize(157, 10)
    popup.status:SetPoint("LEFT", popup.modelbg, "RIGHT", 4, 0)
    popup.status:SetPoint("BOTTOMRIGHT", popup.source, "BOTTOMLEFT", -4, 0)

    popup.glow:SetSize(253, 75)
    popup.glow:SetPoint("TOPLEFT", -10)
    popup.glow:SetPoint("BOTTOMRIGHT", 10)

    popup.shine:SetSize(120, 45)
    popup.shine:SetPoint("BOTTOMLEFT", -10, 12)

    popup.raidIcon:SetPoint("BOTTOMRIGHT", popup.modelbg, "TOPLEFT", 12, -12)
    popup.lootIcon:SetPoint("CENTER", popup.modelbg, "BOTTOMLEFT", 0, 0)
    popup.dead:SetAllPoints(popup.modelbg)
end
