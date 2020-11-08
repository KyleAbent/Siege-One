--Kyle 'Avoca' Abent - Skip the "Tunnel" entity - lower the entity count by not requiring it in the first place
Script.Load("lua/MinimapConnectionMixin.lua")

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
     self:AddTimedCallback(TunnelEntrance.DoOther, 0.3)
     self:AddTimedCallback(TunnelEntrance.DoOther, 0.5)
     self:AddTimedCallback(TunnelEntrance.DoOther, 0.7)
     self:AddTimedCallback(TunnelEntrance.DoOther, 0.9)
end



function TunnelEntrance:GetMiniMapColors()
    --local otherEntrance = self:GetOtherEntrance()--doesnt work if not built ugh
   -- if not self:GetIsBuilt() then  
    --    return Color(1, 138/255, 0, 1)
   -- else
        local num = self.randomColorNumber
        if num == 1 then
         return ColorIntToColor(0x6638D4)
        elseif num == 2 then
           return ColorIntToColor(0x48CE83)
        elseif num == 3 then
           return ColorIntToColor(0x721E51)
        elseif num == 4 then
           return ColorIntToColor(0x7CFC87)
        elseif num == 5 then
           return ColorIntToColor(0x6E03A3)
        elseif num == 6 then
             return ColorIntToColor(0xDA2BFD)
        elseif num == 7 then
           return ColorIntToColor(0x1BC4D3)
        elseif num == 8 then
           return ColorIntToColor(0xC8ED0C)
        elseif num == 9 then
           return ColorIntToColor(0xA99CFF)
        elseif num == 10 then
           return ColorIntToColor(0x0AD5C2)
        elseif num == 11 then
           return ColorIntToColor(0x9C121C)
        end
   --  end    
      
end

function TunnelEntrance:DoOther()
    

        local otherEntrance = self:GetOtherEntrance()
        if otherEntrance then    
           -- Print("TunnelEntrance DoOther Found otherEntrance") --not working with OnCreate , interesting
            self.randomColorNumber = otherEntrance.randomColorNumber
        --elseif self:GetGorgeOwner() then
            --but if the player drops a tunnel ... 
        else
            if self.randomColorNumber == 12 then
                --Print("TunnelEntrance DoOther randomly choosing number didnt find match")
                self.randomColorNumber = math.random(1,11)
             end
        end
    
        local mapBlip = self.mapBlipId and Shared.GetEntity(self.mapBlipId)
        if mapBlip then
           mapBlip.randomColorNumber = self.randomColorNumber
        end
    return false
end
local origInit = TunnelEntrance.OnInitialized
function TunnelEntrance:OnInitialized()
    
    origInit(self) 
    if Server then
        --self:UpdateConnectedTunnel() --only to match pair so quick lol
        InitMixin(self, MinimapConnectionMixin)
    end
    --self:DoOther()
    --Print("TunnelEntrance OnInitialized randomColorNumber is %s", self.randomColorNumber)
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



Shared.LinkClassToMap("TunnelEntrance", TunnelEntrance.kMapName, networkVars)