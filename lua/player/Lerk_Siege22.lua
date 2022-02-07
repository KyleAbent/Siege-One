Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/Weapons/Alien/PrimalScream.lua")


local origCreate = Lerk.OnCreate 
function Lerk:OnCreate()
    origCreate(self)
    InitMixin(self, PredictedProjectileShooterMixin)
end

if Server then

    function Lerk:GetTierFourTechId()
        return kTechId.PrimalScream
    end


end



//Shared.LinkClassToMap("Lerk", Lerk.kMapName, networkVars, true)