Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")
//Script.Load("lua/CloakableMixin.lua") //to allow the hook

local networkVars =
{

}


local origCreate = Fade.OnCreate 

function Fade:OnCreate()
    origCreate(self)
    InitMixin(self, PredictedProjectileShooterMixin)
end

if Server then

    function Fade:GetTierFourTechId()
        return kTechId.AcidRocket
    end

end

/*
local triggerBlink = Fade.TriggerBlink
function Fade:TriggerBlink()
    triggerBlink(self)
    //Print("Blink Triggered")
    self:TriggerUncloak()
end

local endBlinkEnd = Fade.OnBlinkEnd
function Fade:OnBlinkEnd()
    endBlinkEnd(self)
    self:TriggerUncloak()
end
*/

local orig = Fade.GetMaxSpeed
function Fade:GetMaxSpeed(possible)

    local returnValue = orig(self,possible)
    local defaultValue = returnValue
    returnValue = returnValue * (10/100) + returnValue
    --Print("default speed is: %s, buff speed is %s", defaultValue,returnValue)
    return returnValue
end


Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars, true)