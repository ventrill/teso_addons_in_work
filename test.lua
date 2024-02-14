local units = {}
print(string.format("unit count %d", #units))
local data = {}

for i = 1, #data do
    GSMM.units[i] = {
        itemLink = data[i].itemLink,
        expiration = i * 7200,
        stackCount = 'stackCount' .. i,
        purchasePricePerUnit = 'purchasePricePerUnit' .. i,
        purchasePrice = 'purchasePrice' .. i,
        guildName = 'guildName' .. i,
    }
end

