local progression = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId(abilityId)
if not progression then return end

local skillType, skillLine, skillIndex = GetSpecificSkillAbilityKeysByAbilityId(progression:GetAbilityId())


