local MWP = MasterWritProcessing

local function formatSlotInfo(bagId, slotIndex)
    return {
        itemLink = GetItemLink(bagId, slotIndex),
        bagId = bagId,
        slotIndex = slotIndex,
    }
end
local function formatSlotKey(bagId, slotIndex)
    return string.format("%s-%s", bagId, slotIndex)
end
local function isCorrectItem(bagId, slotIndex)
    local itemType = GetItemType(bagId, slotIndex)
    if ITEMTYPE_MASTER_WRIT == itemType then
        return true
    end
    return false
end

local function addItem(bagId, slotIndex)
    if not isCorrectItem(bagId, slotIndex) then
        return
    end
    if bagId == BAG_BANK or bagId == BAG_SUBSCRIBER_BANK then
        table.insert(MasterWritProcessing.savedVars.InStock.InBank, formatSlotKey(bagId, slotIndex), formatSlotInfo(bagId, slotIndex))
        return
    end
end

local function removeItem(bagId, slotIndex)
    if bagId == BAG_BANK or bagId == BAG_SUBSCRIBER_BANK then
        table.remove(MasterWritProcessing.savedVars.InStock.InBank, formatSlotKey(bagId, slotIndex))
        return
    end
end

local function isCorrectBag(bagId)
    if bagId == BAG_BACKPACK then
        return true
    end
    if bagId == BAG_BANK then
        return true
    end
    if bagId == BAG_SUBSCRIBER_BANK then
        return true
    end

    return false
end

local function scanInventory()
    local items = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in ipairs(bagCache) do
        addItem(slotData.bagId, slotData.slotIndex)
    end
    return items
end

local function scanBank()
    MasterWritProcessing.savedVars.InStock.InBank = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for _, slotData in ipairs(bagCache) do
        addItem(slotData.bagId, slotData.slotIndex)
    end
end

function MWP.OnItemSlotUpdate(eventCode, bagId, slotIndex, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange)
    if not isCorrectBag(bagId) then
        return
    end

    if stackCountChange > 0 then
        addItem(bagId, slotIndex)
        return
    end
    if stackCountChange < 0 then
        removeItem(bagId, slotIndex)
        return
    end
end

function MWP.InStockOnCharLoad()
    -- 1 если инвентарь не сканировался - нужно проверить содержимое

    -- 2 если банк не сканировался - нужно проверить содержимое
    if MasterWritProcessing.savedVars.InStock.InBank == nil then
        scanBank()
    end
end
SLASH_COMMANDS["/mwp_scan_bank"] = function()
    scanBank()
end

SLASH_COMMANDS["/mwp_show_bank_in_stock_statistic"] = function()
    local totalCount = 0
    if MasterWritProcessing.savedVars.InStock.InBank then
        for i, v in pairs(MasterWritProcessing.savedVars.InStock.InBank) do
            if v ~= nil then
                totalCount = totalCount + 1
            end
        end
    end
    d(string.format("In Bank now %d", totalCount))
end

