local function onLoad(eventCode, name)
    if name ~= RecipeAndStileAssistant.AddonName then
        return
    end

    LibCharacterKnowledge.RegisterForCallback(RecipeAndStileAssistant.AddonName, LibCharacterKnowledge.EVENT_INITIALIZED, function()
        RecipeAndStileAssistant.init()
    end)
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.AFTER_FILTER_SETUP, function()
        RecipeAndStileAssistant.initAGSFilter()
    end)
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.ITEM_PURCHASED, RecipeAndStileAssistant.purchaseItemProcess)

    EVENT_MANAGER:UnregisterForEvent(RecipeAndStileAssistant.AddonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(RecipeAndStileAssistant.AddonName, EVENT_ADD_ON_LOADED, onLoad)
