ZO_CreateStringId("SI_BINDING_NAME_SRM_TOGGLE_WINDOW", "Show List")
local function OnAddOnLoaded(eventCode, addonName)
    if addonName ~= SkillRankMonitoring.addonName then
        return
    end

    SkillRankMonitoring.abilityListOnLoad()

    EVENT_MANAGER:UnregisterForEvent(SkillRankMonitoring.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(SkillRankMonitoring.addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)