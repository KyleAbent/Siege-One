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
    elseif techId == kTechId.LoneCyst then
         return origIndex(kTechId.Cyst)
    elseif techId == kTechId.EggBeacon then
         return origIndex(kTechId.Egg)
    elseif techId == kTechId.StructureBeacon then
         return origIndex(kTechId.Spur)
    elseif techId == kTechId.AlienTechPoint then
          return origIndex(kTechId.Hive)
    elseif techId == kTechId.CystMenu then
          return origIndex(kTechId.Cyst)
    elseif techId == kTechId.CragMenu then
          return origIndex(kTechId.Crag)
    elseif techId == kTechId.WhipMenu then
          return origIndex(kTechId.Whip)
    elseif techId == kTechId.ShiftMenu then
          return origIndex(kTechId.Shift)
    elseif techId == kTechId.ShadeMenu then
          return origIndex(kTechId.Shade)
    elseif techId == kTechId.CragStackOne then
          return origIndex(kTechId.HealWave)
    elseif techId == kTechId.CragStackTwo then
      return origIndex(kTechId.HealWave)      
    elseif techId == kTechId.CragStackThree then
      return origIndex(kTechId.HealWave)  
    elseif techId == kTechId.AlienTechPointHive then
      return origIndex(kTechId.Hive)  
   -- elseif techId == kTechId.DropARC then
     -- return origIndex(kTechId.ARC)  
    elseif techId == kTechId.AdvancedBeacon then
      return origIndex(kTechId.DistressBeacon)  
    elseif techId == kTechId.SiegeBeacon then
      return origIndex(kTechId.DistressBeacon)  
    else
        return origIndex(techId)
    end
    
end