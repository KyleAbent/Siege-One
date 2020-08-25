Script.Load("lua/Weapons/Marine/Grenade.lua")
class 'ExoGrenade' (Grenade)

ExoGrenade.kMapName = "exogrenade"

ExoGrenade.kRadius = 0.05
ExoGrenade.kDetonateRadius = 0.17
ExoGrenade.kMinLifeTime = 0
ExoGrenade.kClearOnImpact = true
ExoGrenade.kClearOnEnemyImpact = true
ExoGrenade.kNeedsHitEntity = false
ExoGrenade.kUseServerPosition = false

local networkVars =
{

}

function ExoGrenade:ProcessNearMiss( targetHit, endPoint )
        if Server then
            self:Detonate( targetHit )
        end
        return true
end


if Server then
        
    function ExoGrenade:ProcessHit(targetHit, surface, normal, endPoint )

            self:Detonate(targetHit, hitPoint )
    end    
end  




if Client then

    function ExoGrenade:OnAdjustModelCoords(modelCoords)

        modelCoords.xAxis = modelCoords.xAxis * 2
        modelCoords.yAxis = modelCoords.yAxis * 2
        modelCoords.zAxis = modelCoords.zAxis * 2
        
    return modelCoords
    
    end
    

end



     
Shared.LinkClassToMap("ExoGrenade", ExoGrenade.kMapName, networkVars)
