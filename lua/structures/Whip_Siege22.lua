Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")

local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origCreate = Whip.OnCreate
function Whip:OnCreate()
    origCreate(self)
    
end
local origIinit = Whip.OnInitialized
function Whip:OnInitialized()
    origIinit(self)
    InitMixin(self, LevelsMixin)
    InitMixin(self, AvocaMixin)
    if Server then
        GetImaginator().activeWhips = GetImaginator().activeWhips + 1  
    end    
end

function Whip:OnConstructionComplete()
    if Server then
        self:GiveUpgrade(kTechId.WhipBombard)
    end    
end

function Whip:GetMatureMaxHealth()
    return kMatureWhipHealth
end 


--Override
function Whip:GetHasUpgrade(what)
    return true
end

function Whip:GetMaxLevel()
    return 15
end

function Whip:GetAddXPAmount()
    return 1
end

if Server then
    --add xp
    local origFunc = Whip.OnAttackHit--Avoca --- :) 
    function Whip:OnAttackHit()
        local doProceed = false
        if self.attackStarted then
            origFunc(self)
            if self.targetId ~= Entity.invalidId then
                self:AddXP(self:GetAddXPAmount())
            end
       end
    end

end




if Server then

    function Whip:PreOnKill(attacker, doer, point, direction)
        GetImaginator().activeWhips  = GetImaginator().activeWhips - 1
    end

    function Whip:PostDoDamage(target,damage)
        if target then
            if damage == Whip.kDamage and target.GetIsAlive and target:GetIsAlive() then
                local levelBonusDmg = (Whip.kDamage * (self.level/100) + Whip.kDamage) - Whip.kDamage
                local targetPoint = target:GetEngagementPoint()
                local attackOrigin = self:GetEyePos()
                local hitDirection = targetPoint - attackOrigin
                local hitPosition = targetPoint - hitDirection * 0.5
                self:DoDamage(levelBonusDmg, target, hitPosition, hitDirection, nil, true)
                --Print("dmg bonus is %s", levelBonusDmg)
            end
        end
    end
    
    
    function Whip:OnOrderComplete(currentOrder)     
        --doChain(self)
            if GetIsImaginatorAlienEnabled() and not self:GetGameEffectMask(kGameEffect.OnInfestation) then
                //local cyst = CreateEntity(LoneCyst.kMapName, FindFreeSpace(self:GetOrigin(), 1, kCystRedeployRange),2)
                local notNearCyst = #GetEntitiesWithinRange("LoneCyst",self:GetOrigin(), kCystRedeployRange) == 0
                if notNearCyst then
                    local csyt = CreateEntity(LoneCyst.kMapName, FindFreeSpace(self:GetOrigin(), 1, kCystRedeployRange),2)
                end
            end
    end
    
    
    function Whip:OnEnterCombat() 
        if self.moving and GetIsImaginatorAlienEnabled() then  
            self:ClearOrders()
            self:GiveOrder(kTechId.Stop, nil, self:GetOrigin(), nil, true, true)  
            --doChain(self)
            local notNearCyst = #GetEntitiesWithinRange("LoneCyst",self:GetOrigin(), kCystRedeployRange) == 0
            if notNearCyst then
                local csyt = CreateEntity(LoneCyst.kMapName, FindFreeSpace(self:GetOrigin(), 1, kCystRedeployRange),2)
            end
        end
    end
    
end//Server

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