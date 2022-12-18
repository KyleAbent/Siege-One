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


local orig = Lerk.GetMaxSpeed
function Lerk:GetMaxSpeed(possible)

    local returnValue = orig(self,possible)
    local defaultValue = returnValue
    returnValue = returnValue * (20/100) + returnValue
    --Print("default speed is: %s, buff speed is %s", defaultValue,returnValue)
    return returnValue
end


----Override..

Lerk.kFlapForce = 20--5
Lerk.kFlapForceForward = 20--8.3
Lerk.kFlapForceStrafe = 20 --8.3

Lerk.kGlideAccel = 20 --6
Lerk.kMaxGlideRoll = math.rad(10)

Lerk.kGravity = -7
Lerk.kSwoopGravity = Lerk.kGravity * 6


//Shared.LinkClassToMap("Lerk", Lerk.kMapName, networkVars, true)