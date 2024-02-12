local SDM = SkillDevelopmentMonitoring

local infoLine = {
    icon = '',
    skillName = 'name1',
    totalExp = 158000,
    currentExp = 6000,
    leftExp = 152000,
}

local function test1()

    -- try get ability for active panel

    --local hotbarData=ACTION_BAR_ASSIGNMENT_MANAGER:GetHotbar(hotbarCategory or GetActiveWeaponPairInfo()-1)
    -- ACTION_BAR_ASSIGNMENT_MANAGER:GetCurrentHotbar()

    local skillTable = {}

    for hotbarCategory = 0, 1 do
        --skillTable[ hotbarCategory ] = {}
        for slotIndex = 3, 8 do
            local hotbarData = ACTION_BAR_ASSIGNMENT_MANAGER:GetHotbar( hotbarCategory )
            local slotData = hotbarData:GetSlotData( slotIndex )
            -- d('slotData', slotData)
            local abilityId = 0
            -- Cant save cryptcanons special ult.
            if slotData.abilityId == 195031 then
                abilityId = slotData.abilityId
            elseif
            not slotData:IsEmpty() then -- check if there is even a spell
                abilityId = slotData:GetEffectiveAbilityId()
                table.insert(skillTable, abilityId)
            end
        end
    end

    d(skillTable)
    return skillTable
end

local function GetBaseAbilityId(abilityId)
    if abilityId == 0 then return 0 end
    local playerSkillProgressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId( abilityId )
    if not playerSkillProgressionData then
        return nil
    end
    local baseMorphData = playerSkillProgressionData:GetSkillData():GetMorphData( MORPH_SLOT_BASE )
    return baseMorphData:GetAbilityId()
end

local function getMorf1(abilityId)
    if abilityId == 0 then return 0 end
    local playerSkillProgressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId( abilityId )
    if not playerSkillProgressionData then
        return nil
    end
    local baseMorphData = playerSkillProgressionData:GetSkillData():GetMorphData( MORPH_SLOT_MORPH_1 )
    return baseMorphData:GetAbilityId()

end

local function getMorf2(abilityId)
    if abilityId == 0 then return 0 end
    local playerSkillProgressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId( MORPH_SLOT_MORPH_2 )
    if not playerSkillProgressionData then
        return nil
    end
    local baseMorphData = playerSkillProgressionData:GetSkillData():GetMorphData( MORPH_SLOT_BASE )
    return baseMorphData:GetAbilityId()
end


-- ability name
local function showInfo(abilityId)
    d(abilityId)
    local progressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId( abilityId )
    if not progressionData then
        d('no progressionData')
        return
    end
    local abilityName = zo_strformat( "<<C:1>>", progressionData:GetName() )
    d(abilityName)
    local rank = progressionData:GetCurrentRank()
    d('rank', rank)
    local startXP, endXP = progressionData:GetRankXPExtents(rank)
    local currentXP = progressionData:GetCurrentXP()
    d(startXP, endXP, currentXP)

end


SLASH_COMMANDS["/sdm_test1"] = function()
    local skillTable = test1()
    for i = 1, #skillTable do
        showInfo(skillTable[i])
    end
end

SLASH_COMMANDS["/sdm_test2"] = function()
    --local abilityId = 40076
    --local abilityId = 40103
    --local abilityId = 40130
    --local abilityId = 40116
    -- local abilityId = 46348
    local abilityId = 83850
    local progressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId( abilityId )
    if progressionData
            and progressionData:GetSkillData() then
        d(progressionData:GetSkillData())
    end


        --showInfo(abilityId)
    --local b = GetBaseAbilityId(abilityId)
    --if b then
    --    showInfo(b)
    --end
    --local m1 = getMorf1(abilityId)
    --if m1 then
    --    showInfo(m1)
    --end
    --local m2 = getMorf2(abilityId)
    --if m2 then
    --    showInfo(m2)
    --end



end



