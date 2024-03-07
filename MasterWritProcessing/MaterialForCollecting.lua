local MWP = MasterWritProcessing

local listToCollect = {}

local function addItemToCollect(itemId, itemLink, count, countKey)
    if not listToCollect[itemId] then
        listToCollect[itemId] = {
            ['itemId'] = itemId,
            ['itemLink'] = itemLink,
            [countKey] = 0, -- 'forMasterCraft','itemReserve','dailyReserve'
            ['atAll'] = 0
        }
    end
    listToCollect[itemId][countKey] = listToCollect[itemId][countKey] + count
    listToCollect[itemId]['atAll'] = listToCollect[itemId]['atAll'] + count
end

local function updateByCollected()
    for key, rowData in pairs(listToCollect) do
        local toCollect = 0
        local collected = MWP.MatHaveCt(rowData['itemLink'])
        if rowData['atAll'] > collected then
            toCollect = rowData['atAll'] - collected
        end

        listToCollect[key]['collected'] = collected
        listToCollect[key]['toCollect'] = toCollect
    end
end

local function resetListToCollect()
    listToCollect = {}
    for i, v in pairs(MWP.savedVars.ParsedMaterials) do
        --[[
                local itemId = v['itemId']
                local itemLink = v['itemLink']
                local neededCount = v['toCraftNeedCount']
        ]]
        addItemToCollect(v['itemId'], v['itemLink'], v['toCraftNeedCount'], 'forMasterCraft')
    end

    for i, v in pairs(MWP.reserveForItemCraft) do
        --[[
                local neededCount = v['count']
                local itemLink = v['itemLink']
                local itemId = v['itemId']
        ]]
        addItemToCollect(v['itemId'], v['itemLink'], v['count'], 'itemReserve')
    end

    for i, v in pairs(MWP.reserveForDailyCraft) do
        --[[
                local neededCount = v['count']
                local itemLink = v['itemLink']
                local itemId = v['itemId']
        ]]
        addItemToCollect(v['itemId'], v['itemLink'], v['count'], 'dailyReserve')
    end
    updateByCollected()
    return listToCollect
end

-- обработка покупки
function MWP.purchaseProcessing(itemId, count)
    if not listToCollect[itemId] then
        return
    end
    local collected = listToCollect[itemId]['collected'];
    local toCollect = listToCollect[itemId]['toCollect'];
    collected = collected + count

    if toCollect > count then
        toCollect = toCollect - count
    else
        toCollect = 0
    end

    listToCollect[itemId]['collected'] = collected
    listToCollect[itemId]['toCollect'] = toCollect
end

-- проверка необходимости
function MWP.isItemNeed(itemId, count)
    if not listToCollect[itemId] then
        return false
    end

    if listToCollect[itemId]['toCollect'] >= count then
        return true
    end

    return false
end

-- отобразить текущее состояние
function MWP.getSavedInfoToShow()
    local list = {}
    for _, dataRow in pairs(listToCollect) do
        table.insert(list, {
            ['itemId'] = dataRow['itemId'],
            ['itemLink'] = dataRow['itemLink'],
            ['itemIcon'] = GetItemLinkIcon(dataRow['itemLink']),

            ['forMasterCraft'] = dataRow['forMasterCraft'],
            ['itemReserve'] = dataRow['itemReserve'],
            ['dailyReserve'] = dataRow['dailyReserve'],
            ['atAll'] = dataRow['atAll'],

            ['collected'] = dataRow['collected'],

            ['toCollect'] = dataRow['toCollect'],
        })
    end
    return list
end

-- сбросить текущеесщстояние до актуального и отобразить текущее состояние
function MWP.getActualInfoToShow()
    resetListToCollect()
    return MWP.getSavedInfoToShow()
end

