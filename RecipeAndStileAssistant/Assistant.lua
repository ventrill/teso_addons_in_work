local RASA = RecipeAndStileAssistant;
local function isNeeded(itemType)
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

        if isNeeded(itemType) then
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

local function showCollectionDone(itemLink)
    RASA.info(string.format("Collection done for %s", itemLink))
end

function RASA.purchaseItemProcess(itemData)
    local count = itemData.stackCount;
    local itemLink = itemData.itemLink;

    RASA.inWorkList[itemLink] = true

    if RASA.purchasedCount[itemLink] ~= nil then
        RASA.purchasedCount[itemLink] = RASA.purchasedCount[itemLink] + count
    else
        RASA.purchasedCount[itemLink] = count
    end

    local notKnowCount = RASA.getIsNotKnowCount(itemLink)
    if RASA.purchasedCount[itemLink] >= notKnowCount then
        RASA.inWorkDoneList[itemLink] = true
        showCollectionDone(itemLink)
    end

    RASA.IsWorkLimit()
end

function RASA.init()
    -- reset tmp
    RASA.ignoreList = {}
    RASA.inWorkList = {}
    RASA.inWorkDoneList = {}
    RASA.neededCount = {}
    RASA.purchasedCount = {}
    RASA.IsInWorkLimit = false;
    for _, data in pairs(getSavedItemList()) do
        local itemLink = data.itemLink
        local count = data.itemCount
        RASA.inWorkList[itemLink] = true

        if RASA.purchasedCount[itemLink] ~= nil then
            RASA.purchasedCount[itemLink] = RASA.purchasedCount[itemLink] + count
        else
            RASA.purchasedCount[itemLink] = count
        end

        if RASA.purchasedCount[itemLink] >= RASA.getIsNotKnowCount(itemLink) then
            RASA.inWorkDoneList[itemLink] = true
            showCollectionDone(itemLink)
        end
    end

    RASA.IsWorkLimit()
end

SLASH_COMMANDS["/rasa_reset"] = function()
    RASA.init()
end

SLASH_COMMANDS["/rasa_show_stat"] = function()
    RASA.info(string.format("inWorkList count %d", RASA.tableLength(RASA.inWorkList)))
    RASA.info(string.format("inWorkDoneList count %d", RASA.tableLength(RASA.inWorkDoneList)))
    RASA.info(string.format("ignoreList count %d", RASA.tableLength(RASA.ignoreList)))
    if RASA.IsInWorkLimit then
        RASA.info('Limit is active')
    else
        RASA.info('NO limit for new')
    end
end