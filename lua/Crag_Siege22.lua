--Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")
Script.Load("lua/InfestationMixin.lua")

class 'CragAvoca' (Crag)
CragAvoca.kMapName = "cragavoca"

local networkVars = {}

--AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)
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



