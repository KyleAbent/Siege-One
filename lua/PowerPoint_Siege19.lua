local networkVars = { 
    alienTerritory = "boolean",
    marineTerritory = "boolean",
}
   
local ogCreate = PowerPoint.OnCreate
 
function PowerPoint:OnCreate()
    ogCreate(self)
     self.alienTerritory = true -- well it starts off as unbuilt which is definition of alien
     self.marineTerritory = false

end

if Server then

    local origKill = PowerPoint.OnKill
     function PowerPoint:OnKill(attacker, doer, point, direction) //Initial hive 
        origKill(self, attacker, doer, point, direction)
        local gameinfo = GetGameInfoEntity()
        if gameinfo then
            gameinfo:DeductActivePower()
        end
        
     end
     

     function PowerPoint:SetPoweringState(state)
         if state == true then
         --Print("Powering true!")
                    local gameinfo = GetGameInfoEntity()
                    if gameinfo then
                        if not GetSetupConcluded() then
                            self.marineTerritory = true
                            self.alienTerritory = false
                        end
                        gameinfo:AddActivePower(self.alienTerritory)
                    end
        end      
    end  
    
    
    
end
Shared.LinkClassToMap("PowerPoint", PowerPoint.kMapName, networkVars)