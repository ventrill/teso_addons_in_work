ZO_CreateStringId("SI_BINDING_NAME_MWP_SHOW_PROCESSING_WINDOW", "Show Processing Window")
ZO_CreateStringId("SI_BINDING_NAME_MWP_SHOW_IN_STOCK_WINDOW", "Show In Stock Window")

local function OnAddOnLoaded(eventCode, addonName)
    if addonName ~= MasterWritProcessing.addonName then
        return
    end

    MasterWritProcessing.characterList = {}
    MasterWritProcessing.characterNameList = {}
    for i = 1, GetNumCharacters() do
        local name, _, _, _, _, _, characterId = GetCharacterInfo(i)
        name = ZO_CachedStrFormat(SI_UNIT_NAME, name)
        MasterWritProcessing.characterList[name] = characterId
        MasterWritProcessing.characterNameList[characterId] = name
    end

    MasterWritProcessing.ProcessingListOnLoad()
    MasterWritProcessing.CanBeProcessedByOnLoad()
    MasterWritProcessing.MaterialsForProcessingOnLoad()
    MasterWritProcessing.InStockOnLoad()
    MasterWritProcessing.MaterialForCollectingOnLoad()
    MasterWritProcessing.MaterialForCollectingShortOnLoad()

    MasterWritProcessing.savedVars = LibSavedVars:NewAccountWide(MasterWritProcessing.savedKey, "Account", {})
    if not MasterWritProcessing.savedVars.ParsedMotifList then
        MasterWritProcessing.savedVars.ParsedMotifList = {}
    end
    if not MasterWritProcessing.savedVars.ParsedRecipeList then
        MasterWritProcessing.savedVars.ParsedRecipeList = {}
    end
    if not MasterWritProcessing.savedVars.ParsedMaterials then
        MasterWritProcessing.savedVars.ParsedMaterials = {}
    end
    if not MasterWritProcessing.savedVars.InventoryFeeSlotsCount then
        MasterWritProcessing.savedVars.InventoryFeeSlotsCount = {}
    end

    if not MasterWritProcessing.savedVars.InStock then
        MasterWritProcessing.savedVars.InStock = {}
        MasterWritProcessing.savedVars.InStock.InBank = nil
        MasterWritProcessing.savedVars.InStock.Characters = {}
    end

    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.AFTER_FILTER_SETUP, function()
        MasterWritProcessing.initAGSFilter()
    end)
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.ITEM_PURCHASED, MasterWritProcessing.purchaseItemProcess)


    EVENT_MANAGER:UnregisterForEvent(MasterWritProcessing.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(MasterWritProcessing.addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)