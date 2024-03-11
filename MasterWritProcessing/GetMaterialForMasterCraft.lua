local MWP = MasterWritProcessing

local function prepareDataToShow()
    local list = {}

    for _, row in pairs(MWP.savedVars.ParsedMaterials) do
        local currentCount = MWP.MatHaveCt(row.itemLink)
        local toBuyCount = 0
        if row.toCraftNeedCount > currentCount then
            toBuyCount = row.toCraftNeedCount - currentCount
        end
        table.insert(list, {
            ['itemId'] = row.itemId,
            ['MaterialName'] = row.itemLink,
            ['MaterialIcon'] = GetItemLinkIcon(row['itemLink']),
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

