//Kyle 'Avoca' Abent

//These should reference Functions19.lua rather than powerpoint but w/e

local networkVars = { 

discoEnabled = "boolean",
}

function PowerPoint:ToggleDisco()
    print("Toggling Disco")
    self.discoEnabled = not self.discoEnabled
end

function PowerPoint:EnableDisco()
    print("Enabling Disco")
    self.discoEnabled = true
end

function PowerPoint:DisableDisco()
    print("Disabling Disco")
    self.discoEnabled = false
end

function PowerPoint:GetIsDisco()

    if self.discoEnabled then
        // print("PP GetIsDisco is true")
        return true
    end
//print("PP GetIsDisco is false")
end

local origInit = PowerPoint.OnInitialized
function PowerPoint:OnInitialized()
    origInit(self)
    self.discoEnabled = false
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