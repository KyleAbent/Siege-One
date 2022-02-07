--overrides

local function SharedUpdate(self)
    PROFILE("PhaseGateUserMixin:OnUpdate")
    if self:GetCanPhase() then
    local entity = "PhaseGate"
    if self:isa("Alien") then
        entity = "PizzaGate"
            --marines can still find PizzaGate because is considered PhaseGate
    end
        
        for _, phaseGate in ipairs(GetEntitiesForTeamWithinRange(entity, self:GetTeamNumber(), self:GetOrigin(), 0.5)) do
        
            if phaseGate:GetIsDeployed() and GetIsUnitActive(phaseGate) and phaseGate:Phase(self) then

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

--local orig = PhaseGateUserMixin.OnProcessMove

function PhaseGateUserMixin:OnProcessMove(input)
    SharedUpdate(self)
end

-- for non players
if Server then

    function PhaseGateUserMixin:OnUpdate(deltaTime)    
        SharedUpdate(self)
    end

end