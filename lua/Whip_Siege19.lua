
 function Whip:GetCanFireAtTargetActual(target, targetPoint)    

    if target:isa("BreakableDoor") and target.health == 0 then
    return false
    end
    
    return true
    
end

function Whip:GetMatureMaxHealth()
    return kMatureWhipHealth
end

function Whip:GetMatureMaxArmor()
    return kMatureWhipArmor
end    

function Whip:GetUnitNameOverride(viewer)
    

            return string.format( "Siege Whip" )


end
