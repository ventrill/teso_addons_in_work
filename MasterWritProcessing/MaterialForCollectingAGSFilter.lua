local AGS = AwesomeGuildStore
local MWP = MasterWritProcessing
local MultiChoiceFilterBase = AGS.class.MultiChoiceFilterBase
local SUB_CATEGORY_ID = AGS.data.SUB_CATEGORY_ID
local AGS_FILTER_ID = MWP.AGS_FILTER_ID;
local MaterialForCollectingFilter = MultiChoiceFilterBase:Subclass()
AGS.class.MaterialForCollectingFilter = MaterialForCollectingFilter

function MaterialForCollectingFilter:New(...)
    return MultiChoiceFilterBase.New(self, ...)
end

function MaterialForCollectingFilter:Initialize()

    local craftIcons = {}
    for i = 1, 2 do
        craftIcons[i] = {
            id = i,
            label = "Enable " .. i,
            icon = "EsoUI/Art/CharacterCreate/charactercreate_faceicon_%s.dds",
        }
    end
    MultiChoiceFilterBase.Initialize(self, AGS_FILTER_ID, AGS.class.FilterBase.GROUP_LOCAL, ("MWP: Materials"), craftIcons)
    self:SetEnabledSubcategories({
        [SUB_CATEGORY_ID.CRAFTING_ALL] = true,
        [SUB_CATEGORY_ID.CRAFTING_BLACKSMITHING] = true,
        [SUB_CATEGORY_ID.CRAFTING_CLOTHIER] = true,
        [SUB_CATEGORY_ID.CRAFTING_WOODWORKING] = true,
        [SUB_CATEGORY_ID.CRAFTING_JEWELRY] = true,
        [SUB_CATEGORY_ID.CRAFTING_ALCHEMY] = true,
        [SUB_CATEGORY_ID.CRAFTING_ENCHANTING] = true,
        [SUB_CATEGORY_ID.CRAFTING_PROVISIONING] = true,
        [SUB_CATEGORY_ID.CRAFTING_STYLE_MATERIAL] = true,
        [SUB_CATEGORY_ID.CRAFTING_TRAIT_MATERIAL] = true,
        [SUB_CATEGORY_ID.CRAFTING_FURNISHING_MATERIAL] = true,
    })
end

function MaterialForCollectingFilter:SetSelected(value, selected, silent)
    MultiChoiceFilterBase.SetSelected(self, value, selected, silent)
end

function MaterialForCollectingFilter:SetValues(selection)

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

function MaterialForCollectingFilter:Reset(silent)
    MultiChoiceFilterBase.Reset(self, silent)
end

function MaterialForCollectingFilter:FilterLocalResult(itemData)

    if itemData.purchased then
        return false
    end
    if itemData.soldout then
        return false
    end

    local count = itemData.stackCount;
    local itemLink = itemData.itemLink;
    local itemId = GetItemLinkItemId(itemLink)

    return MWP.isItemNeed(itemId, count)
end

function MWP.initAGSFilter()
    AGS:RegisterFilter(MaterialForCollectingFilter:New())
    AGS:RegisterFilterFragment(AGS.class.MultiButtonFilterFragment:New(AGS_FILTER_ID))
end