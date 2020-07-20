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
    elseif techId == kTechId.DropArc then
         return origIndex(kTechId.ARC)
    else
        return origIndex(techId)
    end
    
end