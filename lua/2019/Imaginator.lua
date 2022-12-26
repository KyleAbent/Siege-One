-- Kyle 'Avoca' Abent
--http://twitch.tv/kyleabent
--https://github.com/KyleAbent/
class 'Imaginator' (Entity)
Imaginator.kMapName = "imaginator"

local networkVars =

{
  alienenabled = "private boolean",
  marineenabled = "private boolean",
  lastMarineBeacon =  "private time",
  lasthealwave = "private time",
  activeArms = "integer",
  activeWhips = "integer",
  activeCrags = "integer",
  activeShades = "integer",
  activeShifts = "integer",
  --activeTunnels = "integer",
}

function Imaginator:OnCreate()
   self.alienenabled = false
   self.marineenabled = false
   self.activeArms = 0
   self.activeWhips = 0
   self.activeCrags = 0
   self.activeShades = 0
   self.activeShifts = 0
   --self.activeTunnels = 0
   for i = 1, 8 do
     Print("Imaginator created")
   end
   self.lasthealwave = 0
   self:SetUpdates(true)
end

local function GetDelay()
  if not GetSetupConcluded() then 
      return 8
   end
  //if not GetSiegeDoorOpen() then 
      return 16
  //end
    //return 24
end

function Imaginator:GuideLostBots()
    //Marines
    local door = GetFrontDoor()
    if not door then return end
                       for _, marine in ientitylist(Shared.GetEntitiesWithClassname("Marine")) do
                        //if not in front room and if client is virtual
                        marine:GiveOrder(kTechId.Move, nil, door:GetOrigin(), nil, false, false) 
                    end
    
    
    //Aliens
        CreatePheromone(kTechId.ThreatMarker,door:GetOrigin(), 2)
end

if Server then
    function Imaginator:OnUpdate(deltatime)

        
        if self.marineenabled and (not  self.timeLastGuideLostBots or self.timeLastGuideLostBots + 30 <= Shared.GetTime() ) then
            if not GetSetupConcluded() then
                self:GuideLostBots()
            end
            self.timeLastGuideLostBots = Shared.GetTime()
        end
        
        if not  self.timeLastImaginations or self.timeLastImaginations + GetDelay() <= Shared.GetTime() then
            self.timeLastImaginations = Shared.GetTime()
            self:Imaginations()
        end

    end

end //Server

local function OrganizedEntranceCheck(who,self)


    if not who:GetIsBuilt() then
        return
    end
    
    //in room or in radius?
    

       -- local hive = GetRandomHive()
       -- if hive then
       --     if not GetHasFourTunnelInHiveRoom() then
       --         local tunnel = CreateEntity(TunnelEntrance.kMapName, FindFreeSpace(hive:GetOrigin(), 4, 20),  2)
       --     end
      --  end
    
end

local function DropWeaponsJetpacksExos(who, self)



        //This is bad not to have a cap for spawning haha. Gotta add a limit somewhere. By count in global map as well.ActualAlienFormula
        
    if not who:GetIsBuilt() or not who:GetIsPowered() then
        return
    end
    
    //if has adv armory, if has jp, if has exo.
    local randomize = {}
    
    local exosInRange = GetEntitiesForTeamWithinRange("Exosuit", 1, who:GetOrigin(), 99999999)
    if #exosInRange < 6 then --and TresCheck(1, 40) then
        table.insert(randomize, kTechId.DropExosuit)
    end
    
    /*
    local SGSInRange = GetEntitiesForTeamWithinRange("Shotgun", 1, who:GetOrigin(), 99999999)
    
    if #SGSInRange < 6 then
        table.insert(randomize, kTechId.Shotgun)
    end
    local hmgsInRange = GetEntitiesForTeamWithinRange("HeavyMachineGun", 1, who:GetOrigin(), 99999999)
    if #hmgsInRange < 6 then
        table.insert(randomize, kTechId.HeavyMachineGun)
    end
    local JPSInRange = GetEntitiesForTeamWithinRange("Jetpack", 1, who:GetOrigin(), 99999999)
    if #JPSInRange < 6 then
        table.insert(randomize, kTechId.Jetpack)
    end
    local GLSInRange = GetEntitiesForTeamWithinRange("GrenadeLauncher", 1, who:GetOrigin(), 99999999)
    if #GLSInRange < 6 then
        table.insert(randomize, kTechId.GrenadeLauncher)
    end

    local flsInRange = GetEntitiesForTeamWithinRange("Flamethrower", 1, who:GetOrigin(), 99999999)
    if #exosInRange < 6  then
        table.insert(randomize, kTechId.Flamethrower)
    end
    */
    
    

    if #randomize == 0 then return end
    
    local entry = table.random(randomize)
    
    entity = CreateEntityForTeam(entry, FindFreeSpace(who:GetOrigin(),4, kInfantryPortalAttachRange), 1)
    
    --entity:GetTeam():SetTeamResources(entity:GetTeam():GetTeamResources() - 40) //right now just the dropexo which is 40 tres -.-
    
     
end

local function OrganizedIPCheck(who, self) //spacecow:CC SPawned on top, IPS spawned below/not found/outside of Y Radius! HAH. Lame.
    if not who:GetIsBuilt() then
        return
    end

    local count = 0
    //local findFree = FindFreeSpace(who:GetOrigin(), 1, kInfantryPortalAttachRange)
    local ipsInRange = GetEntitiesForTeamWithinRange("InfantryPortal", 1, who:GetOrigin(), kInfantryPortalAttachRange)//Search Y Radius? lol
    //and activeIPS <= numofChairs*3/4
    if #ipsInRange >= math.random(3,4) then//self.activeIPS >= 8 then //do a check for within range so that each base has its own
     return
    end

    --for i = 1, math.abs( 2 - count ) do --one at a time
    //local cost = 20
    if TresCheck(1, kInfantryPortalCost) then
        local where = who:GetOrigin()
        local origin = FindFreeSpace(where, 4, kInfantryPortalAttachRange)
            if origin ~= where then
            local ip = CreateEntity(InfantryPortal.kMapName, origin,  1)
            --SetDirectorLockedOnEntity(ip)
                if not GetSetupConcluded() then 
                     ip:SetConstructionComplete()
                     ip:GetTeam():SetTeamResources(ip:GetTeam():GetTeamResources() - kInfantryPortalCost)
                end
            end
    end
    
    //May have to re-introduce armslab here if it doesn't spawn fast enough after round start lol
    //Unless the work around to that is the MarineInitialBaseSpawn creating an ArmsLab...
    
      //Bad for if aliens take it down then they get no reward of unpowered marines
      //unless marines dont build it lol
      if self.activeArms <= 1 and TresCheck(1, kArmsLabCost) then
        local where = who:GetOrigin()
        local origin = FindFreeSpace(where, 4, kInfantryPortalAttachRange)
        local arms = CreateEntity(ArmsLab.kMapName, origin,  1)
        --SetDirectorLockedOnEntity(arms)
        arms:GetTeam():SetTeamResources(arms:GetTeam():GetTeamResources() - kArmsLabCost)
          if not GetSetupConcluded() then
            arms:SetConstructionComplete()
          end
       arms:TriggerResearches()
      end

end

local function OrganizedSentryCheck(who, self)
       if not who or not who:GetIsBuilt() then
        return
    end

    local count = 0
    //local findFree = FindFreeSpace(who:GetOrigin(), 1, 7)//range of battery??
    local sentrysInRange = GetEntitiesForTeamWithinRange("Sentry", 1, who:GetOrigin(), 4)//range of battery??

    if #sentrysInRange >= 4 or GetCheckSentryLimit(nil, origin, nil, nil) then//self.activeIPS >= 8 then //do a check for within range so that each base has its own
     return
    end
    

    --for i = 1, math.abs( 2 - count ) do --one at a time
    //local cost = 20
    if TresCheck(1, kSentryCost) then
        local where = who:GetOrigin()
        local origin = FindFreeSpace(where, 1, 4)//range of battery??
            if origin ~= where then
            local sentry = CreateEntity(Sentry.kMapName, origin, 1)
            --SetDirectorLockedOnEntity(sentry)
                if not GetSetupConcluded() then sentry:SetConstructionComplete() end
                    sentry:GetTeam():SetTeamResources(sentry:GetTeam():GetTeamResources() - kSentryCost)
                //end
            end

    end

end

local function HaveBatteriesCheckSentrys(self)
    local SentryBatterys = GetEntitiesForTeam( "SentryBattery", 1 )
    if not SentryBatterys then
     return
    end
    OrganizedSentryCheck(table.random(SentryBatterys), self)
end

local function HaveHivesCheckEntrances(self)
    local Hives = GetEntitiesForTeam( "Hive", 2 )
    if not Hives then
     return
    end
    OrganizedEntranceCheck(table.random(Hives), self)
end


local function HaveCCsCheckIps(self)
    local CommandStations = GetEntitiesForTeam( "CommandStation", 1 )
    if #CommandStations == 0 then
     return
    end
    OrganizedIPCheck(table.random(CommandStations), self)
    local Protos = GetEntitiesForTeam( "PrototypeLab", 1 )
    if #Protos == 0 then
     return
    end
    DropWeaponsJetpacksExos(table.random(Protos), self) // Tune this
end

function Imaginator:ManageMarineBeacons() // Get all Macs, make each mac weld CC?
    local chair = nil

    for _, entity in ientitylist(Shared.GetEntitiesWithClassname("CommandStation")) do
        if entity:GetIsBuilt() and entity:GetHealthScalar() <= 0.3 then
            chair = entity
            break
        end
    end

    if not chair then
        return
    end

    local obs = GetNearest(chair:GetOrigin(), "Observatory", 1,  function(ent) return GetLocationForPoint(ent:GetOrigin()) == GetLocationForPoint(chair:GetOrigin()) and ent:GetIsBuilt() and ent:GetIsPowered()  end )

    if obs then
        obs:TriggerDistressBeacon()
        self.lastMarineBeacon = Shared.GetTime()
    end

end

local function ManageRoboticFactories() //If bad perf can be modified to do one robo a time rather than all heh. Or other ways rather than for looping every. lol.
    local ARCRobo = {} --ugh
    local  macs = GetEntitiesForTeam( "MAC", 1 )
    local isSiege = GetSiegeDoorOpen()

    for index, robo in ipairs(GetEntitiesForTeam("RoboticsFactory", 1)) do
        if robo:GetIsBuilt() and not robo.open and not robo:GetIsResearching() and robo:GetIsPowered() then
            //Prioritize Macs if not siege room open
            if not isSiege and not #macs or #macs <6 and TresCheck(1, kMACCost)  then // Make this cost tres?
                 robo:OverrideCreateManufactureEntity(kTechId.MAC)
                 robo:GetTeam():SetTeamResources(robo:GetTeam():GetTeamResources() - kMACCost)
                //Well the way this is written, if two robos calculate this at once. at 5 macs. <6 .Then both create macs at same time. 7 macs.
                //This can be moved down below with arc spawn.
            else
                if  robo:GetTechId() ~= kTechId.ARCRoboticsFactory then
                    local techid = kTechId.UpgradeRoboticsFactory
                    local techNode = robo:GetTeam():GetTechTree():GetTechNode( techid )
                    robo:SetResearching(techNode, robo)
                end

                if robo:GetTechId() == kTechId.ARCRoboticsFactory then
                    table.insert(ARCRobo, robo)
                end --ugh
           end
         end
    end

    --if ( not GetHasThreeChairs() and not GetFrontDoorOpen() ) then return end

    if table.count(ARCRobo) == 0 then
        return
    end

    ARCRobo = table.random(ARCRobo)

    local ArcCount = #GetEntitiesForTeam( "ARC", 1 )

    if ArcCount < 9 and TresCheck(1, kARCCost) then
        ARCRobo:GetTeam():SetTeamResources(ARCRobo:GetTeam():GetTeamResources() - kARCCost)
        ARCRobo:OverrideCreateManufactureEntity(kTechId.ARC)
    end

end

local function GetMarineSpawnList(self)
    local tospawn = {}
    local canafford = {}
    local gamestarted = false

    local  CCs = 0
        for index, cc in ipairs(GetEntitiesForTeam("CommandStation", 1)) do
            CCs = CCs + 1
        end

    if CCs < 3  and CCs >= 1 and GetSetupConcluded() and TresCheck(1, kCommandStationCost) then
        return kTechId.CommandStation
    end

    local  CommandStation = #GetEntitiesForTeam( "CommandStation", 1 )
    if CommandStation < 3 and TresCheck(1, kCommandStationCost) then
        table.insert(tospawn, kTechId.CommandStation)
    end
    ----------------------------------------------------------------------------------------------------

    if #tospawn == 0 then
        return nil
    end
    local finalchoice  = table.random(tospawn)

    ---------------------------------------------------------------------------------------------------------
    return finalchoice
    ----------------------------------------------------------------------------------------------------------
end

function Imaginator:ActualFormulaMarine()


    if  GetIsTimeUp(self.lastMarineBeacon, 30) then
        self:ManageMarineBeacons()
    end

    if GetGamerules():GetGameState() == kGameState.Started then
        gamestarted = true
        HaveCCsCheckIps(self)
        HaveBatteriesCheckSentrys(self)
        ManageRoboticFactories()
    end


    local randomspawn = nil
    local tospawn = GetMarineSpawnList(self) --cost, blah.
    local powerpoint = GetRandomActivePower()
    local success = false
    local entity = nil

    if powerpoint then
        if tospawn == nil then
            tospawn = powerpoint:GetRandomSpawnEntity()
        end
    end
    
    if tospawn and powerpoint then
        local potential = powerpoint:GetRandomSpawnPoint() 
            if potential == nil then 
                return
            end
        randomspawn = FindFreeSpace(potential, 4)
        if randomspawn then 
            if ( tospawn == kTechId.CommandStation and not GetSetupConcluded() and GetHasChairInRoom(randomspawn) ) then 
                return
            end
            //Trescheck was done in pre-qual but it could probably requrie another check as if 
            //implementing res spending in multiple areas may have a lot happen between then and now. 
            // I'm not sure yet. Haha. Tres spendature sounds scary for AutoComm, no? 
            //Then again perhaps proper delay to combat lag. Maybe 999 max? Lets see. lol. 
             
            entity = CreateEntityForTeam(tospawn, randomspawn, 1)
            entity:GetTeam():SetTeamResources( entity:GetTeam():GetTeamResources() - GetCachedTechData(tospawn, kTechDataCostKey) )
            //if entity:isa("RoboticsFactory") then
             //   local randomAngle = Randomizer() * math.pi * 2
            //    entity:SetAngles(randomAngle)
           // end
            //SetDirectorLockedOnEntity(entity)
            if not GetSetupConcluded() then 
                entity:SetConstructionComplete() 
            end
            if HasMixin(entity, "Research") then
                entity:TriggerResearches()
            end
            success = true
          end
      end
    return success
end

function Imaginator:MarineConstructs()
       for i = 1, 8 do
         local success = self:ActualFormulaMarine()
         if success == true then break end
       end

return
end
function Imaginator:ShowWarningForToggleMarinesOff()

end
function Imaginator:ShowWarningForToggleAliensOff()

end
function Imaginator:ShowWarningForToggleMarinesOn()

end
function Imaginator:ShowWarningForToggleAliensOn()

end
function Imaginator:Imaginations() 
    if not GetGameStarted() then return end
    local Gamerules = GetGamerules()
    local team1Commander = Gamerules.team1:GetCommander()
    local team2Commander = Gamerules.team2:GetCommander()
    
    if team1Commander then
        local doDisplay = not self.marineenabled
        self.marineenabled = team1Commander:GetIsVirtual()
        doDisplay = doDisplay and self.marineenabled
        if doDisplay then
            self:ShowWarningForToggleMarinesOn()
        end
     else
        if self.marineenabled then
            self:ShowWarningForToggleMarinesOff()
            self.marineenabled = false
        end
    end
    
    if team2Commander then
        local doDisplay = not self.alienenabled
        self.alienenabled = team2Commander:GetIsVirtual()
        doDisplay = doDisplay and self.alienenabled
        if doDisplay then
            self:ShowWarningForToggleAliensOn()
        end
    else
        if self.alienenabled then
            self:ShowWarningForToggleAliensOff()
            self.alienenabled = false
            TurnLoneCystsIntoRegular()
        end
    end
    
    if self.marineenabled then
            self:MarineConstructs()
    end
    
    if self.alienenabled then
            self:AlienConstructs()
    end

    return true

end

local function GetAlienSpawnList(self)

    local tospawn = {}
    
    if GetSiegeDoorOpen() then
        if self.activeCrags < 13 or self.activeShades < 12 then
            if  self.activeCrags < 13 then
                table.insert(tospawn, kTechId.Crag)
            end
            if  self.activeShades < 12 then
                table.insert(tospawn, kTechId.Shade)
            end
            local finalchoice = table.random(tospawn)
            return finalchoice
        end
    end

    if self.activeShifts < 14 and TresCheck(2,kShiftCost) then
        table.insert(tospawn, kTechId.Shift)
    end

    if self.activeWhips < kAutoCommMaxWhips and TresCheck(2,kWhipCost)  then
        table.insert(tospawn, kTechId.Whip)
    end

    if  self.activeCrags < 13 and TresCheck(2,kCragCost) then
        table.insert(tospawn, kTechId.Crag)
    end

    if  self.activeShades < 12 and TresCheck(2,kShadeCost) then
        table.insert(tospawn, kTechId.Shade)
    end

    --HaveHivesCheckEntrances(self)
   -- if self.activeTunnels < 4 then //this is only counting ones outside of hive room.
   --     table.insert(tospawn, kTechId.Tunnel)
   -- end

    local finalchoice = table.random(tospawn)
    return finalchoice

    --return table.random(tospawn)
end

local function UpgChambers()
    local gamestarted = not GetGameInfoEntity():GetWarmUpActive()

    if not gamestarted then
     return true
    end

    local tospawn = {}
    local canafford = {}


    if GetHasShiftHive() then
          local Spur = #GetEntitiesForTeam( "Spur", 2 )
          if Spur < 3  and TresCheck(2, kSpurCost)  then
           table.insert(tospawn, kTechId.Spur)
          end
     else
        ResearchShiftHive()
       end

    if GetHasCragHive()  then
        local  Shell = #GetEntitiesForTeam( "Shell", 2 )
        if Shell < 3 and TresCheck(2, kShellCost) then
         table.insert(tospawn, kTechId.Shell) end
     else
         ResearchCragHive()
        end

    if GetHasShadeHive()  then
        local  Veil = #GetEntitiesForTeam( "Veil", 2 )
        if Veil < 3 and TresCheck(2, kVeilCost) then
         table.insert(tospawn, kTechId.Veil)
        end
     else
        ResearchShadeHive()
    end

    for _, techid in pairs(tospawn) do
        local cost = 0 //LookupTechData(techid, kTechDataCostKey)
        if not gamestarted or TresCheck(2,cost) then
            table.insert(canafford, techid)
        end
    end

    local finalchoice = table.random(canafford)
    local finalcost = LookupTechData(finalchoice, kTechDataCostKey)
    //finalcost = 0 //not gamestarted and 0 or finalcost
    --Print("GetAlienSpawnList() UpgChambers() return finalchoice %s, finalcost %s", finalchoice, finalcost)
    return finalchoice, finalcost, gamestarted

end


function Imaginator:DoBetterUpgs()

    if not gamestarted then
     return
    end

    local tospawn, cost, gamestarted = UpgChambers()
    local success = false
    local randomspawn = nil
    local hive = GetRandomHive()

     if hive and tospawn then

        randomspawn = FindFreeSpace( hive:GetOrigin(), 4, 24, true)

        if randomspawn then

            local entity = CreateEntityForTeam(tospawn, randomspawn, 2)
            
            --SetDirectorLockedOnEntity(entity)
            if not GetSetupConcluded() then
             entity:SetConstructionComplete()
            end

            
            if gamestarted then
             entity:GetTeam():SetTeamResources(entity:GetTeam():GetTeamResources() - cost)
            end
            

        end
  end

  return success
end


function Imaginator:AlienConstructs()
--Print("AlienConstructs")
       for i = 1, 8 do
         local success = self:ActualAlienFormula()
         if success == true then break end
       end
        --  if  GetHasShiftHive() then --messy
        --    HandleShiftCallReceive()
        --  end
       self:DoBetterUpgs()

return true

end

local function getAlienConsBuildOrig(techid)

    if GetSiegeDoorOpen() and techid == kTechId.Crag or techid == kTechId.Shade then//and GetRandomHive() ~= nil (if all hives are down? then game over duh)
        return GetRandomHive()
    else
         local random = math.random(1,3)
          --or active gorge tunnel  exit
          if random == 1 then
            return GetRandomDisabledPower()
          elseif random == 2 then 
            return GetRandomConnectedCyst()//Chance of erroring if entity dies ?
          elseif random == 3 then
            return GetRandomConstructEntityNearMostRecentPlacedCyst()//Chance of erroring if entity dies ?
          end
    end
 
end

function Imaginator:hiveSpawn()  
      //lets add a check here for a 4th tech point after front door is opened. 
      //or if tech chount count is 4 and aliens have 3 hives and the 4th tech is empty
      //it's possible marines moved away from tech point also..
       //if enabled, front door open, and has 3 hives?
       //if there's more than 4 tech point count (marine only have 1)
       //then prioritize the hives within range of eachother?
       //lesss priority on other? 
        //(Not really as that would require further withinrange requiresments
            //asserting other tech within range. I don't think this is necessary. 
            //MAybe later if I see it in game.
            //Reason I'm adding this is because of a round of ns2_hivesiege-4_2015b
                //having 4 tech points is actually a good mix. (For aliens)
      
      
      if self.alienenabled and GetGamerules():GetGameState() == kGameState.Started  then
            local hiveCap = 3
            local hivecount = #GetEntitiesForTeam( "Hive", 2 )
            if GetSetupConcluded() then
                local techCount = #GetEntitiesWithinRange("TechPoint", self:GetOrigin(), 9999999)
                local isMarineTechEmpty = true
                //Requires further logic. Do a for loop of all tech. Make sure tech point attached is not marines.
                
                for _, techpoint in ientitylist(Shared.GetEntitiesWithClassname("TechPoint")) do
                    if techpoint.occupiedTeam == 1 then
                        isMarineTechEmpty = false
                    end
                end
                                      //Any case where > 4 ?
                if techCount > 4 or ( techCount == 4 and isMarineTechEmpty and hivecount == hiveCap) then
                    hiveCap = 4//Hm, why limit to 4? 
                end
            if hivecount < hiveCap and hivecount >= 1 and TresCheck(2,40) then
                for _, techpoint in ientitylist(Shared.GetEntitiesWithClassname("TechPoint")) do
                    if techpoint:GetAttached() == nil then 
                        local hive =  techpoint:SpawnCommandStructure(2) 
                        if hive then hive:GetTeam():SetTeamResources(hive:GetTeam():GetTeamResources() - 40) //The only area which deducts tres, eh?
                            break
                        end
                    end
                end
        end
       end

 end
end

local function ActualAlienFormulaFailSafeOne() //recursion
        local power = GetRandomDisabledPower()
        if power == nil then //hm?
                return nil
        else
                return power
        end     
end
local function checkWhip(self,tospawn,randomspawn)
    //Lets emulate the alien comm "saving up" for a whip army on an interval chance or something lol.
    local chance = math.random(1,100)
    if chance <= 30 then //too high?
        for i = 1, kAutoCommMaxWhips - self.activeWhips do //clamp not necessary if we know our current is below limit haha
                                        //FindFreeSpace(randomspawn) ???
            if TresCheck(2, kWhipCost) then
                entity = CreateEntityForTeam(tospawn, randomspawn, 2) //MWHAHAHAHAHAHAH //boolean whipArmy == true , move all at once? LMAO //
                entity:GetTeam():SetTeamResources(entity:GetTeam():GetTeamResources() - kWhipCost)
            end
        end
        return true
    end
    return false
end
local function doSpawn(self,tospawn,randomspawn)
               -- if tospawn == kTechId.Tunnel and GetHasTunnelInRoom(randomspawn) then
              --      return
              --  end
                
                if tospawn == kTechId.Whip then
                    local shouldStop = checkWhip(self,tospawn,randomspawn)
                    if shouldStop then 
                        return
                    end
                end
                
                entity = CreateEntityForTeam(tospawn, randomspawn, 2) // FindFreeSpace?
                entity:GetTeam():SetTeamResources(entity:GetTeam():GetTeamResources() - GetCachedTechData(tospawn, kTechDataCostKey) )
                --SetDirectorLockedOnEntity(entity)
                if not GetSetupConcluded() then
                    entity:SetConstructionComplete() 
                end
                if HasMixin(entity, "Research") then
                    entity:TriggerResearches()
                end
                  local notNearCyst = #GetEntitiesWithinRange("LoneCyst",entity:GetOrigin(), kCystRedeployRange-1)  == 0
                 if notNearCyst then
                    local csyt = CreateEntity(LoneCyst.kMapName, FindFreeSpace(entity:GetOrigin(), 1, kCystRedeployRange),2)
                 end
end
function Imaginator:ActualAlienFormula()
    self:hiveSpawn()
    local randomspawn = nil
    local tospawn = GetAlienSpawnList(self) 
    local success = false
    local entity = nil

    if tospawn then  
    local power = ActualAlienFormulaFailSafeOne()
        if not power then
            return //recursion
         end
        //print("ActualAlienFormula randomspawn")
        randomspawn = power:GetRandomSpawnPoint()  //FindFreeSpace(potential, math.random(2.5, 4) , math.random(8, 16), not tospawn == kTechId.Cyst )
            if randomspawn then 
                doSpawn(self,tospawn,randomspawn)
            end
            success = true
    end
    -- if success and entity then self:AdditionalSpawns(entity) end
    return success
 end
  
  
function Imaginator:GetIsMapEntity()
    return true
end

function Imaginator:GetIsMarineEnabled()
    return self.marineenabled
end

function Imaginator:GetIsAlienEnabled()
    return self.alienenabled
end


Shared.LinkClassToMap("Imaginator", Imaginator.kMapName, networkVars)