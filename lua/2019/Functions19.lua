----------------------------Fade Trail-----------------------------------------------------------
if Server then

   local function CreateEffectModified(player, effectName, parent, coords, attachPoint)
            local kMapName = "particleeffect"
            local entity = Server.CreateEntity(effectName)
            local assetIndex = Shared.GetCinematicIndex(effectName)
                  entity.assetIndex = assetIndex
                  entity:SetCoords(coords)
                  entity.lifeTime = 0.2
   end

end

if Client then


    local function CreateEffectModified(player, effectName, parent, coords, attachPoint, view)
    
        local zone = RenderScene.Zone_Default
        if view then
            zone = RenderScene.Zone_ViewModel
        end
        
        local cinematic = Client.CreateCinematic(zone)
        if not cinematic then return end -- Out of memory / invalid zone
        
        cinematic:SetCinematic(effectName)
        cinematic:SetParent(parent)
        
        if coords ~= nil then
            cinematic:SetCoords(coords)
        end
        
        
    end
    
    
    function Shared.CreateEffectModified(player, effectName, parent, coords)
        if player == nil or not Shared.GetIsRunningPrediction() then
            CreateEffectModified(player, effectName, parent, coords)
        end
    end
    
end
------------------------------------------------------------------------------------------------------
function FindFreeSpace(where, mindistance, maxdistance, infestreq)    
     if not mindistance then mindistance = 2 end
     if not maxdistance then maxdistance = 24 end
        for index = 1, 50 do //#math.random(4,8) do
           local extents = LookupTechData(kTechId.Skulk, kTechDataMaxExtents, nil)
           local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(extents)  
           //local spawnPoint = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, where, mindistance, maxdistance, EntityFilterAll())
           local spawnPoint = GetRandomPointsWithinRadius(GetGroundAtPosition(where, nil, PhysicsMask.AllButPCs, extents), mindistance, maxdistance, 20, 1, 1, nil, validationFunc)
            if #spawnPoint >= 1 then
                spawnPoint = spawnPoint[1]
           end
        
           if spawnPoint ~= nil then
             spawnPoint = GetGroundAtPosition(spawnPoint, nil, PhysicsMask.AllButPCs, extents)
           end
        
           local location = spawnPoint and GetLocationForPoint(spawnPoint)
           local locationName = location and location:GetName() or ""
           local wherelocation = GetLocationForPoint(where)
           wherelocation = wherelocation and wherelocation.name or nil
           local sameLocation = spawnPoint ~= nil and locationName == wherelocation
           
           if infestreq then
             sameLocation = sameLocation and GetIsPointOnInfestation(spawnPoint)
           end
        
           if spawnPoint ~= nil and sameLocation  and spawnPoint ~= where then
              return spawnPoint
           end
       end
--           Print("No valid spot found for FindFreeSpace")
         -- if infestreq and not GetIsPointOnInfestation(where) then
            -- if Server then CreateEntity(Cyst.kMapName, FindFreeSpace(where,1, 6),  2) end
             --For now anyway, bite me. Remove later? :X or tres spend. Who knows right now. I wanna see this in action.
        --  end
          
           return where
end

function FindFreeMarineBaseConsSpace(where, mindistance, maxdistance, infestreq)    
     if not mindistance then mindistance = 2 end
     if not maxdistance then maxdistance = 24 end
        for index = 1, 75 do //#math.random(4,8) do
           local extents = LookupTechData(kTechId.CommandStation, kTechDataMaxExtents, nil)
           local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(extents)  
           //local spawnPoint = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, where, mindistance, maxdistance, EntityFilterAll())
           local spawnPoint = GetRandomPointsWithinRadius(GetGroundAtPosition(where, nil, PhysicsMask.AllButPCs, extents), mindistance, maxdistance, 20, 1, 1, nil, validationFunc)
            if #spawnPoint >= 1 then
                spawnPoint = spawnPoint[1]
           end
        
           if spawnPoint ~= nil then
             spawnPoint = GetGroundAtPosition(spawnPoint, nil, PhysicsMask.AllButPCs, extents)
           end
        
           local location = spawnPoint and GetLocationForPoint(spawnPoint)
           local locationName = location and location:GetName() or ""
           local wherelocation = GetLocationForPoint(where)
           wherelocation = wherelocation and wherelocation.name or nil
           local sameLocation = spawnPoint ~= nil and locationName == wherelocation
           
           if infestreq then
             sameLocation = sameLocation and GetIsPointOnInfestation(spawnPoint)
           end
            
           local consInRange = GetEntitiesWithMixinWithinRange("Construct", spawnPoint, 4)
           if spawnPoint ~= nil and sameLocation  and spawnPoint ~= where and #consInRange == 0 then
              return spawnPoint
           end
       end
--           Print("No valid spot found for FindFreeSpace")
         -- if infestreq and not GetIsPointOnInfestation(where) then
            -- if Server then CreateEntity(Cyst.kMapName, FindFreeSpace(where,1, 6),  2) end
             --For now anyway, bite me. Remove later? :X or tres spend. Who knows right now. I wanna see this in action.
        --  end
          
           return where
end
function FindFreeIPSpace(where, mindistance, maxdistance, infestreq)    
     if not mindistance then mindistance = 2 end
     if not maxdistance then maxdistance = 24 end
        for index = 1, 50 do //#math.random(4,8) do
           local extents = LookupTechData(kTechId.ReadyRoomExo, kTechDataMaxExtents, nil)
           local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(extents)  
           //local spawnPoint = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, where, mindistance, maxdistance, EntityFilterAll())
           local spawnPoint = GetRandomPointsWithinRadius(GetGroundAtPosition(where, nil, PhysicsMask.AllButPCs, extents), mindistance, maxdistance, 20, 1, 1, nil, validationFunc)
            if #spawnPoint >= 1 then
                spawnPoint = spawnPoint[1]
           end
        
           if spawnPoint ~= nil then
             spawnPoint = GetGroundAtPosition(spawnPoint, nil, PhysicsMask.AllButPCs, extents)
           end
        
           local location = spawnPoint and GetLocationForPoint(spawnPoint)
           local locationName = location and location:GetName() or ""
           local wherelocation = GetLocationForPoint(where)
           wherelocation = wherelocation and wherelocation.name or nil
           local sameLocation = spawnPoint ~= nil and locationName == wherelocation
           
           if infestreq then
             sameLocation = sameLocation and GetIsPointOnInfestation(spawnPoint)
           end
        
           local ipinrange = GetEntitiesWithinRange("InfantryPortal", spawnPoint, 3)
           if spawnPoint ~= nil and sameLocation  and spawnPoint ~= where and #ipinrange == 0 then
              return spawnPoint
           end
       end
--           Print("No valid spot found for FindFreeSpace")
         -- if infestreq and not GetIsPointOnInfestation(where) then
            -- if Server then CreateEntity(Cyst.kMapName, FindFreeSpace(where,1, 6),  2) end
             --For now anyway, bite me. Remove later? :X or tres spend. Who knows right now. I wanna see this in action.
        --  end
          
           return where
end
function FindFreeIPSpace(where, mindistance, maxdistance, infestreq)    
     if not mindistance then mindistance = 2 end
     if not maxdistance then maxdistance = 24 end
        for index = 1, 50 do //#math.random(4,8) do
           local extents = LookupTechData(kTechId.ReadyRoomExo, kTechDataMaxExtents, nil)
           local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(extents)  
           //local spawnPoint = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, where, mindistance, maxdistance, EntityFilterAll())
           local spawnPoint = GetRandomPointsWithinRadius(GetGroundAtPosition(where, nil, PhysicsMask.AllButPCs, extents), mindistance, maxdistance, 20, 1, 1, nil, validationFunc)
            if #spawnPoint >= 1 then
                spawnPoint = spawnPoint[1]
           end
        
           if spawnPoint ~= nil then
             spawnPoint = GetGroundAtPosition(spawnPoint, nil, PhysicsMask.AllButPCs, extents)
           end
        
           local location = spawnPoint and GetLocationForPoint(spawnPoint)
           local locationName = location and location:GetName() or ""
           local wherelocation = GetLocationForPoint(where)
           wherelocation = wherelocation and wherelocation.name or nil
           local sameLocation = spawnPoint ~= nil and locationName == wherelocation
           
           if infestreq then
             sameLocation = sameLocation and GetIsPointOnInfestation(spawnPoint)
           end
        
           local ipinrange = GetEntitiesWithinRange("InfantryPortal", spawnPoint, 3)
           if spawnPoint ~= nil and sameLocation  and spawnPoint ~= where and #ipinrange == 0 then
              return spawnPoint
           end
       end
--           Print("No valid spot found for FindFreeSpace")
         -- if infestreq and not GetIsPointOnInfestation(where) then
            -- if Server then CreateEntity(Cyst.kMapName, FindFreeSpace(where,1, 6),  2) end
             --For now anyway, bite me. Remove later? :X or tres spend. Who knows right now. I wanna see this in action.
        --  end
          
           return where
end
function GetIsInFrontDoorRoom(who)

    local door = GetNearest(who:GetOrigin(), "FrontDoor", nil,  function(ent) return ent:isa("FrontDoor") and GetLocationForPoint(who:GetOrigin()) == GetLocationForPoint(ent:GetOrigin()) end ) // or within range a room over?
    if door then
        return true
    end

    return false 
                
end

function notifycommander(who,techid)

end

/*

function notifyglow(who)
  
end

*/


function GetNearestMixin(origin, mixinType, teamNumber, filterFunc)
    assert(type(mixinType) == "string")
    local nearest = nil
    local nearestDistance = 0
    for index, ent in ientitylist(Shared.GetEntitiesWithTag(mixinType)) do
        if not filterFunc or filterFunc(ent) then
            if teamNumber == nil or (teamNumber == ent:GetTeamNumber()) then
                local distance = (ent:GetOrigin() - origin):GetLength()
                if nearest == nil or distance < nearestDistance then
                    nearest = ent
                    nearestDistance = distance
                end
            end
        end
    end
    return nearest
end
function GetIsRoomPowerUp(who)
 local location = GetLocationForPoint(who:GetOrigin())
  if not location then return false end
 local powernode = GetPowerPointForLocation(location.name)
 if powernode and powernode:GetIsBuilt() and not powernode:GetIsDisabled()  then return true end
 return false
end
function GetSiegeLocation(where)
--local locations = {}


 local siegeloc = nil

  siegeloc = GetNearest(where, "Location", nil, function(ent) return string.find(ent.name, "siege") or string.find(ent.name, "Siege") end)

 
if siegeloc then return siegeloc end
 return nil
end

function GetIsOriginInHiveRoom(point)  
 local location = GetLocationForPoint(point)
 local hivelocation = nil
     local hives = GetEntitiesWithinRange("Hive", point, 999)
     if not hives then return false end
     
     for i = 1, #hives do  --better way to do this i know
     local hive = hives[i]
     hivelocation = GetLocationForPoint(hive:GetOrigin())
     break
     end
     
     if location == hivelocation then return true end
     
     return false
     
end


function GetIsTimeUp(timeof, timelimitof)
 local time = Shared.GetTime()
 local boolean = (timeof + timelimitof) < time
 --Print("timeof is %s, timelimitof is %s, time is %s", timeof, timelimitof, time)
 -- if boolean == true then Print("GetTimeIsUp boolean is %s, timelimitof is %s", boolean, timelimitof) end
 return boolean
end


function GetSetupConcluded()
return GetFrontDoorOpen()
end
function GetFrontDoorOpen()
   return GetTimer():GetFrontOpenBoolean()
end
function GetSiegeDoorOpen()
   local boolean = GetTimer():GetSiegeOpenBoolean()
   return boolean
end




function GetSiegeDoor() --it washed away
    local entityList = Shared.GetEntitiesWithClassname("SiegeDoor")
    if entityList:GetSize() > 0 then
                 local siegedoor = entityList:GetEntityAtIndex(0) 
                 return siegedoor
    end    
    return nil
end
function GetTimer() --it washed away
    local entityList = Shared.GetEntitiesWithClassname("Timer")
    if entityList:GetSize() > 0 then
                 local timer = entityList:GetEntityAtIndex(0) 
                 return timer
    end    
    return nil
end

function GetGameStarted()
  if Server then
    local gamestarted = false
    if GetGamerules():GetGameState() == kGameState.Started or GetGamerules():GetGameState() == kGameState.Countdown then gamestarted = true end
    return gamestarted
   end
end
function GetIsInSiege(who)
local locationName = GetLocationForPoint(who:GetOrigin())
                     locationName = locationName and locationName.name or nil
                     if locationName== nil then return false end
if locationName and string.find(locationName, "siege") or string.find(locationName, "Siege") then return true end
return false
end

function GetWhereIsInSiege(where)
local locationName = GetLocationForPoint(where)
                     locationName = locationName and locationName.name or nil
                     if locationName== nil then return false end
if string.find(locationName, "siege") or string.find(locationName, "Siege") then return true end
return false
end

