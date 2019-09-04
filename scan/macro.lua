local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Macro", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-2.0")

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Macro", {
		profile = {
			enabled = true,
			verbose = true,
		},
	})
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	HBD.RegisterCallback(self, "PlayerZoneChanged", "Update")
	core.RegisterCallback(self, "Seen", "Update")
	core.RegisterCallback(self, "Ready", "Update")

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
							"Either create a macro that says: /click SilverDragonMacroButton\n\n"..
							"...or click the \"Create Macro\" button below. It'll make a new macro called SilverDragon. Drag it to your bars and click it to target rares that might be nearby.",
							0),
					verbose = {
						type = "toggle",
						name = "Announce",
						desc = "Output a little more, so you know what the macro is looking for",
					},
					create = {
						type = "execute",
						name = "Create Macro",
						desc = "Click this to create the macro",
						func = function()
							self:CreateMacro()
						end
					},
				},
				-- order = 99,
			},
		}
	end
end

function module:Update()
	if InCombatLockdown() then
		self.waiting = true
		return
	end
	if not self.db.profile.enabled then
		self.button:SetAttribute("macrotext", "/print \"Scanning macro disabled\"")
		return
	end
	Debug("Updating Macro")
	-- first, create the macro text on the button:
	local zone = HBD:GetPlayerZone()
	local mobs = zone and ns.mobsByZone[zone]
	local macro = {}
	local count = 0
	if mobs then
		for id in pairs(mobs) do
			local name = core:NameForMob(id)
			if
				name and
				not core.db.global.ignore[id] and
				core:IsMobInPhase(id, zone)
			then
				table.insert(macro, "/targetexact " .. name)
				count = count + 1
			end
		end
	end
	if count == 0 then
		table.insert(macro, "/print \"No mobs known to scan for\"")
	end
	if self.db.profile.verbose then
		table.insert(macro, 1, ("/print \"Scanning for %d nearby mobs...\""):format(count))
	end
	self.button:SetAttribute("macrotext", ("\n"):join(unpack(macro)))
	table.wipe(macro)
end

function module:CreateMacro()
	if InCombatLockdown() then
		return self:Print("|cffff0000Can't make a macro while in combat!|r")
	end
	LoadAddOn("Blizzard_MacroUI") -- required for MAX_ACCOUNT_MACROS
	local macroIndex = GetMacroIndexByName("SilverDragon")
	if macroIndex == 0 then
		local numglobal,numperchar = GetNumMacros()
		if numglobal < MAX_ACCOUNT_MACROS then
			--/script for i=1,GetNumMacroIcons() do if GetMacroIconInfo(i):match("SniperTraining$") then DEFAULT_CHAT_FRAME:AddMessage(i) end end
			CreateMacro("SilverDragon", 132222, "/click SilverDragonMacroButton", nil, nil)
			self:Print("Created the SilverDragon macro. Open the macro editor with /macro and drag it onto your actionbar to use it.")
		else
			self:Print("|cffff0000Couldn't create rare-scanning macro, too many macros already created.|r")
		end
	else
		self:Print("|cffff0000A macro named SilverDragon already exists.|r")
	end
end

function module:PLAYER_REGEN_ENABLED()
	if self.waiting then
		self.waiting = false
		self:Update()
	end
end

local button = CreateFrame("Button", "SilverDragonMacroButton", nil, "SecureActionButtonTemplate")
button:SetAttribute("type", "macro")
button:SetAttribute("macrotext", "/script DEFAULT_CHAT_FRAME:AddMessage('SilverDragon Macro: Not initialized yet.', 1, 0, 0)")
module.button = button

-- /spew SilverDragonMacroButton:GetAttribute("macrotext")
