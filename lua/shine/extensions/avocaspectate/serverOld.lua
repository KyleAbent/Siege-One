/*

--Kyle 'Avoca' Abent
local Shine = Shine
local Plugin = Plugin

Plugin.Version = "1.0"

function Plugin:Initialise()
self.Enabled = true
self:CreateCommands()
return true
end

function Plugin:CreateCommands()

local function Direct( Client )
   local controlling = Client:GetControllingPlayer()
   if controlling:GetTeamNumber() == kSpectatorIndex then //getteamnumbeR? bleh
        //controlling:ReplaceRespawnPlayer(AvocaSpectator.kMapName, 3)
        controlling:ToggleDirectorOn()
        self:NotifySpectator(Client, "This is simple version just to get the functionality working.", true )
        self:NotifySpectator(Client, "It can be tuned with more angles. With menu options to disable/enable settings, change intervals, whatever..", true )
        self:NotifySpectator(Client, "For now this should help slightly with the idea of AFKING with great footage to watch in the meantime, maybe.", true )
        self:NotifySpectator(Client, "Known issue: Camera might hang if target is on complete other side of map? ", true )

   end
end

local DirectCommand = self:BindCommand( "sh_direct", "direct", Direct)

local function DirectOff( Client )
   local controlling = Client:GetControllingPlayer()
   if controlling:GetTeamNumber() == kSpectatorIndex then //getteamnumbeR? bleh
        //Shared.ConsoleCommand( string.format("sh_setteam %s 0", Client:GetUserId() ) )
        controlling:ToggleDirectorOff()
        self:NotifySpectator(Client, "Director Disabled", true )
   end
end

local DirectCommand = self:BindCommand( "sh_directoff", "directoff", DirectOff)



end





function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
    //Print("JoinTeam newteam is %s", newteam)
    if  newteam == kSpectatorIndex then 
        self:NotifySpectator(player:GetClient(), "Interested in some sweet camera angles? Open your menu and click on Direct (must be free camera mode or overhead , not first person)", true )
    end 
end


function Plugin:NotifySpectator( Player, String, Format, ... )
    Shine:NotifyDualColour( Player, 255, 165, 0,  "[Director]",  0, 255, 0, String, Format, ... )
end


*/





--Kyle 'Avoca' Abent
local Shine = Shine
local Plugin = Plugin



Plugin.Version = "1.0"

function Plugin:Initialise()
self.Enabled = true
self:CreateCommands()
return true
end

function Plugin:NotifyGeneric( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Spectate]",  255, 0, 0, String, Format, ... )
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
local function FindEntNear(where)
                  local entity =  GetNearestMixin(where, "Combat", nil, function(ent) return ent:GetIsInCombat() and not ent:isa("Commander") end)
                    if entity then
                    return FindFreeSpace(entity:GetOrigin())
            end
            return where
end
local function ChangeView(self, client)
 -- Print("ChangeView")
      -- client.SendNetworkMessage("SwitchFromFirstPersonSpectate", { mode = kSpectatorMode.Following })
        
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
        else
             client:SetSpectatorMode(kSpectatorMode.FirstPerson)
              --client:SelectEntity(GetEligableTopScorer()) 
         end

end

local function AutoSpectate(self, client)
    Shine.Timer.Create( "AutoSpectate", 8, -1, 
        function() 
            if client and client:isa("Spectator") then 
                ChangeView(self, client) 
                --Print("AvocaSpectate 1")
            else 
                Shine.Timer.Destroy("AutoSpectate") 
                --Print("AvocaSpectate 2")
            end  
        end )
end


function Plugin:ClientConfirmConnect(client)
     if  client:GetUserId() == 22542592 then 
         Shared.ConsoleCommand(string.format("sh_setteam %s 3", client:GetUserId() ))
         self:SimpleTimer( 4, function() 
            if client then      
                Shared.ConsoleCommand(string.format("sh_direct %s", client:GetUserId() ))
            end
          end)
      end
end

function Plugin:CreateCommands()

    local function Direct( Client, Targets )
        for i = 1, #Targets do-- if not client is virtual..
        local Player = Targets[ i ]:GetControllingPlayer()
                if Player then 
                    Shared.ConsoleCommand(string.format("sh_setteam %s 3", Targets[i]:GetUserId() ))
                    --Player:Replace(AvocaSpectator.kMapName)  
                    Player:SetSpectatorMode(kSpectatorMode.FirstPerson) 
                    AutoSpectate(self, Player)
                end
         end
    end

    local DirectCommand = self:BindCommand( "sh_direct", "direct", Direct)
    DirectCommand:AddParam{ Type = "clients" }
    DirectCommand:Help( "sh_direct <player> force place to become a director" )
end    
