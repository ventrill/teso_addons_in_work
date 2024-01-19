local function isPlayerTradingHouse(guildId)
    -- @todo add access to sale check
    return IsPlayerInGuild(guildId)
end

local function formatTimeRemaining(timeLeft)
    local days = 33
    local hours = 0
    local minutes = 0
    days = math.floor(timeLeft / 86400)
    hours = math.floor((timeLeft - days * 86400) / 3600)
    minutes = math.floor((timeLeft - days * 86400 - hours * 3600) / 60)
    return string.format("%dd %dh %dm", days, hours, minutes)
end

local function getItemsOnTradingHouseListing()
    local items = {}
    local num = GetNumTradingHouseListings()
    if (num > 0) then
        for i = 1, num do
            local icon, name, displayQuality, stackCount, sellerName, timeRemaining, purchasePrice, currencyType, itemUniqueId, purchasePricePerUnit = GetTradingHouseListingItemInfo(i)
            local link = GetTradingHouseListingItemLink(i)
            local itemId = GetItemLinkItemId(link)
            local tradingOpenAt = GetTimeStamp()
            table.insert(items, {
                foundAt = tradingOpenAt,
                timeRemaining = timeRemaining,
                expiration = tradingOpenAt + timeRemaining,
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

local function getSavedListing(guildId)
    if GSMM.savedVars.saved[guildId] then
        return GSMM.savedVars.saved[guildId]
    end
    return {}
end

local function saveListing(guildId, items)
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

function GSMM.scanStart()
    local guildId = GetSelectedTradingHouseGuildId()
    if not guildId then
        GSMM.debug("guild not selected")
        return
    end
    if not isPlayerTradingHouse(guildId) then
        GSMM.debug('its not PlayerTradingHouse')
        return
    end
    GSMM.debug('guild selected')

    if not GSMM.isListingTabTradingHouseTab then
        GSMM.debug("wrong tab opened")
        return
    end
    GSMM.debug("isListingTabTradingHouseTab")

    -- 1 получение списка выставленных на данный момент предметов
    local actualListing = getItemsOnTradingHouseListing()

    -- 2 получение списка сохраненного списка
    local savedListing = getSavedListing(guildId)
    GSMM.debug(string.format("%d actual, %d saved", #actualListing, #savedListing))

    --if not #savedListing then
    --    saveListing(guildId,actualListing)
    --    GSMM.debug('not priv saved data')
    --    return
    --end
    --
    --if not #actualListing then
    --    addToSold(savedListing)
    --    saveListing(guildId,actualListing)
    --    GSMM.debug('actual is empty - all saved to sold')
    --    return
    --end
    --
    --local sold = GSMM.findSold(savedListing, actualListing)
    --addToSold(sold)
    --saveListing(guildId,actualListing)

    --GSMM.debug('scan work done')
    --GSMM.ScreenMessage('scan work done')

    GSMM.setActualListingData(actualListing)
    GSMM.showActualListingWindow()
end

function GSMM.scanAndCompare()
    local guildId = GetSelectedTradingHouseGuildId()
    if not guildId then
        GSMM.debug("guild not selected")
        return
    end

    if not isPlayerTradingHouse(guildId) then
        GSMM.debug('its not PlayerTradingHouse')
        return
    end
    GSMM.debug('guild selected')

    if not GSMM.isListingTabTradingHouseTab then
        GSMM.debug("wrong tab opened")
        return
    end
    GSMM.debug("isListingTabTradingHouseTab")

    -- 1 получение списка выставленных на данный момент предметов
    local actualListing = getItemsOnTradingHouseListing()

    -- 2 получение списка сохраненного списка
    local savedListing = getSavedListing(guildId)
    GSMM.debug(string.format("%d actual, %d saved", #actualListing, #savedListing))

    --if not #savedListing then
    --    saveListing(guildId,actualListing)
    --    GSMM.debug('not priv saved data')
    --    return
    --end
    --
    --if not #actualListing then
    --    addToSold(savedListing)
    --    saveListing(guildId,actualListing)
    --    GSMM.debug('actual is empty - all saved to sold')
    --    return
    --end
    --
    --local sold = GSMM.findSold(savedListing, actualListing)
    --addToSold(sold)
    --saveListing(guildId,actualListing)

    GSMM.debug('scan work done')
    GSMM.ScreenMessage('scan work done')
end

function GSMM.processItemPost(guildId, itemLink, price, stackCount)
    GSMM.debug(string.format("processItemPost START for %s Item %s for %s", guildId, itemLink, price))

    local items = getSavedListing(guildId)

    table.insert(items, {
        foundAt = GetTimeStamp(),
        timeRemaining = GSMM.timeRemainingDefault,
        expiration = GetTimeStamp() + GSMM.timeRemainingDefault,
        itemLink = itemLink,
        stackCount = stackCount,
        purchasePrice = price,
        purchasePricePerUnit = 1,
        currencyType = CURT_MONEY,
    })

    saveListing(guildId, items)
    GSMM.debug(string.format("processItemPost DONE for %s Item %s for %s", guildId, itemLink, price))
end

function GSMM.processItemCancel()

end

function GSMM.saveActualList()
    local guildId = GetSelectedTradingHouseGuildId()
    if not guildId then
        GSMM.debug("guild not selected")
        return
    end

    if isPlayerTradingHouse(guildId) == false then
        GSMM.debug('its not PlayerTradingHouse')
        return
    end
    GSMM.debug('guild selected')

    local actualListing = getItemsOnTradingHouseListing()
    saveListing(guildId, actualListing)
    GSMM.debug('update done')
end


function GSMM.HeaderMouseEnter(control, tooltipIndex)
    if tooltipIndex and GSMM.SORTHEADER_TOOLTIP[tooltipIndex] then
        InitializeTooltip(InformationTooltip, control, TOP, -5, 0)
        SetTooltipText(InformationTooltip, GSMM.SORTHEADER_TOOLTIP[tooltipIndex])
    else
        GSMM.debug("no tooltip for tooltipIndex ".. tooltipIndex)
    end
end

function GSMM.HeaderMouseExit(control, tooltipIndex)
    if tooltipIndex then
        ClearTooltip(InformationTooltip)
    end
end

function GSMM.DropdownShowTooltip(control, dropdownName)
    if GSMM.DropdownTooltips[dropdownName] then
        InitializeTooltip(InformationTooltip, control, BOTTOMLEFT, 0, -2, TOPLEFT)
        InformationTooltip:SetHidden(false)
        InformationTooltip:ClearLines()
        InformationTooltip:AddLine(GSMM.DropdownTooltips[dropdownName])
    end
end
function GSMM.DropdownHideTooltip(control)
    InformationTooltip:ClearLines()
    InformationTooltip:SetHidden(true)
end