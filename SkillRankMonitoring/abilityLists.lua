local ABILITY_TYPE_ULTIMATE = 0
local ABILITY_TYPE_ACTIVE = 1
local ABILITY_TYPE_PASSIVE = 2

function SkillRankMonitoring.getSavedAbilitiesList(skillType)
    local abilityList = {}

    local list = LibSkillsFactory.skillFactory[skillType]
    local lineCount = LibSkillsFactory:GetNumSkillLinesPerChar(skillType)
    for i = 1, lineCount do
        local abilityCount = LibSkillsFactory:GetNumSkillAbilities(skillType, i)
        for index = 1, abilityCount do
            local line = list[i][index]
            if line.at == ABILITY_TYPE_ULTIMATE and line.skillPool then
                for _, item in pairs(line.skillPool) do
                    table.insert(abilityList, item.id)
                end
            end

            if line.at == ABILITY_TYPE_ACTIVE and line.skillPool then
                for _, item in pairs(line.skillPool) do
                    table.insert(abilityList, item.id)
                end
            end
        end
    end

    return abilityList
end

function SkillRankMonitoring.getAllSavedAbilitiesList()
    local abilityList = {}
    local skillTypes = { SKILL_TYPE_CLASS, SKILL_TYPE_AVA, SKILL_TYPE_WEAPON, SKILL_TYPE_WORLD, SKILL_TYPE_GUILD, SKILL_TYPE_ARMOR }
    for _, skillType in pairs(skillTypes) do
        local list = LibSkillsFactory.skillFactory[skillType]
        local lineCount = LibSkillsFactory:GetNumSkillLinesPerChar(skillType)
        for lineIndex = 1, lineCount do
            if list[lineIndex]['skillLineId'] == 50 or list[lineIndex]['skillLineId'] == 51 then
                d(string.format("id %s name %s", list[lineIndex]['skillLineId'],GetSkillLineNameById(list[lineIndex]['skillLineId'])))
            else

                local abilityCount = LibSkillsFactory:GetNumSkillAbilities(skillType, lineIndex)
                for abilityIndex = 1, abilityCount do
                    local line = list[lineIndex][abilityIndex]
                    if line.at == ABILITY_TYPE_ULTIMATE and line.skillPool then
                        for _, item in pairs(line.skillPool) do
                            table.insert(abilityList, item.id)
                        end
                    end
                    if line.at == ABILITY_TYPE_ACTIVE and line.skillPool then
                        for _, item in pairs(line.skillPool) do
                            table.insert(abilityList, item.id)
                        end
                    end
                end

            end
        end

    end

    return abilityList
end

