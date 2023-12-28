local function isPlayerTradingHouse()
    local guildId = GetSelectedTradingHouseGuildId()
    if not guildId then
        d("guild not selected")
        return false
    end
    return IsPlayerInGuild(guildId)
end

local function main()
    if not isPlayerTradingHouse() then
        d('its not PlayerTradingHouse' )
        return
    end
    d('guild selected')

    -- 1 получение списка выставленных на данный момент предметов
    local actualListing = {}

    -- 2 получение списка сохраненного списка
    local savedListing={}

    -- 3 отределение перечня проданных итемов

    -- 4 созранение перечня проданных итемов

    -- 5 сохранение актуального списка
end


AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.GUILD_SELECTION_CHANGED, function()
    zo_callLater(function()
        main()
    end, 500)
end)



