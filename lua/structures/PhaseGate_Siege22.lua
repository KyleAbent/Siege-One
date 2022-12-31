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
    if Server then
        GetRoomPower(self):ToggleCountMapName(self:GetMapName(), 1)
    end    
end

if Server then
     function PhaseGate:PreOnKill(attacker, doer, point, direction)
            GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
    end
    
end
Shared.LinkClassToMap("PhaseGate", PhaseGate.kMapName, networkVars) 