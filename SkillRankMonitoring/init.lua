SkillRankMonitoring = {
    addonName = 'SkillRankMonitoring',
    displayDebug = true,
    MorphChoice = 'all',
    StepFilterChoice = 'all',
    IsUltimateFilterChoice = 'all',
    IsLockedBySkillRankFilterChoice = 'all',
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

function SkillRankMonitoring.getAbilityInfo(abilityId)

    --* GetSpecificSkillAbilityKeysByAbilityId(*integer* _abilityId_)
    --** _Returns:_ *[SkillType|#SkillType]* _skillType_, *luaindex* _skillLineIndex_, *luaindex* _skillIndex_, *integer* _morphChoice_, *integer* _rank_
    local _skillType_, _skillLineIndex_, _skillIndex_, _morphChoice_, _rank_ = GetSpecificSkillAbilityKeysByAbilityId(abilityId)

    --* GetSkillAbilityInfo(*[SkillType|#SkillType]* _skillType_, *luaindex* _skillLineIndex_, *luaindex* _skillIndex_)
    --** _Returns:_ *string* _name_, *textureName* _texture_, *luaindex* _earnedRank_, *bool* _passive_, *bool* _ultimate_, *bool* _purchased_, *luaindex:nilable* _progressionIndex_, *integer* _rank_

    local lineRankNeededToUnlock = GetSkillAbilityLineRankNeededToUnlock(_skillType_, _skillLineIndex_, _skillIndex_)
    local currentLineRank = GetSkillLineDynamicInfo(_skillType_, _skillLineIndex_)

    local isLockedBySkillRank = lineRankNeededToUnlock > currentLineRank;
    local _, abilityIcon, _, _, isUltimate = GetSkillAbilityInfo(_skillType_, _skillLineIndex_, _skillIndex_)

    -- todo
    --local isUltimate = nil
    --* IsSkillAbilityUltimate(*[SkillType|#SkillType]* _skillType_, *luaindex* _skillLineIndex_, *luaindex* _skillIndex_)
    --** _Returns:_ *bool* _isUltimate_



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
        AbilityName = abilityName, -- 300
        AbilityRank = rank, -- 75
        CurrentXP = currentXP, -- 150
        LeftExp = leftExp, -- 150
        isComplete = isComplete,
    }
end

function SkillRankMonitoring.getClassAbility()
    local list = SkillRankMonitoring.getSavedAbilitiesList(SKILL_TYPE_CLASS)
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
function SkillRankMonitoring.getAVAAbility()
    local list = SkillRankMonitoring.getSavedAbilitiesList(SKILL_TYPE_AVA)
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

---formatExp
---@param amount number
---@return string
function SkillRankMonitoring.formatExp(amount)
    local div = 1000;
    if amount < div then
        return string.format("%d", amount)
    end

    local first = math.floor(amount / div)
    local last = math.fmod(amount, div)
    if last < 10 then
        --SRM.debug(string.format('last (%d) < 10 ', last))
        return string.format("%d 00%d", first, last)
    end
    if last < 100 then
        --SRM.debug(string.format('last (%d) < 100 ', last))
        return string.format("%d 0%d", first, last)
    end
    return string.format("%d %d", first, last)
end

function SkillRankMonitoring.DropdownShowTooltip(control, dropdownName)
    if dropdownName then
        InitializeTooltip(InformationTooltip, control, BOTTOMLEFT, 0, -2, TOPLEFT)
        InformationTooltip:SetHidden(false)
        InformationTooltip:ClearLines()
        InformationTooltip:AddLine(dropdownName)
    end
end
function SkillRankMonitoring.DropdownHideTooltip(control)
    InformationTooltip:ClearLines()
    InformationTooltip:SetHidden(true)

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