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
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for _, item in ipairs(bagCache) do
        local itemLink = GetItemLink(item.bagId, item.slotIndex)
        local itemType = GetItemType(item.bagId, item.slotIndex)
        local itemCount = GetSlotStackSize(item.bagId, item.slotIndex)

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
    local count = itemData.stackCount;
    local itemLink = itemData.itemLink;

    RecipeAndStileAssistant.inWorkList[itemLink] = true

    if RecipeAndStileAssistant.purchasedCount[itemLink] ~= nil then
        RecipeAndStileAssistant.purchasedCount[itemLink] = RecipeAndStileAssistant.purchasedCount[itemLink] + count
    else
        RecipeAndStileAssistant.purchasedCount[itemLink] = count
    end

    local notKnowCount = RecipeAndStileAssistant.getIsNotKnowCount(itemLink)
    if RecipeAndStileAssistant.purchasedCount[itemLink] >= notKnowCount then
        RecipeAndStileAssistant.inWorkDoneList[itemLink] = true
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
    for _, data in pairs(getSavedItemList()) do
        local itemLink = data.itemLink
        local count = data.itemCount
        RecipeAndStileAssistant.inWorkList[itemLink] = true

        if RecipeAndStileAssistant.purchasedCount[itemLink] ~= nil then
            RecipeAndStileAssistant.purchasedCount[itemLink] = RecipeAndStileAssistant.purchasedCount[itemLink] + count
        else
            RecipeAndStileAssistant.purchasedCount[itemLink] = count
        end

        if RecipeAndStileAssistant.purchasedCount[itemLink] >= RecipeAndStileAssistant.getIsNotKnowCount(itemLink) then
            RecipeAndStileAssistant.inWorkDoneList[itemLink] = true
        end
    end

    RecipeAndStileAssistant.IsWorkLimit()
end

SLASH_COMMANDS["/rasa_reset"] = function()
    RecipeAndStileAssistant.init()
end

SLASH_COMMANDS["/rasa.showstat"] = function()
    RecipeAndStileAssistant.debug(string.format("inWorkList %d", RecipeAndStileAssistant.tableLength(RecipeAndStileAssistant.inWorkList)))
    RecipeAndStileAssistant.debug(string.format("inWorkDoneList %d", RecipeAndStileAssistant.tableLength(RecipeAndStileAssistant.inWorkDoneList)))
    RecipeAndStileAssistant.debug(string.format("ignoreList %d", RecipeAndStileAssistant.tableLength(RecipeAndStileAssistant.ignoreList)))
    if RecipeAndStileAssistant.IsInWorkLimit then
        RecipeAndStileAssistant.debug('Limit is active')
    else
        RecipeAndStileAssistant.debug('NO limit for new')
    end
end