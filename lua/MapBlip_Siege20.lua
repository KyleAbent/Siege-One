class 'TunnelMapBlip' (MapBlip)

TunnelMapBlip.kMapName = "TunnelMapBlip"

local TunnelMapBlipNetworkVars =
{
    clientIndex = "entityid",
    randomColorNumber = "integer (1 to 12)",
}


function TunnelMapBlip:InitActivityDefaults()
    local owner = self.ownerEntityId and Shared.GetEntity(self.ownerEntityId)
    self.isInCombatActivity = kMinimapActivity.Medium
    self.movingActivity = kMinimapActivity.Medium
    self.defaultActivity = kMinimapActivity.Medium
    self.randomColorNumber = 12 --I wonder if this will erorr from a tunnel placed across map by someone else? 
end

function TunnelMapBlip:GetMapBlipColor(minimap, item)
    
        
        local num = self.randomColorNumber
         --Print("TunnelMapBlip randomColorNumber is %s", self.randomColorNumber)
        if num == 12 then  
            return Color(1, 138/255, 0, 1)
        elseif num == 1 then
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
    --still will error? :l if one too far away is placeD?
    
 end
        /*
    function TunnelMapBlip:UpdateHook(minimap, item)
            minimap:MatchPairingTunnels(item, self.mapBlipType, self.mapBlipTeam, owner:GetMiniMapColors() )
    end
    */
    
    
if Client then
      function TunnelMapBlip:InitActivityDefaults()
        self.isInCombatActivity = kMinimapActivity.Medium
        self.movingActivity = kMinimapActivity.Medium
        self.defaultActivity = kMinimapActivity.Medium
      end
 


end




Shared.LinkClassToMap("TunnelMapBlip", TunnelMapBlip.kMapName, TunnelMapBlipNetworkVars)

