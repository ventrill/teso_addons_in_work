local MWP = MasterWritProcessing

local baseMatCount = 200000;
local boostGreen = 250; -- зеленая точка
local boostBlue = 375;  -- синяя точка
local boostFiol = 1500; -- фиол точка
local boostGold = 11000; -- золотая точка


MWP.reserveForItemCraft = {
--[[
    -- 125 итемов
    -- база 20 000
    -- заточки
    -- 2 - 250
    -- 3 - 375
    -- 4 - 500
    -- 8 - 1000
]]

    -- дерево -- базовое дерево 150-160 Ср
    [64502] = {
        ["count"] = baseMatCount,
        ["itemName"] = "Sanded Ruby Ash",
        ["itemLink"] = "|H0:item:64502:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 64502,
    },
    -- дерево -- зеленая точка
    [54178] = {
        ["count"] = boostGreen,
        ["itemName"] = "pitch",
        ["itemLink"] = "|H0:item:54178:31:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54178,
    },
    -- дерево -- синяя точка
    [54179] = {
        ["count"] = boostBlue,
        ["itemName"] = "turpen",
        ["itemLink"] = "|H0:item:54179:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54179,
    },
    -- дерево -- фиол точка
    [54180] = {
        ["count"] = boostFiol,
        ["itemName"] = "mastic",
        ["itemLink"] = "|H0:item:54180:33:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54180,
    },
    -- дерево -- золотая точка
    [54181] = {
        ["count"] = boostGold,
        ["itemName"] = "rosin", -- золотая точка
        ["itemLink"] = "|H0:item:54181:34:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54181,
    },
    -- сталь -- база
    [64489] = {
        ["count"] = baseMatCount,
        ["itemLink"] = "|H0:item:64489:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 64489,
        ["itemName"] = "Rubedite Ingot",
    },
    -- сталь -- зеленая точка
    [54170] = {
        ["count"] = boostGreen,
        ["itemLink"] = "|H0:item:54170:31:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54170,
        ["itemName"] = "honing stone",
    },
    -- сталь -- синяя точка
    [54171] = {
        ["count"] = boostBlue,
        ["itemLink"] = "|H0:item:54171:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54171,
        ["itemName"] = "dwarven oil",
    },
    -- сталь -- фиол точка
    [54172] = {
        ["count"] = boostFiol,
        ["itemLink"] = "|H0:item:54172:33:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54172,
        ["itemName"] = "grain solvent",
    },
    -- сталь -- золотая точка
    [54173] = {
        ["count"] = boostGold,
        ["itemLink"] = "|H0:item:54173:34:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54173,
        ["itemName"] = "Tempering Alloy",
    },
    -- швея -- 64506 - кожа
    [64506] = {
        ["count"] = baseMatCount,
        ["itemLink"] = "|H0:item:64506:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "Rubedo Leather^ns",
        ["itemId"] = 64506,
    },
    -- швея -- 64504 - ткань
    [64504] = {
        ["count"] = baseMatCount,
        ["itemLink"] = "|H0:item:64504:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "Ancestor Silk^ns",
        ["itemId"] = 64504,
    },
    -- швея -- зеленая точка
    [54174] = {
        ["count"] = boostGreen,
        ["itemLink"] = "|H0:item:54174:31:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "hemming",
        ["itemId"] = 54174,
    },
    -- швея -- синяя точка
    [54175] = {
        ["count"] = boostBlue,
        ["itemLink"] = "|H0:item:54175:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "embroidery",
        ["itemId"] = 54175,
    },
    -- швея -- фиол точка
    [54176] = {
        ["count"] = boostFiol,
        ["itemLink"] = "|H0:item:54176:33:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "elegant lining",
        ["itemId"] = 54176,
    },
    -- швея -- золотая точка
    [54177] = {
        ["count"] = boostGold,
        ["itemLink"] = "|H0:item:54177:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "dreugh wax",
        ["itemId"] = 54177,
    },
    -- ювелирка -- платина
    [135146] = {
        ["count"] = baseMatCount,
        ["itemName"] = "platinum ounce",
        ["itemId"] = 135146,
        ["itemLink"] = "|H0:item:135146:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- ювелирка -- зеленая точка
    [203631] = {
        ["count"] = boostGreen,
        ["itemName"] = "Terne Plating",
        ["itemId"] = 203631,
        ["itemLink"] = "|H0:item:203631:31:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- ювелирка -- синяя точка
    [203632] = {
        ["count"] = boostBlue,
        ["itemName"] = "Iridium Plating",
        ["itemId"] = 203632,
        ["itemLink"] = "|H0:item:203632:32:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- ювелирка -- фиол точка
    [203633] = {
        ["count"] = boostFiol,
        ["itemName"] = "Zircon Plating",
        ["itemId"] = 203633,
        ["itemLink"] = "|H0:item:203633:33:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- ювелирка -- золотая точка
    [203634] = {
        ["count"] = boostGold,
        ["itemName"] = "Chromium Plating",
        ["itemId"] = 203634,
        ["itemLink"] = "|H0:item:203634:34:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },

    --? зачарование

}

local dailyMatReserve = 30000
local dailyAlchemyAdditionalMatReserve = 1000
local dailyEnchantAdditionalMatReserve = 1000
local dailyEnchantCraftMatReserve = 1000 -- @todo кол-во и материалы не известны

MWP.reserveForDailyCraft = {
    -- 30 000 = 20 персонажей. запас на 30 дней. по 40 на раз 24000 + 6000 буфер
    -- дерево -- базовое дерево 150-160 Ср
    [64502] = {
        ["count"] = dailyMatReserve,
        ["itemName"] = "Sanded Ruby Ash",
        ["itemLink"] = "|H0:item:64502:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 64502,
    },
    -- сталь -- база
    [64489] = {
        ["count"] = dailyMatReserve,
        ["itemLink"] = "|H0:item:64489:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 64489,
        ["itemName"] = "Rubedite Ingot",
    },
    -- швея -- 64506 - кожа
    [64506] = {
        ["count"] = dailyMatReserve,
        ["itemLink"] = "|H0:item:64506:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "Rubedo Leather^ns",
        ["itemId"] = 64506,
    },
    -- швея -- 64504 - ткань
    [64504] = {
        ["count"] = dailyMatReserve,
        ["itemLink"] = "|H0:item:64504:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "Ancestor Silk^ns",
        ["itemId"] = 64504,
    },
    -- ювелирка -- 135146 - платина
    [135146] = {
        ["count"] = dailyMatReserve,
        ["itemName"] = "platinum ounce",
        ["itemId"] = 135146,
        ["itemLink"] = "|H0:item:135146:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- алхимия -- "violet coprinus" - доп итем для квеста
    [30152] = {
        ["count"] = dailyAlchemyAdditionalMatReserve,
        ["itemName"] = "violet coprinus",
        ["itemId"] = 30152,
        ["itemLink"] = "|H0:item:30152:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- алхимия -- mudcrab chitin - доп итем для квеста
    [77591] = {
        ["count"] = dailyAlchemyAdditionalMatReserve,
        ["itemName"] = "mudcrab chitin",
        ["itemId"] = 77591,
        ["itemLink"] = "|H0:item:77591:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- алхимия -- Nirnroot - доп итем для квеста
    [30165] = {
        ["count"] = dailyAlchemyAdditionalMatReserve,
        ["itemName"] = "Nirnroot",
        ["itemId"] = 30165,
        ["itemLink"] = "|H0:item:30165:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- зачарование -- Ta - доп итем для квеста
    [45850] = {
        ["count"] = dailyEnchantAdditionalMatReserve,
        ["itemName"] = "Ta",
        ["itemId"] = 45850,
        ["itemLink"] = "|H1:item:45850:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- зачарование -- Oko - доп итем для квеста
    [45831] = {
        ["count"] = dailyEnchantAdditionalMatReserve,
        ["itemName"] = "Oko",
        ["itemId"] = 45831,
        ["itemLink"] = "|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
}