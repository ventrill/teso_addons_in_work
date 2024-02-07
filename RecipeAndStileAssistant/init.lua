RecipeAndStileAssistant = {
    AddonName = "RecipeAndStileAssistant",
    AGS_FILTER_ID = AwesomeGuildStore.data.FILTER_ID.UNKNOWN_ON_ALTS_FILTER,
}

-- settings
RecipeAndStileAssistant.inWorkLimit = 5


-- ------------------------------------------
-- tmp arrays
-- ------------------------------------------
-- in collection process
-- [ItemLink] = true
RecipeAndStileAssistant.inWorkList = {}
-- collecting done
-- [ItemLink] = true
RecipeAndStileAssistant.inWorkDoneList = {}
-- item is known before collection process start
-- [ItemLink] = true
RecipeAndStileAssistant.ignoreList = {}
-- needed count for collection
-- [ItemLink] = int
RecipeAndStileAssistant.neededCount = {}
-- collected count
-- [ItemLink] = int
RecipeAndStileAssistant.purchasedCount = {}

RecipeAndStileAssistant.IsInWorkLimit = false;

function RecipeAndStileAssistant.debug(string)
    d('RASA: ' .. string)
end
