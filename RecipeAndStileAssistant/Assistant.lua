local function isNeeded(itemLink, itemType)
    if itemType == ITEMTYPE_RECIPE then
        return true
    end
    if itemType == ITEMTYPE_RACIAL_STYLE_MOTIF then
        return true
    end
    return false
end

local function getSavedItemList()
    local collected = {}
    -- find item
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for key, item in ipairs(bagCache) do
        local itemLink = GetItemLink(item.bagId, item.slotIndex)
        local itemType = GetItemType(item.bagId, item.slotIndex)
        -- @todo find item count on stack
        local itemCount = 1;
        if isNeeded(itemLink, itemType) then
            table.insert(collected, {
                itemLink = itemLink,
                bagId = item.bagId,
                slotIndex = item.slotIndex,
                itemCount = itemCount,
            })
        end
    end

    return collected
end

function RecipeAndStileAssistant.purchaseItemProcess(itemData)
    local OnSaleCount = itemData.stackCount;
    local ItemLink = itemData.ItemLink;

    RecipeAndStileAssistant.inWorkList[ItemLink] = true

    if RecipeAndStileAssistant.purchasedCount[ItemLink] ~= nil then
        RecipeAndStileAssistant.purchasedCount[ItemLink] = RecipeAndStileAssistant.purchasedCount[ItemLink] + OnSaleCount
    else
        RecipeAndStileAssistant.purchasedCount[ItemLink] = OnSaleCount
    end

    local notKnowCount = RecipeAndStileAssistant.getIsNotKnowCount(ItemLink)
    if RecipeAndStileAssistant.purchasedCount[ItemLink] >= notKnowCount then
        RecipeAndStileAssistant.inWorkDoneList[ItemLink] = true
    end

    RecipeAndStileAssistant.IsWorkLimit()
end

function RecipeAndStileAssistant.init()
    -- reset tmp
    RecipeAndStileAssistant.ignoreList = {}
    RecipeAndStileAssistant.inWorkList = {}
    RecipeAndStileAssistant.inWorkDoneList = {}
    RecipeAndStileAssistant.neededCount = {}
    RecipeAndStileAssistant.purchasedCount = {}
    RecipeAndStileAssistant.IsInWorkLimit = false;
    -- @todo scan inventory and bank
    for _, data in pairs(getSavedItemList()) do
        local ItemLink = data.itemLink
        local count = data.itemCount
        RecipeAndStileAssistant.inWorkList[ItemLink] = true

        if RecipeAndStileAssistant.purchasedCount[ItemLink] ~= nil then
            RecipeAndStileAssistant.purchasedCount[ItemLink] = RecipeAndStileAssistant.purchasedCount[ItemLink] + count
        else
            RecipeAndStileAssistant.purchasedCount[ItemLink] = count
        end

        if RecipeAndStileAssistant.purchasedCount[ItemLink] >= RecipeAndStileAssistant.getIsNotKnowCount(ItemLink) then
            RecipeAndStileAssistant.inWorkDoneList[ItemLink] = true
        end
    end

    RecipeAndStileAssistant.IsWorkLimit()
end