local myname, ns = ...

-- This file exists because these systems are kept in sync from my HandyNotes
-- plugins, and I need a minor translation layer to fit in here.

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

ns.db = setmetatable({}, {__index = function(self, key)
	return core.db.profile[key]
end})

ns.render_string = function(...) return core:RenderString(...) end

ns.run_caches = {}
ns.ClearRunCaches = function()
	for _, cache in pairs(ns.run_caches) do
		table.wipe(cache)
	end
end
