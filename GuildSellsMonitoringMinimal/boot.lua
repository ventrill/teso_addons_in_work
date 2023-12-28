


local function OnAddOnLoaded(eventCode, addonName)
    if addonName ~= GSMM.addonName then
        return
    end
    d('GSMM: Loaded')
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.GUILD_SELECTION_CHANGED, function()
        --zo_callLater(function()
        --    GSMM.scanAndCompare()
        --end, 500)
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


    --AGS.callback.ITEM_POSTED = "ItemPosted"

    --AGS.callback.ITEM_CANCELLED = "ItemCancelled"

    EVENT_MANAGER:UnregisterForEvent(GSMM.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(GSMM.addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)