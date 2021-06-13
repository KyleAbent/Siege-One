Script.Load("lua/SleeperMixin.lua")
Script.Load("lua/FireMixin.lua")
Script.Load("lua/UmbraMixin.lua")
Script.Load("lua/MaturityMixin.lua")
Script.Load("lua/PointGiverMixin.lua")
Script.Load("lua/AchievementGiverMixin.lua")
Script.Load("lua/GameEffectsMixin.lua")
Script.Load("lua/CatalystMixin.lua")
Script.Load("lua/MapBlipMixin.lua")
Script.Load("lua/Mixins/ClientModelMixin.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/CombatMixin.lua")
Script.Load("lua/LOSMixin.lua")
Script.Load("lua/FlinchMixin.lua")
Script.Load("lua/SelectableMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/CloakableMixin.lua")
Script.Load("lua/DetectableMixin.lua")
Script.Load("lua/EntityChangeMixin.lua")
Script.Load("lua/ConstructMixin.lua")
Script.Load("lua/UnitStatusMixin.lua")
Script.Load("lua/CommanderGlowMixin.lua")
Script.Load("lua/SpawnBlockMixin.lua")
Script.Load("lua/IdleMixin.lua")
Script.Load("lua/InfestationMixin.lua")
Script.Load("lua/CommAbilities/Alien/EnzymeCloud.lua")
Script.Load("lua/CommAbilities/Alien/Rupture.lua")

class 'LoneCyst' (ScriptActor)

LoneCyst.kMaxEncodedPathLength = 30
LoneCyst.kMapName = "LoneCyst"
LoneCyst.kModelName = PrecacheAsset("models/alien/Cyst/Cyst.model")

LoneCyst.kAnimationGraph = PrecacheAsset("models/alien/Cyst/Cyst.animation_graph")

LoneCyst.kEnergyCost = 25
LoneCyst.kPointValue = 5
-- how fast the impulse moves
LoneCyst.kImpulseSpeed = 8

LoneCyst.kThinkInterval = 1 
LoneCyst.kImpulseColor = Color(1,1,0)
LoneCyst.kImpulseLightIntensity = 8
local kImpulseLightRadius = 1.5

LoneCyst.kExtents = Vector(0.2, 0.1, 0.2)

LoneCyst.kBurstDuration = 3


-- size of infestation patch
LoneCyst.kInfestationRadius = kInfestationRadius
LoneCyst.kInfestationGrowthDuration = LoneCyst.kInfestationRadius / kCystInfestDuration

-- how many seconds before a fully mature LoneCyst, disconnected, becomes fully immature again.
LoneCyst.kMaturityLossTime = 15

-- LoneCyst infestation spreads/recedes faster
LoneCyst.kInfestationRateMultiplier = 3

LoneCyst.kInfestationGrowRateMultiplier = 6
LoneCyst.kInfestationRecideRateMultiplier = 3

local kEnemyDetectInterval = 0.2

local networkVars =
{

    -- Since LoneCysts don't move, we don't need the fields to be lag compensated
    -- or delta encoded
    m_origin = "position (by 0.05 [], by 0.05 [], by 0.05 [])",
    m_angles = "angles (by 0.1 [], by 10 [], by 0.1 [])",
    
    -- LoneCysts are never attached to anything, so remove the fields inherited from Entity
    m_attachPoint = "integer (-1 to 0)",

    --LoneCysts scale their health based on the distance to the clostest hive
    healthScalar = "float (0 to 1 by 0.01)",

    cloakInfestation = "boolean"
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ClientModelMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(GameEffectsMixin, networkVars)
AddMixinNetworkVars(UmbraMixin, networkVars)
AddMixinNetworkVars(FireMixin, networkVars)
AddMixinNetworkVars(MaturityMixin, networkVars)
AddMixinNetworkVars(CatalystMixin, networkVars)
AddMixinNetworkVars(CombatMixin, networkVars)
AddMixinNetworkVars(LOSMixin, networkVars)
AddMixinNetworkVars(FlinchMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(PointGiverMixin, networkVars)
AddMixinNetworkVars(CloakableMixin, networkVars)
AddMixinNetworkVars(ConstructMixin, networkVars)
AddMixinNetworkVars(DetectableMixin, networkVars)
AddMixinNetworkVars(SelectableMixin, networkVars)
AddMixinNetworkVars(InfestationMixin, networkVars)
AddMixinNetworkVars(IdleMixin, networkVars)




if Server then
    Script.Load("lua/2019/LoneCyst_Server.lua")
end

function LoneCyst:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, TeamMixin)
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ClientModelMixin)
    InitMixin(self, GameEffectsMixin)
    InitMixin(self, LiveMixin)
    InitMixin(self, FireMixin)
    InitMixin(self, UmbraMixin)
    InitMixin(self, CatalystMixin)
    InitMixin(self, CombatMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, LOSMixin)
    InitMixin(self, FlinchMixin, { kPlayFlinchAnimations = true })
    InitMixin(self, SelectableMixin)
    InitMixin(self, PointGiverMixin)
    InitMixin(self, AchievementGiverMixin)
    InitMixin(self, CloakableMixin)
    InitMixin(self, ConstructMixin)
    InitMixin(self, MaturityMixin)
    InitMixin(self, DetectableMixin)
    
    if Server then
    
        InitMixin(self, SpawnBlockMixin)
        self:UpdateIncludeRelevancyMask()
        
    elseif Client then
        InitMixin(self, CommanderGlowMixin)
    end

    self:SetPhysicsCollisionRep(CollisionRep.Move)
    self:SetPhysicsGroup(PhysicsGroup.SmallStructuresGroup)
    
    self:SetLagCompensated(false)
   
    
end

function LoneCyst:OnDestroy()

    if Client then
        
        if self.redeployCircleModel then
        
            Client.DestroyRenderModel(self.redeployCircleModel)
            self.redeployCircleModel = nil
            
        end
        
    end
    
    ScriptActor.OnDestroy(self)
    
end

function LoneCyst:GetShowSensorBlip()
    return false
end

function LoneCyst:GetSpawnBlockDuration()
    return 1
end


function LoneCyst:OnInitialized()

    InitMixin(self, InfestationMixin)
    
    ScriptActor.OnInitialized(self)

    if Server then
        
        InitMixin(self, SleeperMixin)
        InitMixin(self, StaticTargetMixin)
        
        self:SetModel(LoneCyst.kModelName, LoneCyst.kAnimationGraph)
        
        -- This Mixin must be inited inside this OnInitialized() function.
        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end

        self.cloakInfestation = false
        self:AddTimedCallback(self.UpdateInfestationCloaking, 0.2)
        self:AddTimedCallback(self.ScanForNearbyEnemy, kEnemyDetectInterval)
        
    elseif Client then    
    
        InitMixin(self, UnitStatusMixin)
         
    end   
    
    InitMixin(self, IdleMixin)

    if not GetIsImaginatorAlienEnabled() then
        local lonecysts = #GetEntitiesForTeam( "LoneCyst", 2 )
        if lonecysts == 5 then
            NotifyCommanderLimitReached(self)
        elseif lonecysts >= 6 then
            for index, lonesome in ientitylist(Shared.GetEntitiesWithClassname("LoneCyst")) do
              //Notify commander? Bleh
              NotifyCommanderKill(lonesome)
              return lonesome:Kill()
            end
        end
    else
         local notNearCyst = GetEntitiesWithinRange("LoneCyst",self:GetOrigin(), kCystRedeployRange-1) == 0
         if not notNearCyst then
            self:Kill()
         end
    
    end
    
end

function LoneCyst:GetPlayIdleSound()
    return self:GetIsBuilt() and self:GetCurrentInfestationRadiusCached() < 1
end

function LoneCyst:GetInfestationGrowthRate()
    return LoneCyst.kInfestationGrowthDuration
end

function LoneCyst:GetHealthbarOffset()
    return 0.5
end 

--
-- Infestation never sights nearby enemy players.
--
function LoneCyst:OverrideCheckVision()
    return false
end

function LoneCyst:GetIsFlameAble()
    return true
end

function LoneCyst:GetIsFlameableMultiplier()
    return 7
end

function LoneCyst:GetIsCamouflaged()
    return  self:GetIsBuilt() and not self:GetIsInCombat() and GetHasTech(self, kTechId.ShadeHive)
end

function LoneCyst:GetCloakInfestation()
    return self.cloakInfestation
end

function LoneCyst:GetAutoBuildRateMultiplier()
    if GetHasTech(self, kTechId.ShiftHive) then
        return 1.25
    end

    return 1
end

function LoneCyst:GetMatureMaxHealth()
    return math.max(kMatureLoneCystHealth * self.healthScalar or 0, kMinMatureLoneCystHealth)
end

function LoneCyst:GetMatureMaxArmor()
    if GetHasTech(self, kTechId.CragHive) then
        return 25
    end

    return kMatureLoneCystArmor

end 

function LoneCyst:GetMatureMaxEnergy()
    return 0
end

function LoneCyst:GetCanSleep()
    return true
end    

function LoneCyst:GetTechButtons(techId)
  
    return  { kTechId.Infestation,  kTechId.None, kTechId.None, kTechId.None,
              kTechId.None, kTechId.None, kTechId.None, kTechId.None }

end

function LoneCyst:GetInfestationRadius()
    return kInfestationRadius
end

function LoneCyst:GetInfestationMaxRadius()
    return kInfestationRadius
end

function LoneCyst:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = false    
end

function LoneCyst:GetIsConnectedAndAlive()
    return self:GetIsAlive()
end


function LoneCyst:OnOverrideSpawnInfestation(infestation)

    infestation.maxRadius = kInfestationRadius
    -- New infestation starts partially built, but this allows it to start totally built at start of game
    local radiusPercent = math.max(infestation:GetRadius(), .2)
    infestation:SetRadiusPercent(radiusPercent)
    
end

function LoneCyst:GetReceivesStructuralDamage()
    return true
end

function LoneCyst:CanBeBuilt()
    if self:GetIsBuilt() then
        return false
    end
    return true
end

function LoneCyst:GetCanAutoBuild()
    return self:CanBeBuilt()
end

function LoneCyst:GetHealSprayBuildAllowed()
    return self:CanBeBuilt()
end

-- Temporarily don't use "target" attach point
function LoneCyst:GetEngagementPointOverride()
    return self:GetOrigin() + Vector(0, 0.2, 0)
end

function LoneCyst:GetIsHealableOverride()
  return self:GetIsAlive()
end

function LoneCyst:SetIncludeRelevancyMask(includeMask)

    includeMask = bit.bor(includeMask, kRelevantToTeam2Commander)    
    ScriptActor.SetIncludeRelevancyMask(self, includeMask)    

end


function LoneCyst:GetCanCatalyzeHeal()
    return true
end

function LoneCyst:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.Infestation
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end


Shared.LinkClassToMap("LoneCyst", LoneCyst.kMapName, networkVars)
