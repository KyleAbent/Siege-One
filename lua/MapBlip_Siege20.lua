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
    
        /* Has to be done OnInit, doesnt stick outside of radius lol
            --if self.randomColorNumber == 12 then
                local owner = self.ownerEntityId and Shared.GetEntity(self.ownerEntityId)
                    if owner then
                        local otherEntrance = owner:GetOtherEntrance()
                        if otherEntrance then
                            --Print("TunnelMapBlip GetMapBlipColor found OtherEntrance")
                            if self.randomColorNumber ~= otherEntrance.randomColorNumber then
                                owner.randomColorNumber = otherEntrance.randomColorNumber
                                self.randomColorNumber = otherEntrance.randomColorNumber
                                otherEntrance.randomColorNumber = self.randomColorNumber
                                Print("Set colors to match. Self == %s, Other == %s", self.randomColorNumber, otherEntrance.randomColorNumber)
                            end
                        end
                    end
            --end
        */
        
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
 
 /*
    -- the local player has a special marker; do not show his mapblip 
    function TunnelMapBlip:UpdateMinimapActivity(minimap, item)
        if self.clientIndex == minimap.clientIndex then
            return nil
        end
        return MapBlip.UpdateMinimapActivity(self, minimap, item)
    end
    */
    
     /*
    -- players can show their names on the minimap
    function TunnelMapBlip:UpdateHook(minimap, item)
        PROFILE("TunnelMapBlip:UpdateHook")
        if self.randomColorNumber == - 1 then
            local owner = self.ownerEntityId and Shared.GetEntity(self.ownerEntityId)
            if owner then
                local otherEntrance = owner:GetOtherEntrance()
                if otherEntrance then
                    self.randomColorNumber = otherEntrance.randomColorNumber
                else
                    self.randomColorNumber = math.random(1,11)
                end
            end
        end
        --minimap:DrawMinimapName(item, self:GetMapBlipTeam(minimap), self.clientIndex, self.isParasited)
    end
      */

end




Shared.LinkClassToMap("TunnelMapBlip", TunnelMapBlip.kMapName, TunnelMapBlipNetworkVars)



 
    


        /*

local hook = MapBlip.UpdateRelevancy
function MapBlip:UpdateRelevancy()
    local owner = self.ownerEntityId and Shared.GetEntity(self.ownerEntityId)
    if owner then
        if owner:isa("TunnelEntrance") then
            self:SetRelevancyDistance(Math.infinity)
            self:SetExcludeRelevancyMask(kRelevantToTeam2)
        else
            hook(self)
        end
     else
        hook(self)
    end

end    

local hook = MapBlip.UpdateMinimapActivity
function MapBlip:UpdateMinimapActivity(minimap, item)
        PROFILE("MapBlip:UpdateMinimapActivity")

        local owner = self.ownerEntityId and Shared.GetEntity(self.ownerEntityId)
        if  owner and owner:isa("TunnelEntrance") then
            return kMinimapActivity.Static
        end 
    
    return hook(self, minimap, item)
end


    function MapBlip:UpdateHook(minimap, item)
        local owner = self.ownerEntityId and Shared.GetEntity(self.ownerEntityId)
        if owner then
            if owner:isa("TunnelEntrance") and ( owner.GetTunnelEntity and owner:GetTunnelEntity() ~= nil )then
                 minimap:MatchPairingTunnels(item, self.mapBlipType, self.mapBlipTeam, owner:GetMiniMapColors() )
            end
        end
    end
    
    */
    
    
/*
    These functions are only temp - goes back to original color after a while.
    
    local blipRotation = Vector(0,0,0)
    local hook = MapBlip.UpdateMinimapItemHook
    function MapBlip:UpdateMinimapItemHook(minimap, item)
        hook(self,minimap, item)
            local owner = self.ownerEntityId and Shared.GetEntity(self.ownerEntityId)
            if owner then
                if owner:isa("TunnelEntrance") or (owner:isa("MapConnector") and owner:GetTeamNumber() == 2) then
                    --print("Owner is tunnelentrance")
                    self.currentMapBlipColor =  owner:GetMiniMapColors()
                elseif owner:isa("MapConnector") and owner:GetTeamNumber() == 2 then
                    print("Owner is MapConnector")
                    --bleh 
                end
            end
    end
   */