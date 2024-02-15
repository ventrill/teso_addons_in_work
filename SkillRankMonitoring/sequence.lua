local function getSkillLinesBySkillTypeType(skill_type)
    local skill_lines = {}
    for i = 1, GetNumSkillLines(skill_type) do
        local _skillLineId_ = GetSkillLineId(skill_type, i)
        table.insert(skill_lines, _skillLineId_)
    end
    return skill_lines;
end


local function formatAbilityInfo(_skillType_, _skillLineIndex_, _skillIndex_)
    --* GetSkillAbilityInfo(*[SkillType|#SkillType]* _skillType_, *luaindex* _skillLineIndex_, *luaindex* _skillIndex_)
    --** _Returns:_ *string* _name_, *textureName* _texture_, *luaindex* _earnedRank_, *bool* _passive_, *bool* _ultimate_, *bool* _purchased_, *luaindex:nilable* _progressionIndex_, *integer* _rank_

    local _name_, _texture_, _earnedRank_, _passive_, _ultimate_, _purchased_, _progressionIndex_, _rank_ = GetSkillAbilityInfo(_skillType_, _skillLineIndex_, _skillIndex_)

    if _passive_ then
        return nil
    end

    local currentXP=0
    local leftExp=0
    local isComplete=false
    local totalExp = 0
    if _progressionIndex_ then
        totalExp = getTotalExp()
    end

    return{
        Icon = _texture_,
        TotalExp = 'totalExp',
        abilityId = 'abilityId',
        AbilityName = _name_, -- 300
        AbilityRank = rank, -- 75
        CurrentXP = currentXP, -- 150
        LeftExp = leftExp, -- 150
        isComplete = isComplete,
    }
end

local function getAbilityList()
    -- class ability (active+ultimate) SKILL_TYPE_CLASS
    -- weapon ability (active+ultimate) SKILL_TYPE_WEAPON
    -- ? SKILL_TYPE_ARMOR, SKILL_TYPE_WORLD, SKILL_TYPE_GUILD, SKILL_TYPE_AVA

    local classTypes = { SKILL_TYPE_CLASS, SKILL_TYPE_WEAPON }
    for _, _skillType_ in pairs(classTypes) do
        for _skillLineIndex_ = 1, GetNumSkillLines(_skillType_) do
            for _skillIndex_ = 1, GetNumSkillAbilities(_skillType_, _skillLineIndex_) do
                local infoTable = formatAbilityInfo(_skillType_, _skillLineIndex_, _skillIndex_)
            end

        end

    end


end