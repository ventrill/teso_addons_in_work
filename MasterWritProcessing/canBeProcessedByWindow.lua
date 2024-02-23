local MWP = MasterWritProcessing

MWP_CanBeProcessedByWindowClass = ZO_SortFilterList:Subclass()
MWP_CanBeProcessedByWindowClass.defaults = {}

MWP.CanBeProcessedByUnitList = nil
MWP.CanBeProcessedByUnits = {}

MWP_CanBeProcessedByWindowClass.SORT_KEYS = {
    ["CharacterName"] = {},
    ["AllCount"] = { tiebreaker = "CharacterName" },
    ["Blacksmith"] = { tiebreaker = "CharacterName" },
    ["Clothier"] = { tiebreaker = "CharacterName" },
    ["Woodworker"] = { tiebreaker = "CharacterName" },
    ["Jewelry"] = { tiebreaker = "CharacterName" },
    ["Alchemy"] = { tiebreaker = "CharacterName" },
    ["Enchanting"] = { tiebreaker = "CharacterName" },
    ["Provisioning"] = { tiebreaker = "CharacterName" },
}

function MWP_CanBeProcessedByWindowClass:New()
    local units = ZO_SortFilterList.New(self, MWP_canBeProcessedByWindow)
    return units
end

function MWP_CanBeProcessedByWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("AllCount")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "MWP_canBeProcessedByWindowUnitList", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, MWP_CanBeProcessedByWindowClass.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function MWP_CanBeProcessedByWindowClass:BuildMasterList()
    self.masterList = {}
    local units = MWP.CanBeProcessedByUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function MWP_CanBeProcessedByWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function MWP_CanBeProcessedByWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function MWP_CanBeProcessedByWindowClass:SetupUnitRow(control, data)

    control.data = data

    control.CharacterName = GetControl(control, "CharacterName")
    control.CharacterName:SetText(data.name)
    control.CharacterName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.AllCount = GetControl(control, "AllCount")
    control.AllCount:SetText(data.all)
    control.AllCount:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.Blacksmith = GetControl(control, "Blacksmith")
    control.Blacksmith:SetText(data[CRAFTING_TYPE_BLACKSMITHING])
    control.Blacksmith:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.Clothier = GetControl(control, "Clothier")
    control.Clothier:SetText(data[CRAFTING_TYPE_CLOTHIER])
    control.Clothier:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.Woodworker = GetControl(control, "Woodworker")
    control.Woodworker:SetText(data[CRAFTING_TYPE_WOODWORKING])
    control.Woodworker:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.Jewelry = GetControl(control, "Jewelry")
    control.Jewelry:SetText(data[CRAFTING_TYPE_JEWELRYCRAFTING])
    control.Jewelry:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.Alchemy = GetControl(control, "Alchemy")
    control.Alchemy:SetText(data[CRAFTING_TYPE_ALCHEMY])
    control.Alchemy:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.Enchanting = GetControl(control, "Enchanting")
    control.Enchanting:SetText(data[CRAFTING_TYPE_ENCHANTING])
    control.Enchanting:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.Provisioning = GetControl(control, "Provisioning")
    control.Provisioning:SetText(data[CRAFTING_TYPE_PROVISIONING])
    control.Provisioning:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

function MWP.CanBeProcessedByOnLoad()
    MWP.CanBeProcessedByUnitList = MWP_CanBeProcessedByWindowClass:New()
    MWP.CanBeProcessedByUnits = {}
    MWP.CanBeProcessedByUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(MWP_canBeProcessedByWindow)
    MWP_canBeProcessedByWindow:SetHidden(true)
end

-- /script MasterWritProcessing.showCanBeProcessedByListInfo()
function MWP.showCanBeProcessedByListInfo()
    MWP_canBeProcessedByWindow:SetHidden(true)
    MWP.CanBeProcessedByUnits = MWP.prepareDoableList()
    MWP.CanBeProcessedByUnitList:RefreshData()
    MWP_canBeProcessedByWindow:SetHidden(false)
end

SLASH_COMMANDS["/mwp_show_can_be_processed_list_info"] = function()
    MWP.toggleCanBeProcessedByListWindow()
end

-- /script MasterWritProcessing.toggleCanBeProcessedByListWindow()
function MWP.toggleCanBeProcessedByListWindow()
    MWP_canBeProcessedByWindow:ToggleHidden()
end


