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

function SilverDragonOverlayPinMixinBase:OnAcquired(id, pointType, textureInfo, scale, alpha, originalCoord, originalMapID, minimap)
    self.id = id
    self.isTreasure = pointType == "treasure"
    self.coord = originalCoord
    self.uiMapID = originalMapID
    self.minimap = minimap

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
        self.texture:SetTexCoord(0, 1, 0, 1)
        self.texture:SetAtlas(textureInfo.atlas)
    else
        -- a HandyNotes texture spec: an icon file plus a crop, from an imported
        -- treasure's `texture`. Icons that are only an atlas take the branch
        -- above -- no need to resolve those to a file ourselves.
        self.texture:SetTexCoord(
            textureInfo.tCoordLeft or 0, textureInfo.tCoordRight or 1,
            textureInfo.tCoordTop or 0, textureInfo.tCoordBottom or 1
        )
        self.texture:SetTexture(textureInfo.icon)
    end

    self.DriverAnimation:Finish()

    self:ApplyFocusState()
end

function SilverDragonOverlayPinMixinBase:OnReleased()
    self.id = nil
    self.isTreasure = nil
    self.coord = nil
    self.uiMapID = nil
    self.minimap = nil

    self.DriverAnimation:Stop()
    self.DriverAnimation:Finish()
    self:Hide()
end

function SilverDragonOverlayPinMixinBase:OnMouseEnter()
    if not self.minimap then
        module:HighlightPoint(self.id, self.isTreasure)
    end
    module:ShowTooltip(self)
end

function SilverDragonOverlayPinMixinBase:OnMouseLeave()
    if not self.minimap then
        module:UnhighlightPoint(self.id, self.isTreasure)
    end

    if module.lootwindow then return end

    module:CleanupTooltip()
end

-- not OnMouseUp: the map system's pin mixin takes that name for its own routing
function SilverDragonOverlayPinMixinBase:OnClick(button)
    if button == "RightButton" then
        if IsShiftKeyDown() then
            module.HidePoint(self.id, self.isTreasure)
        else
            module:ShowPinDropdown(self, self.uiMapID, self.coord)
        end
        return
    end
    if button == "LeftButton" then
        if IsAltKeyDown() then
           module.CreateWaypoint(self.uiMapID, self.coord, self.id, self.isTreasure)
           return
        end
        if IsShiftKeyDown() then
            module.SendPointToChat(self.id, self.uiMapID, self.coord, self.isTreasure)
            return
        end
        if not self.minimap then
            module:FocusPoint(self.id, self.isTreasure)
        end
    end
end

function SilverDragonOverlayPinMixinBase:Ping()
    self.DriverAnimation:Play()
    self.ScaleAnimation:Play()
end

function SilverDragonOverlayPinMixinBase:ApplyFocusState()
    if module:IsFocused(self.id, self.isTreasure) then
        self.emphasis:Show()
        self.emphasis:SetVertexColor(0, 1, 1, 1)
    else
        if not self:IsMouseOver() then
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

    function module.HidePoint(id, isTreasure)
        if id then
            module.db.profile[isTreasure and "hiddenTreasure" or "hidden"][id] = true
            module:Update()
        end
    end

    function module.CreateWaypoint(uiMapID, coord, id, isTreasure)
        -- point to it, without a timeout, and ignoring whether it'll be replacing an existing waypoint
        local x, y = core:GetXY(coord)
        -- PointTo titles a number by looking the mob up and takes anything else as
        -- the title itself, which is how a treasure gets named
        core:GetModule("TomTom"):PointTo(isTreasure and core:GetLabel(id, true) or id, uiMapID, x, y, 0, true)
    end

    local function createWaypointForAll(uiMapID, id, isTreasure)
        if not TomTom then return end
        local byZone = isTreasure and ns.treasureByZone or ns.mobsByZone
        if not (byZone[uiMapID] and byZone[uiMapID][id]) then return end
        local title = core:GetLabel(id, isTreasure)
        for coord in pairs(byZone[uiMapID][id]) do
            local x, y = core:GetXY(coord)
            TomTom:AddWaypoint(uiMapID, x, y, {
                title = title,
                persistent = nil,
                minimap = true,
                world = true
            })
        end
    end

    local function showAchievement(achievement)
        -- 12.1 renamed this; keep the old name while some regions are on 12.0
        if ShowAchievementFrameForAchievement then
            ShowAchievementFrameForAchievement(achievement)
        else
            OpenAchievementFrameToAchievement(achievement)
        end
    end

    function module.SendPointToChat(id, uiMapID, coord, isTreasure)
        local targets = core:GetModule("ClickTarget", true)
        if not targets then return end
        local x, y = core:GetXY(coord)
        if not (x and y) then return end
        if isTreasure then
            targets:SendLinkToLoot(core:GetLabel(id, true), uiMapID, x, y)
        else
            targets:SendLinkToMob(id, uiMapID, x, y)
        end
    end

    local generateMenu = function(owner, rootDescription, uiMapID, coord, pin)
        local id, isTreasure = pin.id, pin.isTreasure
        rootDescription:SetTag("MENU_WORLD_MAP_CONTEXT_SILVERDRAGON")
        rootDescription:CreateTitle(myfullname)

        local function achievementButton(achievement)
            rootDescription:CreateButton(
                -- core:RenderString(TEXT_MODE_A_STRING_VALUE_TYPE:format(OBJECTIVES_VIEW_ACHIEVEMENT, "{achievement:" .. achievement .. "}")),
                core:RenderString("Show {achievement:" .. achievement .. "}"),
                showAchievement, achievement
            )
        end
        if id then
            if isTreasure then
                -- as in the tooltip: AchievementMobStatus is keyed by npc id, whose
                -- numbers overlap with vignette ids, so a treasure asks its own data
                local data = core:GetData(id, true)
                if data and data.achievement then
                    achievementButton(data.achievement)
                end
            else
                for _, achievement in ns:AchievementMobStatus(id) do
                    achievementButton(achievement)
                end
            end
        end
        rootDescription:CreateButton("Create waypoint", function() module.CreateWaypoint(uiMapID, coord, id, isTreasure) end)
            :SetEnabled(core:GetModule("TomTom"):CanPointTo(uiMapID))

        -- Specifically for TomTom, since it supports multiples:
        rootDescription:CreateButton(
            "Create waypoint for all locations",
            function() createWaypointForAll(uiMapID, id, isTreasure) end
        ):SetEnabled(TomTom and true or false) -- can't be nil

        -- Link to chat
        if _G.MAP_PIN_HYPERLINK then
            rootDescription:CreateButton(
                COMMUNITIES_INVITE_MANAGER_LINK_TO_CHAT,
                function() module.SendPointToChat(id, uiMapID, coord, isTreasure) end
            )
        end

        -- Hide menu item
        rootDescription:CreateButton(
            isTreasure and "Hide treasure" or "Hide mob",
            function() module.HidePoint(id, isTreasure) end
        )

        -- Close menu item
        rootDescription:CreateButton(CLOSE, function() return MenuResponse.CloseAll end)
    end

    function module:ShowPinDropdown(pin, uiMapID, coord)
        MenuUtil.CreateContextMenu(pin, generateMenu, uiMapID, coord, pin)
    end
end
