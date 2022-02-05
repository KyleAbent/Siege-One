Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")


local networkVars = {}


AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origIinit = Crag.OnInitialized
function Crag:OnInitialized()
    origIinit(self)
    InitMixin(self, AvocaMixin)
    InitMixin(self, LevelsMixin)
end


Shared.LinkClassToMap("Crag", Crag.kMapName, networkVars)
-----------------------------
Script.Load("lua/InfestationMixin.lua")

class 'CragAvoca' (Crag)
CragAvoca.kMapName = "cragavoca"

local networkVars = {}

AddMixinNetworkVars(InfestationMixin, networkVars)


function CragAvoca:OnInitialized()
    Crag.OnInitialized(self)
    --  InitMixin(self, LevelsMixin)
    InitMixin(self, InfestationMixin)
    InitMixin(self, AvocaMixin)
    self:SetTechId(kTechId.Crag)
end
    
--This is a messy override of the original function simply to remove the need to have only 1 crag healing the target.
function Crag:TryHeal(target)

    local unclampedHeal = target:GetMaxHealth() * Crag.kHealPercentage
    local heal = Clamp(unclampedHeal, Crag.kMinHeal, Crag.kMaxHeal)
    
    if self.healWaveActive then
        heal = heal * Crag.kHealWaveMultiplier
    end
                                        --lets allow stack by disabling only this
    if target:GetHealthScalar() ~= 1 then --and (not target.timeLastCragHeal or target.timeLastCragHeal + Crag.kHealInterval <= Shared.GetTime()) then
    
        local amountHealed = target:AddHealth(heal, false, false, false, self)
        target.timeLastCragHeal = Shared.GetTime()
        return amountHealed
        
    else
        return 0
    end
    
end

    
    
function CragAvoca:GetInfestationRadius()
    return 1
end    

function CragAvoca:GetTechId()
    return kTechId.Crag
end

function CragAvoca:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.Crag
    blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
    success = true
    end

    return success, blipType, blipTeam, isAttacked, false --isParasited
end



function CragAvoca:OnOrderGiven()
   if self:GetInfestationRadius() ~= 0 then self:SetInfestationRadius(0) end
end
Shared.LinkClassToMap("CragAvoca", CragAvoca.kMapName, networkVars)



