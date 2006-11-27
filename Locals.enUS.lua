local L = AceLibrary("AceLocale-2.2"):new("SilverDragon")

L:RegisterTranslations("enUS", function() return {
	["DefaultIcon"] = "Interface\\Icons\\Ability_Hunter_BeastCall",
	["ChatCommands"] = {"/silverdragon", "/sd"},
	
	["Do scan"] = true,
	["Settings"] = true,
	["Configuration options"] = true,
	["Scan"] = true,
	["Scan for nearby rares at a regular interval"] = true,
	["Announce"] = true,
	["Display a message when a rare is detected nearby"] = true,
	["Scan for nearby rares"] = true,
	
	["%s seen!"] = true,
	["(it's dead)"] = true,
	
	["Rares"] = true,
	["Never"] = true,
	[" day(s)"] = true,
	[" hour(s)"] = true,
	[" minute(s)"] = true,
} end)
