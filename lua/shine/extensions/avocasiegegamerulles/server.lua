--Kyle 'Avoca' Abent
Script.Load("lua/doors/timer.lua")
Plugin.Version = "1.0"
------------------------------------------------------------
function Plugin:Initialise()
self.Enabled = true
self:CreateCommands()
return true
end
------------------------------------------------------------
function Plugin:MapPostLoad()
      Server.CreateEntity(Timer.kMapName)
      GetDoorLengthByMapName()
end
------------------------------------------------------------
//Messy, Whatever. Deal with it. lol.
//Either Here or in map entity door convar for front and siege
//Either or, not both. For now this way.
local function GetDoorLengthByMapName()
mapName = Shared.GetMapName()
local frontTime = 330
local siegeTime = 930
    if mapName == "ns1_siege007_2018" then
        frontTime = 315
        siegeTime = 915
    elseif mapName == "ns1_csiege_2018" then
        frontTime = 420
        siegeTime = 1080
    //elseif mapName == "ns2_chopsiege_2015" then
        //frontTime = 
        //siegeTime =
    //elseif mapName == "ns1_geeksiege_2015" then
        //frontTime = 
        //siegeTime =
    elseif mapName == "ns1_climbsiege_2017b" then
        frontTime = 360
        siegeTime = 960
    elseif mapName == "ns1_aliensiege_2017" then
        frontTime = 420
        siegeTime = 1020
    elseif mapName == "ns1_space_cow_ranch_siege_2018" then
        frontTime = 530
        siegeTime = 930
    elseif mapName == "ns1_herosiege_r2016" then
        frontTime = 330
        siegeTime = 1020
    elseif mapName == "ns1_beemersiege_2018a" then
        frontTime = 360
        siegeTime = 1020
    elseif mapName == "ns1_birdsiege_2015" then
        frontTime = 315
        siegeTime = 915
    elseif mapName == "ns1_birdsiege_2017" then
        frontTime = 330
        siegeTime = 960
    elseif mapName == "ns1_epicsiege_2017" then
        frontTime = 360
        siegeTime = 1080
    elseif mapName == "ns1_fortsiege_2018" then
        frontTime = 420
        siegeTime = 1020
    elseif mapName == "ns1_lightsiege_2017" then
        frontTime = 330
        siegeTime = 930
    elseif mapName == "ns2_trainsiege2_2018" then
        frontTime = 420
        siegeTime = 1140
    elseif mapName == "ns1_darksiege_2018" then
        frontTime =  420
        siegeTime = 1020
    elseif mapName == "ns2_lobstersiege_2015" then
        frontTime = 360
        siegeTime = 1020
    elseif mapName == "ns1_siegeaholic_2017" then
        frontTime = 420
        siegeTime = 1080
    elseif mapName == "ns2_domesiege2_2015(1)" then
        frontTime = 300
        siegeTime = 930
    elseif mapName == "ns2_bunkersiege2_2015" then
        frontTime = 330
        siegeTime = 1200
    elseif mapName == "ns2_hivesiege6_2017" then
        frontTime = 530
        siegeTime = 960
    elseif mapName == "ns1_powersiege_2017" then
        frontTime = 360
        siegeTime = 960
    elseif mapName == "ns1_herosiege_r2016" then
        frontTime = 360
        siegeTime = 1020
    end     
    print("mapName is %s", mapName)
    print("frontTime is %s",frontTime)
    print("siegeTime is %s", siegeTime)
    kFrontTime = frontTime
    kSiegeTime = siegeTime

end
------------------------------------------------------------
function Plugin:OnSiege() 
Shared.ConsoleCommand("sh_csay Siege Door(s) now open!!!!") 
self:NotifyTimer( nil, "Siege Door(s) now open!!!!", true)
end
------------------------------------------------------------
function Plugin:OnFront() 
Shared.ConsoleCommand("sh_csay Front Door(s) now open!!!!") 
self:NotifyTimer( nil, "Front Door(s) now open!!!!", true)
end
------------------------------------------------------------
Shine.Hook.SetupClassHook( "NS2Gamerules", "DisplayFront", "OnFront", "PassivePost" ) 
Shine.Hook.SetupClassHook( "NS2Gamerules", "DisplaySiege", "OnSiege", "PassivePost" ) 
------------------------------------------------------------
local function AddFrontTimer(who,NowToFront)
  if not NowToFront then 
    NowToFront = kFrontTime - (Shared.GetTime() - GetGamerules():GetGameStartTime())
  end
  Shine.ScreenText.Add( 1, {X = 0.40, Y = 0.75,Text = "Front: %s",Duration = NowToFront,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, who )
end
------------------------------------------------------------
local function AddSiegeTimer(who, NowToSiege)
    if not NowToSiege then 
     NowToSiege = kSiegeTime - (Shared.GetTime() - GetGamerules():GetGameStartTime())
     end
    Shine.ScreenText.Add( 2, {X = 0.40, Y = 0.95,Text = "Siege: %s",Duration = NowToSiege,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, who )
end
------------------------------------------------------------
local function GiveTimersToAll()
              GetDoorLengthByMapName()
              local Players = Shine.GetAllPlayers()
			   //AddFrontTimer(nil)
			   //AddSiegeTimer(nil)
               for i = 1, #Players do
                   local Player = Player[ i ]//:GetControllingPlayer()
                   AddFrontTimer(Player)
                   AddSiegeTimer(Player)
               
end
------------------------------------------------------------
//Add timer on join if game started
function Plugin:ClientConfirmConnect(Client)
  if Client:GetIsVirtual() then return end
    if GetGamerules():GetGameStarted() then
       if not GetTimer():GetIsFrontOpen() then
         AddFrontTimer(Client)
        end
        if not GetTimer():GetIsSiegeOpen() then
         AddSiegeTimer(Client)
        end
   end
end
------------------------------------------------------------
local function OpenAllBreakableDoors()
     for _, door in ientitylist(Shared.GetEntitiesWithClassname("BreakableDoor")) do 
       door.open = true
       door.timeOfDestruction = Shared.GetTime() 
       door:SetHealth(door:GetHealth() - 10)
     end
end
------------------------------------------------------------
function Plugin:SetGameState( Gamerules, State, OldState )
     if State == kGameState.Started then 
         GiveTimersToAll()
         OpenAllBreakableDoors()
      else
         Shine.ScreenText.End(1) 
         Shine.ScreenText.End(2)
         Shine.ScreenText.End(3)
      end
      
     if State ==  kGameState.Team1Won  or State ==  kGameState.Team2Won then
     
       elseif State == kGameState.Countdown then
       GetTimer():OnRoundStart()
       elseif State == kGameState.NotStarted then
       GetTimer():OnPreGame()
     end
     
end
------------------------------------------------------------
function Plugin:NotifyTimer( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Timer]",  255, 0, 0, String, Format, ... )
end
------------------------------------------------------------
function Plugin:NotifyGiveRes( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[GiveRes]",  255, 0, 0, String, Format, ... )
end
------------------------------------------------------------
function Plugin:NotifyGeneric( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Admin Abuse]",  255, 0, 0, String, Format, ... )
end
------------------------------------------------------------
function Plugin:NotifyAutoComm( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[AutoComm]",  255, 0, 0, String, Format, ... )
end
------------------------------------------------------------
function Plugin:NotifyMods( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Moderator Chat]",  255, 0, 0, String, Format, ... )
end
------------------------------------------------------------
function Plugin:GiveCyst(Player)
            local ent = CreateEntity(CystSiege.kMapName, Player:GetOrigin(), Player:GetTeamNumber())  
             ent:SetConstructionComplete()
end
------------------------------------------------------------
function Plugin:CreateCommands()

local function Pres( Client, Targets, Number )
    for i = 1, #Targets do
        local Player = Targets[ i ]:GetControllingPlayer()
        if not Player:isa("ReadyRoomTeam")  and Player:isa("Alien") or Player:isa("Marine") then
            Player:SetResources(Number)
           	Shine:CommandNotify( Client, "set %s's resources to %s", true,
			Player:GetName() or "<unknown>", Number )  
        end
     end
end

local PresCommand = self:BindCommand( "sh_pres", "pres", Pres)
PresCommand:AddParam{ Type = "clients" }
PresCommand:AddParam{ Type = "number" }
PresCommand:Help( "sh_pres <player> <number> sets player's pres to the number desired." )
------------------------------------------------------------

local function  AddScore( Client, Targets, Number )
    for i = 1, #Targets do
    local Player = Targets[ i ]:GetControllingPlayer()
            if HasMixin(Player, "Scoring") then
            Player:AddScore(Number, 0, false)
           	 Shine:CommandNotify( Client, "%s's score increased by %s", true,
			 Player:GetName() or "<unknown>", Number )  
             end
     end
end

local AddScoreCommand = self:BindCommand( "sh_addscore", "addscore", AddScore)
AddScoreCommand:AddParam{ Type = "clients" }
AddScoreCommand:AddParam{ Type = "number" }
AddScoreCommand:Help( "sh_addscore <player> <number> adds number to players score" )
------------------------------------------------------------

local function RandomRR( Client )
        local rrPlayers = GetGamerules():GetTeam(kTeamReadyRoom):GetPlayers()
        for p = #rrPlayers, 1, -1 do
            JoinRandomTeam(rrPlayers[p])
        end
        Shine:CommandNotify( Client, "randomized the readyroom", true)  
end
local RandomRRCommand = self:BindCommand( "sh_randomrr", "randomrr", RandomRR )
RandomRRCommand:Help( "randomize's the ready room.") 
------------------------------------------------------------
local function Stalemate( Client )
local Gamerules = GetGamerules()
if not Gamerules then return end
Gamerules:DrawGame()
end 

local StalemateCommand = self:BindCommand( "sh_stalemate", "stalemate", Stalemate )
StalemateCommand:Help( "declares the round a draw." )
------------------------------------------------------------
local function Slap( Client, Targets, Number )
    for i = 1, #Targets do
    local Player = Targets[ i ]:GetControllingPlayer()
       if Player and Player:GetIsAlive() and not Player:isa("Commander") then
            self:NotifyGeneric( nil, "slapping %s for %s seconds", true, Player:GetName(), Number)
            self:CreateTimer( 13, 1, Number, 
            function () 
                if not Player:GetIsAlive()  and self:TimerExists(13) then self:DestroyTimer( 13 ) return end
                Player:SetVelocity(  Player:GetVelocity() + Vector(math.random(-900,900),math.random(-900,900),math.random(-900,900)  ) )
            end )
        end
    end
end
local SlapCommand = self:BindCommand( "sh_slap", "slap", Slap)
SlapCommand:Help ("sh_slap <player> <time> Slaps the player once per second random strength")
SlapCommand:AddParam{ Type = "clients" }
SlapCommand:AddParam{ Type = "number" }
------------------------------------------------------------
local function Respawn( Client, Targets )
    for i = 1, #Targets do
    local Player = Targets[ i ]:GetControllingPlayer()
	        	Shine:CommandNotify( Client, "respawned %s.", true,
				Player:GetName() or "<unknown>" )  
         Player:GetTeam():ReplaceRespawnPlayer(Player)
                 Player:SetCameraDistance(0)
     end
end
local RespawnCommand = self:BindCommand( "sh_respawn", "respawn", Respawn )
RespawnCommand:AddParam{ Type = "clients" }
RespawnCommand:Help( "<player> respawns said player" )
------------------------------------------------------------
local function Destroy( Client, String  ) 
        local player = Client:GetControllingPlayer()
        for _, entity in ipairs( GetEntitiesWithMixinWithinRange( "Live", player:GetOrigin(), 8 ) ) do
            if string.find(entity:GetMapName(), String)  then
                  self:NotifyGeneric( nil, "destroyed %s in %s", true, entity:GetMapName(), entity:GetLocationName())
                  DestroyEntity(entity)
				  break
             end
         end
end
local DestroyCommand = self:BindCommand( "sh_destroy", "destroy", Destroy )
DestroyCommand:AddParam{ Type = "string" }
DestroyCommand:Help( "Destroy <string> Destroys entity with this name within 8 radius" )
------------------------------------------------------------
local function Give( Client, Targets, String, Number )
    for i = 1, #Targets do
        local Player = Targets[ i ]:GetControllingPlayer()
        if Player and Player:GetIsAlive() and String ~= "alien" and not (Player:isa("Alien") and String == "armory") and not (Player:isa"ReadyRoomTeam" and String == "CommandStation" or String == "Hive") and not Player:isa("Commander") then 
            local teamnum = Number and Number or Player:GetTeamNumber()
            local ent = CreateEntity(String, Player:GetOrigin(), teamnum)  
            if HasMixin(ent, "Construct") then 
             ent:SetConstructionComplete() 
            end
            Shine:CommandNotify( Client, "gave %s an %s", true,
            Player:GetName() or "<unknown>", String )  
        end
    end
end
local GiveCommand = self:BindCommand( "sh_give", "give", Give )
GiveCommand:AddParam{ Type = "clients" }
GiveCommand:AddParam{ Type = "string" }
GiveCommand:AddParam{ Type = "number", Optional = true }
GiveCommand:Help( "<player> Give item to player(s)" )
------------------------------------------------------------
local function OpenBreakableDoors()
           for index, breakabledoor in ientitylist(Shared.GetEntitiesWithClassname("BreakableDoor")) do
               if breakabledoor.health ~= 0 then breakabledoor.health = 0 end 
                end

end
local function Open( Client, String )
local Gamerules = GetGamerules()
     if String == "Front" or String == "front" then
       GetTimer():OpenFrontDoors()
       Shine.ScreenText.End(1) 
     elseif String == "Siege" or String == "siege" then
       GetTimer():OpenSiegeDoors()
     elseif String == "Breakable" or String == "breakable" then
       OpenBreakableDoors()
    end  
  self:NotifyGeneric( nil, "Opened the %s doors", true, String)  
end 

local OpenCommand = self:BindCommand( "sh_open", "open", Open )
OpenCommand:AddParam{ Type = "string" }
OpenCommand:Help( "Opens <type> doors (Front/Siege) (not case sensitive) - timer will still display." )
------------------------------------------------------------
local function BringAll( Client )
    self:NotifyGeneric( nil, "Brought everyone to one locaiton/area", true)
        local Players = Shine.GetAllPlayers() //change to player for bots lol
              for i = 1, #Players do
              local Player = Players[ i ]
                  if Player and not Player:isa("Commander") and not Player:isa("Spectator") then
                       local where = FindFreeSpace(Client:GetControllingPlayer():GetOrigin())
                       Player:SetOrigin(where)
                  end
              end
end

local BringAllCommand = self:BindCommand( "sh_bringall", "bringall", BringAll )
BringAllCommand:Help( "sh_bringall - teleports everyone to the same spot" )
------------------------------------------------------------
end//CreateCommands
