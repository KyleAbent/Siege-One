Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")
//Script.Load("lua/CloakableMixin.lua") //to allow the hook

local networkVars =
{

}

local kMaxSpeed = 8 --6.2
local kBlinkMaxSpeed = 30 --25
local kBlinkAcceleration = 45 --40
local kMetabolizeAnimationDelay = 0.3--0.65
local kBlinkSpeed = 18--14
-- Additional acceleration after exceeding kBlinkMaxSpeedBase when holding blink
local kBlinkAddAcceleration = 2--1

-- Max speeds for Fade. Soft cap
local kBlinkMaxSpeedBase = 25--19
local kBlinkMaxSpeedCelerity = 30--20.5

-- Air friction vars for softcap
local kCelerityFrictionFactor = 0.04--0.04
local kFastMovingAirFriction = 0.40 --0.40

-- Delay before you can blink again after a blink.
local kMinEnterEtherealTime = 0.4 --0.4

local kFadeGravityMod = 1.0



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
local orig = Fade.GetMaxSpeed
function Fade:GetMaxSpeed(possible)

    local returnValue = orig(self,possible)
    local defaultValue = returnValue
    returnValue = returnValue * (10/100) + returnValue
    return returnValue
end
*/

---------messy override down below

function Fade:GetMaxSpeed(possible)

    if possible then
        return kMaxSpeed
    end

    if self:GetIsBlinking() then
        return kBlinkSpeed
    end

    -- Take into account crouching.
    return kMaxSpeed
end

function Fade:TriggerMetab()
   if self:GetActiveWeapon() ~= nil then
        local weaponMapName = self:GetActiveWeapon():GetMapName()
        local metabweapon = self:GetWeapon(Metabolize.kMapName)
        if metabweapon and not metabweapon:GetHasAttackDelay() and self:GetEnergy() >= metabweapon:GetEnergyCost() then
            self:SetActiveWeapon(Metabolize.kMapName)
            self:PrimaryAttack()
            if weaponMapName ~= Metabolize.kMapName then
                self.previousweapon = weaponMapName
            end
        end
    end
end

local origBlink = Fade.TriggerBlink
function Fade:TriggerBlink()
    --self:TriggerMetab()
    self.ethereal = true
    self.landedAfterBlink = false
end

--I need to override :/ ---------------------------------------------------------
function Fade:GetAirFriction()

    local currentSpeed = self:GetVelocityLength()
    local baseFriction = 0.17

    if self:GetIsBlinking() then

        return 0

    elseif GetHasCelerityUpgrade(self) then

        if currentSpeed > kBlinkMaxSpeedCelerity then
            return kFastMovingAirFriction
        end

        return baseFriction - self:GetSpurLevel() * 0.01

    elseif currentSpeed > kBlinkMaxSpeedBase then

        return kFastMovingAirFriction

    else

        return baseFriction

    end

end


function Fade:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsBlinking() then

        local wishDir = self:GetViewCoords().zAxis
        local maxSpeedTable = { maxSpeed = kBlinkSpeed }
        self:ModifyMaxSpeed(maxSpeedTable, input)
        local prevSpeed = velocity:GetLength()
        local maxSpeed = math.max(prevSpeed, maxSpeedTable.maxSpeed)
        maxSpeed = math.min(kBlinkMaxSpeed, maxSpeed)

        velocity:Add(wishDir * kBlinkAcceleration * deltaTime)

        if velocity:GetLength() > maxSpeed then
            velocity:Normalize()
            velocity:Scale(maxSpeed)
        end

        velocity:Add(wishDir * kBlinkAddAcceleration * deltaTime)
    end

end


function Fade:GetHasMetabolizeAnimationDelay()
    return self.timeMetabolize + kMetabolizeAnimationDelay > Shared.GetTime()
end

local origTriggerBlink = Fade.OnBlinkEnd
function Fade:OnBlinkEnd()
    origTriggerBlink(self)
    self:MovementModifierChanged(true, nil) -- Force hack metab?
end


Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars, true)