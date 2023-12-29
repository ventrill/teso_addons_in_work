GSMM = {
    addonName = 'GuildSellsMonitoringMinimal',
    savedKey = 'GuildSellsMonitoringMinimal_Data',
    saved = {},
    tradingOpenAt = nil,
    displayDebug = true,
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
