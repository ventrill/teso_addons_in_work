GSMM_ComparisonResult = ZO_SortFilterList:Subclass()
GSMM_ComparisonResult.defaults = {}

GSMM.ComparisonResultUnitList = nil
GSMM.ComparisonResultUnits = {}

GSMM_ComparisonResult.SORT_KEYS = {
    ["expiration"] = {},
    ["status"] = { tiebreaker = "expiration" },
    ["itemLink"] = { tiebreaker = "expiration" },
    ["timeRemaining"] = { tiebreaker = "expiration" },
    ["stackCount"] = { tiebreaker = "expiration" },
    ["purchasePricePerUnit"] = { tiebreaker = "expiration" },
    ["purchasePrice"] = { tiebreaker = "expiration" },
}

function GSMM_ComparisonResult:New()
    local units = ZO_SortFilterList.New(self, GSMM_ComparisonResultMainWindow)
    return units
end

function GSMM_ComparisonResult:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("status")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "GSMM_ComparisonResultUnitRow", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, GSMM_ComparisonResult.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function GSMM_ComparisonResult:BuildMasterList()
    GSMM.debug('GSMM_actualListing:BuildMasterList')
    self.masterList = {}
    local units = GSMM.ComparisonResultUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function GSMM_ComparisonResult:FilterScrollList()
    GSMM.debug("GSMM_actualListing:FilterScrollList")
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function GSMM_ComparisonResult:SortScrollList()
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

function GSMM_ComparisonResult:SetupUnitRow(control, data)

    control.data = data
    control.status = GetControl(control, "status")
    control.itemLink = GetControl(control, "itemLink")
    control.stackCount = GetControl(control, "stackCount")
    control.purchasePricePerUnit = GetControl(control, "purchasePricePerUnit")
    control.purchasePrice = GetControl(control, "purchasePrice")
    control.guildName = GetControl(control, "guildName")
    control.expiration = GetControl(control, "expiration")
    control.timeRemaining = GetControl(control, "timeRemaining")

    control.status:SetText(data.status)
    control.status:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

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

function GSMM.toggleComparisonResultWindow()
    GSMM_ComparisonResultMainWindow:ToggleHidden()
end
function GSMM.showComparisonResultWindow()
    GSMM_ComparisonResultMainWindow:SetHidden(false)
end
function GSMM.closeComparisonResultWindow()
    GSMM_ComparisonResultMainWindow:SetHidden(true)
end

local function InitData()
    GSMM.ComparisonResultUnits = {}
    GSMM.ComparisonResultUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(GSMM_ComparisonResultMainWindow)
end

function GSMM.ComparisonResultOnLoad()
    GSMM.ComparisonResultUnitList = GSMM_ComparisonResult:New()
    InitData()
    GSMM_ComparisonResultMainWindow:SetHidden(true)
end

function GSMM.ComparisonResultData(data)
    GSMM.ComparisonResultUnits = data
    -- updateTotalInfo()
    GSMM.ComparisonResultUnitList:RefreshData()
end

SLASH_COMMANDS["/gsmm_show_comparison_result"] = function()
    GSMM.toggleComparisonResultWindow()
end
SLASH_COMMANDS["/gsmm_show_comparison_result_add2"] = function()
    GSMM.closeComparisonResultWindow()
    local len = #GSMM.ComparisonResultUnits
    for i = len, len + 2 do
        table.insert(GSMM.ComparisonResultUnits, {
            itemLink = "|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
            timeRemaining = i * 7200,
            expiration = GetTimeStamp() + (i * 7200),
            stackCount = 7,
            purchasePricePerUnit = 6,
            purchasePrice = 150000,
            status = "status 1"
        })
        table.insert(GSMM.ComparisonResultUnits, {
            itemLink = "|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
            timeRemaining = i * 3 * 7200,
            expiration = GetTimeStamp() + (i * 3 * 7200),
            stackCount = 7,
            purchasePricePerUnit = 6,
            purchasePrice = 150000,
            status = "status 2"
        })
    end
    GSMM.ComparisonResultUnitList:RefreshData()
    GSMM.showComparisonResultWindow()
end


