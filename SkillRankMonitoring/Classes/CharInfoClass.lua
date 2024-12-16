---@class CHAR_INFO_CLASS


local CHAR_INFO_CLASS = {}
CHAR_INFO_CLASS.id = ''
CHAR_INFO_CLASS.name = ''

---@param characterId string
---@return self
function CHAR_INFO_CLASS:New(characterId)
    self.id = characterId
    self.name = ''
    return self
end

---@return string
function CHAR_INFO_CLASS:GetName()
    if self.name ~= '' then
        return self.name
    end
    local id_64 = self.id
    self.name = ZO_CachedStrFormat(SI_UNIT_NAME, GetCharacterNameById(StringToId64(id_64)))
    return self.name
end