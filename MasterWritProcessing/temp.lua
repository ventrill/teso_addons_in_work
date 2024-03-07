local function getLocation(bagId)
    if (bagId == BAG_BACKPACK or bagId == BAG_WORN) then
        return IIfA.currentCharacterId
    elseif (bagId == BAG_BANK or bagId == BAG_SUBSCRIBER_BANK) then
        return GetString(IIFA_BAG_BANK)
    elseif (bagId == BAG_VIRTUAL) then
        return GetString(IIFA_BAG_CRAFTBAG)
    elseif (bagId == BAG_GUILDBANK) then
        return GetGuildName(GetSelectedGuildBankId())
    elseif 0 < GetCollectibleForHouseBankBag(bagId) then
        return GetCollectibleForHouseBankBag(bagId)
    end
end

--* GetCharacterNameById(*id64* _charId_)
--** _Returns:_ *string* _name_

CRAFTING_TYPE_ALCHEMY = 4
CRAFTING_TYPE_BLACKSMITHING = 1
CRAFTING_TYPE_CLOTHIER = 2
CRAFTING_TYPE_ENCHANTING = 3
CRAFTING_TYPE_INVALID = 0
CRAFTING_TYPE_JEWELRYCRAFTING = 7
CRAFTING_TYPE_PROVISIONING = 5
CRAFTING_TYPE_WOODWORKING = 6

--[[
GetItemLinkItemType(itemLink) ~= ITEMTYPE_MASTER_WRIT
h5. ItemType
        * ITEMTYPE_BLACKSMITHING_BOOSTER
        * ITEMTYPE_BLACKSMITHING_MATERIAL
        * ITEMTYPE_BLACKSMITHING_RAW_MATERIAL
        * ITEMTYPE_CLOTHIER_BOOSTER
        * ITEMTYPE_CLOTHIER_MATERIAL
        * ITEMTYPE_CLOTHIER_RAW_MATERIAL

* ITEMTYPE_JEWELRYCRAFTING_BOOSTER
* ITEMTYPE_JEWELRYCRAFTING_MATERIAL
* ITEMTYPE_JEWELRYCRAFTING_RAW_BOOSTER
* ITEMTYPE_JEWELRYCRAFTING_RAW_MATERIAL
]]
