GSMM_soldList = ZO_SortFilterList:Subclass()
GSMM_soldList.defaults = {}

GSMM.soldUnitList = nil
GSMM.soldUnits = {}

GSMM_soldList.SORT_KEYS = {
    ["addedToSoldAt"] = {},
    ["lastFoundAt"] = { tiebreaker = "addedToSoldAt" },
    ["itemLink"] = { tiebreaker = "addedToSoldAt" },
    ["stackCount"] = { tiebreaker = "addedToSoldAt" },
    ["purchasePricePerUnit"] = { tiebreaker = "addedToSoldAt" },
    ["purchasePrice"] = { tiebreaker = "addedToSoldAt" },
}

function GSMM_soldList:New()
    local units = ZO_SortFilterList.New(self, GSMM_SoldListMainWindow)
    return units
end

function GSMM_soldList:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("addedToSoldAt")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "GSMM_SoldListUnitRow", 30, function(control, data)
        self:SetupUnitRow(control, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, GSMM_soldList.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function GSMM_soldList:BuildMasterList()
    GSMM.debug('GSMM_soldList:BuildMasterList')
    self.masterList = {}
    local units = GSMM.soldUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function GSMM_soldList:FilterScrollList()
    GSMM.debug("GSMM_soldList:FilterScrollList")
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function GSMM_soldList:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

local function formatDateTime(timestamp)
    if not timestamp then
        return "-"
    end
    local timeStr = ZO_FormatTime(timestamp % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR)
    return string.format("%s %s", GetDateStringFromTimestamp(timestamp), timeStr)
end

local function formatCurrency(amount)
    return zo_strformat("|cffffff<<1>>|r", ZO_Currency_FormatPlatform(CURT_MONEY, amount, ZO_CURRENCY_FORMAT_AMOUNT_ICON))
end

function GSMM_soldList:SetupUnitRow(control, data)

    control.data = data
    control.itemLink = GetControl(control, "itemLink")
    control.stackCount = GetControl(control, "stackCount")
    control.purchasePricePerUnit = GetControl(control, "purchasePricePerUnit")
    control.purchasePrice = GetControl(control, "purchasePrice")
    control.addedToSoldAt = GetControl(control, "addedToSoldAt")
    control.lastFoundAt = GetControl(control, "lastFoundAt")

    control.itemLink:SetText(data.itemLink)
    control.itemLink:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.addedToSoldAt:SetText(formatDateTime(data.addedToSoldAt))
    control.addedToSoldAt:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.lastFoundAt:SetText(formatDateTime(data.lastFoundAt))
    control.lastFoundAt:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.stackCount:SetText(data.stackCount)
    control.stackCount:SetHorizontalAlignment(TEXT_ALIGN_CENTER)

    control.purchasePricePerUnit:SetText(formatCurrency(data.purchasePricePerUnit))
    control.purchasePricePerUnit:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.purchasePrice:SetText(formatCurrency(data.purchasePrice))
    control.purchasePrice:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end


-- Combobox stuff adapted with permission from manavortex's fabulous FurnitureCatalogue
-- who adapted it from LAM which is under Open License



-- Dropdown setup
local function createInventoryDropdown(dropdownName)
    --    local controlName     = string.format("%s%s", "RDL_Dropdown", dropdownName)
    --    local control       = _G[controlName]
    --    local dropdownData     = GSMM.DropdownData
    --    local validChoices     = dropdownData[string.format("%s%s", "Choices", dropdownName)]
    --    local choicesTooltips   = dropdownData[string.format("%s%s", "Tooltips", dropdownName)]
    --    local comboBox
    --
    --
    --    control.comboBox = control.comboBox or ZO_ComboBox_ObjectFromContainer(control)
    --    comboBox = control.comboBox
    --    comboBox:SetHeight(800)
    --    local function HideTooltip(control)
    --        ClearTooltip(InformationTooltip)
    --    end
    --
    --
    --    local function SetupTooltips(comboBox, choicesTooltips)
    --
    --        local function ShowTooltip(control)
    --            InitializeTooltip(InformationTooltip, control, TOPRIGHT, -10, 0, TOPLEFT)
    --            SetTooltipText(InformationTooltip, control.tooltip)
    --            InformationTooltipTopLevel:BringWindowToTop()
    --        end
    --
    --
    --        -- allow for tooltips on the drop down entries
    --        local originalShow = comboBox.ShowDropdownInternal
    --        comboBox.ShowDropdownInternal = function(comboBox)
    --            originalShow(comboBox)
    --            local entries = ZO_Menu.items
    --            for i = 1, #entries do
    --
    --                local entry = entries[i]
    --                local control = entries[i].item
    --                control.tooltip = choicesTooltips[i]
    --                if control.tooltip then
    --                    entry.onMouseEnter = control:GetHandler("OnMouseEnter")
    --                    entry.onMouseExit = control:GetHandler("OnMouseExit")
    --                    ZO_PreHookHandler(control, "OnMouseEnter", ShowTooltip)
    --                    ZO_PreHookHandler(control, "OnMouseExit", HideTooltip)
    --                end
    --
    --            end
    --        end
    --
    --        local originalHide = comboBox.HideDropdownInternal
    --        comboBox.HideDropdownInternal = function(self)
    --            local entries = ZO_Menu.items
    --            for i = 1, #entries do
    --                local entry = entries[i]
    --                local control = entries[i].item
    --                control:SetHandler("OnMouseEnter", entry.onMouseEnter)
    --                control:SetHandler("OnMouseExit", entry.onMouseExit)
    --                control.tooltip = nil
    --            end
    --            HideTooltip(self)
    --            originalHide(self)
    --        end
    --    end
    --
    --    function OnItemSelect(control, choiceText, somethingElse)
    --        local dropdownName = tostring(control.m_name):gsub("RDL_Dropdown", "")
    --        GSMM.savedVars.DropdownChoice[dropdownName] = choiceText
    --        HideTooltip(control)
    --        PlaySound(SOUNDS.POSITIVE_CLICK)
    --        GSMM.soldUnitList:RefreshData()
    --    end
    --
    --    comboBox:SetSortsItems(false)
    --    local originalShow = comboBox.ShowDropdownInternal
    --
    --    local choice = validChoices[1]
    --    if GSMM.savedVars.DropdownChoice[dropdownName]  ~= nil then
    --        choice = GSMM.savedVars.DropdownChoice[dropdownName]
    --    else
    --        GSMM.savedVars.DropdownChoice[dropdownName] = choice
    --    end
    --    local foundStoredSelected = false
    --    for i = 1, #validChoices do
    --        entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
    --        comboBox:AddItem(entry)
    --        if validChoices[i] == choice then
    --            foundStoredSelected = true
    --            comboBox:SetSelectedItem(validChoices[i])
    --        end
    --    end
    --    if not foundStoredSelected then
    --        comboBox:SetSelectedItem(validChoices[1])
    --        GSMM.savedVars.DropdownChoice[dropdownName] = validChoices[1]
    --    end
    --    SetupTooltips(comboBox, dropdownData["Tooltips"..dropdownName])
    --
    --    return control
end

function GSMM.toggleSoldWindow()
    GSMM_SoldListMainWindow:ToggleHidden()
end

local function InitData()

    GSMM.soldUnits = GSMM.getSoldItemsList()
    GSMM.soldUnitList:RefreshData()

    SCENE_MANAGER:ToggleTopLevel(GSMM_SoldListMainWindow)
end

function GSMM.SoldListOnLoad()

    GSMM.soldUnitList = GSMM_soldList:New()

    InitData()
    GSMM_SoldListMainWindow:SetHidden(true)


end

SLASH_COMMANDS["/gsmm.showsold"] = function()
    GSMM.toggleSoldWindow()
end

SLASH_COMMANDS["/gsmm.showsoldlist"] = function()
    GSMM.soldUnits = GSMM.getSoldItemsList()
    GSMM.soldUnitList:RefreshData()
end

