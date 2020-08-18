
function MapConnector:GetMiniMapColors()
   -- local tunnel = tunnel = GetNearest(self:GetOrigin(), "TunnelEntrance", 2, function(ent) return self:GetDistance(ent) <= 2   end)
    --if tunnel  then 
    --    return tunnel:GetMiniMapColors()
   -- end
   
    for _, tunnel in ipairs( GetEntitiesForTeamWithinRange("TunnelEntrance", 2, self:GetOrigin(), 2) ) do
            tunnel:GetMiniMapColors()
    end
    
    return Color(1, 138/255, 0, 1)
end