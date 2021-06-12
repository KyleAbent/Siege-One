local networkVars = { 

}
   
local ogCreate = PowerPoint.OnCreate
 
function PowerPoint:OnCreate()
    ogCreate(self)

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
                        gameinfo:AddActivePower()
                    end
        end      
    end  
    
    
    
end
Shared.LinkClassToMap("PowerPoint", PowerPoint.kMapName, networkVars)