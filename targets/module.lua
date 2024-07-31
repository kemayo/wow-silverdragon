local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("ClickTarget", "AceEvent-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-2.0")
local LibWindow = LibStub("LibWindow-1.1")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

module.Looks = {}
module.LookConfig = {}
module.LookReset = {}
module.defaults = {
	profile = {
		show = true,
		loot = true,
		locked = true,
		style = "SilverDragon",
		closeAfter = 30,
		closeDead = true,
		stacksize = 4,
		model = true,
		announce = "IMMEDIATELY", -- or "OPENLAST"
		announceChannel = "CHANNEL",
		sources = {
			target = false,
			grouptarget = true,
			mouseover = true,
			nameplate = true,
			vignette = true,
			['point-of-interest'] = true,
			chat = true,
			groupsync = true,
			guildsync = false,
			darkmagic = true,
			fake = true,
		},
		anchor = {
			point = "BOTTOMRIGHT",
			x = -260,
			y =  270,
			scale = 1,
		},
		style_options = {
			['*'] = {},
		},
	},
}

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("ClickTarget", self.defaults)

	core.RegisterCallback(self, "Announce")
	core.RegisterCallback(self, "AnnounceLoot")
	core.RegisterCallback(self, "Marked")
	core.RegisterCallback(self, "SeenVignette")
	core.RegisterCallback(self, "SeenLoot")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "ProcessQueue")

	self.anchor = self:CreateAnchor()

	self:RegisterConfig()
end

local pending
function module:Announce(callback, id, zone, x, y, dead, source, unit, _, vignetteGUID)
	if not self.db.profile.show then return end
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" then
			source = "guildsync"
		else
			source = "groupsync"
		end
	end
	if not self.db.profile.sources[source] then
		Debug("Not showing popup, source disabled", source)
		return
	end
	local data = {
		type = "mob",
		id = id,
		unit = unit,
		source = source,
		dead = dead,
		zone = zone,
		x = x or 0,
		y = y or 0,
		vignetteGUID = vignetteGUID,
	}
	if vignetteGUID then
		local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID)
		if vignetteInfo then
			data.vignetteID = vignetteInfo.vignetteID
		end
	end
	self:Enqueue(data)
	FlashClientIcon() -- If you're tabbed out, bounce the WoW icon if we're in a context that supports that
	data.unit = nil -- can't be trusted to remain the same
end
function module:AnnounceLoot(_, name, id, zone, x, y, vignetteGUID)
	if not self.db.profile.loot then return end
	local data = {
		type = "loot",
		id = id,
		name = name,
		zone = zone,
		x = x or 0,
		y = y or 0,
		vignetteGUID = vignetteGUID,
		vignetteID = id,
	}
	self:Enqueue(data)
	FlashClientIcon() -- If you're tabbed out, bounce the WoW icon if we're in a context that supports that
end
function module:SeenVignette(_, name, vignetteID, atlasName, uiMapID, x, y, vignetteGUID, mobid)
	if not mobid then return end
	self:UpdateWithData({
		type = "mob",
		id = mobid,
		vignetteGUID = vignetteGUID,
		vignetteID = vignetteID,
		zone = uiMapID,
		x = x,
		y = y,
		source = "vignette",
	})
end
function module:SeenLoot(_, name, vignetteID, uiMapID, x, y, vignetteGUID)
	self:UpdateWithData({
		type = "loot",
		id = vignetteID,
		vignetteGUID = vignetteGUID,
		vignetteID = vignetteID,
		zone = uiMapID,
		x = x,
		y = y,
		source = "vignette",
	})
end

function module:CanPoint(uiMapID)
	return core:GetModule("TomTom"):CanPointTo(uiMapID)
end

function module:Point(data)
	local uiMapID, x, y = self:GetPositionFromData(data)
	if uiMapID and x and y then
		-- point to it, without a timeout, and ignoring whether it'll be replacing an existing waypoint
		core:GetModule("TomTom"):PointTo(data.type == "mob" and data.id or data.name, uiMapID, x, y, 0, true)
	end
end

function module:Marked(callback, id, marker, unit)
	for popup in self:EnumerateActive() do
		if popup.data and popup.data.id == id then
			popup:SetRaidIcon(marker)
		end
	end
end

function module:GetGeneralID()
	local channelFormat = GetLocale() == "ruRU" and "%s: %s" or "%s - %s"
	local zoneText = GetZoneText()
	local general = EnumerateServerChannels()
	if zoneText == nil or general == nil then return false end
	local id = GetChannelName(channelFormat:format(general, zoneText))
	return (id and id > 0) and id
end

function module:SendLink(prefix, uiMapID, x, y)
	local message
	if MAP_PIN_HYPERLINK then
		message = ("%s|cffffff00|Hworldmap:%d:%d:%d|h[%s]|h|r"):format(
			prefix and (prefix .. " ") or "",
			uiMapID,
			x * 10000,
			y * 10000,
			-- Can't do this:
			-- core:GetMobLabel(self.data.id) or UNKNOWN
			-- WoW seems to filter out anything which isn't the standard MAP_PIN_HYPERLINK
			MAP_PIN_HYPERLINK
		)
		PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CHAT_SHARE)
	else
		-- classic
		message = prefix
	end
	-- if you have an open editbox, just paste to it
	if not ChatEdit_InsertLink(message) then
		-- then do whatever's configured
		if self.db.profile.announce == "OPENLAST" then
			ChatFrame_OpenChat(message)
		elseif self.db.profile.announce == "IMMEDIATELY" then
			local generalID
			if self.db.profile.announceChannel == "CHANNEL" then
				generalID = module:GetGeneralID()
				if not generalID then
					ChatFrame_OpenChat(message)
					return
				end
			end
			Debug("SendChatMessage", message, self.db.profile.announceChannel, generalID)
			SendChatMessage(
				message,
				self.db.profile.announceChannel,
				nil, -- use default language
				self.db.profile.announceChannel == "CHANNEL" and generalID or nil
			)
		end
	end
end

function module:SendLinkToMob(id, uiMapID, x, y)
	local unit = core:FindUnitWithID(id)
	local prefix = core:NameForMob(id, unit)
	if unit then
		prefix = ("%s %s"):format(prefix, ('(' .. math.ceil(UnitHealth(unit) / UnitHealthMax(unit) * 100) .. '%)'))
	end
	self:SendLink(prefix, uiMapID, x, y)
end

function module:SendLinkToLoot(name, uiMapID, x, y)
	self:SendLink(name, uiMapID, x, y)
end

function module:SendLinkFromData(data)
	-- worldmap:uiMapId:x:y
	local uiMapID, x, y = module:GetPositionFromData(data)
	if data.type == "mob" then
		self:SendLinkToMob(data.id, uiMapID, x, y)
	elseif data.type == "loot" then
		self:SendLinkToLoot(data.name, uiMapID, x, y)
	end
end

function module:GetPositionFromData(data, allowFallback)
	local x, y, uiMapID = data.x, data.y, data.zone
	if uiMapID and data.vignetteGUID then
		local position = C_VignetteInfo.GetVignettePosition(data.vignetteGUID, uiMapID)
		if position then
			x, y = position:GetXY()
		end
	end
	if not (x and y and x > 0 and y > 0) and data.type == "mob" then
		uiMapID, x, y = core:GetClosestLocationForMob(data.id)
	end
	if allowFallback and not (x and y and x > 0 and y > 0) then
		-- fall back to sending a link to the current position
		x, y, uiMapID = HBD:GetPlayerZonePosition()
	end
	return uiMapID, x, y
end

function module:CreateAnchor()
	local anchor = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	anchor:SetSize(250, 100)
	anchor:SetFrameStrata("DIALOG")
	anchor:SetBackdrop({
		bgFile = [[Interface\FriendsFrame\UI-Toast-Background]],
		edgeFile = [[Interface\FriendsFrame\UI-Toast-Border]],
		edgeSize = 12,
		tile = true,
		tileSize = 12,
		insets = { left = 5, right = 5, top = 5, bottom = 5, },
	})

	anchor:EnableMouse(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:SetClampedToScreen(true)
	anchor:Hide()

	local title = anchor:CreateFontString(nil, "BORDER", "FriendsFont_Normal")
	title:SetJustifyH("CENTER")
	title:SetJustifyV("MIDDLE")
	title:SetWordWrap(true)
	title:SetPoint("TOPLEFT", anchor, "TOPLEFT", 15, -10)
	title:SetPoint("RIGHT", anchor, "RIGHT", -20, 10)
	title:SetText(myname .. " " .. TARGET)
	title:SetWidth(anchor:GetWidth())

	local text = anchor:CreateFontString(nil, "BORDER", "FriendsFont_Normal")
	text:SetSize(anchor:GetWidth() - 20, 24)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("TOP")
	text:SetWordWrap(true)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	text:SetText("Target buttons will appear here")

	local close = CreateFrame("Button", nil, anchor, "UIPanelCloseButton")
	close:SetSize(24, 24)
	close:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", -2, -2)

	anchor:SetHeight(text:GetStringHeight() + title:GetStringHeight() + 25)

	LibWindow.RegisterConfig(anchor, self.db.profile.anchor)
	LibWindow.RestorePosition(anchor)
	LibWindow.MakeDraggable(anchor)

	anchor:HookScript("OnDragStop", function()
		AceConfigRegistry:NotifyChange(myname)
	end)

	return anchor
end
