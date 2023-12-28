local function searchInTable(table, searchingData, indexToIgnore)
    for index, data in pairs(table) do
        if not indexToIgnore[index] then
            if data.itemLink == searchingData.itemLink then
                -- найдено совпадение по itemLink
                if data.expiration and searchingData.expiration and math.abs(data.expiration - searchingData.expiration) < 3600 then
                    -- разница поля expiration допустима
                    return index
                end
            end
        end
    end
    return nil
end

function GSMM.findSold(saved, active)
    local activeIndexFound = {}
    local savedIndexFound = {}
    local itemsSold = {}
    for savedIndex,savedData in pairs(saved) do
        local foundIndex = searchInTable(active, savedData, activeIndexFound)
        if foundIndex then
            GSMM.debug(foundIndex)
            activeIndexFound[foundIndex] = true
            savedIndexFound[savedIndex] = true
        else
            table.insert(itemsSold, savedData)
        end
    end
    return itemsSold
end


