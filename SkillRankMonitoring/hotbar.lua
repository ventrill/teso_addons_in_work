local SRM = SkillRankMonitoring

local SRM_hotbarAbilityListWindowClass = ZO_SortFilterList:Subclass()
SRM_hotbarAbilityListWindowClass.defaults = {}

local hotbarAbilityListUnitList = nil

---@type HotBarAbilities|nil
local hotbarAbilityListUnits = nil

local SORT_KEYS = {
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
    ZO_ScrollList_AddDataType(self.list, 1, "SRM_OnHotbarWindowUnitRow", 32, function(control1, data)
        self:SetupUnitRow(control1, data)
    end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, SORT_KEYS, self.currentSortOrder)
    end
    self:RefreshData()
end

function SRM_hotbarAbilityListWindowClass:BuildMasterList()
    self.masterList = {}
    if hotbarAbilityListUnits then
        for i = 1, hotbarAbilityListUnits:getCount() do
            local line = hotBarAbilityDataRow:New(hotbarAbilityListUnits:get(i))
            table.insert(self.masterList, line)
        end
    end
end

function SRM_hotbarAbilityListWindowClass:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        ---@type hotBarAbilityDataRow
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function SRM_hotbarAbilityListWindowClass:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

---SetupUnitRow
---@param control any
---@param data hotBarAbilityDataRow
function SRM_hotbarAbilityListWindowClass:SetupUnitRow(control, data)

    control.data = data

    local StyleIcon = GetControl(control, "StyleIcon")
    StyleIcon:SetTexture(data.StyleIcon)

    local AbilityName = GetControl(control, "AbilityName")
    -- control.AbilityName:SetText(string.format("[%s] %s (%s) %s", data.AbilityRank, data._morphChoice_, data.abilityId, data.AbilityName))
    AbilityName:SetText(data.AbilityName)
    AbilityName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
    AbilityName:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

    local AbilityRank = GetControl(control, "AbilityRank")
    AbilityRank:SetText(data.AbilityRank)
    AbilityRank:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    AbilityRank:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

    local CurrentXP = GetControl(control, "CurrentXP")
    CurrentXP:SetText(SkillRankMonitoring.formatExp(data.CurrentXP))
    CurrentXP:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    CurrentXP:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

    local LeftExp = GetControl(control, "LeftExp")
    LeftExp:SetText(SkillRankMonitoring.formatExp(data.LeftExp))
    LeftExp:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    LeftExp:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

    local TotalExp = GetControl(control, "TotalExp")
    TotalExp:SetText(SkillRankMonitoring.formatExp(data.TotalExp))
    TotalExp:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    TotalExp:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

    ZO_SortFilterList.SetupRow(self, control, data)
end

function SRM.hotBarAbilityListOnLoad()
    hotbarAbilityListUnitList = SRM_hotbarAbilityListWindowClass:New()
    hotbarAbilityListUnits = nil
    hotbarAbilityListUnitList:RefreshData()
    SCENE_MANAGER:ToggleTopLevel(SRM_OnHotbarWindow)
    SRM_OnHotbarWindow:SetHidden(true)
end

function SkillRankMonitoring.showHotBarInfo()
    SRM_OnHotbarWindow:SetHidden(true)
    hotbarAbilityListUnits = SkillRankMonitoring:getHotBarAbilities()
    hotbarAbilityListUnitList:RefreshData()
    SRM_OnHotbarWindow:SetHidden(false)
end

SLASH_COMMANDS["/srm_show_hotbar_info"] = function()
    SRM.showHotBarInfo()
end

SLASH_COMMANDS["/srm_char_info_debug"] = function()
    --local characterId = GetCurrentCharacterId()
    --if not CHAR_INFO_CLASS then
    --    d("no CHAR_INFO_CLASS")
    --    return
    --end
    --local info = CHAR_INFO_CLASS:New(characterId)
    --d(string.format("Char Name %s", info:GetName()))

    for characterId, isComplete in pairs(SkillRankMonitoring.savedVars.isCharacterProgressComplete) do
        local info = CHAR_INFO_CLASS:New(characterId)
        local isC = 'no'
        if isComplete then
            isC = 'yes'
        end

        d(string.format("Char Name %s is complite %s", info:GetName(), isC))
    end
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

