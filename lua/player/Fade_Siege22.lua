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

---------messy override down below


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

Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars, true)