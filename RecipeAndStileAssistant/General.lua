function RecipeAndStileAssistant.getIsNotKnowCount(ItemLink)
    if RecipeAndStileAssistant.neededCount[ItemLink] ~= nil then
        return RecipeAndStileAssistant.neededCount[ItemLink];
    end

    local knownStatus = LibCharacterKnowledge.GetItemKnowledgeList(ItemLink, nil)
    local count = 0
    for _, status in pairs(knownStatus) do
        if status.knowledge and status.knowledge == LibCharacterKnowledge.KNOWLEDGE_UNKNOWN then
            count = count + 1;
        end
    end
    RecipeAndStileAssistant.neededCount[ItemLink] = count;
    return RecipeAndStileAssistant.neededCount[ItemLink];
end


---IsWorkLimit
---@return boolean
function RecipeAndStileAssistant.IsWorkLimit()
    if RecipeAndStileAssistant.IsInWorkLimit then
        return true
    end

    local count = 0;
    -- RecipeAndStileAssistant.inWorkList
    for _, _ in pairs(RecipeAndStileAssistant.inWorkList) do
        count = count + 1
    end

    if count >= RecipeAndStileAssistant.inWorkLimit then
        RecipeAndStileAssistant.IsInWorkLimit = true
    else
        RecipeAndStileAssistant.IsInWorkLimit = false
    end

    return RecipeAndStileAssistant.IsInWorkLimit
end