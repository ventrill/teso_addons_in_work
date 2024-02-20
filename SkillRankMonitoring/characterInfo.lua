function SkillRankMonitoring.getCharacterInfo()
    local abilityInfo = SkillRankMonitoring.getStatisticForNotCompleteAndNotLocked()
    local characterId = GetCurrentCharacterId()
    local characterName = ZO_CachedStrFormat(SI_UNIT_NAME, GetUnitName("player"))
    local skillPointsCount = 44

    return {
        abilityInfo = abilityInfo,
        characterId = characterId,
        characterName = characterName,
        skillPointsCount = skillPointsCount,
    }
end

function SkillRankMonitoring.getCharacterInfoOnLoad()
    local info = SkillRankMonitoring.getCharacterInfo()
    SkillRankMonitoring.savedVars.CharactersProgress[info["characterId"]] = info
end

function prepareStatisticInfo()
    local info = SkillRankMonitoring.savedVars.CharactersProgress
    return info;
end
-- local CS = CraftStoreFixedAndImprovedLongClassName
--[[
GetAvailableSkillPoints()
local availablePoints = SKILL_POINT_ALLOCATION_MANAGER:GetAvailableSkillPoints()


function CS.GetTotalSpentSkillPoints()
    local count = 0
    for _, skillTypeData in SKILLS_DATA_MANAGER:SkillTypeIterator() do
        for _, skillLineData in skillTypeData:SkillLineIterator() do
            count = count + SKILL_POINT_ALLOCATION_MANAGER:GetNumPointsAllocatedInSkillLine(skillLineData)
        end
    end
    return count
end
]]

-- char list
--[[
for i = 1, GetNumCharacters() do
    local name, _, _, _, _, _, _ = GetCharacterInfo(i)
    charName = name
    charName = zo_strformat(SI_UNIT_NAME, charName)
    if GetUnitName("player") == name and FCOItemSaver_Settings[serverWorldName][displayName][charName] then
        doMove = true
        break -- exit the loop
    end
end
]]
