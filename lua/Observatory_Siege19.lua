local function DestroyRelevancyPortal(self)
    if self.beaconRelevancyPortal ~= -1 then
        Server.DestroyRelevancyPortal(self.beaconRelevancyPortal)
        self.beaconRelevancyPortal = -1
    end
end

local function GetIsPlayerNearby(_, player, toOrigin)
    return (player:GetOrigin() - toOrigin):GetLength() < Observatory.kDistressBeaconRange
end
local function TriggerMarineBeaconEffects(self)

    for index, player in ipairs(GetEntitiesForTeam("Player", self:GetTeamNumber())) do
    
        if player:GetIsAlive() and (player:isa("Marine") or player:isa("Exo")) then
            player:TriggerEffects("player_beacon")
        end
    
    end

end
local function GetPlayersToBeacon(self, toOrigin)

    local players = { }
    
    for index, player in ipairs(self:GetTeam():GetPlayers()) do
    
        // Don't affect Commanders or Heavies
        if player:isa("Marine") or player:isa("Exo") then
        
            // Don't respawn players that are already nearby.
            if not GetIsPlayerNearby(self, player, toOrigin) then
            
                if player:isa("Exo") then
                    table.insert(players, 1, player)
                else
                    table.insert(players, player)
                end
                
            end
            
        end
        
    end

    return players
    
end

local origButtons = Observatory.GetTechButtons
function Observatory:GetTechButtons(techId)

    local techButtons = origButtons(self, techId)
    
    techButtons[3] = kTechId.AdvancedBeacon
    if GetSiegeDoorOpen() and not GetTimer():GetHasSiegeBeaconed() then
        techButtons[4] = kTechId.SiegeBeacon
    else
         techButtons[4] = kTechId.None
    end
    techButtons[5] = kTechId.Detector
    
    return techButtons
    
     
end

------------Advanced Beacon------------------------------

function Observatory:TriggerAdvancedBeacon()

    local success = false
    
    if not self:GetIsBeaconing() and not self:GetIsAdvancedBeaconing() and not self:GetIsSiegeBeaconing() then

        self.distressBeaconSound:Start()

        local origin = self:GetDistressOrigin()
        
        if origin then
        
            self.distressBeaconSound:SetOrigin(origin)

            // Beam all faraway players back in a few seconds!
           // self.distressBeaconTime = Shared.GetTime() + Observatory.kDistressBeaconTime
              self.advancedBeaconTime = Shared.GetTime() + Observatory.kDistressBeaconTime
            if Server then
            
                TriggerMarineBeaconEffects(self)
                
                local location = GetLocationForPoint(self:GetDistressOrigin())
                local locationName = location and location:GetName() or ""
                local locationId = Shared.GetStringIndex(locationName)
                SendTeamMessage(self:GetTeam(), kTeamMessageTypes.Beacon, locationId)
                
            end
            
            success = true
        
        end
    
    end
    
    return success, not success
    
end
function Observatory:CancelAdvancedBeacon()

    self.advancedBeaconTime = nil
    self.distressBeaconSound:Stop()

end

function Observatory:PerformAdvancedBeacon()

    self.distressBeaconSound:Stop()
    self.lastbeacon = Shared.GetTime()
    local anyPlayerWasBeaconed = false
    local successfullPositions = {}
    local successfullExoPositions = {}
    local failedPlayers = {}
    
    local distressOrigin = self:GetDistressOrigin()
    if distressOrigin then
    
            // Respawn DeadPlayers
                        for _, entity in ientitylist(Shared.GetEntitiesWithClassname("MarineSpectator")) do
                          if entity:GetTeamNumber() == 1 and not entity:GetIsAlive() then
                          //Print("Found dead player, trying to revive...")
                          entity:SetCameraDistance(0)
                          entity:GetTeam():ReplaceRespawnPlayer(entity, distressOrigin)
                          end
                        end
                        
                        
        for index, player in ipairs(GetPlayersToBeacon(self, distressOrigin)) do
        
            local success, respawnPoint = self:RespawnPlayer(player, distressOrigin)
            if success then
            
                anyPlayerWasBeaconed = true
                if player:isa("Exo") then
                    table.insert(successfullExoPositions, respawnPoint)
                end
                    
                table.insert(successfullPositions, respawnPoint)
                
            else
                table.insert(failedPlayers, player)
            end
            
        end
        

            
        
    end
    
    local usePositionIndex = 1
    local numPosition = #successfullPositions

    for i = 1, #failedPlayers do
    
        local player = failedPlayers[i]  
    
        if player:isa("Exo") then        
            player:SetOrigin(successfullExoPositions[math.random(1, #successfullExoPositions)])  
            player:SetCameraDistance(0)      
        else
              
            player:SetOrigin(successfullPositions[usePositionIndex])
            player:SetCameraDistance(0) 
            if player.TriggerBeaconEffects then
                player:TriggerBeaconEffects()
                player:SetCameraDistance(0)  
            end
            
            usePositionIndex = Math.Wrap(usePositionIndex + 1, 1, numPosition)
            
        end    
    
    end

    if anyPlayerWasBeaconed then
        self:TriggerEffects("distress_beacon_complete")
    end
    
end
function Observatory:CancelAdvancedBeacon()

    self.advancedBeaconTime = nil
    self.distressBeaconSound:Stop()

end
function Observatory:CancelSiegeBeacon()

    self.siegeBeaconTime = nil
    self.distressBeaconSound:Stop()

end
function Observatory:SetPowerOff()    
    
    // Cancel distress beacon on power down
    if self:GetIsBeaconing() or self:GetIsAdvancedBeaconing() or self:GetIsSiegeBeaconing() then    
        self:CancelDistressBeacon()  
        self:CancelSiegeBeacon()  
        self:CancelAdvancedBeacon() 
  
    end

end
function Observatory:GetIsAdvancedBeaconing()
    return self.advancedBeaconTime ~= nil
end
function Observatory:GetIsSiegeBeaconing()
    return self.siegeBeaconTime ~= nil
end
if Server then

    function Observatory:OnKill(killer, doer, point, direction)
    
    // Cancel distress beacon on power down
    if self:GetIsBeaconing() or self:GetIsAdvancedBeaconing() or self:GetIsSiegeBeaconing() then    
        self:CancelDistressBeacon()  
        self:CancelSiegeBeacon()  
        self:CancelAdvancedBeacon() 
  
    end
        ScriptActor.OnKill(self, killer, doer, point, direction)

    end

end
----------------------------Siege Beacon-------------------------------
function Observatory:TriggerSiegeBeacon()

    local success = false
    
    if not self:GetIsBeaconing() and not self:GetIsAdvancedBeaconing() and not self:GetIsSiegeBeaconing() then

        self.distressBeaconSound:Start()

        local origin = self:GetSiegePowerOrigin()
        
        if origin then
        
            self.distressBeaconSound:SetOrigin(origin)

            // Beam all faraway players back in a few seconds!
           // self.distressBeaconTime = Shared.GetTime() + Observatory.kDistressBeaconTime
              self.siegeBeaconTime = Shared.GetTime() + Observatory.kDistressBeaconTime
            if Server then
            
                TriggerMarineBeaconEffects(self)
                
                local location = GetLocationForPoint(origin)
                local locationName = location and location:GetName() or ""
                local locationId = Shared.GetStringIndex(locationName)
                SendTeamMessage(self:GetTeam(), kTeamMessageTypes.Beacon, locationId)
                
            end
            
            success = true
        
        end
    
    end
    
    return success, not success
    
end
function Observatory:GetSiegePowerOrigin()
    local siegepower = nil
      for _, entity in ientitylist(Shared.GetEntitiesWithClassname("PowerPoint")) do
          if GetIsInSiege(entity) then
             return entity:GetOrigin()
          end
      end
    return nil
end


function Observatory:PerformSiegeBeacon()
    GetTimer():SetSiegeBeaconed(true)
    self.distressBeaconSound:Stop()
    self.lastbeacon = Shared.GetTime()
    local anyPlayerWasBeaconed = false
    local successfullPositions = {}
    local successfullExoPositions = {}
    local failedPlayers = {}
    
    local siegePowerOrigin = self:GetSiegePowerOrigin()
    if not siegePowerOrigin then return end
    local distressOrigin =  FindFreeSpace(siegePowerOrigin) 
    if distressOrigin then
    
            // Respawn DeadPlayers
                        for _, entity in ientitylist(Shared.GetEntitiesWithClassname("MarineSpectator")) do
                          if entity:GetTeamNumber() == 1 and not entity:GetIsAlive() then
                          entity:SetCameraDistance(0)
                          entity:GetTeam():ReplaceRespawnPlayer(entity, distressOrigin)
                          end
                        end
                        
                        
        for index, player in ipairs(GetPlayersToBeacon(self, distressOrigin)) do
        
            local success, respawnPoint = self:RespawnPlayer(player, distressOrigin)
            if success then
            
                anyPlayerWasBeaconed = true
                if player:isa("Exo") then
                    table.insert(successfullExoPositions, respawnPoint)
                end
                    
                table.insert(successfullPositions, respawnPoint)
                
            else
                table.insert(failedPlayers, player)
            end
            
        end
        

            
        
    end
    
    local usePositionIndex = 1
    local numPosition = #successfullPositions

    for i = 1, #failedPlayers do
    
        local player = failedPlayers[i]  
    
        if player:isa("Exo") then        
            player:SetOrigin(successfullExoPositions[math.random(1, #successfullExoPositions)])  
            player:SetCameraDistance(0)      
        else
              
            player:SetOrigin(distressOrigin)
            player:SetCameraDistance(0) 
            if player.TriggerBeaconEffects then
                player:TriggerBeaconEffects()
                player:SetCameraDistance(0)  
            end
            
            usePositionIndex = Math.Wrap(usePositionIndex + 1, 1, numPosition)
            
        end    
    
    end

    if anyPlayerWasBeaconed then
        self:TriggerEffects("distress_beacon_complete")
    end
    
end

local origPowerOff = Observatory.SetPowerOff
function Observatory:SetPowerOff()    
 
    // Cancel distress beacon on power down
    if self:GetIsBeaconing() then    
        self:CancelDistressBeacon()  
        self:CancelAdvancedBeacon()  
        self:CancelDistressBeacon() 
    end

end
function Observatory:PerformActivation(techId, position, normal, commander)

    local success = false
    
    if GetIsUnitActive(self) then
    
        if techId == kTechId.DistressBeacon then
            return self:TriggerDistressBeacon()
        end
        if techId == kTechId.SiegeBeacon then
            return self:TriggerSiegeBeacon()
        end
        if techId == kTechId.AdvancedBeacon then
                  //if not self:GetIsPowered() then
                  // self:SetPowerSurgeDuration(5)
                   //end
           return self:TriggerAdvancedBeacon()
         end
        
    end
    
    return ScriptActor.PerformActivation(self, techId, position, normal, commander)
    
end

function Observatory:GetIsAdvancedBeaconing()
    return self.advancedBeaconTime ~= nil
end
function Observatory:GetIsSiegeBeaconing()
    return self.siegeBeaconTime ~= nil
end
------
function Observatory:OnUpdate(deltaTime)
    
    ScriptActor.OnUpdate(self, deltaTime)

    if self:GetIsBeaconing() and (Shared.GetTime() >= self.distressBeaconTime) then
        self:PerformDistressBeacon()
        DestroyRelevancyPortal(self)
        self.distressBeaconTime = nil
    elseif self:GetIsAdvancedBeaconing() and (Shared.GetTime() >= self.advancedBeaconTime) then
        self:PerformAdvancedBeacon()
        DestroyRelevancyPortal(self)
        self.advancedBeaconTime = nil
    elseif self:GetIsSiegeBeaconing() and (Shared.GetTime() >= self.siegeBeaconTime) then
        self:PerformSiegeBeacon()
        DestroyRelevancyPortal(self)
        self.siegeBeaconTime = nil
    end

    if self.beaconRelevancyPortal ~= -1 and ( self.distressBeaconTime or self.advancedBeaconTime or self.siegeBeaconTime) then
        local rangeFrac = 1.0 - math.min(math.max(self.distressBeaconTime - Shared.GetTime(), 0) / self.kDistressBeaconTime, 1.0)
        local range = self.kRelevancyPortalRange * rangeFrac
        Server.SetRelevancyPortalRange(self.beaconRelevancyPortal, range)
    end
 
end
local function GetRecentlyAdvBeaconed(self)
    if not self.lastbeacon then
        return false
    else
        return (self.lastbeacon + 15) > Shared.GetTime()
    end
end
function Observatory:GetIsPowered()
    if GetRecentlyAdvBeaconed(self) then
        return false
    else
        return PowerConsumerMixin.GetIsPowered(self)
    end
 end

