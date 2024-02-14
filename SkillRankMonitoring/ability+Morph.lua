-- https://www.esoui.com/forums/showthread.php?t=9592&highlight=ability+Morph

--- returns the abilityIndex for a given abilityId
function AG.GetAbility(abilityId)
    trace ('Searching Ability with ID %d', abilityId)


    -- local exists = DoesAbilityExist(abilityId)
    -- trace ('Ability exists: %s', tostring(exists))

    -- local  texName = GetAbilityIcon(abilityId)
    -- trace ('Ability texture: %s', texName)

    -- local st, si, ai, mc, ri = GetSpecificSkillAbilityKeysByAbilityId(abilityId)
    -- trace ('Specific keys: %d, %d, %d, %d', si, ai, mc, ri)

    -- Returns: boolean hasProgression, number progressionIndex, number lastRankXp, number nextRankXP, number currentXP, boolean atMorph
    local hasProgression, progressionIndex = GetAbilityProgressionXPInfoFromAbilityId(abilityId)

    trace ('Progression Index: %s,  %d', tostring(hasProgression), progressionIndex)

    if not hasProgression then
        trace('Ability with ID %d has no progression.', abilityId)
        return 0
    end


    -- Returns: string name, number morph, number rank
    local _, morph, rank = GetAbilityProgressionInfo(progressionIndex)

    -- Returns: string name, string texture, number abilityIndex
    local name, _, abilityIndex = GetAbilityProgressionAbilityInfo(progressionIndex, morph, rank)
    if abilityIndex then
        trace('Found ability %s with Index %d for ID %d.', name, abilityIndex, abilityId)
        return abilityIndex
    else
        trace('Did not find ability with ID %d.', abilityId)
        return 0
    end
end

function AG.LoadSkill(nr, slot)
    if not nr or not slot then return end

    local skillID = AG.setdata[nr].Skill[slot]

    -- TODO remove skill from bar, if set is locked and skillID == 0
    if skillID == 0 then return end

    local currentSkillID = GetSlotBoundId(slot+2)

    if skillID ~= currentSkillID then
        trace('SkillId in slot %d changed. Current: %d new: %d', slot, currentSkillID, skillID)
        local newAbilityIndex = AG.GetAbility(skillID)
        local currentAbilityIndex = AG.GetAbility(currentSkillID)

        if newAbilityIndex ~= 0 and currentAbilityIndex ~= newAbilityIndex then
            trace('AbilityIndex has changed, replacing. Current AI: %d, New AI: %d', currentAbilityIndex, newAbilityIndex)
            local res, msg = CallSecureProtected('SelectSlotAbility', newAbilityIndex, slot+2)

            if not res then
                -- d("|cFF0000Failed to set new skill. Message:|r "..(msg or "<none>"))
                d("|cFF0000Failed to set new skill due to a bug in ESO.|r Kill a mob and try again!")
            end
        end
    end
end

function AG.LoadBar(nr)
    if not nr then return end
    for slot = 1, 6 do AG.LoadSkill(nr,slot) end
end