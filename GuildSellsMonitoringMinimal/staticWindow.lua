function GSMM.toggleStatisticWindow()
    GSMM_StatisticWindow:ToggleHidden()
end

GSMM_statistic = ZO_SortFilterList:Subclass()
GSMM_statistic.defaults = {}

GSMM.statisticUnitList = nil
GSMM.statisticUnits = {}

GSMM_statistic.SORT_KEYS = {
    ["SoldSum"] = {},
    ["LastScanAt"] = { tiebreaker = "SoldSum" },
    ["ItemsSoldCount"] = { tiebreaker = "SoldSum" },
    ["GuildName"] = { tiebreaker = "SoldSum" },
}

function GSMM_statistic:New()
    local units = ZO_SortFilterList.New(self, GSMM_StatisticWindow)
    return units
end

function GSMM_statistic:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("SoldSum")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "GSMM_StatisticWindowUnitRow", 30, function(control, data)
        self:SetupUnitRow(control, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, GSMM_statistic.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function GSMM_statistic:BuildMasterList()
    GSMM.debug('GSMM_statistic:BuildMasterList')
    self.masterList = {}
    local units = GSMM.statisticUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function GSMM_statistic:FilterScrollList()
    GSMM.debug("GSMM_statistic:FilterScrollList")
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function GSMM_statistic:SortScrollList()
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

function GSMM_statistic:SetupUnitRow(control, data)

    control.data = data
    control.ItemsSoldCount = GetControl(control, "ItemsSoldCount")
    control.GuildName = GetControl(control, "GuildName")
    control.SoldSum = GetControl(control, "SoldSum")
    control.LastScanAt = GetControl(control, "LastScanAt")

    control.SoldSum:SetText(formatCurrency(data.SoldSum))
    control.SoldSum:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.LastScanAt:SetText(formatDateTime(data.LastScanAt))
    control.LastScanAt:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.ItemsSoldCount:SetText(data.ItemsSoldCount)
    control.ItemsSoldCount:SetHorizontalAlignment(TEXT_ALIGN_CENTER)

    control.GuildName:SetText(data.GuildName)
    control.GuildName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    ZO_SortFilterList.SetupRow(self, control, data)
end




-- Combobox stuff adapted with permission from manavortex's fabulous FurnitureCatalogue
-- who adapted it from LAM which is under Open License

-- show/hide Tooltips for
function GSMM.DropdownShowTooltip(control, dropdownname)
    if GSMM.DropdownTooltips[dropdownname] then
        InitializeTooltip(InformationTooltip, control, BOTTOMLEFT, 0, -2, TOPLEFT)
        InformationTooltip:SetHidden(false)
        InformationTooltip:ClearLines()
        InformationTooltip:AddLine(GSMM.DropdownTooltips[dropdownname])
    end
end
function GSMM.DropdownHideTooltip(control)
    InformationTooltip:ClearLines()
    InformationTooltip:SetHidden(true)
end

local function InitData()

    GSMM.statisticUnits = GSMM.getSalesStatistic()
    GSMM.statisticUnitList:RefreshData()

    SCENE_MANAGER:ToggleTopLevel(GSMM_StatisticWindow)
end

function GSMM.statisticOnLoad()
    GSMM.statisticUnitList = GSMM_statistic:New()
    InitData()
    GSMM_StatisticWindow:SetHidden(true)
end

SLASH_COMMANDS["/gsmm.showstatwindow"] = function()
    GSMM.toggleStatisticWindow()
end

SLASH_COMMANDS["/gsmm.showstatistic"] = function()
    GSMM.statisticUnits = GSMM.getSalesStatistic()
    GSMM.statisticUnitList:RefreshData()
end


