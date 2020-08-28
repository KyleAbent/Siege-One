Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")

//There's gotta be a way to change the variable without creating a new cinematic for it

local kTrails = {
PrecacheAsset("cinematics/alien/fade/trail_yellow.cinematic"),
PrecacheAsset("cinematics/alien/fade/trail_blue.cinematic"),
PrecacheAsset("cinematics/alien/fade/trail_green.cinematic"),
PrecacheAsset("cinematics/alien/fade/trail_orange.cinematic"),
PrecacheAsset("cinematics/alien/fade/trail_purple.cinematic"),
PrecacheAsset("cinematics/alien/fade/trail_red.cinematic"),
}

local networkVars =
{
    Color = "float (1 to 6 by 1)", //private float? o_O
}

local origCreate = Fade.OnCreate 

function Fade:OnCreate()
    origCreate(self)
    InitMixin(self, PredictedProjectileShooterMixin)
    self.Color = math.random(1,6)
end

if Server then

    function Fade:GetTierFourTechId()
        return kTechId.AcidRocket
    end

end

function Fade:PreUpdateMove(input, runningPrediction)
       if Client then
         self:OnMoveTrail()
       end
end    

if Client then


    function Fade:OnMoveTrail()
        local coords = self:GetCoords() 
              coords.origin = coords.origin + Vector(0, 0.2, 0)
        Shared.CreateEffectModified(nil, kTrails[self.Color], nil, coords )
    end
    
    
end





Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars, true)