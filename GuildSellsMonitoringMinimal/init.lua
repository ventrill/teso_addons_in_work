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
    if not GSMM.saved.guilds then
        GSMM.saved.guilds = {}
    end

    if not GSMM.saved.guilds[guildId] then
        if IsPlayerInGuild(guildId) then
            GSMM.saved.guilds[guildId] = GetGuildName(guildId) or guildId
        else
            GSMM.saved.guilds[guildId] = guildId
        end
    end

    return GSMM.saved.guilds[guildId]
end
