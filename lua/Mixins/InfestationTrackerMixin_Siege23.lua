InfestationTrackerMixin = CreateMixin( InfestationTrackerMixin )
InfestationTrackerMixin.type = "InfestationTracker"

-- Listen on the state that infested state depends on - ie where we are
InfestationTrackerMixin.expectedCallbacks = {

}

InfestationTrackerMixin.expectedMixins =
{

}

-- What entities have become dirty.
-- Flushed in the UpdateServer hook by InfestationTrackerMixin.OnUpdateServer
InfestationTrackerMixin.dirtyTable = {}

-- Call all dirty entities
function InfestationTrackerMixin.OnUpdateServer()

end

-- Intercept the functions that changes the state the mapblip depends on
function InfestationTrackerMixin:SetOrigin(_)

end
function InfestationTrackerMixin:SetCoords(_)

end

function InfestationTrackerMixin:__initmixin()
 
end

function InfestationTrackerMixin:UpdateInfestedState(onInfestation)

end

function InfestationTrackerMixin:SetInfestationState(onInfestation)


end

function InfestationTrackerMixin:InfestationNeedsUpdate()

end

Event.Hook("UpdateServer", InfestationTrackerMixin.OnUpdateServer)