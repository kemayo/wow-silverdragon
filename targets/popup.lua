local myname, ns = ...

local HBD = LibStub("HereBeDragons-2.0")
local LibWindow = LibStub("LibWindow-1.1")

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

local CreateAnimationAlpha
local escapes = core.escapes

function module:ApplyLook(popup, look)
	-- Many values cribbed from AlertFrameSystem.xml
	(self.Looks[look] or self.Looks.SilverDragon)(self, popup, self.db.profile.style_options[look])
	popup.look = look
end
function module:ResetLook(popup)
	if not (popup.look and self.LookReset[popup.look]) then return end
	self.LookReset[popup.look](self, popup, self.db.profile.style_options[popup.look])
end

function module:ShowFrame(data)
	if not self.db.profile.show then return end
	if not (data and data.id) then return end
	if not self.popup then
		self.popup = self:CreatePopup()
	end
	local popup = self.popup
	popup.data = data

	local name = core:NameForMob(data.id, data.unit)
	if name then
		local macrotext = "/cleartarget \n/targetexact "..name
		popup:SetAttribute("macrotext1", macrotext)
	end

	if popup:IsVisible() then
		popup:Hide()
	end

	popup:Show()

	self:RefreshMobData(popup)

	self:ShowModel(popup)

	if data.unit and GetRaidTargetIndex(data.unit) then
		popup:SetRaidIcon(GetRaidTargetIndex(data.unit))
	end
end

function module:RefreshMobData(popup)
	local data = popup.data
	popup.title:SetText(core:GetMobLabel(data.id) or UNKNOWN)
	popup.source:SetText(data.source or "")

	local achievement, achievement_name, completed = ns:AchievementMobStatus(data.id)
	if achievement then
		popup.status:SetFormattedText("%s%s|r", completed and escapes.green or escapes.red, achievement_name)
	else
		popup.status:SetText("")
	end
end

function module:ShowModel(popup)
	-- reset the model
	popup.model:ClearModel()
	popup.model:SetModelScale(1)
	popup.model:SetPosition(0, 0, 0)
	popup.model:SetFacing(0)

	local data = popup.data
	if (data.id or data.unit) and not self:IsModelBlacklisted(data.id, data.unit) then
		if data.unit then
			popup.model:SetUnit(data.unit)
		else
			popup.model:SetCreature(data.id)
		end

		popup.model:SetPortraitZoom(1)
	else
		popup.model:SetModelScale(4.25)
		popup.model:SetPosition(4, 0, 1.5)
		popup.model:SetModel([[Interface\Buttons\talktomequestionmark.mdx]])
	end
end

do
	local bad_ids = {
		[83008] = true, -- Haakun the All-Consuming
	}
	function module:IsModelBlacklisted(id, unit)
		if not (id or unit) then
			return true
		end
		if not id then
			id = core:UnitID(unit)
		end
		return bad_ids[id]
	end
end

function module:SizeModel(popup, offset, borders)
	local modelSize = popup.modelbg:GetWidth() - (borders or 10)
	local model = popup.model
	model:SetSize(modelSize, modelSize)
	model:SetPoint("TOPLEFT", popup.modelbg, offset, -offset)
	model:SetPoint("BOTTOMRIGHT", popup.modelbg, -offset, offset)
end

-- copy the Button metatable on to this, because otherwise we lose all regular frame methods
local PopupMixin = {}

function module:CreatePopup()
	-- Set up the frame
	local name = "SilverDragonPopupButton"
	do
		local i = 1
		while _G[name] do
			name = name .. i
			i = i + 1
		end
	end
	local popup = CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate, SecureHandlerShowHideTemplate, BackdropTemplate")
	Mixin(popup, PopupMixin)
	module.popup = popup

	popup:SetSize(276, 96)
	-- TODO: a stack
	popup:SetPoint("CENTER", self.anchor, "CENTER")
	popup:SetScale(self.db.profile.anchor.scale)
	popup:SetMovable(true)
	popup:SetClampedToScreen(true)
	popup:RegisterForClicks("AnyUp")

	popup:SetAttribute("type", "macro")
	popup:SetAttribute("_onshow", "self:Enable()")
	popup:SetAttribute("_onhide", "self:Disable()")
	-- Can't do type=click + clickbutton=close because then it'd be right-clicking the close button which also ignores the mob
	popup:SetAttribute("macrotext2", "/click " .. popup:GetName() .. "CloseButton")

	popup:Hide()

	-- art
	local background = popup:CreateTexture(nil, "BORDER", nil, 1)
	popup.background = background
	background:SetBlendMode("BLEND")

	local modelbg = popup:CreateTexture(nil, "BORDER")
	popup.modelbg = modelbg
	modelbg:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
	modelbg:SetSize(52, 52)

	local model = CreateFrame("PlayerModel", nil, popup)
	popup.model = model

	local raidIcon = model:CreateTexture(nil, "OVERLAY")
	popup.raidIcon = raidIcon
	raidIcon:SetSize(16, 16)
	raidIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	raidIcon:Hide()

	local dead = model:CreateTexture(nil, "OVERLAY")
	popup.dead = dead
	dead:SetAtlas([[XMarksTheSpot]])
	dead:SetAlpha(0)

	-- text
	local title = popup:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3");
	popup.title = title
	title:SetSize(167, 33)
	title:SetJustifyH("MIDDLE")
	title:SetJustifyV("MIDDLE")

	local source = popup:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	popup.source = source
	source:SetJustifyH("RIGHT")
	source:SetJustifyV("MIDDLE")

	local status = popup:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	popup.status = status
	status:SetJustifyH("RIGHT")
	status:SetJustifyV("MIDDLE")

	-- Close button
	local close = CreateFrame("Button", popup:GetName() .. "CloseButton", popup, "UIPanelCloseButtonNoScripts,SecureHandlerClickTemplate")
	popup.close = close
	close:SetSize(16, 16)
	close:GetDisabledTexture():SetTexture("")
	close:GetHighlightTexture():SetTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Highlight]])
	close:GetNormalTexture():SetTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Up]])
	close:GetPushedTexture():SetTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Down]])
	close:RegisterForClicks("AnyUp")
	-- called as onclick(self, button, down):
	close:SetAttribute("_onclick", [[
		local popup = self:GetParent()
		if button == "RightButton" then
			popup:CallMethod("DoIgnore")
		end
		popup:Hide()
	]])

	-- Flashy effects
	local glow = popup:CreateTexture(nil, "OVERLAY")
	popup.glow = glow
	glow:SetBlendMode("ADD")
	glow:SetAtlas("loottoast-glow") -- Garr_NotificationGlow?

	local shine = popup:CreateTexture(nil, "OVERLAY")
	popup.shine = shine
	shine:SetBlendMode("ADD")
	shine:SetAtlas("loottoast-sheen")

	-- animations for same
	-- CreateAnimationAlpha(from, to, duration, delay, order)
	popup.animIn = popup:CreateAnimationGroup()
	popup.animIn:SetToFinalAlpha(true)
	for _, child in ipairs({'background', 'model', 'modelbg', 'close'}) do
		local animIn = CreateAnimationAlpha(popup.animIn, 0, 1, 0.4, nil, 1)
		animIn:SetTarget(popup)
		animIn:SetChildKey(child)
		popup[child].animIn = animIn
		popup[child]:SetAlpha(0)
	end

	dead.animIn = dead:CreateAnimationGroup()
	dead.animIn:SetToFinalAlpha(true)
	CreateAnimationAlpha(dead.animIn, 0, 0.8, 0.6, nil, 1)
	CreateAnimationAlpha(dead.animIn, 1, 0.2, 0.4, nil, 2)
	CreateAnimationAlpha(dead.animIn, 0.2, 0.6, 0.3, nil, 3)
	CreateAnimationAlpha(dead.animIn, 0.6, 0.4, 0.3, nil, 4)

	glow.animIn = glow:CreateAnimationGroup()
	glow.animIn:SetScript("OnFinished", popup.scripts.AnimationHideParent)
	CreateAnimationAlpha(glow.animIn, 0, 1, 0.2, nil, 1)
	CreateAnimationAlpha(glow.animIn, 1, 0, 0.5, nil, 2)

	glow.animEnter = glow:CreateAnimationGroup()
	glow.animEnter:SetLooping("BOUNCE")
	glow.animEnter:SetScript("OnFinished", popup.scripts.AnimationHideParent)
	CreateAnimationAlpha(glow.animEnter, 0, 0.3, 0.8, nil, 1)
	CreateAnimationAlpha(glow.animEnter, 0.3, 0, 0.8, nil, 2)

	shine.animIn = shine:CreateAnimationGroup()
	shine.animIn:SetScript("OnFinished", popup.scripts.AnimationHideParent)
	CreateAnimationAlpha(shine.animIn, 0, 1, 0.1, nil, 1)
	CreateAnimationAlpha(shine.animIn, 1, 0, 0.25, 0.175, 2)
	local shineTranslate = shine.animIn:CreateAnimation("Translation")
	shineTranslate:SetOffset(165, 0)
	shineTranslate:SetDuration(0.425)
	shineTranslate:SetOrder(2)

	popup.animFade = popup:CreateAnimationGroup()
	popup.animFade:SetScript("OnFinished", popup.scripts.AnimationRequestHideParent)
	popup.animFade:SetToFinalAlpha(true)
	popup.animFade.anim = CreateAnimationAlpha(popup.animFade, 1, 0, 2, self.db.profile.closeAfter, 1)

	-- handlers
	popup:HookScript("OnShow", popup.scripts.OnShow)
	popup:HookScript("OnHide", popup.scripts.OnHide)
	popup:SetScript("OnEvent", popup.scripts.OnEvent)
	popup:SetScript("OnEnter", popup.scripts.OnEnter)
	popup:SetScript("OnLeave", popup.scripts.OnLeave)
	popup:SetScript("OnUpdate", popup.scripts.OnUpdate)
	popup:SetScript("OnMouseDown", popup.scripts.OnMouseDown)
	popup:SetScript("OnMouseUp", popup.scripts.OnMouseUp)

	popup.close:SetScript("OnEnter", popup.scripts.CloseOnEnter)
	popup.close:SetScript("OnLeave", popup.scripts.CloseOnLeave)

	self:ApplyLook(popup, self.db.profile.style)

	return popup
end

function CreateAnimationAlpha(animationGroup, fromAlpha, toAlpha, duration, startDelay, order)
	local animation = animationGroup:CreateAnimation("Alpha")
	animation:SetFromAlpha(fromAlpha)
	animation:SetToAlpha(toAlpha)
	animation:SetDuration(duration)

	if startDelay then
		animation:SetStartDelay(startDelay)
	end
	if order then
		animation:SetOrder(order)
	end

	return animation
end

function PopupMixin:SetRaidIcon(icon)
	SetRaidTargetIconTexture(self.raidIcon, icon)
	self.raidIcon:Show()
end

function PopupMixin:DoIgnore()
	if self.data and self.data.id then
		core:SetIgnore(self.data.id, true)
	end
end

function PopupMixin:HideWhenPossible(automatic)
	-- this is for animations that want to hide the popup itself, since it can't be touched in-combat
	self.automaticClose = automatic
	if InCombatLockdown() then
		self.waitingToHide = true
	else
		self:Hide()
	end
end

function PopupMixin:Reset()
	-- note to self: this gets called as part of a chain from OnHide, so we
	-- can't do anything which might trip in-combat lockdowns here.
	-- In particular, this means that anything which needs to use this post-
	-- reset will have to ClearAllPoints manually
	self.data = nil

	self.glow.animIn:Stop()
	self.shine.animIn:Stop()
	self.dead.animIn:Stop()
	self.animIn:Stop()
	self.animFade:Stop()

	self.raidIcon:Hide()
	self.dead:SetAlpha(0)
	self.model:ClearModel()

	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

PopupMixin.scripts = {
	OnEvent = function(self, event, ...)
		self[event](self, event, ...)
	end,
	OnEnter = function(self)
		if self.waitingToHide then
			-- we're "hidden" via alpha==0 now, so no tooltip
			return
		end

		local anchor = (self:GetCenter() < (UIParent:GetWidth() / 2)) and "ANCHOR_RIGHT" or "ANCHOR_LEFT"
		GameTooltip:SetOwner(self, anchor, 0, -60)
		GameTooltip:AddLine(escapes.leftClick .. " " .. TARGET)
		GameTooltip:AddLine(escapes.keyDown .. ALT_KEY_TEXT .. " + " .. escapes.leftClick .. " + " .. DRAG_MODEL .. "  " .. MOVE_FRAME)
		--GameTooltip:AddLine(escapes.keyDown .. CTRL_KEY_TEXT .. " + " .. escapes.leftClick .. "  " .. MAP_PIN )
		--if C_Map.CanSetUserWaypointOnMap(self.data.zone) and self.data.x > 0 and self.data.y > 0 then
		--	GameTooltip:AddLine(escapes.keyDown .. SHIFT_KEY_TEXT .. " + " .. escapes.leftClick .. "  " .. TRADESKILL_POST )
		--end
		GameTooltip:AddLine(escapes.rightClick .. " " .. CLOSE)
		GameTooltip:Show()

		self.glow.animIn:Stop() -- in case
		self.glow.animEnter:Stop() -- in case

		self.glow:Show()
		self.glow.animEnter:Play()

		-- reset the automatic hiding
		self.animFade:Stop()
		self.animFade.anim:SetStartDelay(module.db.profile.closeAfter)
	end,
	OnLeave = function(self)
		GameTooltip:Hide()

		self.glow.animEnter:Finish()

		self.animFade:Play()
	end,
	OnUpdate = function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > 0.5 then
			if not self.model:GetModelFileID() then
				-- Sometimes models don't load the first time you request them for some reason. In this case,
				-- re-requesting it seems to be needed. This might be a client bug, so testing whether it's still
				-- necessary would be wise. (Added in 70100, reproducing by flying around Pandaria works pretty well.)
				Debug("Poll for model reload")
				module:ShowModel(self)
			end
			self.elapsed = 0
		end
	end,
	OnMouseDown = function(self, button)
		if button == "RightButton" then
			-- handled in the secure click handler
			return
		--elseif IsControlKeyDown() then
		--	module:Point()
		elseif IsShiftKeyDown() then
			-- worldmap:uiMapId:x:y
			local data = self.data
			local x, y = data.x, data.y
			if not (x > 0 and y > 0) then
				x, y = HBD:GetPlayerZonePosition()
			end
			module:SendLinkToMob(data.id, data.zone, x, y)
		elseif IsAltKeyDown() then
			module.anchor:StartMoving()
		end
	end,
	OnMouseUp = function(self, button)
		module.anchor:StopMovingOrSizing()
		if not InCombatLockdown() then
			LibWindow.SavePosition(module.anchor)
		end
	end,
	-- hooked:
	OnShow = function(self)
		if not self.data then
			-- Things which show/hide UIParent (cinematics) *might* get us here without data
			return self:Hide()
		end
		module:ResetLook(self)

		self:SetAlpha(1)

		self.glow:Show()
		self.glow.animIn:Play()
		self.shine:Show()
		self.shine.animIn:Play()

		self.animIn:Play()

		self.animFade.anim:SetStartDelay(module.db.profile.closeAfter)
		self.animFade:Play() -- woo delay

		self.dead:SetAlpha(0)
		if self.data.dead then
			self.dead.animIn:Play()
		end

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")

		self.elapsed = 0
	end,
	OnHide = function(self)
		if self.data then
			-- Things which show/hide UIParent (cinematics) *might* get us here without data
			core.events:Fire("PopupHide", self.data.id, self.data.zone, self.data.x, self.data.y, self.automaticClose)
		end

		if not InCombatLockdown() then
			LibWindow.SavePosition(module.anchor)
		end

		self.waitingToHide = false
	end,
	-- Close button
	CloseOnEnter = function(self)
		local anchor = (self:GetCenter() < (UIParent:GetWidth() / 2)) and "ANCHOR_RIGHT" or "ANCHOR_LEFT"
		GameTooltip:SetOwner(self, anchor, 0, 0)
		GameTooltip:AddLine(escapes.leftClick .. " " .. CLOSE)
		GameTooltip:AddLine(escapes.rightClick .. " " .. IGNORE)
		GameTooltip:Show()
	end,
	CloseOnLeave = function(self)
		GameTooltip:Hide()
	end,
	-- Common animations
	AnimationHideParent = function(self)
		self:GetParent():Hide()
	end,
	AnimationRequestHideParent = function(self)
		self:GetParent():HideWhenPossible()
	end,
}
function PopupMixin:COMBAT_LOG_EVENT_UNFILTERED()
	-- timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags
	local _, subevent, _, _, _, _, _, destGUID = CombatLogGetCurrentEventInfo()
	if subevent ~= "UNIT_DIED" then
		return
	end

	if destGUID and ns.IdFromGuid(destGUID) == self.data.id then
		self.data.dead = true
		self.dead.animIn:Play()

		-- might have changed things like achievement status
		module:RefreshMobData(self)

		if module.db.profile.closeDead then
			self:HideWhenPossible()
		end
	end
end
function PopupMixin:PLAYER_REGEN_ENABLED()
	if self.waitingToHide then
		self:Hide()
	end
end
