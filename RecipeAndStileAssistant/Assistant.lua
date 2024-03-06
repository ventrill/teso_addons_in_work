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
    local itemId = GetItemLinkItemId(itemLink)

    RASA.inWorkListIds[itemId] = true

    if RASA.purchasedCountIds[itemId] ~= nil then
        RASA.purchasedCountIds[itemId] = RASA.purchasedCountIds[itemId] + count
    else
        RASA.purchasedCountIds[itemId] = count
    end

    local notKnowCount = RASA.getIsNotKnowCount(itemLink)
    if RASA.purchasedCountIds[itemId] >= notKnowCount then
        RASA.inWorkDoneListIds[itemId] = true
        showCollectionDone(itemLink)
    end

    RASA.IsWorkLimit()
end

function RASA.init()
    -- reset tmp
    RASA.ignoreListIds = {}
    RASA.inWorkListIds = {}
    RASA.inWorkDoneListIds = {}
    RASA.neededCountIds = {}
    RASA.purchasedCountIds = {}
    RASA.IsInWorkLimit = false;
    for _, data in pairs(getSavedItemList()) do
        local itemLink = data.itemLink
        local count = data.itemCount
        local itemId = GetItemLinkItemId(itemLink)
        RASA.inWorkListIds[itemId] = true

        if RASA.purchasedCountIds[itemId] ~= nil then
            RASA.purchasedCountIds[itemId] = RASA.purchasedCountIds[itemId] + count
        else
            RASA.purchasedCountIds[itemId] = count
        end

        if RASA.purchasedCountIds[itemId] >= RASA.getIsNotKnowCount(itemLink) then
            RASA.inWorkDoneListIds[itemId] = true
            showCollectionDone(itemLink)
        end
    end

    RASA.IsWorkLimit()
end

SLASH_COMMANDS["/rasa_reset"] = function()
    RASA.init()
end

SLASH_COMMANDS["/rasa_show_stat"] = function()
    RASA.info(string.format("inWorkListIds count %d", RASA.tableLength(RASA.inWorkListIds)))
    RASA.info(string.format("inWorkDoneListIds count %d", RASA.tableLength(RASA.inWorkDoneListIds)))
    RASA.info(string.format("ignoreListIds count %d", RASA.tableLength(RASA.ignoreListIds)))
    if RASA.IsInWorkLimit then
        RASA.info('Limit is active')
    else
        RASA.info('NO limit for new')
    end
end