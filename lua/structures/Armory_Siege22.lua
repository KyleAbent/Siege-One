Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")

local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origInit = Armory.OnInitialized
function Armory:OnInitialized()
    origInit(self)
    InitMixin(self, LevelsMixin)
    InitMixin(self, AvocaMixin)
end

function Armory:OnPowerOn()
	GetRoomPower(self):ToggleCountMapName(self:GetMapName(),1)
end

function Armory:OnPowerOff()
	 GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
end

 function Armory:PreOnKill(attacker, doer, point, direction)
	  if GetIsUnitActive(self) then
	    GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1) 
	  end
end

Shared.LinkClassToMap("Armory", Armory.kMapName, networkVars)