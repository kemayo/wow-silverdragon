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
	(self.Looks[look] or self.Looks.LessAwesome)(self, popup)
end
module.Looks = {}

function module:ShowFrame()
	if not self.db.profile.show then return end
	local current = self.current
	if not current.id then return end
	local popup = self.popup

	local name = core:NameForMob(current.id)
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

	popup.title:SetText(core:GetMobLabel(current.id) or UNKNOWN)
	popup.source:SetText(current.source or "")

	local achievement, achievement_name, completed = ns:AchievementMobStatus(current.id)
	if achievement then
		popup.status:SetFormattedText("%s%s|r", completed and escapes.green or escapes.red, achievement_name)
	else
		popup.status:SetText("")
	end

	self:ShowModel(popup, current)

	if current.unit and GetRaidTargetIndex(current.unit) then
		self:SetRaidIcon(popup, GetRaidTargetIndex(current.unit))
	end
end

function module:SetRaidIcon(popup, icon)
	SetRaidTargetIconTexture(popup.raidIcon, icon)
	popup.raidIcon:Show()
end

function module:ShowModel(popup, current)
	-- reset the model
	popup.model:ClearModel()
	popup.model:SetModelScale(1)
	popup.model:SetPosition(0, 0, 0)
	popup.model:SetFacing(0)

	if (current.id or current.unit) and not self:IsModelBlacklisted(current.id, current.unit) then
		if current.unit then
			popup.model:SetUnit(current.unit)
		else
			popup.model:SetCreature(current.id)
		end

		popup.model:SetPortraitZoom(1)
	else
		popup.model:SetModelScale(4.25)
		popup.model:SetPosition(4, 0, 1.5)
		popup.model:SetModel([[Interface\Buttons\talktomequestionmark.mdx]])
	end
end

function module:ShouldBeDraggable()
	return (not self.db.profile.locked) or IsModifierKeyDown()
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

function module:CreatePopup()
	-- Set up the frame
	local popup = CreateFrame("Button", "SilverDragonPopupButton", UIParent, "SecureActionButtonTemplate, SecureHandlerShowHideTemplate")
	module.popup = popup

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

	glow.animIn = glow:CreateAnimationGroup()
	glow.animIn:SetScript("OnFinished", function(self) self:GetParent():Hide() end)
	CreateAnimationAlpha(glow.animIn, 0, 1, 0.2, nil, 1)
	CreateAnimationAlpha(glow.animIn, 1, 0, 0.5, nil, 2)

	glow.animEnter = glow:CreateAnimationGroup()
	glow.animEnter:SetLooping("BOUNCE")
	glow.animEnter:SetScript("OnFinished", function(self) self:GetParent():Hide() end)
	CreateAnimationAlpha(glow.animEnter, 0, 0.3, 0.8, nil, 1)
	CreateAnimationAlpha(glow.animEnter, 0.3, 0, 0.8, nil, 2)

	shine.animIn = shine:CreateAnimationGroup()
	shine.animIn:SetScript("OnFinished", function(self) self:GetParent():Hide() end)

	CreateAnimationAlpha(shine.animIn, 0, 1, 0.1, nil, 1)
	CreateAnimationAlpha(shine.animIn, 1, 0, 0.25, 0.175, 2)
	local shineTranslate = shine.animIn:CreateAnimation("Translation")
	shineTranslate:SetOffset(165, 0)
	shineTranslate:SetDuration(0.425)
	shineTranslate:SetOrder(2)

	-- handlers
	popup:HookScript("OnShow", function(self)
		self.glow:Show()
		self.glow.animIn:Play()
		self.shine:Show()
		self.shine.animIn:Play()

		self.animIn:Play()
	end)
	popup:HookScript("OnHide", function(self)
		self.glow.animIn:Stop()
		self.shine.animIn:Stop()
		self.animIn:Stop()

		self.raidIcon:Hide()
	end)
	popup:SetScript("OnEnter", function(self)
		local anchor = (self:GetCenter() < (UIParent:GetWidth() / 2)) and "ANCHOR_RIGHT" or "ANCHOR_LEFT"
		GameTooltip:SetOwner(self, anchor, 0, -60)
		GameTooltip:AddLine(escapes.leftClick .. " " .. TARGET)
		if module.db.profile.locked then
			GameTooltip:AddLine(escapes.keyDown .. "ALT + " .. escapes.leftClick .. " + " .. DRAG_MODEL .. "  " .. MOVE_FRAME)
		else
			GameTooltip:AddLine(escapes.leftClick .. " + " .. DRAG_MODEL .. "  " .. MOVE_FRAME)
		end
		GameTooltip:Show()

		self.glow.animIn:Stop() -- in case
		self.glow.animEnter:Stop() -- in case

		self.glow:Show()
		self.glow.animEnter:Play()
	end)
	popup:SetScript("OnLeave", function(self)
		GameTooltip:Hide()

		self.glow.animEnter:Finish()
	end)
	popup:SetScript("OnDragStart", function(self)
		if module:ShouldBeDraggable() then
			self:StartMoving()
		end
	end)
	popup:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	popup.model:SetScript("OnHide", function(self)
		self.loaded = nil
		self:ClearModel()
	end)
	popup.model:SetScript("OnUpdateModel", function(self)
		self.loaded = true
	end)

	popup.close:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 0)
		GameTooltip:AddLine(escapes.leftClick .. " " .. CLOSE)
		GameTooltip:Show()
	end)
	popup.close:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

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
