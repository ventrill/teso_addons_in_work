local MWP = MasterWritProcessing

local MWP_MaterialForCollectingShortWindowClass = ZO_SortFilterList:Subclass()
MWP_MaterialForCollectingShortWindowClass.defaults = {}

MWP.MaterialForCollectingShortUnitList = nil
MWP.MaterialForCollectingShortUnits = {}

MWP_MaterialForCollectingShortWindowClass.SORT_KEYS = {
    ["MaterialName"] = {},
    ["toCollect"] = { tiebreaker = "MaterialName" },
}

function MWP_MaterialForCollectingShortWindowClass:New()
    local units = ZO_SortFilterList.New(self, MWP_MaterialForCollectingShortWindow)
    return units
end

function MWP_MaterialForCollectingShortWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("toCollect")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "MWP_MaterialForCollectingShortWindowUnitList", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, MWP_MaterialForCollectingShortWindowClass.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function MWP_MaterialForCollectingShortWindowClass:BuildMasterList()
    self.masterList = {}
    local units = MWP.MaterialForCollectingShortUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function MWP_MaterialForCollectingShortWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        if data['toCollect'] > 0 then
            table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
        end
    end
end

function MWP_MaterialForCollectingShortWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function MWP_MaterialForCollectingShortWindowClass:SetupUnitRow(control, data)

    control.data = data

    control.MaterialIcon = GetControl(control, "MaterialIcon")
    control.MaterialIcon:SetTexture(data.MaterialIcon)

    control.MaterialName = GetControl(control, "MaterialName")
    control.MaterialName:SetText(data.MaterialName)
    control.MaterialName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.toCollect = GetControl(control, "toCollect")
    control.toCollect:SetText(data.toCollect)
    control.toCollect:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

function MWP.MaterialForCollectingShortOnLoad()
    MWP.MaterialForCollectingShortUnitList = MWP_MaterialForCollectingShortWindowClass:New()
    MWP.MaterialForCollectingShortUnits = {}
    MWP.MaterialForCollectingShortUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(MWP_MaterialForCollectingShortWindow)
    MWP_MaterialForCollectingShortWindow:SetHidden(true)
end

-- /script MasterWritProcessing.showMaterialsForProcessingBySaved_Short()
function MWP.showMaterialsForProcessingBySaved_Short()
    MWP_MaterialForCollectingShortWindow:SetHidden(true)
    MWP.MaterialForCollectingShortUnits = MWP.getSavedInfoToShow()
    MWP.MaterialForCollectingShortUnitList:RefreshData()
    MWP_MaterialForCollectingShortWindow:SetHidden(false)
end
-- /script MasterWritProcessing.showMaterialsForProcessingByActual_Short()
function MWP.showMaterialsForProcessingByActual_Short()
    MWP_MaterialForCollectingShortWindow:SetHidden(true)
    MWP.MaterialForCollectingShortUnits = MWP.getActualInfoToShow()
    MWP.MaterialForCollectingShortUnitList:RefreshData()
    MWP_MaterialForCollectingShortWindow:SetHidden(false)
end

SLASH_COMMANDS["/mwp_show_materials_for_collecting_info_short"] = function()
    MWP.toggleMaterialForCollectingShortWindow()
end

-- /script MasterWritProcessing.toggleMaterialForCollectingShortWindow()
function MWP.toggleMaterialForCollectingShortWindow()
    -- MWP_MaterialForCollectingShortWindow:ToggleHidden()
    if MWP_MaterialForCollectingShortWindow:IsHidden() then
        MWP.showMaterialsForProcessingBySaved_Short()
    else
        MWP_MaterialForCollectingShortWindow:SetHidden(true)
    end
end


