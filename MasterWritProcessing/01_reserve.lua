local MWP = MasterWritProcessing


-- 125 итемов
-- база 20 000
-- заточки
-- 2 - 250
-- 3 - 375
-- 4 - 500
-- 8 - 1000

MWP.reserveForItemCraft = {

    -- дерево
    -- -- базовое дерево 150-160 Ср
    [64502] = {
        ["count"] = 54,
        ["itemName"] = "Sanded Ruby Ash",
        ["itemLink"] = "|H0:item:64502:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 64502,
    },
    -- -- зеленая точка
    [54178] = {
        ["count"] = 8,
        ["itemName"] = "pitch",
        ["itemLink"] = "|H0:item:54178:31:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54178,
    },
    -- -- синяя точка
    [54179] = {
        ["count"] = 12,
        ["itemName"] = "turpen",
        ["itemLink"] = "|H0:item:54179:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54179,
    },
    -- -- фиол точка
    [54180] = {
        ["count"] = 16,
        ["itemName"] = "mastic",
        ["itemLink"] = "|H0:item:54180:33:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54180,
    },
    -- -- золотая точка
    [54181] = {
        ["count"] = 16,
        ["itemName"] = "rosin", -- золотая точка
        ["itemLink"] = "|H0:item:54181:34:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54181,
    },

    -- сталь
    -- -- база
    [64489] = {
        ["count"] = 53,
        ["itemLink"] = "|H0:item:64489:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 64489,
        ["itemName"] = "Rubedite Ingot",
    },
    -- -- зеленая точка
    [54170] = {
        ["count"] = 8,
        ["itemLink"] = "|H0:item:54170:31:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54170,
        ["itemName"] = "honing stone",
    },
    -- -- синяя точка
    [54171] = {
        ["count"] = 12,
        ["itemLink"] = "|H0:item:54171:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54171,
        ["itemName"] = "dwarven oil",
    },
    -- -- фиол точка
    [54172] = {
        ["count"] = 16,
        ["itemLink"] = "|H0:item:54172:33:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54172,
        ["itemName"] = "grain solvent",
    },
    -- -- золотая точка
    [54173] = {
        ["count"] = 16,
        ["itemLink"] = "|H0:item:54173:34:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 54173,
        ["itemName"] = "Tempering Alloy",
    },

    -- швея
    -- 64506 - кожа
    [64506] = {
        ["count"] = 39,
        ["itemLink"] = "|H0:item:64506:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "Rubedo Leather^ns",
        ["itemId"] = 64506,
    },

    -- 64504 - ткань
    [64504] = {
        ["count"] = 14,
        ["itemLink"] = "|H0:item:64504:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "Ancestor Silk^ns",
        ["itemId"] = 64504,
    },

    -- 54174
    -- -- зеленая точка
    [54174] = {
        ["count"] = 8,
        ["itemLink"] = "|H0:item:54174:31:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "hemming",
        ["itemId"] = 54174,
    },
    -- 54175
    -- -- синяя точка
    [54175] = {
        ["count"] = 12,
        ["itemLink"] = "|H0:item:54175:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "embroidery",
        ["itemId"] = 54175,
    },

    -- 54176
    -- -- фиол точка
    [54176] = {
        ["count"] = 16,
        ["itemLink"] = "|H0:item:54176:33:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "elegant lining",
        ["itemId"] = 54176,
    },

    -- 54177
    -- -- золотая точка
    [54177] = {
        ["count"] = 8,
        ["itemLink"] = "|H0:item:54177:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "dreugh wax",
        ["itemId"] = 54177,
    },

    -- ювелирка
    -- 135146 - платина
    [135146] = {
        ["count"] = 15,
        ["itemName"] = "platinum ounce",
        ["itemId"] = 135146,
        ["itemLink"] = "|H0:item:135146:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- 203631
    -- -- зеленая точка
    [203631] = {
        ["count"] = 2,
        ["itemName"] = "Terne Plating^n",
        ["itemId"] = 203631,
        ["itemLink"] = "|H0:item:203631:31:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- 203632
    -- -- синяя точка
    [203632] = {
        ["count"] = 3,
        ["itemName"] = "Iridium Plating^n",
        ["itemId"] = 203632,
        ["itemLink"] = "|H0:item:203632:32:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- 203633
    -- -- фиол точка
    [203633] = {
        ["count"] = 4,
        ["itemName"] = "Zircon Plating^n",
        ["itemId"] = 203633,
        ["itemLink"] = "|H0:item:203633:33:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },
    -- 203634
    -- -- золотая точка
    [203634] = {
        ["count"] = 8,
        ["itemName"] = "Chromium Plating^n",
        ["itemId"] = 203634,
        ["itemLink"] = "|H0:item:203634:34:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },

    --? зачарование

}

MVP.reserveForDailyCraft = {
    -- 30 000 = 20 персонажей. запас на 30 дней.
    -- дерево
    -- -- базовое дерево 150-160 Ср
    [64502] = {
        ["count"] = 30000,
        ["itemName"] = "Sanded Ruby Ash",
        ["itemLink"] = "|H0:item:64502:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 64502,
    },
    -- сталь
    -- -- база
    [64489] = {
        ["count"] = 30000,
        ["itemLink"] = "|H0:item:64489:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemId"] = 64489,
        ["itemName"] = "Rubedite Ingot",
    },
    -- швея
    -- 64506 - кожа
    [64506] = {
        ["count"] = 30000,
        ["itemLink"] = "|H0:item:64506:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "Rubedo Leather^ns",
        ["itemId"] = 64506,
    },
    -- 64504 - ткань
    [64504] = {
        ["count"] = 30000,
        ["itemLink"] = "|H0:item:64504:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
        ["itemName"] = "Ancestor Silk^ns",
        ["itemId"] = 64504,
    },
    -- ювелирка
    -- 135146 - платина
    [135146] = {
        ["count"] = 30000,
        ["itemName"] = "platinum ounce",
        ["itemId"] = 135146,
        ["itemLink"] = "|H0:item:135146:30:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
    },

    -- алхимия

    -- ? зачарование



}