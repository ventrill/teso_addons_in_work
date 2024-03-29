GSMM_onSaleList = ZO_SortFilterList:Subclass()
GSMM_onSaleList.defaults = {}

GSMM.UnitList = nil
GSMM.units = {}

GSMM_onSaleList.SORT_KEYS = {
    ["expiration"] = {},
    ["itemLink"] = { tiebreaker = "expiration" },
    ["timeRemaining"] = { tiebreaker = "expiration" },
    ["stackCount"] = { tiebreaker = "expiration" },
    ["purchasePricePerUnit"] = { tiebreaker = "expiration" },
    ["purchasePrice"] = { tiebreaker = "expiration" },
    ["guildName"] = { tiebreaker = "expiration" },

}

function GSMM_onSaleList:New()
    local units = ZO_SortFilterList.New(self, GSMM_OnSaleListMainWindow)
    return units
end

function GSMM_onSaleList:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("timeRemaining")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "GSMM_OnSaleListUnitRow", 30, function(control, data)
        self:SetupUnitRow(control, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, GSMM_onSaleList.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function GSMM_onSaleList:BuildMasterList()
    GSMM.debug('GSMM_onSaleList:BuildMasterList')
    self.masterList = {}
    local units = GSMM.units
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function GSMM_onSaleList:FilterScrollList()
    GSMM.debug("GSMM_onSaleList:FilterScrollList")
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function GSMM_onSaleList:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

local function formatExpiration(timeLeft)
    return GetDateStringFromTimestamp(timeLeft)
end

local function formatCurrency(amount)
    return zo_strformat("|cffffff<<1>>|r", ZO_Currency_FormatPlatform(CURT_MONEY, amount, ZO_CURRENCY_FORMAT_AMOUNT_ICON))
end

local function formatTimeRemaining(timeLeft)
    local days = 33
    local hours = 0
    local minutes = 0
    days = math.floor(timeLeft / 86400)
    hours = math.floor((timeLeft - days * 86400) / 3600)
    minutes = math.floor((timeLeft - days * 86400 - hours * 3600) / 60)
    return string.format("%dd %dh %dm", days, hours, minutes)
end

function GSMM_onSaleList:SetupUnitRow(control, data)

    control.data = data
    control.itemLink = GetControl(control, "itemLink")
    control.stackCount = GetControl(control, "stackCount")
    control.purchasePricePerUnit = GetControl(control, "purchasePricePerUnit")
    control.purchasePrice = GetControl(control, "purchasePrice")
    control.guildName = GetControl(control, "guildName")
    control.expiration = GetControl(control, "expiration")
    control.timeRemaining = GetControl(control, "timeRemaining")

    control.itemLink:SetText(data.itemLink)
    control.itemLink:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.expiration:SetText(formatExpiration(data.expiration))
    control.expiration:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.timeRemaining:SetText(formatTimeRemaining(data.timeRemaining))
    control.timeRemaining:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

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
    --        GSMM.UnitList:RefreshData()
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

function GSMM.toggleOnSaleWindow()
    GSMM_OnSaleListMainWindow:ToggleHidden()
end

local function InitData()

    GSMM.units = GSMM.getOnSaleItemsList()
    GSMM.UnitList:RefreshData()

    SCENE_MANAGER:ToggleTopLevel(GSMM_OnSaleListMainWindow)
end

function GSMM.OnSaleListOnLoad()

    --GSMM.savedVars = ZO_SavedVars:NewAccountWide("RDLVars", 1, nil, nil)
    --if GSMM.savedVars.DropdownChoice == nil then
    --    GSMM.savedVars.DropdownChoice = {}
    --    GSMM.savedVars.DropdownChoice["Major"] = GSMM.DropdownData["ChoicesMajor"][1]
    --    GSMM.savedVars.DropdownChoice["Zone"] = GSMM.DropdownData["ChoicesZone"][1]
    --    GSMM.savedVars.DropdownChoice["SetType"] = GSMM.DropdownData["ChoicesSetType"][1]
    --end
    GSMM.UnitList = GSMM_onSaleList:New()

    InitData()
    GSMM_OnSaleListMainWindow:SetHidden(true)

    -- RDL_DropdownMajor
    --createInventoryDropdown("Major")
    -- RDL_DropdownZone
    --createInventoryDropdown("Zone")
    -- RDL_DropdownSetType
    --createInventoryDropdown("SetType")

    --SCENE_MANAGER:RegisterTopLevel(GSMM_OnSaleListMainWindow, false)
end

SLASH_COMMANDS["/gsmm.showonsale"] = function()
    GSMM.toggleOnSaleWindow()
end
SLASH_COMMANDS["/gsmm.showonsalelist"] = function()
    GSMM.units = GSMM.getOnSaleItemsList()
    GSMM.UnitList:RefreshData()
end

SLASH_COMMANDS["/gsmm.add2row"] = function()
    local len = #GSMM.units
    for i = len, len + 2 do
        GSMM.units[i] = {
            itemLink = "|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
            timeRemaining = i * 7200,
            expiration = GetTimeStamp() + (i * 7200),
            stackCount = 7,
            purchasePricePerUnit = 6,
            purchasePrice = 150000,
            guildName = 'guildName',
        }
    end
    GSMM.UnitList:RefreshData()
end

SLASH_COMMANDS["/gsmm.showmessage"] = function()
    GSMM.ScreenMessage('same message')
end