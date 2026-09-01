local myname, ns = ...

-- This file exists because these systems are kept in sync from my HandyNotes
-- plugins, and I need a minor translation layer to fit in here. It loads last
-- of the systems, so ns.conditions/ns.rewards and the synced helpers are all
-- present by now.

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

core.conditions = ns.conditions
core.rewards = ns.rewards

-- Builds the HandyNotes texture spec the plugins put on point.texture: an icon
-- file plus tex-coords, tinted or scaled by `extra`, with an optional inset (one
-- number trims every side, four give left/right/top/bottom). The overlay pin
-- applies it as-is. Kept close to the handler's own copy, but resolves the atlas
-- to `filename` when it has no `file` fileID.
ns.atlas_texture = ns.atlas_texture or function(atlas, extra, left, right, top, bottom)
    local info = C_Texture.GetAtlasInfo(atlas)
        or C_Texture.GetAtlasInfo("QuestObjective")
        or C_Texture.GetAtlasInfo("VignetteLoot")
    if type(extra) == "number" then
        extra = {scale = extra}
    end
    if left and not right then
        right, top, bottom = 1 - left, left, 1 - left
    end
    if left then
        -- an atlas is already a crop of its file, so the inset scales into that
        local horizontal = info.rightTexCoord - info.leftTexCoord
        local vertical = info.bottomTexCoord - info.topTexCoord
        info.rightTexCoord = info.leftTexCoord + (right * horizontal)
        info.leftTexCoord = info.leftTexCoord + (left * horizontal)
        info.bottomTexCoord = info.topTexCoord + (bottom * vertical)
        info.topTexCoord = info.topTexCoord + (top * vertical)
    end
    return ns.merge({
        icon = info.file or info.filename,
        tCoordLeft = info.leftTexCoord, tCoordRight = info.rightTexCoord,
        tCoordTop = info.topTexCoord, tCoordBottom = info.bottomTexCoord,
    }, extra)
end

-- A plugin map-link point opens a different map on right-click. SilverDragon
-- has no equivalent pin and these points carry no loot or completion data, so
-- RegisterHandyNotesData skips them; this only has to be callable.
ns.mapLink = ns.mapLink or function(point) return point end

ns.path = ns.nodeMaker{
    label = "Path to treasure",
    atlas = "poi-door", -- 'PortalPurple' / 'PortalRed'?
    minimap = true,
    scale = 0.9,
}

-- A point table whose __get entries compute fields (note, texture) on read.
-- SilverDragon reads none of those keys off an imported point, so this only
-- has to build a table the shape the zone file expects.
ns.Getterize = ns.Getterize or function(tbl)
    return setmetatable(tbl, {__index = function(self, key)
        if self.__get[key] then return self.__get[key](self) end
    end})
end

ns.SUPERRARE = ns.SUPERRARE or function(point)
    local note = "This is a \"super rare\" which can drop higher level loot"
    point.note = point.note and (point.note .. "\n" .. note) or note
    return point
end

-- foldConditions leaves gates split across `requires` and `hide_before`;
-- SilverDragon has no "until" state, so AND them into one. An or-group stays
-- wrapped so it isn't flattened into the AND.
function ns.combineRequires(a, b)
    if not a then return b end
    if not b then return a end
    local out = {}
    local function append(gate)
        if ns.IsObject(gate) then
            out[#out + 1] = gate
        elseif gate.any then
            out[#out + 1] = ns.conditions.Any(unpack(gate))
        else
            for _, condition in ipairs(gate) do out[#out + 1] = condition end
        end
    end
    append(a)
    append(b)
    return out
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

-- This doesn't do anything in SilverDragon, but the handynotes handler
-- sometimes expects to call it to suppress its map-button appearing in
-- mostly-unrelated zones.
ns.suppressoverlay = {}
ns.groups = {}
