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
            if not MWP.savedVars.InStock.Characters[characterId] then
                MWP.savedVars.InStock.Characters[characterId] = {}
            end
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

function MasterWritProcessing.scanHouseBanks()
    MWP.savedVars.InStock.InHouseBank = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_HOUSE_BANK_ONE, BAG_HOUSE_BANK_TWO, BAG_HOUSE_BANK_THREE, BAG_HOUSE_BANK_FOUR, BAG_HOUSE_BANK_FIVE, BAG_HOUSE_BANK_SIX, BAG_HOUSE_BANK_SEVEN, BAG_HOUSE_BANK_EIGHT)
    for _, slotData in ipairs(bagCache) do
        if isCorrectItem(slotData.bagId, slotData.slotIndex) then
            MWP.savedVars.InStock.InHouseBank[formatSlotKey(slotData.bagId, slotData.slotIndex)] = formatSlotInfo(slotData.bagId, slotData.slotIndex)
        end
    end
end

-- @todo inspect and remove?
-- /script MasterWritProcessing.getAllSavedItemLinks()
function MasterWritProcessing.getAllSavedItemLinks()
    local itemLinks = {}

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
    MWP.scanBank()
end
SLASH_COMMANDS["/mwp_scan_inventory"] = function()
    MWP.scanInventory()
end
-- @todo inspect and remove?
local function getCharList()
    local list = {}
    for i = 1, GetNumCharacters() do
        --for i = 1, 3 do
        local _, _, _, _, _, _, characterId = GetCharacterInfo(i)
        table.insert(list, characterId)
    end
    return list
end
-- /script MasterWritProcessing.prepareInStockInfo()
-- /script d(MasterWritProcessing.prepareInStockInfo())
-- @todo inspect and remove?
function MasterWritProcessing.prepareInStockInfo()
    local list = {}
    local charList = getCharList()
    list['total'] = {
        ['FreeSlots'] = 0,
        ['name'] = "total",
        ['all'] = 0,
        [CRAFTING_TYPE_BLACKSMITHING] = 0,
        [CRAFTING_TYPE_CLOTHIER] = 0,
        [CRAFTING_TYPE_WOODWORKING] = 0,
        [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
        [CRAFTING_TYPE_ALCHEMY] = 0,
        [CRAFTING_TYPE_ENCHANTING] = 0,
        [CRAFTING_TYPE_PROVISIONING] = 0,
    }
    list['bank'] = {
        ['FreeSlots'] = getBankFreeSlots(),
        ['name'] = "bank",
        ['all'] = 0,
        [CRAFTING_TYPE_BLACKSMITHING] = 0,
        [CRAFTING_TYPE_CLOTHIER] = 0,
        [CRAFTING_TYPE_WOODWORKING] = 0,
        [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
        [CRAFTING_TYPE_ALCHEMY] = 0,
        [CRAFTING_TYPE_ENCHANTING] = 0,
        [CRAFTING_TYPE_PROVISIONING] = 0,
    }
    if MWP.savedVars.InStock.InBank then
        for _, data in pairs(MWP.savedVars.InStock.InBank) do
            if data ~= nil and data ~= {} then
                local writItemLink = data.itemLink
                local writCraftType = MWP.getCraftType(writItemLink)
                list['total']['all'] = list['total']['all'] + 1;
                list['total'][writCraftType] = list['total'][writCraftType] + 1;
                list['bank']['all'] = list['bank']['all'] + 1;
                list['bank'][writCraftType] = list['bank'][writCraftType] + 1;
            end
        end
    end

    for _, characterId in pairs(charList) do
        list[characterId] = {
            ['FreeSlots'] = MWP.savedVars.InventoryFeeSlotsCount[characterId] or 0,
            ['name'] = ZO_CachedStrFormat(SI_UNIT_NAME, GetCharacterNameById(StringToId64(characterId))),
            ['all'] = 0,
            [CRAFTING_TYPE_BLACKSMITHING] = 0,
            [CRAFTING_TYPE_CLOTHIER] = 0,
            [CRAFTING_TYPE_WOODWORKING] = 0,
            [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
            [CRAFTING_TYPE_ALCHEMY] = 0,
            [CRAFTING_TYPE_ENCHANTING] = 0,
            [CRAFTING_TYPE_PROVISIONING] = 0,
        }
    end

    if MWP.savedVars.InStock.Characters then
        for characterId, InCharData in pairs(MWP.savedVars.InStock.Characters) do
            for _, Slots in pairs(InCharData) do
                --d(string.format("id %s", characterId))
                if Slots ~= nil and Slots ~= {} then
                    local writItemLink = Slots.itemLink
                    --d(writItemLink)
                    local writCraftType = MWP.getCraftType(writItemLink)
                    list['total']['all'] = list['total']['all'] + 1;
                    list['total'][writCraftType] = list['total'][writCraftType] + 1;
                    list[characterId]['all'] = list[characterId]['all'] + 1;
                    list[characterId][writCraftType] = list[characterId][writCraftType] + 1;
                end
            end
        end
    end

    return list;
end
-- @todo inspect and remove?
function MasterWritProcessing.prepareInStockInfoByCharacterId(selectedCharacterId)
    local list = {}
    local charList = getCharList()
    list['total'] = {
        ['FreeSlots'] = 0,
        ['name'] = "total",
        ['all'] = 0,
        [CRAFTING_TYPE_BLACKSMITHING] = 0,
        [CRAFTING_TYPE_CLOTHIER] = 0,
        [CRAFTING_TYPE_WOODWORKING] = 0,
        [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
        [CRAFTING_TYPE_ALCHEMY] = 0,
        [CRAFTING_TYPE_ENCHANTING] = 0,
        [CRAFTING_TYPE_PROVISIONING] = 0,
    }
    list['bank'] = {
        ['FreeSlots'] = getBankFreeSlots(),
        ['name'] = "bank",
        ['all'] = 0,
        [CRAFTING_TYPE_BLACKSMITHING] = 0,
        [CRAFTING_TYPE_CLOTHIER] = 0,
        [CRAFTING_TYPE_WOODWORKING] = 0,
        [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
        [CRAFTING_TYPE_ALCHEMY] = 0,
        [CRAFTING_TYPE_ENCHANTING] = 0,
        [CRAFTING_TYPE_PROVISIONING] = 0,
    }
    if MWP.savedVars.InStock.InBank then
        for _, data in pairs(MWP.savedVars.InStock.InBank) do
            if data ~= nil and data ~= {} then
                local writItemLink = data.itemLink
                local writCraftType = MWP.getCraftType(writItemLink)
                if MWP.isDoable(writItemLink, selectedCharacterId) then
                    list['total']['all'] = list['total']['all'] + 1;
                    list['total'][writCraftType] = list['total'][writCraftType] + 1;
                    list['bank']['all'] = list['bank']['all'] + 1;
                    list['bank'][writCraftType] = list['bank'][writCraftType] + 1;
                end
            end
        end
    end

    for _, characterId in pairs(charList) do
        list[characterId] = {
            ['FreeSlots'] = MWP.savedVars.InventoryFeeSlotsCount[characterId] or 0,
            ['name'] = ZO_CachedStrFormat(SI_UNIT_NAME, GetCharacterNameById(StringToId64(characterId))),
            ['all'] = 0,
            [CRAFTING_TYPE_BLACKSMITHING] = 0,
            [CRAFTING_TYPE_CLOTHIER] = 0,
            [CRAFTING_TYPE_WOODWORKING] = 0,
            [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
            [CRAFTING_TYPE_ALCHEMY] = 0,
            [CRAFTING_TYPE_ENCHANTING] = 0,
            [CRAFTING_TYPE_PROVISIONING] = 0,
        }
    end

    if MWP.savedVars.InStock.Characters then
        for characterId, InCharData in pairs(MWP.savedVars.InStock.Characters) do
            for _, Slots in pairs(InCharData) do
                --d(string.format("id %s", characterId))
                if Slots ~= nil and Slots ~= {} then
                    local writItemLink = Slots.itemLink
                    --d(writItemLink)
                    local writCraftType = MWP.getCraftType(writItemLink)
                    if MWP.isDoable(writItemLink, selectedCharacterId) then
                        list['total']['all'] = list['total']['all'] + 1;
                        list['total'][writCraftType] = list['total'][writCraftType] + 1;
                        list[characterId]['all'] = list[characterId]['all'] + 1;
                        list[characterId][writCraftType] = list[characterId][writCraftType] + 1;
                    end
                end
            end
        end
    end

    return list;
end


