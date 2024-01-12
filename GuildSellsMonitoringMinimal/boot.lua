ZO_CreateStringId("SI_BINDING_NAME_GSMM_onSaleList_TOGGLE_WINDOW", "On Sale List Toggle")
ZO_CreateStringId("SI_BINDING_NAME_GSMM_soldList_TOGGLE_WINDOW", "Sold List Toggle")
ZO_CreateStringId("SI_BINDING_NAME_GSMM_statistic_TOGGLE_WINDOW", "Statistic Window Toggle")

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
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.STORE_TAB_CHANGED, function(oldTab, newTab)
        if newTab == AwesomeGuildStore.internal.tradingHouse.listingTab then
            GSMM.isListingTabTradingHouseTab = true
            GSMM.debug('AwesomeGuildStore.callback.STORE_TAB_CHANGED - LISTING')
            --zo_callLater(function()
            --    GSMM.scanAndCompare()
            --end, 500)
        else
            GSMM.isListingTabTradingHouseTab = false
            GSMM.debug('AwesomeGuildStore.callback.STORE_TAB_CHANGED - else')
        end
    end)

    --AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.ITEM_POSTED, GSMM.processItemPost)

    --AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.ITEM_CANCELLED, GSMM.processItemCancel)

    GSMM.savedVars = LibSavedVars:NewAccountWide(GSMM.savedKey, "Account", {})

    if GSMM.savedVars.forTest == nil then
        GSMM.savedVars.forTest = {}
    end
    if GSMM.savedVars.saved == nil then
        GSMM.savedVars.saved = {}
    end
    if GSMM.savedVars.sold == nil then
        GSMM.savedVars.sold = {}
    end

    GSMM.OnSaleListOnLoad()
    GSMM.SoldListOnLoad()
    GSMM.statisticOnLoad()
    GSMM.actualListingOnLoad()

    EVENT_MANAGER:UnregisterForEvent(GSMM.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(GSMM.addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)