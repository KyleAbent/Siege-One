---Less Calculation , Or . CragStack . Or . Lets See.
/*

Crag.kHealRadius = 14
Crag.kHealWaveAmount = 50
Crag.kMaxTargets = 3
Crag.kThinkInterval = .25
Crag.kHealInterval = 2
Crag.kHealEffectInterval = 1

Crag.kHealWaveDuration = 8

Crag.kHealPercentage = 0.042
Crag.kMinHeal = 7
Crag.kMaxHeal = 42
Crag.kHealWaveMultiplier = 1.3

For an onos with 1170 MAX HP (Max Biomass): 
    0.042 heal percentage is 49.14

*/


--Is it better to heal faster for less or slower for more? Healing more just seems weird to me. Although healing faster is calculation.

Crag.kHealPercentage =  0.059 --0.042 4%?
Crag.kMinHeal = 11--7
Crag.kMaxHeal = 59--42
Crag.kHealInterval = 1.7 -- 2


function Crag:TryHeal(target) --GorgeCrag , why you no call this. Bleh. lol.


     --lets remove the delay for heal for the target allowing stack
    if target:GetHealthScalar() ~= 1 then
    
        local unclampedHeal = target:GetMaxHealth() * Crag.kHealPercentage
        local heal = Clamp(unclampedHeal, Crag.kMinHeal, Crag.kMaxHeal)
        local tempHeal = heal
        
        
        if self.healWaveActive then
            heal = heal * Crag.kHealWaveMultiplier
        end
    
      --  if target.OnConstructionComplete then
          --  if target:GetIsOnFire() then
          --      return
          --  end
       -- end
       --	Change in TryHeal:
		--Structure cannot be healed if it is open fire
			--This is seperate than dissalowing crag to heal if crag is on fire

        
        local amountHealed = target:AddHealth(heal, false, false, false, self)
       -- if target:isa("Player") then
       --     Print("[0]Target: %s , [1] unclampedHeal is %s , [A] heal is %s , [B] heal is %s, [C]amountHealed is %s", target:GetClassName(), unclampedHeal, tempHeal, heal, amountHealed)
       -- end
        target.timeLastCragHeal = Shared.GetTime()
        return amountHealed
        
    else
        return 0
    end
    
    
end


function Crag:GetUnitNameOverride(viewer)
    

     return string.format( "Siege Crag(Stack)" )

end
