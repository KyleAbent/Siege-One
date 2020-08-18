
-- Computes line of sight to entity, set considerObstacles to true to check if any other entity is blocking LOS
local toEntity = Vector()
local hook = GetCanSeeEntity
function GetCanSeeEntity(seeingEntity, targetEntity, considerObstacles, obstaclesFilter)
    if seeingEntity:isa("TunnelEntrance") and targetEntity:isa("Player") and targetEntity:GetTeamNumber() == 2 then
        return true
    end
    
    return hook(seeingEntity, targetEntity, considerObstacles, obstaclesFilter)

end