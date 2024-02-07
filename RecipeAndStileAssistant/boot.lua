local function onLoad(eventCode, name)
    if name ~= RecipeAndStileAssistant.AddonName then return end

    RecipeAndStileAssistant.init()
    AwesomeGuildStore:RegisterCallback( AwesomeGuildStore.callback.AFTER_FILTER_SETUP, function() RecipeAndStileAssistant.initAGSFilter() end)
    AwesomeGuildStore:RegisterCallback( AwesomeGuildStore.callback.ITEM_PURCHASED, function(itemData) RecipeAndStileAssistant.purchaseItemProcess(itemData) end)

    EVENT_MANAGER:UnregisterForEvent(RecipeAndStileAssistant.AddonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(RecipeAndStileAssistant.AddonName, EVENT_ADD_ON_LOADED, onLoad)
