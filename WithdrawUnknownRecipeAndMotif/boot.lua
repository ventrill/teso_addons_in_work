WithdrawUnknownRecipeAndMotif = {
    name = "WithdrawUnknownRecipeAndMotif",
}
local WURAM = WithdrawUnknownRecipeAndMotif

local itemsToWithdraw = {}
WURAM.itemsToWithdraw = itemsToWithdraw
local withdrawQueueIndex = 0
WURAM.withdrawQueueIndex = withdrawQueueIndex

local function showDebug(message)
    d("WURAM: " .. message)
end

local function reset()
    itemsToWithdraw = {}
    withdrawQueueIndex = 0
end

local function isNeeded(itemLink,itemType)
    if itemType == ITEMTYPE_RECIPE then
        -- @todo replace by LibCharacterKnowledge
        if not IsItemLinkRecipeKnown(itemLink) then
            return true
        end
    end
    if itemType == ITEMTYPE_RACIAL_STYLE_MOTIF then
        -- @todo replace by LibCharacterKnowledge
        if not IsItemLinkBookKnown(itemLink) then
            return true
        end
    end
    return false
end

local function scanBank()
    -- find item to move to inventory
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for key, item in ipairs(bagCache) do
        local itemLink = GetItemLink(item.bagId, item.slotIndex)
        local itemType = GetItemType(item.bagId, item.slotIndex)
        if isNeeded(itemLink, itemType) then
            table.insert(itemsToWithdraw, {
                itemLink = itemLink,
                bagId = item.bagId,
                slotIndex = item.slotIndex,
            })
        end
    end
end

local function withdrawNext()
    withdrawQueueIndex = withdrawQueueIndex + 1;
    if itemsToWithdraw[withdrawQueueIndex] == nil then
        showDebug("withdraw done")
        EVENT_MANAGER:UnregisterForEvent(WURAM.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
        return
    end
    local item = itemsToWithdraw[withdrawQueueIndex]
    local targetSlotIndex = FindFirstEmptySlotInBag(BAG_BACKPACK)

    if IsProtectedFunction('RequestMoveItem') then
        CallSecureProtected('RequestMoveItem', item.bagId, item.slotIndex, BAG_BACKPACK, targetSlotIndex, 1)
    else
        RequestMoveItem(item.bagId, item.slotIndex, BAG_BACKPACK, targetSlotIndex, 1)
    end
end

local function OnItemSlotUpdate(eventCode, bagId, slotIndex, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange)
    if bagId == BAG_BACKPACK and stackCountChange > 0 then
        -- local itemLink = GetItemLink(bagId, slotIndex)
        -- ? mark then move done
        withdrawNext()
    end
end

local function startWithdraw()
    reset()
    scanBank()
    if #itemsToWithdraw > 0 then
        showDebug(string.format("found %s items", #itemsToWithdraw))
        EVENT_MANAGER:RegisterForEvent(WURAM.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnItemSlotUpdate)
        withdrawNext()
    else
        showDebug("nothing to withdraw")
    end
end

local function onBankOpen()
    reset()
    scanBank()
    if #itemsToWithdraw > 0 then
        showDebug(string.format("found %s items", #itemsToWithdraw))
    else
        showDebug("nothing to withdraw")
    end
end

local function showItemsToWithdraw()
    reset()
    scanBank()
    for i,item in pairs(itemsToWithdraw) do
        local message = item.itemLink
        showDebug(message)
    -- itemLink = itemLink,
    --bagId = item.bagId,
    --slotIndex = item.slotIndex,
    end
end

SLASH_COMMANDS["/wuram_show_to_withdraw"] = function() showItemsToWithdraw()  end
SLASH_COMMANDS["/wuram_start_withdraw"] = function() startWithdraw()  end

EVENT_MANAGER:RegisterForEvent(WURAM.name, EVENT_OPEN_BANK, onBankOpen)