
GSMM_onSaleList = ZO_SortFilterList:Subclass()
GSMM_onSaleList.defaults = {}

GSMM.UnitList = nil
GSMM.units = {}

GSMM_onSaleList.SORT_KEYS = {
    ["expiration"] = {},
    ["itemLink"] = { tiebreaker = "expiration" },
    ["stackCount"] = { tiebreaker = "expiration" },
    ["purchasePricePerUnit"] = { tiebreaker = "expiration" },
    ["purchasePrice"] = { tiebreaker = "expiration" },
    ["guildName"] = { tiebreaker = "expiration" },

}

function GSMM_onSaleList:New()
    local units = ZO_SortFilterList.New(self, OnSaleListMainWindow)
    return units
end

function GSMM_onSaleList:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("itemLink")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "OnSaleListUnitRow", 30, function(control, data)
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

    control.itemLink:SetText(data.itemLink)
    control.expiration:SetText(formatExpiration(data.expiration))
    control.stackCount:SetText(data.stackCount)
    control.purchasePricePerUnit:SetText(data.purchasePricePerUnit)
    control.purchasePrice:SetText(data.purchasePrice)
    control.guildName:SetText(data.guildName)

    ZO_SortFilterList.SetupRow(self, control, data)
end

--function GSMM_onSaleList:Refresh()
--    -- @todo найти вызов похоже на не используемое
--    GSMM.debug('GSMM_onSaleList:Refresh')
--    self:RefreshData()
--end

function GSMM.HeaderMouseEnter(control, tooltipindex)
    if tooltipindex then
        InitializeTooltip(InformationTooltip, control, TOP, -5, 0)
        SetTooltipText(InformationTooltip, GSMM.SORTHEADER_TOOLTIP[tooltipindex])
    end
end

function GSMM.HeaderMouseExit(control, tooltipindex)
    if tooltipindex then
        ClearTooltip(InformationTooltip)
    end
end

--function GSMM.AddInkling()
--
--    --ZO_Tooltip_AddDivider(InformationTooltip)
--    --for i = 1, #GSMM.TOOLTIP_INKLING do
--    --    InformationTooltip:AddLine(GSMM.TOOLTIP_INKLING[i], "ZoFontGameSmall")
--    --end
--end



-- Combobox stuff adapted with permission from manavortex's fabulous FurnitureCatalogue
-- who adapted it from LAM which is under Open License

-- show/hide Tooltips for
function GSMM.DropdownShowTooltip(control, dropdownname, reAnchor)
    --InitializeTooltip(InformationTooltip, control, BOTTOM, 0, 0, 0)
    --InformationTooltip:SetHidden(false)
    --InformationTooltip:ClearLines()
    --InformationTooltip:AddLine(GSMM.DropdownTooltips[dropdownname])
end

function GSMM.DropdownHideTooltip(control)
    --InformationTooltip:ClearLines()
    --InformationTooltip:SetHidden(true)
end

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
    OnSaleListMainWindow:ToggleHidden()
end

function GSMM.InitData()


    GSMM.units = {}
    GSMM.setsminfound = {}

    local data = {} -- GSMM.savedVars[585680]

    for i = 1, #data do
        GSMM.units[i] = {
            itemLink = data[i].itemLink,
            expiration = i * 7200,
            stackCount = 'stackCount' .. i,
            purchasePricePerUnit = 'purchasePricePerUnit' .. i,
            purchasePrice = 'purchasePrice' .. i,
            guildName = 'guildName' .. i,
        }
    end

    GSMM.UnitList:RefreshData()

    SCENE_MANAGER:ToggleTopLevel(OnSaleListMainWindow)
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

    GSMM.InitData()
    OnSaleListMainWindow:SetHidden(false)

    -- RDL_DropdownMajor
    --createInventoryDropdown("Major")
    -- RDL_DropdownZone
    --createInventoryDropdown("Zone")
    -- RDL_DropdownSetType
    --createInventoryDropdown("SetType")

    --SCENE_MANAGER:RegisterTopLevel(OnSaleListMainWindow, false)
end

SLASH_COMMANDS["/gsmm.showonsale"] = function()
    GSMM.toggleOnSaleWindow()
end

SLASH_COMMANDS["/gsmm.add2row"] = function()
    local len = #GSMM.units
    for i = len, len + 2 do
        GSMM.units[i] = {
            itemLink = "|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
            expiration = i * 7200,
            stackCount = 'stackCount' .. i,
            purchasePricePerUnit = 'purchasePricePerUnit' .. i,
            purchasePrice = 'purchasePrice' .. i,
            guildName = 'guildName' .. i,
        }
    end
    GSMM.UnitList:RefreshData()
end




