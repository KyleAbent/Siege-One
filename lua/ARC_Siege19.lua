/*
local origCanFire = ARC.GetCanFireAtTarget
function ARC:GetCanFireAtTarget(target, targetPoint) 

    if not GetSetupConcluded() then
        return false
    else
        return origCanFire(self,target,targetPoint)
    end
    
end
 */

if Server then
local origrules = ARC.AcquireTarget
    function ARC:AcquireTarget() 
        local canfire = GetSetupConcluded()
        --Print("Arc can fire is %s", canfire)
            if not canfire then
                return 
            end
            
        return origrules(self)
    end
 end
