local oninit = Whip.OnInitialized
function Whip:OnInitialized()
    oninit(self)
     GetImaginator().activeWhips = GetImaginator().activeWhips + 1  
end

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


if Server then

    function Whip:OnOrderComplete(currentOrder)     
        --doChain(self)
            if GetIsImaginatorAlienEnabled() and not self:GetGameEffectMask(kGameEffect.OnInfestation) then
                local cyst = CreateEntity(Cyst.kMapName, FindFreeSpace(self:GetOrigin(), 1, kCystRedeployRange),2)
            end
    end
    
    
    function Whip:OnEnterCombat() 
        if self.moving and GetIsImaginatorAlienEnabled() then  
            self:ClearOrders()
            self:GiveOrder(kTechId.Stop, nil, self:GetOrigin(), nil, true, true)  
            --doChain(self)
            if not self:GetGameEffectMask(kGameEffect.OnInfestation) then
                local cyst = CreateEntity(Cyst.kMapName, FindFreeSpace(self:GetOrigin(), 1, kCystRedeployRange),2)
            end
        end
    end
    
end//Server


 function Whip:PreOnKill(attacker, doer, point, direction)
      
	    GetImaginator().activeWhips  = GetImaginator().activeWhips - 1
end


function Whip:GetCanTeleportOverride()
    return not self:GetIsInCombat()
end
