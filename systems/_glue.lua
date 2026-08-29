local myname, ns = ...

-- This file exists because these systems are kept in sync from my HandyNotes
-- plugins, and I need a minor translation layer to fit in here. It loads last
-- of the systems, so ns.conditions/ns.rewards and the synced helpers are all
-- present by now.

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

core.conditions = ns.conditions
core.rewards = ns.rewards

-- In the handler this returns a HandyNotes texture-spec table, which lands on
-- point.texture. SilverDragon never reads point.texture on imported points --
-- icons come from the MobState/treasure rules, and RegisterHandyNotesData
-- takes point.atlas straight from the data -- so the return here is dead. It
-- only has to be callable.
ns.atlas_texture = ns.atlas_texture or function(atlas) return atlas end

-- A plugin map-link point opens a different map on right-click. SilverDragon
-- has no equivalent pin and these points carry no npc or vignette, so
-- RegisterHandyNotesData skips them; this only has to be callable.
ns.mapLink = ns.mapLink or function(point) return point end

-- Older handler code negates AreaPoi under this name; a current conditions.lua
-- already provides it.
ns.conditions.NotAreaPoi = ns.conditions.NotAreaPoi or ns.conditions._Negated(ns.conditions.AreaPoi)

ns.SUPERRARE = ns.SUPERRARE or function(point)
    local note = "This is a \"super rare\" which can drop higher level loot"
    point.note = point.note and (point.note .. "\n" .. note) or note
    return point
end

-- Each Data/<Expansion>/module.lua names its source once, then RegisterPoints
-- and RegisterVignettes feed core under that name. A nil source (the file's
-- gate failed, wrong expansion for this client) makes both a no-op so the
-- copied zone files can still run their top-level code without registering.
local currentSource
function ns.BeginDataModule(source) currentSource = source end
function ns.DataModuleSource() return currentSource end
function ns.RegisterPoints(zone, points, defaults)
    if not currentSource then return end
    return core:RegisterHandyNotesData(currentSource, zone, points, defaults)
end
function ns.RegisterVignettes(zone, vignettes, defaults)
    if not currentSource then return end
    return core:RegisterHandyNotesVignettes(currentSource, zone, vignettes, defaults)
end
