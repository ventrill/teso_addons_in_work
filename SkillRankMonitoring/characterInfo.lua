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

-- /script d(SkillRankMonitoring.savedVars.charactersProgress)
-- /script d(SkillRankMonitoring.getCharacterInfo())
-- /script SkillRankMonitoring.updateCharacterStatisticOnLoad()
function SkillRankMonitoring.updateCharacterStatisticOnLoad()
    local info = SkillRankMonitoring.getCharacterInfo()
    local charId = GetCurrentCharacterId()
    SkillRankMonitoring.savedVars.charactersProgress[charId] = {}
    for i, v in pairs(info) do
        SkillRankMonitoring.savedVars.charactersProgress[charId][i] = v
    end
end

-- /script d(SkillRankMonitoring.savedVars.charactersProgress)
-- /script d(SkillRankMonitoring.prepareStatisticInfo())
function SkillRankMonitoring.prepareStatisticInfo()
    local progress = SkillRankMonitoring.savedVars.charactersProgress
    local info = {}
    for _, data in pairs(progress) do
        table.insert(info, {
            CharacterName = data.characterName,
            SkillPointsCount = data.skillPointsCount,
            AbilityTable = data.abilityInfo
        })

    end
    return info
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
