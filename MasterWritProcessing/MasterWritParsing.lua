local MWP = MasterWritProcessing
local WW = WritWorthy

local function resetParseResult()
    MWP.savedVars.ParsedMotifList = {}
    MWP.savedVars.ParsedRecipeList = {}
    MWP.savedVars.ParsedMaterials = {}
end

local function saveMaterialIno(matList)
    for _, matRow in pairs(matList) do
        local itemId = matRow.item_id
        local itemLink = matRow.link
        local toCraftNeedCount = matRow.ct

        if not MWP.savedVars.ParsedMaterials[itemId] then
            MWP.savedVars.ParsedMaterials[itemId] = {
                ['itemId'] = itemId,
                ['itemLink'] = itemLink,
                ['itemName'] = GetItemLinkName(itemLink),
                ['toCraftNeedCount'] = 0,
            }
        end

        MWP.savedVars.ParsedMaterials[itemId]['toCraftNeedCount'] = MWP.savedVars.ParsedMaterials[itemId]['toCraftNeedCount'] + toCraftNeedCount
    end
end

local function saveMotifInfo(writCraftType, parser)
    if not MWP.isMotifNeeded(writCraftType) then
        return
    end

    local motif = parser.motif_num
    if not motif then
        return
    end
    local chapter = parser.request_item.motif_page or ITEM_STYLE_CHAPTER_ALL

    local LCKI = LibCharacterKnowledgeInternal
    local itemId = LCKI.TranslateItem({ styleId = motif, chapterId = chapter })
    if itemId < 1 then
        d(string.format("not found Motif motif num %s chapter %s", motif, chapter))
        local id2 = LCKI.TranslateItem({ styleId = motif, chapterId = ITEM_STYLE_CHAPTER_ALL })
        if id2 < 0 then
            d(string.format("not found Motif motif num %s chapter_all", motif))
        end
        if id2 > 0 then
            itemId = id2
        end
    end
    local motifItemLink = LCKI.GetItemLink(itemId, LINK_STYLE_BRACKETS)
    if not motifItemLink then
        return
    end

    --local itemId = GetItemLinkItemId(motifItemLink)
    if not MWP.savedVars.ParsedMotifList[itemId] then
        MWP.savedVars.ParsedMotifList[itemId] = {
            ['itemId'] = itemId,
            ['link'] = motifItemLink,
            ['countWrit'] = 0,
        }
    end
    MWP.savedVars.ParsedMotifList[itemId]['countWrit'] = MWP.savedVars.ParsedMotifList[itemId]['countWrit'] + 1;

end
local function saveRecipeInfo(writCraftType, parser)
    if not MWP.isRecipeNeed(writCraftType) then
        return
    end
    if parser.recipe then
        local recipeItemId = parser.recipe.recipe_item_id
        local recipeLink = parser.recipe.recipe_link

        if not MWP.savedVars.ParsedRecipeList[recipeItemId] then
            MWP.savedVars.ParsedRecipeList[recipeItemId] = {
                ['recipeItemId'] = recipeItemId,
                ['recipeLink'] = recipeLink,
                ['count'] = 0,
            }
        end
        MWP.savedVars.ParsedRecipeList[recipeItemId]['count'] = MWP.savedVars.ParsedRecipeList[recipeItemId]['count'] + 1
    end
end

local function getMasterWritItemsByInventory()
    local items = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        local itemType = GetItemType(bagId, slotIndex)
        if ITEMTYPE_MASTER_WRIT == itemType then
            local itemLink = GetItemLink(bagId, slotIndex)
            table.insert(items, itemLink)
        end
    end
    return items
end

local function getMasterWritItemsByInventoryAndBank()
    local items = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        local itemType = GetItemType(bagId, slotIndex)
        if ITEMTYPE_MASTER_WRIT == itemType then
            local itemLink = GetItemLink(bagId, slotIndex)
            table.insert(items, itemLink)
        end
    end
    return items
end

local function parseWritItemList(WritItemList)
    for _, writItemLink in pairs(WritItemList) do
        local writCraftType = MWP.getCraftType(writItemLink)

        local mat_list, know_list, parser = WW.ToMatKnowList(writItemLink)

        saveMaterialIno(mat_list)
        saveMotifInfo(writCraftType, parser)
        saveRecipeInfo(writCraftType, parser)

    end
end

function MWP.parseByInventory()
    resetParseResult()
    local WritItemList = getMasterWritItemsByInventory()
    parseWritItemList(WritItemList)
end
function MWP.parseByInventoryAndBank()
    resetParseResult()
    local WritItemList = getMasterWritItemsByInventoryAndBank()
    parseWritItemList(WritItemList)
end
function MWP.parseAllSaved()
    resetParseResult()
    local WritItemList = MasterWritProcessing.getAllSavedItemLinks()
    parseWritItemList(WritItemList)
end

SLASH_COMMANDS["/mwp_test_show_motif_list"] = function()
    -- /script d(MasterWritProcessing.savedVars.ParsedMotifList)
    local list = MWP.savedVars.ParsedMotifList
    for _, row in pairs(list) do
        if row.countWrit > 1 then
            d(string.format("Need for %s writ [%s] %s", row.countWrit, row.itemId, row.link))
        end
    end
end

SLASH_COMMANDS["/mwp_test_show_recipe_list"] = function()
    -- /script d(MasterWritProcessing.savedVars.ParsedRecipeList)
    local list = MWP.savedVars.ParsedRecipeList
    for _, row in pairs(list) do
        if row.count > 0 then
            d(string.format("Need for %s writ [%s] %s", row.count, row.recipeItemId, row.recipeLink))
        end
    end
end