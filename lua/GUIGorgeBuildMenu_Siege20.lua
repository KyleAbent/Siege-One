---Haha I can't believe this works lol
function GorgeBuild_GetMaxNumStructure(techId)
    if techId == kTechId.GorgeWhip then
        return 1
    elseif techId == kTechId.GorgeCrag then
        return 1
    else
        return LookupTechData(techId, kTechDataMaxAmount, -1)
    end

end
