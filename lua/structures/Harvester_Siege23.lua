Script.Load("lua/InfestationMixin.lua")

local networkVars = {}

AddMixinNetworkVars(InfestationMixin, networkVars)


local origIinit = Harvester.OnInitialized
function Harvester:OnInitialized()
    origIinit(self)
    InitMixin(self, InfestationMixin)
end





function Harvester:GetInfestationRadius()
    return 1
end

function Harvester:GetInfestationMaxRadius()
    return 1
end

--If power is On then set infestation radius 0?