local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("ClickTarget", "AceEvent-3.0")
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

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("ClickTarget", {
		profile = {
			show = true,
			locked = true,
			style = "SilverDragon",
			sources = {
				target = false,
				grouptarget = true,
				mouseover = true,
				nameplate = true,
				vignette = true,
				['point-of-interest'] = true,
				groupsync = true,
				guildsync = false,
				fake = true,
			},
		},
	})
	core.RegisterCallback(self, "Announce")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.clicktarget = {
			clicktarget = {
				type = "group",
				name = "ClickTarget",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v)
					self.db.profile[info[#info]] = v
					local oldpopup = self.popup
					self.popup = self:CreatePopup()
					if oldpopup:IsVisible() then
						self:ShowFrame()
					end
					oldpopup:Hide()
				end,
				args = {
					about = config.desc("Once you've found a rare, it can be nice to actually target it. So this pops up a frame that targets the rare when you click on it. It can show a 3d model of that rare, but only if we already know the ID of the rare (though a data import), or if it was found by being targetted. Nameplates are right out.", 0),
					show = config.toggle("Show", "Show the click-target frame.", 10),
					locked = config.toggle("Locked", "Lock the click-target frame in place unless ALT is held down", 15),
					sources = {
						type="multiselect",
						name = "Rare Sources",
						desc = "Which ways of finding a rare should cause this frame to appear?",
						get = function(info, key) return self.db.profile.sources[key] end,
						set = function(info, key, v) self.db.profile.sources[key] = v end,
						values = {
							target = "Targets",
							grouptarget = "Group targets",
							mouseover = "Mouseover",
							nameplate = "Nameplates",
							vignette = "Vignettes",
							['point-of-interest'] = "Map Points of Interest",
							groupsync = "Group Sync",
							guildsync = "Guild Sync",
						},
					},
					style = {
						type = "select",
						name = "Style",
						desc = "Appearance of the frame",
						values = {},
					},
				},
			},
		}
		for key in pairs(self.Looks) do
			config.options.plugins.clicktarget.clicktarget.args.style.values[key] = key
		end
	end

	self.popup = self:CreatePopup()
end

local current = {}
function module:ShowFrame()
	if not self.db.profile.show then return end
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

	-- reset the model
	popup.model:ClearModel()
	popup.model:SetModelScale(1)
	popup.model:SetPosition(0, 0, 0)
	popup.model:SetFacing(0)

	if (current.id or current.unit) and not self:IsModelBlacklisted(current.id, current.unit) then
		if current.id then
			popup.model:SetCreature(current.id)
		else
			popup.model:SetUnit(current.unit)
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

function module:Announce(callback, id, zone, x, y, dead, source, unit)
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" then
			source = "guildsync"
		else
			source = "groupsync"
		end
	end
	if not self.db.profile.sources[source] then
		return
	end
	current.id = id
	current.unit = unit
	current.source = source
	current.dead = dead
	if InCombatLockdown() then
		current.pending = true
	else
		self:ShowFrame()
	end
	FlashClientIcon() -- If you're tabbed out, bounce the WoW icon if we're in a context that supports that
	current.unit = nil -- can't be trusted to remain the same
end

function module:PLAYER_REGEN_ENABLED()
	if current.pending then
		current.pending = nil
		self:ShowFrame()
	end
end

function module:ShouldBeDraggable()
	return (not self.db.profile.locked) or IsModifierKeyDown()
end

function module:ApplyLook(popup, look)
	-- Many values cribbed from AlertFrameSystem.xml
	(self.Looks[look] or self.Looks.LessAwesome)(self, popup)
end
module.Looks = {}
function module.Looks:SilverDragon(popup)
	-- The "zomg legendary, but a bit more silver" look
	module.Looks.Legendary(self, popup)
	popup.background:SetDesaturated(true)
end
function module.Looks:Legendary(popup)
	popup:SetSize(302, 119)

	-- left, right, top, bottom
	popup:SetHitRectInsets(20, 0, 15, 15)

	popup.background:SetSize(276, 96)
	popup.background:SetAtlas("LegendaryToast-background", true)
	popup.background:SetPoint("CENTER")

	popup.close:SetPoint("TOPRIGHT", -18, -24)

	popup.modelbg:SetPoint("TOPLEFT", 48, -32)
	self:SizeModel(popup, 4)

	popup.title:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 11, -16)
	popup.source:SetPoint("BOTTOMRIGHT", -20, 26)

	popup.status:SetSize(160, 22)
	popup.status:SetPoint("TOPLEFT", 107, -26)

	popup.glow:SetSize(298, 109)
	popup.glow:SetPoint("CENTER", 10, 1)

	popup.shine:SetSize(171, 75)
	popup.shine:SetPoint("BOTTOMLEFT", 10, 24)
end
function module.Looks:LessAwesome(popup)
	-- The "loot, not an upgrade" look
	popup:SetSize(276, 96)

	popup.background:SetSize(276, 96)
	popup.background:SetAtlas("LootToast-LessAwesome", true)
	popup.background:SetPoint("CENTER")

	popup.close:SetPoint("TOPRIGHT", -12, -18)

	popup.modelbg:SetPoint("LEFT", 20, 0)
	self:SizeModel(popup, 7)

	popup.title:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 10, -7)
	popup.source:SetPoint("BOTTOMRIGHT", -20, 20) -- (-14, 4) is a better outside position

	popup.status:SetFontObject("GameFontNormalSmallLeft")
	popup.status:SetSize(157, 10)
	popup.status:SetPoint("TOPLEFT", popup.title, "TOPLEFT", 0, 3)

	popup.glow:SetSize(266, 109)
	popup.glow:SetPoint("TOPLEFT", -10)
	popup.glow:SetPoint("BOTTOMRIGHT", 10)

	popup.shine:SetSize(171, 60)
	popup.shine:SetPoint("BOTTOMLEFT", -10, 12)
end
function module.Looks:Transmog(popup)
	popup:SetSize(253, 75)

	popup.background:SetSize(253, 75)
	popup.background:SetAtlas("transmog-toast-bg", true)
	popup.background:SetPoint("CENTER")

	popup.close:SetPoint("TOPRIGHT", -12, -12)

	popup.modelbg:SetPoint("LEFT", 10, 0)
	self:SizeModel(popup, 7)

	popup.title:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 10, -10)
	popup.source:SetPoint("BOTTOMRIGHT", -18, 18)

	popup.status:SetFontObject("GameFontNormalSmallLeft")
	popup.status:SetSize(157, 10)
	popup.status:SetPoint("TOPLEFT", popup.title, "TOPLEFT", 0, 3)

	popup.glow:SetSize(253, 75)
	popup.glow:SetPoint("TOPLEFT", -10)
	popup.glow:SetPoint("BOTTOMRIGHT", 10)

	popup.shine:SetSize(120, 45)
	popup.shine:SetPoint("BOTTOMLEFT", -10, 12)
end
function module.Looks:Classic(popup)
	-- The <v4 SilverDragon look
	popup:SetSize(190, 70)

	-- popup.background:SetSize(190, 70)
	popup.background:SetTexture([[Interface\AchievementFrame\UI-Achievement-Parchment-Horizontal]])
	popup.background:ClearAllPoints()
	popup.background:SetPoint("BOTTOMLEFT", 3, 3)
	popup.background:SetPoint("TOPRIGHT", -3, -3)
	popup.background:SetTexCoord(0, 1, 0, 0.25)

	popup:SetBackdrop({
		tile = true, edgeSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	})
	popup:SetBackdropBorderColor(0.7, 0.15, 0.05)

	popup.close:SetPoint("TOPRIGHT", -3, -3)

	-- popup.modelbg:SetPoint("BOTTOMLEFT", 3, 3)
	popup.modelbg:SetSize(popup:GetHeight() - 20, popup:GetHeight() - 20)
	popup.modelbg:SetPoint("TOPLEFT", popup.title, "BOTTOMLEFT", 0, -2)
	popup.modelbg:SetPoint("BOTTOMLEFT", popup, "BOTTOMLEFT", 4, 4)
	self:SizeModel(popup, 0, 0)

	popup.title:SetFontObject("GameFontHighlightMedium")
	popup.title:SetHeight(18)
	popup.title:SetPoint("TOPLEFT", popup, "TOPLEFT", 6, -6)
	popup.title:SetPoint("RIGHT", popup, "RIGHT", -20, 0)

	popup.source:SetFontObject("GameFontWhite")
	popup.source:SetPoint("TOPLEFT", popup.modelbg, "TOPRIGHT", 3, -3)
	popup.source:SetPoint("RIGHT", 0, 0)
	popup.source:SetJustifyH("CENTER")

	popup.status:SetFontObject("GameFontWhite")
	popup.status:SetPoint("TOPLEFT", popup.source, 0, -12)
	popup.status:SetPoint("RIGHT", 0, 0)
	popup.status:SetJustifyH("CENTER")

	-- popup.glow:SetSize(190, 110)
	popup.glow:SetPoint("TOPLEFT", -20)
	popup.glow:SetPoint("BOTTOMRIGHT", 20)

	popup.shine:SetSize(120, 60)
	popup.shine:SetPoint("TOPLEFT", -10, -3)
	
	select(3, popup.shine.animIn:GetAnimations()):SetOffset(70, 0)
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

		self.model:ClearModel()
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
