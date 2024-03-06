local MWP = MasterWritProcessing

local function MatHaveCt(item_link)
    local bag_ct, bank_ct, craft_bag_ct = GetItemLinkStacks(item_link)
    return bag_ct + bank_ct + craft_bag_ct
end

local function prepareDataToShow()
    local list = {}

    for _, row in pairs(MWP.savedVars.ParsedMaterials) do
        local currentCount = MatHaveCt(row.itemLink)
        local toBuyCount = 0
        if row.toCraftNeedCount > currentCount then
            toBuyCount = currentCount - row.toCraftNeedCount
        end
        table.insert(list, {
            ['itemId'] = row.itemId,
            ['MaterialName'] = row.itemLink,
            ['toCraftNeedCount'] = row.toCraftNeedCount,
            ['currentCount'] = currentCount,
            ['toBuyCount'] = toBuyCount,
        })
    end

    return list
end

function MWP.parseMaterialByAllSaved()
    MWP.parseAllSaved()
    return prepareDataToShow()
end
function MWP.parseMaterialByInventoryAndBank()
    MWP.parseByInventoryAndBank()
    return prepareDataToShow()
end
function MWP.parseMaterialByInventory()
    MWP.parseByInventory()
    return prepareDataToShow()
end

