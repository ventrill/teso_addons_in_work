local AGS = AwesomeGuildStore
local MultiChoiceFilterBase = AGS.class.MultiChoiceFilterBase
local SUB_CATEGORY_ID = AGS.data.SUB_CATEGORY_ID
local AGS_FILTER_ID = RecipeAndStileAssistant.AGS_FILTER_ID;
local UnknownFilter = MultiChoiceFilterBase:Subclass()
AGS.class.UnknownFilter = UnknownFilter

function UnknownFilter:New(...)
    return MultiChoiceFilterBase.New(self, ...)
end

function UnknownFilter:Initialize()

    local craftIcons = {}
    for i = 1, 2 do
        craftIcons[i] = {
            id = i,
            label = "Enable " .. i,
            icon = "EsoUI/Art/CharacterCreate/charactercreate_faceicon_%s.dds",
        }
    end
    MultiChoiceFilterBase.Initialize(self, AGS_FILTER_ID, AGS.class.FilterBase.GROUP_LOCAL, ("Unknown Recipe And Stile Assistant"), craftIcons)
    self:SetEnabledSubcategories({
        [SUB_CATEGORY_ID.CONSUMABLE_MOTIF] = true,
        [SUB_CATEGORY_ID.CONSUMABLE_RECIPE] = true,
    })
end

function UnknownFilter:SetSelected(value, selected, silent)
    MultiChoiceFilterBase.SetSelected(self, value, selected, silent)
end

function UnknownFilter:SetValues(selection)

    local changed = false
    local currentSelection = self.selection
    for value, state in pairs(selection) do
        if (currentSelection[value] ~= state) then
            changed = true
        end
        self:SetSelected(value, state, SILENT)
    end
    self:HandleChange(currentSelection)
end

function UnknownFilter:Reset(silent)
    MultiChoiceFilterBase.Reset(self, silent)
end

function UnknownFilter:FilterLocalResult(itemData)

    -- @todo check and remove if item is sold or error
    -- itemData.purchased = true
    if itemData.purchased then
        return false
    end
    -- itemData.soldout = true
    if itemData.soldout then
        return false
    end

    return RecipeAndStileAssistant.Filtration(itemData.itemLink, itemData.stackCount)
end

function RecipeAndStileAssistant.initAGSFilter()
    AGS:RegisterFilter(UnknownFilter:New())
    AGS:RegisterFilterFragment(AGS.class.MultiButtonFilterFragment:New(AGS_FILTER_ID))
end