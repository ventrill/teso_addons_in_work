--- @class hotBarAbilityDataRow
hotBarAbilityDataRow  = ZO_Object:Subclass()

---New
---@param abilityInfo AbilityInfoClass
---@return self
function hotBarAbilityDataRow:New(abilityInfo)
    local object = ZO_Object.New(self)
    object:Initialize(abilityInfo)
    return object
end

---Initialize
---@param abilityInfo AbilityInfoClass
function hotBarAbilityDataRow:Initialize(abilityInfo)
    self.StyleIcon = abilityInfo:getAbilityIcon()
    self.AbilityName = abilityInfo:getAbilityName()
    self.AbilityRank = abilityInfo:getAbilityRank()
    self.TotalExp = abilityInfo:getTotalExp()
    self.CurrentXP = abilityInfo:getCurrentXP()
    self.LeftExp = abilityInfo:getLeftExp()
end
