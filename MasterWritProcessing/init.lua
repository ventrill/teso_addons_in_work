MasterWritProcessing = {
    addonName = "MasterWritProcessing",
    savedVars = {},
    savedKey = 'MasterWritProcessing_Data',
    characterList = {}, -- name => id
    characterNameList = {}, -- id => name
    AGS_FILTER_ID = AwesomeGuildStore.data.FILTER_ID.INDIVIDUAL_ITEM_PRICE_FILTER,
}
local MWP = MasterWritProcessing
local NORM_COLOR = ZO_ColorDef:New("BAA21A")
local SELECTED_COLOR = ZO_ColorDef:New("1A82BA")

MWP.ICON_TO_CRAFT_TYPE = {
    ["/esoui/art/icons/master_writ_blacksmithing.dds"] = CRAFTING_TYPE_BLACKSMITHING,
    ["/esoui/art/icons/master_writ_clothier.dds"] = CRAFTING_TYPE_CLOTHIER,
    ["/esoui/art/icons/master_writ_woodworking.dds"] = CRAFTING_TYPE_WOODWORKING,
    ["/esoui/art/icons/master_writ_jewelry.dds"] = CRAFTING_TYPE_JEWELRYCRAFTING,
    ["/esoui/art/icons/master_writ_alchemy.dds"] = CRAFTING_TYPE_ALCHEMY,
    ["/esoui/art/icons/master_writ_enchanting.dds"] = CRAFTING_TYPE_ENCHANTING,
    ["/esoui/art/icons/master_writ_provisioning.dds"] = CRAFTING_TYPE_PROVISIONING,
}
local CraftTypeLabel = {
    [CRAFTING_TYPE_BLACKSMITHING] = "Blacksmith",
    [CRAFTING_TYPE_CLOTHIER] = "Clothier",
    [CRAFTING_TYPE_WOODWORKING] = "Woodworker",
    [CRAFTING_TYPE_JEWELRYCRAFTING] = "Jewelry",
    [CRAFTING_TYPE_ALCHEMY] = "Alchemy",
    [CRAFTING_TYPE_ENCHANTING] = "Enchanting",
    [CRAFTING_TYPE_PROVISIONING] = "Provisioning",
}

function MWP.getCraftTypeLabel(craftType)
    if not CraftTypeLabel[craftType] then
        d(string.format("no label for %s", craftType))
        return 'none'
    end
    return CraftTypeLabel[craftType]
end

function MWP.showWindowSwapMode(control)
    WMP_WindowSwitcher:SetHidden(false)

end

function MWP.onSelectWindowClick(var)
    -- hide switcher
    WMP_WindowSwitcher:SetHidden(true)

    -- close all
    MWP_inStockWindow:SetHidden(true)
    MWP_MaterialsForProcessingWindow:SetHidden(true)
    MWP_MaterialForCollectingWindow:SetHidden(true)
    MWP_MaterialForCollectingShortWindow:SetHidden(true)

    if var == 0 then
        MWP.toggleInStockWindow()
    end
    if var == 1 then
        MWP.toggleMaterialsForProcessingListWindow()
    end
    if var == 2 then
        MWP.toggleMaterialForCollectingWindow()
    end
    if var == 3 then
        MWP.toggleMaterialForCollectingShortWindow()
    end
end

function MWP.highlightButton(control, isHighlighted)
    if isHighlighted then
        control:SetColor(SELECTED_COLOR:UnpackRGBA())
    else
        control:SetColor(NORM_COLOR:UnpackRGBA())
    end
    -- local NORM_COLOR = ZO_ColorDef:New("BC4B1A")
    -- local SELECTED_COLOR = ZO_ColorDef:New("1A82BA")
    -- control.status:SetColor(NORM_COLOR:UnpackRGBA())
    -- control.status:SetColor(SELECTED_COLOR:UnpackRGBA())
end

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

function MWP.getBankFreeSlots()
    return GetNumBagFreeSlots(BAG_BANK) + GetNumBagFreeSlots(BAG_SUBSCRIBER_BANK)
end