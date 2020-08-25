-- lua\Weapons\Marine\Welder.lua
--
--    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
--
--    Weapon used for repairing structures and armor of friendly players (marines, exosuits, jetpackers).
--    Uses hud slot 3 (replaces axe)
--
-- ========= For more information, visit us at http:--www.unknownworlds.com =====================

--Script.Load("lua/Weapons/Marine/Flame.lua")
Script.Load("lua/Weapons/Marine/ExoGrenade.lua")
Script.Load("lua/Weapons/Weapon.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/Weapons/Marine/ExoWeaponHolder.lua")
Script.Load("lua/Weapons/Marine/ExoWeaponSlotMixin.lua")
Script.Load("lua/TechMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/PointGiverMixin.lua")
Script.Load("lua/EffectsMixin.lua")
Script.Load("lua/Weapons/ClientWeaponEffectsMixin.lua")
Script.Load("lua/Weapons/BulletsMixin.lua")

class 'ExoGrenader' (Entity)

ExoGrenader.kMapName = "exogrenader"

local kConeWidth = 0.9 --0.3
local kFireRate = 1
local kDamageRadius = kFlamethrowerDamageRadius
local kCoolDownRate = 0.24
local kDualGunHeatUpRate = 0.048
local kHeatUpRate = 0.1344


if Client then
   Script.Load("lua/2019/ExoGrenader_Client.lua")
end

ExoGrenader.kMapName = "exogrenader"

ExoGrenader.kModelName = PrecacheAsset("models/marine/grenadelauncher/grenadelauncher.model")
local kAnimationGraph = PrecacheAsset("models/marine/grenadelauncher/grenadelauncher_view.animation_graph")
local kFireLoopingSound = PrecacheAsset("sound/NS2.fev/marine/flamethrower/attack_loop")


local kExoGrenaderThingyZero = PrecacheAsset("cinematics/marine/gl/muzzle_flash.cinematic")
local kExoGrenaderThingyOne = PrecacheAsset("cinematics/marine/gl/muzzle_flash.cinematic")

--local kHeatUISoundName = PrecacheAsset("sound/NS2.fev/marine/heavy/heat_UI")
local kOverheatedSoundName = PrecacheAsset("sound/NS2.fev/marine/heavy/overheated")

local networkVars =
{
    createParticleEffects = "boolean",
    animationDoneTime = "float",
    range = "integer (0 to 11)",
    isShooting = "boolean",
    loopingSoundEntId = "entityid",
    heatAmount = "float (0 to 1 by 0.01)",
    overheated = "private boolean",
	--heatUISoundId = "private entityid"

}

AddMixinNetworkVars(ExoWeaponSlotMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(TechMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(PointGiverMixin, networkVars)

function ExoGrenader:OnCreate()
    Entity.OnCreate(self)
    
	self.lastAttackApplyTime = 0

	self.isShooting = false
    InitMixin(self, ExoWeaponSlotMixin)
	InitMixin(self, TechMixin)
    InitMixin(self, TeamMixin)
    InitMixin(self, DamageMixin)
    InitMixin(self, BulletsMixin)
    InitMixin(self, PointGiverMixin)
    InitMixin(self, EffectsMixin)
    
	self.timeWeldStarted = 0
    self.timeLastWeld = 0
    self.loopingSoundEntId = Entity.invalidId
	self.range = kFlamethrowerRange
    self.heatAmount = 0
    self.overheated = false

    if Server then
        self.lastAttackApplyTime = 0

		self.createParticleEffects = false
        self.loopingFireSound = Server.CreateEntity(SoundEffect.kMapName)
        self.loopingFireSound:SetAsset(kFireLoopingSound)
        -- SoundEffect will automatically be destroyed when the parent is destroyed (the Welder).
        self.loopingFireSound:SetParent(self)
        self.loopingSoundEntId = self.loopingFireSound:GetId()
		
		--self.heatUISound = Server.CreateEntity(SoundEffect.kMapName)
		--self.heatUISound:SetAsset(kHeatUISoundName)
		--self.heatUISound:SetParent(self)
		--self.heatUISound:Start()
		--self.heatUISoundId = self.heatUISound:GetId()
		
    elseif Client then
        self:SetUpdates(true)
        self.lastAttackEffectTime = 0.0
        self.lastAttackApplyTime = 0
	end
end

function ExoGrenader:OnInitialized()
    Entity.OnInitialized(self)
end


function ExoGrenader:OnDestroy()
    Entity.OnDestroy(self)
    if Server then
        self.loopingFireSound = nil
    elseif Client then
        if self.trailCinematic then
            Client.DestroyTrailCinematic(self.trailCinematic)
            self.trailCinematic = nil
        end
        if self.pilotCinematic then
            Client.DestroyCinematic(self.pilotCinematic)
            self.pilotCinematic = nil
        end
        if self.heatDisplayUI then
    
        Client.DestroyGUIView(self.heatDisplayUI)
        self.heatDisplayUI = nil
        end
    end
end

function ExoGrenader:OnUpdateAnimationInput(modelMixin)
    PROFILE("ExoGrenader:OnUpdateAnimationInput")
    local parent = self:GetParent()
    local activity = self.isShooting  and "primary" or "none"
    -- modelMixin:SetAnimationInput("activity_" .. self:GetExoWeaponSlotName(), activity)
end

function ExoGrenader:ModifyMaxSpeed(maxSpeedTable)
    if self.isShooting then
        maxSpeedTable.maxSpeed = maxSpeedTable.maxSpeed * 1
    end
end

function ExoGrenader:GetIsAffectedByWeaponUpgrades()
    return false
end

function ExoGrenader:CreatePrimaryAttackEffect(player)
    -- Remember this so we can update gun_loop pose param
    self.timeOfLastPrimaryAttack = Shared.GetTime()
end

function ExoGrenader:GetRange()
    return self.range
end


 function ExoGrenader:GetMeleeOffset()

	return 0

 end


function ExoGrenader:GetBarrelPoint()
    local player = self:GetParent()
    if player then
		if Client and player:GetIsLocalPlayer() then
            local origin = player:GetEyePos()
            local viewCoords = player:GetViewCoords()
            
            if self:GetIsLeftSlot() then
                return origin + viewCoords.zAxis * 0.9 + viewCoords.xAxis * 0.65 + viewCoords.yAxis * -0.19
            else
                return origin + viewCoords.zAxis * 0.9 + viewCoords.xAxis * -0.65 + viewCoords.yAxis * -0.19
            end
        else
            local origin = player:GetEyePos()
            local viewCoords = player:GetViewCoords()
            
            if self:GetIsLeftSlot() then
                return origin + viewCoords.zAxis * 0.9 + viewCoords.xAxis * 0.35 + viewCoords.yAxis * -0.15
            else
                return origin + viewCoords.zAxis * 0.9 + viewCoords.xAxis * -0.35 + viewCoords.yAxis * -0.15
            end
        end
    end
    return self:GetOrigin()
end


local kGrenadeSpeed = 8
local kGrenadeBounce = 0
local kGrenadeFriction = 0.35
local kLauncherBarrelDist = 1.5

local function ShootGrenade(self, player)

    PROFILE("GrenadeLauncher:ShootGrenade")

    --self:TriggerEffects("grenadelauncher_attack")

    if Server or (Client and Client.GetIsControllingPlayer()) then

        local viewCoords = player:GetViewCoords()
        local eyePos = player:GetEyePos()

        local floorAim = 1 - math.min(viewCoords.zAxis.y,0) -- this will be a number 1-2

        local startPointTrace = Shared.TraceCapsule(eyePos, eyePos + viewCoords.zAxis * floorAim * kLauncherBarrelDist, Grenade.kRadius+0.0001, 0, CollisionRep.Move, PhysicsMask.PredictedProjectileGroup, EntityFilterTwo(self, player))
        local startPoint = startPointTrace.endPoint

        local direction = viewCoords.zAxis

        player:CreatePredictedProjectile("ExoGrenade", startPoint, direction * kGrenadeSpeed, kGrenadeBounce, kGrenadeFriction)

    end

end


function ExoGrenader:FirePrimary(player, bullets, range, penetration)
     ShootGrenade(self, player)
end

function ExoGrenader:OnTag(tagName)
    PROFILE("ExoWelder:OnTag")
    if not self:GetIsLeftSlot() then
        if tagName == "deploy_end" then
            self.deployed = true
        end
    end
end

function ExoGrenader:OnPrimaryAttack(player)
    PROFILE("ExoGrenader:OnPrimaryAttack")
    if not self.overheated then                 if not self.isShooting then
        if not self.createParticleEffects then
            if self:GetIsLeftSlot() then
                player:TriggerEffects("leftExoGrenader_muzzle")
            elseif self:GetIsRightSlot() then
                player:TriggerEffects("rightExoGrenader_muzzle")
            end        
        end
        self.createParticleEffects = true
        if Server and not self.loopingFireSound:GetIsPlaying() then
            self.loopingFireSound:Start()
        end
    end
    
    self.isShooting = true
	end                              if Client and self.createParticleEffects and self.lastAttackEffectTime + kFireRate < Shared.GetTime() then
            if self:GetIsLeftSlot() then
                player:TriggerEffects("leftExoGrenader_muzzle")
            elseif self:GetIsRightSlot() then
                player:TriggerEffects("rightExoGrenader_muzzle")
            end          self.lastAttackEffectTime = Shared.GetTime()
    end
	if  not self.overheated and self.lastAttackApplyTime  + kFireRate < Shared.GetTime() then
		ShootGrenade(self, player)
        self.lastAttackApplyTime  = Shared.GetTime()
    end
end

local function UpdateOverheated(self, player)

    if not self.overheated and self.heatAmount == 1 then
    
        self.overheated = true
        self:OnPrimaryAttackEnd(player)
        
        
        StartSoundEffectForPlayer(kOverheatedSoundName, player)
        
    end
    
    if self.overheated and self.heatAmount == 0 then
        self.overheated = false
    end
    
end

function ExoGrenader:AddHeat(amount)
    self.heatAmount = self.heatAmount + amount

end

function ExoGrenader:GetDeathIconIndex()
    return kDeathMessageIcon.Flamethrower
end

function ExoGrenader:OnPrimaryAttackEnd(player)
    if self.isShooting then 
        self.createParticleEffects = false
        if Server then    
            self.loopingFireSound:Stop()        
        end
    end
	self.isShooting = false

end

function ExoGrenader:OnReload(player)
    if self:CanReload() then
        if Server then
            self.createParticleEffects = false
            self.loopingFireSound:Stop()
        end
        self:TriggerEffects("reload")
        self.reloading = true
    end
end	

function ExoGrenader:ProcessMoveOnWeapon(player, input)
    local dt = input.time
    local addAmount = self.isShooting and (dt * kHeatUpRate) or -(dt * kCoolDownRate)
    self.heatAmount = math.min(1, math.max(0, self.heatAmount + addAmount))

    UpdateOverheated(self, player)

        
	if self.isShooting then
    
        local exoWeaponHolder = player:GetActiveWeapon()
        if exoWeaponHolder then
        
            local otherSlotWeapon = self:GetExoWeaponSlot() == ExoWeaponHolder.kSlotNames.Left and exoWeaponHolder:GetRightSlotWeapon() or exoWeaponHolder:GetLeftSlotWeapon()
            if otherSlotWeapon and otherSlotWeapon:isa("ExoGrenader") then
                otherSlotWeapon:AddHeat(dt * kDualGunHeatUpRate)
            end
        
        end
    end
end	

function ExoGrenader:GetNotifiyTarget()
    return false
end

function ExoGrenader:ModifyDamageTaken(damageTable, attacker, doer, damageType)
    if damageType ~= kDamageType.Corrode then
        damageTable.damage = 0
    end
end

function ExoGrenader:GetRange()
    return self.range
end

function ExoGrenader:UpdateViewModelPoseParameters(viewModel)
    viewModel:SetPoseParam("welder", 1)    
end

function ExoGrenader:OnUpdatePoseParameters(viewModel)
    PROFILE("ExoGrenader:OnUpdatePoseParameters")
    self:SetPoseParam("welder", 1)
end


GetEffectManager():AddEffectData("FlamerModEffects", {
    leftExoGrenader_muzzle = {
        flamerMuzzleEffects =
        {
            {viewmodel_cinematic = kExoGrenaderThingyOne, attach_point = "fxnode_l_railgun_muzzle"},
           {weapon_cinematic = kExoGrenaderThingyZero, attach_point = "fxnode_lrailgunmuzzle"},
        },
    },
    rightExoGrenader_muzzle = {
        flamerMuzzleEffects =
        {
            {viewmodel_cinematic = kExoGrenaderThingyOne, attach_point = "fxnode_r_railgun_muzzle"},
           {weapon_cinematic = kExoGrenaderThingyZero, attach_point = "fxnode_rrailgunmuzzle"},
        },
    },
})
    

Shared.LinkClassToMap("ExoGrenader", ExoGrenader.kMapName, networkVars)
