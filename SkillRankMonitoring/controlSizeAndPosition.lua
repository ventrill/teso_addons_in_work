local function getSavedWindowsPosition()
    return SkillRankMonitoring.savedVars.windowsPosition
end

local leftKey = 'left'
local topKey = 'top'
local widthKey = 'width'
local heightKey = 'height'

local function saveControlPositionValue(controlName, valueName, value)
    if not getSavedWindowsPosition()[controlName] then
        getSavedWindowsPosition()[controlName] = {}
    end
    getSavedWindowsPosition()[controlName][valueName] = value
end
local function getControlPositionValue(controlName, valueName)
    if not getSavedWindowsPosition() then
        d("no getSavedWindowsPosition")
        return nil
    end
    if not getSavedWindowsPosition()[controlName] then
        d("not found data for controlName")
        d(controlName)
        return nil
    end
    if not getSavedWindowsPosition()[controlName][valueName] then
        d('keyPosition is empty')
        d(controlName)
        d(valueName)
        return nil
    end

    return getSavedWindowsPosition()[controlName][valueName]
end

local function SaveLeft(controlName, left)
    saveControlPositionValue(controlName, leftKey, left)
end
local function SaveWidth(controlName, Width)
    saveControlPositionValue(controlName, widthKey, Width)
end

local function SaveHeight(controlName, Height)
    saveControlPositionValue(controlName, heightKey, Height)
end
local function SaveTop(controlName, top)
    saveControlPositionValue(controlName, topKey, top)
end

local function GetWidth(controlName)
    return getControlPositionValue(controlName, widthKey)
end
local function GetHeight(controlName)
    return getControlPositionValue(controlName, heightKey)
end
local function GetSavedLeft(controlName)
    return getControlPositionValue(controlName, leftKey)
end
local function GetSavedTop(controlName)
    return getControlPositionValue(controlName, topKey)
end


function SkillRankMonitoring.SaveControlLocation(control)
    SaveLeft(control:GetName(), control:GetLeft())
    SaveTop(control:GetName(), control:GetTop())
end
function SkillRankMonitoring.onResizeStop(control)
    SaveWidth(control:GetName(), control:GetWidth())
    SaveHeight(control:GetName(), control:GetHeight())
end

function SkillRankMonitoring.LoadControlLocation(control)
    local controlName = control:GetName()
    local left = GetSavedLeft(controlName) or 0
    local top = GetSavedTop(controlName) or 0
    control:ClearAnchors()
    control:SetHeight(GetHeight(controlName) or 350)
    control:SetWidth(GetWidth(controlName) or 900)
    control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end
