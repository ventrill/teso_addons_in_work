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