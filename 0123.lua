ZO_Alert(UI_ALERT_CATEGORY_ERROR, SOUNDS.NEGATIVE_CLICK, "deletePackAlertStr")

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

local itemLink='';
local itemId = GetItemLinkItemId(itemLink)


print(string.format("unit count %d", #units))

local amount = 53
print(amount / 5) -- 10.6
print(math.floor(amount/5)) -- 10
print(amount % 5) -- 3

print(amount / 7) -- 10.6
print(math.floor(amount/7)) -- 10
print(math.fmod(amount , 7)) -- 3


function DailyProvisioning:GetHouseBankIdList()

    local houseBankBagId = GetBankingBag()
    if GetInteractionType() == INTERACTION_BANK
            and IsOwnerOfCurrentHouse()
            and IsHouseBankBag(houseBankBagId) then
        return {houseBankBagId}

    elseif IsOwnerOfCurrentHouse() then
        return {BAG_HOUSE_BANK_ONE,
                BAG_HOUSE_BANK_TWO,
                BAG_HOUSE_BANK_THREE,
                BAG_HOUSE_BANK_FOUR,
                BAG_HOUSE_BANK_FIVE,
                BAG_HOUSE_BANK_SIX,
                BAG_HOUSE_BANK_SEVEN,
                BAG_HOUSE_BANK_EIGHT,
                BAG_HOUSE_BANK_NINE,
                BAG_HOUSE_BANK_TEN}
    end
    return {}
end

mappingVars.houseBankBagIdToBag = {
    [1]  = BAG_HOUSE_BANK_ONE,
    [2]  = BAG_HOUSE_BANK_TWO,
    [3]  = BAG_HOUSE_BANK_THREE,
    [4]  = BAG_HOUSE_BANK_FOUR,
    [5]  = BAG_HOUSE_BANK_FIVE,
    [6]  = BAG_HOUSE_BANK_SIX,
    [7]  = BAG_HOUSE_BANK_SEVEN,
    [8]  = BAG_HOUSE_BANK_EIGHT,
    [9]  = BAG_HOUSE_BANK_NINE,
    [10] = BAG_HOUSE_BANK_TEN,
}


--- returns a noun for the bagId
---@param bagId number the id of the bag
---@return string the name of the bag
local function getBagName(bagId)
    if bagId == BAG_WORN then
        return GetString(SI_PA_NS_BAG_EQUIPMENT)
    elseif bagId == BAG_BACKPACK then
        return GetString(SI_PA_NS_BAG_BACKPACK)
    elseif bagId == BAG_BANK then
        return GetString(SI_PA_NS_BAG_BANK)
    elseif bagId == BAG_SUBSCRIBER_BANK then
        return GetString(SI_PA_NS_BAG_SUBSCRIBER_BANK)
    elseif bagId == BAG_VIRTUAL then
        return GetString(SI_PA_NS_BAG_VIRTUAL)
    elseif bagId == BAG_HOUSE_BANK_ONE or bagId == BAG_HOUSE_BANK_TWO or bagId == BAG_HOUSE_BANK_THREE or bagId == BAG_HOUSE_BANK_FOUR
            or bagId == BAG_HOUSE_BANK_FIVE or bagId == BAG_HOUSE_BANK_SIX or bagId == BAG_HOUSE_BANK_SEVEN or bagId == BAG_HOUSE_BANK_EIGHT
            or bagId == BAG_HOUSE_BANK_NINE or bagId == BAG_HOUSE_BANK_TEN then
        return GetString(SI_PA_NS_BAG_HOUSE_BANK)
    else
        return GetString(SI_PA_NS_BAG_UNKNOWN)
    end
end


local function OnChestSelect(_, choiceText, choice)
    -- p("OnChestSelect '<<1>>' - <<2>>", choiceText, choice)
    local ctr, cName, cId
    for ctr = BAG_HOUSE_BANK_ONE, BAG_HOUSE_BANK_TEN do
        cId = GetCollectibleForHouseBankBag(ctr)
        cName = GetCollectibleNickname(cId)
        if cName == self.EMPTY_STRING then
            cName = GetCollectibleName(cId)
        end
        cName = ZO_CachedStrFormat(SI_COLLECTIBLE_NAME_FORMATTER, cName)
        if cName == choiceText then
            IIfA:SetInventoryListFilter("Housing Storage", ctr)
            break
        end
    end
    IIfA:RefreshInventoryScroll()
    PlaySound(SOUNDS.POSITIVE_CLICK)
end

local ctr, cName, cId
for ctr = BAG_HOUSE_BANK_ONE, BAG_HOUSE_BANK_TEN do
    cId = GetCollectibleForHouseBankBag(ctr)
    if IsCollectibleUnlocked(cId) then
        cName = GetCollectibleNickname(cId)
        if cName == self.EMPTY_STRING then
            cName = GetCollectibleName(cId)
        end
        cName = ZO_CachedStrFormat(SI_COLLECTIBLE_NAME_FORMATTER, cName)
        entry = comboBox:CreateItemEntry(cName, OnChestSelect)
        comboBox:AddItem(entry)
    end
end

IIfA.trackedBags = {
    [BAG_WORN] = true,
    [BAG_BACKPACK] = true,
    [BAG_BANK] = true,
    [BAG_SUBSCRIBER_BANK] = true,
    [BAG_GUILDBANK] = true,
    [BAG_VIRTUAL] = true,
    [BAG_HOUSE_BANK_ONE] = true,
    [BAG_HOUSE_BANK_TWO] = true,
    [BAG_HOUSE_BANK_THREE] = true,
    [BAG_HOUSE_BANK_FOUR] = true,
    [BAG_HOUSE_BANK_FIVE] = true,
    [BAG_HOUSE_BANK_SIX] = true,
    [BAG_HOUSE_BANK_SEVEN] = true,
    [BAG_HOUSE_BANK_EIGHT] = true,
    [BAG_HOUSE_BANK_NINE] = true,
    [BAG_HOUSE_BANK_TEN] = true,
}



function zo_callLater(func, ms) end
function zo_removeCallLater(id) end

function SearchManager:RequestResultUpdate()
    if self.resultUpdateCallback then -- TODO use the delay call lib we started but never finished
        zo_removeCallLater(self.resultUpdateCallback)
    end
    self.resultUpdateCallback = zo_callLater(function()
        self.resultUpdateCallback = nil
        self:UpdateSearchResults()
    end, FILTER_UPDATE_DELAY)
end


