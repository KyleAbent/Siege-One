//
// lua\Weapons\Alien\Rocket.lua

Script.Load("lua/Weapons/Projectile.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/DamageMixin.lua")
Script.Load("lua/Weapons/DotMarker.lua")
Script.Load("lua/Weapons/PredictedProjectile.lua")

class 'Rocket' (PredictedProjectile)

Rocket.kMapName            = "rocket"
Rocket.kModelName          = PrecacheAsset("models/alien/babbler/babbler.model")

// The max amount of time a Rocket can last for
Rocket.kRadius             = 0.05
Rocket.kDetonateRadius     = 0.35
Rocket.kClearOnImpact      = true
Rocket.kClearOnEnemyImpact = true

local kRocketLifetime = 0.5

local networkVars = { }

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)


function Rocket:TimeUp()
        self:TriggerEffects("bilebomb_hit")
        self:ProcessHit(nil)
        return false
end
function Rocket:OnCreate()

    PredictedProjectile.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, TeamMixin)
    InitMixin(self, DamageMixin)
    
    if Server then
        self:AddTimedCallback( self.TimeUp, 0.5 )
    end

end

function Rocket:GetProjectileModel()
    return Rocket.kModelName
end 

function Rocket:GetDeathIconIndex()
    return kDeathMessageIcon.Babbler
end

function Rocket:GetDamageType()
    return kAcidRocketDamageType
end

if Server then

    local function SineFalloff(distanceFraction)
        local piFraction = Clamp(distanceFraction, 0, 1) * math.pi / 2
        return math.cos(piFraction + math.pi) + 1 
    end
    
    function Rocket:ProcessHit(targetHit, surface, normal, endPoint)
             -- Do damage to nearby targets.
            local hitEntities = GetEntitiesWithMixinWithinRange("Live", self:GetOrigin(), kAcidRocketRadius)
            
            -- Remove rocket and firing player.
            local player = self:GetOwner()
            if player then
              table.removevalue(hitEntities, player)
            end
            table.removevalue(hitEntities, self)
            
            -- full damage on direct impact
            if targetHit then
                table.removevalue(hitEntities, targetHit)
                self:DoDamage(kAcidRocketDamage, targetHit, targetHit:GetOrigin(), GetNormalizedVector(targetHit:GetOrigin() - self:GetOrigin()), "none")
            end
            --          (entities,    centerOrigin,     radius,                  fullDamage,        doer, ignoreLOS, fallOffFunc)
            RadiusDamage(hitEntities, self:GetOrigin(), kAcidRocketRadius, kAcidRocketDamage, self, false, function() return 0 end )

            self:TriggerEffects("bilebomb_hit")
            DestroyEntity(self)
           
    end


end


Shared.LinkClassToMap("Rocket", Rocket.kMapName, networkVars)