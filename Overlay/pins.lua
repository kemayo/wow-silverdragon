local myname = ...
local _, myfullname = C_AddOns.GetAddOnInfo("SilverDragon")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")

-- Pin mixin

local SilverDragonOverlayPinMixinBase = {}
module.SilverDragonOverlayPinMixinBase = SilverDragonOverlayPinMixinBase

-- 10.1.5 protected SetPassThroughButtons and it's called automatically inside AcquirePin, so we'll break it harder here until Blizzard fixes it:
SilverDragonOverlayPinMixinBase.SetPassThroughButtons = function() end

function SilverDragonOverlayPinMixinBase:OnAcquired(mobid, x, y, textureInfo, scale, alpha, originalCoord, originalMapID, minimap)
    self.mobid = mobid
    self.coord = originalCoord
    self.uiMapID = originalMapID
    self.minimap = minimap

    if not minimap then
        self:SetPosition(x, y)

        -- MapCanvasMixin:AcquirePin sets right-click to pass through so zoom-out can happen
        -- ...but we want it, because we have a right-click menu to show
        if self.SetPassThroughButtons then
            self:SetPassThroughButtons("")
        end
    end

    local size = 12
    scale = scale * self:Config().icon_scale
    alpha = alpha * self:Config().icon_alpha

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
           module.CreateWaypoint(self.uiMapID, self.coord)
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

function SilverDragonOverlayPinMixinBase:Config()
    return self.minimap and module.db.profile.minimap or module.db.profile.worldmap
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

    local function hideMob(mobid)
        if mobid then
            module.db.profile.hidden[mobid] = true
            module:Update()
        end
    end

    function module.CreateWaypoint(uiMapID, coord)
        -- point to it, without a timeout, and ignoring whether it'll be replacing an existing waypoint
        local id, name = core:GetMobByCoord(uiMapID, coord)
        local x, y = core:GetXY(coord)
        core:GetModule("TomTom"):PointTo(id, uiMapID, x, y, 0, true)
    end

    local function createWaypointForAll(uiMapID, mobid)
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

    local function showAchievement(achievement)
        OpenAchievementFrameToAchievement(achievement)
    end

    local function sendToChat(mobid, uiMapID, coord)
        local targets = core:GetModule("ClickTarget", true)
        if targets then
            local x, y = core:GetXY(coord)
            if x and y then
                targets:SendLinkToMob(mobid, uiMapID, x, y)
            end
        end
    end

    local generateMenu = function(owner, rootDescription, uiMapID, coord, pin)
        local mobid = pin.mobid
        rootDescription:SetTag("MENU_WORLD_MAP_CONTEXT_SILVERDRAGON")
        rootDescription:CreateTitle(myfullname)

        local achievement = mobid and ns:AchievementMobStatus(mobid)
        if achievement then
            rootDescription:CreateButton(OBJECTIVES_VIEW_ACHIEVEMENT, showAchievement, achievement)
        end
        rootDescription:CreateButton("Create waypoint", function() module.CreateWaypoint(uiMapID, coord) end)
            :SetEnabled(core:GetModule("TomTom"):CanPointTo(uiMapID))

        -- Specifically for TomTom, since it supports multiples:
        rootDescription:CreateButton(
            "Create waypoint for all locations",
            function() createWaypointForAll(uiMapID, mobid) end
        ):SetEnabled(TomTom and true or false) -- can't be nil

        -- Link to chat
        if _G.MAP_PIN_HYPERLINK then
            rootDescription:CreateButton(
                COMMUNITIES_INVITE_MANAGER_LINK_TO_CHAT,
                function() sendToChat(mobid, uiMapID, coord) end
            )
        end

        -- Hide menu item
        rootDescription:CreateButton("Hide mob", hideMob, mobid)

        -- Close menu item
        rootDescription:CreateButton(CLOSE, function() return MenuResponse.CloseAll end)
    end

    function module:ShowPinDropdown(pin, uiMapID, coord)
        MenuUtil.CreateContextMenu(pin, generateMenu, uiMapID, coord, pin)
    end
end
