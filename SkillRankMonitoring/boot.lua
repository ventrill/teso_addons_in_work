ZO_CreateStringId("SI_BINDING_NAME_SRM_TOGGLE_HOTBAR_WINDOW", "Show HotBar Info")
local function OnAddOnLoaded(eventCode, addonName)
    if addonName ~= SkillRankMonitoring.addonName then
        return
    end

    LibSkillsFactory:Initialize()

    SkillRankMonitoring.hotBarAbilityListOnLoad()
    SkillRankMonitoring.abilityListOnLoad()
    SkillRankMonitoring.statisticOnLoad()

    SkillRankMonitoring.savedVars = LibSavedVars:NewAccountWide(SkillRankMonitoring.savedKey, "Account", {})

    if SkillRankMonitoring.savedVars.saved == nil then
        SkillRankMonitoring.savedVars.saved = {}
    end

    if SkillRankMonitoring.savedVars.windowsPosition == nil then
        SkillRankMonitoring.savedVars.windowsPosition = {}
    end

    if SkillRankMonitoring.savedVars.charactersProgress == nil then
        SkillRankMonitoring.savedVars.charactersProgress = {}
    end

    if SkillRankMonitoring.savedVars.isCharacterProgressComplete == nil then
        SkillRankMonitoring.savedVars.isCharacterProgressComplete = {}
    end

    -- SkillRankMonitoring.updateCharacterStatisticOnLoad()
    SkillRankMonitoring:CheckHotBarAbilities()

    EVENT_MANAGER:UnregisterForEvent(SkillRankMonitoring.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(SkillRankMonitoring.addonName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)