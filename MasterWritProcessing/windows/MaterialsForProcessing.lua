local MWP = MasterWritProcessing

MWP_MaterialsForProcessingWindowClass = ZO_SortFilterList:Subclass()
MWP_MaterialsForProcessingWindowClass.defaults = {}

MWP.MaterialsForProcessingUnitList = nil
MWP.MaterialsForProcessingUnits = {}

MWP_MaterialsForProcessingWindowClass.SORT_KEYS = {
    ["MaterialName"] = {},
    ["toCraftNeedCount"] = { tiebreaker = "MaterialName" },
    ["currentCount"] = { tiebreaker = "MaterialName" },
    ["toBuyCount"] = { tiebreaker = "MaterialName" },
}

function MWP_MaterialsForProcessingWindowClass:New()
    local units = ZO_SortFilterList.New(self, MWP_MaterialsForProcessingWindow)
    return units
end

function MWP_MaterialsForProcessingWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("toBuyCount")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "MWP_MaterialsForProcessingWindowUnitList", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, MWP_MaterialsForProcessingWindowClass.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function MWP_MaterialsForProcessingWindowClass:BuildMasterList()
    self.masterList = {}
    local units = MWP.MaterialsForProcessingUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function MWP_MaterialsForProcessingWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function MWP_MaterialsForProcessingWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function MWP_MaterialsForProcessingWindowClass:SetupUnitRow(control, data)

    control.data = data

    control.MaterialIcon = GetControl(control, "MaterialIcon")
    control.MaterialIcon:SetTexture(data.MaterialIcon)

    control.MaterialName = GetControl(control, "MaterialName")
    --control.MaterialName:SetText(string.format("[%s] %s", data.itemId, data.MaterialName))
    control.MaterialName:SetText(data.MaterialName)
    control.MaterialName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.toCraftNeedCount = GetControl(control, "toCraftNeedCount")
    control.toCraftNeedCount:SetText(data.toCraftNeedCount)
    control.toCraftNeedCount:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.currentCount = GetControl(control, "currentCount")
    control.currentCount:SetText(data.currentCount)
    control.currentCount:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.toBuyCount = GetControl(control, "toBuyCount")
    control.toBuyCount:SetText(data.toBuyCount)
    control.toBuyCount:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

function MWP.MaterialsForProcessingOnLoad()
    MWP.MaterialsForProcessingUnitList = MWP_MaterialsForProcessingWindowClass:New()
    MWP.MaterialsForProcessingUnits = {}
    MWP.MaterialsForProcessingUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(MWP_MaterialsForProcessingWindow)
    MWP_MaterialsForProcessingWindow:SetHidden(true)
end

-- /script MasterWritProcessing.showMaterialsForProcessingListBySavedParsingResult()
function MWP.showMaterialsForProcessingListBySavedParsingResult()
    MWP_MaterialsForProcessingWindow:SetHidden(true)
    MWP.MaterialsForProcessingUnits = MWP.getParsedMaterial()
    MWP.MaterialsForProcessingUnitList:RefreshData()
    MWP_MaterialsForProcessingWindow:SetHidden(false)
end

-- /script MasterWritProcessing.showMaterialsForProcessingListByInventory()
function MWP.showMaterialsForProcessingListByInventory()
    MWP_MaterialsForProcessingWindow:SetHidden(true)
    MWP.MaterialsForProcessingUnits = MWP.parseMaterialByInventory()
    MWP.MaterialsForProcessingUnitList:RefreshData()
    MWP_MaterialsForProcessingWindow:SetHidden(false)
end
-- /script MasterWritProcessing.showMaterialsForProcessingListByInventoryAndBank()
function MWP.showMaterialsForProcessingListByInventoryAndBank()
    MWP_MaterialsForProcessingWindow:SetHidden(true)
    MWP.MaterialsForProcessingUnits = MWP.parseMaterialByInventoryAndBank()
    MWP.MaterialsForProcessingUnitList:RefreshData()
    MWP_MaterialsForProcessingWindow:SetHidden(false)
end
-- /script MasterWritProcessing.showMaterialsForProcessingListByAllSaved()
function MWP.showMaterialsForProcessingListByAllSaved()
    MWP_MaterialsForProcessingWindow:SetHidden(true)
    MWP.MaterialsForProcessingUnits = MWP.parseMaterialByAllSaved()
    MWP.MaterialsForProcessingUnitList:RefreshData()
    MWP_MaterialsForProcessingWindow:SetHidden(false)
end

SLASH_COMMANDS["/mwp_show_materials_for_processing_list_info"] = function()
    MWP.toggleMaterialsForProcessingListWindow()
end

-- /script MasterWritProcessing.toggleMaterialsForProcessingListWindow()
function MWP.toggleMaterialsForProcessingListWindow()
    MWP_MaterialsForProcessingWindow:ToggleHidden()
end


