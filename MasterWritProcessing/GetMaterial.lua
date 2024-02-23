local MWP = MasterWritProcessing

local function getMasterWritItemsByInventory()
    local Items = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        local itemType = GetItemType(bagId, slotIndex)
        if ITEMTYPE_MASTER_WRIT == itemType then
            local itemLink = GetItemLink(bagId, slotIndex)
            table.insert(Items, itemLink)
        end
    end
    return Items
end

local function getMasterWritItemsByInventoryAndBank()
    local Items = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        local itemType = GetItemType(bagId, slotIndex)
        if ITEMTYPE_MASTER_WRIT == itemType then
            local itemLink = GetItemLink(bagId, slotIndex)
            table.insert(Items, itemLink)
        end
    end
    return Items
end

local function MatHaveCt(item_link)
    local bag_ct, bank_ct, craft_bag_ct = GetItemLinkStacks(item_link)
    return bag_ct + bank_ct + craft_bag_ct
end

local function parseMaterial(WritItemList)

    local allMatList = {}
    for _, writItemLink in pairs(WritItemList) do
        local mat_list, know_list, parser = WritWorthy.ToMatKnowList(writItemLink)
        for _, mat_row in pairs(mat_list) do
            if not allMatList[mat_row.item_id] then
                allMatList[mat_row.item_id] = {
                    itemId = mat_row.item_id,
                    itemLink = mat_row.link,
                    toCraftNeedCount = mat_row.ct,
                    currentCount = MatHaveCt(mat_row.link),
                }
            else
                allMatList[mat_row.item_id]['toCraftNeedCount'] = allMatList[mat_row.item_id]['toCraftNeedCount'] + mat_row.ct
            end
        end
    end

    for itemId, row in pairs(allMatList) do
        local toBuyCount = 0
        if row.toCraftNeedCount > row.currentCount then
            toBuyCount = row.toCraftNeedCount - row.currentCount
        end
        allMatList[itemId]['toBuyCount'] = toBuyCount
    end

    d("parsing done")
    return allMatList
end

function MasterWritProcessing.parseMaterialByAllSaved()
    local WritItemList = MWP.getAllSavedItemLinks()
    return parseMaterial(WritItemList)
end
function MasterWritProcessing.parseMaterialByInventoryAndBank()
    local WritItemList = getMasterWritItemsByInventoryAndBank()
    return parseMaterial(WritItemList)
end
function MasterWritProcessing.parseMaterialByInventory()
    local WritItemList = getMasterWritItemsByInventory()
    return parseMaterial(WritItemList)
end

