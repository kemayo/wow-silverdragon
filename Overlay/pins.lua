local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

-- Pin mixin

local SilverDragonOverlayPinMixinBase = {}
module.SilverDragonOverlayPinMixinBase = SilverDragonOverlayPinMixinBase

function SilverDragonOverlayPinMixinBase:OnAcquired(mobid, x, y, textureInfo, scale, alpha, originalCoord, originalMapID, minimap)
    self.mobid = mobid
    self.coord = originalCoord
    self.uiMapID = originalMapID
    self.minimap = minimap
    self.config = minimap and module.db.profile.minimap or module.db.profile.worldmap

    if not minimap then
        self:SetPosition(x, y)
    end

    local size = 12
    scale = scale * self.config.icon_scale
    alpha = alpha * self.config.icon_alpha

    size = size * scale
    self:SetSize(size, size)
    local inset = 3 * scale
    self:SetHitRectInsets(inset, inset, inset, inset)
    self:SetAlpha(alpha)

    if textureInfo.r then
        self.texture:SetVertexColor(textureInfo.r, textureInfo.g, textureInfo.b, textureInfo.a)
    else
        self.texture:SetVertexColor(1, 1, 1, 1)
    end
    if textureInfo.atlas then
        self.texture:SetAtlas(textureInfo.atlas)
    else
        if textureInfo.tCoordLeft then
            self.texture:SetTexCoord(textureInfo.tCoordLeft, textureInfo.tCoordRight, textureInfo.tCoordTop, textureInfo.tCoordBottom)
        else
            self.texture:SetTexCoord(0, 1, 0, 1)
        end
        self.texture:SetTexture(textureInfo.icon)
    end

    self.DriverAnimation:Finish()

    self:ApplyFocusState()
end

function SilverDragonOverlayPinMixinBase:OnReleased()
    self.mobid = nil
    self.coord = nil
    self.uiMapID = nil
    self.minimap = nil
    self.config = nil

    self.DriverAnimation:Stop()
    self.DriverAnimation:Finish()
    self:Hide()
end

function SilverDragonOverlayPinMixinBase:OnMouseEnter()
    if not self.minimap then
        module:HighlightMob(self.mobid)
    end
    module:ShowTooltip(self)
end

function SilverDragonOverlayPinMixinBase:OnMouseLeave()
    if not self.minimap then
        module:UnhighlightMob(self.mobid)
    end

    if module.lootwindow then return end

    module:CleanupTooltip()
end

function SilverDragonOverlayPinMixinBase:OnMouseDown(button)
end

function SilverDragonOverlayPinMixinBase:OnMouseUp(button)
    local targets = core:GetModule("ClickTarget", true)
    if button == "RightButton" then
        if IsShiftKeyDown() then
            module.db.profile.hidden[self.mobid] = true
            module:Update()
        else
            module:ShowPinDropdown(self, self.uiMapID, self.coord)
        end
        return
    end
    if button == "LeftButton" then
        if IsAltKeyDown() then
           module.CreateWaypoint(self, self.uiMapID, self.coord)
           return
        end
        if IsShiftKeyDown() then
            if targets then
                local x, y = core:GetXY(self.coord)
                if x and y then
                    targets:SendLinkToMob(self.mobid, self.uiMapID, x, y)
                end
            end
            return
        end
        if not self.minimap then
            module:FocusMob(self.mobid)
        end
    end
end

function SilverDragonOverlayPinMixinBase:Ping()
    self.DriverAnimation:Play()
    self.ScaleAnimation:Play()
end

function SilverDragonOverlayPinMixinBase:ApplyFocusState()
    if self.mobid == module.focus_mob then
        self.emphasis:Show()
        self.emphasis:SetVertexColor(0, 1, 1, 1)
    else
        if not MouseIsOver(self) then
            self.emphasis:Hide()
        end
        self.emphasis:SetVertexColor(1, 1, 1, 1)
    end
end

-- Animation mixin

SilverDragonOverlayMapPinPingDriverAnimationMixin = {}

function SilverDragonOverlayMapPinPingDriverAnimationMixin:OnPlay()
    self.loops = 0
    self:GetParent().Expand:Show()
end

function SilverDragonOverlayMapPinPingDriverAnimationMixin:OnLoop()
    self.loops = self.loops + 1
    if self.loops >= 2 then
        self:Finish()
    end
end

function SilverDragonOverlayMapPinPingDriverAnimationMixin:OnFinished()
    local pin = self:GetParent()
    pin.ScaleAnimation:Stop()
    pin.ScaleAnimation:Finish()
    pin.Expand:Hide()
end

-- Dropdown setup

do
    local clicked_zone, clicked_coord

    local function hideMob(button, mobid)
        if mobid then
            module.db.profile.hidden[mobid] = true
            module:Update()
        end
    end

    function module.CreateWaypoint(button, uiMapID, coord)
        -- point to it, without a timeout, and ignoring whether it'll be replacing an existing waypoint
        local id, name = core:GetMobByCoord(uiMapID, coord)
        local x, y = core:GetXY(coord)
        core:GetModule("TomTom"):PointTo(id, uiMapID, x, y, 0, true)
    end

    local function createWaypointForAll(button, uiMapID, mobid)
        if not TomTom then return end
        if not (ns.mobsByZone[uiMapID] and ns.mobsByZone[uiMapID][mobid]) then return end
        for _, mob_coord in ipairs(ns.mobsByZone[uiMapID][mobid]) do
            local x, y = core:GetXY(mob_coord)
            TomTom:AddWaypoint(uiMapID, x, y, {
                title = core:GetMobLabel(mobid),
                persistent = nil,
                minimap = true,
                world = true
            })
        end
    end

    local dropdown = CreateFrame("Frame", nil, UIParent, "UIDropDownMenuTemplate")
    dropdown.displayMode = "MENU"

    dropdown.initialize = function(button, level)
        if (not level) then return end
        local info = UIDropDownMenu_CreateInfo()
        if (level == 1) then
            -- Create the title of the menu
            info.isTitle      = 1
            info.text         = "SilverDragon Overlay"
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, level)

            -- Waypoint menu item
            info.disabled     = nil
            info.isTitle      = nil
            info.notCheckable = nil
            info.text = "Create waypoint"
            info.icon = nil
            info.func = module.CreateWaypoint
            info.arg1 = button.uiMapID
            info.arg2 = button.coord
            UIDropDownMenu_AddButton(info, level)

            info.disabled = not TomTom
            info.isTitle = nil
            info.notCheckable = nil
            info.text = "Create waypoint for all locations"
            info.icon = nil
            info.func = createWaypointForAll
            info.arg1 = button.uiMapID
            info.arg2 = button.mobid
            UIDropDownMenu_AddButton(info, level)

            -- Hide menu item
            info.disabled     = nil
            info.isTitle      = nil
            info.notCheckable = nil
            info.text = "Hide mob"
            info.icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01"
            info.func = hideMob
            info.arg1 = button.mobid
            UIDropDownMenu_AddButton(info, level)

            -- Close menu item
            info.text         = "Close"
            info.icon         = nil
            info.func         = function() CloseDropDownMenus() end
            info.arg1         = nil
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, level)
        end
    end

    function module:ShowPinDropdown(pin, uiMapID, coord)
        dropdown.uiMapID = uiMapID
        dropdown.coord = coord
        dropdown.mobid = pin.mobid
        ToggleDropDownMenu(1, nil, dropdown, pin, 0, 0)
    end
end
