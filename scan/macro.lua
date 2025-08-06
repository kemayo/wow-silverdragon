local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Macro", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug
local DebugF = core.DebugF

local HBD = LibStub("HereBeDragons-2.0")

function module:OnInitialize()
	self.vignettesExist = C_EventUtils.IsEventValid("VIGNETTE_MINIMAP_UPDATED")
	self.db = core.db:RegisterNamespace("Macro", {
		profile = {
			enabled = true,
			custom = true,
			verbose = true,
			relaxed = false,
			skipcomplete = true,
			skipvignette = false,
		},
	})
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	HBD.RegisterCallback(self, "PlayerZoneChanged", "Update")
	core.RegisterCallback(self, "Seen", "Update")
	core.RegisterCallback(self, "Ready", "Update")
	core.RegisterCallback(self, "IgnoreChanged", "Update")
	core.RegisterCallback(self, "CustomChanged", "Update")

	C_Timer.NewTicker(5, function()
		self:Update()
	end)

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.scanning.plugins.macro = {
			macro = {
				type = "group",
				name = "Macro",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v)
					self.db.profile[info[#info]] = v
					self:Update()
				end,
				args = {
					about = config.desc("Creates a button that can be used in a macro to target rares that might be nearby.\n\n"..
							"Either create a macro called \"SilverDragon\" or click the \"Create Macro\" button below, which will "..
							"try to make it for you. Drag it to your bars and click it to target rares that might be nearby. There "..
							"are strict limits on macro-length, so only the closest rares will be included.",
							0),
					verbose = {
						type = "toggle",
						name = "Announce",
						desc = "Output a little more, so you know what the macro is looking for",
						order = 10,
					},
					custom = {
						type = "toggle",
						name = CUSTOM,
						desc = "Include custom mobs in the macro. Because we don't know locations for them, they'll get priority "..
							"for being added and might push actually-close mobs out of the macro if you have too many.",
						order = 20,
					},
					relaxed = {
						type = "toggle",
						name = "Relaxed targeting",
						desc = "Target with /tar instead of /targetexact. This will sometimes target the wrong mob, but it'll also let you fit more mobs into the macro.",
						order = 30,
					},
					skipcomplete = {
						type = "toggle",
						name = "Skip completed mobs",
						desc = "Don't even try to target mobs that you have completed",
						order = 35,
					},
					skipvignette = {
						type = "toggle",
						name = "Skip known vignettes",
						desc = "Don't even try to target mobs that have known vignettes, because we can be pretty sure that other scanning methods will catch them",
						order = 40,
						disabled = not self.vignettesExist,
					},
					create = {
						type = "execute",
						name = "Create Macro",
						desc = "Click this to create the macro",
						func = function()
							self:CreateMacro()
						end,
						order = 50,
					},
				},
				-- order = 99,
			},
		}
	end
end

local lastmacrotext
function module:Update()
	if not self.db.profile.enabled then
		return
	end
	if InCombatLockdown() then
		self.waiting = true
		return
	end
	if MacroFrame and MacroFrame:IsVisible() then
		-- EditMacro will reset any manual editing in the macro frame
		return
	end
	-- Debug("Updating Macro")
	-- Make sure the core macro is up to date
	if GetMacroIndexByName("SilverDragon") then
		-- 1023 for macrotext on a button, but...
		local macroicon, macrotext = self:GetMacroArguments(255)
		if lastmacrotext ~= macrotext then
			EditMacro(GetMacroIndexByName("SilverDragon"), nil, macroicon, macrotext)
			lastmacrotext = macrotext
			DebugF("Updated macro: %d characters", #macrotext)
		end
	end
end

local macro = {}
function module:BuildTargetMacro(limit)
	local VERBOSE_ANNOUNCE = "/run print(\"Checking %d nearby mobs\")"
	-- first, create the macro text on the button:
	local zone = HBD:GetPlayerZone()
	local mobs = {}
	local distances = {}
	local relevant_count = 0
	for id, hasCoords, isCustom in core:IterateRelevantMobs(zone, true) do
		-- Debug("Considering", id, (not self.vignettesExist), (not self.db.profile.skipvignette), ns.mobdb[id] and not ns.mobdb[id].vignette)
		relevant_count = relevant_count + 1
		if
			(self.db.profile.custom or not isCustom) and
			-- there's no vignettes in this game version OR the skip-vignette config is disabled OR the mob doesn't have a vignette
			((not self.vignettesExist) or (not self.db.profile.skipvignette) or (ns.mobdb[id] and not ns.mobdb[id].vignette)) and
			not core:ShouldIgnoreMob(id, zone) and
			core:IsMobInPhase(id, zone) and
			not (self.db.profile.skipcomplete and ns:CompletionStatus(id))
		then
			local distance = hasCoords and select(4, core:GetClosestLocationForMob(id)) or 0
			distances[id] = distance
			table.insert(mobs, id)
		end
	end
	table.sort(mobs, function(a, b)
		return distances[a] < distances[b]
	end)
	local length = self.db.profile.verbose and (#(VERBOSE_ANNOUNCE:format(#mobs)) + 1) or 0
	for _, id in ipairs(mobs) do
		local name = core:NameForMob(id)
		if name then
			local line = (self.db.profile.relaxed and "/tar " or "/targetexact ") .. name
			length = length + 1 + #line
			if length > limit then
				break
			end
			table.insert(macro, line)
		end
	end
	if #macro == 0 then
		table.insert(macro, ("/script print(\"No mobs to scan for, of %s in zone\")"):format(relevant_count == 0 and NONE or relevant_count))
	elseif self.db.profile.verbose then
		table.insert(macro, 1, VERBOSE_ANNOUNCE:format(#macro))
	end

	local mtext = ("\n"):join(unpack(macro))

	-- DebugF("Updated macro: %d statements, %d characters, %d mobs", #macro, #mtext, #mobs)
	table.wipe(macro)
	return mtext
end

function module:CreateMacro()
	if InCombatLockdown() then
		return self:Print("|cffff0000Can't make a macro while in combat!|r")
	end
	local macroIndex = GetMacroIndexByName("SilverDragon")
	if macroIndex == 0 then
		local numglobal,numperchar = GetNumMacros()
		if numglobal < MAX_ACCOUNT_MACROS then
			CreateMacro("SilverDragon", self:GetMacroArguments())
			self:Print("Created the SilverDragon macro. Open the macro editor with /macro and drag it onto your actionbar to use it.")
		else
			self:Print("|cffff0000Couldn't create rare-scanning macro, too many macros already created.|r")
		end
	else
		self:Print("|cffff0000A macro named SilverDragon already exists.|r")
	end
end
function module:GetMacroArguments(limit)
	--/script for i=1,GetNumMacroIcons() do if GetMacroIconInfo(i):match("SniperTraining$") then DEFAULT_CHAT_FRAME:AddMessage(i) end end
	return 132222, self:BuildTargetMacro(limit or 255)
end

function module:PLAYER_REGEN_ENABLED()
	if self.waiting then
		self.waiting = false
		self:Update()
	end
end

-- /dump SilverDragonMacroButton:GetAttribute("macrotext")
function module:GetMacroButton(i)
	local name = "SilverDragonMacroButton"
	if i > 1 then
		name = name .. i
	end
	if _G[name] then
		return _G[name]
	end
	local button = CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate")
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext", "/script DEFAULT_CHAT_FRAME:AddMessage('SilverDragon Macro: Not initialized yet.', 1, 0, 0)")
	return button
end
