if Server then
local origrules = ARC.AcquireTarget //lua/ARC_Siege19.lua:2: attempt to index global 'ARC' (a nil value)
    function ARC:AcquireTarget() 
        local canfire = GetSetupConcluded()
        --Print("Arc can fire is %s", canfire)
            if not canfire then
                return 
            end
            
        return origrules(self)
    end
 end
