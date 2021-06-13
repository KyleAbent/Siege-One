//local networkVars = { }
/*
local ogCreate = PowerPoint.OnCreate
 
function PowerPoint:OnCreate()
    ogCreate(self)
end
*/

local origInit = PowerPoint.OnInitialized
function PowerPoint:OnInitialized()
    origInit(self)
    if Server then 
        self.SpawnTableOne = {}
        self:GenerateTables()
        self.hasBeenToggledDuringSetup = false //OnReset???
        //Moving these from imaginator to be per room basis
        self.activeArmorys = 0
        self.activeRobos = 0
        self.activeBatteries = 0
        self.activeObs = 0
        self.activePGs = 0
        self.activeProtos = 0
    end
end

if Server then

    function PowerPoint:ToggleCountMapName(mapname, count)//although onpoweron may never register...?
        if not GetGameStarted() or not GetIsImaginatorMarineEnabled() then return end
        Print("ToggleCountMapName mapname %s, count %s", mapname, count)
        if string.find(mapname, "armor") then
            self.activeArmorys = self.activeArmorys + (count)
        elseif string.find(mapname, "observ") then
             self.activeObs = self.activeObs + (count)
        elseif string.find(mapname, "robo") then
             self.activeRobos = self.activeRobos + (count)
        elseif string.find(mapname, "batter") then
             self.activeBatteries = self.activeBatteries + (count)
        elseif string.find(mapname, "phase") then
             self.activePGs = self.activePGs + (count)
        elseif string.find(mapname, "prot") then
             self.activeProtos = self.activeProtos + (count)
        end
    end
    

    function PowerPoint:GenerateTables()
        local maxAttempts = 300 
        local maxSizePer = 75
        for i = 0, maxAttempts do 
               table.insert(self.SpawnTableOne, FindFreeSpace( self:GetOrigin() ,4,70) ) // The room could be big. is 20 large enough? then attempts/size may be toggled
               currentIndexLocation = nil//temp
           
            if #self.SpawnTableOne == maxSizePer then
                break
            end
            
        end 
    end

    function PowerPoint:GetRandomSpawnPoint()
            return table.random(self.SpawnTableOne)
    end
    
    function PowerPoint:GetHasBeenToggledDuringSetup()
        return self.hasBeenToggledDuringSetup
    end
    
    local origKill = PowerPoint.OnKill
     function PowerPoint:OnKill(attacker, doer, point, direction) //Initial hive 
        origKill(self, attacker, doer, point, direction)
        local gameinfo = GetGameInfoEntity()
        if gameinfo then
            gameinfo:DeductActivePower()
        end
        local isSetup = not GetSetupConcluded()
        if isSetup or GetIsOriginInHiveRoom(self:GetOrigin()) then 
            self.hasBeenToggledDuringSetup = true
        end
     end
     
    function GetPossibleAlienResRoomNode()
        //if one res point has about 4 others in close radius?
        local possible = {}
        local count = 5
      for _, respoint in ientitylist(Shared.GetEntitiesWithClassname("ResourcePoint")) do
                local resnodes = GetEntitiesWithinRange("ResourcePoint", respoint:GetOrigin(), 20) //try catch in the function calling
                for i = 1, #resnodes do 
                    local resnode = resnodes[i]
                    if GetLocationForPoint(resnode:GetOrigin()) == GetLocationForPoint(respoint:GetOrigin()) then
                        count = count + 1
                        if count >= 5 then
                            table.insert(possible, GetPowerPointForLocation( GetLocationForPoint( respoint:GetOrigin() ).name ) )
                            break
                        end
                    end
                end
      end
      
      return possible
      
    end

     function PowerPoint:SetPoweringState(state)
         if state == true then
         --Print("Powering true!")
                    local gameinfo = GetGameInfoEntity()
                    if gameinfo then
                        gameinfo:AddActivePower()
                    end
        end      
    end  
    
   local function GetMarineSpawnList(self) // Count should be based on size of location(s).
        local tospawn = {}
             -----------------------------------------------------------------------------------------------
        if self.activePGs < 1 and TresCheck(1, kPhaseGateCost) then
            table.insert(tospawn, kTechId.PhaseGate)
        end
        -------------------------------------------------------------------------------------------
        if self.activeArmorys < 4 and TresCheck(1, kArmoryCost) then 
            table.insert(tospawn, kTechId.Armory)
        end
        ---------------------------------------------------------------------------------------------
        if self.activeRobos < 1 and TresCheck(1, kRoboticsFactoryCost) then
            table.insert(tospawn, kTechId.RoboticsFactory)
        end
        ------------------------------------------------------------------------------------------------
        if self.activeObs < 3 and TresCheck(1, kPhaseGateCost) then
            table.insert(tospawn, kTechId.Observatory)
        end
        -----------------------------------------------------------------------------------------------
        if GetHasAdvancedArmory()  then
            if self.activeProtos < 2 and TresCheck(1, kPrototypeLabCost) then
                table.insert(tospawn, kTechId.PrototypeLab)
            end
        end
        -------------------------------------------------------------------------------------------------

        if self.activeBatteries < 1 and TresCheck(1, kSentryBatteryCost) then //or count of locations with built power up lol
          table.insert(tospawn, kTechId.SentryBattery)
        end
        ----------------------------------------------------------------------------------------------------
        return table.random(tospawn) //if empty..
    end 
    
    function PowerPoint:GetRandomSpawnEntity()
        /// self name has X number of X entity
        local location = GetLocationForPoint(self:GetOrigin())
        //Print("%s has %s Observatory", ToString(location.name),  ToString(self.activeObs))
        //Print("%s has %s Armory", ToString(location.name),  ToString(self.activeArmorys))
        //Print("%s has %s Robo", ToString(location.name),  ToString(self.activeRobos))
        //Print("%s has %s PG", ToString(location.name),  ToString(self.activePGs))
       // Print("%s has %s Proto", ToString(location.name),  ToString(self.activeProtos))
        //Print("%s has %s Battery", ToString(location.name),  ToString(self.activeBatteries))
        return GetMarineSpawnList(self)
    end
    
end
//Shared.LinkClassToMap("PowerPoint", PowerPoint.kMapName, networkVars)