GSMM = {
    addonName = 'GuildSellsMonitoringMinimal',
    savedKey = 'GuildSellsMonitoringMinimal_Data',
    saved = {},
    tradingOpenAt=nil
}

function GSMM.getGuildName(guildId)
    if not GSMM.saved.guilds then
        GSMM.saved.guilds = {}
    end

    if not GSMM.saved.guilds[guildId] then
        if IsPlayerInGuild(guildId) then
            GSMM.saved.guilds[guildId] = GetGuildName(guildId) or guildId
        else
            GSMM.saved.guilds[guildId] = guildId
        end
    end

    return GSMM.saved.guilds[guildId]
end

--GSMM.saved = {
--    [585680] = {
--        [1] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Chromium Plating^n",
--            ["icon"] = "/esoui/art/icons/jewelrycrafting_booster_refined_chromium.dds",
--            ["itemId"] = 203634,
--            ["purchasePrice"] = 114000,
--            ["timeRemaining"] = 2506303,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 8,
--            ["purchasePricePerUnit"] = 14250,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [2] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Chromium Plating^n",
--            ["icon"] = "/esoui/art/icons/jewelrycrafting_booster_refined_chromium.dds",
--            ["itemId"] = 203634,
--            ["purchasePrice"] = 114000,
--            ["timeRemaining"] = 2506304,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 8,
--            ["purchasePricePerUnit"] = 14250,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [3] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Chromium Plating^n",
--            ["icon"] = "/esoui/art/icons/jewelrycrafting_booster_refined_chromium.dds",
--            ["itemId"] = 203634,
--            ["purchasePrice"] = 114000,
--            ["timeRemaining"] = 2506305,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 8,
--            ["purchasePricePerUnit"] = 14250,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--    },
--    [147954] = {
--    },
--    [726298] = {
--        [4] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Chromium Plating^n",
--            ["icon"] = "/esoui/art/icons/jewelrycrafting_booster_refined_chromium.dds",
--            ["itemId"] = 203634,
--            ["purchasePrice"] = 114000,
--            ["timeRemaining"] = 2506271,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 8,
--            ["purchasePricePerUnit"] = 14250,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:203634:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [1] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Sealed Jewelry Crafter Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_jewelry.dds",
--            ["itemId"] = 153737,
--            ["purchasePrice"] = 9240,
--            ["timeRemaining"] = 2506218,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 280,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:153737:5:1:0:0:0:18:255:4:81:33:0:0:0:0:0:0:0:0:0:330750|h|h",
--        },
--        [2] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Kuta",
--            ["icon"] = "/esoui/art/icons/crafting_components_runestones_001.dds",
--            ["itemId"] = 45854,
--            ["purchasePrice"] = 106250,
--            ["timeRemaining"] = 2506265,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 25,
--            ["purchasePricePerUnit"] = 4250,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:45854:24:21:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [3] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Kuta",
--            ["icon"] = "/esoui/art/icons/crafting_components_runestones_001.dds",
--            ["itemId"] = 45854,
--            ["purchasePrice"] = 106250,
--            ["timeRemaining"] = 2506266,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 25,
--            ["purchasePricePerUnit"] = 4250,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:45854:24:21:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--    },
--    [742682] = {
--        [1] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Apocrypha Specimen Jar, Tomeshell Viscera",
--            ["icon"] = "/esoui/art/icons/housing_apc_inc_specimenjarscroll002.dds",
--            ["itemId"] = 198388,
--            ["purchasePrice"] = 3450,
--            ["timeRemaining"] = 2504016,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 3450,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:198388:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [2] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Sealed Jewelry Crafter Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_jewelry.dds",
--            ["itemId"] = 153738,
--            ["purchasePrice"] = 44197,
--            ["timeRemaining"] = 2506149,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 401.7910000000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:153738:6:1:0:0:0:24:255:5:679:29:0:0:0:0:0:0:0:0:0:1100000|h|h",
--        },
--        [3] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Sealed Jewelry Crafter Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_jewelry.dds",
--            ["itemId"] = 153738,
--            ["purchasePrice"] = 32000,
--            ["timeRemaining"] = 2506168,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 363.6360000000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:153738:6:1:0:0:0:24:255:5:323:21:0:0:0:0:0:0:0:0:0:880000|h|h",
--        },
--        [4] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Sealed Jewelry Crafter Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_jewelry.dds",
--            ["itemId"] = 153738,
--            ["purchasePrice"] = 44197,
--            ["timeRemaining"] = 2506146,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 401.7910000000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:153738:6:1:0:0:0:24:255:5:385:29:0:0:0:0:0:0:0:0:0:1100000|h|h",
--        },
--        [5] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Sealed Jewelry Crafter Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_jewelry.dds",
--            ["itemId"] = 153738,
--            ["purchasePrice"] = 35000,
--            ["timeRemaining"] = 2506159,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 388.8890000000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:153738:6:1:0:0:0:18:255:5:540:23:0:0:0:0:0:0:0:0:0:897600|h|h",
--        },
--        [6] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Style Page: Y'ffre's Fallen-Wood Cuirass",
--            ["icon"] = "/esoui/art/icons/quest_summerset_completed_report.dds",
--            ["itemId"] = 199053,
--            ["purchasePrice"] = 22500,
--            ["timeRemaining"] = 2503983,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 22500,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:199053:124:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [7] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Style Page: Opal Velidreth Sword",
--            ["icon"] = "/esoui/art/icons/quest_letter_002.dds",
--            ["itemId"] = 190108,
--            ["purchasePrice"] = 1950,
--            ["timeRemaining"] = 2503961,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 1950,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:190108:124:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [8] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Apocrypha Specimen Jar, Brains",
--            ["icon"] = "/esoui/art/icons/housing_apc_inc_specimenjarbrains001.dds",
--            ["itemId"] = 198382,
--            ["purchasePrice"] = 4750,
--            ["timeRemaining"] = 2504034,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 4750,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:198382:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [9] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Apocrypha Specimen Jar, Centipede",
--            ["icon"] = "/esoui/art/icons/housing_apc_inc_specimenjarcentipedes002.dds",
--            ["itemId"] = 198383,
--            ["purchasePrice"] = 3500,
--            ["timeRemaining"] = 2504040,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 3500,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:198383:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [10] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Sealed Provisioning Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_provisioning.dds",
--            ["itemId"] = 119693,
--            ["purchasePrice"] = 7500,
--            ["timeRemaining"] = 2506026,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 187.5000000000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:119693:5:1:0:0:0:71059:0:0:0:0:0:0:0:0:0:0:0:0:0:400000|h|h",
--        },
--        [11] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Sealed Provisioning Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_provisioning.dds",
--            ["itemId"] = 119693,
--            ["purchasePrice"] = 7500,
--            ["timeRemaining"] = 2506028,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 187.5000000000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:119693:5:1:0:0:0:71059:0:0:0:0:0:0:0:0:0:0:0:0:0:400000|h|h",
--        },
--        [12] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Sealed Jewelry Crafter Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_jewelry.dds",
--            ["itemId"] = 153737,
--            ["purchasePrice"] = 9800,
--            ["timeRemaining"] = 2506186,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 280,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:153737:5:1:0:0:0:18:255:4:92:33:0:0:0:0:0:0:0:0:0:346500|h|h",
--        },
--        [13] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Sealed Provisioning Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_provisioning.dds",
--            ["itemId"] = 119693,
--            ["purchasePrice"] = 7500,
--            ["timeRemaining"] = 2506030,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 187.5000000000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:119693:5:1:0:0:0:64221:0:0:0:0:0:0:0:0:0:0:0:0:0:400000|h|h",
--        },
--        [14] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Sealed Jewelry Crafter Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_jewelry.dds",
--            ["itemId"] = 153738,
--            ["purchasePrice"] = 45000,
--            ["timeRemaining"] = 2506138,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 401.7860000000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:153738:6:1:0:0:0:18:255:5:642:31:0:0:0:0:0:0:0:0:0:1122000|h|h",
--        },
--        [15] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Sealed Alchemy Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_alchemy.dds",
--            ["itemId"] = 119703,
--            ["purchasePrice"] = 17000,
--            ["timeRemaining"] = 2506042,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 3400,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:119703:5:1:0:0:0:199:8:11:2:0:0:0:0:0:0:0:0:0:0:50000|h|h",
--        },
--        [16] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Sealed Alchemy Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_alchemy.dds",
--            ["itemId"] = 119819,
--            ["purchasePrice"] = 17000,
--            ["timeRemaining"] = 2506048,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 3400,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:119819:5:1:0:0:0:199:18:10:2:0:0:0:0:0:0:0:0:0:0:50000|h|h",
--        },
--        [17] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Sealed Clothier Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_clothier.dds",
--            ["itemId"] = 121532,
--            ["purchasePrice"] = 20250,
--            ["timeRemaining"] = 2505936,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 250,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:121532:6:1:0:0:0:28:194:5:38:15:128:0:0:0:0:0:0:0:0:811200|h|h",
--        },
--        [18] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Sealed Alchemy Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_alchemy.dds",
--            ["itemId"] = 119696,
--            ["purchasePrice"] = 17000,
--            ["timeRemaining"] = 2506056,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 3400,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:119696:5:1:0:0:0:199:2:11:21:0:0:0:0:0:0:0:0:0:0:50000|h|h",
--        },
--        [19] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Style Page: Nord Carved Gauntlets",
--            ["icon"] = "/esoui/art/icons/quest_summerset_completed_report.dds",
--            ["itemId"] = 182469,
--            ["purchasePrice"] = 2500,
--            ["timeRemaining"] = 2503975,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 2500,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:182469:124:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [20] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Sealed Jewelry Crafter Writ",
--            ["icon"] = "/esoui/art/icons/master_writ_jewelry.dds",
--            ["itemId"] = 153738,
--            ["purchasePrice"] = 45000,
--            ["timeRemaining"] = 2506141,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 401.7860000000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:153738:6:1:0:0:0:18:255:5:148:32:0:0:0:0:0:0:0:0:0:1122000|h|h",
--        },
--        [21] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Style Page: Nord Carved Sabatons",
--            ["icon"] = "/esoui/art/icons/quest_summerset_completed_report.dds",
--            ["itemId"] = 182467,
--            ["purchasePrice"] = 7000,
--            ["timeRemaining"] = 2506099,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 7000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:182467:124:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [22] = {
--            ["displayQuality"] = 3,
--            ["name"] = "Recipe: Lava Foot Soup-and-Saltrice",
--            ["icon"] = "/esoui/art/icons/event_newlifefestival_2016_recipe.dds",
--            ["itemId"] = 96967,
--            ["purchasePrice"] = 27950,
--            ["timeRemaining"] = 2503915,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 27950,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:96967:4:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [23] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Style Page: Nord Carved Pauldrons",
--            ["icon"] = "/esoui/art/icons/quest_summerset_completed_report.dds",
--            ["itemId"] = 182466,
--            ["purchasePrice"] = 7000,
--            ["timeRemaining"] = 2506105,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 7000,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:182466:124:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [24] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Style Page: Nord Carved Cuirass",
--            ["icon"] = "/esoui/art/icons/quest_summerset_completed_report.dds",
--            ["itemId"] = 182457,
--            ["purchasePrice"] = 7500,
--            ["timeRemaining"] = 2506111,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 7500,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:182457:124:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [25] = {
--            ["displayQuality"] = 3,
--            ["name"] = "Breton Chamberstick, Short",
--            ["icon"] = "/esoui/art/icons/housing_bre_lsb_candleholdershort001.dds",
--            ["itemId"] = 116376,
--            ["purchasePrice"] = 6250,
--            ["timeRemaining"] = 2505889,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 6250,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:116376:4:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [26] = {
--            ["displayQuality"] = 4,
--            ["name"] = "Redguard Lantern, Delicate",
--            ["icon"] = "/esoui/art/icons/housing_red_lsb_hanginglanterninterior001.dds",
--            ["itemId"] = 117817,
--            ["purchasePrice"] = 14250,
--            ["timeRemaining"] = 2505899,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 14250,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:117817:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--        [27] = {
--            ["displayQuality"] = 5,
--            ["name"] = "Style Page: Morningstar Frostwear Epaulets",
--            ["icon"] = "/esoui/art/icons/quest_summerset_completed_report.dds",
--            ["itemId"] = 199084,
--            ["purchasePrice"] = 82950,
--            ["timeRemaining"] = 2503954,
--            ["itemUniqueId"] = 2.8357143408,
--            ["currencyType"] = 1,
--            ["stackCount"] = 1,
--            ["purchasePricePerUnit"] = 82950,
--            ["sellerName"] = "@ventrill",
--            ["itemLink"] = "|H0:item:199084:124:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
--        },
--    },
--}
