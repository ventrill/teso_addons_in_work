--- @class HotBarAbilities
HotBarAbilities = ZO_Object:Subclass()

-----New
-----@return HotBarAbilities
function HotBarAbilities:New()
    local object = ZO_Object.New(self)
    object:Initialize()
    return object
end

---getHotBarAbilityIds
---@return table<string>
local function getHotBarAbilityIds()
    local skillTable = {}
    for hotBarCategory = 0, 1 do
        for slotIndex = 3, 8 do
            local hotBarData = ACTION_BAR_ASSIGNMENT_MANAGER:GetHotbar(hotBarCategory)
            if hotBarData then
                local slotData = hotBarData:GetSlotData(slotIndex)
                if slotData then
                    local abilityId = 0
                    if not slotData:IsEmpty() then
                        abilityId = slotData:GetEffectiveAbilityId()
                        table.insert(skillTable, abilityId)
                    end
                end
            end
        end
    end
    return skillTable
end

---@return HotBarAbilities
function HotBarAbilities:Initialize()
    self.Abilities = {}
    for _, abilityId in pairs(getHotBarAbilityIds()) do
        table.insert(self.Abilities, AbilityInfoClass:New(abilityId))
    end
    return self
end

function HotBarAbilities:hasCompleted()
    for i = 1, self:getCount() do
        if self:get(i):isComplete() == true then
            return true
        end
    end
    return false
end

---@return number
function HotBarAbilities:getCount()
    return #self.Abilities
end

---@param index number
---@return AbilityInfoClass
function HotBarAbilities:get(index)
    return self.Abilities[index]
end
