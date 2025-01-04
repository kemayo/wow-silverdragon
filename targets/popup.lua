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
	if not (data and data.id) then return end
	local popup = self:Acquire(self.db.profile.style)
	popup.data = data

	if data.type == "mob" then
		local name = core:NameForMob(data.id, data.unit)
		if name then
			local macrotext = "/cleartarget \n/targetexact "..name
			popup:SetAttribute("macrotext1", macrotext)
		end
		if data.unit and GetRaidTargetIndex(data.unit) then
			popup:SetRaidIcon(GetRaidTargetIndex(data.unit))
		end
	else
		popup:SetAttribute("macrotext1", "")
	end

	if popup:IsVisible() then
		popup:Hide()
	end

	self:RefreshData(popup)
	popup:Show()

	self:SetModel(popup)

	return popup
end

function module:RefreshData(popup)
	local data = popup.data
	if data.type == "mob" then
		self:RefreshMobData(popup)
	else
		self:RefreshLootData(popup)
	end
	local isTreasure = data.type == "loot"
	local anyLoot = ns.Loot.GetLootTable(data.id, isTreasure)
	if anyLoot and #anyLoot > 0 then
		popup.lootIcon.count:SetText("?")
		popup.lootIcon:Show()
	else
		popup.lootIcon:Hide()
	end
	ns.Loot.OnceAllLootLoaded(data.id, data.type == "loot", function(loot)
		if popup.waitingToHide then return end
		local hasLoot, lootCount, suitableLootCount = ns.Loot.HasLoot(data.id, isTreasure)
		if hasLoot then
			popup.lootIcon:Show()
			popup.lootIcon.count:SetText(suitableLootCount)
		else
			popup.lootIcon:Hide()
		end
		if ns.Loot.Status(data.id, true, data.type == "loot") then
			-- all loot is collected
			popup.lootIcon.complete:Show()
		else
			popup.lootIcon.complete:Hide()
		end
	end)
end

function module:RefreshMobData(popup)
	local data = popup.data
	popup.title:SetText(core:GetMobLabel(data.id))
	popup:SetSource(data.source)

	local achievement, achievement_name, completed = ns:AchievementMobStatus(data.id)
	if achievement then
		popup.status:SetFormattedText("%s%s|r", completed and escapes.green or escapes.red, achievement_name or UNKNOWN)
	else
		popup.status:SetText("")
	end
end
function module:RefreshLootData(popup)
	local data = popup.data
	popup.title:SetText(data.name or UNKNOWN)
	popup:SetSource("vignette")
	-- TODO: work out the Treasure of X achievements?
	popup.status:SetText("")
	popup.raidIcon:Hide()
end

local models = {
	question = {
		model = [[Interface\Buttons\talktomequestionmark.mdx]],
		position = {4, 0, 1.5},
		scale = 4.25,
	},
	loot = {
		-- https://wow.tools/files/#search=type%3Am2%2Ctreasure&page=1&sort=0&desc=asc
		{
			model = 1100065, -- world/skillactivated/containers/treasurechest01hd.m2
			position = nil,
			scale = nil,
		},
		{
			model = 3189119, -- world/expansion08/doodads/valkyr/9vl_aspirants_treasurechest_large01.m2
			position = {-8, 0, 0.5},
			scale = nil,
		}
	}
}
local function applyModelSettings(model, settings)
	model:SetModel(settings.model)
	if settings.scale then model:SetModelScale(settings.scale) end
	if settings.position then model:SetPosition(unpack(settings.position)) end
	if settings.facing then model:SetFacing(settings.facing) end
end

function module:SetModel(popup)
	-- reset the model
	popup.model:ClearModel()
	popup.model:SetModelScale(1)
	popup.model:SetModelAlpha(1)
	popup.model:SetPosition(0, 0, 0)
	popup.model:SetFacing(0)
	popup.model.fallback:Hide()

	local data = popup.data
	if not self.db.profile.model then
		popup.model.fallback:SetAtlas(data.type == "loot" and "BonusLoot-Chest" or "sniper_shot-icon")
		popup.model.fallback:Show()
		return
	end
	if (data.type == "mob" and data.id or data.unit) and not self:IsModelBlacklisted(data.id, data.unit) then
		if data.unit then
			popup.model:SetUnit(data.unit)
		else
			popup.model:SetCreature(data.id)
		end

		popup.model:SetPortraitZoom(1)
	elseif data.type == "loot" then
		popup.model.fallback:SetAtlas("BonusLoot-Chest")
		popup.model.fallback:Show()
		-- I could do a 3d model, but since I can't get the right model for the treasure, it's arguably confusing
		-- applyModelSettings(popup.model, models.loot[1])
	else
		applyModelSettings(popup.model, models.question)
	end
end

do
	local bad_ids = {
		-- [83008] = true, -- Haakun the All-Consuming
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

function module:CreatePopup(look)
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

	popup:SetSize(276, 96)

	popup:SetScale(self.db.profile.anchor.scale)
	popup:SetMovable(true)
	popup:SetClampedToScreen(true)
	popup:RegisterForClicks("AnyDown", "AnyUp") -- dragonflight: anydown+anyup required to function

	popup:SetAttribute("type", "macro")
	-- macrotext is set elsewhere
	popup:SetAttribute("macrotext2", "/click " .. popup:GetName() .. "CloseButton")

	popup:Hide()

	-- art
	local background = popup:CreateTexture(nil, "BORDER", nil, 1)
	popup.background = background
	background:SetBlendMode("BLEND")

	local modelbg = popup:CreateTexture(nil, "BORDER", nil, 2)
	popup.modelbg = modelbg
	modelbg:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
	modelbg:SetSize(52, 52)

	local model = CreateFrame("PlayerModel", nil, popup)
	popup.model = model
	local modelfallback = model:CreateTexture(nil, "ARTWORK")
	modelfallback:SetAllPoints(model)
	modelfallback:Hide()
	model.fallback = modelfallback

	local raidIcon = model:CreateTexture(nil, "OVERLAY")
	popup.raidIcon = raidIcon
	raidIcon:SetSize(16, 16)
	raidIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	raidIcon:Hide()

	local lootIcon = CreateFrame("Button", nil, popup)
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
	lootIcon.count = lootIcon:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")
	lootIcon.count:SetAllPoints(lootIcon)

	local dead = model:CreateTexture(nil, "OVERLAY")
	popup.dead = dead
	dead:SetAtlas([[XMarksTheSpot]])
	dead:SetAlpha(0)

	-- text
	local title = popup:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3");
	popup.title = title
	title:SetSize(167, 33)
	title:SetJustifyH("CENTER")
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
	shine.animIn.translate = shineTranslate

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

	popup.lootIcon:SetScript("OnEnter", popup.scripts.LootOnEnter)
	popup.lootIcon:SetScript("OnLeave", popup.scripts.LootOnLeave)
	popup.lootIcon:SetScript("OnClick", popup.scripts.LootOnClick)
	popup.lootIcon:SetScript("OnHide", popup.scripts.LootOnHide)

	self:ApplyLook(popup, look)

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
	if icon then
		SetRaidTargetIconTexture(self.raidIcon, icon)
		self.raidIcon:Show()
	else
		self.raidIcon:Hide()
	end
end

function PopupMixin:SetSource(source)
	self.source:SetText(source or "")
end

function PopupMixin:DoIgnore()
	if not (self.data and self.data.id) then return end
	if self.data.type == "loot" then
		local vignette = core:GetModule("Scan_Vignettes", true)
		if vignette then
			vignette.db.profile.ignore[self.data.id] = self.data.name
		end
	else
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
	self.lootIcon:Hide()
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
		if self.waitingToHide or not self.data then
			-- we're "hidden" via alpha==0 now, so no tooltip
			return
		end
		local data = self.data

		local anchor = (self:GetCenter() < (UIParent:GetWidth() / 2)) and "ANCHOR_RIGHT" or "ANCHOR_LEFT"
		GameTooltip:SetOwner(self, anchor, 0, -60)
		if data.type == "mob" then
			GameTooltip:AddDoubleLine(escapes.leftClick .. " " .. TARGET, escapes.rightClick .. " " .. CLOSE)
			core:GetModule('Tooltip'):UpdateTooltip(data.id)
		else
			GameTooltip:AddDoubleLine(" ", escapes.rightClick .. " " .. CLOSE)
			-- GameTooltip:AddLine(data.name)
			-- tooltip, id, only_knowable, is_treasure
			ns.Loot.Summary.UpdateTooltip(GameTooltip, data.id, nil, true)
			if ns.vignetteTreasureLookup[data.id] and ns.vignetteTreasureLookup[data.id].notes then
				GameTooltip:AddLine(core:RenderString(ns.vignetteTreasureLookup[data.id].notes), 1, 1, 1, true)
			end
		end
		local uiMapID, x, y = module:GetPositionFromData(data, false)
		if uiMapID and x and y then
			GameTooltip:AddDoubleLine(core.zone_names[uiMapID] or UNKNOWN, (x ~= 0 and y ~= 0) and ("%.1f, %.1f"):format(x * 100, y * 100) or UNKNOWN,
				0, 1, 0,
				0, 1, 0
			)
		else
			GameTooltip:AddDoubleLine("Location", UNKNOWN,
				0, 1, 0,
				1, 0, 0
			)
		end
		if data.vignetteID then
			GameTooltip:AddDoubleLine("Vignette ID", self.data.vignetteID, 0, 1, 1, 0, 1, 1)
		end

		GameTooltip:AddDoubleLine(ALT_KEY_TEXT .. " + " .. escapes.leftClick .. " + " .. DRAG_MODEL, MOVE_FRAME)
		if module:CanPoint(uiMapID) then
			GameTooltip:AddDoubleLine(CTRL_KEY_TEXT .. " + " .. escapes.leftClick, MAP_PIN )
		end
		if uiMapID and x and y then
			GameTooltip:AddDoubleLine(SHIFT_KEY_TEXT .. " + " .. escapes.leftClick, TRADESKILL_POST )
		end
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
			if not self.model:GetModelFileID() and not self.model.fallback:IsShown() then
				-- Sometimes models don't load the first time you request them for some reason. In this case,
				-- re-requesting it seems to be needed. This might be a client bug, so testing whether it's still
				-- necessary would be wise. (Added in 70100, reproducing by flying around Pandaria works pretty well.)
				Debug("Poll for model reload")
				module:SetModel(self)
			end
			self.elapsed = 0
		end
	end,
	OnMouseDown = function(self, button)
		if self.waitingToHide then
			return
		end
		if button == "RightButton" then
			-- handled in the secure click handler
			return
		elseif IsControlKeyDown() then
			module:Point(self.data)
		elseif IsShiftKeyDown() then
			module:SendLinkFromData(self.data)
		elseif IsAltKeyDown() then
			module.anchor:StartMoving()
		end
	end,
	OnMouseUp = function(self, button)
		module.anchor:StopMovingOrSizing()
		if not InCombatLockdown() then
			LibWindow.SavePosition(module.anchor)
			module:Reflow()
		end
	end,
	-- hooked:
	OnShow = function(self)
		if not self.data then
			-- Things which show/hide UIParent (cinematics) *might* get us here without data
			return self:HideWhenPossible()
		end
		module:ResetLook(self)

		self:SetAlpha(1)
		self:SetScale(module.db.profile.anchor.scale)

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

		core.events:Fire("PopupShow", self.data, self)
	end,
	OnHide = function(self)
		if self.data then
			-- Things which show/hide UIParent (cinematics) *might* get us here without data
			core.events:Fire("PopupHide", self.data, self.automaticClose)
		end

		if not InCombatLockdown() then
			LibWindow.SavePosition(module.anchor)
		end

		self.waitingToHide = false
		self.automaticClose = nil

		module:Release(self)
	end,
	-- Close button
	CloseOnEnter = function(self)
		if self:GetParent().waitingToHide then
			return
		end
		local anchor = (self:GetCenter() < (UIParent:GetWidth() / 2)) and "ANCHOR_RIGHT" or "ANCHOR_LEFT"
		GameTooltip:SetOwner(self, anchor, 0, 0)
		GameTooltip:AddLine(escapes.leftClick .. " " .. CLOSE)
		GameTooltip:AddLine(escapes.rightClick .. " " .. IGNORE)
		GameTooltip:Show()
	end,
	CloseOnLeave = function(self)
		GameTooltip:Hide()
	end,
	-- Loot icon
	LootOnEnter = function(self)
		if self:GetParent().waitingToHide then
			return
		end
		local data = self:GetParent().data
		if not (data and data.id) then return end
		local anchor = (self:GetCenter() < (UIParent:GetWidth() / 2)) and "ANCHOR_RIGHT" or "ANCHOR_LEFT"
		GameTooltip:SetOwner(self, anchor, 0, 0)
		GameTooltip:SetFrameStrata("TOOLTIP")
		if data.type == "mob" then
			GameTooltip:AddDoubleLine(core:GetMobLabel(data.id), "Loot")
		else
			GameTooltip:AddDoubleLine(data.name or UNKNOWN, "Loot")
		end
		ns.Loot.Summary.UpdateTooltip(GameTooltip, data.id, false, data.type == "loot")
		GameTooltip:AddLine(CLICK_FOR_DETAILS, 0, 1, 1)
		GameTooltip:Show()
	end,
	LootOnLeave = function(self)
		GameTooltip:Hide()
	end,
	LootOnClick = function(self, button)
		if self:GetParent().waitingToHide then
			return
		end
		if not self.window then
			local data = self:GetParent().data
			self.window = ns.Loot.Window.ShowForMob(data.id, false, data.type == "loot")
			self.window:SetParent(self)
			self.window:Hide()
		end
		if not self.window:IsShown() then
			self.window:ClearAllPoints()
			if self:GetParent():GetCenter() > UIParent:GetCenter() then
				self.window:SetPoint("RIGHT", self:GetParent(), "LEFT")
			else
				self.window:SetPoint("LEFT", self:GetParent(), "RIGHT")
			end
			self.window:Show()
		else
			self.window:Hide()
		end
	end,
	LootOnHide = function(self)
		if self.window then
			ns.Loot.Window.Release(self.window)
		end
		self.window = nil
	end,
	-- Common animations
	AnimationHideParent = function(self)
		self:GetParent():Hide()
	end,
	AnimationRequestHideParent = function(self)
		local parent = self:GetParent()
		if parent.model:IsVisible() then
			-- 10.0 bug: the models within a Model don't inherit alpha
			-- We *can* directly set the interior model alpha, though
			parent.model:SetModelAlpha(0)
		end
		parent:HideWhenPossible()
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
