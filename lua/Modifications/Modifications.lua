if Server then 

    local function AddFullScore(attacker, victim)
        local points = victim and victim:GetPointValue() or 0
        if HasMixin(attacker, "Scoring") then 
            attacker:AddScore(points)
        end
    end
    
    local origkill = LiveMixin.Kill
    function LiveMixin:Kill(attacker, doer, point, direction)
    
        if self:GetIsAlive() and self:GetCanDie() then
            ---Rebirth
            if self:isa("Alien") then
                if GetHasRebirthUpgrade(self) and self:GetEligableForRebirth() then
                    AddFullScore(attacker, self )
                    self:TriggerRebirth()
                    return
                end
            end

            --Hunger
            if self:GetTeamNumber() == 1 then 
                if self:isa("Player")  then
                    if attacker and attacker:isa("Alien") and attacker:isa("Player") and GetHasHungerUpgrade(attacker) then
                        local duration = 6
                        if attacker:isa("Onos") then
                            duration = duration * .7
                        end
                        attacker:TriggerEnzyme(duration)
                        attacker:AddEnergy(attacker:GetMaxEnergy() * .10 )
                        attacker:AddHealth(attacker:GetHealth() * (10/100))
                    end
                elseif ( HasMixin(self, "Construct") or self:isa("ARC") or self:isa("MAC") ) and attacker and attacker:isa("Player") then 
                    if GetHasHungerUpgrade(attacker) and attacker:isa("Gorge") and doer:isa("DotMarker") then 
                        attacker:TriggerEnzyme(5)
                        attacker:AddEnergy(attacker:GetMaxEnergy() * .10)
                    end
                end
            end 
        end  
   
    return origkill(self, attacker, doer, point, direction)
    end
    
    




end