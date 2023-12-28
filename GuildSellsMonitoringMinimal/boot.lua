


local function OnAddOnLoaded(eventCode, addonName)
    if addonName ~= GSMM.addonName then
        return
    end
    GSMM.debug('GSMM: Loaded')
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.GUILD_SELECTION_CHANGED, function()
        GSMM.debug('AwesomeGuildStore.callback.GUILD_SELECTION_CHANGED')
        --zo_callLater(function()
        --    GSMM.scanAndCompare()
        --end, 500)
    end)
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.ITEM_POSTED, function()
        GSMM.debug('AwesomeGuildStore.callback.ITEM_POSTED')
        --zo_callLater(function()
        --    GSMM.saveActualList()
        --end, 500)
    end)
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.ITEM_CANCELLED, function()
        GSMM.debug('AwesomeGuildStore.callback.ITEM_CANCELLED')
        --zo_callLater(function()
        --    GSMM.saveActualList()
        --end, 500)
    end)

    EVENT_MANAGER:RegisterForEvent(GSMM.addonName, EVENT_OPEN_TRADING_HOUSE, function()
        GSMM.debug('EVENT_OPEN_TRADING_HOUSE')
        GSMM.tradingOpenAt = GetTimeStamp()
        GSMM.debug("GSMM.tradingOpenAt: "..GSMM.tradingOpenAt)
    end)

    GSMM.saved = LibSavedVars:NewAccountWide(GSMM.savedKey, "Account", {})

    if GSMM.saved.forTest == nil then
        GSMM.saved.forTest = {}
    end
    if GSMM.saved.saved == nil then
        GSMM.saved.saved = {}
    end
    if GSMM.saved.sold == nil then
        GSMM.saved.sold = {}
    end

    EVENT_MANAGER:UnregisterForEvent(GSMM.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(GSMM.addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)