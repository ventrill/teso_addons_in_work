GSMM_actualListing = ZO_SortFilterList:Subclass()
GSMM_actualListing.defaults = {}

GSMM.actualListingUnitList = nil
GSMM.actualListingUnits = {}

GSMM_actualListing.SORT_KEYS = {
    ["expiration"] = {},
    ["itemLink"] = { tiebreaker = "expiration" },
    ["timeRemaining"] = { tiebreaker = "expiration" },
    ["stackCount"] = { tiebreaker = "expiration" },
    ["purchasePricePerUnit"] = { tiebreaker = "expiration" },
    ["purchasePrice"] = { tiebreaker = "expiration" },
}

function GSMM_actualListing:New()
    local units = ZO_SortFilterList.New(self, GSMM_ActualListingMainWindow)
    return units
end

function GSMM_actualListing:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("timeRemaining")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "GSMM_ActualListingUnitRow", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, GSMM_actualListing.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function GSMM_actualListing:BuildMasterList()
    GSMM.debug('GSMM_actualListing:BuildMasterList')
    self.masterList = {}
    local units = GSMM.actualListingUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function GSMM_actualListing:FilterScrollList()
    GSMM.debug("GSMM_actualListing:FilterScrollList")
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function GSMM_actualListing:SortScrollList()
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

function GSMM_actualListing:SetupUnitRow(control, data)

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

function GSMM.toggleActualListingWindow()
    GSMM_ActualListingMainWindow:ToggleHidden()
end
function GSMM.showActualListingWindow()
    GSMM_ActualListingMainWindow:SetHidden(false)
end
function GSMM.closeActualListingWindow()
    GSMM_ActualListingMainWindow:SetHidden(true)
end

local function InitData()
    GSMM.actualListingUnits = {}
    GSMM.actualListingUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(GSMM_ActualListingMainWindow)
end

function GSMM.actualListingOnLoad()
    GSMM.actualListingUnitList = GSMM_actualListing:New()
    InitData()
    GSMM_ActualListingMainWindow:SetHidden(true)
end



function GSMM.setActualListingData(data)
    GSMM.actualListingUnits = data
    -- updateTotalInfo()
    GSMM.actualListingUnitList:RefreshData()
end

SLASH_COMMANDS["/gsmm.showactual"] = function()
    GSMM.toggleActualListingWindow()
end

SLASH_COMMANDS["/gsmm.add2rowactual"] = function()
    local len = #GSMM.actualListingUnits
    for i = len, len + 2 do
        table.insert(GSMM.actualListingUnits, {
            itemLink = "|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
            timeRemaining = i * 7200,
            expiration = GetTimeStamp() + (i * 7200),
            stackCount = 7,
            purchasePricePerUnit = 6,
            purchasePrice = 150000,
            guildName = 'guildName',
        })
    end
    GSMM.actualListingUnitList:RefreshData()
end

SLASH_COMMANDS["/gsmm.showmessage"] = function()
    GSMM.ScreenMessage('same message')
end