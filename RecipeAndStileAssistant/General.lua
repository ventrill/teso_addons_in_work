function RecipeAndStileAssistant.info(string)
    d('RASA: ' .. string)
end
function RecipeAndStileAssistant.debug(string)
    --d('RASA: ' .. string)
end

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

    local count = RecipeAndStileAssistant.tableLength(RecipeAndStileAssistant.inWorkList);
    -- RecipeAndStileAssistant.inWorkList
    --for _, _ in pairs(RecipeAndStileAssistant.inWorkList) do
    --    count = count + 1
    --end

    if count >= RecipeAndStileAssistant.inWorkLimit then
        RecipeAndStileAssistant.IsInWorkLimit = true
    else
        RecipeAndStileAssistant.IsInWorkLimit = false
    end

    return RecipeAndStileAssistant.IsInWorkLimit
end