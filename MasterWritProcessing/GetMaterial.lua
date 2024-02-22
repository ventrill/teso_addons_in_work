







local function getMasterWritItemsByInv()
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        local itemType = GetItemType(bagId, slotIndex)
        if ITEMTYPE_MASTER_WRIT == itemType then
            local itemLink = GetItemLink(bagId, slotIndex)
            d(itemLink)
            local mat_list,know_list,parser = WritWorthy.ToMatKnowList(itemLink)
            for i, v in pairs(mat_list) do
                local item_id = v.item_id
                local count = v.ct
                local link = v.link
                d(string.format("[%s] %s %s", item_id, link, count))
            end
        end

    end
end



SLASH_COMMANDS["/mwp_test_material_inventory"] = function()
    --|H0:item:64489:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h
    getMasterWritItemsByInv()
end
