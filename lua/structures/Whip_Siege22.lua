Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")

local networkVars = {}


AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origIinit = Whip.OnInitialized
function Whip:OnInitialized()
    origIinit(self)
    InitMixin(self, AvocaMixin)
    InitMixin(self, LevelsMixin)
end

Shared.LinkClassToMap("Whip", Whip.kMapName, networkVars)

-----------------------------------------------------
Script.Load("lua/InfestationMixin.lua")
class 'WhipAvoca' (Whip)
WhipAvoca.kMapName = "whipavoca"

local networkVars = {}


AddMixinNetworkVars(InfestationMixin, networkVars)
function WhipAvoca:GetInfestationRadius()
    return 1
end
function WhipAvoca:OnOrderGiven()
   if self:GetInfestationRadius() ~= 0 then self:SetInfestationRadius(0) end
end
    function WhipAvoca:OnInitialized()
        Whip.OnInitialized(self)
        
        InitMixin(self, InfestationMixin)
        
        self:SetTechId(kTechId.Whip)
    end
    
    local origCreate = Whip.OnCreate
    function Whip:OnCreate()
        origCreate(self)
        if Server then
            InitMixin(self, OwnerMixin)
        end
    end
    
        function WhipAvoca:GetTechId()
         return kTechId.Whip
    end
   function WhipAvoca:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.Whip
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end
    function WhipAvoca:GetMaxLevel()
    return kAlienDefaultLvl
    end
    function WhipAvoca:GetAddXPAmount()
    return kAlienDefaultAddXp
    end
Shared.LinkClassToMap("WhipAvoca", WhipAvoca.kMapName, networkVars) 

local originit = Whip.OnInitialized
function Whip:OnInitialized()

originit(self)

if Server then
        local targetTypes = { kAlienStaticTargets, kAlienMobileTargets }
        self.slapTargetSelector = TargetSelector():Init(self, Whip.kRange, true, targetTypes, { self.SlapFilter(self) })
        self.bombardTargetSelector = TargetSelector():Init(self, Whip.kBombardRange, true, targetTypes, { self.BombFilter(self) })

end

end
/*
function Whip:OnTeleportEnd()
        local contamination = GetEntitiesWithinRange("Contamination", self:GetOrigin(), kInfestationRadius) 
        if contamination then self:Root() end
end
*/
function Whip:SlapFilter()

    local attacker = self
    return function (target, targetPosition) return attacker:GetCanSlap(target, targetPosition) end
    
end
function Whip:BombFilter()

    local attacker = self
    return function (target, targetPosition) return attacker:GetCanBomb(target, targetPosition) end
    
end
function Whip:GetCanSlap(target, targetPoint)    
    local range = Whip.kRange
    if target:isa("BreakableDoor") and target.health == 0  or (self:GetOrigin() -targetPoint):GetLength() > range  then
    return false
    end
    
    return true
    
end
function Whip:GetCanBomb(target, targetPoint)    
    local range = Whip.kBombardRange
    if target:isa("BreakableDoor") and target.health == 0  or (self:GetOrigin() -targetPoint):GetLength() > range or
       target:isa("Marine") and target.armor == 0 then
    return false
    end
    
    return true
    
end


    