-- https://wiki.esoui.com/GetUnitClassId

for i = 1, GetNumClasses() do
    local classId = GetClassInfo(i)
    local classNameMale = zo_strformat(SI_CLASS_NAME, GetClassName(GENDER_MALE , classId ))
    local classNameFemale = zo_strformat(SI_CLASS_NAME, GetClassName(GENDER_FEMALE, classId ))
    d(string.format("ClassName male/female: %s/%s", classNameMale , classNameFemale))
end

-- https://wiki.esoui.com/How_to_determine_%26_get_class_skill_lines

local classSkillLines = {
    [1] = {35,36,37},    -- Dragonknight
    [2] = {41,42,43},    -- Sorcerer
    [3] = {38,39,40},    -- Nightblade
    [4] = {127,128,129}, -- Warden
    [5] = {131,132,133}, -- Necromancer
    [6] = {22,27,28},    -- Templar
}

--* GetSkillLineNameById(*integer* _skillLineId_)
--** _Returns:_ *string* _name_

--* GetSkillLineDetailedIconById(*integer* _skillLineId_)
--** _Returns:_ *textureName* _detailedIcon_

--* GetSkillLineId(*[SkillType|#SkillType]* _skillType_, *luaindex* _skillLineIndex_)
--** _Returns:_ *integer* _skillLineId_

--* GetSkillLineUnlockTextById(*integer* _skillLineId_)
--** _Returns:_ *string* _unlockText_
