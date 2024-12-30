--- @class CharacterStatisticInfoClass
CharacterStatisticInfoClass = ZO_Object:Subclass()

---@return CharacterStatisticInfoClass
function CharacterStatisticInfoClass:New(Index, CharacterId, CharacterName, SkillPointsCount, AbilityTable, IsCharacterProgressComplete)
    local object = ZO_Object.New(self)
    object:Initialize(Index, CharacterId, CharacterName, SkillPointsCount, AbilityTable, IsCharacterProgressComplete)
    return object
end

local function formatAbilityProgress(table, key)
    local all = table[key];
    local string = string.format("%s / %s / %s", all[MORPH_SLOT_BASE] or 0, all[MORPH_SLOT_MORPH_1] or 0, all[MORPH_SLOT_MORPH_2] or 0)
    return string
end

local function formatAbilityProgressNumber(table, key)
    local all = table[key];
    local sum = 0
    sum = sum + (all[MORPH_SLOT_BASE] or 0) + (all[MORPH_SLOT_MORPH_1] or 0) + (all[MORPH_SLOT_MORPH_2] or 0)
    return sum
end

---Initialize
---@param Index number
---@param CharacterId string
---@param CharacterName string
---@param SkillPointsCount number
---@param AbilityTable table
---@param IsCharacterProgressComplete boolean
function CharacterStatisticInfoClass:Initialize(Index, CharacterId, CharacterName, SkillPointsCount, AbilityTable, IsCharacterProgressComplete)
    self.Index = Index
    self.CharacterId = CharacterId
    self.CharacterName = CharacterName
    self.SkillPointsCount = SkillPointsCount
    self.IsCharacterProgressComplete = IsCharacterProgressComplete
    if IsCharacterProgressComplete == true then
        self.IsCharacterProgressCompleteText = 'Yes'
    else
        self.IsCharacterProgressCompleteText = 'No'
    end

    self.SrcAbilityTable = AbilityTable
    self.AbilityTable = AbilityTable
    self.AllAbilityStatus = formatAbilityProgressNumber(self.SrcAbilityTable, 'all')
    self.AllAbilityStatusText = formatAbilityProgress(self.SrcAbilityTable, 'all')

    self.ClassAbilityStatus = formatAbilityProgressNumber(self.SrcAbilityTable, SKILL_TYPE_CLASS)
    self.ClassAbilityStatusText = formatAbilityProgress(self.SrcAbilityTable, SKILL_TYPE_CLASS)

    self.WeaponAbilityStatus = formatAbilityProgressNumber(self.SrcAbilityTable, SKILL_TYPE_WEAPON)
    self.WeaponAbilityStatusText = formatAbilityProgress(self.SrcAbilityTable, SKILL_TYPE_WEAPON)

    self.GuildAbilityStatus = formatAbilityProgressNumber(self.SrcAbilityTable, SKILL_TYPE_GUILD)
    self.GuildAbilityStatusText = formatAbilityProgress(self.SrcAbilityTable, SKILL_TYPE_GUILD)

    self.ArmorAbilityStatus = formatAbilityProgressNumber(self.SrcAbilityTable, SKILL_TYPE_ARMOR)
    self.ArmorAbilityStatusText = formatAbilityProgress(self.SrcAbilityTable, SKILL_TYPE_ARMOR)

    self.AvAAbilityStatus = formatAbilityProgressNumber(self.SrcAbilityTable, SKILL_TYPE_AVA)
    self.AvAAbilityStatusText = formatAbilityProgress(self.SrcAbilityTable, SKILL_TYPE_AVA)

    self.WorldAbilityStatus = formatAbilityProgressNumber(self.SrcAbilityTable, SKILL_TYPE_WORLD)
    self.WorldAbilityStatusText = formatAbilityProgress(self.SrcAbilityTable, SKILL_TYPE_WORLD)
end


---IsCompleteFiltration
---@param Filter string
---@return boolean
function CharacterStatisticInfoClass:IsCompleteFiltration(Filter)
    if Filter == 'all' then
        return true
    end
    if Filter == 'Yes' and self.IsCharacterProgressComplete == true then
        return true
    end
    if Filter == 'No' and self.IsCharacterProgressComplete == false then
        return true
    end
    return false
end