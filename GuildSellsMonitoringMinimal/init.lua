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
