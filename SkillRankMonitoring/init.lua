SkillRankMonitoring = {
    addonName = 'SkillRankMonitoring',
    displayDebug = true,
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
                    if not slotData:IsEmpty() then
                        abilityId = slotData:GetEffectiveAbilityId()
                        table.insert(skillTable, abilityId)
                    end
                end
            end
        end
    end
    return skillTable
end

local function getTotalExp(progressionData)
    local allExp = 0;
    for i = 1, 4 do
        local startXP, endXP = progressionData:GetRankXPExtents(i)
        --SkillRankMonitoring.debug(string.format("%s - For Rank %d start %d - finish %d", progressionData:GetName(), i, startXP, endXP))
        if endXP > startXP then
            allExp = allExp + endXP - startXP
        end
    end
    return allExp
end

local function getAbilityInfo(abilityId)
    local progressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId(abilityId)
    if not progressionData then
        SkillRankMonitoring.debug('no progressionData')
        return
    end
    local abilityName = zo_strformat("<<C:1>>", progressionData:GetName())
    local rank = progressionData:GetCurrentRank()
    local totalExp = getTotalExp(progressionData)
    local currentXP = progressionData:GetCurrentXP()
    local leftExp = totalExp - currentXP
    if leftExp <= 0 then
        leftExp = 0
    end
    local isComplete = currentXP >= totalExp
    return {
        Icon = GetAbilityIcon(abilityId),
        TotalExp = totalExp,
        abilityId = abilityId,
        AbilityName = abilityName, -- 300
        AbilityRank = rank, -- 75
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
            local aI = getAbilityInfo(abilityId);
            if aI then
                table.insert(info, getAbilityInfo(abilityId))
            end
        end
    end
    return info;
end

function SkillRankMonitoring.HeaderMouseEnter(control, name)
end

function SkillRankMonitoring.HeaderMouseExit(control, name)
end

function SkillRankMonitoring.debug(string)
    if not SkillRankMonitoring.displayDebug then
        return
    end
    d('RSM: ' .. string)
end