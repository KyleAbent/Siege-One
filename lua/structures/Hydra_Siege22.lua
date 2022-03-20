Script.Load("lua/Additions/LevelsMixin.lua")


local networkVars = {}


AddMixinNetworkVars(LevelsMixin, networkVars)


local origIinit = Hydra.OnInitialized
function Hydra:OnInitialized()
    origIinit(self)
    InitMixin(self, AvocaMixin)
    InitMixin(self, LevelsMixin)
    if Server then
        self.targetSelector = TargetSelector():Init(
            self,
            Hydra.kRange, 
            true,
            { kAlienStaticTargets, kAlienMobileTargets }, { self.FilterTarget(self) } ) 
    end
end

function Hydra:FilterTarget(slap)

    local attacker = self
    return function (target, targetPosition) return attacker:GetCanFireAtTargetActual(target, targetPosition) end
    
end
function Hydra:GetCanFireAtTargetActual(target, targetPoint)    

    if target:isa("BreakableDoor") and target.health == 0 then
        return false
    end
    
    return true
    
end


function Hydra:GetLevelPercentage()
    return self.level / self:GetMaxLevel() * 2
end


function Hydra:GetMaxLevel()
    return 15
end

function Hydra:GetAddXPAmount()
    return 1
end

function Hydra:OnAdjustModelCoords(modelCoords)
    local coords = modelCoords
	local scale = self:GetLevelPercentage()
    if scale >= 1 then
        coords.xAxis = coords.xAxis * scale
        coords.yAxis = coords.yAxis * scale
        coords.zAxis = coords.zAxis * scale
    end
    return coords
end

function Hydra:OnAddXp(amount)
    
    self:AdjustMaxHealth(kMatureHydraHealth * (self.level/100) + kMatureHydraHealth) 
    self:AdjustMaxArmor(kMatureHydraArmor * (self.level/100) + kMatureHydraArmor)
    
end

function LevelsMixin:OnHealSpray(gorge) 
      self:AddXP(1)
end

function Hydra:PostDoDamage(target,damage)
    if target then
        if damage == Hydra.kDamage and target.GetIsAlive and target:GetIsAlive() then
            local levelBonusDmg = (Hydra.kDamage * (self.level/100) + Hydra.kDamage) - Hydra.kDamage
            local targetPoint = target:GetEngagementPoint()
            local attackOrigin = self:GetEyePos()
            local hitDirection = targetPoint - attackOrigin
            local hitPosition = targetPoint - hitDirection * 0.5
            self:DoDamage(levelBonusDmg, target, hitPosition, hitDirection, nil, true)
            --Print("dmg bonus is %s", levelBonusDmg)
        end
    end
end
    
if Server then

    function Hydra:OnDamageDone(doer, target)
        if self:GetIsAlive() and doer == self then
            self:AddXP(self:GetAddXPAmount())
        end
    end
    
end
Shared.LinkClassToMap("Hydra", Hydra.kMapName, networkVars)