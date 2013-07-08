local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Range", "AceEvent-3.0")
local Debug = core.Debug

local DETECTION_RANGE = 100 -- a number chosen, as much as anything, so that people will get what they're used to from NPCscan

local globaldb
function module:OnInitialize()
	globaldb = core.db.global

	self.db = core.db:RegisterNamespace("Range", {
		profile = {
			enabled = true,
			smarthide = true,
		},
	})
	self.db.RegisterCallback(self, "OnProfileChanged", "Update")
	self.db.RegisterCallback(self, "OnProfileCopied", "Update")
	self.db.RegisterCallback(self, "OnProfileReset", "Update")

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.outputs.plugins.range = {
			range = {
				type = "group",
				name = "Range ring",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v; self:Update() end,
				args = {
					about = config.desc("We can put a ring on the minimap showing your approximate cache detection range. This will mostly be accurate for mobs around your own size... giant ones can be detected across entire zones.", 0),
					enabled = config.toggle("Show it", nil, 30),
					smarthide = config.toggle("Hide if we don't know about rares in this zone", nil, 40),
				},
			},
		}
	end

	hooksecurefunc(Minimap, "SetZoom", function(frame, zoom, ...)
		self:Update()
	end)

	-- So, we need a scrollframe because the texture below can become bigger than the minimap, and we need it to cut off gracefully
	local scroll = CreateFrame("ScrollFrame", nil, Minimap)
	scroll:SetAllPoints()

	-- Then we need a frame to go inside the scrollframe...
	local ring = CreateFrame("Frame", nil, scroll)
	scroll:SetScrollChild(ring)

	ring:ClearAllPoints()
	ring:SetPoint("CENTER")
	ring:SetSize(Minimap:GetSize())
	ring:SetAlpha(0.8)

	-- And finally, we need the texture we're going to be displaying
	local tex = ring:CreateTexture()
	tex:SetTexture([[SPELLS\CIRCLE]])
	tex:SetBlendMode("ADD")
	tex:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	tex:SetAllPoints()
	ring.tex = tex

	-- Hold onto a reference to it, so we can fiddle with its scale below
	self.ring = ring
	ring:Hide()
end

function module:OnEnable()
	self:RegisterEvent("MINIMAP_UPDATE_ZOOM")
	core.RegisterCallback(self, "ZoneChanged", "Update")
	self:Update()
end

function module:Update()
	local show = self.db.profile.enabled
	if show and self.db.profile.smarthide then
		local announce = core:GetModule("Announce", true)
		local zone = core:GetPlayerZone()
		if announce then
			show = announce:CareAboutZone(zone)
		end
		if show then
			show = core:ZoneContainsMobs(zone)
		end
	end
	if not show then
		return self.ring:Hide()
	end
	self.ring:Show()
	self.ring:SetScale(DETECTION_RANGE / self:GetRadius())
end

function module:MINIMAP_UPDATE_ZOOM()
	-- this is the swap between indoor and outdoor zoom levels, not player-triggered zoom changes
	local zoom = Minimap:GetZoom()
	local changed
	if GetCVar("minimapZoom") == GetCVar("minimapInsideZoom") then
		-- change the cvars a teensy bit, so that they won't be equal...
		Minimap:SetZoom(zoom > 0 and zoom - 1 or zoom + 1)
		changed = true
	end
	self.inside = Minimap:GetZoom() == GetCVar("minimapInsideZoom") + 0
	if changed then
		Minimap:SetZoom(zoom)
	end
	self:Update()
end

-- translating approximate radii of the minimap in yards to the zoom levels used by GetZoom
local radii_inside = {150, 120, 90, 60, 40, 25}
local radii_outside = {233 + 1 / 3, 200, 166 + 2 / 3, 133 + 1 / 3, 100, 66 + 2 / 3}
function module:GetRadius()
	return (self.inside and radii_inside or radii_outside)[Minimap:GetZoom() + 1]
end
