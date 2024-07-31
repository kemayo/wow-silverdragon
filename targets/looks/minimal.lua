local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

function module.Looks:Minimal(popup, config)
    popup:SetSize(240, 60)
    popup:SetBackdrop({
        edgeFile = [[Interface\Buttons\WHITE8X8]], bgFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1
    })

    popup.title:SetFont([[Fonts\ARIALN.TTF]], 12, "OUTLINE")
    popup.source:SetFont([[Fonts\ARIALN.TTF]], 12, "OUTLINE")
    popup.source:SetTextColor(1.0, 1.0, 1.0)
    popup.status:SetFont([[Fonts\ARIALN.TTF]], 12, "OUTLINE")
    popup.status:SetTextColor(1.0, 1.0, 1.0)

    popup.title:SetHeight(0)

    popup.status:SetJustifyH("CENTER")

    popup.source:SetPoint("BOTTOMRIGHT", -2, 2)

    popup.lootIcon.texture:SetAtlas("VignetteLoot")

    popup.shine:SetPoint("TOPLEFT", 0, 0)
    popup.shine:SetPoint("BOTTOMLEFT", 0, 0)
    popup.shine:SetWidth(32)

    popup.glow:SetTexture([[Interface\FullScreenTextures\OutOfControl]])
    -- popup.glow:SetVertexColor(r, g, b, 1)
    popup.glow:SetAllPoints()

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

    popup.SetSource = function(_, source)
        if module.db.profile.model then
            popup.source:SetText(source or "")
        else
            popup.source:SetText(source and source:sub(0, 1) or "")
        end
    end
end

module:RegisterLookConfig("Minimal", {
    classcolor = {
        type = "toggle",
        name = "Class colored border",
        desc = "Color the border of the popup by your class color",
    },
    background = {
        type = "color",
        name = "Background color",
        hasAlpha = true,
    },
}, {
    classcolor = false,
    background = {0, 0, 0, 0.7},
}, function(_, popup, config)
    local r, g, b, a = unpack(config.background)
    popup:SetBackdropColor(r, g, b, a)
    popup.modelbg.animIn:SetToAlpha(a * 0.5)

    if config.classcolor then
        popup:SetBackdropBorderColor(RAID_CLASS_COLORS[select(2, UnitClass("player"))]:GetRGB())
    else
        popup:SetBackdropBorderColor(0, 0, 0)
    end

    popup.title:ClearAllPoints()
    popup.status:ClearAllPoints()

    if module.db.profile.model then
        popup:SetSize(240, 60)
        popup.model:Show()

        popup.modelbg:SetTexture(false)
        popup.modelbg:SetPoint("TOPLEFT", 1, -2)
        popup.modelbg:SetPoint("BOTTOMLEFT", 1, 2)
        popup.modelbg:SetWidth(popup:GetHeight())
        module:SizeModel(popup, 0, 0)

        popup.title:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 0, -16)
        popup.title:SetPoint("RIGHT")

        -- popup.status:SetPoint("BOTTOMLEFT", popup.modelbg, "BOTTOMRIGHT", 2, 2)
        popup.status:SetPoint("TOPLEFT", popup.title, "BOTTOMLEFT")
        popup.status:SetPoint("TOPRIGHT", popup.title, "BOTTOMRIGHT")

        popup.raidIcon:SetPoint("BOTTOM", popup.modelbg, "TOP", 0, -8)

        popup.lootIcon:SetPoint("BOTTOMLEFT", popup.modelbg)
        popup.lootIcon:SetSize(24, 24)

        popup.dead:SetAllPoints(popup.modelbg)

        popup.shine.animIn.translate:SetOffset(210, 0)
    else
        popup:SetSize(180, 32)
        popup.model:Hide()

        popup.title:SetPoint("TOP", 0, -4)
        popup.status:SetPoint("BOTTOM", 0, 4)

        popup.raidIcon:SetPoint("BOTTOM")
        popup.lootIcon:SetPoint("BOTTOMLEFT")
        popup.lootIcon:SetSize(20, 20)

        popup.dead:SetAllPoints(popup)
        popup.shine.animIn.translate:SetOffset(150, 0)
    end
end)
