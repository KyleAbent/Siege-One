Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")


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




Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars, true)