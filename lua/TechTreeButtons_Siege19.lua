local origIndex = GetMaterialXYOffset
function GetMaterialXYOffset(techId)
    if techId == kTechId.BigMac then
        return origIndex(kTechId.MAC)
    elseif techId == kTechId.BackupBattery then
         return origIndex(kTechId.PowerPoint) 
    elseif techId == kTechId.EggBeacon then
         return origIndex(kTechId.Shell)
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
    else
        return origIndex(techId)
    end
    
end