MasterWritProcessing = {
    addonName = "MasterWritProcessing",
    savedVars = {},
    savedKey = 'MasterWritProcessing_Data',
    characterList = {}, -- name => id
    AGS_FILTER_ID = AwesomeGuildStore.data.FILTER_ID.INDIVIDUAL_ITEM_PRICE_FILTER,
}

local MWP = MasterWritProcessing

MWP.ICON_TO_CRAFT_TYPE = {
    ["/esoui/art/icons/master_writ_blacksmithing.dds"] = CRAFTING_TYPE_BLACKSMITHING
, ["/esoui/art/icons/master_writ_clothier.dds"] = CRAFTING_TYPE_CLOTHIER
, ["/esoui/art/icons/master_writ_woodworking.dds"] = CRAFTING_TYPE_WOODWORKING
, ["/esoui/art/icons/master_writ_jewelry.dds"] = CRAFTING_TYPE_JEWELRYCRAFTING
, ["/esoui/art/icons/master_writ_alchemy.dds"] = CRAFTING_TYPE_ALCHEMY
, ["/esoui/art/icons/master_writ_enchanting.dds"] = CRAFTING_TYPE_ENCHANTING
, ["/esoui/art/icons/master_writ_provisioning.dds"] = CRAFTING_TYPE_PROVISIONING
}

function MWP.getCraftType(itemLink)
    local icon = GetItemLinkInfo(itemLink)
    return MWP.ICON_TO_CRAFT_TYPE[icon] or nil
end

function MWP.isMotifNeeded(craftType)
    if craftType == CRAFTING_TYPE_BLACKSMITHING or craftType == CRAFTING_TYPE_CLOTHIER or craftType == CRAFTING_TYPE_WOODWORKING then
        return true
    end
    return false
end
function MWP.isRecipeNeed(craftType)
    if CRAFTING_TYPE_PROVISIONING == craftType then
        return true
    end
    return false
end

function MWP.MatHaveCt(item_link)
    local bag_ct, bank_ct, craft_bag_ct = GetItemLinkStacks(item_link)
    return bag_ct + bank_ct + craft_bag_ct
end
