local SRM_statisticWindowClass = ZO_SortFilterList:Subclass()
SRM_statisticWindowClass.defaults = {}

local statisticUnitList = nil
--- @type CharacterStatisticInfoClass[]
local statisticListUnits = {}

SRM_statisticWindowClass.SORT_KEYS = {
    ["Index"] = {},
    ["CharacterName"] = { tiebreaker = "Index" },
    ["IsCharacterProgressComplete"] = { tiebreaker = "Index" },
    ["SkillPointsCount"] = { tiebreaker = "Index" },
    ["AllAbilityStatus"] = { tiebreaker = "Index" },
    ["ClassAbilityStatus"] = { tiebreaker = "Index" },
    ["WeaponAbilityStatus"] = { tiebreaker = "Index" },
    ["GuildAbilityStatus"] = { tiebreaker = "Index" },
    ["ArmorAbilityStatus"] = { tiebreaker = "Index" },
    ["AvAAbilityStatus"] = { tiebreaker = "Index" },
    ["WorldAbilityStatus"] = { tiebreaker = "Index" },
}

function SRM_statisticWindowClass:New()
    local units = ZO_SortFilterList.New(self, SRM_StatisticWindow)
    return units
end

function SRM_statisticWindowClass:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)

    self.sortHeaderGroup:SelectHeaderByKey("AllAbilityStatus")

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

---ColorRow
---@param control any
---@param data hotBarAbilityDataRow
---@param mouseIsOver boolean
function SRM_statisticWindowClass:ColorRow(control, data, mouseIsOver)
    local CharacterName = ZO_CachedStrFormat(SI_UNIT_NAME, GetUnitName("player"))
    for i = 1, control:GetNumChildren() do
        local child = control:GetChild(i)
        if child and child:GetType() == CT_LABEL then
            if data.CharacterName == CharacterName then
                child:SetColor(SkillRankMonitoring:getSelectedTextColor():UnpackRGBA())
            else
                child:SetColor(SkillRankMonitoring:getNormalTextColor():UnpackRGBA())
            end
        end
    end
end

function SRM_statisticWindowClass:BuildMasterList()
    self.masterList = {}
    local units = statisticListUnits
    for _, data in pairs(units) do
        table.insert(self.masterList, data)
    end
end

function SRM_statisticWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        ---@type CharacterStatisticInfoClass
        local data = self.masterList[i]
        if data:IsCompleteFiltration(SkillRankMonitoring.IsCompleteChoice) then
            table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
        end
    end
end

function SRM_statisticWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

---SetupUnitRow
---@param control any
---@param data CharacterStatisticInfoClass
function SRM_statisticWindowClass:SetupUnitRow(control, data)

    control.data = data

    control.CharacterName = GetControl(control, "CharacterName")
    control.CharacterName:SetText(data.CharacterName)
    control.CharacterName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

    control.SkillPointsCount = GetControl(control, "SkillPointsCount")
    control.SkillPointsCount:SetText(data.SkillPointsCount)
    control.SkillPointsCount:SetHorizontalAlignment(TEXT_ALIGN_CENTER)

    control.IsCharacterProgressComplete = GetControl(control, "IsCharacterProgressComplete")
    control.IsCharacterProgressComplete:SetText(data.IsCharacterProgressCompleteText)
    control.IsCharacterProgressComplete:SetHorizontalAlignment(TEXT_ALIGN_CENTER)

    control.AllAbilityStatus = GetControl(control, "AllAbilityStatus")
    control.AllAbilityStatus:SetText(data.AllAbilityStatusText)
    control.AllAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.ClassAbilityStatus = GetControl(control, "ClassAbilityStatus")
    control.ClassAbilityStatus:SetText(data.ClassAbilityStatusText)
    control.ClassAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.WeaponAbilityStatus = GetControl(control, "WeaponAbilityStatus")
    control.WeaponAbilityStatus:SetText(data.WeaponAbilityStatusText)
    control.WeaponAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.GuildAbilityStatus = GetControl(control, "GuildAbilityStatus")
    control.GuildAbilityStatus:SetText(data.GuildAbilityStatusText)
    control.GuildAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.ArmorAbilityStatus = GetControl(control, "ArmorAbilityStatus")
    control.ArmorAbilityStatus:SetText(data.ArmorAbilityStatusText)
    control.ArmorAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.AvAAbilityStatus = GetControl(control, "AvAAbilityStatus")
    control.AvAAbilityStatus:SetText(data.AvAAbilityStatusText)
    control.AvAAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    control.WorldAbilityStatus = GetControl(control, "WorldAbilityStatus")
    control.WorldAbilityStatus:SetText(data.WorldAbilityStatusText)
    control.WorldAbilityStatus:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

    ZO_SortFilterList.SetupRow(self, control, data)
end

local function createDropdownIsComplete()
    local validChoices = {
        'all',
        'Yes',
        'No',
    }
    SRM_StatisticWindow_IsComplete.comboBox = SRM_StatisticWindow_IsComplete.comboBox or ZO_ComboBox_ObjectFromContainer(SRM_StatisticWindow_IsComplete)
    local comboBox = SRM_StatisticWindow_IsComplete.comboBox
    local function OnItemSelect(_, choiceText, choice)
        SkillRankMonitoring.IsCompleteChoice = choiceText
        statisticUnitList:RefreshData()
    end
    comboBox:SetSortsItems(false)
    for i = 1, #validChoices do
        local entry = comboBox:CreateItemEntry(validChoices[i], OnItemSelect)
        comboBox:AddItem(entry)
    end
    comboBox:SetSelectedItem(SkillRankMonitoring.IsCompleteChoice)
end

function SkillRankMonitoring.statisticOnLoad()
    createDropdownIsComplete()
    statisticUnitList = SRM_statisticWindowClass:New()
    statisticListUnits = {}
    statisticUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(SRM_StatisticWindow)
    SkillRankMonitoring.LoadControlLocation(SRM_StatisticWindow)
    SRM_StatisticWindow:SetHidden(true)
end

function SkillRankMonitoring.showStatisticWindow()
    SRM_StatisticWindow:SetHidden(true)
    statisticListUnits = SkillRankMonitoring.prepareFormatedStatisticInfo()
    statisticUnitList:RefreshData()
    SkillRankMonitoring.LoadControlLocation(SRM_StatisticWindow)
    SRM_StatisticWindow:SetHidden(false)
end

SLASH_COMMANDS["/srm_show_statistic_window"] = function()
    SkillRankMonitoring.showStatisticWindow()
end

function SkillRankMonitoring.toggleStatisticWindow()
    if SRM_StatisticWindow:IsHidden() then
        SRM_OnHotbarWindow:SetHidden(true)
        SkillRankMonitoring.showStatisticWindow()
    else
        SRM_StatisticWindow:SetHidden(true)
    end
end

