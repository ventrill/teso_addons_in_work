RecipeAndStileAssistant = {
    AddonName = "RecipeAndStileAssistant",
    AGS_FILTER_ID = AwesomeGuildStore.data.FILTER_ID.UNKNOWN_ON_ALTS_FILTER,
}

-- settings
RecipeAndStileAssistant.inWorkLimit = 100


-- ------------------------------------------
-- tmp arrays
-- ------------------------------------------
-- [itemId] = itemLink
RecipeAndStileAssistant.idLink = {}
-- in collection process
-- [itemId] = true
RecipeAndStileAssistant.inWorkListIds = {}

-- collecting done
-- [itemId] = true
RecipeAndStileAssistant.inWorkDoneListIds = {}

-- item is known before collection process start
-- [itemId] = true
RecipeAndStileAssistant.ignoreListIds = {}


-- needed count for collection
-- [itemId] = int
RecipeAndStileAssistant.neededCountIds = {}

-- collected count
-- [itemId] = int
RecipeAndStileAssistant.purchasedCountIds = {}

RecipeAndStileAssistant.IsInWorkLimit = false;


