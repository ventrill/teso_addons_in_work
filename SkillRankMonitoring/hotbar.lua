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

---ColorRow
---@param control any
---@param data hotBarAbilityDataRow
---@param mouseIsOver boolean
function SRM_hotbarAbilityListWindowClass:ColorRow(control, data, mouseIsOver)
    local color = ZO_NORMAL_TEXT
    -- GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, ITEM_QUALITY_LEGENDARY)
    local r, g, b = GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, ITEM_QUALITY_MAGIC)

    for i = 1, control:GetNumChildren() do
        local child = control:GetChild(i)
        if child then
            if child:GetType() ~= CT_TEXTURE then
                if data.LeftExp > 0 then
                    child:SetColor(color:UnpackRGBA())
                else
                    child:SetColor(r, g, b)
                end
            end
        end
    end

end

---SetupUnitRow
---@param control any
---@param data hotBarAbilityDataRow
function SRM_hotbarAbilityListWindowClass:SetupUnitRow(control, data)

    control.data = data

    control.StyleIcon = GetControl(control, "StyleIcon")
    control.StyleIcon:SetTexture(data.StyleIcon)

    control.AbilityName = GetControl(control, "AbilityName")
    -- control.AbilityName:SetText(string.format("[%s] %s (%s) %s", data.AbilityRank, data._morphChoice_, data.abilityId, data.AbilityName))
    control.AbilityName:SetText(data.AbilityName)
    control.AbilityName:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
    control.AbilityName:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

    control.AbilityRank = GetControl(control, "AbilityRank")
    control.AbilityRank:SetText(data.AbilityRank)
    control.AbilityRank:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    control.AbilityRank:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

    control.CurrentXP = GetControl(control, "CurrentXP")
    control.CurrentXP:SetText(SkillRankMonitoring.formatExp(data.CurrentXP))
    control.CurrentXP:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    control.CurrentXP:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

    control.LeftExp = GetControl(control, "LeftExp")
    control.LeftExp:SetText(string.format("%s (%d)", SkillRankMonitoring.formatExp(data.LeftExp), SkillRankMonitoring:MasterWritCountForExp(data.LeftExp)))
    control.LeftExp:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    control.LeftExp:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

    control.TotalExp = GetControl(control, "TotalExp")
    control.TotalExp:SetText(SkillRankMonitoring.formatExp(data.TotalExp))
    control.TotalExp:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    control.TotalExp:SetVerticalAlignment(TEXT_ALIGN_BOTTOM)

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

