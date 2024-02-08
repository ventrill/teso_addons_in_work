WithdrawUnknownRecipeAndMotif = {
    name = "WithdrawUnknownRecipeAndMotif",
    isBankOpen = false,
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

local charId = GetCurrentCharacterId()

local function isNeeded(itemLink, itemType)
    if itemType == ITEMTYPE_RACIAL_STYLE_MOTIF or itemType == ITEMTYPE_RECIPE then
        local stat = LibCharacterKnowledge.GetItemKnowledgeList(itemLink)
        for _, status in pairs(stat) do
            if status.id
                    and status.id == charId
                    and status.knowledge
                    and status.knowledge == LibCharacterKnowledge.KNOWLEDGE_UNKNOWN then
                return true
            end
        end
    end
    return false
end

local function getInventoryItems()
    local items = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, item in ipairs(bagCache) do
        local itemLink = GetItemLink(item.bagId, item.slotIndex)
        local itemType = GetItemType(item.bagId, item.slotIndex)
        if itemType == ITEMTYPE_RACIAL_STYLE_MOTIF
            or itemType == ITEMTYPE_RECIPE then
            items[itemLink] = true
        end
    end
    return items;
end

local function scanBank()
    local inventoryItems = getInventoryItems()
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for _, item in ipairs(bagCache) do
        local itemLink = GetItemLink(item.bagId, item.slotIndex)
        local itemType = GetItemType(item.bagId, item.slotIndex)
        if inventoryItems[itemLink] == nil
            and isNeeded(itemLink, itemType) then
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
        withdrawNext()
    end
end

function WURAM.startWithdraw()
    if WURAM.isBankOpen == false then
        showDebug("bank closed")
        return
    end
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
ZO_CreateStringId("SI_BINDING_NAME_WURAM_WITHDRAW", "WURAM: withdraw")
local buttons = {}
buttons.withdraw = {
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
    {
        name = "WURAM: withdraw",
        keybind = "WURAM_WITHDRAW",
        callback = function()
            WURAM.startWithdraw()
        end,
        visible = function()
            return true
        end
    },
}

local function onBankOpen()
    KEYBIND_STRIP:AddKeybindButtonGroup(buttons.withdraw)
    WURAM.isBankOpen = true
end
local function onBankClose()
    WURAM.isBankOpen = false
    KEYBIND_STRIP:RemoveKeybindButtonGroup(buttons.withdraw)
end

local function showItemsToWithdraw()
    reset()
    scanBank()
    for i, item in pairs(itemsToWithdraw) do
        showDebug(item.itemLink)
    end
end

SLASH_COMMANDS["/wuram_show_to_withdraw"] = function()
    showItemsToWithdraw()
end
SLASH_COMMANDS["/wuram_start_withdraw"] = function()
    WURAM.startWithdraw()
end

EVENT_MANAGER:RegisterForEvent(WURAM.name, EVENT_OPEN_BANK, onBankOpen)
EVENT_MANAGER:RegisterForEvent(WURAM.name, EVENT_CLOSE_BANK, onBankClose)
