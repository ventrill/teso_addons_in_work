local MWP = MasterWritProcessing

MWP_InStockWindowClass = ZO_SortFilterList:Subclass()
MWP_InStockWindowClass.defaults = {}

MWP.InStockUnitList = nil
MWP.InStockUnits = {}

MWP_InStockWindowClass.SORT_KEYS = {
    ["CharacterName"] = {},
    ["AllCount"] = { tiebreaker = "CharacterName" },
    ["FreeSlots"] = { tiebreaker = "CharacterName" },
    ["Blacksmith"] = { tiebreaker = "CharacterName" },
    ["Clothier"] = { tiebreaker = "CharacterName" },
    ["Woodworker"] = { tiebreaker = "CharacterName" },
    ["Jewelry"] = { tiebreaker = "CharacterName" },
    ["Alchemy"] = { tiebreaker = "CharacterName" },
    ["Enchanting"] = { tiebreaker = "CharacterName" },
    ["Provisioning"] = { tiebreaker = "CharacterName" },
}

function MWP_InStockWindowClass:New()
    local units = ZO_SortFilterList.New(self, MWP_inStockWindow)
    return units
end

function MWP_InStockWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("AllCount")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "MWP_InStockWindowUnitList", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, MWP_InStockWindowClass.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function MWP_InStockWindowClass:BuildMasterList()
    self.masterList = {}
    local units = MWP.InStockUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function MWP_InStockWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        if (data.all > 0) then
            table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
        end
    end
end

function MWP_InStockWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function MWP_InStockWindowClass:SetupUnitRow(control, data)

    control.data = data

    -- freeSlots
    control.FreeSlots = GetControl(control, "FreeSlots")
    control.FreeSlots:SetText(data.FreeSlots)
    control.FreeSlots:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)


    data.CharacterName = data.name
    control.CharacterName = GetControl(control, "CharacterName")
    control.CharacterName:SetText(data.CharacterName)
    control.CharacterName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

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

local function createCharacterNameDropDown()
    local validChoices = { 'all' }
    local list = MasterWritProcessing.characterList
    for name, id in pairs(list) do
        table.insert(validChoices, name)
    end

    MWP_inStockWindow_CharacterName.comboBox = MWP_inStockWindow_CharacterName.comboBox or ZO_ComboBox_ObjectFromContainer(MWP_inStockWindow_CharacterName)
    local comboBox = MWP_inStockWindow_CharacterName.comboBox
    local function OnItemSelect(_, choiceText, choice)
        -- d('OnItemSelect', choiceText)
        MWP.showByCharacter(choiceText)
    end
    comboBox:SetSortsItems(false)

    for i = 1, #validChoices do
        local entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
        comboBox:AddItem(entry)
    end
    comboBox:SetSelectedItem('all')
end

function MWP.InStockOnLoad()
    createCharacterNameDropDown()

    MWP.InStockUnitList = MWP_InStockWindowClass:New()
    MWP.InStockUnits = {}
    MWP.InStockUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(MWP_inStockWindow)
    MWP_inStockWindow:SetHidden(true)
end

-- /script MasterWritProcessing.showInStockWindowInfo()
function MWP.showInStockWindowInfo()
    MWP_inStockWindow:SetHidden(true)
    -- MWP.InStockUnits = MWP.prepareInStockInfo()
    MWP.InStockUnits = MWP.prepareInStockInfoList(nil)
    MWP.InStockUnitList:RefreshData()
    MWP_inStockWindow:SetHidden(false)
end
function MWP.showByCharacter(name)
    if name == 'all' then
        MWP.showInStockWindowInfo()
        return
    end

    if not MWP.characterList[name] then
        d('wrong name selected')
        return
    end

    local characterId = MWP.characterList[name]
    MWP_inStockWindow:SetHidden(true)
    -- MWP.InStockUnits = MWP.prepareInStockInfoByCharacterId(characterId)
    MWP.InStockUnits = MWP.prepareInStockInfoList(characterId)
    MWP.InStockUnitList:RefreshData()
    MWP_inStockWindow:SetHidden(false)
end

function MWP.updateInventoryInfo()
    MWP.scanInventory()
    MWP_inStockWindow:SetHidden(true)
    -- MWP.InStockUnits = MWP.prepareInStockInfo()
    MWP.InStockUnits = MWP.prepareInStockInfoList(nil)
    MWP.InStockUnitList:RefreshData()
    MWP_inStockWindow:SetHidden(false)
end
function MWP.updateBankInfo()
    MWP.scanBank()
    MWP_inStockWindow:SetHidden(true)
    -- MWP.InStockUnits = MWP.prepareInStockInfo()
    MWP.InStockUnits = MWP.prepareInStockInfoList(nil)
    MWP.InStockUnitList:RefreshData()
    MWP_inStockWindow:SetHidden(false)
end

SLASH_COMMANDS["/mwp_show_in_stock_list_info"] = function()
    MWP.toggleInStockWindow()
end

-- /script MasterWritProcessing.toggleInStockWindow()
function MWP.toggleInStockWindow()
    -- MWP_inStockWindow:ToggleHidden()
    -- MWP.showInStockWindowInfo()
    if MWP_inStockWindow:IsHidden() then
        MWP.showInStockWindowInfo()
    else
        MWP_inStockWindow:SetHidden(true)
    end

end


