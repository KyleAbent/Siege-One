--=============================================================================
--
-- lua\Weapons\Alien\Bomb.lua
--
-- Created by Charlie Cleveland (charlie@unknownworlds.com)
-- Copyright (c) 2011, Unknown Worlds Entertainment, Inc.
--
-- Bile bomb projectile
--
--=============================================================================

Script.Load("lua/Weapons/Projectile.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/Weapons/DotMarker.lua")
Script.Load("lua/Weapons/PredictedProjectile.lua")

PrecacheAsset("cinematics/vfx_materials/decals/bilebomb_decal.surface_shader")

class 'LerkBomb' (PredictedProjectile)

LerkBomb.kMapName            = "lerkbomb"
LerkBomb.kModelName          = PrecacheAsset("models/alien/gorge/bilebomb.model")

LerkBomb.kRadius             = 0.2
LerkBomb.kClearOnImpact      = false
LerkBomb.kClearOnEnemyImpact = false
--LerkBomb.bounce = 2
--LerkBomb.gravity = 19
--LerkBomb.velocity = 0
LerkBomb.kNeedsHitEntity      = false
LerkBomb.kUseServerPosition = true

--LerkBomb max amount of time a Bomb can last for
LerkBomb.kLifetime = 3

local networkVars = { }

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)

function LerkBomb:OnCreate()
    
    PredictedProjectile.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, TeamMixin)
    
    if Server then
        self:AddTimedCallback(LerkBomb.TimeUp, LerkBomb.kLifetime)
    end
                
end

function LerkBomb:GetDeathIconIndex()
    return kTechId.BileBomb
end

if Server then

    local function SineFalloff(distanceFraction)
        local piFraction = Clamp(distanceFraction, 0, 1) * math.pi / 2
        return math.cos(piFraction + math.pi) + 1 
    end
        
     function LerkBomb:ProcessHit(targetHit, surface, normal, endPoint )

        return
           
     end
        
        
     function LerkBomb:Detonate(targetHit)
        
        local dotMarker = CreateEntity(DotMarker.kMapName, self:GetOrigin() , self:GetTeamNumber())
		dotMarker:SetTechId(kTechId.BileBomb)
		dotMarker:SetDamageType(kBileBombDamageType)        
        dotMarker:SetLifeTime(kBileBombDuration)
        dotMarker:SetDamage(kBileBombDamage * 0.7 )
        dotMarker:SetRadius(kBileBombSplashRadius)
        dotMarker:SetDamageIntervall(kBileBombDotInterval * 0.7)
        dotMarker:SetDotMarkerType(DotMarker.kType.Static)
        dotMarker:SetTargetEffectName("bilebomb_onstructure")
        dotMarker:SetDeathIconIndex(kDeathMessageIcon.BileBomb)
        dotMarker:SetOwner(self:GetOwner())
        dotMarker:SetFallOffFunc(SineFalloff)
        
        dotMarker:TriggerEffects("bilebomb_hit")
        CreateExplosionDecals(dotMarker, "bilebomb_decal")
        DestroyEntity(self)
        
        

    end
    


end


function LerkBomb:TimeUp()

    self:Detonate()
    return false
end
    
    
function LerkBomb:GetNotifiyTarget()
    return false
end


Shared.LinkClassToMap("LerkBomb", LerkBomb.kMapName, networkVars)