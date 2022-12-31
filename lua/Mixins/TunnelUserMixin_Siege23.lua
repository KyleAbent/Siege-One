--Removing and replacing with Siege version of PhaseGateUserMixin for Aliens lol

TunnelUserMixin = CreateMixin( TunnelUserMixin )
TunnelUserMixin.type = "TunnelUser"


TunnelUserMixin.networkVars =
{
}

function TunnelUserMixin:__initmixin()
    //Print("Replacing TunnelUserMixin")
    
end

function TunnelUserMixin:OnUseGorgeTunnel(destinationOrigin)

end

function TunnelUserMixin:GetIsEnteringTunnel()
  
end

function TunnelUserMixin:OnProcessSpectate(deltaTime)

end

-- called before processmove. disable move when sinking in
function TunnelUserMixin:HandleButtonsMixin(input)


end

function TunnelUserMixin:OnProcessMove(input)
    
end

function TunnelUserMixin:OnUpdate(deltaTime)

end

function TunnelUserMixin:SetEnterTunnelDesired(enterTunnelDesired)

    
end

if Server then
    function TunnelUserMixin:GetCanEnterTunnel()

    end
end

function TunnelUserMixin:SetOrigin()

end

function TunnelUserMixin:SetCoords()

end

function TunnelUserMixin:OnCapsuleTraceHit(entity)

end

function TunnelUserMixin:OnUpdateRender()


end
