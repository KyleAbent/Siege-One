Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")


local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origInit = PhaseGate.OnInitialized
function PhaseGate:OnInitialized()
    origInit(self)
    InitMixin(self, LevelsMixin)
    InitMixin(self, AvocaMixin)
end



Shared.LinkClassToMap("PhaseGate", PhaseGate.kMapName, networkVars) 


------------------
Script.Load("lua/ConsumeMixin.lua")
class 'PizzaGate' (PhaseGate)
PizzaGate.kMapName = "pizzagate"

PizzaGate.kModelName = PrecacheAsset("models/alien/tunnel/mouth.model")
local kAnimationGraph = PrecacheAsset("models/alien/tunnel/mouth.animation_graph")

local networkVars = {}

AddMixinNetworkVars(ConsumeMixin, networkVars)

function PizzaGate:GetRequiresPower()
    return false
end

function PizzaGate:PoweredUpNow()
    if not self.powered then
        self.powered = true
    end
    if not self.deployed then
        self.deployed = true
    end    
    return true
end

function PizzaGate:GetIsDeployed()
    return self:GetIsBuilt()
end    


function PizzaGate:OnInitialized()
    PhaseGate.OnInitialized(self)
    InitMixin(self, ConsumeMixin)
    if Server then
        self:AdjustMaxArmor(kTunnelEntranceHealth)
        self:AdjustMaxHealth(kTunnelEntranceArmor)
    end    
     self:SetModel(PizzaGate.kModelName, kAnimationGraph)

end

function PizzaGate:OnConstructionComplete()
    if Server then
        self:AdjustMaxArmor(kMatureTunnelEntranceHealth)
        self:AdjustMaxHealth(kMatureTunnelEntranceArmor)
        self.powered = true
        self.deployed = true
        self:AddTimedCallback( self.PoweredUpNow, 4 )
    end
end

function PizzaGate:GetDeathIconIndex()
    return kDeathMessageIcon.PhaseGate
end

----------------------------------------------------------------------------------------
--this is local function from PhaseGate.lua so no choice but to copy it :/ 

-- Offset about the phase gate origin where the player will spawn
local kSpawnOffset = Vector(0, 0.1, 0)

-- Transform angles, view angles and velocity from srcCoords to destCoords (when going through phase gate)
local function TransformPlayerCoordsForPhaseGate(player, srcCoords, dstCoords)

    local viewCoords = player:GetViewCoords()
    
    -- If we're going through the backside of the phase gate, orient us
    -- so we go out of the front side of the other gate.
    if Math.DotProduct(viewCoords.zAxis, srcCoords.zAxis) < 0 then
    
        srcCoords.zAxis = -srcCoords.zAxis
        srcCoords.xAxis = -srcCoords.xAxis
        
    end
    
    -- Redirect player velocity relative to gates
    local invSrcCoords = srcCoords:GetInverse()
    local invVel = invSrcCoords:TransformVector(player:GetVelocity())
    local newVelocity = dstCoords:TransformVector(invVel)
    player:SetVelocity(newVelocity)
    
    local viewCoords = dstCoords * (invSrcCoords * viewCoords)
    local viewAngles = Angles()
    viewAngles:BuildFromCoords(viewCoords)
    
    player:SetBaseViewAngles(Angles(0,0,0))
    player:SetViewAngles(viewAngles)
    
end

--override
function PizzaGate:Phase(user)

    if self.phase then
        return false
    end

    --if HasMixin(user, "PhaseGateUser") and self.linked then
      if user:GetTeamNumber() == 2 and self.linked then -- hopefully not commanders lol

        local destinationCoords = Angles(0, self.targetYaw, 0):GetCoords()
        destinationCoords.origin = self.destinationEndpoint
        
        user:OnPhaseGateEntry(self.destinationEndpoint) --McG: Obsolete for PGs themselves, but required for Achievements
        
        TransformPlayerCoordsForPhaseGate(user, self:GetCoords(), destinationCoords)
        
        user:SetOrigin(self.destinationEndpoint)

        --Mark PG to trigger Phase/teleport FX next update loop. This does incure a _slight_ delay in FX but it's worth it
        --to remove the need for the plyaer-centric 2D sound, and simplify effects definitions
        self.performedPhaseLastUpdate = true

        self.timeOfLastPhase = Shared.GetTime()
        
        return true
        
    end
    
    return false

end

   function PizzaGate:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.TunnelEntrance
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end

function PizzaGate:CorrodeOnInfestation()
    return false
end

function PizzaGate:GetTechId()
    return kTechId.PhaseGate --this will cause LevelsMixin to give the same armor as PG rather than tunnelentrance-bug
end

Shared.LinkClassToMap("PizzaGate", PizzaGate.kMapName, networkVars) 
