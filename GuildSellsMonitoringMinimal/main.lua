local function isPlayerTradingHouse()
    local guildId = GetSelectedTradingHouseGuildId()
    if not guildId then
        GSMM.debug("guild not selected")
        return false
    end

    -- @todo add access to sale check

    return IsPlayerInGuild(guildId)
end

local function getItemsOnTradingHouseListing()
    local items = {}
    local num = GetNumTradingHouseListings()
    if (num > 0) then
        for i = 1, num do
            local icon, name, displayQuality, stackCount, sellerName, timeRemaining, purchasePrice, currencyType, itemUniqueId, purchasePricePerUnit = GetTradingHouseListingItemInfo(i)
            local link = GetTradingHouseListingItemLink(i)
            local itemId = GetItemLinkItemId(link)
            table.insert(items, {
                foundAt = GSMM.tradingOpenAt,
                timeRemaining = timeRemaining,
                expiration = GSMM.tradingOpenAt + timeRemaining,
                itemLink = link,
                itemId = itemId,
                name = name,
                stackCount = stackCount,
                purchasePrice = purchasePrice,
                itemUniqueId = itemUniqueId,
                purchasePricePerUnit = purchasePricePerUnit,
                currencyType = currencyType,
                displayQuality = displayQuality,
                icon = icon,
            })
        end
    end
    return items
end

local function getSavedListing()
    local guildId = GetSelectedTradingHouseGuildId()
    if GSMM.savedVars.saved[guildId] then
        return GSMM.savedVars.saved[guildId]
    end
    return {}
end

local function saveListing(items)
    local guildId = GetSelectedTradingHouseGuildId()
    GSMM.savedVars.saved[guildId] = items
end

local function addToSold(items)
    local guildId = GetSelectedTradingHouseGuildId()
    if not GSMM.savedVars.sold[guildId] then
        GSMM.savedVars.sold[guildId] = {}
    end
    for _, data in pairs(items) do
        data.lastFoundAt = data.foundAt
        data.addedToSoldAt = GetTimeStamp()
        table.insert(GSMM.savedVars.sold[guildId], data)
    end
end

function GSMM.scanAndCompare()
    if not isPlayerTradingHouse() then
        GSMM.debug('its not PlayerTradingHouse')
        return
    end
    GSMM.debug('guild selected')

    -- 1 получение списка выставленных на данный момент предметов
    local actualListing = getItemsOnTradingHouseListing()

    -- 2 получение списка сохраненного списка
    local savedListing = getSavedListing()
    GSMM.debug(string.format("%d actual, %d saved"))

    --if not #savedListing then
    --    saveListing(actualListing)
    --    GSMM.debug('not priv saved data')
    --    return
    --end
    --
    --if not #actualListing then
    --    addToSold(savedListing)
    --    saveListing(actualListing)
    --    GSMM.debug('actual is empty - all saved to sold')
    --    return
    --end
    --
    --local sold = GSMM.findSold(savedListing, actualListing)
    --addToSold(sold)
    --saveListing(actualListing)

    GSMM.debug('scan work done')
end

function GSMM.saveActualList()
    if not isPlayerTradingHouse() then
        GSMM.debug('its not PlayerTradingHouse')
        return
    end
    GSMM.debug('guild selected')

    local actualListing = getItemsOnTradingHouseListing()
    saveListing(actualListing)
    GSMM.debug('update done')
end


