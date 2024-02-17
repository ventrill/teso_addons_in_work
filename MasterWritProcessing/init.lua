MasterWritProcessing = {
    addonName = "MasterWritProcessing",
}

local MWP = MasterWritProcessing

local bagId = BAG_BACKPACK;
local timeout = 250;
local listToWorkWith = {};

function MWP.prepareWritInfo()
    d("MWP.prepareWritInfo")
    MasterWritProcessing.searchAll()
    return MasterWritProcessing.getSlotStatistic()
end

function MWP.ProcessWrit(control)
    local parent = control:GetParent()
    if parent ~= nil then
        if parent.data then
            local str = string.format("Type: %s [%s], Count %d", parent.data.CraftType, parent.data.CraftTypeId, parent.data.Count)
            d(str)
            MasterWritProcessing.processByType(parent.data.CraftTypeId)
        else
            d("paren has no data")
        end
    end
end