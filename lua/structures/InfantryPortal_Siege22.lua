Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")

local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origInit = InfantryPortal.OnInitialized
function InfantryPortal:OnInitialized()
    origInit(self)
    InitMixin(self, LevelsMixin)
    InitMixin(self, AvocaMixin)
end

Shared.LinkClassToMap("InfantryPortal", InfantryPortal.kMapName, networkVars) 
