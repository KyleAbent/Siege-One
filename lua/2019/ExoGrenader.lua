//Modified from ExoFlamer then made ExoGrenade based on Grenade

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


--copy railgun
local kChargeTime = 2
-- The Railgun will automatically shoot if it is charged for too long.
local kChargeForceShootTime = 2.2
local kRailgunRange = 400
local kRailgunSpread = Math.Radians(0)
local kBulletSize = 0.3

local kRailgunChargeTime = 1.4


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
    isShooting = "boolean",--railgunAttacking ?
    loopingSoundEntId = "entityid",
    heatAmount = "float (0 to 1 by 0.01)",
    overheated = "private boolean",
	--heatUISoundId = "private entityid"
	
	--try copy railgun
	timeChargeStarted = "time",
	 lockCharging = "boolean",
	 timeOfLastShot = "time",

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
	
	--try copy railgun
	self.timeChargeStarted = 0
    --self.railgunAttacking = false
    self.lockCharging = false
    self.timeOfLastShot = 0
    
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


function ExoGrenader:LockGun()
    self.timeOfLastShot = Shared.GetTime()
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
            --I thought PRedicedProjectile broke with this class getting this mapname, so i copied the function. then now i need it for chargeamount
        kGrenadeSpeed = 8 * ( ( math.round( self:GetChargeAmount() * 10 ) ) /10) + 8
        Print("kGrenadeSpeed is %s", kGrenadeSpeed)
        player:CreateExoGrenade("ExoGrenade", startPoint, direction * kGrenadeSpeed, kGrenadeBounce, kGrenadeFriction, nil, self:GetChargeAmount() )

    end
    
        self:LockGun()
        self.lockCharging = true

end



function ExoGrenader:OnTag(tagName)

    PROFILE("ExoGrenader:OnTag")
    if not self:GetIsLeftSlot() then
        if tagName == "deploy_end" then
            self.deployed = true
        end
    end
    
    
    
end

local kExoGrenaderChargeTime = 1.4
function ExoGrenader:OnPrimaryAttack(player)


    local exoWeaponHolder = player:GetActiveWeapon()
    local otherSlotWeapon = self:GetExoWeaponSlot() == ExoWeaponHolder.kSlotNames.Left and exoWeaponHolder:GetRightSlotWeapon() or exoWeaponHolder:GetLeftSlotWeapon()
    if not otherSlotWeapon.isShooting and self.timeOfLastShot + kExoGrenaderChargeTime <= Shared.GetTime() then

        if not self.isShooting then
            self.timeChargeStarted = Shared.GetTime()           
        end
        self.isShooting = true
        
    end
end
    /*
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
    */
    
--end


function ExoGrenader:GetDeathIconIndex()
    return kDeathMessageIcon.GL
end

function ExoGrenader:OnPrimaryAttackEnd(player)
    if self.isShooting and self:GetChargeAmount() > 0 then 
        self.createParticleEffects = false

        	ShootGrenade(self, player)--chargeamount?
    end
	self.isShooting = false


end





function ExoGrenader:OnUpdateRender()

    PROFILE("ExoGrenader:OnUpdateRender")
    
    local chargeAmount = self:GetChargeAmount()
    local parent = self:GetParent()
    if parent and parent:GetIsLocalPlayer() then
    
        local viewModel = parent:GetViewModelEntity()
        if viewModel and viewModel:GetRenderModel() then
        
            viewModel:InstanceMaterials()
            local renderModel = viewModel:GetRenderModel()
            renderModel:SetMaterialParameter("chargeAmount" .. self:GetExoWeaponSlotName(), chargeAmount)
            renderModel:SetMaterialParameter("timeSinceLastShot" .. self:GetExoWeaponSlotName(), Shared.GetTime() - self.timeOfLastShot)
            
        end
        
        local chargeDisplayUI = self.chargeDisplayUI
        if not chargeDisplayUI then
        
            chargeDisplayUI = Client.CreateGUIView(246, 256)
            chargeDisplayUI:Load("lua/GUI" .. self:GetExoWeaponSlotName():gsub("^%l", string.upper) .. "RailgunDisplay.lua")
            chargeDisplayUI:SetTargetTexture("*exo_railgun_" .. self:GetExoWeaponSlotName())
            self.chargeDisplayUI = chargeDisplayUI
            
        end
        
        chargeDisplayUI:SetGlobal("chargeAmount" .. self:GetExoWeaponSlotName(), chargeAmount)
        chargeDisplayUI:SetGlobal("timeSinceLastShot" .. self:GetExoWeaponSlotName(), Shared.GetTime() - self.timeOfLastShot)
        
    else
    
        if self.chargeDisplayUI then
        
            Client.DestroyGUIView(self.chargeDisplayUI)
            self.chargeDisplayUI = nil
            
        end
        
    end
    
    if self.chargeSound then
    
        local playing = self.chargeSound:GetIsPlaying()
        if not playing and chargeAmount > 0 then
            self.chargeSound:Start()
        elseif playing and chargeAmount <= 0 then
            self.chargeSound:Stop()
        end
        
        self.chargeSound:SetParameter("charge", chargeAmount, 1)
        
    end
    
end


function ExoGrenader:ProcessMoveOnWeapon(player, input)

    if self.isShooting then
    
        if (Shared.GetTime() - self.timeChargeStarted) >= kChargeForceShootTime then
            --self.isShooting = false
            self:OnPrimaryAttackEnd(player)
        end
        
    end
    
end

/*
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
*/


function ExoGrenader:GetNotifiyTarget()
    return false
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
function ExoGrenader:GetChargeAmount()
   return self.isShooting and math.min(1, (Shared.GetTime() - self.timeChargeStarted) / kChargeTime) or 0
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
