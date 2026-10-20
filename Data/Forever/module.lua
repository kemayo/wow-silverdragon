local myname, ns = ...

if WOW_PROJECT_ID ~= WOW_PROJECT_CAMELOT then
	ns.BeginDataModule(nil)
	return
end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

ns.BeginDataModule("Forever")
