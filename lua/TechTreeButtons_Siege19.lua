local origIndex = GetMaterialXYOffset
function GetMaterialXYOffset(techId)
    if techId == kTechId.BigMac then
        return origIndex(kTechId.MAC)
    elseif techId == kTechId.BackupBattery then
         return origIndex(kTechId.SentryBattery) 
    elseif techId == kTechId.EggBeacon then
         return origIndex(kTechId.Shell)
    elseif techId == kTechId.Wall then
         return origIndex(kTechId.Door)
    else
        return origIndex(techId)
    end
    
end