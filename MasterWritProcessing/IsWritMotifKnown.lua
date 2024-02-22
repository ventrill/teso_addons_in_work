local MWP = MasterWritProcessing
local LCK = LibCharacterKnowledge

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

    local LCKI = LibCharacterKnowledgeInternal
    local id, link_1 = LCKI.TranslateItem({ styleId = styleId, chapterId = chapterId })
    local link = LCKI.GetItemLink(id, LINK_STYLE_DEFAULT)
    return link
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

    --local knownStatus = LibCharacterKnowledge.GetItemKnowledgeList(ItemLink, nil)
    --local count = 0
    --for _, status in pairs(knownStatus) do
    --    if status.knowledge and status.knowledge == LibCharacterKnowledge.KNOWLEDGE_UNKNOWN then
    --        count = count + 1;
    --    end
    --end

    return false
end
local function getCharList()
    local list = {}
    for i = 1, GetNumCharacters() do
        --for i = 1, 7 do
        local _, _, _, _, _, _, characterId = GetCharacterInfo(i)
        table.insert(list, characterId)
    end
    return list
end

local function getMasterWritItemsByInv()
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
local function getCraftType(itemLink)
    local icon = GetItemLinkInfo(itemLink)
    return MWP.ICON_TO_CRAFT_TYPE[icon]
end
local function isMotifNeeded(craftType)
    if craftType == CRAFTING_TYPE_BLACKSMITHING or craftType == CRAFTING_TYPE_CLOTHIER or craftType == CRAFTING_TYPE_WOODWORKING then
        return true
    end
    return false
end


-- craftingSkillType

SLASH_COMMANDS["/mwp_test_motif_by_inventory_for_all"] = function()
    local MWList = getMasterWritItemsByInv()
    local charList = getCharList()

    local DoableList = {}
    DoableList['total'] = {
        ['all'] = 0,
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
            ['all'] = 0,
            [CRAFTING_TYPE_BLACKSMITHING] = 0,
            [CRAFTING_TYPE_CLOTHIER] = 0,
            [CRAFTING_TYPE_WOODWORKING] = 0,
            [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
            [CRAFTING_TYPE_ALCHEMY] = 0,
            [CRAFTING_TYPE_ENCHANTING] = 0,
            [CRAFTING_TYPE_PROVISIONING] = 0,
        }
    end

    for _, itemLink in pairs(MWList) do
        local craftType = getCraftType(itemLink)
        DoableList['total']['all'] = DoableList['total']['all'];
        DoableList['total'][craftType] = DoableList['total'][craftType];
        if isMotifNeeded(craftType) then
            local motifItemLink = getMasterWritMotif(itemLink)
            local characters = LibCharacterKnowledge.GetItemKnowledgeList(motifItemLink, nil)
            for _, character in pairs(characters) do
                if character.knowledge and character.knowledge == LibCharacterKnowledge.KNOWLEDGE_KNOWN then
                    DoableList[character.id]['all'] = DoableList[character.id]['all'] + 1
                    DoableList[character.id][craftType] = DoableList[character.id][craftType] + 1
                end
            end
        else
            for _, characterId in pairs(charList) do
                DoableList[characterId]['all'] = DoableList[characterId]['all'] + 1
                DoableList[characterId][craftType] = DoableList[characterId][craftType] + 1
            end
        end
    end
    d(DoableList)
    return DoableList
end