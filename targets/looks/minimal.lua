local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

local function SetSize(popup, config)
    local modelOffset = module.db.profile.model and popup.model:GetWidth() / 2
                        or 0

    -- Center the title
    popup.title:ClearAllPoints()
    popup.title:SetPoint("BOTTOM", popup, "CENTER", modelOffset, 2)

    -- Anchor the status under the title
    popup.status:ClearAllPoints()
    popup.status:SetPoint("TOP", popup.title, "BOTTOM", 0, -2)

    popup:SetSize(config.width, config.height)
end

function module.Looks:Minimal(popup, config)
    popup:SetBackdrop({
        edgeFile = [[Interface\Buttons\WHITE8X8]], bgFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1
    })

    popup.title:SetHeight(0)

    popup.status:SetJustifyH("CENTER")

    popup.source:SetPoint("BOTTOMRIGHT", -2, 2)

    popup.lootIcon.texture:SetAtlas("VignetteLoot")

    popup.noteIcon:SetPoint("TOPLEFT", popup.modelbg, "TOPLEFT", 0, 0)

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

    SetSize(popup, config)
end

module:RegisterLookConfig("Minimal", {
    classcolor = {
        type = "toggle",
        name = "Class colored border",
        desc = "Color the border of the popup by your class color",
        order = 1,
    },
    background = {
        type = "color",
        name = "Background color",
        hasAlpha = true,
        order = 2,
    },
    width = {
        type = "range",
        name = "Width",
        width = "full",
        min = 120,
        max = 480,
        step = 1,
        order = 3,
    },
    height = {
        type = "range",
        name = "Height",
        width = "full",
        min = 30,
        max = 120,
        step = 1,
        order = 4,
    },
    showSource = {
        type = "toggle",
        name = "Show source",
        order = 5,
    },
    titleFontSize = {
        type = "range",
        name = "Title font size",
        width = "full",
        min = 4,
        max = 32,
        step = 1,
        order = 6,
    },
    statusFontSize = {
        type = "range",
        name = "Status font size",
        width = "full",
        min = 4,
        max = 32,
        step = 1,
        order = 7,
    },
    sourceFontSize = {
        type = "range",
        name = "Source font size",
        width = "full",
        min = 4,
        max = 32,
        step = 1,
        order = 8,
    },
}, {
    classcolor = false,
    background = {0, 0, 0, 0.7},
    width = 240,
    height = 60,
    showSource = true,
    titleFontSize = 12,
    statusFontSize = 12,
    sourceFontSize = 12,
}, function(_, popup, config)
    local r, g, b, a = unpack(config.background)
    popup:SetBackdropColor(r, g, b, a)
    popup.modelbg.animIn:SetToAlpha(a * 0.5)

    if config.classcolor then
        popup:SetBackdropBorderColor(RAID_CLASS_COLORS[select(2, UnitClass("player"))]:GetRGB())
    else
        popup:SetBackdropBorderColor(0, 0, 0)
    end

    -- Handle texts
    do
        -- Title
        popup.title:SetFont([[Fonts\ARIALN.TTF]], config.titleFontSize, "OUTLINE")

        -- Status
        popup.status:SetFont([[Fonts\ARIALN.TTF]], config.statusFontSize, "OUTLINE")
        popup.status:SetTextColor(1.0, 1.0, 1.0)

        -- Source
        popup.source:SetFont([[Fonts\ARIALN.TTF]], config.sourceFontSize, "OUTLINE")
        popup.source:SetTextColor(1.0, 1.0, 1.0)
        popup.source:SetShown(config.showSource)
    end

    if module.db.profile.model then
        popup.model:Show()

        popup.modelbg:SetTexture(false)
        popup.modelbg:SetPoint("TOPLEFT", 1, -2)
        popup.modelbg:SetPoint("BOTTOMLEFT", 1, 2)
        popup.modelbg:SetWidth(popup:GetHeight())
        module:SizeModel(popup, 0, 0)

        popup.raidIcon:SetPoint("BOTTOM", popup.modelbg, "TOP", 0, -8)

        popup.lootIcon:SetPoint("BOTTOMLEFT", popup.modelbg)
        popup.lootIcon:SetSize(24, 24)

        popup.dead:SetAllPoints(popup.modelbg)

        popup.shine.animIn.translate:SetOffset(210, 0)
    else
        popup.model:Hide()

        popup.raidIcon:SetPoint("BOTTOM")
        popup.lootIcon:SetPoint("BOTTOMLEFT")
        popup.lootIcon:SetSize(20, 20)

        popup.dead:SetAllPoints(popup)
        popup.shine.animIn.translate:SetOffset(150, 0)
    end

    SetSize(popup, config)
end)
