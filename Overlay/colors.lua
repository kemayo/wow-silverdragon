local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

module.colors = {}
for _, color in ipairs({
    -- This was me having fun with https://medialab.github.io/iwanthue/ yes
    {208,44,178},
    {108,227,62},
    {186,63,231},
    {92,190,41},
    {131,83,241},
    {80,229,111},
    {223,70,223},
    {183,209,41},
    {84,103,240},
    {227,196,48},
    {172,92,224},
    {65,181,71},
    {237,85,210},
    {39,144,39},
    {229,51,155},
    {77,223,158},
    {180,78,179},
    {126,174,32},
    {136,113,227},
    {169,213,86},
    {71,121,234},
    {234,167,51},
    {83,138,229},
    {229,86,32},
    {68,185,114},
    {225,121,223},
    {139,218,111},
    {115,98,189},
    {107,174,72},
    {196,76,148},
    {73,141,40},
    {181,123,210},
    {163,180,66},
    {236,118,180},
    {52,145,73},
    {229,56,46},
    {39,122,53},
    {220,73,121},
    {71,123,37},
    {224,67,89},
    {112,152,52},
    {219,99,78},
    {127,143,33},
    {231,128,43},
    {210,205,95},
    {196,101,48},
    {119,120,18},
    {212,151,64},
    {181,161,53},
    {166,111,24},
}) do
    table.insert(module.colors, CreateColorFromBytes(color[1], color[2], color[3], 1))
end

function module.id_to_color(id)
    return module.colors[(id % #module.colors) + 1]:GetRGB()
end

-- the other approach
-- local function scale(value, currmin, currmax, min, max)
--     -- take a value between currmin and currmax and scale it to be between min and max
--     return ((value - currmin) / (currmax - currmin)) * (max - min) + min
-- end
-- local function hasher(value)
--     return scale(select(2, math.modf(math.abs(math.tan(value)) * 10000, 1)), 0, 1, 0.3, 1)
-- end
-- local function id_to_color(id)
--     return hasher(id + 1), hasher(id + 2), hasher(id + 3)
-- end
-- module.id_to_color = id_to_color
