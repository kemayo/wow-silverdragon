local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("ClickTarget")
local Debug = core.Debug

local CreateAnimationAlpha
local escapes = {
	-- |TTexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2|t
	leftClick = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:19:11:-1:0:512:512:9:67:227:306|t]],
	rightClick = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:20:12:0:-1:512:512:9:66:332:411|t]],
	keyDown = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:0:0:0:-1:512:512:9:66:437:490|t]],
	green = _G.GREEN_FONT_COLOR_CODE,
	red = _G.RED_FONT_COLOR_CODE,
}

function module:ApplyLook(popup, look)
	-- Many values cribbed from AlertFrameSystem.xml
	(self.Looks[look] or self.Looks.SilverDragon)(self, popup)
end
module.Looks = {}

function module:ShowFrame(data)
	if not self.db.profile.show then return end
	if not (data and data.id) then return end
	local popup = self.popup
	popup.data = data

	local name = core:NameForMob(data.id, data.unit)
	if name then
		local macrotext = "/cleartarget\n/targetexact "..name
		popup:SetAttribute("macrotext", macrotext)
	else
		name = UNKNOWN
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
	popup.title:SetText(core:GetMobLabel(data.id))
	popup.source:SetText(data.source or "")

	local achievement, achievement_name, completed = ns:AchievementMobStatus(data.id)
	if achievement then
		popup.status:SetFormattedText("%s%s|r", completed and escapes.green or escapes.red, achievement_name)
	else
		popup.status:SetText("")
	end

	if ns.mobdb[data.id] and (ns.mobdb[data.id].mount or ns.mobdb[data.id].pet or ns.mobdb[data.id].toy) then
		popup.lootIcon:Show()
		local toy, mount, pet = ns:LootStatus(data.id)
		if (toy or toy == nil) and (mount or mount == nil) and (pet or pet == nil) then
			popup.lootIcon.complete:Show()
		else
			popup.lootIcon.complete:Hide()
		end
	else
		popup.lootIcon:Hide()
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
local PopupClass = setmetatable({}, getmetatable(CreateFrame("Button")))
local PopupClassMetatable = {__index = PopupClass}

function module:CreatePopup()
	-- Set up the frame
	local popup = CreateFrame("Button", "SilverDragonPopupButton", UIParent, "SecureActionButtonTemplate, SecureHandlerShowHideTemplate")
	module.popup = popup
	setmetatable(popup, PopupClassMetatable)

	popup:SetSize(276, 96)
	popup:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -260, 270)
	popup:SetMovable(true)
	popup:SetUserPlaced(true)
	popup:SetClampedToScreen(true)
	popup:SetFrameStrata("DIALOG")
	popup:RegisterForDrag("LeftButton")

	popup:SetAttribute("type1", "macro")
	popup:SetAttribute("_onshow", "self:Enable()")
	popup:SetAttribute("_onhide", "self:Disable()")

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

	local lootIcon = CreateFrame("Frame", nil, popup)
	popup.lootIcon = lootIcon
	lootIcon:SetSize(40, 40)
	lootIcon.texture = lootIcon:CreateTexture(nil, "OVERLAY", nil, 0)
	lootIcon.texture:SetAllPoints(lootIcon)
	lootIcon.texture:SetAtlas("ShipMissionIcon-Treasure-MapBadge")
	lootIcon:Hide()
	lootIcon.complete = lootIcon:CreateTexture(nil, "OVERLAY", nil, 1)
	lootIcon.complete:SetAllPoints(lootIcon)
	lootIcon.complete:SetAtlas("pvpqueue-conquestbar-checkmark")
	lootIcon.complete:Hide()

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
	local close = CreateFrame("Button", nil, popup, "UIPanelCloseButton,SecureHandlerClickTemplate")
	popup.close = close
	close:SetSize(16, 16)
	close:GetDisabledTexture():SetTexture("")
	close:GetHighlightTexture():SetTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Highlight]])
	close:GetNormalTexture():SetTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Up]])
	close:GetPushedTexture():SetTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Down]])
	close:SetAttribute("_onclick", [[
		local button = self:GetParent()
		button:Disable()
		button:Hide()
	]])

	-- Flashy effects
	local glow = popup:CreateTexture(nil, "OVERLAY")
	popup.glow = glow
	glow:SetBlendMode("ADD")
	glow:SetAtlas("loottoast-glow")

	local shine = popup:CreateTexture(nil, "OVERLAY")
	popup.shine = shine
	shine:SetBlendMode("ADD")
	shine:SetAtlas("loottoast-sheen")

	-- animations for same
	-- CreateAnimationAlpha(from, to, duration, delay, order)
	popup.animIn = popup:CreateAnimationGroup()
	popup.animIn:SetToFinalAlpha(true)
	for i, child in ipairs({'background', 'model', 'modelbg', 'close'}) do
		local animIn = CreateAnimationAlpha(popup.animIn, 0, 1, 0.4, nil, 1)
		animIn:SetTarget(popup)
		animIn:SetChildKey(child)
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
	popup:SetScript("OnDragStart", popup.scripts.OnDragStart)
	popup:SetScript("OnDragStop", popup.scripts.OnDragStop)
	popup:SetScript("OnMouseDown", popup.scripts.OnMouseDown)

	popup.close:SetScript("OnEnter", popup.scripts.CloseOnEnter)
	popup.close:SetScript("OnLeave", popup.scripts.CloseOnLeave)

	popup.lootIcon:SetScript("OnEnter", popup.scripts.LootOnEnter)
	popup.lootIcon:SetScript("OnLeave", popup.scripts.LootOnLeave)

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

function PopupClass:SetRaidIcon(icon)
	SetRaidTargetIconTexture(self.raidIcon, icon)
	self.raidIcon:Show()
end

function PopupClass:ShouldBeDraggable()
	return (not module.db.profile.locked) or IsModifierKeyDown()
end

function PopupClass:HideWhenPossible()
	-- this is for animations that want to hide the popup itself, since it can't be touched in-combat
	if InCombatLockdown() then
		self.waitingToHide = true
	else
		self:Hide()
	end
end

PopupClass.scripts = {
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
		if module.db.profile.locked then
			GameTooltip:AddLine(escapes.keyDown .. "ALT + " .. escapes.leftClick .. " + " .. DRAG_MODEL .. "  " .. MOVE_FRAME)
		else
			GameTooltip:AddLine(escapes.leftClick .. " + " .. DRAG_MODEL .. "  " .. MOVE_FRAME)
		end
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
	OnDragStart = function(self)
		if self:ShouldBeDraggable() then
			self:StartMoving()
		end
	end,
	OnDragStop = function(self)
		self:StopMovingOrSizing()
	end,
	OnMouseDown = function(self, button)
		if button == "RightButton" then
			self:HideWhenPossible()
		end
	end,
	-- hooked:
	OnShow = function(self)
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
		self.glow.animIn:Stop()
		self.shine.animIn:Stop()
		self.dead.animIn:Stop()
		self.animIn:Stop()
		self.animFade:Stop()

		self.raidIcon:Hide()
		self.lootIcon:Hide()
		self.dead:SetAlpha(0)
		self.model:ClearModel()

		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")

		self.waitingToHide = false
	end,
	-- Close button
	CloseOnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 0)
		GameTooltip:AddLine(escapes.leftClick .. " " .. CLOSE)
		GameTooltip:Show()
	end,
	CloseOnLeave = function(self)
		GameTooltip:Hide()
	end,
	-- Loot icon
	LootOnEnter = function(self)
		local id = self:GetParent().data.id
		if not ns.mobdb[id] then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 0)
		ns:UpdateTooltipWithLootDetails(GameTooltip, id)
		GameTooltip:Show()
	end,
	LootOnLeave = function(self)
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
-- timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags
function PopupClass:COMBAT_LOG_EVENT_UNFILTERED(_, _, combatEvent, _, _, _, _, _, destGUID)
	if combatEvent ~= "UNIT_DIED" then
		return
	end
	if destGUID and ns.IdFromGuid(destGUID) == self.data.id then
		self.data.dead = true
		self.dead.animIn:Play()

		-- might have changed things like achievement status
		module:RefreshMobData(self)
	end
end
function PopupClass:PLAYER_REGEN_ENABLED()
	if self.waitingToHide then
		self:Hide()
	end
end
