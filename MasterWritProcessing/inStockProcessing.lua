local MWP = MasterWritProcessing

local function getCharacterId()
    if not MWP.CharacterId then
        MWP.CharacterId = GetCurrentCharacterId()
    end
    return MWP.CharacterId
end

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
        MWP.savedVars.InStock.InBank[formatSlotKey(bagId, slotIndex)] = formatSlotInfo(bagId, slotIndex)
        return
    end
    if bagId == BAG_BACKPACK then
        local characterId = getCharacterId()
        if MWP.savedVars.InStock.Characters[characterId] == nil then
            MWP.savedVars.InStock.Characters[characterId] = {}
        end
        MWP.savedVars.InStock.Characters[characterId][formatSlotKey(bagId, slotIndex)] = formatSlotInfo(bagId, slotIndex)
        return
    end

end

local function removeItem(bagId, slotIndex)
    if bagId == BAG_BANK or bagId == BAG_SUBSCRIBER_BANK then
        MWP.savedVars.InStock.InBank[formatSlotKey(bagId, slotIndex)] = nil
        return
    end
    if bagId == BAG_BACKPACK then
        local characterId = getCharacterId()
        if MWP.savedVars.InStock.Characters[characterId] then
            MWP.savedVars.InStock.Characters[characterId][formatSlotKey(bagId, slotIndex)] = nil
        end
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
    local characterId = getCharacterId()
    MWP.savedVars.InStock.Characters[characterId] = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in ipairs(bagCache) do
        addItem(slotData.bagId, slotData.slotIndex)
    end
end

local function scanBank()
    MWP.savedVars.InStock.InBank = {}
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
    local characterId = getCharacterId()
    if MWP.savedVars.InStock.Characters[characterId] == nil then
        scanInventory()
    end

    -- 2 если банк не сканировался - нужно проверить содержимое
    if MWP.savedVars.InStock.InBank == nil then
        scanBank()
    end
end

--local function formatSlotInfo(bagId, slotIndex)
--    return {
--        itemLink = GetItemLink(bagId, slotIndex),
--        bagId = bagId,
--        slotIndex = slotIndex,
--    }
--end

-- /script MasterWritProcessing.getAllSavedItemLinks()
function MWP.getAllSavedItemLinks()
    local itemLinks={}

    -- get form bank
    if MWP.savedVars.InStock.InBank then
        for i, savedRow in pairs(MWP.savedVars.InStock.InBank) do
            local link = savedRow.itemLink
            --d(link)
            table.insert(itemLinks, link)
        end
    end
    -- get form by characters
    if MWP.savedVars.InStock.Characters then
        for _, InCharData in pairs(MWP.savedVars.InStock.Characters) do
            for characterId, Slots in pairs(InCharData) do
                if Slots ~= nil and Slots ~= {} then
                    local link = Slots.itemLink
                    --d(link)
                    table.insert(itemLinks, link)
                end
            end
        end
    end

    return itemLinks
end

SLASH_COMMANDS["/mwp_scan_bank"] = function()
    scanBank()
end
SLASH_COMMANDS["/mwp_scan_inventory"] = function()
    scanInventory()
end

SLASH_COMMANDS["/mwp_show_bank_in_stock_statistic"] = function()
    local totalCount = 0
    local inBank = 0
    local inChar = 0
    -- calculate by bank
    if MWP.savedVars.InStock.InBank then
        for i, v in pairs(MWP.savedVars.InStock.InBank) do
            if v ~= nil and v ~= {} then
                totalCount = totalCount + 1
                inBank = inBank + 1
            end
        end
    end
    -- calculate by char
    if MWP.savedVars.InStock.Characters then
        for _, InCharData in pairs(MWP.savedVars.InStock.Characters) do
            for characterId, Slots in pairs(InCharData) do
                if Slots ~= nil and Slots ~= {} then
                    totalCount = totalCount + 1
                    inChar = inChar + 1
                end
            end
        end
    end
    d(string.format("In Bank %d, In Chars %d, total %s", inBank, inChar, totalCount))
end

