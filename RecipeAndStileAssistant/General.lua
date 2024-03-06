function RecipeAndStileAssistant.info(string)
    d('RASA: ' .. string)
end
function RecipeAndStileAssistant.debug(string)
    --d('RASA: ' .. string)
end

function RecipeAndStileAssistant.getIsNotKnowCount(ItemLink)
    local itemId = GetItemLinkItemId(ItemLink)
    if RecipeAndStileAssistant.neededCountIds[itemId] ~= nil then
        return RecipeAndStileAssistant.neededCountIds[itemId];
    end

    local knownStatus = LibCharacterKnowledge.GetItemKnowledgeList(ItemLink, nil)
    local count = 0
    for _, status in pairs(knownStatus) do
        if status.knowledge and status.knowledge == LibCharacterKnowledge.KNOWLEDGE_UNKNOWN then
            count = count + 1;
        end
    end
    RecipeAndStileAssistant.neededCountIds[itemId] = count;
    return RecipeAndStileAssistant.neededCountIds[itemId];
end

---tableLength
---@param table table
---@return string
function RecipeAndStileAssistant.tableLength(table)
    local count = 0;
    for _, _ in pairs(table) do
        count = count + 1
    end
    return count
end

---IsWorkLimit
---@return boolean
function RecipeAndStileAssistant.IsWorkLimit()
    if RecipeAndStileAssistant.IsInWorkLimit then
        return true
    end

    local count = RecipeAndStileAssistant.tableLength(RecipeAndStileAssistant.inWorkListIds);

    if count >= RecipeAndStileAssistant.inWorkLimit then
        RecipeAndStileAssistant.IsInWorkLimit = true
        RecipeAndStileAssistant.info("work limit is reached")
    else
        RecipeAndStileAssistant.IsInWorkLimit = false
    end

    return RecipeAndStileAssistant.IsInWorkLimit
end