local MWP = MasterWritProcessing
local listToDeposit = {}
local depositQueueIndex = 0

local function isMovableByType(writItemLink)
    local writCraftType = MWP.getCraftType(writItemLink)
    if writCraftType == CRAFTING_TYPE_BLACKSMITHING
            or writCraftType == CRAFTING_TYPE_CLOTHIER
            or writCraftType == CRAFTING_TYPE_WOODWORKING then
        return true
    end
    return false
end

local function getBankFreeSlot()
    local bankId = BAG_BANK
    local slotId = FindFirstEmptySlotInBag(bankId)
    if not slotId then
        bankId = BAG_SUBSCRIBER_BANK
        slotId = FindFirstEmptySlotInBag(bankId)
    end
    if not slotId then
        bankId = nil
    end
    return bankId, slotId
end

local function depositNext()
    if not IsBankOpen() then
        d("open bank")
        EVENT_MANAGER:UnregisterForEvent(MWP.addonName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
        return
    end
    if #listToDeposit < 1 then
        d("deposit done")
        EVENT_MANAGER:UnregisterForEvent(MWP.addonName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
        return
    end

    depositQueueIndex = depositQueueIndex + 1;
    if not listToDeposit[depositQueueIndex] then
        d("Deposit done")
        return
    end

    local slotToDeposit = listToDeposit[depositQueueIndex]
    if not slotToDeposit then
        d("error on get slotToDeposit")
        EVENT_MANAGER:UnregisterForEvent(MWP.addonName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
        return
    end
    local destBag, destSlot = getBankFreeSlot()
    if not destBag or not destSlot then
        d("no free slots in bank")
        EVENT_MANAGER:UnregisterForEvent(MWP.addonName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
        return
    end

    local stackCount = GetSlotStackSize(BAG_BACKPACK, slotToDeposit)
    if IsProtectedFunction("RequestMoveItem") then
        CallSecureProtected("RequestMoveItem", BAG_BACKPACK, slotToDeposit, destBag, destSlot, stackCount)
    else
        RequestMoveItem(BAG_BACKPACK, slotToDeposit, destBag, destSlot, stackCount)
    end

end

local function OnItemSlotUpdate(eventCode, bagId, slotIndex, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange)
    if bagId == BAG_BANK or bagId == BAG_SUBSCRIBER_BANK then
        if stackCountChange > 0 then
            depositNext()
        end
    end
end

local function startDeposit()
    if #listToDeposit > 0 then
        d(string.format("found %s items", #listToDeposit))
        EVENT_MANAGER:RegisterForEvent(MWP.addonName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnItemSlotUpdate)
        depositNext()
    else
        d("nothing to deposit")
    end
end


function MWP.depositByCraftType(control, writCraftType)
    local parent = control:GetParent()
    if not parent
            or not parent.data
            or not parent.data.characterId then
        d("no info for withdraw")
        return
    end
    if not writCraftType then
        writCraftType = 'all'
    end
    listToDeposit = {}

    if not IsBankOpen() then
        d("open bank")
        return
    end

    local characterId = parent.data.characterId
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        if ITEMTYPE_MASTER_WRIT == GetItemType(bagId, slotIndex) then
            local writItemLink = GetItemLink(bagId, slotIndex)
            if 'all' == writCraftType or MWP.getCraftType(writItemLink) == writCraftType then
                if MWP.isDoable(writItemLink, characterId) then
                    table.insert(listToDeposit, slotIndex)
                end
            end
        end
    end
    startDeposit()
end

function MWP.depositDoable(control)
    local parent = control:GetParent()
    if not parent
            or not parent.data
            or not parent.data.characterId then
        d("no info for withdraw")
        return
    end
    listToDeposit = {}

    if not IsBankOpen() then
        d("open bank")
        return
    end

    local characterId = parent.data.characterId

    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        if ITEMTYPE_MASTER_WRIT == GetItemType(bagId, slotIndex) then
            local writItemLink = GetItemLink(bagId, slotIndex)
            if isMovableByType(writItemLink) and MWP.isDoable(writItemLink, characterId) then
                table.insert(listToDeposit, slotIndex)
            end
        end
    end
    startDeposit()
end