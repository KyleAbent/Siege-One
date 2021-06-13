Script.Load("lua/2019/Con_Vars.lua")

local networkVars = { 

lastWave = "time",
}

local originit = Crag.OnInitialized
function Crag:OnInitialized()
    originit(self)
    self.lastWave = 0
end

function Crag:GetIsWaveAllowed()
    return GetIsTimeUp(self.lastWave, kHealWaveCooldown)
end
function Crag:JustWavedNowSetTimer()
    self.lastWave = Shared.GetTime()//Although should be global in conductor like shadeink is , rather than for every crag having its own unique delay
end

local function ManageHealWave(self)
    for _, entity in ipairs( GetEntitiesWithMixinForTeamWithinRange("Combat", 2, self:GetOrigin(),Crag.kHealRadius) ) do
                 if entity ~= self and entity:GetIsInCombat() and entity:GetHealthScalar() <= .9  then
                         self:TriggerHealWave()
                         //if self.moving then 
                            //self:ClearOrders()
                        //end
                        self:JustWavedNowSetTimer()
                        break//Only trigger once , not for every ... lol
                end
      end
end

function Crag:InstructSpecificRules()
    if self:GetIsWaveAllowed() and not self:GetIsOnFire() and GetIsUnitActive(self) then
        ManageHealWave(self)
    end
end

 function Crag:OnConstructionComplete()
	 GetImaginator().activeCrags = GetImaginator().activeCrags + 1;  
end

function Crag:PreOnKill(attacker, doer, point, direction)
  if self:GetIsBuilt() then
    GetImaginator().activeCrags  = GetImaginator().activeCrags- 1;  
  end
end

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



if Server then

    function Crag:ManageCrags()
    
           self:InstructSpecificRules()
           if self:GetCanTeleport() then    
                local destination = findDestinationForAlienConst(self)
                if destination then 
                    self:TriggerTeleport(5, self:GetId(), FindFreeSpace(destination:GetOrigin(), 4), 0)
                    return
                end
            end
        
    end


end//server
local origUpdate = Crag.OnUpdate 

function Crag:OnUpdate(deltaTime)
    origUpdate(self,deltaTime)
     if Server then
        if not self.manageCragsTime or self.manageCragsTime + kManageCragInterval <= Shared.GetTime() then
            if GetIsImaginatorAlienEnabled() and GetConductor():GetIsCragMovementAllowed() then
                self:ManageCrags()
                GetConductor():JustMovedCragSetTimer()
            end
            self.manageCragsTime = Shared.GetTime()
        end
     end
        
end

function Crag:GetCanTeleportOverride()
    if GetIsImaginatorAlienEnabled() then
        return not self:GetIsInCombat()
     else
        return true
    end
end

Shared.LinkClassToMap("Crag", Crag.kMapName, networkVars)