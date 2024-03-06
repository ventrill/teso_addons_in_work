local MWP = MasterWritProcessing

MWP_ProcessingListWindowClass = ZO_SortFilterList:Subclass()
MWP_ProcessingListWindowClass.defaults = {}

MWP.ProcessingListUnitList = nil
MWP.ProcessingListUnits = {}

MWP_ProcessingListWindowClass.SORT_KEYS = {
    ["CraftType"] = {},
    ["Count"] = { tiebreaker = "CraftType" },
}

function MWP_ProcessingListWindowClass:New()
    local units = ZO_SortFilterList.New(self, MWP_ProcessingList)
    return units
end

function MWP_ProcessingListWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("CraftType")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "MWP_ProcessingListUnitList", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, MWP_ProcessingListWindowClass.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function MWP_ProcessingListWindowClass:BuildMasterList()
    self.masterList = {}
    local units = MWP.ProcessingListUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function MWP_ProcessingListWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        if data.Count > 0 then
            table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
        end
    end
end

function MWP_ProcessingListWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function MWP_ProcessingListWindowClass:SetupUnitRow(control, data)

    control.data = data

    control.CraftType = GetControl(control, "CraftType")
    control.CraftType:SetText(string.format("[%s] %s", data.CraftTypeId, data.CraftType))
    control.CraftType:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.Count = GetControl(control, "Count")
    control.Count:SetText(data.Count)
    control.Count:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

function MWP.ProcessingListOnLoad()
    MWP.ProcessingListUnitList = MWP_ProcessingListWindowClass:New()
    MWP.ProcessingListUnits = {}
    MWP.ProcessingListUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(MWP_ProcessingList)
    MWP_ProcessingList:SetHidden(true)
end

-- /script MasterWritProcessing.showProcessingListInfo()
function MWP.showProcessingListInfo()
    MWP_ProcessingList:SetHidden(true)
    MWP.ProcessingListUnits = MWP.prepareWritInfo()
    MWP.ProcessingListUnitList:RefreshData()
    MWP_ProcessingList:SetHidden(false)
end

function MWP.showSavedProcessingListInfo()
    MWP_ProcessingList:SetHidden(true)
    MWP.ProcessingListUnits = MWP.prepareWritInfoBySaved()
    MWP.ProcessingListUnitList:RefreshData()
    MWP_ProcessingList:SetHidden(false)
end

SLASH_COMMANDS["/mwp_show_processing_list_info"] = function()
    --MWP.showProcessingListInfo()
    MWP.toggleProcessingListWindow()
end

-- /script MasterWritProcessing.toggleProcessingListWindow()
function MWP.toggleProcessingListWindow()
    MWP_ProcessingList:ToggleHidden()
end

function MWP.prepareWritInfo()
    --d("MWP.prepareWritInfo")
    MWP.searchAll()
    return MWP.getSlotStatistic()
end

function MWP.prepareWritInfoBySaved()
    --d('MWP.prepareWritInfoBySaved')
    return MWP.getSlotStatistic()
end

function MWP.ProcessWrit(control)
    local parent = control:GetParent()
    if parent ~= nil and parent.data and parent.data.CraftTypeId then
        --local str = string.format("Type: %s [%s], Count %d", parent.data.CraftType, parent.data.CraftTypeId, parent.data.Count)
        --d(str)
        MWP.processByType(parent.data.CraftTypeId)
        MWP.showSavedProcessingListInfo()
    else
        --d("paren has no data")
    end
end

