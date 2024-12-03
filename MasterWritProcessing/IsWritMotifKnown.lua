local MWP = MasterWritProcessing
local LCK = LibCharacterKnowledge
local LCKI = LibCharacterKnowledgeInternal

local EQUIPMENT_CHAPTERS = {
    [26] = ITEM_STYLE_CHAPTER_HELMETS, -- Hat
    [28] = ITEM_STYLE_CHAPTER_CHESTS, -- Robe
    [29] = ITEM_STYLE_CHAPTER_SHOULDERS, -- Epaulets
    [30] = ITEM_STYLE_CHAPTER_BELTS, -- Sash
    [31] = ITEM_STYLE_CHAPTER_LEGS, -- Breeches
    [32] = ITEM_STYLE_CHAPTER_BOOTS, -- Shoes
    [34] = ITEM_STYLE_CHAPTER_GLOVES, -- Gloves
    [35] = ITEM_STYLE_CHAPTER_HELMETS, -- Helmet
    [37] = ITEM_STYLE_CHAPTER_CHESTS, -- Jack
    [38] = ITEM_STYLE_CHAPTER_SHOULDERS, -- Arm Cops
    [39] = ITEM_STYLE_CHAPTER_BELTS, -- Belt
    [40] = ITEM_STYLE_CHAPTER_LEGS, -- Guards
    [41] = ITEM_STYLE_CHAPTER_BOOTS, -- Boots
    [43] = ITEM_STYLE_CHAPTER_GLOVES, -- Bracers
    [44] = ITEM_STYLE_CHAPTER_HELMETS, -- Helm
    [46] = ITEM_STYLE_CHAPTER_CHESTS, -- Cuirass
    [47] = ITEM_STYLE_CHAPTER_SHOULDERS, -- Pauldron
    [48] = ITEM_STYLE_CHAPTER_BELTS, -- Girdle
    [49] = ITEM_STYLE_CHAPTER_LEGS, -- Greaves
    [50] = ITEM_STYLE_CHAPTER_BOOTS, -- Sabatons
    [52] = ITEM_STYLE_CHAPTER_GLOVES, -- Gauntlets
    [53] = ITEM_STYLE_CHAPTER_AXES, -- Axe
    [56] = ITEM_STYLE_CHAPTER_MACES, -- Mace
    [59] = ITEM_STYLE_CHAPTER_SWORDS, -- Sword
    [62] = ITEM_STYLE_CHAPTER_DAGGERS, -- Dagger
    [65] = ITEM_STYLE_CHAPTER_SHIELDS, -- Shield
    [67] = ITEM_STYLE_CHAPTER_SWORDS, -- Greatsword
    [68] = ITEM_STYLE_CHAPTER_AXES, -- Battle Axe
    [69] = ITEM_STYLE_CHAPTER_MACES, -- Maul
    [70] = ITEM_STYLE_CHAPTER_BOWS, -- Bow
    [71] = ITEM_STYLE_CHAPTER_STAVES, -- Restoration Staff
    [72] = ITEM_STYLE_CHAPTER_STAVES, -- Inferno Staff
    [73] = ITEM_STYLE_CHAPTER_STAVES, -- Ice Staff
    [74] = ITEM_STYLE_CHAPTER_STAVES, -- Lightning Staff
    [75] = ITEM_STYLE_CHAPTER_CHESTS, -- Jerkin
}

local function getMasterWritMotif(itemLink)
    local fields = { zo_strsplit(":", itemLink) }
    local styleId = fields[14] and tonumber(fields[14])
    local chapterId = fields[9] and EQUIPMENT_CHAPTERS[tonumber(fields[9])]

    local id = LCKI.TranslateItem({ styleId = styleId, chapterId = chapterId })
    local link = LCKI.GetItemLink(id, LINK_STYLE_DEFAULT)
    return link
end

-- @todo need check
local function getRecipeLink(itemLink)
    local mat_list, know_list, parser = WritWorthy.ToMatKnowList(itemLink)
    -- local parser = WritWorthy.CreateParser(itemLink)
    -- d('parser.recipe',parser.recipe)
    if parser.recipe then
        local recipeItemId = parser.recipe.recipe_item_id
        local recipeLink = parser.recipe.recipe_link
        --d(string.format("Found Recipe [%s] %s", recipeItemId, recipeLink))
        --d(string.format("LCKI Recipe Link %s", LCKI.GetItemLink(recipeItemId, LINK_STYLE_DEFAULT)))
        return recipeLink
    end

    return nil
end

local function saveMotifLink(motifItemLink)
    local itemId = GetItemLinkItemId(motifItemLink)
    if not MWP.savedVars.ParsedMotifList[itemId] then
        MWP.savedVars.ParsedMotifList[itemId] = {
            itemId = itemId,
            link = motifItemLink,
            countWrit = 0,
        }
    end
    MWP.savedVars.ParsedMotifList[itemId]['countWrit'] = MWP.savedVars.ParsedMotifList[itemId]['countWrit'] + 1;
end
local function saveRecipeList(recipeItemLink)
    local itemId = GetItemLinkItemId(recipeItemLink)
    if not MWP.savedVars.ParsedRecipeList[itemId] then
        MWP.savedVars.ParsedRecipeList[itemId] = {
            itemId = itemId,
            link = recipeItemLink,
            countWrit = 0,
        }
    end
    MWP.savedVars.ParsedRecipeList[itemId]['countWrit'] = MWP.savedVars.ParsedRecipeList[itemId]['countWrit'] + 1;
end

local function IsWritMotifKnown(itemLink, CharacterId)
    local fields = { zo_strsplit(":", itemLink) }
    local styleId = fields[14] and tonumber(fields[14])
    local chapterId = fields[9] and EQUIPMENT_CHAPTERS[tonumber(fields[9])]

    local LCKI = LibCharacterKnowledgeInternal
    local id, link_1 = LCKI.TranslateItem({ styleId = styleId, chapterId = chapterId })
    local link = LCKI.GetItemLink(id, LINK_STYLE_DEFAULT)
    --d(link)
    --d(link_1)
    if (styleId and chapterId and LCK.GetMotifKnowledgeForCharacter(styleId, chapterId, nil, CharacterId) == LCK.KNOWLEDGE_KNOWN) then
        return true
    end
    -- Public.KNOWLEDGE_KNOWN = Internal.KNOWLEDGE_KNOWN

    --local knownStatus = LCK.GetItemKnowledgeList(ItemLink, nil)
    --local count = 0
    --for _, status in pairs(knownStatus) do
    --    if status.knowledge and status.knowledge == LCK.KNOWLEDGE_UNKNOWN then
    --        count = count + 1;
    --    end
    --end

    return false
end

local function getCharList()
    local list = {}
    for i = 1, GetNumCharacters() do
        --for i = 1, 3 do
        local _, _, _, _, _, _, characterId = GetCharacterInfo(i)
        table.insert(list, characterId)
    end
    return list
end

local function getMasterWritItemsByInv()
    local list = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        local itemType = GetItemType(bagId, slotIndex)
        if ITEMTYPE_MASTER_WRIT == itemType then
            local itemLink = GetItemLink(bagId, slotIndex)
            table.insert(list, itemLink)
            -- IsWritMotifKnown(itemLink)
        end
    end
    return list
end
local function getMasterWritItemsByInvAndBank()
    local list = {}
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK)
    for _, slotData in ipairs(bagCache) do
        local bagId = slotData.bagId
        local slotIndex = slotData.slotIndex
        local itemType = GetItemType(bagId, slotIndex)
        if ITEMTYPE_MASTER_WRIT == itemType then
            local itemLink = GetItemLink(bagId, slotIndex)
            table.insert(list, itemLink)
            -- IsWritMotifKnown(itemLink)
        end
    end
    return list
end

SLASH_COMMANDS["/mwp_test_motif_by_inventory"] = function()
    d(GetCraftingSkillName(CRAFTING_TYPE_BLACKSMITHING))
    d(GetCraftingSkillName(CRAFTING_TYPE_CLOTHIER))
    d(GetCraftingSkillName(CRAFTING_TYPE_WOODWORKING))
    -- getMasterWritItemsByInv()
end

function MWP.prepareDoableList()
    MWP.savedVars.ParsedMotifList = {}
    MWP.savedVars.ParsedRecipeList = {}

    --local MWList = getMasterWritItemsByInv()
    --local MWList = getMasterWritItemsByInvAndBank()
    local MWList = MasterWritProcessing.getAllSavedItemLinks()
    local charList = getCharList()

    local DoableList = {}

    DoableList['total'] = {
        ['characterId'] = nil,
        ['name'] = "total",
        ['all'] = 0,
        ['isCharacterProgressComplete'] = false,
        [CRAFTING_TYPE_BLACKSMITHING] = 0,
        [CRAFTING_TYPE_CLOTHIER] = 0,
        [CRAFTING_TYPE_WOODWORKING] = 0,
        [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
        [CRAFTING_TYPE_ALCHEMY] = 0,
        [CRAFTING_TYPE_ENCHANTING] = 0,
        [CRAFTING_TYPE_PROVISIONING] = 0,
    }

    for _, characterId in pairs(charList) do
        DoableList[characterId] = {
            ['characterId'] = characterId,
            ['name'] = ZO_CachedStrFormat(SI_UNIT_NAME, GetCharacterNameById(StringToId64(characterId))),
            ['all'] = 0,
            ['isCharacterProgressComplete'] = false,
            [CRAFTING_TYPE_BLACKSMITHING] = 0,
            [CRAFTING_TYPE_CLOTHIER] = 0,
            [CRAFTING_TYPE_WOODWORKING] = 0,
            [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
            [CRAFTING_TYPE_ALCHEMY] = 0,
            [CRAFTING_TYPE_ENCHANTING] = 0,
            [CRAFTING_TYPE_PROVISIONING] = 0,
        }
        if SkillRankMonitoring then
            DoableList[characterId]['isCharacterProgressComplete'] = SkillRankMonitoring.isCharacterProgressComplete(characterId)
        end
    end

    for _, writItemLink in pairs(MWList) do
        local writCraftType = MWP.getCraftType(writItemLink)
        DoableList['total']['all'] = DoableList['total']['all'] + 1;
        DoableList['total'][writCraftType] = DoableList['total'][writCraftType] + 1;
        if MWP.isMotifNeeded(writCraftType) then
            -- local motifItemLink = getMasterWritMotif(writItemLink)
            local motifItemLink = MWP.getMotif(writItemLink)
            if motifItemLink then
                saveMotifLink(motifItemLink)
                local characters = LCK.GetItemKnowledgeList(motifItemLink, nil)
                for _, character in pairs(characters) do
                    if character.knowledge and character.knowledge == LCK.KNOWLEDGE_KNOWN then
                        DoableList[character.id]['all'] = DoableList[character.id]['all'] + 1
                        DoableList[character.id][writCraftType] = DoableList[character.id][writCraftType] + 1
                    end
                end
            else
                d(string.format("Motif link not found for %s", writItemLink))
            end
        elseif MWP.isRecipeNeed(writCraftType) then
            local recipeLink = getRecipeLink(writItemLink)
            if recipeLink then
                saveRecipeList(recipeLink)
                local characters = LCK.GetItemKnowledgeList(recipeLink, nil)
                for _, character in pairs(characters) do
                    if character.knowledge and character.knowledge == LCK.KNOWLEDGE_KNOWN then
                        DoableList[character.id]['all'] = DoableList[character.id]['all'] + 1
                        DoableList[character.id][writCraftType] = DoableList[character.id][writCraftType] + 1
                    end
                end
            else
                d(string.format("Recipe link not found for %s", writItemLink))
            end
        else
            for _, characterId in pairs(charList) do
                DoableList[characterId]['all'] = DoableList[characterId]['all'] + 1
                DoableList[characterId][writCraftType] = DoableList[characterId][writCraftType] + 1
            end
        end
    end

    return DoableList
end

function MWP.isDoable(writItemLink, characterId)
    local writCraftType = MWP.getCraftType(writItemLink)
    if MWP.isMotifNeeded(writCraftType) then
        --local motifItemLink = getMasterWritMotif(writItemLink)
        local motifItemLink = MWP.getMotif(writItemLink)
        if motifItemLink then
            local know = LCK.GetItemKnowledgeForCharacter(motifItemLink, nil, characterId)
            if know == LCK.KNOWLEDGE_KNOWN then
                return true
            end
        end
    elseif MWP.isRecipeNeed(writCraftType) then
        local recipeLink = getRecipeLink(writItemLink)
        if recipeLink then
            local know = LCK.GetItemKnowledgeForCharacter(recipeLink, nil, characterId)
            if know == LCK.KNOWLEDGE_KNOWN then
                return true
            end
        end
    else
        return true
    end
    return false
end


