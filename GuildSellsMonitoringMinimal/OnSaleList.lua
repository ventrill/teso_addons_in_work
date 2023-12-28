local Addon = {}
Addon.Name = GSMM.addonName

-- Unitlist stuff adapted from Scroll List Example Addon

GSMM_onSaleList = ZO_SortFilterList:Subclass()
GSMM_onSaleList.defaults = {}

GSMM.UnitList = nil
GSMM.units = {}

GSMM_onSaleList.SORT_KEYS = {
    ["itemLink"] = {},
    ["Zone"] = { tiebreaker = "itemLink" },
    ["Location"] = { tiebreaker = "itemLink" },
    ["Diff"] = { tiebreaker = "itemLink" },
    ["Lore"] = { tiebreaker = "itemLink" },
    ["Dug"] = { tiebreaker = "itemLink" },
    ["Set"] = { tiebreaker = "itemLink" },
    ["Expiration"] = { tiebreaker = "itemLink" }
}

function GSMM_onSaleList:New()
    local units = ZO_SortFilterList.New(self, RDLMainWindow)
    return units
end

function GSMM_onSaleList:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("itemLink")
    --ZO_SortHeader_OnMouseExit(RDLMainWindowHeadersName)

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "RDLUnitRow", 30, function(control, data)
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
    for k, v in pairs(units) do
        local data = v
        data["Aid"] = k
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

local function getColorCode(intvalue)

    if intvalue == 1 then
        return GSMM.GREEN_TEXT
    elseif intvalue == 2 then
        return GSMM.BLUE_TEXT
    elseif intvalue == 3 then
        return GSMM.PURPLE_TEXT
    elseif intvalue == 4 then
        return GSMM.GOLD_TEXT
    elseif intvalue == 5 then
        return GSMM.ORANGE_TEXT
    else
        return GSMM.DEFAULT_TEXT
    end
end

local function formatExpiration(leadtimeleft)

    local ltld = 33
    local ltlh = 0
    local ltlm = 0
    local ltls = 0
    ltld = math.floor(leadtimeleft / 86400)
    ltlh = math.floor((leadtimeleft - ltld * 86400) / 3600)
    ltlm = math.floor((leadtimeleft - ltld * 86400 - ltlh * 3600) / 60)
    return string.format("%dd %dh %dm", ltld, ltlh, ltlm)
end

local function colorizeExpiration(leadtimeleft)

    if leadtimeleft < 3600 then
        return GSMM.RED_TEXT
    elseif leadtimeleft < 86400 then
        return GSMM.ORANGE_TEXT
    elseif leadtimeleft < 604800 then
        return GSMM.YELLOW_TEXT
    else
        return GSMM.GREEN_TEXT
    end
end

function GSMM_onSaleList:SetupUnitRow(control, data)

    control.data = data
    control.itemLink = GetControl(control, "itemLink")
    control.Zone = GetControl(control, "Zone")
    control.Location = GetControl(control, "Location")
    control.Diff = GetControl(control, "Diff")
    control.Lore = GetControl(control, "Lore")
    control.Dug = GetControl(control, "Dug")
    control.Set = GetControl(control, "Set")
    control.Expiration = GetControl(control, "Expiration")

    local formatbegin = ""
    local formatend = ""
    --if (not data.Repeatable and (data.Dug == 1)) or (data.SetId > 0 and data.Dug > GSMM.setsminfound[data.SetId]) then
    --    formatbegin = "|l0:1:0:-25%:2:000000|l"
    --    formatend = "|l"
    --end
    control.itemLink:SetText(formatbegin .. data.itemLink .. formatend)
    control.Zone:SetText(formatbegin .. data.Zone .. formatend)
    control.Location:SetText(formatbegin .. data.Location .. formatend)
    control.Diff:SetText(data.Diff)
    control.Lore:SetText(data.Lore)
    control.Dug:SetText(data.Dug)
    control.Set:SetText(formatbegin .. data.Set .. formatend)
    if data.HaveLead then
        control.Expiration:SetText(formatExpiration(data.Expiration))
    else
        control.Expiration:SetText("")
    end

    --control.itemLink.normalColor = getColorCode(data.Diff)
    --control.Zone.normalColor = getColorCode(data.Diff)
    --control.Location.normalColor = getColorCode(data.Diff)
    --control.Diff.normalColor = getColorCode(data.Diff)
    --control.Lore.normalColor = getColorCode(data.Diff)
    --control.Dug.normalColor = getColorCode(data.Diff)
    --control.Set.normalColor = getColorCode(data.SetQuality)
    --control.Expiration.normalColor = colorizeExpiration(data.Expiration)

    ZO_SortFilterList.SetupRow(self, control, data)
end

function GSMM_onSaleList:Refresh()
    GSMM.debug('GSMM_onSaleList:Refresh')
    self:RefreshData()
end

function GSMM.HeaderMouseEnter(control, tooltipindex)

    if tooltipindex then
        InitializeTooltip(InformationTooltip, control, LEFT, -5, 0)
        SetTooltipText(InformationTooltip, GSMM.SORTHEADER_TOOLTIP[tooltipindex])
    end

end

function GSMM.HeaderMouseExit(control, tooltipindex)

    if tooltipindex then
        ClearTooltip(InformationTooltip)
    end
end

function GSMM.AddInkling()

    --ZO_Tooltip_AddDivider(InformationTooltip)
    --for i = 1, #GSMM.TOOLTIP_INKLING do
    --    InformationTooltip:AddLine(GSMM.TOOLTIP_INKLING[i], "ZoFontGameSmall")
    --end
end

function GSMM.RowMouseEnter(control)
    --GSMM.UnitList:Row_OnMouseEnter(control)
end

function GSMM.RowMouseExit(control)
    --GSMM.UnitList:Row_OnMouseExit(control)
end

function GSMM.RowMouseUp(control)

end

function GSMM.LeadfoundMouseEnter(control)

    --InitializeTooltip(InformationTooltip, control, BOTTOMLEFT, 0, 0)
    --local minX, minY, maxX, maxY = InformationTooltip:GetDimensionConstraints()
    --GSMM.OrigToolTipMaxX = maxX
    --InformationTooltip:SetDimensionConstraints(minX, minY, 450, maxY)
    --for i = 1, #GSMM.TOOLTIP_URL do
    --    InformationTooltip:AddLine(GSMM.TOOLTIP_URL[i], "", 1,1,1, LEFT, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_LEFT, true)
    --end
    --GSMM.AddInkling()
end

function GSMM.LeadfoundMouseExit(control)

    --if GSMM.OrigToolTipMaxX ~= nil then
    --    InformationTooltip:SetDimensionConstraints(minX, minY, GSMM.OrigToolTipMaxX, maxY)
    --end
    --ClearTooltip(InformationTooltip)
end



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
    RDLMainWindow:ToggleHidden()
end

function GSMM.InitData()


    GSMM.units = {}
    GSMM.setsminfound = {}

    local data = {} -- GSMM.savedVars[585680]

    for i = 1, #data do
        GSMM.units[i] = {
            itemLink = data[i].itemLink,
            --Lead = 'lead' .. i,
            Zone = 'Zone' .. i,
            ZoneId = 'ZoneId' .. i,
            Location = 'Location' .. i,
            Diff = 'diff' .. i,
            Lore = 'lore' .. i,
            Dug = 'Dug' .. i,
            Set = 'Set' .. i,
            SetId = 'SetId' .. i,
            Expiration = i * 7200,
            SetQuality = 'SetQuality' .. i,
            HaveLead = 'HaveLead' .. i,
            Repeatable = 'Repeatable' .. i,
        }
    end

    GSMM.UnitList:RefreshData()

    SCENE_MANAGER:ToggleTopLevel(RDLMainWindow)
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
    RDLMainWindow:SetHidden(false)

    -- RDL_DropdownMajor
    --createInventoryDropdown("Major")
    -- RDL_DropdownZone
    --createInventoryDropdown("Zone")
    -- RDL_DropdownSetType
    --createInventoryDropdown("SetType")

    SCENE_MANAGER:RegisterTopLevel(RDLMainWindow, false)
end

SLASH_COMMANDS["/gsmm.showonsale"] = function()
    GSMM.toggleOnSaleWindow()
end

SLASH_COMMANDS["/gsmm.add2row"] = function()
    local len = #GSMM.units
    for i = len, len + 2 do
        GSMM.units[i] = {
            itemLink="|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
            --Lead = 'lead' .. i,
            Zone = 'Zone' .. i,
            ZoneId = 'ZoneId' .. i,
            Location = 'Location' .. i,
            Diff = 'diff' .. i,
            Lore = 'lore' .. i,
            Dug = 'Dug' .. i,
            Set = 'Set' .. i,
            SetId = 'SetId' .. i,
            Expiration = i * 7200,
            SetQuality = 'SetQuality' .. i,
            HaveLead = 'HaveLead' .. i,
            Repeatable = 'Repeatable' .. i,
        }
    end
    GSMM.UnitList:RefreshData()
end




