--Kyle 'Avoca' Abent
local Shine = Shine
local Plugin = Plugin


Shine.Hook.SetupClassHook( "AvocaSpectator", "ChangeView", "OnChangeView", "PassivePost" )

Plugin.Version = "1.0"

function Plugin:Initialise()
self.Enabled = true
self:CreateCommands()
return true
end
function Plugin:NotifyGeneric( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Director]",  255, 0, 0, String, Format, ... )
end
function Plugin:NotifySand( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Director]",  255, 0, 0, String, Format, ... )
end
local function GetPregameView()
local choices = {}
 
              
                   for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
                  if player ~= self and not player:isa("Spectator")  and not player:isa("ReadyRoomPlayer")  and not player:isa("Commander") and player:GetIsOnGround() then table.insert(choices, player) break end
              end 
            
              local random = table.random(choices)
              return random
              

end
local function GetIsBusy(who)
  local order = who:GetCurrentOrder()
local busy = false
   if order then
   busy = true
   end
  -- if who:isa("MAC") then
 --  elseif who:isa("Drifter") then
   -- end
return busy
end
local function GetViewOne()


if not GetGamerules():GetGameStarted() then return GetPregameView() end

local choices = {}
--arc if moving or in siege
--contam
--commandstructure if in combat
--alive power node in combat
--egg or structure beacon
//local interesting = nil //GetLocationWithMostMixedPlayers()
//if interesting ~= nil then table.insert(choices,interesting) end
           
                     for index, camera in ientitylist(Shared.GetEntitiesWithClassname("DirectorCamera")) do
                   table.insert(choices, camera) //should be random not first. always will go to same first. argh. NM no break lol
              end    
           
              for index, shadeink in ientitylist(Shared.GetEntitiesWithClassname("ShadeInk")) do
                   table.insert(choices, shadeink)
              end     
    
              
               for index, arc in ientitylist(Shared.GetEntitiesWithClassname("ARC")) do
                      if arc.mode == ARC.kMode.Moving then table.insert(choices, arc) end
              end 
              
                            
               for index, whip in ientitylist(Shared.GetEntitiesWithClassname("Whip")) do
                      if whip.moving  then table.insert(choices, whip) end
              end 
              
             for index, contam in ientitylist(Shared.GetEntitiesWithClassname("Contamination")) do
                  table.insert(choices, contam) 
                   break  -- just 1xx
              end 
             for index, cs in ientitylist(Shared.GetEntitiesWithClassname("CommandStructure")) do
                  if cs:GetIsInCombat() then table.insert(choices, cs) break end
              end 
                 for _, construct in ipairs(GetEntitiesWithMixin("Construct")) do
                 if not construct:isa("Hydra") and not construct:isa("PowerPoint") and construct:GetIsAlive() and construct:GetHealthScalar() <= .5 and construct:GetIsInCombat() then table.insert(choices, construct) break end --built and not disabled should be summed up by if in combat?
             end  

              
               for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
                  if player ~= self and not player:isa("Spectator")  and not player:isa("ReadyRoomPlayer") 
                    and not player:isa("Commander") and player:GetIsInCombat() then 
                   table.insert(choices, player) 
                     break 
                  end
              end 
            
              local random = table.random(choices)
              return random
end
 local function GetViewTwo()

local choices = {}
//local interesting = GetLocationWithMostMixedPlayers()
//if interesting ~= nil then table.insert(choices,interesting) end
            
                                 for index, camera in ientitylist(Shared.GetEntitiesWithClassname("DirectorCamera")) do
                   table.insert(choices, camera) //should be random not first. always will go to same first. argh. NM no break lol
              end    
              

             for index, obs in ientitylist(Shared.GetEntitiesWithClassname("Observatory")) do
                  if obs:GetIsBeaconing()  then table.insert(choices, obs) break end --built and not disabled should be summed up by if in combat?
              end  
              
                      for index, whip in ientitylist(Shared.GetEntitiesWithClassname("Whip")) do
                      if whip.moving  then table.insert(choices, whip) end
                     end        
      
             for index, contam in ientitylist(Shared.GetEntitiesWithClassname("Contamination")) do
                  table.insert(choices, contam) 
                   break  -- just 1
              end
        
                  for _, construct in ipairs(GetEntitiesWithMixin("Construct")) do
                 if construct:GetIsBuilt() and  not construct:isa("PowerPoint") and construct:GetHealthScalar() <= .3 and construct:GetIsInCombat() then table.insert(choices, construct) break end --built and not disabled should be summed up by if in combat?
              end     

               for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
                  if player ~= self and not player:isa("Spectator")  and not player:isa("ReadyRoomPlayer") 
                    and not player:isa("Commander") and player:GetIsInCombat() then 
                   table.insert(choices, player) 
                    -- break 
                  end
              end       
              
             
              local random = table.random(choices)
              return random

end
local function GetViewThree()
local choices = {}    
      
                            for index, camera in ientitylist(Shared.GetEntitiesWithClassname("DirectorCamera")) do
                   table.insert(choices, camera) //should be random not first. always will go to same first. argh. NM no break lol
              end    
              
                      for index, arc in ientitylist(Shared.GetEntitiesWithClassname("ARC")) do
                    local order = arc:GetCurrentOrder()
                      if order then 
                 if order:GetType() == kTechId.Move then table.insert(choices, arc) break end -- just 1
                     end
              end 
              
                             for index, whip in ientitylist(Shared.GetEntitiesWithClassname("Whip")) do
                      if whip.moving  then table.insert(choices, whip) end
              end 
              
              
             for index, mac in ientitylist(Shared.GetEntitiesWithClassname("MAC")) do
                  if GetIsBusy(mac) then table.insert(choices, mac) break end 
              end   
         /*
             for index, cyst in ientitylist(Shared.GetEntitiesWithClassname("Cyst")) do
                  if not cyst:GetIsBuilt() then table.insert(choices, cyst) break end 
              end
      */
    
                     for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
                  if player ~= self and not player:isa("Spectator")  and not player:isa("ReadyRoomPlayer") 
                    and not player:isa("Commander") and player:GetIsInCombat() then 
                   table.insert(choices, player) 
                     break 
                  end
              end 
  
             for index, drifter in ientitylist(Shared.GetEntitiesWithClassname("Drifter")) do
                  if GetIsBusy(drifter) then table.insert(choices, drifter) break end 
              end    
                   for _, construct in ipairs(GetEntitiesWithMixin("Construct")) do //should be randomized and not index 0
                  if not construct:isa("PowerPoint") and not construct:GetIsBuilt() and construct:GetIsInCombat()
                 then table.insert(choices, construct) 
                 -- break
                  end --built and not disabled should be summed up by if in combat?
              end    
              
              local random = table.random(choices)
              return random

end

local function FindEntNear(where)
                  local entity =  GetNearestMixin(where, "Combat", nil, function(ent) return ent:GetIsInCombat() and not ent:isa("Commander") end)
                    if entity then
                    return FindFreeSpace(entity:GetOrigin())
            end
            return where
end


local function SwitchToOverHead(client, self, where)
        client:BreakChains()
        local height = math.random(4,12)
        self:NotifyGeneric( client, "Overhead mode nearby otherwise inside entity origin. Height is %s", true, height)
        if client.specMode ~= kSpectatorMode.Overhead  then client:SetSpectatorMode(kSpectatorMode.Overhead)  end
        client:SetOrigin(where)
        client.overheadModeHeight =  height

end

local function GetSiegeView()
      --Print("GetSiegeView")
    local choices = {}
    --arc if moving or in siege
    --contam
    --commandstructure if in combat
    --alive power node in combat
    --egg or structure beacon
             for index, marine in ientitylist(Shared.GetEntitiesWithClassname("Marine")) do
                  if marine:GetIsAlive() and marine:GetIsOnGround() and marine:GetHealthScalar() <= .3 and marine:GetIsInCombat() and not marine:isa("Commander")  then table.insert(choices, marine) break end --built and not disabled should be summed up by if in combat?
              end 
             for index, alien in ientitylist(Shared.GetEntitiesWithClassname("Alien")) do
                  if alien:GetIsAlive() and ( GetIsInSiege(alien) or alien:GetHealthScalar() <= .3 ) and alien:GetIsInCombat() and not alien:isa("Commander")  then table.insert(choices, alien) break end --built and not disabled should be summed up by if in combat?
              end  
               for index, arc in ientitylist(Shared.GetEntitiesWithClassname("ARC")) do
                    local order = arc:GetCurrentOrder()
                      if order then
                 if order:GetType() == kTechId.Move then table.insert(choices, arc) break end -- just 1
                     end
              end 
             for index, contam in ientitylist(Shared.GetEntitiesWithClassname("Contamination")) do
                  table.insert(choices, contam) 
                   break  -- just 1xx
              end 
             for index, cs in ientitylist(Shared.GetEntitiesWithClassname("CommandStructure")) do
                  if cs:GetIsInCombat() then table.insert(choices, cs) break end
              end 
                   for _, construct in ipairs(GetEntitiesWithMixin("Construct")) do
                  if not construct:isa("Hydra") and construct:GetIsAlive() and construct:GetHealthScalar() <= .5 and construct:GetIsInCombat() then table.insert(choices, construct) break end --built and not disabled should be summed up by if in combat?
              end  
                      for index, powerpoint in ientitylist(Shared.GetEntitiesWithClassname("PowerPoint")) do
                  if ( powerpoint:GetIsBuilt() and not powerpoint:GetIsDisabled() ) and powerpoint:GetHealthScalar() <= .65 and powerpoint:GetIsInCombat() then table.insert(choices, powerpoint) break end --built and not disabled should be summed up by if in combat?
              end 
              
          --   for index, alienbeacon in ientitylist(Shared.GetEntitiesWithClassname("AlienBeacon")) do
           --       if alienbeacon:GetIsAlive() then table.insert(choices, alienbeacon) break end --built and not disabled should be summed up by if in combat?
         --     end   
              
              local random = table.random(choices)
              return random
end

 local function GetMiddleView()
      --Print("GetMiddleView")
    --Beacons
    -- <=30% hp constructs in combat
    --moving arcs
    --contam
    local choices = {}
            -- for index, siegedoor in ientitylist(Shared.GetEntitiesWithClassname("SiegeDoor")) do
            --    if siegedoor then
            --       local player =  GetNearest(siegedoor:GetOrigin(), "Player", nil, function(ent) return not ent:isa("Commander") end)
            --         if player then
            --         table.insert(choices, player) 
            --         break  -- just 1
            --         end
             --      end
             -- end 
           --  for index, alienbeacon in ientitylist(Shared.GetEntitiesWithClassname("AlienBeacon")) do
            --      if alienbeacon:isa("EggBeacon") or alienbeacon:isa("StructureBeacon") and alienbeacon:GetIsAlive() then table.insert(choices, alienbeacon) break end --built and not disabled should be summed up by if in combat?
            --  end 
             for index, marine in ientitylist(Shared.GetEntitiesWithClassname("Marine")) do
                  if marine:GetIsAlive() and marine:GetIsOnGround() and marine:GetHealthScalar() <= .7 and marine:GetIsInCombat() and not marine:isa("Commander")  then table.insert(choices, marine) break end --built and not disabled should be summed up by if in combat?
              end 
             for index, alien in ientitylist(Shared.GetEntitiesWithClassname("Alien")) do
                  if alien:GetIsAlive() and alien:GetHealthScalar() <= .7 and alien:GetIsInCombat() and  not alien:isa("Commander")  then table.insert(choices, alien) break end --built and not disabled should be summed up by if in combat?
              end  
             for index, obs in ientitylist(Shared.GetEntitiesWithClassname("Observatory")) do
                  if obs:GetIsBeaconing() or obs:GetIsAdvancedBeaconing() then table.insert(choices, obs) break end --built and not disabled should be summed up by if in combat?
              end  
              
             for index, breakabledoor in ientitylist(Shared.GetEntitiesWithClassname("BreakableDoor")) do
              if breakabledoor:GetHealthScalar() <= .7 and not breakabledoor:GetHealth() == 0 and  breakabledoor:GetIsInCombat() then
                     local player =  GetNearest(breakabledoor:GetOrigin(), "Player", nil, function(ent) return not ent:isa("Commander") end)
                     if player then
                     table.insert(choices, player) 
                     break  -- just 1
                     end
                end
              end  
      
             for index, contam in ientitylist(Shared.GetEntitiesWithClassname("Contamination")) do
                  table.insert(choices, contam) 
                   break  -- just 1
              end
        
              for _, construct in ipairs(GetEntitiesWithMixin("Construct")) do
                  if construct:GetIsBuilt() and construct:GetHealthScalar() <= .7 and construct:GetIsInCombat() then table.insert(choices, construct) break end --built and not disabled should be summed up by if in combat?
              end     

             for index, arc in ientitylist(Shared.GetEntitiesWithClassname("ARC")) do
                 local order = arc:GetCurrentOrder()
                  if order then
                 if order:GetType() == kTechId.Move then table.insert(choices, arc) break end -- just 1
                 end
              end          
              
              
              local random = table.random(choices)
              return random

end

 function GetIsBusy(who)
    local order = who:GetCurrentOrder()
    local busy = false
    if order then
        busy = true
    end
    -- if who:isa("MAC") then
    --  elseif who:isa("Drifter") then
    -- end
    return busy
end

local function GetSetupView()
 --Print("GetSetupView")
local choices = {}
--macs, drifters, not built constructs
--front door

            --Nearest person near front door
             for index, frontdoor in ientitylist(Shared.GetEntitiesWithClassname("FrontDoor")) do
                     local player = GetNearest(frontdoor:GetOrigin(), "Player", nil, 
                        function(ent) 
                            return not ent:isa("Commander")  
                            and not ent:isa("Spectator") 
                            and ent:GetIsAlive() 
                        end)
                     if player then
                        table.insert(choices, player) 
                        break  -- just 1
                     end
              end 
              
             --Whatever person
                --for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
                  --  if player and player:GetIsAlive() then
                  --      table.insert(choices, player) 
                 --   end
               -- end 
              
              
             for index, mac in ientitylist(Shared.GetEntitiesWithClassname("MAC")) do
                  if GetIsBusy(mac) then table.insert(choices, mac) break end 
              end     
              
             for index, cyst in ientitylist(Shared.GetEntitiesWithClassname("Cyst")) do
                  if not cyst:GetIsBuilt() then table.insert(choices, cyst) break end 
              end  
              
             for index, drifter in ientitylist(Shared.GetEntitiesWithClassname("Drifter")) do
                  if GetIsBusy(drifter) then table.insert(choices, drifter) break end 
              end  
  
              for _, construct in ipairs(GetEntitiesWithMixin("Construct")) do
                  if not construct:isa("PowerPoint") and not GetIsInSiege(construct)
                 --and not construct:GetIsBuilt() then 
                    and Shared.GetTime() - construct.timeLastConstruct < 8 then
                        table.insert(choices, construct) break 
                    end --built and not disabled should be summed up by if in combat?
              end    
              
              local random = table.random(choices)
              return random

end

local function GetLocationName(who)
        local location = GetLocationForPoint(who:GetOrigin())
        local locationName = location and location:GetName() or ""
        return locationName
end

local function nearandPanning(self, client)
  
       if not client then return end
       local vip = nil
       
        if GetSiegeDoorOpen() then
         --  Print("ChangeView Siege Open")
           vip = GetSiegeView()
        elseif GetSetupConcluded() then
         --  Print("ChangeView Setup Concluded")
           vip = GetMiddleView()
        else
          -- Print("ChangeView Setup In Progress")
           vip = GetSetupView()
        end
       
        if vip ~= nil then 
        -- Print("vip is %s", vip:GetClassName())
          if client:GetSpectatorMode() ~= kSpectatorMode.FreeLook then client:SetSpectatorMode(kSpectatorMode.FreeLook)  end
          local viporigin = vip:GetOrigin()
          local findfreespace = FindFreeSpace(viporigin, 1, 8)
          if findfreespace == viporigin then findfreespace = FindEntNear(findfreespace) end
             client:SetOrigin(findfreespace)
             local dir = GetNormalizedVector(viporigin - client:GetOrigin())
             local angles = Angles(GetPitchFromVector(dir), GetYawFromVector(dir), 0)
              client:SetDesiredCamera(8.0, {move = true}, client:GetEyePos(), angles, 0)
              self:NotifyGeneric( client, "VIP is %s, location is %s", true, vip:GetClassName(), GetLocationName(client) )
              client.lastswitch = Shared.GetTime()
              client.nextangle = math.random(4,8)
        else
             client:SetSpectatorMode(kSpectatorMode.FirstPerson)
              --client:SelectEntity(GetEligableTopScorer()) 
         end
end

local function behindAndLocked(self, client, vip)
      client:SetDesiredCameraDistance(0)
    -- Print("vip is %s", vip:GetClassName())
      if client:GetSpectatorMode() ~= kSpectatorMode.FreeLook then client:SetSpectatorMode(kSpectatorMode.FreeLook)  end
      local viporigin = vip:GetOrigin()
    //  local findfreespace = FindFreeSpace(viporigin, 1, 8)
    //  if findfreespace == viporigin then findfreespace.x = findfreespace.x - 2 return end
        //  client:SetOrigin(findfreespace)
         client:SetOrigin(viporigin)
         client:SetOffsetAngles(vip:GetAngles()) //if iscam
        
         local dir = GetNormalizedVector(viporigin - client:GetOrigin())
         local angles = Angles(GetPitchFromVector(dir), GetYawFromVector(dir), 0)
         client:SetOffsetAngles(angles)
         client:SetLockOnTarget(vip:GetId())
         //Sixteenth notes within eigth notes which is the other untilNext
         self:NotifyGeneric( client, "VIP is %s, location is %s", true, vip:GetClassName(), GetLocationName(client) )        
end

local function firstPersonScoreBased(self, client)

    client:BreakChains()
    function sortByScore(ent1, ent2)
        return ent1:GetScore() > ent2:GetScore()
    end
    
    local tableof = {}
                for _, scorer in ipairs(GetEntitiesWithMixin("Scoring")) do
                 if not scorer:isa("ReadyRoomPlayer") and not scorer:isa("Commander") and scorer:GetIsAlive() then table.insert(tableof, scorer) end
              end  
    if table.count(tableof) == 0 then return end
    local max = Clamp(table.count(tableof), 1, 4)
    table.sort(tableof, sortByScore)
    local entrant = math.random(1,max)
    local topscorer = tableof[entrant]
    if not topscorer then return end
    
    if not topscorer:GetIsVirtual() then
        if client:GetSpectatorMode() ~= kSpectatorMode.FirstPerson then client:SetSpectatorMode(kSpectatorMode.FirstPerson)  end
        Server.GetOwner(client):SetSpectatingPlayer(topscorer)
        self:NotifyGeneric( client, "(First person) VIP is %s, # rank in score is %s", true, topscorer:GetName(), entrant )
    else
        //self:NotifyGeneric( client, "VIP is %s, # rank in score is %s", true, topscorer:GetName(), entrant )
        behindAndLocked(self, client, topscorer)
    end
    
end
 function Plugin:OnChangeView(client, untilNext, betweenLast)
 -- Print("ChangeView")
      -- client.SendNetworkMessage("SwitchFromFirstPersonSpectate", { mode = kSpectatorMode.Following })
        
    local chance = math.random(1,2)
    if chance == 1 then
        nearandPanning(self,client)
    else
           if not client then return end
           local vip = nil
            local random = math.random(1,3)
            if random == 1 then
               vip = GetViewOne()
            elseif random == 2 then
               vip = GetViewTwo()
            elseif random == 3 then
               vip = GetViewThree()
            else 
                firstPersonScoreBased(self, client)
            end
       
            if vip ~= nil then 
                  local roll = math.random(1,2)
                 if roll == 1 then
                  behindAndLocked(self, client, vip)
                 elseif roll == 2 then
                  firstPersonScoreBased(self, client)
                  end
          else
            firstPersonScoreBased(self, client)
           end
      end   
         Shine.ScreenText.Add( 50, {X = 0.20, Y = 0.75,Text = "[Director] untilNext: %s",Duration = betweenLast or 0,R = 255, G = 0, B = 0,Alignment = 0,Size = 1,FadeIn = 0,}, client )  
end




function Plugin:CreateCommands()

    local function Direct( Client, Targets )
        for i = 1, #Targets do
        local Player = Targets[ i ]:GetControllingPlayer()
              //Shared.ConsoleCommand(string.format("sh_setteam %s %s", Player:GetUserId(), 3 )) 
              //Player:ReplaceRespawnPlayer(Player, nil, nil, AvocaSpectator.kMapName)
              Player:Replace(AvocaSpectator.kMapName, 3)
         end
    end

    local DirectCommand = self:BindCommand( "sh_direct", "direct", Direct)
    DirectCommand:AddParam{ Type = "clients" }
end

function Plugin:ClientConfirmConnect(client)
     if  client:GetUserId() == 22542592 then 
         --Shared.ConsoleCommand(string.format("sh_setteam %s 3", client:GetUserId() ))
         self:SimpleTimer( 4, function() 
            if client then      
                Shared.ConsoleCommand(string.format("sh_direct %s", client:GetUserId() ))
            end
          end)
      end
end