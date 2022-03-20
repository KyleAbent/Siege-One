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

function PhaseGate:OnPowerOn()
	 GetRoomPower(self):ToggleCountMapName(self:GetMapName(), 1)
end

function PhaseGate:OnPowerOff()
	 GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
end

 function PhaseGate:PreOnKill(attacker, doer, point, direction)
      
	  if self:GetIsPowered() then
	    GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
	  end
end

Shared.LinkClassToMap("PhaseGate", PhaseGate.kMapName, networkVars) 