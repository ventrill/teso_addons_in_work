local SRM = SkillRankMonitoring

SRM_statisticWindowClass = ZO_SortFilterList:Subclass()
SRM_statisticWindowClass.defaults = {}

SRM.statisticUnitList = nil
SRM.statisticListUnits = {}

SRM_statisticWindowClass.SORT_KEYS = {
    ["CharacterName"] = {},
    ["SkillPointsCount"] = { tiebreaker = "CharacterName" },
    ["AllAbilityStatus"] = { tiebreaker = "CharacterName" },
    ["ClassAbilityStatus"] = { tiebreaker = "CharacterName" },
    ["WeaponAbilityStatus"] = { tiebreaker = "CharacterName" },
    ["GuildAbilityStatus"] = { tiebreaker = "CharacterName" },
    ["ArmorAbilityStatus"] = { tiebreaker = "CharacterName" },
    ["AvAAbilityStatus"] = { tiebreaker = "CharacterName" },
    ["WorldAbilityStatus"] = { tiebreaker = "CharacterName" },
}

function SRM_statisticWindowClass:New()
    local units = ZO_SortFilterList.New(self, SRM_StatisticWindow)
    return units
end

function SRM_statisticWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    --self.sortHeaderGroup:SelectHeaderByKey("CharacterName")

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "SRM_StatisticWindowUnitRow", 30, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, SRM_statisticWindowClass.SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function SRM_statisticWindowClass:BuildMasterList()
    self.masterList = {}
    local units = SRM.statisticListUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function SRM_statisticWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function SRM_statisticWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function SRM_statisticWindowClass:SetupUnitRow(control, data)

    control.data = data
    d("data", data)

    --control.CharacterName = GetControl(control, "CharacterName")
    --control.CharacterName:SetText(data.characterName)
    --control.CharacterName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
    --
    --control.SkillPointsCount = GetControl(control, "SkillPointsCount")
    --control.SkillPointsCount:SetText(data.skillPointsCount)
    --control.SkillPointsCount:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    --
    --local all = data['all'];
    --local v0 = all[MORPH_SLOT_BASE] or 0
    --local string = string.format("%s / %s / %s", v0, all[MORPH_SLOT_MORPH_1], all[MORPH_SLOT_MORPH_2])
    --control.AllAbilityStatus = GetControl(control, "AllAbilityStatus")
    --control.AllAbilityStatus:SetText(string)
    --control.AllAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    --control.ClassAbilityStatus = GetControl(control, "ClassAbilityStatus")
    --control.ClassAbilityStatus:SetText(data.ClassAbilityStatus)
    --control.ClassAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    --control.WeaponAbilityStatus = GetControl(control, "WeaponAbilityStatus")
    --control.WeaponAbilityStatus:SetText(data.WeaponAbilityStatus)
    --control.WeaponAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    --control.GuildAbilityStatus = GetControl(control, "GuildAbilityStatus")
    --control.GuildAbilityStatus:SetText(data.GuildAbilityStatus)
    --control.GuildAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    --control.ArmorAbilityStatus = GetControl(control, "ArmorAbilityStatus")
    --control.ArmorAbilityStatus:SetText(data.ArmorAbilityStatus)
    --control.ArmorAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    --control.AvAAbilityStatus = GetControl(control, "AvAAbilityStatus")
    --control.AvAAbilityStatus:SetText(data.AvAAbilityStatus)
    --control.AvAAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    --control.WorldAbilityStatus = GetControl(control, "WorldAbilityStatus")
    --control.WorldAbilityStatus:SetText(data.WorldAbilityStatus)
    --control.WorldAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

function SRM.statisticOnLoad()
    SRM.statisticUnitList = SRM_statisticWindowClass:New()
    SRM.statisticListUnits = {}
    SRM.statisticUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(SRM_StatisticWindow)
    SRM_StatisticWindow:SetHidden(true)
end

function SkillRankMonitoring.showStatisticWindow()
    SRM_StatisticWindow:SetHidden(true)
    SRM.statisticListUnits = SRM.prepareStatisticInfo()
    SRM.statisticUnitList:RefreshData()
    SRM_StatisticWindow:SetHidden(false)
end

SLASH_COMMANDS["/srm_show_statistic_window"] = function()
    SRM.showStatisticWindow()
end

function SkillRankMonitoring.toggleStatisticWindow()
    if SRM_StatisticWindow:IsHidden() then
        SRM.showStatisticWindow()
    else
        SRM_StatisticWindow:SetHidden(true)
    end
end

