Script.Load("lua/Weapons/Marine/Grenade.lua")-- Darn TechData saying Invalid Base Class without this line lol
class 'ExoGrenade' (Grenade)

ExoGrenade.kMapName = "exogrenade"
--Default
ExoGrenade.kRadius = 0.05
ExoGrenade.kDetonateRadius = 0.17
ExoGrenade.kMinLifeTime = 0
ExoGrenade.kClearOnImpact = true
ExoGrenade.kClearOnEnemyImpact = true
ExoGrenade.kNeedsHitEntity = false
ExoGrenade.kUseServerPosition = false

local kGrenadeCameraShakeDistance = 15
local kGrenadeMinShakeIntensity = 0.02
local kGrenadeMaxShakeIntensity = 0.13

local networkVars =
{
    chargedAmount = "integer (1 to 10)"
}

function ExoGrenade:OnCreate()

    Grenade.OnCreate(self)
    self.chargedAmount = 1

end

function ExoGrenade:SetChargeAmount(amt)--lol if 1 was the real 0
    amt = math.round(amt * 10)
    self.chargedAmount = Clamp(amt,1,10)
    --Print("ExoGrenade SetChargeAmount amt is %s", amt)
    --ExoGrenade.kRadius = 0.05 * (self.chargedAmount/10) + 0.05
    --Print("ExoGrenade SetChargeAmount kRadius is %s", ExoGrenade.kRadius)

end

function ExoGrenade:ProcessNearMiss( targetHit, endPoint )--Blow up without bounce
        if Server then
            self:Detonate( targetHit )
        end
        return true
end

function ExoGrenade:GetIntBonusPercent()
    local bonus = self.chargedAmount --( 1 * (self.chargedAmount/10) + 1 )
   -- Print("ExoGrenade GetIntBonusPercent is %s", bonus)
    return bonus
end

if Server then
        
    function ExoGrenade:ProcessHit(targetHit, surface, normal, endPoint )--Blow up without bounce

            self:Detonate(targetHit, hitPoint )
    end 


    function ExoGrenade:Detonate(targetHit)
    
        -- Do damage to nearby targets.
        local hitEntities = GetEntitiesWithMixinWithinRange("Live", self:GetOrigin(), kGrenadeLauncherGrenadeDamageRadius)
        
        -- Remove grenade and add firing player.
        table.removevalue(hitEntities, self)
        
        --half of default at start, so a full charge would equal to default.
        local dam = 90/2
        dam = dam *(self.chargedAmount/10) + dam
        if targetHit then
            table.removevalue(hitEntities, targetHit)
            self:DoDamage(dam, targetHit, self:GetOrigin(), GetNormalizedVector(targetHit:GetOrigin() - self:GetOrigin()), "none")
        end
        
         --half of default at start, so a full charge would equal to default.
        local radDam = 4.8/2
        radDam = radDam *(self.chargedAmount/10) + radDam
        RadiusDamage(hitEntities, self:GetOrigin(), radDam, dam, self)
        
        -- TODO: use what is defined in the material file
        local surface = GetSurfaceFromEntity(targetHit)
        
        local params = { surface = surface }
        params[kEffectHostCoords] = Coords.GetLookIn( self:GetOrigin(), self:GetCoords().zAxis)
        
        self:TriggerEffects("grenade_explode", params)
        
        CreateExplosionDecals(self)
        TriggerCameraShake(self, kGrenadeMinShakeIntensity, kGrenadeMaxShakeIntensity, kGrenadeCameraShakeDistance)
        
        DestroyEntity(self)
        
    end
   
end  






     
Shared.LinkClassToMap("ExoGrenade", ExoGrenade.kMapName, networkVars)
