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
    
    
    
    
    /*
                --why isn't this at start?
    if target:GetHealthScalar() ~= 1 and (not target.timeLastCragHeal or target.timeLastCragHeal + Crag.kHealInterval <= Shared.GetTime()) then
    
        local unclampedHeal = target:GetMaxHealth() * Crag.kHealPercentage
        local heal = Clamp(unclampedHeal, Crag.kMinHeal, Crag.kMaxHeal)
        if target:isa("Player") then Print("[A] Heal is %s", heal) end 
        if self.healWaveActive then
            heal = heal * Crag.kHealWaveMultiplier
            if target:isa("Player") then Print("[B] Heal is %s", heal) end
        end
    
        local amountHealed = target:AddHealth(heal, false, false, false, self)
        target.timeLastCragHeal = Shared.GetTime()
        if target:isa("Player") then Print("[B] timeLastCragHeal is %s", timeLastCragHeal) end
        return amountHealed
        
    else
        return 0
    end
    */
    
end


function Crag:GetUnitNameOverride(viewer)
    

     return string.format( "Siege Crag(Stack)" )

end


--Copied from NS2GorgeTunnel GorgeToys Meteru to override :l

Script.Load("lua/DigestMixin.lua")

class 'GorgeCrag' (Crag)

GorgeCrag.kMapName = "gorgecrag"
GorgeCrag.kMaxUseableRange = 6.5

local networkVars =
{
    ownerId = "entityid"
}

local kDigestDuration = 1.5

function GorgeCrag:OnCreate()
	Crag.OnCreate(self)
    InitMixin(self, DigestMixin)
end

function GorgeCrag:GetUseMaxRange()
    return self.kMaxUseableRange
end

function GorgeCrag:GetTechButtons(techId)
    local techButtons = { kTechId.HealWave, kTechId.None, kTechId.CragHeal, kTechId.None,
                              kTechId.None, kTechId.None, kTechId.None, kTechId.None }
        
    return techButtons
    
end

if not Server then
    function Crag:GetOwner()
        return self.ownerId ~= nil and Shared.GetEntity(self.ownerId)
    end
end

function GorgeCrag:OnDestroy()
    AlienStructure.OnDestroy(self)
    if Server then
		local team = self:GetTeam()
        if team then
            team:UpdateClientOwnedStructures(self:GetId())
        end
		local player = self:GetOwner()
		if player then
			if (self.consumed) then
				player:AddResources(kGorgeCragCostDigest)
			else
				player:AddResources(kGorgeCragCostKill)
			end
		end
    end
end



-- CQ: Predates Mixins, somewhat hackish
function GorgeCrag:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = useSuccessTable.useSuccess and self:GetCanDigest(player)
end

function GorgeCrag:GetCanBeUsedConstructed()
    return true
end

function GorgeCrag:GetCanTeleportOverride()
    return false
end

function GorgeCrag:GetCanConsumeOverride()
    return false
end

function GorgeCrag:GetCanReposition()
    return false
end

function GorgeCrag:GetCanDigest(player)
    return player == self:GetOwner() and player:isa("Gorge") and (not HasMixin(self, "Live") or self:GetIsAlive())
end

function GorgeCrag:GetDigestDuration()
    return kDigestDuration
end

function GorgeCrag:OnOverrideOrder(order)
    --if self.ownerId ~= nil then
        order:SetType(kTechId.Default)
    --elseif order:GetType() == kTechId.Default then
    --    order:SetType(kTechId.Move)
    --end
end

function GorgeCrag:GetMapBlipType()
    return kMinimapBlipType.Crag
end

Shared.LinkClassToMap("GorgeCrag", GorgeCrag.kMapName, networkVars)