local withdrawLimit = 3
local listToWithdraw = {}

local function resetListToWithdraw()
    listToWithdraw = {
        [CRAFTING_TYPE_BLACKSMITHING] = {},
        [CRAFTING_TYPE_CLOTHIER] = {},
        [CRAFTING_TYPE_WOODWORKING] = {},
        [CRAFTING_TYPE_JEWELRYCRAFTING] = {},
        [CRAFTING_TYPE_ALCHEMY] = {},
        [CRAFTING_TYPE_ENCHANTING] = {},
        [CRAFTING_TYPE_PROVISIONING] = {},
    }
end
local function getNextToWithdraw()
    local foundSlot = nil
    for craftTypeId, slotList in pairs(listToWithdraw) do
        for i = 1, #slotList do
            if slotList[i] ~= nil or slotList[i] ~= {} then
                foundSlot = listToWithdraw[craftTypeId][i]
                table.remove(listToWithdraw[craftTypeId], i)
                return foundSlot
            end
        end
    end
    return foundSlot
end

---@return number
local function getCountForWithdraw()
    local count = 0
    for craftTypeId, _ in pairs(listToWithdraw) do
        count = count + #listToWithdraw[craftTypeId]
    end
    return count
end

local function getFeeSpaceNeeded()
    return withdrawLimit * 7 * 2
end

local function checkIsInventorySpaceEnough()
    local freeSpace = GetNumBagFreeSlots(BAG_BACKPACK)
    local needSpace = getFeeSpaceNeeded()
    if needSpace > freeSpace then
        MasterWritProcessing:ShowDebug(string.format("Not enough inventory space %d need %d", freeSpace, needSpace))
        return false
    end
    return true
end

local function isMovableByTypeAndLimit(writCraftType)
    if listToWithdraw[writCraftType] == nil then
        MasterWritProcessing:ShowDebug(string.format("Work with craft type '%s' not setup", MasterWritProcessing.getCraftTypeLabel(writCraftType)))
        return false
    end

    if #listToWithdraw[writCraftType] < withdrawLimit then
        return true
    end
    return false
end

local function buildQueueForWithdraw()
    local characterId = GetCurrentCharacterId()
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        if ITEMTYPE_MASTER_WRIT == GetItemType(bagId, slotIndex) then
            local writItemLink = GetItemLink(bagId, slotIndex)
            local writCraftType = MasterWritProcessing.getCraftType(writItemLink)
            if isMovableByTypeAndLimit(writCraftType) and MasterWritProcessing.isDoable(writItemLink, characterId) then
                table.insert(listToWithdraw[writCraftType], {
                    bagId = bagId,
                    slotIndex = slotIndex,
                })
            end
        end
    end
end

local function withdrawNext()
    if not IsBankOpen() then
        MasterWritProcessing:ShowDebug("open bank")
        EVENT_MANAGER:UnregisterForEvent(MasterWritProcessing.addonName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
        return
    end

    local next = getNextToWithdraw()

    if next == {} or next == nil then
        MasterWritProcessing:ShowDebug("withdraw done")
        EVENT_MANAGER:UnregisterForEvent(MasterWritProcessing.addonName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
        return
    end

    local targetSlotIndex = FindFirstEmptySlotInBag(BAG_BACKPACK)
    if IsProtectedFunction('RequestMoveItem') then
        CallSecureProtected('RequestMoveItem', next.bagId, next.slotIndex, BAG_BACKPACK, targetSlotIndex, 1)
    else
        RequestMoveItem(next.bagId, next.slotIndex, BAG_BACKPACK, targetSlotIndex, 1)
    end
end

local function OnItemSlotUpdate(eventCode, bagId, slotIndex, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange)
    if bagId == BAG_BACKPACK and stackCountChange > 0 then
        zo_callLater(function()
            withdrawNext()
        end, 250)
    end
end

function MasterWritProcessing:WithdrawWithLimit()
    resetListToWithdraw()

    if not checkIsInventorySpaceEnough() then
        return
    end
    buildQueueForWithdraw()

    local countForWithdraw = getCountForWithdraw()
    if countForWithdraw > 0 then
        MasterWritProcessing:ShowDebug(string.format("Found %d writ(s) for withdraw", countForWithdraw))
        EVENT_MANAGER:RegisterForEvent(MasterWritProcessing.addonName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnItemSlotUpdate)
        withdrawNext()
    else
        MasterWritProcessing:ShowDebug('No Writs for withdraw')
    end
end

ZO_CreateStringId("SI_BINDING_NAME_MWP_WITHDRAW", "MWP: withdraw")
local buttons = {}
buttons.withdraw = {
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
    {
        name = "MWP: withdraw",
        keybind = "MWP_WITHDRAW",
        callback = function()
            MasterWritProcessing:WithdrawWithLimit()
        end,
        visible = function()
            return true
        end
    },
}
local function onBankOpen()
    KEYBIND_STRIP:AddKeybindButtonGroup(buttons.withdraw)
end
local function onBankClose()
    KEYBIND_STRIP:RemoveKeybindButtonGroup(buttons.withdraw)
end
EVENT_MANAGER:RegisterForEvent(MasterWritProcessing.addonName, EVENT_OPEN_BANK, onBankOpen)
EVENT_MANAGER:RegisterForEvent(MasterWritProcessing.addonName, EVENT_CLOSE_BANK, onBankClose)
