--Copy of PhaseGateUserMixin but for Aliens

AlienPhaseGateUserMixin = CreateMixin( AlienPhaseGateUserMixin )
AlienPhaseGateUserMixin.type = "AlienPhaseGateUser"

local kPhaseDelay = 2

AlienPhaseGateUserMixin.networkVars =
{
    timeOfLastPhase = "compensated private time"
}

local function SharedUpdate(self)
    PROFILE("AlienPhaseGateUserMixin:OnUpdate")
    if self:GetCanPhase() then

        for _, alienPhaseGate in ipairs(GetEntitiesForTeamWithinRange("AlienPhaseGate", self:GetTeamNumber(), self:GetOrigin(), 1)) do
        
            if alienPhaseGate:GetIsDeployed() and GetIsUnitActive(alienPhaseGate) and alienPhaseGate:Phase(self) then

                self.timeOfLastPhase = Shared.GetTime()
                
                if Client then               
                    self.timeOfLastPhaseClient = Shared.GetTime()
                    local viewAngles = self:GetViewAngles()
                    Client.SetYaw(viewAngles.yaw)
                    Client.SetPitch(viewAngles.pitch)     
                end
                --[[
                if HasMixin(self, "Controller") then
                    self:SetIgnorePlayerCollisions(1.5)
                end
                --]]
                break
                
            end
        
        end
    
    end

end

function AlienPhaseGateUserMixin:__initmixin()
    
    PROFILE("AlienPhaseGateUserMixin:__initmixin")
    
    self.timeOfLastPhase = 0
end

local kOnPhase =
{
    phaseGateId = "entityid",
    phasedEntityId = "entityid"
}
Shared.RegisterNetworkMessage("OnAlienPhase", kOnPhase)

if Server then

    function AlienPhaseGateUserMixin:OnProcessMove(input)
        PROFILE("AlienPhaseGateUserMixin:OnProcessMove")

        if self:GetCanPhase() then
            for _, alienPhaseGate in ipairs(GetEntitiesForTeamWithinRange("AlienPhaseGate", self:GetTeamNumber(), self:GetOrigin(), 1)) do
                if alienPhaseGate:GetIsDeployed() and GetIsUnitActive(alienPhaseGate) and alienPhaseGate:Phase(self) then
                    -- If we can found a phasegate we can phase through, inform the server
                    self.timeOfLastPhase = Shared.GetTime()
                    local id = self:GetId()
                    Server.SendNetworkMessage(self:GetClient(), "OnAlienPhase", { phaseGateId = alienPhaseGate:GetId(), phasedEntityId = id or Entity.invalidId }, true)
                    self:SetElectrified(5)
                    return
                end
            end
        end
    end

    function AlienPhaseGateUserMixin:OnUpdate(deltaTime)
        SharedUpdate(self)
    end
    
end

if Client then

    local function OnMessagePhase(message)
        PROFILE("AlienPhaseGateUserMixin:OnMessagePhase")

        -- TODO: Is there a better way to do this?
        local alienPhaseGate = Shared.GetEntity(message.phaseGateId)
        local phasedEnt = Shared.GetEntity(message.phasedEntityId)

        -- Need to keep this var updated so that client side effects work correctly
        phasedEnt.timeOfLastPhaseClient = Shared.GetTime()

        alienPhaseGate:Phase(phasedEnt)
        local viewAngles = phasedEnt:GetViewAngles()

        -- Update view angles
        Client.SetYaw(viewAngles.yaw)
        Client.SetPitch(viewAngles.pitch)
    end

    Client.HookNetworkMessage("OnAlienPhase", OnMessagePhase)

end

function AlienPhaseGateUserMixin:GetCanPhase()
    if Server then
        return self:GetIsAlive() and Shared.GetTime() > self.timeOfLastPhase + kPhaseDelay and not GetConcedeSequenceActive()
    else
        return self:GetIsAlive() and Shared.GetTime() > self.timeOfLastPhase + kPhaseDelay
    end
    
end


function AlienPhaseGateUserMixin:OnAlienPhaseGateEntry(destinationOrigin)
    if Server and HasMixin(self, "LOS") then
        self:MarkNearbyDirtyImmediately()
    end
end
