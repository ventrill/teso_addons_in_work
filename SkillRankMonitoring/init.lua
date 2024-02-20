SkillRankMonitoring = {
    addonName = 'SkillRankMonitoring',
    displayDebug = true,
    MorphChoice = 'all',
    StepFilterChoice = 'not_complete',
    IsUltimateFilterChoice = 'all',
    IsLockedBySkillRankFilterChoice = 'isUnLocked',
}

--- list of not complete and not LockedBySkillRank
---@return table
function SkillRankMonitoring.getStatisticForNotCompleteAndNotLocked()
    local info = {}
    local all_info = {
        [0] = 0,
        [1] = 0,
        [2] = 0,
    }
    local skillTypes = { SKILL_TYPE_CLASS, SKILL_TYPE_AVA, SKILL_TYPE_WEAPON, SKILL_TYPE_WORLD, SKILL_TYPE_GUILD, SKILL_TYPE_ARMOR }
    for _, skillType in pairs(skillTypes) do
        local type_info = {
            [0] = 0,
            [1] = 0,
            [2] = 0,
        }
        local abilityIdList = SkillRankMonitoring.getAllSavedAbilitiesList({ skillType })
        for _, abilityId in pairs(abilityIdList) do
            if abilityId > 0 then
                local aI = SkillRankMonitoring.getAbilityInfo(abilityId);
                if aI then
                    --[[
                                        --_morphChoice_ = _morphChoice_,
                                        -- isUltimate = isUltimate,
                                        -- isLockedBySkillRank = isLockedBySkillRank,
                                        -- isComplete = isComplete,
                    ]]
                    if aI.isComplete == false and aI.isLockedBySkillRank == false then
                        -- нужны только не завершенные и не залоченные
                        all_info[aI._morphChoice_] = all_info[aI._morphChoice_] + 1
                        type_info[aI._morphChoice_] = type_info[aI._morphChoice_] + 1
                    end
                end
            end
        end
        info[skillType] = type_info
    end
    info["all"] = all_info
    return info
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