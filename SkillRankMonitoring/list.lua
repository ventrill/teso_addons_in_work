local SRM = SkillRankMonitoring

function SkillRankMonitoring.toggleListWindow()
    SRM_ListWindow:ToggleHidden()
end

SRM_abilityListWindowClass = ZO_SortFilterList:Subclass()
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
    SRM.debug("SRM_abilityListWindowObject:FilterScrollList")
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
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

    --control.AbilityRank = GetControl(control, "AbilityRank")
    --control.AbilityRank:SetText(data.AbilityRank)
    --control.AbilityRank:SetHorizontalAlignment(TEXT_ALIGN_CENTER)

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

function SRM.abilityListOnLoad()
    SRM.abilityListUnitList = SRM_abilityListWindowClass:New()
    SRM.abilityListUnits = {}
    SRM.abilityListUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(SRM_ListWindow)
    SRM_ListWindow:SetHidden(true)
end

function SkillRankMonitoring.showClassInfo()
    SRM_ListWindow:SetHidden(true)
    SRM.abilityListUnits = SRM.getClassAbility()
    SRM.abilityListUnitList:RefreshData()
    SRM_ListWindow:SetHidden(false)
end

function SkillRankMonitoring.showAVAInfo()
    SRM_ListWindow:SetHidden(true)
    SRM.abilityListUnits = SRM.getAVAAbility()
    SRM.abilityListUnitList:RefreshData()
    SRM_ListWindow:SetHidden(false)
end
function SkillRankMonitoring.InfoByAll()
    SRM_ListWindow:SetHidden(true)
    SRM.abilityListUnits = SRM.prepareInfoByAll()
    SRM.abilityListUnitList:RefreshData()
    SRM_ListWindow:SetHidden(false)
end
function SkillRankMonitoring.InfoBySkillType(skillType)
    SRM_ListWindow:SetHidden(true)
    SRM.abilityListUnits = SRM.prepareInfoBySkillType(skillType)
    SRM.abilityListUnitList:RefreshData()
    SRM_ListWindow:SetHidden(false)
end

SLASH_COMMANDS["/srm_show_panel_info"] = function()
    SRM.showHotBarInfo()
end

SLASH_COMMANDS["/srm_show_class_info"] = function()
    SkillRankMonitoring.showClassInfo()
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


