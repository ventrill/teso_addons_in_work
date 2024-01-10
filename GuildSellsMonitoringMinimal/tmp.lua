--information schema
local onSale = {
    window="GSMM_OnSaleListMainWindow",
    headers={
        "itemLink","stackCount","purchasePricePerUnit","purchasePrice","timeRemaining","expiration"
    },
    unitRow="GSMM_OnSaleListUnitRow",
    {
        "itemLink",
        "stackCount",
        "purchasePricePerUnit",
        "purchasePrice",
        "timeRemaining",
        "expiration",
    },

}

local sold = {
    window = "GSMM_SoldListMainWindow",
    headers = {
        "itemLink", "stackCount", "purchasePricePerUnit", "purchasePrice", "lastFoundAt", "addedToSoldAt",
    },
    unitRow = "GSMM_SoldListUnitRow",
    {
        "itemLink",
        "stackCount",
        "purchasePricePerUnit",
        "purchasePrice",
        "lastFoundAt",
        "addedToSoldAt",
    }
}

local statistic = {
    window = "GSMM_StatisticWindow",
    headers = {
        { "GuildName", "ItemsSoldCount", "SoldSum", "LastScanAt" }
    },
    unitRow = "GSMM_StatisticWindowUnitRow",
    {
        { "GuildName", "ItemsSoldCount", "SoldSum", "LastScanAt" }
    }
}