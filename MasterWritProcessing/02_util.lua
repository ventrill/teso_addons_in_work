local MWP = MasterWritProcessing
local WW = WritWorthy

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

function MWP.getMotif(writItemLink)
    local writCraftType = MWP.getCraftType(writItemLink)
    if not MWP.isMotifNeeded(writCraftType) then
        return nil
    end
    local mat_list, know_list, parser = WW.ToMatKnowList(writItemLink)
    local motif = parser.motif_num
    if not motif then
        return
    end
    local chapter = parser.request_item.motif_page or ITEM_STYLE_CHAPTER_ALL
    local LCKI = LibCharacterKnowledgeInternal
    local itemId = LCKI.TranslateItem({ styleId = motif, chapterId = chapter })
    if itemId < 1 then
        --d(string.format("not found Motif motif num %s chapter %s", motif, chapter))
        local id2 = LCKI.TranslateItem({ styleId = motif, chapterId = ITEM_STYLE_CHAPTER_ALL })
        --d(string.format("not found Motif motif num %s chapter_all", motif))
        if id2 > 0 then
            itemId = id2
        end
    end
    local motifItemLink = LCKI.GetItemLink(itemId, LINK_STYLE_BRACKETS)
    return motifItemLink
end

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

function MWP.updateAll()
    MWP.scanInventory()
    MWP.scanBank()
    MWP.parseAllSaved()
end
SLASH_COMMANDS["/mwp_update_all"] = function()
    MWP.updateAll()
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

function MWP.highlightLabel(control, isHighlighted)
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

function MasterWritProcessing.ShowUIToolTip(control, pos, text)
    ZO_Tooltips_ShowTextTooltip(control, pos, text)
end

function MWP.showWindowSwapMode(control)
    -- @todo reset position by current control

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
    MWP_canBeProcessedByWindow:SetHidden(true)

    if var == "in_stock_list" then
        MWP.toggleInStockWindow()
    end
    if var == "materials_for_processing" then
        MWP.toggleMaterialsForProcessingListWindow()
    end
    if var == "materials_for_collecting" then
        MWP.toggleMaterialForCollectingWindow()
    end
    if var == "materials_for_collecting_short" then
        MWP.toggleMaterialForCollectingShortWindow()
    end
    if var == "can_be_processed_by" then
        MWP.toggleCanBeProcessedByListWindow()
    end
end

function MasterWritProcessing:ShowDebug(message)
    d(message)
end