GSMM = {
    addonName = 'GuildSellsMonitoringMinimal',
    savedKey = 'GuildSellsMonitoringMinimal_Data',
    saved = {},
    displayDebug = true,
    timeRemainingDefault = 30 * 24 * 60 * 60, -- 30 days in seconds
    isListingTabTradingHouseTab = false,
}

function GSMM.debug(string)
    if not GSMM.displayDebug then
        return
    end
    d('GSMM: ' .. string)
end

function GSMM.getGuildName(guildId)
    if not GSMM.savedVars.guilds then
        GSMM.savedVars.guilds = {}
    end

    if not GSMM.savedVars.guilds[guildId] then
        if IsPlayerInGuild(guildId) then
            GSMM.savedVars.guilds[guildId] = GetGuildName(guildId) or guildId
        else
            GSMM.savedVars.guilds[guildId] = guildId
        end
    end

    return GSMM.savedVars.guilds[guildId]
end

function GSMM.getSoldItemsList()
    local sold = GSMM.savedVars.sold
    local items = {}

    for guildId, guildSold in pairs(sold) do
        --GSMM.debug(string.format("work with %d %s", guildId, GSMM.getGuildName(guildId)))
        for _, savedRow in pairs(guildSold) do
            --GSMM.debug(savedRow.itemLink)
            table.insert(items, {
                itemLink = savedRow.itemLink,
                addedToSoldAt = savedRow.addedToSoldAt,
                lastFoundAt = savedRow.lastFoundAt,
                stackCount = savedRow.stackCount,
                purchasePricePerUnit = savedRow.purchasePricePerUnit,
                purchasePrice = savedRow.purchasePrice,
                guildName = GSMM.getGuildName(guildId),
                guildId = guildId,
            })
        end
    end

    return items

end

local function getStatisticRow(guildId, guildSold)
    local GuildName = GSMM.getGuildName(guildId)
    local ItemsSoldCount = 0
    local SoldSum = 0
    local LastScanAt = nil
    for _, savedRow in pairs(guildSold) do
        SoldSum = SoldSum + savedRow.purchasePrice
        ItemsSoldCount = ItemsSoldCount + 1
    end

    return {
        GuildName = GuildName,
        ItemsSoldCount = ItemsSoldCount,
        SoldSum = SoldSum,
        LastScanAt = LastScanAt,
    }
end

function GSMM.getSalesStatistic()
    local items = {}
    local sold = GSMM.savedVars.sold
    for guildId, guildSold in pairs(sold) do
        table.insert(items, getStatisticRow(guildId, guildSold))
    end
    return items
end

function GSMM.getOnSaleItemsList()
    local saved = GSMM.savedVars.saved
    local items = {}

    for guildId, guildSaved in pairs(saved) do
        --GSMM.debug(string.format("work with %d %s", guildId, GSMM.getGuildName(guildId)))
        for _, savedRow in pairs(guildSaved) do
            --GSMM.debug(savedRow.itemLink)
            table.insert(items, {
                itemLink = savedRow.itemLink,
                expiration = savedRow.expiration,
                timeRemaining = savedRow.timeRemaining,
                stackCount = savedRow.stackCount,
                purchasePricePerUnit = savedRow.purchasePricePerUnit,
                purchasePrice = savedRow.purchasePrice,
                guildName = GSMM.getGuildName(guildId),
                guildId = guildId,
            })
        end
    end

    return items
end

function GSMM.ScreenMessage(message, delay)
    local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_MAJOR_TEXT, SOUNDS.BOOK_ACQUIRED)
    messageParams:SetText("|t42:42:/esoui/art/icons/mapkey/mapkey_wayshrine.dds|t " .. message)
    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end