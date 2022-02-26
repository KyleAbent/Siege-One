
function CloseAllBreakableDoors()
      for _, door in ientitylist(Shared.GetEntitiesWithClassname("BreakableDoor")) do 
               door.open = false
               door:SetHealth(door:GetHealth() + 10)
      end
end

function HookGorgeViaServer(player,tunnel,destroy)
    //goes to FindPlayerTunnels -- this is just for shine hook messaging player in both cases
end
function FindPlayerTunnels(player,pizzatoppings)
    local hasKilled = false
    local toppingsowner = pizzatoppings:GetOwner()
    for _, pizzagate in ipairs( GetEntitiesForTeam("PizzaGate", 2)) do
        if  pizzagate:GetOwner()  ==  toppingsowner then
            if pizzagate ~= pizzatoppings then
                pizzagate:Kill()
                hasKilled = true
                print("HasKilled!")
                --return hasKilled
            end
        end
    end
    return hasKilled
end


/*
if Server then
    function doBuyLocation(who,where,playername)
        --already purchased?
        for _, location in ientitylist(Shared.GetEntitiesWithClassname("Location")) do 
            if location.name == playername then
                return false
            end
        end
        locations = GetAllLocationsWithSameName(where)
        --make sure player doesn't have the word "Siege" in it lol
        local hasSiegeInName = string.find(playername, "siege") or string.find(playername, "Siege")
        if #locations == 0 or GetIsInSiege(who) or hasSiegeInName then
            return false
        end
        for i = 1, #locations do
            location = locations[i]
            location.name = playername
            Shared.PrecacheString(playername)
        end
        return true
    end
end
*/

function ResearchShiftHive()
  local hivey = nil
    for _, hive in ientitylist(Shared.GetEntitiesWithClassname("Hive")) do 
        if hive:GetTechId() == kTechId.Hive and not hive:GetIsResearching() and hive:GetIsBuilt() then
                hivey = hive
        end
    end
    if hivey ~= nil then
        local techId = kTechId.UpgradeToShiftHive
        local tree = GetTechTree(hivey:GetTeamNumber())
        local techNode = tree:GetTechNode(techId)
        if tree:GetTechAvailable(techId) and not techNode:GetResearching() then
             //print("DoResearches [G]")
            hivey:SetResearching(techNode, hivey)
       end
    end
end
function ResearchShadeHive()
  local hivey = nil
    for _, hive in ientitylist(Shared.GetEntitiesWithClassname("Hive")) do 
        if hive:GetTechId() == kTechId.Hive and not hive:GetIsResearching() and hive:GetIsBuilt() then
                hivey = hive
        end
    end
    if hivey ~= nil then
        local techId = kTechId.UpgradeToShadeHive
        local tree = GetTechTree(hivey:GetTeamNumber())
        local techNode = tree:GetTechNode(techId)
        if tree:GetTechAvailable(techId) and not techNode:GetResearching() then
             //print("DoResearches [G]")
            hivey:SetResearching(techNode, hivey)
       end
    end
end

function ResearchCragHive()
  local hivey = nil
    for _, hive in ientitylist(Shared.GetEntitiesWithClassname("Hive")) do 
        if hive:GetTechId() == kTechId.Hive and not hive:GetIsResearching() and hive:GetIsBuilt() then
                hivey = hive
        end
    end
    if hivey ~= nil then
        local techId = kTechId.UpgradeToCragHive
        local tree = GetTechTree(hivey:GetTeamNumber())
        local techNode = tree:GetTechNode(techId)
        if tree:GetTechAvailable(techId) and not techNode:GetResearching() then
             //print("DoResearches [G]")
            hivey:SetResearching(techNode, hivey)
       end
    end
end


function GetIsPointWithinChairRadius(point)     
  
   local cc = GetEntitiesWithinRange("CommandStation", point, ARC.kFireRange)
   if #cc >= 1 then return true end

   return false
end
function GetRandomCC()
    local ccs = {}
    for _, cc in ientitylist(Shared.GetEntitiesWithClassname("CommandStation")) do
        if cc and cc:GetIsBuilt() then table.insert(ccs,cc) end
    end
    return table.random(ccs)
end
function GetHasThreeBuiltHives()
    local count = 0
    for index, hive in ipairs(GetEntitiesForTeam("Hive", 2)) do
        if hive:GetIsBuilt() then 
            count = count + 1
        end
    end
    if count >= 3 then
        return true
    end
    return false
end
function GetWhipFocusTarget()
    local contam = nil
    for _, currentContam in ientitylist(Shared.GetEntitiesWithClassname("Contamination")) do
        contam = currentContam
    end
    if contam ~= nil then
        return contam
    else
        return GetRandomActivePower()
    end
end
function GetHasFourTunnelInHiveRoom()

    local tunnels = GetEntitiesForTeamWithinRange("TunnelEntrance", 2, GetRandomHive():GetOrigin(), 999999) //try catch in the function calling
    if #tunnels == 0 then return false end
    local count = 0
    for i = 1, #tunnels do
        local ent = tunnels[i]
        if GetIsOriginInHiveRoom(ent:GetOrigin()) then
           count = count + 1
        end
    end

    return count == 4  
                
end
function GetDrifterBuff()
    local buffs = {}
    if GetHasShadeHive()  then table.insert(buffs,kTechId.Hallucinate) end
    if GetHasCragHive()  then table.insert(buffs,kTechId.MucousMembrane) end
    if GetHasShiftHive()  then table.insert(buffs,kTechId.EnzymeCloud) end
    return table.random(buffs)
end
function GetHasPGInRoom(where)

    local pgs = GetEntitiesForTeamWithinRange("PhaseGate", 1, where, 999999)
    if #pgs == 0 then return false end
    for i = 1, #pgs do
        local ent = pgs[i]
        if GetLocationForPoint(ent:GetOrigin()) == GetLocationForPoint(where) then return true end
    end

    return false  
                
end

function GetHasTunnelInRoom(where)

    local tunnels = GetEntitiesForTeamWithinRange("TunnelEntrance", 2, where, 999999)
    if #tunnels == 0 then return false end
    for i = 1, #tunnels do
        local ent = tunnels[i]
        if GetLocationForPoint(ent:GetOrigin()) == GetLocationForPoint(where) then return true end
    end

    return false  
                
end
function GetHasThreeChairs()
    local CommandStations = #GetEntitiesForTeam( "CommandStation", 1 )
    if CommandStations >= 3 then
        return true
    end
    return false
end
function GetHasThreeHives()
    local Hives = #GetEntitiesForTeam( "Hive", 2 )
    if Hives >= 3 then
     return true
    end
    return fasle
end
function GetHasAdvancedArmory()
    for index, armory in ipairs(GetEntitiesForTeam("Armory", 1)) do
        if armory:GetTechId() == kTechId.AdvancedArmory then return true end
    end
    return false
end
function TresCheck(team, cost)//True if setup ???
    if team == 1 then
        return GetGamerules().team1:GetTeamResources() >= cost
    elseif team == 2 then
        return GetGamerules().team2:GetTeamResources() >= cost
    end
end
function FindArcHiveSpawn(where)    
    for index = 1, 24 do
        local extents = LookupTechData(kTechId.Skulk, kTechDataMaxExtents, nil)
        local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(extents)  
        local spawnPoint = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, where, 2, 18, EntityFilterAll())
        local inradius = false
        if spawnPoint ~= nil then
            spawnPoint = GetGroundAtPosition(spawnPoint, nil, PhysicsMask.AllButPCs, extents)
            inradius = #GetEntitiesWithinRange("Hive", spawnPoint, ARC.kFireRange) >= 1
        end
         Print("FindArcHiveSpawn inradius is %s", inradius)
        local sameLocation = spawnPoint ~= nil and GetWhereIsInSiege(spawnPoint)
         Print("FindArcHiveSpawn sameLocation is %s", sameLocation)
        if spawnPoint ~= nil and sameLocation and inradius then
            return spawnPoint
        end
    end
     Print("No valid spot found for FindArcHiveSpawn")
    return nil --FindFreeSpace(where, .5, 48)
end
function GetASiegeLocation()
    local siegeloc = nil
    for _, loc in ientitylist(Shared.GetEntitiesWithClassname("Location")) do
        if string.find(loc.name, "siege") or string.find(loc.name, "Siege") and GetPowerPointForLocation(loc.name) ~= nil then
        siegeloc = loc
        end
    end
    if siegeloc then 
        return siegeloc
    end
    return nil
end
function SetDirectorLockedOnEntity(ent)
    if ent ~= nil then 
    
        if GetSetupConcluded() then
            if HasMixin(ent, "Construct") or ent:isa("Drifter") or ent:isa("MAC") then
                return
            end
        end
        
        for _, director in ientitylist(Shared.GetEntitiesWithClassname("AvocaSpectator")) do
            if director:CanChange() then // well this is messy haha , why not have an active table? although would be constantly transition invalid and valid
                 local viporigin = ent:GetOrigin()
                 director:SetOrigin(viporigin)
                 //director:SetOffsetAngles(ent:GetAngles()) //if iscam
                 //local dir = GetNormalizedVector(viporigin - director:GetOrigin())
                 //local angles = Angles(GetPitchFromVector(dir), GetYawFromVector(dir), 0)
                 //director:SetOffsetAngles(angles)
                 director:SetLockOnTarget(ent:GetId())
            end
        end
     end
end
function findDestinationForAlienConst(who)
    
    if GetSiegeDoorOpen() and who:isa("Crag") or who:isa("Shift") and not GetIsPointWithinHiveRadiusForHealWave(who:GetOrigin()) then
        local hive = GetRandomHive()
        if hive then
            return hive
        end
    end

    local random = math.random(1,2)
    if random == 1 then
        local inCombat = GetNearestMixin(who:GetOrigin(), "Combat", 2, function(ent) return ent:GetIsInCombat() end)
        if inCombat then
            return inCombat
        end
    else // Well this will only work if contam is up, and wont do anything otherwise. Like firing a blank.ActualAlienFormula
            //Maybe say if contam is avail then add this option.
        local contam = GetNearest(who:GetOrigin(), "Contamination", 2)
        if contam then
            return contam
        end

    end

end
function doChain(entity) 
    //print("UHHH")
    local where = entity:GetOrigin()
    //if not entity:isa("Contamination") and GetIsPointOnInfestation(where) then return end
    local cyst = GetEntitiesWithinRange("Cyst",where, kCystRedeployRange)
    if (#cyst >=1) then return end
    local conductor = GetConductor()
    local splitPoints = GetCystPoints(entity:GetOrigin(), true, 2)
    for i = 1, #splitPoints do
        //if getIsNearHive(splitPoints[i]) or ( not getHasCystNear(splitPoints[i]) and not GetIsPointOnInfestation(splitPoints[i]) ) then
            local cyst = GetEntitiesWithinRange("Cyst",where, kCystRedeployRange)
            if not (#cyst >=1) then 
            local csyt = CreateEntity(Cyst.kMapName,splitPoints[i],2) //FindFreeSpace(splitPoints[i], 1, 7), 2)
            if not GetSetupConcluded() then csyt:SetConstructionComplete() end
            if i == #splitPoints then //last one
                //conductor:SetMostRecentCyst(cyst:GetId())
                Print("Setting Conductor most recent cyst origin")
                conductor:SetMostRecentCystOrigin(splitPoints[i])
            end 
        end
    end
end
function GetIsPointWithinHiveRadius(point)     
   local hive = GetEntitiesWithinRange("Hive", point, ARC.kFireRange)
   if #hive >= 1 then return true end
   return false
end
function GetIsPointWithinHiveRadiusForHealWave(point)     
   local hive = GetEntitiesWithinRange("Hive", point, Crag.kHealRadius)
   if #hive >= 1 then return true end
   return false
end
function GetIsScanWithinRadius(point)     
   local scan = GetEntitiesWithinRange("Scan", point, kScanRadius)
   if #scan >= 1 then return true end
   return false
end
function InsideLocation(ents, teamnum)
    local origin = nil
    if #ents == 0  then return origin end
    for i = 1, #ents do
        local entity = ents[i]   
            if teamnum == 2 then
                if entity:isa("Alien") and entity:GetIsAlive() and isPathable( entity:GetOrigin() ) then
                    return FindFreeSpace(entity:GetOrigin(), math.random(2, 4), math.random(8,24), true)
                end
            elseif teamnum == 1 then
                if entity:isa("Marine") and entity:GetIsAlive() and isPathable( entity:GetOrigin() ) then
                    return FindFreeSpace(entity:GetOrigin(), math.random(2,4), math.random(8,24), false )
                end
            end 
    end
    return origin
end
function GetAllLocationsWithSameName(origin)
    local location = GetLocationForPoint(origin)
    if not location then return end
    local locations = {}
    local name = location.name
    for _, location in ientitylist(Shared.GetEntitiesWithClassname("Location")) do
        if location.name == name then table.insert(locations, location) end
    end
    return locations
end
function GetHasCragHive()
    for index, hive in ipairs(GetEntitiesForTeam("Hive", 2)) do
       if hive:GetTechId() == kTechId.CragHive then return true end
    end
    return false
end
 function GetHasShiftHive()
    for index, hive in ipairs(GetEntitiesForTeam("Hive", 2)) do
       if hive:GetTechId() == kTechId.ShiftHive then return true end
    end
    return false
end
 function GetHasShadeHive()
    for index, hive in ipairs(GetEntitiesForTeam("Hive", 2)) do
       if hive:GetIsBuilt() and hive:GetTechId() == kTechId.ShadeHive then return true end//only way for it to be shadehive is for it to be built eh?
    end
    return false
end
function GetRandomActivePowerNotInSiege()//bool notSiege, if notSiege true then.. prevent grabbing siege powerpoint..?
      local powers = {}
      for _, power in ientitylist(Shared.GetEntitiesWithClassname("PowerPoint")) do
         if power:GetIsBuilt() and not power:GetIsDisabled() and not GetIsInSiege(power) then
                if isSetup then // I don't want rooms be built which are yet to be undetermined in setup. ugh. players mark ownership by entering room. then spawn.
                    if power:GetHasBeenToggledDuringSetup() then
                        table.insert(powers,power)
                    end
                else
                     table.insert(powers,power) //and not in siege ? Hm?
                end
          end
        end
        return table.random(powers)
end
function GetRandomActivePower()//bool notSiege, if notSiege true then.. prevent grabbing siege powerpoint..?
      local powers = {}
      for _, power in ientitylist(Shared.GetEntitiesWithClassname("PowerPoint")) do
         if power:GetIsBuilt() and not power:GetIsDisabled() then
                if isSetup then // I don't want rooms be built which are yet to be undetermined in setup. ugh. players mark ownership by entering room. then spawn.
                    if power:GetHasBeenToggledDuringSetup() then
                        table.insert(powers,power)
                    end
                else
                     table.insert(powers,power) //and not in siege ? Hm?
                end
          end
        end
        return table.random(powers)
end
function GetHasChairInRoom(where)

    local ccs = GetEntitiesForTeamWithinRange("CommandStation", 1, where, 999999)
    if #ccs == 0 then return false end
    for i = 1, #ccs do
        local ent = ccs[i]//match name? 
        if GetLocationForPoint(ent:GetOrigin()) == GetLocationForPoint(where) then return true end
    end

    return false  
                
end
function GetRandomHive() 
    local hives = {}
    for _, hive in ientitylist(Shared.GetEntitiesWithClassname("Hive")) do 
        table.insert(hives, hive)
    end
    if #hives == 0 then return nil end
    return table.random(hives)
end
function GetRandomDisabledPower()
    local powers = {}
    local isSetup = not GetSetupConcluded()
    for _, power in ientitylist(Shared.GetEntitiesWithClassname("PowerPoint")) do
        if power:GetIsDisabled() and not GetIsInSiege(power) then
            if isSetup then // I don't want rooms be built which are yet to be undetermined in setup. ugh. players mark ownership by entering room. then spawn.
                if power:GetHasBeenToggledDuringSetup() then
                    table.insert(powers,power)
                end
            else
                table.insert(powers,power)
            end
        end
    end
    if #powers == 0 then return nil end
    local power = table.random(powers)
    return  power
end
function GetIsOriginInHiveRoom(point)  
    local location = GetLocationForPoint(point)
    local hivelocation = nil
    local hives = GetEntitiesWithinRange("Hive", point, 999)
    if not hives then return false end

    for i = 1, #hives do  --better way to do this i know
    local hive = hives[i]
    //hivelocation = GetLocationForPoint(hive:GetOrigin())
    // break with 4 tech points we dont want to break here.
    if location ==  GetLocationForPoint(hive:GetOrigin()) then
    return true
    end // return here with loop dont break for 4th.
    end



    return false
end
function GetIsImaginatorMarineEnabled()     
   local imaginator = GetImaginator()
   if imaginator then
    return imaginator:GetIsMarineEnabled()
   end
   return false
end
function GetIsImaginatorAlienEnabled()     
   local imaginator = GetImaginator()
   if imaginator then
    return imaginator:GetIsAlienEnabled()
   end
   return false
end
function GetRatioToSiege()
    
    local gameRules = nil
    local entityList = Shared.GetEntitiesWithClassname("GameInfo")
    if entityList:GetSize() > 0 then
        gameRules = entityList:GetEntityAtIndex(0) 
    end    

    local level = 1
    if not gameRules then return 0.1 end
    if not gameRules:GetGameStarted() then return 0.1 end
    if GetSiegeDoorOpen() then
        return 1
    end 
    local roundlength =   Shared.GetTime()   - ( gameRules:GetStartTime()  )
    local siegetime = GetTimer():GetSiegeLength()
    level = math.round(roundlength/  GetTimer():GetSiegeLength(), 2)
   
    return level 
    
end
function AdjustCystsHPArmor()
    for _, cyst in ientitylist(Shared.GetEntitiesWithClassname("Cyst")) do
        //if not cyst is king?
        cyst:AdjustMaxHPOnTier()
    end
end
function TurnLoneCystsIntoRegular()//Bleh a for loop
    local cysts = {}
    for _, lonecyst in ientitylist(Shared.GetEntitiesWithClassname("LoneCyst")) do
        lonecyst:SetTechId(kTechId.Cyst)
    end

end
function GetRandomCyst()//Bleh a for loop
    local cysts = {}
    for _, cyst in ientitylist(Shared.GetEntitiesWithClassname("Cyst")) do
        if cyst and cyst:GetIsBuilt() and not cyst.isKing then table.insert(cysts,cyst) end
    end
    return table.random(cysts)
end
function GetHasHiveType(type)//Bleh a for loop
    for _, hive in ientitylist(Shared.GetEntitiesWithClassname("Hive")) do
        if type == kTechId.CragHive and hive:GetTechId() == kTechId.CragHive then
            return true
        elseif type == kTechId.ShadeHive and hive:GetTechId() == kTechId.ShadeHive then
             return true
        elseif type == kTechId.ShiftHive and hive:GetTechId() == kTechId.ShiftHive then
             return true
        end
    end
    return false    
end
function GetActivePowerCount()//bool notSiege, if notSiege true then.. prevent grabbing siege powerpoint..?
      local powers = {}
      for _, power in ientitylist(Shared.GetEntitiesWithClassname("PowerPoint")) do
         if power:GetIsBuilt() and not power:GetIsDisabled() then
                table.insert(powers,power) //and not in siege ? Hm?
          end
      end
        return table.count(powers)
end
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
        for index = 1, 100 do //#math.random(4,8) do
           local extents = LookupTechData(kTechId.Harvester, kTechDataMaxExtents, nil)
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
            
           local consInRange = GetEntitiesWithMixinWithinRange("Construct", spawnPoint, 3)
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

function notifycommander(who,techid,order)

end
function helpcommander(who,techid)

end
function NotifyCommanderLimitReached(who)

end
function NotifyCommanderKill(who)

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

function GetOriginInHiveRoom(point)  
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
function GetHiveRoomPower(point)  
 local hivelocation = nil
  local hivepower = nil
     local hives = GetEntitiesWithinRange("Hive", point, 999) //well this may not be the main room we want if the hive is not in the initia lhive room.. like trainsiege/domesiege 4th tech point. but w/e
     if not hives then return false end
     
     for i = 1, #hives do  --better way to do this i know
         local hive = hives[i]
         hivelocation = GetLocationForPoint(hive:GetOrigin())
         break
     end
     
     if hivelocation then
        return GetPowerPointForLocation(hivelocation.name)
     end
end
function GetRoomPowerTryEnsureSetupAlienOwned(who)
    local location = GetLocationForPoint(who:GetOrigin())
    if not location then return false end
    local powernode = GetPowerPointForLocation(location.name) //probably GetNearestPowerPoint .. 
    if powernode and powernode:GetIsDisabled() and powernode:GetHasBeenToggledDuringSetup() then ////HHMMMMM?? 
        return powernode
    end
    return false
end
function GetRoomPower(who)
    local location = GetLocationForPoint(who:GetOrigin())
    if not location then return false end
    local powernode = GetPowerPointForLocation(location.name)
    if powernode then 
        return powernode
    end
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

function GetAutoCommEnabled()
return GetIma
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

function GetKingCyst() 
        for index, king in ientitylist(Shared.GetEntitiesWithClassname("KingCyst")) do
      
          return king
            
    end
end

function GetFrontDoor() 
        for index, door in ientitylist(Shared.GetEntitiesWithClassname("FrontDoor")) do
        
          return door
            
    end
end
function GetSideDoor() 
    local entityList = Shared.GetEntitiesWithClassname("SideDoor")
    if entityList:GetSize() > 0 then
         local door = entityList:GetEntityAtIndex(0) 
         return door
    end   
     return nil 
end
function GetSiegeDoor() 
    for index, door in ientitylist(Shared.GetEntitiesWithClassname("SiegeDoor")) do
        if not door:isa("FrontDoor") and not door:isa("SideDoor") then--because siegedoor is parent lol ugh
            return door
        end  
    end
           
    return nil
end
function GetImaginator() --it's fake
    local entityList = Shared.GetEntitiesWithClassname("Imaginator")
    if entityList:GetSize() > 0 then
                 local timer = entityList:GetEntityAtIndex(0) 
                 return timer
    end    
    return nil
end

function GetConductor() --it's in time
    local entityList = Shared.GetEntitiesWithClassname("Conductor")
    if entityList:GetSize() > 0 then
                 local timer = entityList:GetEntityAtIndex(0) 
                 return timer
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

