local addonName = 'AutoAcceptMasterWrit'

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

AutoAcceptMasterWrit = {
    name = addonName,
    version = '1.0.0',
    build = 100
}

local bagId = BAG_BACKPACK;
local timeout = 250;
local listToWorkWith = {};

local function debug(message)
    d("AAMW: " .. message)
end

local writSlots = {
    [MASTER_WRIT_TYPE_BLACKSMITHING] = {},
    [MASTER_WRIT_TYPE_TAILORING] = {},
    [MASTER_WRIT_TYPE_WOODWORKING] = {},
    [MASTER_WRIT_TYPE_ENCHANTING] = {},
    [MASTER_WRIT_TYPE_ALCHEMY] = {},
    [MASTER_WRIT_TYPE_PROVISIONING] = {},
    [MASTER_WRIT_TYPE_JEWELRY] = {},

}

function AutoAcceptMasterWrit.processList()
    if #listToWorkWith < 1 then
        AutoAcceptMasterWrit.processWorkDone()
        return
    end

    local index = #listToWorkWith
    local slotIndex = listToWorkWith[index]
    -- remove processed form list
    table.remove(listToWorkWith, index)
    AutoAcceptMasterWrit.acceptMasterWrit(slotIndex)
end

function AutoAcceptMasterWrit.acceptMasterWrit(slotIndex)
    -- accept quest from writ
    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_QUEST_OFFERED, function()
        zo_callLater(function()
            -- accept quest
            AcceptOfferedQuest()
            --SelectChatterOption(1)

            -- Unregister to avoid issues
            EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_QUEST_OFFERED)

            AutoAcceptMasterWrit.processList()
        end, timeout)
    end)


    -- use Master Writ - trigger for EVENT_QUEST_OFFERED
    zo_callLater(function()
        CallSecureProtected('UseItem', bagId, slotIndex)
    end, timeout)
end



local function collectWorkList()
    local list = {}
    for i = 1, #writSlots do
        -- collection has items
        if #writSlots[i] then
            local lastIndex = #writSlots[i]
            -- save slot to work
            table.insert(list, writSlots[i][lastIndex])
            -- remove slot
            table.remove(writSlots[i], lastIndex)
        end
    end
    return list
end

function AutoAcceptMasterWrit.processWorkDone()
    debug("Work done")
end

-- /script AutoAcceptMasterWrit.searchAndUse()
function AutoAcceptMasterWrit.processMasterWrit()
    listToWorkWith = collectWorkList()
    if #listToWorkWith then
        AutoAcceptMasterWrit.processList()
    else
        AutoAcceptMasterWrit.processWorkDone()
    end
end

local function saveWritInfo(writType, slotIndex)
    table.insert(writSlots[writType], slotIndex)
end

local function showSlotStatistic()
    for i = 1, #writSlots do
        local writTypeText;
        if MASTER_WRIT_TYPE_NAME[i] then
            writTypeText = MASTER_WRIT_TYPE_NAME[i]
        else
            writTypeText = "Unknown"
        end
        local writCount = #writSlots[i]
        debug(string.format("Type: %s, Count %d", writTypeText, writCount))
    end
end

local function searchAll()
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, bagId)
    for _, data in pairs(bagCache) do
        if data ~= nil then
            local itemLink = GetItemLink(bagId, data.slotIndex)
            local itemId = GetItemId(bagId, data.slotIndex)
            local itemType = GetItemType(bagId, data.slotIndex)
            if itemType == ITEMTYPE_MASTER_WRIT then
                --debug('type Writ'..itemLink)
                local writType = MASTER_WRIT_TYPES[itemId]
                if writType ~= nil then
                    saveWritInfo(writType, data.slotIndex)
                    -- debug('type Writ '..itemLink..'type '..MASTER_WRIT_TYPE_NAME[writType])
                else
                    -- debug(string.format("an known writ type %s", itemLink))
                end
            end
            --if (GetItemLinkItemType(itemLink) == ITEMTYPE_MASTER_WRIT) then
            --    table.insert(writSlots, data.slotIndex)
            --end
        end
    end

end

local function OnAddOnLoaded(event, addon)
    if addon ~= addonName then
        return
    end
    debug('Loaded')
    searchAll()
    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

ZO_CreateStringId("SI_BINDING_NAME_AAMW_PROCESS_MASTER_WRIT", "Process Master Writ")

local myButton = {
    name = "Process Master Writ",
    keybind = "AAMW_PROCESS_MASTER_WRIT",
    callback = function()
        AutoAcceptMasterWrit.processMasterWrit()
    end,
    alignment = KEYBIND_STRIP_ALIGN_LEFT,
}
KEYBIND_STRIP:AddKeybindButton(myButton)

SLASH_COMMANDS["/aamw.scan"] = function()
    searchAll()
end

SLASH_COMMANDS["/aamw.start"] = function()
    AutoAcceptMasterWrit.processMasterWrit()
end

SLASH_COMMANDS["/aamw.statistic"] = function()
    showSlotStatistic()
end
