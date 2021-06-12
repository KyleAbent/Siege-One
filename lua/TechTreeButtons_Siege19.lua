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
    elseif techId == kTechId.StructureBeacon then
         return origIndex(kTechId.Spur)
    elseif techId == kTechId.ArmoryBeefUp then
          return origIndex(kTechId.AdvancedArmory)
    elseif techId == kTechId.HiveLifeInsurance or techId == kTechId.AlienTechPointHive then
          return origIndex(kTechId.Hive)
    elseif techId == kTechId.AlienTechPoint then
          return origIndex(kTechId.TechPoint)
    elseif ( techId == kTechId.CystMenu or techId == kTechId.DoubleCystHP 
            or techId == kTechId.TripleCystHP or techId == kTechId.QuadrupleCystHP or techId == kTechId.DoubleCystArmor 
            or techId == kTechId.TripleCystArmor  or techId == kTechId.QuadrupleCystArmor ) then
            return origIndex(kTechId.Cyst)
    else
        return origIndex(techId)
    end
    
end