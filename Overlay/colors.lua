local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

module.colors = {}
for _, color in ipairs({
    -- Fifty colours, in the order they get handed out. The first 24 differ in
    -- hue and saturation alone, with no help from brightness. The icon art
    -- already varies its own brightness across a single skull, so two colours
    -- that differ only in brightness look like one colour at two strengths.
    {255,87,157},
    {86,248,21},
    {5,168,251},
    {235,241,187},
    {171,130,255},
    {250,69,254},
    {57,254,230},
    {251,132,100},
    {233,250,10},
    {229,204,251},
    {252,192,185},
    {181,251,244},
    {250,108,219},
    {249,146,187},
    {152,201,250},
    {167,252,186},
    {241,163,251},
    {254,187,116},
    {210,104,249},
    {158,251,115},
    {122,151,255},
    {10,254,170},
    {8,219,251},
    {251,231,105},
    -- Fifty do not fit on hue and saturation alone, so the rest use brightness
    -- as well. Only a dense zone reaches them.
    {125,174,127},
    {5,193,70},
    {183,187,11},
    {189,150,112},
    {169,148,200},
    {80,175,193},
    {57,213,160},
    {193,193,139},
    {139,212,201},
    {206,148,13},
    {212,129,208},
    {240,188,23},
    {253,151,34},
    {183,173,253},
    {59,228,97},
    {118,180,72},
    {124,163,217},
    {165,163,74},
    {137,214,117},
    {168,217,16},
    {16,183,161},
    {198,224,136},
    {241,111,131},
    {228,156,148},
    {202,135,165},
    {219,171,203},
}) do
    table.insert(module.colors, CreateColorFromBytes(color[1], color[2], color[3], 255))
end

-- Each entry in the table stands as far as it can from the ones before it, so
-- the colours go out in order: a zone that shows ten points gets a well-spread
-- ten. The count restarts per zone to keep every map at the front of the order.
-- A mob in two zones has no need of the same colour in both. The two id spaces
-- overlap, so mobs and treasures count separately.
local assigned = {}
function module.id_to_color(id, uiMapID, isTreasure)
    local zone = assigned[uiMapID]
    if not zone then
        zone = {count = 0, mob = {}, treasure = {}}
        assigned[uiMapID] = zone
    end
    local kind = isTreasure and zone.treasure or zone.mob
    local index = kind[id]
    if not index then
        index = zone.count % #module.colors + 1
        zone.count = zone.count + 1
        kind[id] = index
    end
    return module.colors[index]:GetRGB()
end
