local MWP = MasterWritProcessing

local function getMasterWritItemsByInvAndBank()
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

    --local allMatList = {}
    --local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK)
    --for _, slotData in ipairs(bagCache) do
    --    local bagId = slotData.bagId
    --    local slotIndex = slotData.slotIndex
    --    local itemType = GetItemType(bagId, slotIndex)
    --    if ITEMTYPE_MASTER_WRIT == itemType then
    --        local itemLink = GetItemLink(bagId, slotIndex)
    --        --d(itemLink)
    --        local mat_list, know_list, parser = WritWorthy.ToMatKnowList(itemLink)
    --        for i, v in pairs(mat_list) do
    --            --d(string.format("[%s] %s %s", v.item_id, v.link, v.ct))
    --            if not allMatList[v.item_id] then
    --                allMatList[v.item_id] = {
    --                    item_id = v.item_id,
    --                    count = v.ct,
    --                    link = v.link
    --                }
    --            else
    --                allMatList[v.item_id]['count'] = allMatList[v.item_id]['count'] + v.ct
    --            end
    --        end
    --    end
    --
    --end
    --d("parsing done")
    --local function MatHaveCt(item_link)
    --    local bag_ct, bank_ct, craft_bag_ct = GetItemLinkStacks(item_link)
    --    return bag_ct + bank_ct + craft_bag_ct
    --end
    --
    --for itemId, row in pairs(allMatList) do
    --    d(string.format("[%s] %s %s / %s", itemId, row.link, row.count, MatHaveCt(row.link)))
    --end

    return Items
end

local function MatHaveCt(item_link)
    local bag_ct, bank_ct, craft_bag_ct = GetItemLinkStacks(item_link)
    return bag_ct + bank_ct + craft_bag_ct
end

function MWP.parseMaterial()
    --local WritItemList = getMasterWritItemsByInvAndBank()
    local WritItemList = MWP.getAllSavedItemLinks()

    local allMatList = {}
    for _, writItemLink in pairs(WritItemList) do
        local mat_list, know_list, parser = WritWorthy.ToMatKnowList(writItemLink)
        for _, mat_row in pairs(mat_list) do
            --d(string.format("[%s] %s %s", v.item_id, v.link, v.ct))
            if not allMatList[mat_row.item_id] then
                allMatList[mat_row.item_id] = {
                    itemId = mat_row.item_id,
                    toCraftNeedCount = mat_row.ct,
                    currentCount = MatHaveCt(mat_row.link),
                    itemLink = mat_row.link,
                }
            else
                allMatList[mat_row.item_id]['toCraftNeedCount'] = allMatList[mat_row.item_id]['toCraftNeedCount'] + mat_row.ct
            end
        end

    end

    --local function MatHaveCt(item_link)
    --    local bag_ct, bank_ct, craft_bag_ct = GetItemLinkStacks(item_link)
    --    return bag_ct + bank_ct + craft_bag_ct
    --end

    --for itemId, row in pairs(allMatList) do
    --    d(string.format("[%s] %s %s / %s", itemId, row.link, row.count, MatHaveCt(row.link)))
    --end
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

SLASH_COMMANDS["/mwp_test_material_inventory"] = function()
    --|H0:item:64489:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h
    --getMasterWritItemsByInvAndBank()
    MWP.parseMaterial()
end
