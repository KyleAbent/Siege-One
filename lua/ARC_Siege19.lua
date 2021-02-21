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
