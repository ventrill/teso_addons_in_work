ZO_CreateStringId("SI_BINDING_NAME_MWP_SHOW_PROCESSING_WINDOW", "Show Processing Window")

local function OnAddOnLoaded(eventCode, addonName)
    if addonName ~= MasterWritProcessing.addonName then
        return
    end

    MasterWritProcessing.ProcessingListOnLoad()

    MasterWritProcessing.savedVars = LibSavedVars:NewAccountWide(MasterWritProcessing.savedKey, "Account", {})
    if MasterWritProcessing.savedVars == nil then
        MasterWritProcessing.savedVars = {}
        MasterWritProcessing.savedVars.InStock = {}
        MasterWritProcessing.savedVars.InStock.InBank = nil
    end

    MasterWritProcessing.InStockOnCharLoad()
    EVENT_MANAGER:RegisterForEvent(MasterWritProcessing.addonName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, MasterWritProcessing.OnItemSlotUpdate)

    EVENT_MANAGER:UnregisterForEvent(MasterWritProcessing.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(MasterWritProcessing.addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)