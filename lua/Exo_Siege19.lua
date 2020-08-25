Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/2019/ExoWelder.lua")
Script.Load("lua/2019/ExoFlamer.lua")
Script.Load("lua/2019/ExoGrenader.lua")

local networkVars = {   


  --isLockedEjecting = "private boolean",

  --  wallboots = "private boolean",
  --  wallWalking = "compensated boolean",
  --  timeLastWallWalkCheck = "private compensated time",

 }
  /*
local kNormalWallWalkFeelerSize = 0.25
local kNormalWallWalkRange = 0.3
local kJumpWallRange = 0.4
local kJumpWallFeelerSize = 0.1
local kWallJumpInterval = 0.4
local kWallJumpForce = 5.2 // scales down the faster you are
local kMinWallJumpForce = 0.1
local kVerticalWallJumpForce = 4.3
*/

AddMixinNetworkVars(StunMixin, networkVars)
AddMixinNetworkVars(PhaseGateUserMixin, networkVars)
AddMixinNetworkVars(LadderMoveMixin, networkVars)

local kDualWelderModelName = PrecacheAsset("models/marine/exosuit/exosuit_rr.model")
local kDualWelderAnimationGraph = PrecacheAsset("models/marine/exosuit/exosuit_rr.animation_graph")

local kHoloMarineMaterialname = PrecacheAsset("cinematics/vfx_materials/marine_ip_spawn.material")


local function HealSelf(self)


    self:SetArmor(self:GetArmor() + 3, true) 
    return self.layout == "WelderWelder"--why is grenadergrenader having nano? ........
end

local origcreate = Exo.OnCreate
function Exo:OnCreate()
    origcreate(self)
    self:AddTimedCallback(function() HealSelf(self) return true end, 1) 
    InitMixin(self, PredictedProjectileShooterMixin)
end


local oninit = Exo.OnInitialized
function Exo:OnInitialized()

oninit(self)
    InitMixin(self, StunMixin)
   self:SetTechId(kTechId.Exo)
end
local origmodel = Exo.InitExoModel

function Exo:InitExoModel()

    local hasWelders = false
    local modelName = kDualWelderModelName
    local graphName = kDualWelderAnimationGraph
    
  if self.layout == "WelderWelder" or self.layout == "FlamerFlamer" or self.layout == "GrenaderGrender" then
         modelName = kDualWelderModelName
        graphName = kDualWelderAnimationGraph
        self.hasDualGuns = true
        hasWelders = true
        self:SetModel(modelName, graphName)
    end
    
    
    if hasWelders then 
    else
    origmodel(self)
    end
end
local origweapons = Exo.InitWeapons
function Exo:InitWeapons()
     
    local weaponHolder = self:GetWeapon(ExoWeaponHolder.kMapName)
    if not weaponHolder then
        weaponHolder = self:GiveItem(ExoWeaponHolder.kMapName, false)   
    end    
    
  
        if self.layout == "WelderWelder" then
        weaponHolder:SetWelderWeapons()
        self:SetHUDSlotActive(1)
        return
        elseif self.layout == "FlamerFlamer" then
        weaponHolder:SetFlamerWeapons()
        self:SetHUDSlotActive(1)
        return
        elseif self.layout == "GrenaderGrenader" then
        weaponHolder:SetGrenaderWeapons()
        self:SetHUDSlotActive(1)
        return
        end
        
       -- Print("self.layout is %s", self.layout)

        origweapons(self)

    
end

function Exo:GetCanControl()
    return not self.isLockedEjecting and not self.isMoveBlocked and self:GetIsAlive() and  not self.countingDown and not self.concedeSequenceActive
end


--facepalm I thought I needed this to fix error, now to just have chargeamount grenade lol
function Exo:CreateExoGrenade(className, startPoint, velocity, bounce, friction, gravity, chargeAmount )

    if Predict or (not Server and _G[className].kUseServerPosition) then
        return nil
    end

    local clearOnImpact = _G[className].kClearOnImpact
    local detonateWithTeam = _G[className].kClearOnEnemyImpact and GetEnemyTeamNumber(self:GetTeamNumber()) or -1
    local detonateRadius = _G[className].kDetonateRadius

    local minLifeTime = _G[className].kMinLifeTime

    local projectile
    local projectileController = ProjectileController()
    projectileController:Initialize(startPoint, velocity, _G[className].kRadius, self, bounce, friction, gravity, detonateWithTeam, clearOnImpact, minLifeTime, detonateRadius)
    projectileController.projectileId = self.nextProjectileId
    projectileController.modelName = _G[className].kModelName

    local projectileEntId = Entity.invalidId

    if Server then

        projectile = CreateEntity(ExoGrenade.kMapName, startPoint, self:GetTeamNumber()) --for this line
        projectile.projectileId = self.nextProjectileId

        projectileEntId = projectile:GetId()
        projectile:SetOwner(self)

        projectile:SetProjectileController(projectileController, self.isHallucination == true)
        projectile:SetChargeAmount(chargeAmount)--.chargedAmount = chargeAmount

    end

    local projectileModel
    local projectileCinematic

    if Client then

        local coords = Coords.GetLookIn(startPoint, GetNormalizedVector(velocity))

        if _G[className].kModelName then

            local modelIndex = Shared.GetModelIndex(_G[className].kModelName)
            if modelIndex then

                projectileModel = Client.CreateRenderModel(RenderScene.Zone_Default)
                projectileModel:SetModel(modelIndex)
                projectileModel:SetCoords(coords)

            end

        end

        local cinematicName = _G[className].kProjectileCinematic
        if cinematicName then

            projectileCinematic = Client.CreateCinematic(RenderScene.Zone_Default)
            projectileCinematic:SetCinematic(cinematicName)
            projectileCinematic:SetRepeatStyle(Cinematic.Repeat_Endless)
            projectileCinematic:SetIsVisible(true)
            projectileCinematic:SetCoords(coords)

        end

    end

    self.predictedProjectiles[self.nextProjectileId] = { Controller = projectileController, Model = projectileModel, EntityId = projectileEntId, CreationTime = Shared.GetTime(), Cinematic = projectileCinematic }
    self.predictedProjectilesList:Insert(self.nextProjectileId)

    if not _G[className].kUseServerPosition then

        self.nextProjectileId = self.nextProjectileId + 1
        if self.nextProjectileId > 200 then --intersting
            self.nextProjectileId = 1
        end

    end

    return projectile

end


Shared.LinkClassToMap("Exo", Exo.kMapName, networkVars)