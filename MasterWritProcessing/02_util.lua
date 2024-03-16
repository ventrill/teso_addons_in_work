local MWP = MasterWritProcessing
local WW = WritWorthy

function MWP.getMotif(writItemLink)
    local writCraftType = MWP.getCraftType(writItemLink)
    if not MWP.isMotifNeeded(writCraftType) then
        return nil
    end
    local mat_list, know_list, parser = WW.ToMatKnowList(writItemLink)
    local motif = parser.motif_num
    if not motif then
        return
    end
    local chapter = parser.request_item.motif_page or ITEM_STYLE_CHAPTER_ALL
    local LCKI = LibCharacterKnowledgeInternal
    local itemId = LCKI.TranslateItem({ styleId = motif, chapterId = chapter })
    if itemId < 1 then
        --d(string.format("not found Motif motif num %s chapter %s", motif, chapter))
        local id2 = LCKI.TranslateItem({ styleId = motif, chapterId = ITEM_STYLE_CHAPTER_ALL })
        --d(string.format("not found Motif motif num %s chapter_all", motif))
        if id2 > 0 then
            itemId = id2
        end
    end
    local motifItemLink = LCKI.GetItemLink(itemId, LINK_STYLE_BRACKETS)
    return motifItemLink
end