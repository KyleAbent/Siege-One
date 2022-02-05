local origIndex = GetMaterialXYOffset
function GetMaterialXYOffset(techId)
    if techId == kTechId.Redemption then
         return origIndex(kTechId.Hive)
    elseif techId == kTechId.Rebirth then
         return origIndex(kTechId.Egg)
    elseif techId == kTechId.Hunger then
         return origIndex(kTechId.EnzymeCloud)
    elseif techId == kTechId.ThickenedSkin then
         return origIndex(kTechId.Shell)
    elseif techId == kTechId.CragHiveTwo then
         return origIndex(kTechId.CragHive)
    elseif techId == kTechId.ShiftHiveTwo then
         return origIndex(kTechId.ShiftHive)
    else
        return origIndex(techId)
    end
    
end