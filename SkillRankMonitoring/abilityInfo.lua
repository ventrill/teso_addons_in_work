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
        if endXP > startXP then
            allExp = allExp + endXP - startXP
        end
    end
    return allExp
end

function SkillRankMonitoring.getAbilityInfo(abilityId)
    local _skillType_, _skillLineIndex_, _skillIndex_, _morphChoice_, _rank_ = GetSpecificSkillAbilityKeysByAbilityId(abilityId)
    local lineRankNeededToUnlock = GetSkillAbilityLineRankNeededToUnlock(_skillType_, _skillLineIndex_, _skillIndex_)
    local currentLineRank = GetSkillLineDynamicInfo(_skillType_, _skillLineIndex_)

    local isLockedBySkillRank = lineRankNeededToUnlock > currentLineRank;
    local _, _, _, _, isUltimate = GetSkillAbilityInfo(_skillType_, _skillLineIndex_, _skillIndex_)

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
        isUltimate = isUltimate,
        isLockedBySkillRank = isLockedBySkillRank,
        _morphChoice_ = _morphChoice_,
        Icon = GetAbilityIcon(abilityId),
        TotalExp = totalExp,
        abilityId = abilityId,
        AbilityName = abilityName,
        AbilityRank = rank,
        CurrentXP = currentXP,
        LeftExp = leftExp,
        isComplete = isComplete,
    }
end

function SkillRankMonitoring.prepareInfoByAll()
    local skillTypes = { SKILL_TYPE_CLASS, SKILL_TYPE_AVA, SKILL_TYPE_WEAPON, SKILL_TYPE_WORLD, SKILL_TYPE_GUILD, SKILL_TYPE_ARMOR }
    local list = SkillRankMonitoring.getAllSavedAbilitiesList(skillTypes)
    local info = {}
    for _, abilityId in pairs(list) do
        if abilityId > 0 then
            local aI = SkillRankMonitoring.getAbilityInfo(abilityId);
            if aI then
                table.insert(info, aI)
            end
        end
    end
    return info;

end
function SkillRankMonitoring.prepareInfoBySkillType(skillType)
    local list = SkillRankMonitoring.getAllSavedAbilitiesList({ skillType })
    local info = {}
    for _, abilityId in pairs(list) do
        if abilityId > 0 then
            local aI = SkillRankMonitoring.getAbilityInfo(abilityId);
            if aI then
                table.insert(info, aI)
            end
        end
    end
    return info;
end

function SkillRankMonitoring.prepareHotBarInfo()
    local list = getHotBarAbility()
    local info = {}
    for _, abilityId in pairs(list) do
        if abilityId > 0 then
            local aI = SkillRankMonitoring.getAbilityInfo(abilityId);
            if aI then
                table.insert(info, aI)
            end
        end
    end
    return info;
end
