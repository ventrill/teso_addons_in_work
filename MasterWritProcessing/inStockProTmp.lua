local MWP = MasterWritProcessing



function MasterWritProcessing.prepareInStockInfoList(selectedCharacterId)
    local list = {}
    list['total'] = {
        ['FreeSlots'] = 0,
        ['name'] = "total",
        ['all'] = 0,
        [CRAFTING_TYPE_BLACKSMITHING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_BLACKSMITHING)] = 0,
        [CRAFTING_TYPE_CLOTHIER] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_CLOTHIER)] = 0,
        [CRAFTING_TYPE_WOODWORKING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_WOODWORKING)] = 0,
        [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_JEWELRYCRAFTING)] = 0,
        [CRAFTING_TYPE_ALCHEMY] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_ALCHEMY)] = 0,
        [CRAFTING_TYPE_ENCHANTING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_ENCHANTING)] = 0,
        [CRAFTING_TYPE_PROVISIONING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_PROVISIONING)] = 0,
    }
    list['bank'] = {
        ['FreeSlots'] = MWP.getBankFreeSlots(),
        ['name'] = "bank",
        ['all'] = 0,
        [CRAFTING_TYPE_BLACKSMITHING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_BLACKSMITHING)] = 0,
        [CRAFTING_TYPE_CLOTHIER] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_CLOTHIER)] = 0,
        [CRAFTING_TYPE_WOODWORKING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_WOODWORKING)] = 0,
        [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_JEWELRYCRAFTING)] = 0,
        [CRAFTING_TYPE_ALCHEMY] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_ALCHEMY)] = 0,
        [CRAFTING_TYPE_ENCHANTING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_ENCHANTING)] = 0,
        [CRAFTING_TYPE_PROVISIONING] = 0,
        [MWP.getCraftTypeLabel(CRAFTING_TYPE_PROVISIONING)] = 0,
    }
    for characterId, characterName in pairs(MasterWritProcessing.characterNameList) do
        list[characterId] = {
            ['FreeSlots'] = MWP.savedVars.InventoryFeeSlotsCount[characterId] or 0,
            ['name'] = characterName,
            ['all'] = 0,
            [CRAFTING_TYPE_BLACKSMITHING] = 0,
            [MWP.getCraftTypeLabel(CRAFTING_TYPE_BLACKSMITHING)] = 0,
            [CRAFTING_TYPE_CLOTHIER] = 0,
            [MWP.getCraftTypeLabel(CRAFTING_TYPE_CLOTHIER)] = 0,
            [CRAFTING_TYPE_WOODWORKING] = 0,
            [MWP.getCraftTypeLabel(CRAFTING_TYPE_WOODWORKING)] = 0,
            [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
            [MWP.getCraftTypeLabel(CRAFTING_TYPE_JEWELRYCRAFTING)] = 0,
            [CRAFTING_TYPE_ALCHEMY] = 0,
            [MWP.getCraftTypeLabel(CRAFTING_TYPE_ALCHEMY)] = 0,
            [CRAFTING_TYPE_ENCHANTING] = 0,
            [MWP.getCraftTypeLabel(CRAFTING_TYPE_ENCHANTING)] = 0,
            [CRAFTING_TYPE_PROVISIONING] = 0,
            [MWP.getCraftTypeLabel(CRAFTING_TYPE_PROVISIONING)] = 0,
        }
    end

    if MWP.savedVars.InStock.InHouseBank then
        for HouseBankId, _ in pairs(MWP.savedVars.InStock.InHouseBank) do
            local cId = GetCollectibleForHouseBankBag(HouseBankId)
            local cName = GetCollectibleNickname(cId)
            if cName == "" then
                cName = GetCollectibleName(cId)
            end
            cName = ZO_CachedStrFormat(SI_COLLECTIBLE_NAME_FORMATTER, cName)

            list[HouseBankId] = {
                ['FreeSlots'] = MWP.savedVars.InventoryFeeSlotsCount[HouseBankId] or 0,
                ['name'] = cName,
                ['all'] = 0,
                [CRAFTING_TYPE_BLACKSMITHING] = 0,
                [MWP.getCraftTypeLabel(CRAFTING_TYPE_BLACKSMITHING)] = 0,
                [CRAFTING_TYPE_CLOTHIER] = 0,
                [MWP.getCraftTypeLabel(CRAFTING_TYPE_CLOTHIER)] = 0,
                [CRAFTING_TYPE_WOODWORKING] = 0,
                [MWP.getCraftTypeLabel(CRAFTING_TYPE_WOODWORKING)] = 0,
                [CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
                [MWP.getCraftTypeLabel(CRAFTING_TYPE_JEWELRYCRAFTING)] = 0,
                [CRAFTING_TYPE_ALCHEMY] = 0,
                [MWP.getCraftTypeLabel(CRAFTING_TYPE_ALCHEMY)] = 0,
                [CRAFTING_TYPE_ENCHANTING] = 0,
                [MWP.getCraftTypeLabel(CRAFTING_TYPE_ENCHANTING)] = 0,
                [CRAFTING_TYPE_PROVISIONING] = 0,
                [MWP.getCraftTypeLabel(CRAFTING_TYPE_PROVISIONING)] = 0,
            }
        end
    end



    if MWP.savedVars.InStock.InBank then
        for _, data in pairs(MWP.savedVars.InStock.InBank) do
            if data ~= nil and data ~= {} then
                local writItemLink = data.itemLink
                local writCraftType = MWP.getCraftType(writItemLink)
                local writCraftTypeLabel = MWP.getCraftTypeLabel(writCraftType)
                if not selectedCharacterId
                        or (selectedCharacterId and MWP.isDoable(writItemLink, selectedCharacterId)) then
                    list['total']['all'] = list['total']['all'] + 1;
                    list['total'][writCraftType] = list['total'][writCraftType] + 1;
                    list['total'][writCraftTypeLabel] = list['total'][writCraftTypeLabel] + 1;
                    list['bank']['all'] = list['bank']['all'] + 1;
                    list['bank'][writCraftType] = list['bank'][writCraftType] + 1;
                    list['bank'][writCraftTypeLabel] = list['bank'][writCraftTypeLabel] + 1;
                end
            end
        end
    end

    if MWP.savedVars.InStock.Characters then
        for characterId, InCharData in pairs(MWP.savedVars.InStock.Characters) do
            for _, Slots in pairs(InCharData) do
                --d(string.format("id %s", characterId))
                if Slots ~= nil and Slots ~= {} then
                    local writItemLink = Slots.itemLink
                    --d(writItemLink)
                    local writCraftType = MWP.getCraftType(writItemLink)
                    local writCraftTypeLabel = MWP.getCraftTypeLabel(writCraftType)
                    if not selectedCharacterId
                            or (selectedCharacterId and MWP.isDoable(writItemLink, selectedCharacterId)) then
                        list['total']['all'] = list['total']['all'] + 1;
                        list['total'][writCraftType] = list['total'][writCraftType] + 1;
                        list['total'][writCraftTypeLabel] = list['total'][writCraftTypeLabel] + 1;
                        list[characterId]['all'] = list[characterId]['all'] + 1;
                        list[characterId][writCraftType] = list[characterId][writCraftType] + 1;
                        list[characterId][writCraftTypeLabel] = list[characterId][writCraftTypeLabel] + 1;
                    end
                end
            end
        end
    end

    if MWP.savedVars.InStock.InHouseBank then
        for HouseBankId, InHouseBankData in pairs(MWP.savedVars.InStock.InHouseBank) do
            for _, Slots in pairs(InHouseBankData) do
                if Slots ~= nil and Slots ~= {} then
                    local writItemLink = Slots.itemLink
                    local writCraftType = MWP.getCraftType(writItemLink)
                    local writCraftTypeLabel = MWP.getCraftTypeLabel(writCraftType)
                    if not selectedCharacterId
                            or (selectedCharacterId and MWP.isDoable(writItemLink, selectedCharacterId)) then
                        list['total']['all'] = list['total']['all'] + 1;
                        list['total'][writCraftType] = list['total'][writCraftType] + 1;
                        list['total'][writCraftTypeLabel] = list['total'][writCraftTypeLabel] + 1;
                        list[HouseBankId]['all'] = list[HouseBankId]['all'] + 1;
                        list[HouseBankId][writCraftType] = list[HouseBankId][writCraftType] + 1;
                        list[HouseBankId][writCraftTypeLabel] = list[HouseBankId][writCraftTypeLabel] + 1;
                    end
                end
            end
        end
    end

    return list;
end