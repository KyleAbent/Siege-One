local origIndex = GetMaterialXYOffset
function GetMaterialXYOffset(techId)
    if techId == kTechId.BackupBattery then
         return origIndex(kTechId.PowerPoint) 
    elseif techId == kTechId.EggBeacon then
         return origIndex(kTechId.Egg)
    elseif techId == kTechId.Wall then
         return origIndex(kTechId.Door)
    elseif techId == kTechId.DualWelderExosuit or techId == kTechId.DualFlamerExosuit or techId == kTechId.DualGrenaderExosuit then
         return origIndex(kTechId.Exo)
    elseif techId == kTechId.Redemption then
         return origIndex(kTechId.Hive)
    elseif techId == kTechId.Rebirth then
         return origIndex(kTechId.Egg)
    elseif techId == kTechId.Hunger then
         return origIndex(kTechId.EnzymeCloud)
    elseif techId == kTechId.ThickenedSkin then
         return origIndex(kTechId.Shell)
    elseif techId == kTechId.AdvancedBeacon or techId == kTechId.SiegeBeacon then
         return origIndex(kTechId.DistressBeacon)
    elseif techId == kTechId.LoneCyst then
         return origIndex(kTechId.Cyst)
    elseif techId == kTechId.CragHiveTwo then
         return origIndex(kTechId.CragHive)
    elseif techId == kTechId.ShiftHiveTwo then
         return origIndex(kTechId.ShiftHive)
    else
        return origIndex(techId)
    end
    
end