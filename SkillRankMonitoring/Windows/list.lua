local SRM = SkillRankMonitoring

function SkillRankMonitoring.toggleListWindow()
    SRM_ListWindow:ToggleHidden()
end

local SRM_abilityListWindowClass = ZO_SortFilterList:Subclass()
SRM_abilityListWindowClass.defaults = {}

SRM.abilityListUnitList = nil
SRM.abilityListUnits = {}

SRM_abilityListWindowClass.SORT_KEYS = {
    ["AbilityName"] = {},
    ["AbilityRank"] = { tiebreaker = "AbilityName" },
    ["TotalExp"] = { tiebreaker = "AbilityName" },
    ["CurrentXP"] = { tiebreaker = "AbilityName" },
    ["LeftExp"] = { tiebreaker = "AbilityName" },
}

function SRM_abilityListWindowClass:New()
    local units = ZO_SortFilterList.New(self, SRM_ListWindow)
    return units
end

function SRM_abilityListWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("LeftExp")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "SRM_ListWindowUnitRow", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, SRM_abilityListWindowClass.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function SRM_abilityListWindowClass:BuildMasterList()
    --SRM.debug('SRM_abilityListWindowObject:BuildMasterList')
    self.masterList = {}
    local units = SRM.abilityListUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function SRM_abilityListWindowClass:FilterScrollList()

    local function checkByIsPurchased(data)
        local saved = SRM.IsPurchasedChoice
        if saved == 'all' then
            return true
        end
        if saved == 'Yes' and data.purchased == true then
            return true
        end
        if saved == 'No' and data.purchased == false then
            return true
        end
        return false
    end

    ---checkByMorph
    ---@param data table
    ---@return boolean
    local function checkByMorph(data)
        local saved = SRM.MorphChoice
        if saved == 'all' then
            return true
        end
        if saved == 'm0' and data._morphChoice_ == MORPH_SLOT_BASE then
            return true
        end
        if saved == 'm1' and data._morphChoice_ == MORPH_SLOT_MORPH_1 then
            return true
        end
        if saved == 'm2' and data._morphChoice_ == MORPH_SLOT_MORPH_2 then
            return true
        end
        return false
    end

    ---checkByStepFilter
    ---@param data table
    ---@return boolean
    local function checkByStepFilter(data)
        local saved = SRM.StepFilterChoice
        if saved == 'all' then
            return true
        end
        if saved == 'not_start' and data.CurrentXP == 0 then
            return true
        end
        if saved == 'in_process' and data.CurrentXP > 0 and data.isComplete == false then
            return true
        end
        if saved == 'is_complete' and data.isComplete == true then
            return true
        end
        if saved == 'not_complete' and data.isComplete == false then
            return true
        end
        return false
    end

    ---checkIsUltimate
    ---@param data table
    ---@return boolean
    local function checkIsUltimate(data)
        local saved = SRM.IsUltimateFilterChoice
        if saved == 'all' then
            return true
        end
        if saved == 'isUltimate' and data.isUltimate == true then
            return true
        end
        if saved == 'isNotUltimate' and data.isUltimate == false then
            return true
        end

        return false
    end

    ---checkIsLockedBySkillRank
    ---@param data table
    ---@return boolean
    local function checkIsLockedBySkillRank(data)
        local saved = SRM.IsLockedBySkillRankFilterChoice
        if saved == 'all' then
            return true
        end
        if saved == 'isLocked' and data.isLockedBySkillRank == true then
            return true
        end
        if saved == 'isUnLocked' and data.isLockedBySkillRank == false then
            return true
        end
        return false
    end

    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        if checkByMorph(data)
                and checkByStepFilter(data)
                and checkIsUltimate(data)
                and checkIsLockedBySkillRank(data)
                and checkByIsPurchased(data)
        then
            table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
        end
    end
end

function SRM_abilityListWindowClass:ColorRow(control, data, mouseIsOver)
    for i = 1, control:GetNumChildren() do
        local child = control:GetChild(i)
        if child and child:GetType() == CT_LABEL then
            child:SetColor(SkillRankMonitoring:getNormalTextColor():UnpackRGBA())
        end
    end
end

function SRM_abilityListWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function SRM_abilityListWindowClass:SetupUnitRow(control, data)

    control.data = data
    control.StyleIcon = GetControl(control, "StyleIcon")
    control.StyleIcon:SetTexture(data.Icon)

    if not data.AbilityRank then
        data.AbilityRank = 0
    end
    control.AbilityName = GetControl(control, "AbilityName")
    control.AbilityName:SetText(string.format("[%s] %s (%s) %s", data.AbilityRank, data._morphChoice_, data.abilityId, data.AbilityName))
    control.AbilityName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.AbilityRank = GetControl(control, "AbilityRank")
    control.AbilityRank:SetText(data.AbilityRank)
    control.AbilityRank:SetHorizontalAlignment(TEXT_ALIGN_CENTER)

    control.CurrentXP = GetControl(control, "CurrentXP")
    control.CurrentXP:SetText(SRM.formatExp(data.CurrentXP))
    control.CurrentXP:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.LeftExp = GetControl(control, "LeftExp")
    control.LeftExp:SetText(SRM.formatExp(data.LeftExp))
    control.LeftExp:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.TotalExp = GetControl(control, "TotalExp")
    control.TotalExp:SetText(SRM.formatExp(data.TotalExp))
    control.TotalExp:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

local function createDropdownIsPurchased()
    local validChoices = {
        'all',
        'Yes',
        'No',
    }
    SRM_ListWindow_IsPurchased.comboBox = SRM_ListWindow_IsPurchased.comboBox or ZO_ComboBox_ObjectFromContainer(SRM_ListWindow_IsPurchased)
    local comboBox = SRM_ListWindow_IsPurchased.comboBox
    local function OnItemSelect(_, choiceText, choice)
        SRM.IsPurchasedChoice = choiceText
        SRM.abilityListUnitList:RefreshData()
    end
    comboBox:SetSortsItems(false)
    for i = 1, #validChoices do
        local entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
        comboBox:AddItem(entry)
    end
    comboBox:SetSelectedItem(SRM.IsPurchasedChoice)
end

local function createDropdownMorph()
    local validChoices = {
        'all',
        'm0',
        'm1',
        'm2',
    }
    SRM_ListWindow_Morph.comboBox = SRM_ListWindow_Morph.comboBox or ZO_ComboBox_ObjectFromContainer(SRM_ListWindow_Morph)
    local comboBox = SRM_ListWindow_Morph.comboBox
    local function OnItemSelect(_, choiceText, choice)
        SRM.MorphChoice = choiceText
        SRM.abilityListUnitList:RefreshData()
    end
    comboBox:SetSortsItems(false)

    for i = 1, #validChoices do
        local entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
        comboBox:AddItem(entry)
    end
    comboBox:SetSelectedItem(SRM.MorphChoice)
end

local function createDropdownStep()
    local validChoices = {
        'all',
        'not_start',
        'in_process',
        'not_complete',
        'is_complete',
    }
    SRM_ListWindow_Step.comboBox = SRM_ListWindow_Step.comboBox or ZO_ComboBox_ObjectFromContainer(SRM_ListWindow_Step)
    local comboBox = SRM_ListWindow_Step.comboBox
    local function OnItemSelect(_, choiceText, choice)
        SRM.StepFilterChoice = choiceText
        SRM.abilityListUnitList:RefreshData()
    end
    comboBox:SetSortsItems(false)

    for i = 1, #validChoices do
        local entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
        comboBox:AddItem(entry)
    end
    comboBox:SetSelectedItem(SRM.StepFilterChoice)
end

local function createDropdownIsUltimate()
    local validChoices = {
        'all',
        'isUltimate',
        'isNotUltimate',
    }
    SRM_ListWindow_IsUltimate.comboBox = SRM_ListWindow_IsUltimate.comboBox or ZO_ComboBox_ObjectFromContainer(SRM_ListWindow_IsUltimate)
    local comboBox = SRM_ListWindow_IsUltimate.comboBox
    local function OnItemSelect(_, choiceText, choice)
        SRM.IsUltimateFilterChoice = choiceText
        SRM.abilityListUnitList:RefreshData()
    end
    comboBox:SetSortsItems(false)

    for i = 1, #validChoices do
        local entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
        comboBox:AddItem(entry)
    end
    comboBox:SetSelectedItem(SRM.IsUltimateFilterChoice)
end

local function createDropdownIsLockedBySkillRank()
    local validChoices = {
        'all',
        'isLocked',
        'isUnLocked',
    }
    SRM_ListWindow_IsLockedBySkillRank.comboBox = SRM_ListWindow_IsLockedBySkillRank.comboBox or ZO_ComboBox_ObjectFromContainer(SRM_ListWindow_IsLockedBySkillRank)
    local comboBox = SRM_ListWindow_IsLockedBySkillRank.comboBox
    local function OnItemSelect(_, choiceText, choice)
        SRM.IsLockedBySkillRankFilterChoice = choiceText
        SRM.abilityListUnitList:RefreshData()
    end
    comboBox:SetSortsItems(false)

    for i = 1, #validChoices do
        local entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
        comboBox:AddItem(entry)
    end
    comboBox:SetSelectedItem(SRM.IsLockedBySkillRankFilterChoice)
end

function SRM.abilityListOnLoad()
    createDropdownIsPurchased()
    createDropdownMorph()
    createDropdownStep()
    createDropdownIsUltimate()
    createDropdownIsLockedBySkillRank()
    SRM.abilityListUnitList = SRM_abilityListWindowClass:New()
    SRM.abilityListUnits = {}
    SRM.abilityListUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(SRM_ListWindow)
    SRM_ListWindow:SetHidden(true)
    SkillRankMonitoring.LoadControlLocation(SRM_ListWindow)
end


--- @deprecated
function SkillRankMonitoring.showAVAInfo()
    SRM_ListWindow:SetHidden(true)
    SkillRankMonitoring.LoadControlLocation(SRM_ListWindow)
    SRM.abilityListUnits = SRM.getAVAAbility()
    SRM.abilityListUnitList:RefreshData()
    SRM_ListWindow:SetHidden(false)
end

function SkillRankMonitoring.InfoByAll()
    SRM_ListWindow:SetHidden(true)
    SkillRankMonitoring.LoadControlLocation(SRM_ListWindow)
    SRM.abilityListUnits = SRM.prepareInfoByAll()
    SRM.abilityListUnitList:RefreshData()
    SRM_ListWindow:SetHidden(false)
end

function SkillRankMonitoring.InfoBySkillType(skillType)
    SRM_ListWindow:SetHidden(true)
    SkillRankMonitoring.LoadControlLocation(SRM_ListWindow)
    SRM.abilityListUnits = SRM.prepareInfoBySkillType(skillType)
    SRM.abilityListUnitList:RefreshData()
    SRM_ListWindow:SetHidden(false)
end

SLASH_COMMANDS["/srm_show_ava_info"] = function()
    SkillRankMonitoring.InfoBySkillType(SKILL_TYPE_AVA)
end
SLASH_COMMANDS["/srm_show_weapon_info"] = function()
    SkillRankMonitoring.InfoBySkillType(SKILL_TYPE_WEAPON)
end
SLASH_COMMANDS["/srm_show_world_info"] = function()
    SkillRankMonitoring.InfoBySkillType(SKILL_TYPE_WORLD)
end
SLASH_COMMANDS["/srm_show_guild_info"] = function()
    SkillRankMonitoring.InfoBySkillType(SKILL_TYPE_GUILD)
end
SLASH_COMMANDS["/srm_show_armor_info"] = function()
    SkillRankMonitoring.InfoBySkillType(SKILL_TYPE_ARMOR)
end
SLASH_COMMANDS["/srm_test_1"] = function()
    local abilityIds = {
        38566,
        61487,
        61511,
        61489,
        38573,
        33376,
    }
    for _, abilityId in pairs(abilityIds) do
        local _skillType_, _skillLineIndex_, _skillIndex_, _morphChoice_, _rank_ = GetSpecificSkillAbilityKeysByAbilityId(abilityId)
        local abilityName, icon, _earnedRank_ = GetSkillAbilityInfo(_skillType_, _skillLineIndex_, _skillIndex_);
        local lineRankNeededToUnlock = GetSkillAbilityLineRankNeededToUnlock(_skillType_, _skillLineIndex_, _skillIndex_)
        local line_rank = GetSkillLineDynamicInfo(_skillType_, _skillLineIndex_)
        local str = string.format("For unlock %s need line rank %s current %s", abilityName, lineRankNeededToUnlock, line_rank)
        d(str)
    end
end


