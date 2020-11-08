function TunnelEntrance:GetInfestationRadius()
  local frontdoor = GetEntitiesWithinRange("FrontDoor", self:GetOrigin(), 7)
   if #frontdoor >=1 then return 0
   else
    return 7
   end
end

function TunnelEntrance:GetInfestationMaxRadius()
  local frontdoor = GetEntitiesWithinRange("FrontDoor", self:GetOrigin(), 7)
   if #frontdoor >=1 then return 0
   else
    return 7
   end
end

   

    function TunnelEntrance:GetConnectionStartPoint()
    local connection = self.otherEntranceId ~= nil and Shared.GetEntity(self.otherEntranceId) ~= nil
    if connection then
    return self:GetOrigin()
    end

    end

    function TunnelEntrance:GetConnectionEndPoint()
    local connection = self.otherEntranceId ~= nil and Shared.GetEntity(self.otherEntranceId) ~= nil
    if connection then
    return Shared.GetEntity(self.otherEntranceId):GetOrigin()
    end

    end