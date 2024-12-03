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
        if not MWP.savedVars.InStock.Characters[characterId] then
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
local function getBankFreeSlots()
    return GetNumBagFreeSlots(BAG_BANK) + GetNumBagFreeSlots(BAG_SUBSCRIBER_BANK)
end

function MWP.scanInventory()
    local characterId = getCharacterId()
    MWP.savedVars.InStock.Characters[characterId] = {}
    MWP.savedVars.InventoryFeeSlotsCount[characterId] = GetNumBagFreeSlots(BAG_BACKPACK)

    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in ipairs(bagCache) do
        if isCorrectItem(slotData.bagId, slotData.slotIndex) then
            MWP.savedVars.InStock.Characters[characterId][formatSlotKey(slotData.bagId, slotData.slotIndex)] = formatSlotInfo(slotData.bagId, slotData.slotIndex)
        end
    end
end

function MWP.scanBank()
    MWP.savedVars.InStock.InBank = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for _, slotData in ipairs(bagCache) do
        if isCorrectItem(slotData.bagId, slotData.slotIndex) then
            MWP.savedVars.InStock.InBank[formatSlotKey(slotData.bagId, slotData.slotIndex)] = formatSlotInfo(slotData.bagId, slotData.slotIndex)
        end
    end
end

-- /script MasterWritProcessing.scanHouseBanks()
function MasterWritProcessing.scanHouseBanks()
    if not IsOwnerOfCurrentHouse() then
        d('don\'t work if you not in your house')
        return
    end
    MWP.savedVars.InStock.InHouseBank = {}
    local ctr, cName, cId
    for bagId = BAG_HOUSE_BANK_ONE, BAG_HOUSE_BANK_TEN do
        cId = GetCollectibleForHouseBankBag(bagId)
        if IsCollectibleUnlocked(cId) then
            cName = GetCollectibleNickname(cId)
            if cName == "" then
                cName = GetCollectibleName(cId)
            end
            cName = ZO_CachedStrFormat(SI_COLLECTIBLE_NAME_FORMATTER, cName)
            --d(cName)
            MWP.savedVars.InStock.InHouseBank[bagId] = {}
            MWP.savedVars.InventoryFeeSlotsCount[bagId] = GetNumBagFreeSlots(bagId)
            local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, bagId)
            for _, slotData in ipairs(bagCache) do
                if isCorrectItem(slotData.bagId, slotData.slotIndex) then
                    MWP.savedVars.InStock.InHouseBank[bagId][formatSlotKey(slotData.bagId, slotData.slotIndex)] = formatSlotInfo(slotData.bagId, slotData.slotIndex)
                end
            end
        end

        --if cName ~= "" then
        --    d(cName)
        --    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, ctr)
        --    for _, slotData in ipairs(bagCache) do
        --        if isCorrectItem(slotData.bagId, slotData.slotIndex) then
        --            --local item = formatSlotInfo(slotData.bagId, slotData.slotIndex)
        --            --d(item.itemLink)
        --            MWP.savedVars.InStock.InHouseBank[formatSlotKey(slotData.bagId, slotData.slotIndex)] = formatSlotInfo(slotData.bagId, slotData.slotIndex)
        --        end
        --    end
        --end
    end


    --MWP.savedVars.InStock.InHouseBank = {}
    --local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_HOUSE_BANK_ONE, BAG_HOUSE_BANK_TWO, BAG_HOUSE_BANK_THREE, BAG_HOUSE_BANK_FOUR, BAG_HOUSE_BANK_FIVE, BAG_HOUSE_BANK_SIX, BAG_HOUSE_BANK_SEVEN, BAG_HOUSE_BANK_EIGHT)
    --for _, slotData in ipairs(bagCache) do
    --    if isCorrectItem(slotData.bagId, slotData.slotIndex) then
    --        MWP.savedVars.InStock.InHouseBank[formatSlotKey(slotData.bagId, slotData.slotIndex)] = formatSlotInfo(slotData.bagId, slotData.slotIndex)
    --    end
    --end
end

-- @todo inspect and remove?
-- /script MasterWritProcessing.getAllSavedItemLinks()
function MasterWritProcessing.getAllSavedItemLinks()
    local itemLinks = {}

    -- get form bank
    if MWP.savedVars.InStock.InBank then
        for _, savedRow in pairs(MWP.savedVars.InStock.InBank) do
            local link = savedRow.itemLink
            table.insert(itemLinks, link)
        end
    end
    -- get form by characters
    if MWP.savedVars.InStock.Characters then
        for _, InCharData in pairs(MWP.savedVars.InStock.Characters) do
            for _, Slots in pairs(InCharData) do
                if Slots ~= nil and Slots ~= {} then
                    local link = Slots.itemLink
                    table.insert(itemLinks, link)
                end
            end
        end
    end

    if MWP.savedVars.InStock.InHouseBank then
        for _, InHouseBankData in pairs(MWP.savedVars.InStock.InHouseBank) do
            for _, Slots in pairs(InHouseBankData) do
                if Slots ~= nil and Slots ~= {} then
                    local link = Slots.itemLink
                    table.insert(itemLinks, link)
                end
            end
        end
    end

    return itemLinks
end

SLASH_COMMANDS["/mwp_scan_bank"] = function()
    MWP.scanBank()
end
SLASH_COMMANDS["/mwp_scan_inventory"] = function()
    MWP.scanInventory()
end


