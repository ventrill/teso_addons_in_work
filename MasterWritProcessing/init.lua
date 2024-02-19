MasterWritProcessing = {
    addonName = "MasterWritProcessing",
}

local MWP = MasterWritProcessing

function MWP.prepareWritInfo()
    d("MWP.prepareWritInfo")
    MWP.searchAll()
    return MWP.getSlotStatistic()
end

function MWP.prepareWritInfoBySaved()
    d('MWP.prepareWritInfoBySaved')
    return MWP.getSlotStatistic()
end

function MWP.ProcessWrit(control)
    local parent = control:GetParent()
    if parent ~= nil and parent.data then
        local str = string.format("Type: %s [%s], Count %d", parent.data.CraftType, parent.data.CraftTypeId, parent.data.Count)
        --d(str)
        MWP.processByType(parent.data.CraftTypeId)
        MWP.showSavedProcessingListInfo()
    else
        --d("paren has no data")
    end
end