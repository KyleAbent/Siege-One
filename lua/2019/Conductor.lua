-- Kyle 'Avoca' Abent
--http://twitch.tv/kyleabent
--https://github.com/KyleAbent/


//If I wanted to lower the front timer, such as: having all tech at start, having each room built super fast without waiting 5-7 min, 
//It would need a JSON from Shine for each map and each room location setting: Marine or Alien toggle who owns the room at the base start of game. 
//This would allow faster construct placement . 

Script.Load("lua/2019/Con_Vars.lua")
class 'Conductor' (Entity)
Conductor.kMapName = "conductor"

local networkVars =

{
    arcSiegeOrig = "vector",//Added a way in to reset this if there's two hives down and 1 hive outside of radius 
    //mostRecentCyst = "entityid"
    mostRecentCystOrig = "vector",
    lastInk = "time", //Global in one location rather than local for every shade in many locations
    lastCrag = "time",
    lastShift = "time",
    lastShade = "time",
    lastDrift = "time",
    lastMac = "time",
    lastArc = "time",
    lastDirection = "time",
}


function Conductor:OnCreate()
    self.arcSiegeOrig = self:GetOrigin()
    self.mostRecentCystOrig = self:GetOrigin()
    self.lastInk = Shared.GetTime()
    self.lastCrag = Shared.GetTime()
    self.lastShift = Shared.GetTime()
    self.lastShade = Shared.GetTime()
    self.lastDrift = Shared.GetTime()
    self.lastMac = Shared.GetTime()
    self.lastArc = Shared.GetTime()
    self.lastDirection = Shared.GetTime()
    self:SetUpdates(true)
end

function Conductor:GetIsInkAllowed()
    return GetHasShadeHive() and GetIsTimeUp(self.lastInk, kShadeInkCooldown)
end
function Conductor:JustInkedNowSetTimer()
    self.lastInk = Shared.GetTime()
end
function Conductor:GetIsCragMovementAllowed()
    return GetIsTimeUp(self.lastCrag, kManageCragInterval)
end
function Conductor:JustMovedCragSetTimer()
    self.lastCrag = Shared.GetTime()
end
function Conductor:GetIsShiftMovementAllowed()
    return GetIsTimeUp(self.lastShift, kManageShiftsInterval)
end
function Conductor:JustMovedShiftSetTimer()
    self.lastShift = Shared.GetTime()
end
function Conductor:GetIsShadeMovementAllowed()
    return GetIsTimeUp(self.lastShade, kManageShadeInterval)
end
function Conductor:JustMovedShadeSetTimer()
    self.lastShade = Shared.GetTime()
end
function Conductor:GetIsDriftMovementAllowed()
    return GetIsTimeUp(self.lastDrift, kManageDrifterInterval)
end
function Conductor:JustMovedDriftSetTimer()
    self.lastDrift = Shared.GetTime()
end
function Conductor:GetIsMacMovementAllowed()
    return GetIsTimeUp(self.lastMac, kManageMacInterval)
end
function Conductor:JustMovedMacSetTimer()
    self.lastMac = Shared.GetTime()
end
function Conductor:GetIsArcMovementAllowed()
    return GetIsTimeUp(self.lastArc, kManageArcInterval)
end
function Conductor:JustMovedArcSetTimer()
    self.lastArc = Shared.GetTime()
end
/*
function Conductor:SetMostRecentCyst(cystid)
    self.mostRecentCyst = cystid//Do I have to hook CystPreOnKill, call cond, get most recent cyst id.. if match then set back to invalid? Hm. Not Sure. Ah.
end
*/    
function Conductor:SetMostRecentCystOrigin(vector)
    self.mostRecentCystOrig = vector//So I don't have to worry about entity id with cyst and all that hehe
end
   function Conductor:GetMostRecentCystOrigin()
    return self.mostRecentCystOrig
end 
function Conductor:GetArcSpotForSiege()
local inradius = GetIsPointWithinHiveRadius(self.arcSiegeOrig)//#GetEntitiesWithinRange("Hive", self.arcSiegeOrig, ARC.kFireRange - 3) >= 1
    if not inradius then
        //Print("Conductor arc spot to place not in hive radius")
        local siegelocation = GetASiegeLocation()
        local siegepower = GetPowerPointForLocation(siegelocation.name)
        local hiveclosest = GetNearest(siegepower:GetOrigin(), "Hive", 2)
        if hiveclosest then
            //Print("Found hiveclosest")
            local origin  = FindArcHiveSpawn(self.arcSiegeOrig)//Adding for 0 incase old spot is saved, find new one near old spot.
            if origin == nil then
                print("[0]ERROR! AH! Unable to find Arc placement near siege.")
                origin  = FindArcHiveSpawn(siegepower:GetOrigin())
            end
            if origin == nil then
                print("[1]ERROR! AH! Unable to find Arc placement near siege.")
                origin  = FindArcHiveSpawn(hiveclosest:GetOrigin())
            end
            if origin == nil then
                print("[2]ERROR! AH! Unable to find Arc placement near siege.")
                local avg = siegepower:GetOrigin().x + hiveclosest:GetOrigin().x
                avg = avg / 2
                local toLook = siegepower:GetOrigin()
                      toLook.x = avg
                origin  = FindArcHiveSpawn(toLook)
            end
            if origin == nil then
                print("[3]ERROR! AH! Unable to find Arc placement near siege.")
                return
            end

            if origin ~= nil then
                local inRangeofOrigin = GetIsPointWithinHiveRadius(origin) //#GetEntitiesWithinRange("Hive", origin, ARC.kFireRange) >= 1
                if inRangeofOrigin then
                self.arcSiegeOrig = origin
                Print("Found arc spot within hive radius")
                end
            end
            if origin == nil then
                print("[4]ERROR! AH! Unable to find Arc placement for Siege!")
                return
            end
        end
    end
end

if Server then
    function Conductor:OnUpdate(deltatime)
    
        if not GetGameStarted() then return end
        
        /*
        if self.lastDirection + math.random(4,8) <= Shared.GetTime() then//and self.arcSiegeOrig == self:GetOrigin() then
                if GetSetupConcluded() then
                        self:DirectSpectators()
                end   
                        self.lastDirection = Shared.GetTime()     
        end
        */
        
        if not self.timeLastResourceTower or self.timeLastResourceTower + kResTowerInterval <= Shared.GetTime() then//and self.arcSiegeOrig == self:GetOrigin() then
            if GetIsImaginatorMarineEnabled() or GetIsImaginatorAlienEnabled() then 
                self:ResourceTowers()
            //So if 2 hives are dead and 1 is remaining then find new spot. If possible. Though 2 more will likely drop in the meantime haha.
            end
                        self.timeLastResourceTower = Shared.GetTime()
        end
        
        if not self.timeLastArcSiege or self.timeLastArcSiege + kIntervalForArcsDuringSiege <= Shared.GetTime() then//and self.arcSiegeOrig == self:GetOrigin() then
            if GetIsImaginatorMarineEnabled() then
                if self.arcSiegeOrig == self:GetOrigin() then 
                self:GetArcSpotForSiege()
                //So if 2 hives are dead and 1 is remaining then find new spot. If possible. Though 2 more will likely drop in the meantime haha.
                end
            end
            self.timeLastArcSiege = Shared.GetTime()
        end
            
        if not self.timeLastMarineBuffs or self.timeLastMarineBuffs + kMarineBuffInterval <= Shared.GetTime() then
            if GetIsImaginatorMarineEnabled() then 
                self:MarineBuffsDelay()
            end
            self.timeLastMarineBuffs = Shared.GetTime()
        end

        if not self.phaseCannonTime or self.phaseCannonTime + math.random(27,90) <= Shared.GetTime() then
            if GetIsImaginatorAlienEnabled() then
                self:ContaminationSpawnTimer()
            end
            self.phaseCannonTime = Shared.GetTime()
        end
        
        if not self.manageScanTime or self.manageScanTime + kManageScanInterval <= Shared.GetTime() then
            if GetIsImaginatorMarineEnabled() then
                self:ManageScans()
            end
            self.manageScanTime = Shared.GetTime()
        end
        
        if not self.manageDriferTime or self.manageDriferTime + kManageDrifterInterval <= Shared.GetTime() then
            if GetIsImaginatorAlienEnabled() then
                self:ManageDrifters()
            end
            self.manageDriferTime = Shared.GetTime()
        end

        if not self.manageWhipsTime or self.manageWhipsTime + kManageWhipsInterval <= Shared.GetTime() then
            if GetIsImaginatorAlienEnabled() then
                self:ManageWhips()
            end
            self.manageWhipsTime = Shared.GetTime()
        end
        
        if not self.manageCystsTime or self.manageCystsTime + kManageCystsInterval <= Shared.GetTime() then
            if GetIsImaginatorAlienEnabled() then
                self:ManageCysts()
            end
            self.manageCystsTime = Shared.GetTime()
        end
  
    end
    
end//Server


local function ChanceContaminationSpawn(self)
//Probably a more fair version of this rather than DDOS? LOL
    local onechance = math.random(1,2)

    if onechance == 1 then
        local chance = math.random(1,100)
        if chance >= 70 then
            local power = GetRandomActivePower()
            if power then  self:SpawnContamination(power)
                return
            end --if not power then
            else
                local cc = GetRandomCC()
                if cc then  self:SpawnContamination(cc)
                    return
                 end
        end
    else

        local power = GetRandomActivePower()
        if power then
          self:SpawnContamination(power)
           return
         end
    end

    local built = {}
    for index, powerpoint in ientitylist(Shared.GetEntitiesWithClassname("PowerPoint")) do
        if not GetIsPointInMarineBase(powerpoint:GetOrigin()) and powerpoint:GetIsBuilt() and not powerpoint:GetIsDisabled() then
            table.insert(built, powerpoint)
        end
    end
    
    if #built == 0 then return end
    local random = table.random(built)
    self:SpawnContamination(random)
end


function Conductor:ContaminationSpawnTimer()
         ChanceContaminationSpawn(self)
end

function Conductor:MarineBuffsDelay()
             
            if GetIsImaginatorMarineEnabled() then
              self:HandoutMarineBuffs()
            end

             return true
end
function Conductor:DirectSpectators()

        for _, director in ientitylist(Shared.GetEntitiesWithClassname("AvocaSpectator")) do
            if director:CanChange() then // well this is messy haha , why not have an active table? although would be constantly transition invalid and valid
               local interestingPlayer = GetNearestMixin(director:GetOrigin(), "Combat", nil, function(ent) return ent:isa("Player") and ent:GetIsInCombat() end)
                if interestingPlayer then
                    local viporigin = interestingPlayer:GetOrigin()
                     director:SetOrigin(viporigin)
                     director:SetLockOnTarget(interestingPlayer:GetId())
               end
            end
        end
end
function Conductor:ResourceTowers()

             if GetIsImaginatorMarineEnabled() or GetIsImaginatorAlienEnabled() then
               self:AutoBuildResTowers()
             end
end
local function PowerPointStuff(who, self)
    local location = GetLocationForPoint(who:GetOrigin())
    local powerpoint =  location and GetPowerPointForLocation(location.name)
    local imaginator = GetImaginator()
    if powerpoint ~= nil then
        if imaginator:GetIsMarineEnabled() and ( powerpoint:GetIsBuilt() and not powerpoint:GetIsDisabled() ) then
            return 1
        elseif imaginator:GetIsAlienEnabled() and ( powerpoint:GetIsDisabled() )  then
            return 2
        end
    end
end


local function WhoIsQualified(who, self)
   return PowerPointStuff(who, self)
end


local function Touch(who, where, what, number)
 local tower = CreateEntityForTeam(what, where, number, nil)
   if not GetSetupConcluded() then tower:SetConstructionComplete() end
         if tower then
            local cost = kExtractorCost
            who:SetAttached(tower)
            if number == 2 then
               cost = kHarvesterCost
             --doChain(tower)
                local notNearCyst = #GetEntitiesWithinRange("LoneCyst",who:GetOrigin(), kCystRedeployRange) == 0
                 if notNearCyst then
                  local cyst = CreateEntity(LoneCyst.kMapName, FindFreeSpace(tower:GetOrigin(), 1, kCystRedeployRange),2)
                              if not GetSetupConcluded() then
                                   cyst:SetConstructionComplete()
                               end
               end
            end
           -- tower:GetTeam():SetTeamResources(tower:GetTeam():GetTeamResources() - cost)
            return tower
         end
end


local function Envision(self,who, which)
    local imaginator = GetImaginator()
   if which == 1 and imaginator:GetIsMarineEnabled() then --and TresCheck(1, kExtractorCost) then if we have extractor being prioritized to be build yes, but now its spread and not written this way
     Touch(who, who:GetOrigin(), kTechId.Extractor, 1)
   elseif which == 2 and imaginator:GetIsAlienEnabled() then --and TresCheck(1, kHarvesterCost)  then
    Touch(who, who:GetOrigin(), kTechId.Harvester, 2)
    end
end

local function AutoDrop(self,who)
  local which = WhoIsQualified(who, self)
  if which ~= 0 then Envision(self,who, which) end
end

function Conductor:AutoBuildResTowers()
  for _, respoint in ientitylist(Shared.GetEntitiesWithClassname("ResourcePoint")) do
        if not respoint:GetAttached() then
            AutoDrop(self, respoint)
            if GetSetupConcluded() then
                break//One at a time? lol meh probably not. Huge delay? We'll see. Heh.
            end
        end
    end
end

local function BuildAllNodes(self)

          for _, powerpoint in ientitylist(Shared.GetEntitiesWithClassname("PowerPoint")) do
             powerpoint:SetConstructionComplete()
             local where = powerpoint:GetOrigin()
             if not GetIsPointInMarineBase(where) and math.random(1,2) == 1  then
                powerpoint:Kill()
             end
          end

end

local function BuildAllNodes(self)


end//Kyle Abent :P
local function KillAlienResRoomPower(self)
    //Room power of location with the most resource nodes which is the closest location to the hive room.
    local hivepower = GetHiveRoomPower(self:GetOrigin())
    local roomswithresnodes = GetPossibleAlienResRoomNode()
    local closestDistance = 999
    local closestIndex = -1
    print("KillAlienResRoomPower")
    if hivepower then
        print("HivePower")
        if roomswithresnodes then
            print("roomswithresnodes")
            for i = 1, #roomswithresnodes do
                print("for roomswithresnodes")
                local node = roomswithresnodes[i]
                local dist = GetRange(hivepower, node:GetOrigin()) 
                if dist < closestDistance then
                    print("dist < closestDistance")
                    closestDistance = dist
                    closestIndex = i
                end
            end
            if closestIndex ~= -1 then
                 print("closestIndex ~= -1")
                 local whichNode = roomswithresnodes[closestIndex]
                 whichNode:SetConstructionComplete()
                 whichNode.hasBeenToggledDuringSetup = true
                 whichNode:SetInternalPowerState(PowerPoint.kPowerState.socketed)
                 whichNode:SetConstructionComplete()
                 whichNode:Kill()
             end
        end
    end
    

end
function Conductor:OnRoundStart()
           if Server then
            --  BuildAllNodes(self)
            --  KillAlienResRoomPower(self)
            end
            
            //self.alienresroom = .... 
            //if alien res room under attack , consider not dropping other structures until prioritizing harvester rebuild. ???
end

/*
Alternative to spawning eggs, move em... by front/whatever
function Conductor:ManageEggsSetup()
   local isSetup = not GetFrontDoorOpen()
   if not isSetup then
    return
   end
   
   //Yeah.. For loop! .. but its ok.. its ... setup... 5-15 iterations. /shrug
   
   for index, egg in ipairs(GetEntitiesForTeam("Egg", 2)) do
        if not GetIsInFrontDoorRoom(egg) and shade:GetCanTeleport() then //shade lol
        
        end
    end
   
   
end
*/

function Conductor:ManageScans()
    if not GetSiegeDoorOpen() then
     return // Scan the avg origin of arc or something meh
    end
    local hive = GetRandomHive()
    if hive then
    CreateEntity(Scan.kMapName, hive:GetOrigin(), 1)
    end
end


local function ResearchMacIfPossible(who, where)
    local robo = FindNonBusyRoboticsFactory()
    if robo then
        //SetDirectorLockedOnEntity(who)
        local tree = GetTechTree(1)
        local techNode = tree:GetTechNode(kTechId.MAC)
        assert(techNode ~= nil)
        robo:SetResearching(techNode, robo)
    end
end




local function findFrontDestination(self,who)
                    local door = GetNearest(who:GetOrigin(), "FrontDoor", nil,  function(ent) return ent:isa("FrontDoor") and GetLocationForPoint(who:GetOrigin()) ~= GetLocationForPoint(ent:GetOrigin()) end ) 
                    if door then
                        return door
                    end
                    return false
end


function Conductor:ManageCysts()
    --print("ManageCysts")
    local cystsMax = 0
    doMax = 4
    --local doMax = math.random(1,4)
     local noncysted = {}
     for _, infestable in ipairs(GetEntitiesWithMixinForTeam("InfestationTracker", 2)) do
        --print("found something to check for infestation")
       -- if cystsMax < doMax and not infestable:GetGameEffectMask(kGameEffect.OnInfestation) then
       /*
       if not infestable:GetGameEffectMask(kGameEffect.OnInfestation) then
            --print("Found something not on infestation")
            table.insert(noncysted, infestable)
            cystsMax = cystsMax + 1
            --if cystsMax == doMax then
                 break 
           -- end
        end
       */
        local notNearCyst = #GetEntitiesWithinRange("LoneCyst",infestable:GetOrigin(), kCystRedeployRange) == 0
        if notNearCyst then
            table.insert(noncysted, infestable)
             cystsMax = cystsMax + 1
           -- if cystsMax == doMax then
           --      break 
           -- end
        end

     end
    
    --print("Number of non infested is %s", ToString(cystsMax))
   -- print("Number of non noncysted is %s", ToString(#noncysted))
     if cystsMax == 0 then return end
  
     for _, spawnEnt in ipairs(noncysted) do
        --print("Spawned cyst on %s", ToString(spawnEnt))
            local cyst = CreateEntity(LoneCyst.kMapName, FindFreeSpace(spawnEnt:GetOrigin(), 1, kCystRedeployRange),2)
       // local cyst = CreateEntity(Cyst.kMapName, FindFreeSpace(spawnEnt:GetOrigin(), 1, kCystRedeployRange),2)
            if not GetSetupConcluded() then
                cyst:SetConstructionComplete()
             end
      end

end


function Conductor:ManageWhips()
       
       //Make them all attack one?
       
       //local random = math.random(1,4)
       local isSetup = not GetFrontDoorOpen() 
       --leave min around hive not all leave. hm.
       local focusTarget = GetWhipFocusTarget()--GetRandomActivePower()
       local frontdoor = nil
       if isSetup then
            frontdoor = GetNearest(self:GetOrigin(), "FrontDoor") //self origin lol well ok it works
            if frontdoor then  
               focusTarget = GetRoomPowerTryEnsureSetupAlienOwned(frontdoor)//here is where it can mess up and get the marine occupied room.
           end
       end
       
       if focusTarget then
            local origin = FindFreeSpace(focusTarget:GetOrigin(), 4) //dont loop this calculation
            for index, whip in ientitylist(Shared.GetEntitiesWithClassname("Whip")) do
              if not whip:GetIsInCombat() and not whip.moving  then
                     if focusTarget:isa("Contamination") and whip:GetCanTeleport() then
                        whip:TriggerTeleport(5, whip:GetId(), FindFreeSpace(focusTarget:GetOrigin(), 4), 0)
                     else    //Well this will move it to the contamination. May not be ideal. Lets try.
                        whip:GiveOrder(kTechId.Move, focusTarget:GetId(), origin, nil, false, false)
                     end
                     --SetDirectorLockedOnEntity(whip)
                     -- CreatePheromone(kTechId.ThreatMarker,power:GetOrigin(), 2)  if get is time up then
               end 
           end
       end   

end
function Conductor:ManageDrifters()

    local hive = GetRandomHive() 
    local Drifters = GetEntitiesForTeamWithinRange("Drifter", 2, self:GetOrigin(), 9999)
    if hive and not #Drifters or #Drifters <=3  and TresCheck(2, kDrifterCost) then
        local where = hive:GetOrigin()
         local drifter = CreateEntity(Drifter.kMapName, FindFreeSpace(where), 2)
         drifter:GetTeam():SetTeamResources(drifter:GetTeam():GetTeamResources() - kDrifterCost)
    end

end

function Conductor:GetIsMapEntity()
return true
end

Shared.LinkClassToMap("Conductor", Conductor.kMapName, networkVars)
