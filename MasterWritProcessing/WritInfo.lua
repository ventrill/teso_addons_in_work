local addonName = MasterWritProcessing.addonName

local MASTER_WRIT_TYPE_BLACKSMITHING = 1
local MASTER_WRIT_TYPE_TAILORING = 2
local MASTER_WRIT_TYPE_WOODWORKING = 3
local MASTER_WRIT_TYPE_ENCHANTING = 4
local MASTER_WRIT_TYPE_ALCHEMY = 5
local MASTER_WRIT_TYPE_PROVISIONING = 6
local MASTER_WRIT_TYPE_JEWELRY = 7

local MASTER_WRIT_TYPE_NAME = {
    [MASTER_WRIT_TYPE_BLACKSMITHING] = "BLACKSMITHING",
    [MASTER_WRIT_TYPE_TAILORING] = "TAILORING",
    [MASTER_WRIT_TYPE_WOODWORKING] = "WOODWORKING",
    [MASTER_WRIT_TYPE_ENCHANTING] = "ENCHANTING",
    [MASTER_WRIT_TYPE_ALCHEMY] = "ALCHEMY",
    [MASTER_WRIT_TYPE_PROVISIONING] = "PROVISIONING",
    [MASTER_WRIT_TYPE_JEWELRY] = "JEWELRY",
}

local TYPE_LIST = {
    MASTER_WRIT_TYPE_BLACKSMITHING,
    MASTER_WRIT_TYPE_TAILORING,
    MASTER_WRIT_TYPE_WOODWORKING,
    MASTER_WRIT_TYPE_ENCHANTING,
    MASTER_WRIT_TYPE_ALCHEMY,
    MASTER_WRIT_TYPE_PROVISIONING,
    MASTER_WRIT_TYPE_JEWELRY,
}

local MASTER_WRIT_TYPES = {
    [119563] = MASTER_WRIT_TYPE_BLACKSMITHING,
    [119680] = MASTER_WRIT_TYPE_BLACKSMITHING,
    [121527] = MASTER_WRIT_TYPE_BLACKSMITHING,
    [121529] = MASTER_WRIT_TYPE_BLACKSMITHING,
    [119694] = MASTER_WRIT_TYPE_TAILORING,
    [119695] = MASTER_WRIT_TYPE_TAILORING,
    [121532] = MASTER_WRIT_TYPE_TAILORING,
    [121533] = MASTER_WRIT_TYPE_TAILORING,
    [119681] = MASTER_WRIT_TYPE_WOODWORKING,
    [119682] = MASTER_WRIT_TYPE_WOODWORKING,
    [121530] = MASTER_WRIT_TYPE_WOODWORKING,
    [121531] = MASTER_WRIT_TYPE_WOODWORKING,
    [119564] = MASTER_WRIT_TYPE_ENCHANTING,
    [121528] = MASTER_WRIT_TYPE_ENCHANTING,
    [119696] = MASTER_WRIT_TYPE_ALCHEMY,
    [119698] = MASTER_WRIT_TYPE_ALCHEMY,
    [119705] = MASTER_WRIT_TYPE_ALCHEMY,
    [119818] = MASTER_WRIT_TYPE_ALCHEMY,
    [119820] = MASTER_WRIT_TYPE_ALCHEMY,
    [119704] = MASTER_WRIT_TYPE_ALCHEMY,
    [119701] = MASTER_WRIT_TYPE_ALCHEMY,
    [119702] = MASTER_WRIT_TYPE_ALCHEMY,
    [119699] = MASTER_WRIT_TYPE_ALCHEMY,
    [119703] = MASTER_WRIT_TYPE_ALCHEMY,
    [119700] = MASTER_WRIT_TYPE_ALCHEMY,
    [119819] = MASTER_WRIT_TYPE_ALCHEMY,
    [119693] = MASTER_WRIT_TYPE_PROVISIONING,
    [138798] = MASTER_WRIT_TYPE_JEWELRY,
    [138799] = MASTER_WRIT_TYPE_JEWELRY,
    [153737] = MASTER_WRIT_TYPE_JEWELRY,
    [153738] = MASTER_WRIT_TYPE_JEWELRY,
    [153739] = MASTER_WRIT_TYPE_JEWELRY,
}

local bagId = BAG_BACKPACK;
local timeout = 250;
local listToWorkWith = {};

local writSlots = {
    [MASTER_WRIT_TYPE_BLACKSMITHING] = {},
    [MASTER_WRIT_TYPE_TAILORING] = {},
    [MASTER_WRIT_TYPE_WOODWORKING] = {},
    [MASTER_WRIT_TYPE_ENCHANTING] = {},
    [MASTER_WRIT_TYPE_ALCHEMY] = {},
    [MASTER_WRIT_TYPE_PROVISIONING] = {},
    [MASTER_WRIT_TYPE_JEWELRY] = {},
}

local function acceptMasterWrit(slotIndex)
    local itemType = GetItemType(bagId, slotIndex)
    if itemType ~= ITEMTYPE_MASTER_WRIT then
        d('wrong item type selected')
        return nil
    end

    -- accept quest from writ

    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_QUEST_OFFERED, function()
        --d("EVENT_QUEST_OFFERED")
        zo_callLater(function()
            -- accept quest
            AcceptOfferedQuest()
            --SelectChatterOption(1)

            -- Unregister to avoid issues
            EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_QUEST_OFFERED)
        end, timeout)
    end)


    -- use Master Writ - trigger for EVENT_QUEST_OFFERED
    zo_callLater(function()
        CallSecureProtected('UseItem', bagId, slotIndex)
    end, timeout)
end

function MasterWritProcessing.processByType(type)
    if writSlots[type] and #writSlots[type] > 0 then
        local index = writSlots[type][1]
        table.remove(writSlots[type], 1)
        acceptMasterWrit(index)
    end
end

local function processNext()
    --d('processNext | listToWorkWith')
    --d(listToWorkWith)
    local index = 1
    if listToWorkWith[index] then
        local type = listToWorkWith[index]
        table.remove(listToWorkWith, index)
        -- process writ
        MasterWritProcessing.processByType(type)
    else
        d("all UP UnregisterForEvent")
        EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_QUEST_ADDED)
        MasterWritProcessing.showSavedProcessingListInfo()
    end
end

function MasterWritProcessing.processAllType()
    listToWorkWith = {}
    for _, type in pairs(TYPE_LIST) do
        if writSlots[type] and #writSlots[type] > 0 then
            table.insert(listToWorkWith, type)
        end
    end
    --d('listToWorkWith count ' .. #listToWorkWith)
    --for i, type in pairs(listToWorkWith) do
    --    d(string.format("index %s(%s), count = %d", i, MASTER_WRIT_TYPE_NAME[type], #writSlots[type]))
    --end

    if #listToWorkWith > 0 then
        EVENT_MANAGER:RegisterForEvent(addonName, EVENT_QUEST_ADDED, function()
            --d("EVENT_QUEST_ADDED")
            zo_callLater(function()
                processNext()
            end, timeout)
        end)
        processNext()
    else
        d("Nosing to process")
        MasterWritProcessing.showSavedProcessingListInfo()
    end
end

function MasterWritProcessing.getSlotStatistic()
    local statistic = {}
    for i = 1, #writSlots do
        local writTypeText = "Unknown"
        if MASTER_WRIT_TYPE_NAME[i] then
            writTypeText = MASTER_WRIT_TYPE_NAME[i]
        end
        local writCount = #writSlots[i]
        --debug(string.format("Type: %s, Count %d", writTypeText, writCount))
        table.insert(statistic, {
            CraftType = writTypeText,
            Count = writCount,
            CraftTypeId = i,
        })
    end
    return statistic
end

function MasterWritProcessing.searchAll()
    writSlots = {
        [MASTER_WRIT_TYPE_BLACKSMITHING] = {},
        [MASTER_WRIT_TYPE_TAILORING] = {},
        [MASTER_WRIT_TYPE_WOODWORKING] = {},
        [MASTER_WRIT_TYPE_ENCHANTING] = {},
        [MASTER_WRIT_TYPE_ALCHEMY] = {},
        [MASTER_WRIT_TYPE_PROVISIONING] = {},
        [MASTER_WRIT_TYPE_JEWELRY] = {},
    }
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, bagId)
    for _, data in pairs(bagCache) do
        if data ~= nil then
            local itemLink = GetItemLink(bagId, data.slotIndex)
            local itemId = GetItemId(bagId, data.slotIndex)
            local itemType = GetItemType(bagId, data.slotIndex)
            if itemType == ITEMTYPE_MASTER_WRIT then
                local writType = MASTER_WRIT_TYPES[itemId]
                if writType ~= nil then
                    table.insert(writSlots[writType], data.slotIndex)
                else
                    debug(string.format("an known writ type (%d) %s", itemId, itemLink))
                end
            end
        end
    end
end


