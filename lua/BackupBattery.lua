--Kyle 'Avoca' Abent

Script.Load("lua/Mixins/ClientModelMixin.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/PointGiverMixin.lua")
Script.Load("lua/AchievementGiverMixin.lua")
Script.Load("lua/GameEffectsMixin.lua")
Script.Load("lua/SelectableMixin.lua")
Script.Load("lua/FlinchMixin.lua")
Script.Load("lua/LOSMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/CorrodeMixin.lua")
Script.Load("lua/ConstructMixin.lua")
Script.Load("lua/ResearchMixin.lua")
Script.Load("lua/RecycleMixin.lua")
Script.Load("lua/CombatMixin.lua")
Script.Load("lua/CommanderGlowMixin.lua")

Script.Load("lua/ScriptActor.lua")
Script.Load("lua/NanoShieldMixin.lua")
Script.Load("lua/ObstacleMixin.lua")
Script.Load("lua/WeldableMixin.lua")
Script.Load("lua/UnitStatusMixin.lua")
Script.Load("lua/DissolveMixin.lua")
Script.Load("lua/GhostStructureMixin.lua")
Script.Load("lua/PowerConsumerMixin.lua")
Script.Load("lua/MapBlipMixin.lua")
Script.Load("lua/InfestationTrackerMixin.lua")
Script.Load("lua/ParasiteMixin.lua")
Script.Load("lua/SupplyUserMixin.lua")


class 'BackupBattery' (ScriptActor)

BackupBattery.kMapName = "backupbattery"

BackupBattery.kModelName = PrecacheAsset("models/marine/portable_node/portable_node.model")
local kAnimationGraph = PrecacheAsset("models/marine/portable_node/portable_node.animation_graph")

local networkVars =
{
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ClientModelMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(GameEffectsMixin, networkVars)
AddMixinNetworkVars(FlinchMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(LOSMixin, networkVars)
AddMixinNetworkVars(CorrodeMixin, networkVars)
AddMixinNetworkVars(ConstructMixin, networkVars)
AddMixinNetworkVars(ResearchMixin, networkVars)
AddMixinNetworkVars(RecycleMixin, networkVars)
AddMixinNetworkVars(CombatMixin, networkVars)

AddMixinNetworkVars(NanoShieldMixin, networkVars)
--AddMixinNetworkVars(StunMixin, networkVars)
AddMixinNetworkVars(ObstacleMixin, networkVars)
AddMixinNetworkVars(DissolveMixin, networkVars)
AddMixinNetworkVars(GhostStructureMixin, networkVars)
AddMixinNetworkVars(PowerConsumerMixin, networkVars)
AddMixinNetworkVars(SelectableMixin, networkVars)
AddMixinNetworkVars(ParasiteMixin, networkVars)

function BackupBattery:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ClientModelMixin)
    InitMixin(self, LiveMixin)
    InitMixin(self, GameEffectsMixin)
    InitMixin(self, FlinchMixin, { kPlayFlinchAnimations = true })
    InitMixin(self, TeamMixin)
    InitMixin(self, PointGiverMixin)
    InitMixin(self, AchievementGiverMixin)
    InitMixin(self, SelectableMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, LOSMixin)
    InitMixin(self, CorrodeMixin)
    InitMixin(self, ConstructMixin)
    InitMixin(self, ResearchMixin)
    InitMixin(self, RecycleMixin)
    InitMixin(self, CombatMixin)
    InitMixin(self, ObstacleMixin)
    InitMixin(self, DissolveMixin)
    InitMixin(self, GhostStructureMixin)
    InitMixin(self, PowerConsumerMixin)
    InitMixin(self, ParasiteMixin)
    
    if Client then
        InitMixin(self, CommanderGlowMixin)
    end
    
    self:SetLagCompensated(false)
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(PhysicsGroup.BigStructuresGroup)
    
end

function BackupBattery:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    InitMixin(self, WeldableMixin)
    InitMixin(self, NanoShieldMixin)
    
    if Server then
    
        -- This Mixin must be inited inside this OnInitialized() function.
        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end
        
        InitMixin(self, StaticTargetMixin)
        InitMixin(self, InfestationTrackerMixin)
        InitMixin(self, SupplyUserMixin)
    
    elseif Client then
    
        InitMixin(self, UnitStatusMixin)
        InitMixin(self, HiveVisionMixin)
        self:MakeLight()
        
    end
    
    self:SetModel(BackupBattery.kModelName, kAnimationGraph)

end

if Client then

    function BackupBattery:MakeLight() --ExoSuit
        self.flashlight = Client.CreateRenderLight()
        self.flashlight:SetType(RenderLight.Type_Point)
        self.flashlight:SetCastsShadows(false)
        self.flashlight:SetSpecular(true)
        self.flashlight:SetRadius(8)
        self.flashlight:SetIntensity(15)
        self.flashlight:SetColor(Color(0, .2, 0.9))
        
        self.flashlight:SetIsVisible(true) -- will have to make this oncons

        local coords = self:GetCoords()
        coords.origin = coords.origin + coords.zAxis * 0.75 + coords.yAxis * 4

        self.flashlight:SetCoords(coords)
       -- self.flashlight:SetAngles( Angles(180,88,180) ) --face down shine light
            
        
    end


end


function BackupBattery:GetReceivesStructuralDamage()
    return true
end

function BackupBattery:GetDamagedAlertId()
    return kTechId.MarineAlertStructureUnderAttack
end

function BackupBattery:GetRequiresPower()
    return false
end
function BackupBattery:GetHealthbarOffset()
    return 0.75
end 

function GetBackupBatteryInRoom(origin)

    local location = GetLocationForPoint(origin)
    local locationName = location and location:GetName() or nil
    
    if locationName then
    
        local batteries = Shared.GetEntitiesWithClassname("BackupBattery")
        for b = 0, batteries:GetSize() - 1 do
        
            local battery = batteries:GetEntityAtIndex(b)
            if battery and battery:GetLocationName() == locationName then
                return battery
            end
            
        end
        
    end
    
    return nil
    
end

function GetRoomHasNoBackupBattery(techId, origin, normal, commander)

    local location = GetLocationForPoint(origin)
    local locationName = location and location:GetName() or nil
    local validRoom = false
    
    if locationName then
    
        validRoom = true
    
        for index, sentryBattery in ientitylist(Shared.GetEntitiesWithClassname("BackupBattery")) do
            
            if sentryBattery:GetLocationName() == locationName then
                validRoom = false
                break
            end
            
        end
    
    end
    
    return validRoom

end

if Server then

    function BackupBattery:GetDestroyOnKill()
        return true
    end

    function BackupBattery:OnKill()

        self:TriggerEffects("death")

    end

end


function BackupBattery:OnGetMapBlipInfo()

    local success = false
    local blipType = kMinimapBlipType.SentryBattery
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    local isParasited = HasMixin(self, "ParasiteAble") and self:GetIsParasited()
    
    
        blipType = kMinimapBlipType.Door
        blipTeam = self:GetTeamNumber()
    
    return blipType, blipTeam, isAttacked, isParasited
end

function BackupBattery:OnDestroy()
    ScriptActor.OnDestroy( self )
        
    if Client then
        if self.flashlight then
            Client.DestroyRenderLight(self.flashlight)
            self.flashlight = nil
        end
    end
    
end

Shared.LinkClassToMap("BackupBattery", BackupBattery.kMapName, networkVars)