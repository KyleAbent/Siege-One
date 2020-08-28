/*
Script.Load("lua/BiomassHealthMixin.lua")

local networkVars = {


  
 }
 local orig = Cyst.OnCreate
function Cyst:OnCreate()
    orig(self)
    InitMixin(self, BiomassHealthMixin)

end

function Cyst:GetHealthPerBioMass()
    return kCystHealthPerBioMass
end



Shared.LinkClassToMap("Cyst", Cyst.kMapName, networkVars, true)
*/