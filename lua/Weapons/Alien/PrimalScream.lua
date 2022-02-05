// NS2 - Classic -- Modified for siege ofc -- thanks dragon
// lua\Weapons\Alien\Umbra.lua
//

Script.Load("lua/Weapons/Alien/Ability.lua")
Script.Load("lua/Weapons/Alien/LerkBite.lua")
Script.Load("lua/Weapons/Alien/LerkBomb.lua")
Script.Load("lua/Weapons/ClientWeaponEffectsMixin.lua")

Shared.PrecacheSurfaceShader("materials/effects/mesh_effects/view_blood.surface_shader")

local kStructureHitEffect = PrecacheAsset("cinematics/alien/lerk/bite_view_structure.cinematic")
local kMarineHitEffect = PrecacheAsset("cinematics/alien/lerk/bite_view_marine.cinematic")

local kCinematic = PrecacheAsset("cinematics/alien/lerk/primal2.cinematic")
local kSound = PrecacheAsset("sound/NS2.fev/alien/lerk/taunt")

class 'Primal' (Ability)

Primal.kMapName = "primal"

local kAnimationGraph = PrecacheAsset("models/alien/lerk/lerk_view.animation_graph")
local kBbombViewEffect = PrecacheAsset("cinematics/alien/gorge/bbomb_1p.cinematic")
local attackEffectMaterial = nil
local kRange = 20

if Client then
    attackEffectMaterial = Client.CreateRenderMaterial()
    attackEffectMaterial:SetMaterial("materials/effects/mesh_effects/view_blood.material")
end

local networkVars =
{
    lastPrimaryAttackTime = "private time"
}

--AddMixinNetworkVars(SpikesMixin, networkVars)
local function GetWeaponEffects()
local toreturn = {

           primal_scream =
    {
        primalScreamEffects =
        {
            {cinematic = kCinematic},
            {sound = "", silenceupgrade = true, done = true},
            {player_sound = kSound},
        },    
    
    },
    
    }
    
       return toreturn
end

local function TriggerPrimal(self, lerk)

     --  if lerk:GetIsOnFire() then
     --  return  PBAOEEnergize(self, lerk, true) 
     --  end
      

      --GetEffectManager():AddEffectData("AlienWeaponEffects", GetWeaponEffects()) --Ghetto alienweaponeffects.lua   
      --lerk:TriggerEffects("primal")
     if Server then 
        local parent = self:GetParent()
        if parent then
            parent:PrimalScream(kPrimalScreamDuration)
            local aliens = GetEntitiesForTeamWithinRange("Alien", 2, lerk:GetOrigin(), kPrimalScreamRange)
            for i = 1, #aliens do
               local alien = aliens[i]
               if alien ~= parent then
                   alien:PrimalScream(kPrimalScreamDuration)
                   alien:AddEnergy(kPrimalScreamTeamEnergyBoost)
                   alien.primaledID = self:GetParent():GetId()
                end   
            end
        end
    end

     
    
      

    
end

function Primal:OnCreate()

    Ability.OnCreate(self)
	
	
    self.primaryAttacking = false
    self.secondaryAttacking = false
    self.lastPrimaryAttackTime = 0
    self.timeLastLerkBileBomb = 0
	
    if Client then
        InitMixin(self, ClientWeaponEffectsMixin)
    end

end

function Primal:GetAnimationGraphName()
    return kAnimationGraph
end

function Primal:GetEnergyCost(player)
    return kPrimalScreamEnergyCost
end
function Primal:GetSecondaryEnergyCost(player)
    return kBileBombEnergyCost * 1.7
end
function Primal:GetHUDSlot()
    return 4
end

function Primal:GetAttackDelay()
    return kPrimalScreamROF
end

function Primal:GetLastAttackTime()
    return self.lastPrimaryAttackTime
end

function Primal:GetDeathIconIndex()

    if self.secondaryAttacking then
        return kDeathMessageIcon.BileBomb
    else
        return kDeathMessageIcon.Umbra
    end
    
end
function Primal:GetCanScream()
return Shared.GetTime() > self:GetLastAttackTime() + kPrimalScreamROF
end
function Primal:OnPrimaryAttack(player)

    if not self.secondaryAttacking then 
        if player:GetEnergy() >= self:GetEnergyCost() and self:GetCanScream() then
            self:TriggerEffects("primal_scream")
            if Server then        
                TriggerPrimal(self, player)
            end
            self:GetParent():DeductAbilityEnergy(self:GetEnergyCost())
            self.lastPrimaryAttackTime = Shared.GetTime()
            self.primaryAttacking = true
        else
            self.primaryAttacking = false
        end
    end
    
end

function Primal:OnPrimaryAttackEnd()
    
    Ability.OnPrimaryAttackEnd(self)
    self.primaryAttacking = false
    
end

local function CreateBombProjectile( self, player )
    
    if not Predict then
        
        -- little bit of a hack to prevent exploitey behavior.  Prevent gorges from bile bombing
        -- through clogs they are trapped inside.
        local startPoint = nil
        local startVelocity = nil
            local viewCoords = player:GetViewAngles():GetCoords()
            startPoint = player:GetAttachPointOrigin("Head_Tongue_02")
            startPoint = startPoint - Vector(0, 0.3, 0 )
            startVelocity = viewCoords.zAxis * 1
            
            local startPointTrace = Shared.TraceRay(player:GetEyePos(), startPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterOneAndIsa(player, "Babbler"))
            
            startPoint = startPointTrace.endPoint

        local bilebomb = player:CreatePredictedProjectile( "LerkBomb", startPoint, startVelocity)
        
    end
    
end

function Primal:OnSecondaryAttack(player)
     if not self.secondaryAttacking and not self.primaryAttacking and ( self.timeLastLerkBileBomb + 3.2 <= Shared.GetTime() )  then
       if player:GetEnergy() >= self:GetSecondaryEnergyCost() then
        
            self.secondaryAttacking = true
            
            if Server or (Client and Client.GetIsControllingPlayer()) then
                CreateBombProjectile(self, player)
            end
            
            player:DeductAbilityEnergy(self:GetSecondaryEnergyCost())            
            self.timeLastLerkBileBomb = Shared.GetTime()
            
            self:TriggerEffects("LerkBileBomb_attack")
            
            if Client then
            
                local cinematic = Client.CreateCinematic(RenderScene.Zone_ViewModel)
                cinematic:SetCinematic(kBbombViewEffect)
                
            end
  
        else
            self.secondaryAttacking = false
        end  
     end

end

function Primal:GetTimeLastBomb()
    return self.timeLastLerkBileBomb
end
function Primal:GetHasSecondary(player)
    return true
end
function Primal:OnSecondaryAttackEnd(player)
    
    if self.secondaryAttacking then 
    
        self.secondaryAttacking = false
    
    end
    
end

if Client then

    function Primal:TriggerFirstPersonHitEffects(player, target)

        if player == Client.GetLocalPlayer() and target then
            
            local cinematicName = kStructureHitEffect
            if target:isa("Marine") then
                self:CreateBloodEffect(player)        
                cinematicName = kMarineHitEffect
            end
        
            local cinematic = Client.CreateCinematic(RenderScene.Zone_ViewModel)
            cinematic:SetCinematic(cinematicName)
        
        
        end

    end

    function Primal:CreateBloodEffect(player)
    
        if not Shared.GetIsRunningPrediction() then

            local model = player:GetViewModelEntity():GetRenderModel()

            model:RemoveMaterial(attackEffectMaterial)
            model:AddMaterial(attackEffectMaterial)
            attackEffectMaterial:SetParameter("attackTime", Shared.GetTime())

        end
        
    end

end
function Primal:OnUpdateAnimationInput(modelMixin)

    local abilityString = "umbra"
    local activityString = "none"
    
    if self.attackButtonPressed or self.secondaryAttacking then
    
        activityString = "primary"
        
    end
   
    modelMixin:SetAnimationInput("ability", abilityString) 
    modelMixin:SetAnimationInput("activity", activityString)
    
end





Shared.LinkClassToMap("Primal", Primal.kMapName, networkVars)