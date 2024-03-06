function RecipeAndStileAssistant.Filtration(ItemLink, OnSaleCount)
    local itemId = GetItemLinkItemId(ItemLink)
    if RecipeAndStileAssistant.ignoreListIds[itemId] == true then
        -- in ignoreList - hide it
        RecipeAndStileAssistant.debug(string.format("In ignore %s", ItemLink))
        return false
    end

    if RecipeAndStileAssistant.inWorkDoneListIds[itemId] == true then
        -- work done - hide it
        RecipeAndStileAssistant.debug(string.format("Work done for %s", ItemLink))
        return false
    end

    if RecipeAndStileAssistant.IsWorkLimit() and RecipeAndStileAssistant.inWorkListIds[itemId] == nil then
        RecipeAndStileAssistant.debug(string.format("Hidden by in work limit %s", ItemLink))
        return false
    end

    -- is not known check
    local notKnowCount = RecipeAndStileAssistant.getIsNotKnowCount(ItemLink)
    if notKnowCount < 1 then
        -- known - add to ignoreList
        RecipeAndStileAssistant.ignoreListIds[itemId] = true
        RecipeAndStileAssistant.debug(string.format("Added To ignore %s", ItemLink))
        return false
    end

    if OnSaleCount > notKnowCount then
        RecipeAndStileAssistant.debug(string.format("Items on sale %d more needed %d %s", OnSaleCount, notKnowCount, ItemLink))
        return false;
    end

    return true;
end