GSMM.buttons = {}

GSMM.buttons.scanListing={
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
    {
        name = "GSMM: Scan Listing",
        keybind = "GSMM_START_SCANING",
        callback = function()
            GSMM.scanStart()
        end,
        visible = function()
            return true
        end
    },
}

function GSMM.buttons.scanListingVisibilityCheck()
    if GSMM.isListingTabTradingHouseTab then
        KEYBIND_STRIP:AddKeybindButtonGroup(GSMM.buttons.scanListing)
    else
        KEYBIND_STRIP:RemoveKeybindButtonGroup(GSMM.buttons.scanListing)
    end
end

