local skillTypeList = {
    SKILL_TYPE_CLASS,
    SKILL_TYPE_WEAPON,
    SKILL_TYPE_GUILD,
    SKILL_TYPE_ARMOR,
    SKILL_TYPE_AVA,
    SKILL_TYPE_WORLD,
}
--statistic
local windowName = 'SRM_OnHotbarWindow'
local unitRow = 'SRM_OnHotbarWindowUnitRow'
local infoRow = {
    'charId',
    m0_not_comp_all = 'not_complete_count',
    m0_locked_all = 'not_complete_count',

    m1_all = 'not_complete_count',
    m2_all = 'not_complete_count',
    m0_class = 'not_complete_count',
    m1_class = 'not_complete_count',
    m2_class = 'not_complete_count',
}

--hotbar
local windowName = 'SRM_OnHotbarWindow'
local unitRow = 'SRM_OnHotbarWindowUnitRow'

-- abilityList
local windowName = 'SRM_ListWindow'
local unitRow = 'SRM_ListWindowUnitRow'

local abilityInfoRow = {
    Icon = 'Icon',
    TotalExp = 'totalExp',
    abilityId = 'abilityId',
    AbilityName = 'abilityName',
    AbilityRank = 'rank',
    CurrentXP = 'currentXP',
    LeftExp = 'leftExp',
    isComplete = 'isComplete',
}
local panelInfoRow = {
    'Icon', -- 32
    'AbilityName', -- 300
    'AbilityRank', -- 75
    'TotalExp', -- 150
    'CurrentXP', -- 150
    'LeftExp', -- 150
}