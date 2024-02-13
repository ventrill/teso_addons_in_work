SkillRankMonitoring = {
    addonName = SkillRankMonitoring,
}

local function getHotBarAbility()
    local skillTable = {}
    for hotBarCategory = 0, 1 do
        for slotIndex = 3, 8 do
            local hotBarData = ACTION_BAR_ASSIGNMENT_MANAGER:GetHotbar(hotBarCategory)
            if hotBarData then
                local slotData = hotBarData:GetSlotData(slotIndex)
                if slotData then
                    local abilityId = 0
                    if slotData:IsEmpty() then
                        abilityId = slotData:GetEffectiveAbilityId()
                        table.insert(skillTable, abilityId)
                    end
                end
            end
        end
    end
    return skillTable
end

local function getAbilityInfo(abilityId)
    local progressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId(abilityId)
    if not progressionData then
        d('no progressionData')
        return
    end
    local abilityName = zo_strformat("<<C:1>>", progressionData:GetName())
    local rank = progressionData:GetCurrentRank()
    local startXP, endXP = progressionData:GetRankXPExtents(rank)
    local currentXP = progressionData:GetCurrentXP()
    local leftExp = endXP - currentXP
    local isComplete = currentXP >= endXP
    return {
        abilityId = abilityId,
        AbilityName = abilityName, -- 300
        AbilityRank = rank, -- 75
        StartXP = startXP, -- 150
        EndXP = endXP, -- 150
        CurrentXP = currentXP, -- 150
        LeftExp = leftExp, -- 150
        isComplete = isComplete,
    }
end

function SkillRankMonitoring.preparePanelInfo()
    local list = getHotBarAbility()
    local info = {}
    for _, abilityId in pairs(list) do
        if abilityId > 0 then
            table.insert(info, getAbilityInfo(abilityId))
        end
    end
    return info;
end

function SkillRankMonitoring.HeaderMouseEnter(control, name)
end

function SkillRankMonitoring.HeaderMouseExit(control, name)

end