Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/Weapons/Alien/PrimalScream.lua")

--Lerk.XZExtents = 0.28
--Lerk.YExtents = 0.28


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

/*
//Hitboxes aren't updated

function Lerk:GetExtentsOverride()
    return Vector(0.28, 0.28, 0.28) --70% Size
end

if Client then

    function Lerk:OnAdjustModelCoords(modelCoords)

        modelCoords.xAxis = modelCoords.xAxis * 0.7
        modelCoords.yAxis = modelCoords.yAxis * 0.7
        modelCoords.zAxis = modelCoords.zAxis * 0.7
        
    return modelCoords
    
    end
    

end

*/