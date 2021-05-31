local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("ClickTarget", "AceEvent-3.0")
local Debug = core.Debug

local LibWindow = LibStub("LibWindow-1.1")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

module.Looks = {}
module.LookConfig = {}
module.LookReset = {}
module.defaults = {
	profile = {
		show = true,
		locked = true,
		style = "SilverDragon",
		closeAfter = 30,
		closeDead = true,
		announce = "IMMEDIATELY", -- or "OPENLAST"
		announceChannel = "CHANNEL",
		sources = {
			target = false,
			grouptarget = true,
			mouseover = true,
			nameplate = true,
			--vignette = true,
			--['point-of-interest'] = true,
			--chat = true,
			groupsync = true,
			guildsync = false,
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

local db
function module:OnInitialize()
	self.db = core.db:RegisterNamespace("ClickTarget", self.defaults)
	db = self.db.profile

	core.RegisterCallback(self, "Announce")
	core.RegisterCallback(self, "Marked")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	self.anchor = self:CreateAnchor()

	self:RegisterConfig()
end

local pending
function module:Announce(callback, id, zone, x, y, dead, source, unit)
	if not db.show then return end
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" then
			source = "guildsync"
		else
			source = "groupsync"
		end
	end
	if not db.sources[source] then
		Debug("Not showing popup, source disabled", source)
		return
	end
	local data = {
		id = id,
		unit = unit,
		source = source,
		dead = dead,
		x = x or 0,
		y = y or 0,
	}
	if InCombatLockdown() then
		pending = data
	else
		self:ShowFrame(data)
	end
	FlashClientIcon() -- If you're tabbed out, bounce the WoW icon if we're in a context that supports that
	data.unit = nil -- can't be trusted to remain the same
end

function module:Marked(callback, id, marker, unit)
	if self.popup and self.popup.data and self.popup.data.id == id then
		self.popup:SetRaidIcon(marker)
	end
end

function module:PLAYER_REGEN_ENABLED()
	if pending then
		self:ShowFrame(pending)
		pending = nil
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

function module:SendLinkToMob(id, uiMapID, x, y)
	local unit = core:FindUnitWithID(id)
	local text = ("%s %s"):format(
		core:NameForMob(id, unit),
		(unit and ('(' .. math.ceil(UnitHealth(unit) / UnitHealthMax(unit) * 100) .. '%) ') or '')
	)
	-- if you have an open editbox, just paste to it
	if not ChatEdit_InsertLink(text) then
		-- then do whatever's configured
		if db.announce == "OPENLAST" then
			ChatFrame_OpenChat(text)
		elseif db.announce == "IMMEDIATELY" then
			local generalID
			if db.announceChannel == "CHANNEL" then
				generalID = module:GetGeneralID()
				if not generalID then
					ChatFrame_OpenChat(text)
					return
				end
			end
			Debug("SendChatMessage", text, db.announceChannel, generalID)
			SendChatMessage(
				text,
				db.announceChannel,
				nil, -- use default language
				db.announceChannel == "CHANNEL" and generalID or nil
			)
		end
	end
end

function module:CreateAnchor()
	local anchor = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
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
	title:SetText(myname)
	title:SetWidth(anchor:GetWidth())

	local text = anchor:CreateFontString(nil, "BORDER", "FriendsFont_Normal")
	text:SetSize(anchor:GetWidth() - 20, 24)
	text:SetJustifyH("MIDDLE")
	text:SetJustifyV("TOP")
	text:SetWordWrap(true)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	text:SetText("Target buttons will appear here")

	local close = CreateFrame("Button", nil, anchor, "UIPanelCloseButton")
	close:SetSize(24, 24)
	close:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", -2, -2)

	anchor:SetHeight(text:GetStringHeight() + title:GetStringHeight() + 25)

	LibWindow.RegisterConfig(anchor, db.anchor)
	LibWindow.RestorePosition(anchor)
	LibWindow.MakeDraggable(anchor)

	anchor:HookScript("OnDragStop", function()
		AceConfigRegistry:NotifyChange(myname)
	end)

	return anchor
end
