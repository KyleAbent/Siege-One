///////TechPoint.lua
///////////
/*
Techpoint written by UWE. 
The only reason I copied the code from Techpoint to make it moddable.
There's another reason of doing is such as by making it a new class and not having to hook it.
If I call through filehooks then have that load the previous file, then I Could have a sub class based on the class. 
However the reason I have the content from the file copied over is because the TechData requiring TechID, 
If the TechData class was not an issue, then I would not have copied code from another file. 


Maybe in the future I can find out how to take less of UWE code being hardcoded.
 is because there's 
*/
///////
Script.Load("lua/ScriptActor.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/Mixins/ClientModelMixin.lua")
Script.Load("lua/MapBlipMixin.lua")
Script.Load("lua/CommanderGlowMixin.lua")
Script.Load("lua/SelectableMixin.lua")
Script.Load("lua/ResearchMixin.lua")
Script.Load("lua/UnitStatusMixin.lua")
Script.Load("lua/MapBlipMixin.lua")
Script.Load("lua/ConsumeMixin.lua")

class 'AlienTechPoint' (ScriptActor)

AlienTechPoint.kMapName = "alientechpoint"

AlienTechPoint.kModelName =  PrecacheAsset("models/misc/tech_point/tech_point.model")
local kAnimationGraph = PrecacheAsset("models/misc/tech_point/tech_point.animation_graph")


local networkVars =
{
    smashed = "boolean",
    smashScouted = "boolean",
    showObjective = "boolean",
    occupiedTeam = string.format("integer (-1 to %d)", kSpectatorIndex),
    attachedId = "entityid",
    extendAmount = "float (0 to 1 by 0.01)"
}

AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(ClientModelMixin, networkVars)
AddMixinNetworkVars(SelectableMixin, networkVars)
AddMixinNetworkVars(ResearchMixin, networkVars)
AddMixinNetworkVars(ConsumeMixin, networkVars)

function AlienTechPoint:OnCreate()
///////TechPoint.lua
    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ClientModelMixin)
    InitMixin(self, TeamMixin)
    InitMixin(self, SelectableMixin)
    InitMixin(self, LiveMixin)
    InitMixin(self, ResearchMixin)
    InitMixin(self, ConsumeMixin)
    
    if Client then
        InitMixin(self, CommanderGlowMixin)
        InitMixin(self, UnitStatusMixin)
    end
    
    -- Anything that can be built upon should have this group
    self:SetPhysicsGroup(PhysicsGroup.AttachClassGroup)
    
    -- Make the nozzle kinematic so that the player will collide with it.
    self:SetPhysicsType(PhysicsType.Kinematic)
    
    -- Defaults to 1 but the mapper can adjust this setting in the editor.
    -- The higher the chooseWeight, the more likely this point will be randomly chosen for a team.
    self.chooseWeight = 1
    
    self.extendAmount = 0
    
end

function AlienTechPoint:OnInitialized()
///////TechPoint.lua
    ScriptActor.OnInitialized(self)
    
     self:SetModel(AlienTechPoint.kModelName, kAnimationGraph)
    
    self:SetTechId(kTechId.AlienTechPoint)
    
    self.extendAmount = math.min(1, math.max(0, self.extendAmount))
    
    if Server then
        -- 0 indicates all teams allowed for random selection process.
        self.allowedTeamNumber = self.teamNumber or 0
        self.smashed = false
        self.smashScouted = false
        self.showObjective = false
        self.occupiedTeam = 0
        InitMixin(self, StaticTargetMixin)
        
        -- This Mixin must be inited inside this OnInitialized() function.
        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end
        
        self:SetRelevancyDistance(Math.infinity)
        self:SetExcludeRelevancyMask(bit.bor(kRelevantToTeam1, kRelevantToTeam2, kRelevantToReadyRoom))
        self:NotifyAlienCommander(self)
    end
 
end

function AlienTechPoint:NotifyAlienCommander(self)

end

function AlienTechPoint:GetTechButtons(techId)
    local table = {}
    if not self:GetAttached() then
        table[1] = kTechId.AlienTechPointHive
    end
    table[8] = kTechId.Consume
     return table
end
function AlienTechPoint:GetExtendAmount()
    return self.extendAmount
end

function AlienTechPoint:PerformActivation(techId, position, normal, commander)

    local success = false
    
    if techId == kTechId.AlienTechPointHive then
        success = self:SpawnCommandStructure(2)
    end
    
    return success, true
    
end
function AlienTechPoint:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.TechPoint
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end
function AlienTechPoint:SetIsSmashed(setSmashed)

    self.smashed = setSmashed
    self.smashScouted = false
    
end
function AlienTechPoint:SetSmashScouted()

    if Server then
        self.smashScouted = true
    end
    
end

function AlienTechPoint:GetHealthbarOffset()
    return 2
end 

///////TechPoint.lua
if Server then

/*
function AlienTechPoint:GetCanTakeDamageOverride()
    return false
end

function AlienTechPoint:GetCanDieOverride()
    return false
end

function AlienTechPoint:OnKill()
    local hive = ...AddKill
end
*/

function AlienTechPoint:OnAttached(entity)
    self.occupiedTeam = entity:GetTeamNumber()
end


function AlienTechPoint:OnDetached()
    self.showObjective = false
    self.occupiedTeam = 0
end

function AlienTechPoint:Reset()
    
    self:OnInitialized()
    
    self:ClearAttached()
    
end

function AlienTechPoint:SetAttached(structure)

    if structure and structure:isa("CommandStation") then
        self.smashed = false
        self.smashScouted = false
    end
    ScriptActor.SetAttached(self, structure)
    
end 

-- Spawn command station or hive on tech point
function AlienTechPoint:SpawnCommandStructure(teamNumber)

    local alienTeam = (GetGamerules():GetTeam(teamNumber):GetTeamType() == kAlienTeamType)
    local techId = ConditionalValue(alienTeam, kTechId.Hive, kTechId.CommandStation)
    local entity = CreateEntityForTeam(techId, Vector(self:GetOrigin()), teamNumber)
    self:SetAttached(entity)
    entity:SetAttached(self)
    return true
end


function AlienTechPoint:OnUpdate(deltaTime)

    ScriptActor.OnUpdate(self, deltaTime)
    
    if self.smashed and not self.smashScouted then
        local attached = self:GetAttached()
        if attached and attached:GetIsSighted() then
            self.smashScouted = true
        end
    end    
    
end 
 
    function AlienTechPoint:OnKill()
        local attached = self:GetAttached()
        if attached then
            attached:Kill()
        end
        DestroyEntity(self)
    end
    function AlienTechPoint:OnConsumed()
        local attached = self:GetAttached()
        if attached then
            attached:Kill()
        end
    end
end
Shared.LinkClassToMap("AlienTechPoint", AlienTechPoint.kMapName, networkVars)