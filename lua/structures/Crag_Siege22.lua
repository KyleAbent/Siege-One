Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")


local networkVars = {
cragstacklevel = "integer",
}


AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origIinit = Crag.OnInitialized
function Crag:OnInitialized()
    origIinit(self)
    InitMixin(self, AvocaMixin)
    InitMixin(self, LevelsMixin)
    self.cragstacklevel = 0
end

---------------------------Cragstack overriding original code taken from Crag.lua---------------------

function Crag:GetCragsNearBy()

    local targets = {}

    for _, crag in ipairs(GetEntitiesForTeamWithinRange("Crag", self:GetTeamNumber(), self:GetOrigin(), Crag.kHealRadius)) do
        if crag ~= self and GetIsUnitActive(crag) then
            table.insert(targets, crag)
            if #targets >=3 then
                return #targets
            end    
        end

    end

    return #targets

end

--Override and modify functions from Crag.lua
function Crag:TryHeal(target)

    local unclampedHeal = target:GetMaxHealth() * Crag.kHealPercentage
    local heal = Clamp(unclampedHeal, Crag.kMinHeal, Crag.kMaxHeal)
    
    if self.healWaveActive then
        heal = heal * Crag.kHealWaveMultiplier
    end
    
    if self.cragstacklevel == 0 or self.cragstacklevel ~= 3 then
        if GetHasTech(self, kTechId.CragStackThree)  then
            self.cragstacklevel = 3
        elseif GetHasTech(self, kTechId.CragStackTwo) then
            self.cragstacklevel =  2
        elseif GetHasTech(self, kTechId.CragStackOne) then
            self.cragstacklevel = 1
        end
    end
    --local prevheal = heal
    --local nearby = -1
    if self.cragstacklevel ~= 0 then
        NumCragsNearBy = self:GetCragsNearBy()
        --nearby = NumCragsNearBy
        local bonusPercent = -1
        if NumCragsNearBy >= 1 then--Max 3 (30%)
            multiplyBy = Clamp(NumCragsNearBy, 1, self.cragstacklevel)--Obey only what's researched.
            bonusPercent = 10*multiplyBy
            heal = heal * (bonusPercent/100) +heal
            --Print("PrevHeal: %s,  Heal: %s, CragStackLevel: %s, NumCragsNearby %s, HealBonusPercent: %s", prevheal, heal, self.cragstacklevel, nearby, bonusPercent)
        end
        
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


