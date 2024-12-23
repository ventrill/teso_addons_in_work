--- @class AbilityInfoClass
AbilityInfoClass = ZO_Object:Subclass()

---New
---@param abilityId string
---@return AbilityInfoClass
function AbilityInfoClass:New(abilityId)
    local object = ZO_Object.New(self)
    object:Initialize(abilityId)
    return object
end

function AbilityInfoClass:Initialize(abilityId)
    self.id = abilityId
    self.name = nil
    self.icon = nil
    self.rank = nil
    self.progressionData = nil
    self.totalExp = nil
    self.currentXP = nil
    self.leftXP = nil
    self.is_complete = nil
end

function AbilityInfoClass:getProgressionData()
    if not self.progressionData then
        local progressionData = SKILLS_DATA_MANAGER:GetProgressionDataByAbilityId(self.id)
        if not progressionData then
            SkillRankMonitoring.debug('no progressionData')
            return nil
        end
        self.progressionData = progressionData
    end

    return self.progressionData
end

function AbilityInfoClass:getAbilityName()
    if not self.name then
        local progressionData = self:getProgressionData()
        if not progressionData then
            return nil
        end
        self.name = zo_strformat("<<C:1>>", progressionData:GetName())
    end
    return self.name
end

function AbilityInfoClass:getAbilityIcon()
    return GetAbilityIcon(self.id)
end

function AbilityInfoClass:getAbilityRank()
    if not self.rank then
        local progressionData = self:getProgressionData()
        if not progressionData then
            return nil
        end
        self.rank = progressionData:GetCurrentRank()
    end
    return self.rank
end

function AbilityInfoClass:getTotalExp()
    if not self.totalExp then
        local progressionData = self:getProgressionData()
        if not progressionData then
            return nil
        end
        local allExp = 0;
        for i = 1, 4 do
            local startXP, endXP = progressionData:GetRankXPExtents(i)
            if endXP > startXP then
                allExp = allExp + endXP - startXP
            end
        end
        self.totalExp = allExp
    end
    return self.totalExp
end

function AbilityInfoClass:getCurrentXP()
    if not self.currentXP then
        local progressionData = self:getProgressionData()
        if not progressionData then
            return nil
        end
        self.currentXP = progressionData:GetCurrentXP()
    end
    return self.currentXP
end

---@return number
function AbilityInfoClass:getLeftExp()
    if not self.leftExp then
        if not self:getTotalExp() or not self:getCurrentXP() then
            return nil
        end
        local leftExp = self:getTotalExp() - self:getCurrentXP()
        if leftExp <= 0 then
            leftExp = 0
        end
        self.leftExp = leftExp
    end
    return self.leftExp
end
function AbilityInfoClass:isComplete()
    if not self.is_complete then
        if not self:getTotalExp() or not self:getCurrentXP() then
            return nil
        end
        if self:getCurrentXP() >= self:getTotalExp() then
            self.is_complete = true
        else
            self.is_complete = false
        end
    end
    return self.is_complete
end
