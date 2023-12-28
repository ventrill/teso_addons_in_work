local saved1 = {
    [1] = {
        ["itemLink"] = "|H0:item:68343:370:50:0:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0|h|h",
        ["name"] = "Truly Superb Glyph of Prismatic Defense",
        ["currencyType"] = 1,
        ["stackCount"] = 1,
        ["itemId"] = 68343,
        ["icon"] = "/esoui/art/icons/crafting_enchantment_036.dds",
        ["purchasePrice"] = 75000,
        ["itemUniqueId"] = 2.8357143407,
        ["expiration"] = 1706176985,
        ["purchasePricePerUnit"] = 75000,
        ["displayQuality"] = 5,
        ["timeRemaining"] = 2473656,
        ["foundAt"] = 1703703329,
    },
    [2] = {
        ["itemLink"] = "|H0:item:68343:370:50:0:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0|h|h",
        ["name"] = "Truly Superb Glyph of Prismatic Defense",
        ["currencyType"] = 1,
        ["stackCount"] = 1,
        ["itemId"] = 68343,
        ["icon"] = "/esoui/art/icons/crafting_enchantment_036.dds",
        ["purchasePrice"] = 75000,
        ["itemUniqueId"] = 2.8357143407,
        ["expiration"] = 1706176983,
        ["purchasePricePerUnit"] = 75000,
        ["displayQuality"] = 5,
        ["timeRemaining"] = 2473654,
        ["foundAt"] = 1703703329,
    },
    [3] = {
        ["itemLink"] = "|H0:item:199085:124:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["name"] = "Style Page: Morningstar Frostwear Shoes",
        ["currencyType"] = 1,
        ["stackCount"] = 1,
        ["itemId"] = 199085,
        ["icon"] = "/esoui/art/icons/quest_summerset_completed_report.dds",
        ["purchasePrice"] = 70000,
        ["itemUniqueId"] = 2.8357143408,
        ["expiration"] = 1706176907,
        ["purchasePricePerUnit"] = 70000,
        ["displayQuality"] = 5,
        ["timeRemaining"] = 2473578,
        ["foundAt"] = 1703703329,
    },
}
local active1 = {
    [1] = {
        ["itemLink"] = "|H0:item:68343:370:50:0:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0|h|h",
        ["name"] = "Truly Superb Glyph of Prismatic Defense",
        ["currencyType"] = 1,
        ["stackCount"] = 1,
        ["itemId"] = 68343,
        ["icon"] = "/esoui/art/icons/crafting_enchantment_036.dds",
        ["purchasePrice"] = 75000,
        ["itemUniqueId"] = 2.8357143407,
        ["expiration"] = 1706176973,
        ["purchasePricePerUnit"] = 75000,
        ["displayQuality"] = 5,
        ["timeRemaining"] = 2473515,
        ["foundAt"] = 1703703458,
    },
    [2] = {
        ["itemLink"] = "|H0:item:199085:124:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["name"] = "Style Page: Morningstar Frostwear Shoes",
        ["currencyType"] = 1,
        ["stackCount"] = 1,
        ["itemId"] = 199085,
        ["icon"] = "/esoui/art/icons/quest_summerset_completed_report.dds",
        ["purchasePrice"] = 70000,
        ["itemUniqueId"] = 2.8357143408,
        ["expiration"] = 1706176907,
        ["purchasePricePerUnit"] = 70000,
        ["displayQuality"] = 5,
        ["timeRemaining"] = 2473578,
        ["foundAt"] = 1703703329,
    },

}

local function searchInTable(table, searchingData, indexToIgnore)
    for index, data in pairs(table) do
        if not indexToIgnore[index] then
            if data.itemLink == searchingData.itemLink then
                -- найдено совпадение по itemLink
                if math.abs(data.expiration - searchingData.expiration) < 3600 then
                    -- разница поля expiration допустима

                    --совпадение найдено
                    --active[i] это
                    --saved[foundIndex]
                    return index
                end
            end

        end
    end
    return nil
end

local function findSold(saved, active)
    local activeIndexFound = {}
    local savedIndexFound = {}
    local itemsSold = {}
    for savedIndex,savedData in pairs(saved) do
        local foundIndex = searchInTable(active, savedData, activeIndexFound)
        if foundIndex then
            print(foundIndex)
            activeIndexFound[foundIndex] = true
            savedIndexFound[savedIndex] = true
        end
    end

    for savedIndex,savedData in pairs(saved) do
        if not savedIndexFound[savedIndex] then
            table.insert(itemsSold, savedData)
        end
    end
    return itemsSold
end

local rest = findSold(saved1, active1)
for _,data in pairs(rest) do
    print(data.name)
end

