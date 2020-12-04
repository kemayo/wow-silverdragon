local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

function module.Looks:Minimal(popup, config)
    popup:SetSize(240, 60)
    popup:SetBackdrop({
        edgeFile = [[Interface\Buttons\WHITE8X8]], bgFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1
    })
    local r, g, b, a = unpack(config.background)
    popup:SetBackdropColor(r, g, b, a)
    popup.modelbg.animIn:SetToAlpha(a * 0.5)

    if config.classcolor then
        popup:SetBackdropBorderColor(RAID_CLASS_COLORS[select(2, UnitClass("player"))]:GetRGB())
    else
        popup:SetBackdropBorderColor(0, 0, 0)
    end

    popup.title:SetFont([[Fonts\ARIALN.TTF]], 12, "OUTLINE")
    popup.source:SetFont([[Fonts\ARIALN.TTF]], 12, "OUTLINE")
    popup.source:SetTextColor(1.0, 1.0, 1.0)
    popup.status:SetFont([[Fonts\ARIALN.TTF]], 12, "OUTLINE")
    popup.status:SetTextColor(1.0, 1.0, 1.0)

    popup.modelbg:SetPoint("TOPLEFT", 1, -1)
    popup.modelbg:SetPoint("BOTTOMLEFT", 1, 1)
    popup.modelbg:SetWidth(popup:GetHeight())
    self:SizeModel(popup, 0, 0)

    popup.title:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 0, -16)
    popup.title:SetPoint("RIGHT")
    popup.title:SetHeight(0)
    popup.source:SetPoint("BOTTOMRIGHT", -2, 2)

    popup.status:SetJustifyH("MIDDLE")
    -- popup.status:SetPoint("BOTTOMLEFT", popup.modelbg, "BOTTOMRIGHT", 2, 2)
    popup.status:SetPoint("TOPLEFT", popup.title, "BOTTOMLEFT")
    popup.status:SetPoint("TOPRIGHT", popup.title, "BOTTOMRIGHT")

    popup.glow:SetTexture([[Interface\FullScreenTextures\OutOfControl]])
    -- popup.glow:SetVertexColor(r, g, b, 1)
    popup.glow:SetAllPoints()

    popup.shine:SetPoint("TOPLEFT", 0, 0)
    popup.shine:SetPoint("BOTTOMLEFT", 0, 0)
    popup.shine:SetSize(171, 75)

    popup.raidIcon:SetPoint("BOTTOM", popup.modelbg, "TOP", 0, -8)

    popup.lootIcon:SetPoint("BOTTOMLEFT", popup.modelbg)
    popup.lootIcon.texture:SetAtlas("VignetteLoot")
    popup.lootIcon:SetSize(24, 24)

    popup.dead:SetAllPoints(popup.modelbg)

    -- it might be easier to just replace this entirely...
    popup.close:GetDisabledTexture():SetTexture("")
    popup.close:GetHighlightTexture():SetTexture("")
    popup.close:GetNormalTexture():SetTexture("")
    popup.close:GetPushedTexture():SetTexture("")
    popup.close.text = popup.close:CreateFontString(nil, "OVERLAY")
    popup.close.text:SetFont([[Fonts\FRIZQT___CYR.TTF]], 16, "OUTLINE")
    popup.close.text:SetText("x")
    popup.close.text:SetJustifyH("CENTER")
    popup.close.text:SetPoint("CENTER", popup.close, "CENTER")
    popup.close:SetPoint("TOPRIGHT", popup, "TOPRIGHT", 3, 3)
    popup.close:HookScript("OnEnter", function(self)
        self.text:SetTextColor(1, .2, .2)
    end)
    popup.close:HookScript("OnLeave", function(self)
        self.text:SetTextColor(1, 1, 1)
    end)
end

module:RegisterLookConfig("Minimal", {
    classcolor = {
        type = "toggle",
        name = "Class colored border",
        desc = "Color the border of the popup by your class color",
        arg = true,
    },
    background = {
        type = "color",
        name = "Background color",
        hasAlpha = true,
        arg = true,
    },
}, {
    classcolor = false,
    background = {0, 0, 0, 0.7},
})
