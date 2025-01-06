SkillRankMonitoring = {
    addonName = 'SkillRankMonitoring',
    displayDebug = true,
    MorphChoice = 'all',
    IsPurchasedChoice = 'all',
    IsCompleteChoice = 'No',
    StepFilterChoice = 'not_complete',
    IsUltimateFilterChoice = 'all',
    IsLockedBySkillRankFilterChoice = 'isUnLocked',
    savedVars = {},
    savedKey = 'SkillRankMonitoring_Data',
    expPerMasterWrit = 35366,
}

function SkillRankMonitoring:getNormalTextColor()
    return ZO_ColorDef:New("FFFFFF")
end
function SkillRankMonitoring:getSelectedTextColor()
    return ZO_ColorDef:New("2DC50E")
end

--RDL.DEFAULT_TEXT = ZO_ColorDef:New(0.4627, 0.737, 0.7647, 1) -- scroll list row text color
--RDL.GREEN_TEXT = ZO_ColorDef:New("2DC50E")
--RDL.BLUE_TEXT = ZO_ColorDef:New("3A92FF")
--RDL.PURPLE_TEXT = ZO_ColorDef:New("A02EF7")
--RDL.GOLD_TEXT = ZO_ColorDef:New("CCAA1A")
--RDL.ORANGE_TEXT = ZO_ColorDef:New("E58B27")
--RDL.YELLOW_TEXT = ZO_ColorDef:New("FFFF66")
--RDL.RED_TEXT = ZO_ColorDef:New("FF6666")


---@return HotBarAbilities
function SkillRankMonitoring:getHotBarAbilities()
    return HotBarAbilities:New()
end

function SkillRankMonitoring:CheckHotBarAbilities()
    if SkillRankMonitoring.isCharacterProgressComplete(GetCurrentCharacterId()) == true then
        return
    end
    local list = self:getHotBarAbilities()
    if list:hasCompleted() then
        self.showHotBarInfo()
    end
end

---MasterWritCount
---@param leftExp number
---@return number
function SkillRankMonitoring:MasterWritCountForExp(leftExp)
    local count = 0
    if leftExp > 0 then
        count = leftExp / self.expPerMasterWrit
        return math.ceil(count)
    end
    return count
end

---formatExp
---@param amount number
---@return string
function SkillRankMonitoring.formatExp(amount)
    local div = 1000;
    if amount < div then
        return string.format("%d", amount)
    end

    local first = math.floor(amount / div)
    local last = math.fmod(amount, div)
    if last < 10 then
        --SRM.debug(string.format('last (%d) < 10 ', last))
        return string.format("%d 00%d", first, last)
    end
    if last < 100 then
        --SRM.debug(string.format('last (%d) < 100 ', last))
        return string.format("%d 0%d", first, last)
    end
    return string.format("%d %d", first, last)
end

function SkillRankMonitoring.DropdownShowTooltip(control, dropdownName)
    if dropdownName then
        InitializeTooltip(InformationTooltip, control, BOTTOMLEFT, 0, -2, TOPLEFT)
        InformationTooltip:SetHidden(false)
        InformationTooltip:ClearLines()
        InformationTooltip:AddLine(dropdownName)
    end
end

function SkillRankMonitoring.DropdownHideTooltip(control)
    InformationTooltip:ClearLines()
    InformationTooltip:SetHidden(true)
end

function SkillRankMonitoring.HeaderMouseEnter(control, tooltipText)
    if tooltipText then
        InitializeTooltip(InformationTooltip, control, BOTTOMLEFT, 0, -2, TOPLEFT)
        InformationTooltip:SetHidden(false)
        InformationTooltip:ClearLines()
        InformationTooltip:AddLine(tooltipText)
    end
end

function SkillRankMonitoring.HeaderMouseExit(control, name)
    InformationTooltip:ClearLines()
    InformationTooltip:SetHidden(true)
end

function SkillRankMonitoring.debug(string)
    if not SkillRankMonitoring.displayDebug then
        return
    end
    d('RSM: ' .. string)
end
