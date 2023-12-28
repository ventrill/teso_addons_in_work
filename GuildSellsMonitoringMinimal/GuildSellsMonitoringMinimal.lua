
local function getItemsOnTradingHouseListing()
    local items = {}
    local guildId = GetSelectedTradingHouseGuildId()
    if guildId < 1 then
        return items
    end
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
                sellerName = sellerName,
                displayQuality = displayQuality,
                icon = icon,
            })
        end
    end
    return items
end

local function getGuildName(guildId)
    if not GSMM.saved.guilds then
        GSMM.saved.guilds = {}
    end

    if not GSMM.saved.guilds[guildId] then
        GSMM.saved.guilds[guildId] = GetGuildName(guildId)
    end

    return GSMM.saved.guilds[guildId]
end


EVENT_MANAGER:RegisterForEvent(GSMM.addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

EVENT_MANAGER:RegisterForEvent(GSMM.addonName, EVENT_OPEN_TRADING_HOUSE, function()
    d('EVENT_OPEN_TRADING_HOUSE')
    GSMM.tradingOpenAt = GetTimeStamp()
    d("GSMM.tradingOpenAt: "..GSMM.tradingOpenAt)
end)


