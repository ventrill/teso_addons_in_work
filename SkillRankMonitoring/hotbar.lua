local SRM = SkillRankMonitoring


SRM_hotbarAbilityListWindowClass = ZO_SortFilterList:Subclass()
SRM_hotbarAbilityListWindowClass.defaults = {}

SRM.hotbarAbilityListUnitList = nil
SRM.hotbarAbilityListUnits = {}

SRM_hotbarAbilityListWindowClass.SORT_KEYS = {
    ["AbilityName"] = {},
    ["AbilityRank"] = { tiebreaker = "AbilityName" },
    ["TotalExp"] = { tiebreaker = "AbilityName" },
    ["CurrentXP"] = { tiebreaker = "AbilityName" },
    ["LeftExp"] = { tiebreaker = "AbilityName" },
}

function SRM_hotbarAbilityListWindowClass:New()
    local units = ZO_SortFilterList.New(self, SRM_OnHotbarWindow)
    return units
end

function SRM_hotbarAbilityListWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("LeftExp")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "SRM_OnHotbarWindowUnitRow", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, SRM_hotbarAbilityListWindowClass.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function SRM_hotbarAbilityListWindowClass:BuildMasterList()
    self.masterList = {}
    local units = SRM.hotbarAbilityListUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function SRM_hotbarAbilityListWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function SRM_hotbarAbilityListWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function SRM_hotbarAbilityListWindowClass:SetupUnitRow(control, data)

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
    control.CurrentXP:SetText(SkillRankMonitoring.formatExp(data.CurrentXP))
    control.CurrentXP:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.LeftExp = GetControl(control, "LeftExp")
    control.LeftExp:SetText(SkillRankMonitoring.formatExp(data.LeftExp))
    control.LeftExp:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.TotalExp = GetControl(control, "TotalExp")
    control.TotalExp:SetText(SkillRankMonitoring.formatExp(data.TotalExp))
    control.TotalExp:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

function SRM.hotBarAbilityListOnLoad()
    SRM.hotbarAbilityListUnitList = SRM_hotbarAbilityListWindowClass:New()
    SRM.hotbarAbilityListUnits = {}
    SRM.hotbarAbilityListUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(SRM_OnHotbarWindow)
    SRM_OnHotbarWindow:SetHidden(true)
end

function SkillRankMonitoring.showHotBarInfo()
    SRM_OnHotbarWindow:SetHidden(true)
    SRM.hotbarAbilityListUnits = SRM.prepareHotBarInfo()
    SRM.hotbarAbilityListUnitList:RefreshData()
    SRM_OnHotbarWindow:SetHidden(false)
end

SLASH_COMMANDS["/srm_show_hotbar_info"] = function()
    SRM.showHotBarInfo()
end

function SkillRankMonitoring.toggleHotbarWindow()
    if SRM_OnHotbarWindow:IsHidden() then
        --d('hotbar window closed')
        SRM.showHotBarInfo()
    else
        --d('hotbar window open')
        SRM_OnHotbarWindow:SetHidden(true)
    end
    --SRM_OnHotbarWindow:ToggleHidden()
end

