local myname, ns = ...

local lineParent = CreateFrame('Frame', nil, WorldMapFrame:GetCanvas())
lineParent:SetAllPoints()
lineParent:SetFrameStrata("MEDIUM")
-- lineParent:SetFrameLevel(2200) -- need to set it high so lines render above the canvas and pois
lineParent:SetFrameLevel(ns.MapSystem.GetWorldMapFrameLevelByType("PIN_FRAME_LEVEL_AREA_POI") - 2)

local linePool = CreateUnsecuredObjectPool(function()
    local line = lineParent:CreateLine()
    line:SetColorTexture(1, 1, 1, 0.6)
    line:SetIgnoreParentScale(true)
    return line
end, function(_, line)
    line:SetScale(1)
    line:SetThickness(2)
    line:SetVertexColor(1, 1, 1, 1)
    line:Hide()
end)

function ns.MapSystem:AttachLine(source, destination)
    local line = linePool:Acquire()
    line:SetStartPoint('CENTER', source)
    line:SetEndPoint('CENTER', destination)
    line:Show()
    return line
end

function ns.MapSystem:EnumerateLines()
    return linePool:EnumerateActive()
end

function ns.MapSystem:ReleaseLines()
    linePool:ReleaseAll()
end

function ns.MapSystem:ReleaseLine(line)
    linePool:Release(line)
end
