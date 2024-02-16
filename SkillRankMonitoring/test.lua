local progression = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId(abilityId)
if not progression then return end

local skillType, skillLine, skillIndex = GetSpecificSkillAbilityKeysByAbilityId(progression:GetAbilityId())

-- todo need check
local function GetBaseAbilityId(abilityId)
    if abilityId == 0 then
        return 0
    end
    local playerSkillProgressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId(abilityId)
    if not playerSkillProgressionData then
        return nil
    end
    local baseMorphData = playerSkillProgressionData:GetSkillData():GetMorphData(MORPH_SLOT_BASE)
    return baseMorphData:GetAbilityId()
end

-- todo need check
local function getMorf1(abilityId)
    if abilityId == 0 then
        return 0
    end
    local playerSkillProgressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId(abilityId)
    if not playerSkillProgressionData then
        return nil
    end
    local baseMorphData = playerSkillProgressionData:GetSkillData():GetMorphData(MORPH_SLOT_MORPH_1)
    return baseMorphData:GetAbilityId()
end

-- todo need check
local function getMorf2(abilityId)
    if abilityId == 0 then
        return 0
    end
    local playerSkillProgressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId(MORPH_SLOT_MORPH_2)
    if not playerSkillProgressionData then
        return nil
    end
    local baseMorphData = playerSkillProgressionData:GetSkillData():GetMorphData(MORPH_SLOT_BASE)
    return baseMorphData:GetAbilityId()
end

-- SKILLS_DATA_MANAGER is the object of the class ZO_SkillsDataManager, see above

-- todo нужен текущий морф абилки


-- local  texName = GetAbilityIcon(abilityId)
-- trace ('Ability texture: %s', texName)



-- local function createInventoryDropdown()
-- local function createInventoryDropdownQuality()


-- <Control name="RDL_DropdownMajor" inherits="ZO_ScrollableComboBox" mouseEnabled="true" >
-- local function createInventoryDropdown(dropdownName)