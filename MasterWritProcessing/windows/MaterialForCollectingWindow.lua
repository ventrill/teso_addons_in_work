local MWP = MasterWritProcessing

local MWP_MaterialForCollectingWindowClass = ZO_SortFilterList:Subclass()
MWP_MaterialForCollectingWindowClass.defaults = {}

MWP.MaterialForCollectingUnitList = nil
MWP.MaterialForCollectingUnits = {}

MWP_MaterialForCollectingWindowClass.SORT_KEYS = {
    ["MaterialName"] = {},
    ["forMasterCraft"] = { tiebreaker = "MaterialName" },
    ["itemReserve"] = { tiebreaker = "MaterialName" },
    ["dailyReserve"] = { tiebreaker = "MaterialName" },
    ["atAll"] = { tiebreaker = "MaterialName" },
    ["currentCount"] = { tiebreaker = "MaterialName" },
    ["toCollect"] = { tiebreaker = "MaterialName" },
}

function MWP_MaterialForCollectingWindowClass:New()
    local units = ZO_SortFilterList.New(self, MWP_MaterialForCollectingWindow)
    return units
end

function MWP_MaterialForCollectingWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("toCollect")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "MWP_MaterialForCollectingWindowUnitList", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, MWP_MaterialForCollectingWindowClass.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function MWP_MaterialForCollectingWindowClass:BuildMasterList()
    self.masterList = {}
    local units = MWP.MaterialForCollectingUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function MWP_MaterialForCollectingWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function MWP_MaterialForCollectingWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function MWP_MaterialForCollectingWindowClass:SetupUnitRow(control, data)

    control.data = data

    control.MaterialIcon = GetControl(control, "MaterialIcon")
    control.MaterialIcon:SetTexture(data.MaterialIcon)

    control.MaterialName = GetControl(control, "MaterialName")
    --control.MaterialName:SetText(string.format("[%s] %s", data.itemId, data.MaterialName))
    control.MaterialName:SetText(data.MaterialName)
    control.MaterialName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.forMasterCraft = GetControl(control, "forMasterCraft")
    control.forMasterCraft:SetText(data.forMasterCraft)
    control.forMasterCraft:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.itemReserve = GetControl(control, "itemReserve")
    control.itemReserve:SetText(data.itemReserve)
    control.itemReserve:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.dailyReserve = GetControl(control, "dailyReserve")
    control.dailyReserve:SetText(data.dailyReserve)
    control.dailyReserve:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.atAll = GetControl(control, "atAll")
    control.atAll:SetText(data.atAll)
    control.atAll:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.currentCount = GetControl(control, "currentCount")
    control.currentCount:SetText(data.currentCount)
    control.currentCount:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.toCollect = GetControl(control, "toCollect")
    control.toCollect:SetText(data.toCollect)
    control.toCollect:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

function MWP.MaterialForCollectingOnLoad()
    MWP.MaterialForCollectingUnitList = MWP_MaterialForCollectingWindowClass:New()
    MWP.MaterialForCollectingUnits = {}
    MWP.MaterialForCollectingUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(MWP_MaterialForCollectingWindow)
    MWP_MaterialForCollectingWindow:SetHidden(true)
end

-- /script MasterWritProcessing.showMaterialsForProcessingBySaved()
function MWP.showMaterialsForProcessingBySaved()
    MWP_MaterialForCollectingWindow:SetHidden(true)
    MWP.MaterialForCollectingUnits = MWP.getSavedInfoToShow()
    MWP.MaterialForCollectingUnitList:RefreshData()
    MWP_MaterialForCollectingWindow:SetHidden(false)
end
-- /script MasterWritProcessing.showMaterialsForProcessingByActual()
function MWP.showMaterialsForProcessingByActual()
    MWP_MaterialForCollectingWindow:SetHidden(true)
    MWP.MaterialForCollectingUnits = MWP.getActualInfoToShow()
    MWP.MaterialForCollectingUnitList:RefreshData()
    MWP_MaterialForCollectingWindow:SetHidden(false)
end

SLASH_COMMANDS["/mwp_show_materials_for_collecting_info"] = function()
    MWP.toggleMaterialForCollectingWindow()
end

-- /script MasterWritProcessing.toggleMaterialForCollectingWindow()
function MWP.toggleMaterialForCollectingWindow()
    -- MWP_MaterialForCollectingWindow:ToggleHidden()
    if MWP_MaterialForCollectingWindow:IsHidden() then
        MWP.showMaterialsForProcessingBySaved()
    else
        MWP_MaterialForCollectingWindow:SetHidden(true)
    end
end


