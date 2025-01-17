local MWP = MasterWritProcessing

local MWP_CanBeProcessedByWindowClass = ZO_SortFilterList:Subclass()
MWP_CanBeProcessedByWindowClass.defaults = {}

MWP.CanBeProcessedByUnitList = nil
MWP.CanBeProcessedByUnits = {}

MWP_CanBeProcessedByWindowClass.SORT_KEYS = {
    ["CharacterName"] = {},
    ["AllCount"] = { tiebreaker = "CharacterName" },
    ["isCharacterProgressComplete"] = { tiebreaker = "CharacterName" },
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

local function boolToText(boolean)
    if boolean then
        return 'Yes'
    end
    return 'No'
end

function MWP_CanBeProcessedByWindowClass:FilterScrollList()

    ---filter by data.isCharacterProgressComplete
    ---@param data table
    ---@return boolean
    local function checkIsCharacterProgressComplete(data)
        local selected = MWP.canBeProcessedByWindow_IsCharacterProgressCompleteDropDown
        if string.lower(selected) == 'all' then
            return true
        end
        if string.lower(selected) == string.lower(boolToText(data.isCharacterProgressComplete)) then
            return true
        end
        return false
    end

    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        if checkIsCharacterProgressComplete(data) then
            table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
        end
    end
end

function MWP_CanBeProcessedByWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function MWP_CanBeProcessedByWindowClass:SetupUnitRow(control, data)

    control.data = data

    data.CharacterName = data.name
    control.CharacterName = GetControl(control, "CharacterName")
    control.CharacterName:SetText(data.CharacterName)
    control.CharacterName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.IsCharacterProgressComplete = GetControl(control, "IsCharacterProgressComplete")
    control.IsCharacterProgressComplete:SetText(boolToText(data.isCharacterProgressComplete))
    control.IsCharacterProgressComplete:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)


    data.AllCount = data.all
    control.AllCount = GetControl(control, "AllCount")
    control.AllCount:SetText(data.AllCount)
    control.AllCount:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    data.Blacksmith = data[CRAFTING_TYPE_BLACKSMITHING]
    control.Blacksmith = GetControl(control, "Blacksmith")
    control.Blacksmith:SetText(data.Blacksmith)
    control.Blacksmith:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    data.Clothier = data[CRAFTING_TYPE_CLOTHIER]
    control.Clothier = GetControl(control, "Clothier")
    control.Clothier:SetText(data.Clothier)
    control.Clothier:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    data.Woodworker = data[CRAFTING_TYPE_WOODWORKING]
    control.Woodworker = GetControl(control, "Woodworker")
    control.Woodworker:SetText(data.Woodworker)
    control.Woodworker:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    data.Jewelry = data[CRAFTING_TYPE_JEWELRYCRAFTING]
    control.Jewelry = GetControl(control, "Jewelry")
    control.Jewelry:SetText(data.Jewelry)
    control.Jewelry:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    data.Alchemy = data[CRAFTING_TYPE_ALCHEMY]
    control.Alchemy = GetControl(control, "Alchemy")
    control.Alchemy:SetText(data.Alchemy)
    control.Alchemy:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    data.Enchanting = data[CRAFTING_TYPE_ENCHANTING]
    control.Enchanting = GetControl(control, "Enchanting")
    control.Enchanting:SetText(data.Enchanting)
    control.Enchanting:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    data.Provisioning = data[CRAFTING_TYPE_PROVISIONING]
    control.Provisioning = GetControl(control, "Provisioning")
    control.Provisioning:SetText(data.Provisioning)
    control.Provisioning:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

local function createIsCharacterProgressCompleteDropDown()
    local validChoices = { 'All' ,'Yes', 'No'}

    MWP_canBeProcessedByWindow_IsCharacterProgressCompleteDropDown.comboBox = MWP_canBeProcessedByWindow_IsCharacterProgressCompleteDropDown.comboBox or ZO_ComboBox_ObjectFromContainer(MWP_canBeProcessedByWindow_IsCharacterProgressCompleteDropDown)
    local comboBox = MWP_canBeProcessedByWindow_IsCharacterProgressCompleteDropDown.comboBox

    local function OnItemSelect(_, choiceText, choice)
        MWP.canBeProcessedByWindow_IsCharacterProgressCompleteDropDown = choiceText
        MWP.CanBeProcessedByUnitList:RefreshData()
    end
    comboBox:SetSortsItems(false)

    for i = 1, #validChoices do
        local entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
        comboBox:AddItem(entry)
    end
    comboBox:SetSelectedItem(MWP.canBeProcessedByWindow_IsCharacterProgressCompleteDropDown)
end


function MWP.CanBeProcessedByOnLoad()
    createIsCharacterProgressCompleteDropDown()

    MWP.CanBeProcessedByUnitList = MWP_CanBeProcessedByWindowClass:New()
    MWP.CanBeProcessedByUnits = {}
    MWP.CanBeProcessedByUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(MWP_canBeProcessedByWindow)
    MWP_canBeProcessedByWindow:SetHidden(true)
end

function MWP.showCanBeProcessedByInventoryListInfo()
    MWP_canBeProcessedByWindow:SetHidden(true)
    MWP.CanBeProcessedByUnits = MWP.prepareDoableListByInventory()
    MWP.CanBeProcessedByUnitList:RefreshData()
    MWP_canBeProcessedByWindow:SetHidden(false)
end

function MWP.showCanBeProcessedByInventoryAndBankListInfo()
    MWP_canBeProcessedByWindow:SetHidden(true)
    MWP.CanBeProcessedByUnits = MWP.prepareDoableListByInventoryAndBank()
    MWP.CanBeProcessedByUnitList:RefreshData()
    MWP_canBeProcessedByWindow:SetHidden(false)
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


