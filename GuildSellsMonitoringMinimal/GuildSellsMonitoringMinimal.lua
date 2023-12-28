local function getForSelectedOnly()
    local guildId = GetSelectedTradingHouseGuildId()
    local guildName = GetGuildName(guildId)
    d(string.format("%s selected", guildName))
    local num = GetNumTradingHouseListings()
    d(string.format("%d items on sale", num))

    if (num > 0) then
        for i = 1, num do
            local icon, name, displayQuality, stackCount, sellerName, timeRemaining, purchasePrice, currencyType, itemUniqueId, purchasePricePerUnit = GetTradingHouseListingItemInfo(i)
            local link = GetTradingHouseListingItemLink(i)
            local linkItemId = GetItemLinkItemId(link)
            d(string.format("%d) (%d)%s: %s * %s for %s", i, guildId, guildName, link, stackCount, purchasePrice))
            d(itemUniqueId)
            d(timeRemaining)
        end
    else
        d(string.format('%s: no items on sale', guildName))
    end
end

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

local function saveInfo(guildId, items)
    if not GSMM.saved.active then
        GSMM.saved.active = {}
    end
    local time = GSMM.tradingOpenAt
    if not GSMM.saved.active[time] then
        GSMM.saved.active[time] = {}
    end
    GSMM.saved.active[time][guildId] = items
end

local function scanActiveAndSave()
    local guildId = GetSelectedTradingHouseGuildId()

    if not guildId then
        d("no guild selected")
        return
    end

    local items = getItemsOnTradingHouseListing()
    if #items then
        d(string.format("Found %d on sale items", #items))
    else
        d("No items on sale")
    end

    -- saveInfo(guildId, items)
end

--SLASH_COMMANDS["/gsmm.ginfo"] = function()
--    showGuildInfo()
--end
SLASH_COMMANDS["/gsmm.showcnt"] = function()
    if GSMM.saved and GSMM.saved.active then
        for guildId, items in pairs(GSMM.saved.active) do
            d(string.format("%s: %d items on sale", getGuildName(guildId), #items))
        end
    end
end
--SLASH_COMMANDS["/gsmm.selllist"] = function()
--    showOnSellList()
--end
SLASH_COMMANDS["/gsmm.list"] = function()
    getForSelectedOnly()
end



--SLASH_COMMANDS["/gsmm.getsaved"] = function()
--    for key, value in pairs(GSMM.saved.forTest) do
--        -- do something
--        d("key: " .. tostring(key) .. ", value: " .. tostring(value))
--    end
--end

--SLASH_COMMANDS["/gsmm.addsaved"] = function(input)
--    table.insert(GSMM.saved.forTest, input)
--end

--  d(ZO_TradingHouse_CreateListingItemData(1))

SLASH_COMMANDS["/gsmm.savefortest"] = function()
    --if not GSMM.saved.forTest then
    --    GSMM.saved.forTest = {}
    --end
    --local guildId = GetSelectedTradingHouseGuildId()
    --if not guildId then
    --    d("no guild selected")
    --    return
    --end
    --
    --local num = GetNumTradingHouseListings()
    --if (num > 0) then
    --    for i = 1, num do
    --        table.insert(GSMM.saved.forTest, guildId, ZO_TradingHouse_CreateListingItemData(i))
    --    end
    --end
    --
    --if #GSMM.saved.forTest[guildId] then
    --    d(string.format("Found %d on sale items", #GSMM.saved.forTest[guildId]))
    --else
    --    d("No items on sale")
    --end
end

local function OnAddOnLoaded(eventCode, addonName)
    if addonName ~= GSMM.addonName then
        return
    end
    d('GSMM: Loaded')
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.GUILD_SELECTION_CHANGED, function()
        zo_callLater(function()
            scanActiveAndSave()
        end, 500)
    end)

    GSMM.saved = LibSavedVars:NewAccountWide(GSMM.savedKey, "Account", {})

    if GSMM.saved.forTest == nil then
        GSMM.saved.forTest = {}
    end


    --AGS.callback.ITEM_POSTED = "ItemPosted"

    --AGS.callback.ITEM_CANCELLED = "ItemCancelled"

    EVENT_MANAGER:UnregisterForEvent(GSMM.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(GSMM.addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

EVENT_MANAGER:RegisterForEvent(GSMM.addonName, EVENT_OPEN_TRADING_HOUSE, function()
    d('EVENT_OPEN_TRADING_HOUSE')
    GSMM.tradingOpenAt = GetTimeStamp()
    d("GSMM.tradingOpenAt: "..GSMM.tradingOpenAt)
end)


