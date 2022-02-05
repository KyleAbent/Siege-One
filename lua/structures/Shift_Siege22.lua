Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")

local networkVars = {}


AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origIinit = Shift.OnInitialized
function Shift:OnInitialized()
    origIinit(self)
    InitMixin(self, AvocaMixin)
    InitMixin(self, LevelsMixin)
end


Shared.LinkClassToMap("Shift", Shift.kMapName, networkVars)


--------------------
Script.Load("lua/InfestationMixin.lua")

class 'ShiftAvoca' (Shift)
ShiftAvoca.kMapName = "shiftavoca"

local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)
AddMixinNetworkVars(InfestationMixin, networkVars)
function ShiftAvoca:GetInfestationRadius()
    return 1
end
    function ShiftAvoca:OnInitialized()
     Shift.OnInitialized(self)
       InitMixin(self, InfestationMixin)
         InitMixin(self, LevelsMixin)
        InitMixin(self, AvocaMixin)
        self:SetTechId(kTechId.Shift)
    end
    function ShiftAvoca:OnOrderGiven()
   if self:GetInfestationRadius() ~= 0 then self:SetInfestationRadius(0) end
end
        function ShiftAvoca:GetTechId()
         return kTechId.Shift
    end
   function ShiftAvoca:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.Shift
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end
    function ShiftAvoca:GetMaxLevel()
    return kAlienDefaultLvl
    end
    function ShiftAvoca:GetAddXPAmount()
    return kAlienDefaultAddXp
    end

Shared.LinkClassToMap("ShiftAvoca", ShiftAvoca.kMapName, networkVars)