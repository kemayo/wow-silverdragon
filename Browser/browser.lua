local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Browser", "AceEvent-3.0")
local Debug = core.Debug

local LibWindow = LibStub("LibWindow-1.1")

-- Looks work as the click-target popup's do, and for the same reason: one window,
-- built once by window.lua, which each look positions and skins. A look must
-- never create anything. window.lua lists the parts one can rely on.
module.Looks = {}
module.LookReset = {}
module.LookConfig = {}

module.defaults = {
	profile = {
		style = "Traditional",
		style_options = {['*'] = {}},
		model = true,
		showMap = true,
		-- with a rare picked, whether the rest of its zone stays on the map, dimmed
		mapShowAll = true,
		-- what the second level of the tree lists
		grouping = "zone", -- zone / achievement / loot
		-- whether the tree starts with a level per expansion, or goes straight to
		-- zones with every expansion's mobs merged
		groupBySource = true,
		filterIgnored = "show", -- show / hide / only
		filterWatched = false,
		-- only what has been opened is remembered
		expanded = {},
		-- no width or height: the window sizes itself from what it has to show
		position = {
			point = "CENTER",
			x = 0,
			y = 0,
			scale = 1,
		},
	},
}

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Browser", self.defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

	self:RegisterConfig()
end

function module:OnEnable()
	-- Deliberately nothing built here. History can make its window at login
	-- because its list starts empty; this one would have to walk every mob.
	core.RegisterCallback(self, "Ready", "OnDataReady")
	core.RegisterCallback(self, "IgnoreChanged", "InvalidateMob")
	core.RegisterCallback(self, "CustomChanged", "InvalidateMob")
	core.RegisterCallback(self, "Seen", "InvalidateMob")
	core.RegisterCallback(self, "OptionsChanged", "InvalidateAll")
	self:RegisterEvent("LOOT_CLOSED", "InvalidateAll")
	-- phasing can swap a zone's art out from under us
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "RefreshMap")
end

function module:OnDisable()
	core.UnregisterAllCallbacks(self)
	self:UnregisterAllEvents()
	if self.window then
		self.window:Hide()
	end
end

function module:RefreshConfig()
	if not self.window then return end
	LibWindow.RegisterConfig(self.window, self.db.profile.position)
	LibWindow.RestorePosition(self.window)
	self:ResetLook(self.window)
	self:ApplyLook(self.window, self.db.profile.style)
	self:InvalidateAll()
end

-- Looks

function module:ApplyLook(window, look)
	(self.Looks[look] or self.Looks.Traditional)(self, window, self.db.profile.style_options[look])
	window.look = look
end

function module:ResetLook(window)
	if not (window.look and self.LookReset[window.look]) then return end
	self.LookReset[window.look](self, window, self.db.profile.style_options[window.look])
end

function module:SetLook(look)
	self.db.profile.style = look
	if not self.window then return end
	self:ResetLook(self.window)
	self:ApplyLook(self.window, look)
	self:Refresh()
end

function module:RegisterLookConfig(look, config, defaults, reset)
	self.LookConfig[look] = {
		type = "group",
		name = look:gsub("_", ": "),
		args = config,
		inline = true,
	}
	if defaults then
		self.defaults.profile.style_options[look] = defaults
		if self.db then
			self.db:RegisterDefaults(self.defaults)
		end
	end
	self.LookReset[look] = reset
end

-- The six-state icons are core's, but the theme to draw them in is the overlay's
-- option, and the overlay ships as its own addon. Fall back, do not depend on it.
function module:IconTheme()
	local overlay = core:GetModule("Overlay", true)
	local theme = overlay and overlay.db and overlay.db.profile.icon_theme
	return (theme and ns.MobStateIcons[theme]) and theme or "skulls"
end

-- Showing it

function module:Open()
	if not self.window then
		self.window = self:CreateWindow()
		self:ApplyLook(self.window, self.db.profile.style)
		self:UpdateHeaderButtons()
		-- the criteria scan is lazy, and the achievement branches need it
		ns:LoadAllAchievementMobs()
		self:Refresh()
	end
	self.window:Show()
	return self.window
end

function module:Toggle()
	if self.window and self.window:IsShown() then
		self.window:Hide()
		return self.window
	end
	return self:Open()
end
