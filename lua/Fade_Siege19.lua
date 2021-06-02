Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")
Script.Load("lua/CloakableMixin.lua") //to allow the hook

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



Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars, true)