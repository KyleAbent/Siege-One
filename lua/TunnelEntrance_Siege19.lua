
local networkVars =
{
    index = "integer",
    randomColorNumber = "integer (1 to 12)",
}

local origCreate = TunnelEntrance.OnCreate
function TunnelEntrance:OnCreate()
    origCreate(self)
    self.index = 0
    self.randomColorNumber =  12--math.random(1,11)
    --self:DoOther()
     self:AddTimedCallback(TunnelEntrance.GetMiniMapColors, 0.3)
     self:AddTimedCallback(TunnelEntrance.GetMiniMapColors, 0.5)
     self:AddTimedCallback(TunnelEntrance.GetMiniMapColors, 0.7)
     self:AddTimedCallback(TunnelEntrance.GetMiniMapColors, 0.9)
end

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
  
    
function TunnelEntrance:GetMiniMapColors()
        local owner = self:GetOwner()
        if owner then
            //Print("Found Owner")
            //Print("Owner tunnel color is %s", owner:GetTunnelColor()) 
            self.randomColorNumber = owner:GetTunnelColor()
        else
            //Print("Did not find owner")
            return
        end
        
        local color = ""
        
        local num = self.randomColorNumber
        if num == 1 then
         color = ColorIntToColor(0x6638D4)
        elseif num == 2 then
           color = ColorIntToColor(0x48CE83)
        elseif num == 3 then
           color = ColorIntToColor(0x721E51)
        elseif num == 4 then
           color = ColorIntToColor(0x7CFC87)
        elseif num == 5 then
           color = ColorIntToColor(0x6E03A3)
        elseif num == 6 then
             color = ColorIntToColor(0xDA2BFD)
        elseif num == 7 then
           color = ColorIntToColor(0x1BC4D3)
        elseif num == 8 then
           color = ColorIntToColor(0xC8ED0C)
        elseif num == 9 then
           color = ColorIntToColor(0xA99CFF)
        elseif num == 10 then
           color = ColorIntToColor(0x0AD5C2)
        elseif num == 11 then
           color = ColorIntToColor(0x9C121C)
        end

    -- local otherEntrance = self:GetOtherEntrance()
    -- if otherEntrance then    
    --     self.randomColorNumber = otherEntrance.randomColorNumber
    -- end
           

        local mapBlip = self.mapBlipId and Shared.GetEntity(self.mapBlipId)
        if mapBlip then
           mapBlip.randomColorNumber = self.randomColorNumber
        end
        
    return false
end


 Shared.LinkClassToMap("TunnelEntrance", TunnelEntrance.kMapName, networkVars) 