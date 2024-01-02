TRADING_HOUSE_SCENE:GetName()

self:Wrap("HandleTabSwitch", function(originalHandleTabSwitch, tradingHouse, tabData)
    local oldTab = self.currentTab
    if self.currentTab then
        self.currentTab:OnClose(self)
    end
    originalHandleTabSwitch(tradingHouse, tabData)
    self.currentTab = self.modeToTab[tabData.descriptor]
    if self.currentTab then
        self.currentTab:OnOpen(self)
    end
    AGS.internal:FireCallbacks(AGS.callback.STORE_TAB_CHANGED, oldTab, self.currentTab)
end)


local function TryInitiatingItemPost(bag, index)
    self:UnsetPendingItem()

    if tradingHouseWrapper.interactionHelper:IsBankBag(bag) and not tradingHouseWrapper.interactionHelper:IsBankAvailable() then
        -- TRANSLATORS: alert text when trying to list an item from the bank while not at a banker NPC
        ZO_Alert(UI_ALERT_CATEGORY_ERROR, SOUNDS.NEGATIVE_CLICK, gettext("Bank items can only be listed while at a banker NPC"))
        return
    end
end

------------------------------------------------------

local InteractionHelper = ZO_InitializingObject:Subclass()
AGS.class.InteractionHelper = InteractionHelper

function InteractionHelper:UpdateChatterIndices()
    self.bankChatterIndex = -1
    self.tradingHouseChatterIndex = -1
    for i = 1, GetChatterOptionCount() do
        local _, optionType = GetChatterOption(i)
        if optionType == CHATTER_START_BANK then
            self.bankChatterIndex = i
        elseif optionType == CHATTER_START_TRADINGHOUSE then
            self.tradingHouseChatterIndex = i
        end
    end
end
function InteractionHelper:IsBankAvailable()
    return self.bankChatterIndex > 0
end

function InteractionHelper:IsGuildStoreAvailable()
    return self.tradingHouseChatterIndex > 0
end

function ListingTabWrapper:RefreshListingPriceSumDisplay(tradingHouse)
    local sum = 0
    for i = 1, GetNumTradingHouseListings() do
        local _, _, _, _, _, _, price = GetTradingHouseListingItemInfo(i)
        sum = sum + price
    end

    sum = zo_strformat("|cffffff<<1>>|r", ZO_Currency_FormatPlatform(CURT_MONEY, sum, ZO_CURRENCY_FORMAT_AMOUNT_ICON))
    self.listingPriceSumControl:SetText(gettext("Overall Price: <<1>>", sum))
    tradingHouse:UpdateListingCounts()
end

-- https://github.com/esoui/esoui/blob/c9f8a88114130077403f2c6bb82684f99db06a97/esoui/ingame/tradinghouse/tradinghouse_shared.lua#L29



function ZO_TradingHouse_CreateItemData(index, icon, name, displayQuality, stackCount, sellerName, timeRemaining, purchasePrice, currencyType, itemLink, itemUniqueId, purchasePricePerUnit)
    if name ~= "" and stackCount > 0 then
        local UNIT_PRICE_PRECISION = 0.01
        purchasePricePerUnit = zo_roundToNearest(purchasePricePerUnit, UNIT_PRICE_PRECISION)
        currencyType = currencyType or CURT_MONEY

        local result =
        {
            slotIndex = index,
            icon = icon,
            name = name,
            displayQuality = displayQuality,
            -- quality is deprecated, included here for addon backwards compatibility
            quality = displayQuality,
            stackCount = stackCount,
            sellerName = sellerName,
            timeRemaining = timeRemaining,
            purchasePrice = purchasePrice,
            purchasePricePerUnit = purchasePricePerUnit,
            currencyType = currencyType,
            itemLink = itemLink,
            itemUniqueId = itemUniqueId,
        }

        return result
    end

    return nil
end

-- https://github.com/esoui/esoui/blob/c9f8a88114130077403f2c6bb82684f99db06a97/esoui/ingame/tradinghouse/tradinghouse_shared.lua#L59C1-L64C1
function ZO_TradingHouse_CreateListingItemData(index)
    local icon, name, displayQuality, stackCount, sellerName, timeRemaining, purchasePrice, currencyType, itemUniqueId, purchasePricePerUnit = GetTradingHouseListingItemInfo(index)
    local itemLink = GetTradingHouseListingItemLink(index)
    return ZO_TradingHouse_CreateItemData(index, icon, name, displayQuality, stackCount, sellerName, timeRemaining, purchasePrice, currencyType, itemLink, itemUniqueId, purchasePricePerUnit)
end

EVENT_MANAGER:RegisterForEvent(ZO_TRADING_HOUSE_SYSTEM_NAME, EVENT_OPEN_TRADING_HOUSE, function() OnTradingHouseOpen() end)
EVENT_MANAGER:RegisterForEvent(ZO_TRADING_HOUSE_SYSTEM_NAME, EVENT_CLOSE_TRADING_HOUSE, function() OnCloseTradingHouse() end)

TRADING_HOUSE_SEARCH:RegisterCallback("OnSelectedGuildChanged", FilterForKeyboardEvents(function() self:UpdateForGuildChange() end))


function ZO_TradingHouse_Shared:GetCurrentMode()
    return self.currentMode
end

function ZO_TradingHouse_Shared:SetCurrentMode(mode)
    self.currentMode = mode
end

function ZO_TradingHouse_Shared:IsInSellMode()
    return self.currentMode == ZO_TRADING_HOUSE_MODE_SELL
end

function ZO_TradingHouse_Shared:IsInSearchMode()
    return self.currentMode == ZO_TRADING_HOUSE_MODE_BROWSE
end

--https://github.com/esoui/esoui/blob/c9f8a88114130077403f2c6bb82684f99db06a97/esoui/ingame/tradinghouse/tradinghouse_shared.lua#L147
function ZO_TradingHouse_Shared:IsInListingsMode()
    return self.currentMode == ZO_TRADING_HOUSE_MODE_LISTINGS
end

--https://github.com/esoui/esoui/blob/c9f8a88114130077403f2c6bb82684f99db06a97/esoui/ingame/tradinghouse/tradinghouse_shared.lua




function ZO_TradingHouseManager:RebuildListingsScrollList()
    local list = self.postedItemsList
    local scrollData = ZO_ScrollList_GetDataList(list)
    ZO_ScrollList_Clear(list)

    for i = 1, GetNumTradingHouseListings() do
        local itemData = ZO_TradingHouse_CreateListingItemData(i)
        if itemData then
            scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(ITEM_LISTINGS_DATA_TYPE, itemData)
        end
    end

    ZO_ScrollList_Commit(list)

    self.noPostedItemsLabel:SetHidden(#scrollData > 0)
end
