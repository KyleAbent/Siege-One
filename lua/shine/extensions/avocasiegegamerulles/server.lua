--Kyle 'Avoca' Abent
Script.Load("lua/doors/timer.lua")
Script.Load("lua/2019/Functions19.lua")//hook the notifycommander
Plugin.Version = "1.0"
------------------------------------------------------------
function Plugin:Initialise()
self.Enabled = true
self:CreateCommands()
kgameStartTime = 0
kReduceDoorTimeBy = 0
return true
end
------------------------------------------------------------
//Messy, Whatever. Deal with it. lol.
//Either Here or in map entity door convar for front and siege
//Either or, not both. For now this way.
local function GetDoorLengthByMapName()
mapName = Shared.GetMapName()
local frontTime = 330
local siegeTime = 930
    if string.find(mapName, "siege007") then 
        frontTime = 315
        siegeTime = 915
    elseif string.find(mapName, "csiege") then
        frontTime = 420
        siegeTime = 1080
    elseif string.find(mapName, "darksiege") then
        frontTime = 420
        siegeTime = 1020
    elseif string.find(mapName, "supersiege") then
        frontTime = 360
        siegeTime = 1200
    elseif string.find(mapName, "siege005") then
        frontTime = 360
        siegeTime = 1100
    //elseif mapName == "ns2_chopsiege_2015" then
        //frontTime = 
        //siegeTime =
    //elseif mapName == "ns1_geeksiege_2015" then
        //frontTime = 
        //siegeTime =
    elseif string.find(mapName, "climbsiege") then
        frontTime = 360
        siegeTime = 960
    elseif string.find(mapName, "aliensiege") then
        frontTime = 420
        siegeTime = 1020
    elseif string.find(mapName, "space_cow_ranch_siege") then
        frontTime = 330
        siegeTime = 930
    elseif string.find(mapName, "herosiege") then
        frontTime = 330
        siegeTime = 1020
    elseif string.find(mapName, "beemersiege") then
        frontTime = 360
        siegeTime = 1020
    elseif string.find(mapName, "birdsiege") then
        frontTime = 315
        siegeTime = 915
    elseif string.find(mapName, "epicsiege") then
        frontTime = 360
        siegeTime = 1080
    elseif string.find(mapName, "fortsiege") then
        frontTime = 420
        siegeTime = 1020
    elseif string.find(mapName, "lightsiege") then
        frontTime = 330
        siegeTime = 930
    elseif string.find(mapName, "trainsiege") then
        frontTime = 420
        siegeTime = 1140
    elseif string.find(mapName, "msiege") then
        frontTime = 330
        siegeTime = 1080
    elseif string.find(mapName, "lobstersiege") then
        frontTime = 360
        siegeTime = 1020
    elseif string.find(mapName, "siegeaholic") then
        frontTime = 420
        siegeTime = 1080
    elseif string.find(mapName, "domesiege") then
        frontTime = 300
        siegeTime = 930
    elseif string.find(mapName, "bunkersiege") then
        frontTime = 330
        siegeTime = 1200
    elseif string.find(mapName, "hivesiege") then
        frontTime = 330
        siegeTime = 960
    elseif string.find(mapName, "powersiege") then
        frontTime = 360
        siegeTime = 960
     elseif string.find(mapName, "trim") then
        frontTime = 360
        --siegeTime = 960
    end     
    
    //Calculate reduction here 6.15.20
    print("frontTime was %s",frontTime)
    kReduceDoorTimeBy = math.random(frontTime*0.5, frontTime*0.7)
    frontTime = frontTime - kReduceDoorTimeBy
    print("mapName is %s", mapName)
    print("frontTime is %s",frontTime)
    print("siegeTime is %s", siegeTime)
    kFrontTime = frontTime
    kSiegeTime = siegeTime

end
------------------------------------------------------------
function Plugin:MapPostLoad()
      Server.CreateEntity(Timer.kMapName)
      GetDoorLengthByMapName()
end
function Plugin:OnFirstThink()
      GetDoorLengthByMapName()
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
    NowToFront = kFrontTime - (Shared.GetTime() - kgameStartTime)
  end
  Shine.ScreenText.Add( 1, {X = 0.40, Y = 0.75,Text = "Front: %s",Duration = NowToFront,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, who )
end
------------------------------------------------------------
local function AddSiegeTimer(who, NowToSiege)
    if not NowToSiege then 
     NowToSiege = kSiegeTime - (Shared.GetTime() - kgameStartTime)
     end
    Shine.ScreenText.Add( 2, {X = 0.40, Y = 0.95,Text = "Siege: %s",Duration = NowToSiege,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, who )
end
------------------------------------------------------------
local function GiveTimersToAll()
              //GetDoorLengthByMapName()
              local Players = Shine.GetAllPlayers()
			   //AddFrontTimer(nil)
			   //AddSiegeTimer(nil)
               for i = 1, #Players do
                   local Player = Player[ i ]//:GetControllingPlayer()
                   AddFrontTimer(Player)
                   AddSiegeTimer(Player)
               end
end
------------------------------------------------------------
//Add timer on join if game started
function Plugin:ClientConfirmConnect(Client)
--function Plugin:ClientConnect(Client)
    --REMOvE ME LOL DEBUGGING 
--Shared.ConsoleCommand("cheats 1") 
--Shared.ConsoleCommand("alltech") 
--Shared.ConsoleCommand("autobuild") 
--Shared.ConsoleCommand("sh_forceroundstart") 
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
         kgameStartTime = Shared.GetTime()
         GetTimer():OnRoundStart()
         self:NotifyTimer( nil, "Front Door time has been reduced by %s seconds", true, kReduceDoorTimeBy)
         GiveTimersToAll()
         OpenAllBreakableDoors()
      else
         Shine.ScreenText.End(1) 
         Shine.ScreenText.End(2)
         Shine.ScreenText.End(3)
      end
      
     if State ==  kGameState.Team1Won  or State ==  kGameState.Team2Won then
     
       elseif State == kGameState.Countdown then
       //GetTimer():OnRoundStart()
       //self:NotifyTimer( nil, "Front Door time has been reduced by this many seconds: %s", true, kReduceDoorTimeBy)
       elseif State == kGameState.NotStarted then
       GetTimer():OnPreGame()
     end
     
end
------------------------------------------------------------
function Plugin:NotifyOne( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Siege One]",  0, 255, 0, String, Format, ... )
end
function Plugin:NotifyGorilla( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[GorillaGlue]",  0, 255, 0, String, Format, ... )
end
------------------------------------------------------------
function Plugin:NotifyTimer( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Timer]",  0, 255, 0, String, Format, ... )
end
------------------------------------------------------------
function Plugin:NotifyGiveRes( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[GiveRes]",  255, 0, 0, String, Format, ... )
end
------------------------------------------------------------
function Plugin:NotifyGeneric( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Admin Abuse]",  0, 255, 0, String, Format, ... )
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

function Plugin:DontSpamCommanders(player)

  local mist = GetEntitiesWithinRange("NutrientMist", player:GetOrigin(), 9)
  local hasFailed = false
  local string = "lol"
  
   if #mist >=1 then 
    string = "Failed to buy: Found mist within radius"
    hasFailed = true
   end
   
   if not hasFailed then
       if player:GetResources() == 0 then
            string = "You're broke. Go to the bank. Get Res."
            hasFailed = true
       end
    end  
    
    if not hasFailed then
        string = "You have purchased mist for 1 resource"
        player:GiveItem(NutrientMist.kMapName)
        player:SetResources( player:GetResources() - 1 )
    end
    
    local client = player:GetClient()
    Shine.ScreenText.Add( "One", {X = 0.40, Y = 0.65,Text = string,Duration = 4,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, client )

end

Shine.Hook.SetupClassHook( "Player", "HookWithShineToBuyMist", "DontSpamCommanders", "Replace" )


function Plugin:lolcomm(who,techid,order)
    //print("lolcommlolcommlolcommlolcommlolcomm")
    //self:NotifyTimer(nil, "[A] Setup Time: Giving you free upgrade: %s", true, EnumToString(kTechId, techid) )
    local commander = who:GetTeam():GetCommander()
    if commander ~= nil then
        local client = commander:GetClient()
        self:NotifyOne(client, "Blocking Order for %s : %s", true, EnumToString(kTechId, techid), EnumToString(kTechId, order) )
    end
end

Shine.Hook.SetupGlobalHook( "notifycommander", "lolcomm", "Replace" )


function Plugin:doitcomm(who,techid)
    //print("lolcommlolcommlolcommlolcommlolcomm")
    //self:NotifyTimer(nil, "[A] Setup Time: Giving you free upgrade: %s", true, EnumToString(kTechId, techid) )
    local commander = who:GetTeam():GetCommander()
    if commander ~= nil then
        local client = commander:GetClient()
        self:NotifyOne(client, "[Setup-Owned_Territory] Constructing: %s", true, EnumToString(kTechId, techid) )
    end
end

Shine.Hook.SetupGlobalHook( "helpcommander", "doitcomm", "Replace" )


local function NewUpdateBatteryState( self )
        return -- lol no
end


OldUpdateBatteryState = Shine.Hook.ReplaceLocalFunction( Sentry.OnUpdate, "UpdateBatteryState", NewUpdateBatteryState )



/*

function Plugin:ShowRebirthRedemptionSettings(player)

  if not player:GetTeamNumber() == 2 or not player:GetIsAlive() then return end
  local rebirth = "Rebirth: Disabled"
  local redemption = "Redemption: Disabled"
    
    if player.hasRedeem then
        redemption = "Redemption: Enabled"
    end
    if player.hasRebirth then
        rebirth = "Rebirth: Enabled"
    end
    
    local client = player:GetClient()
    self:NotifyGorilla(player:GetClient(), "%s", true, redemption )
    self:NotifyGorilla(player:GetClient(), "%s", true, rebirth )
    --Shine.ScreenText.Add( 94, {X = 0.50, Y = 0.80,Text = rebirth,Duration = 4,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, client )
    --Shine.ScreenText.Add( 54, {X = 0.30, Y = 0.80,Text = redemption,Duration = 4,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, client )
     --Shine.ScreenText.End(25)
end

Shine.Hook.SetupClassHook( "Onos", "ShowRebirthSetting", "ShowRebirthRedemptionSettings", "Replace" )

*/

--Shine.Hook.SetupClassHook( "Onos", "ShowRedemptionSetting", "ShowRebirthRedemptionSettings", "Replace" )


  function Plugin:OnRedemedHook(player) 
        if not player:GetTeamNumber() == 2 or not player:GetIsAlive() then return end
        if player:GetEligableForRebirth() then
            Shine.ScreenText.End(35)
            return
        end
        local NowToCoolDownOver = player:GetRedemptionCoolDown() - (Shared.GetTime() - player.lastredeemorrebirthtime)
        --Shine.ScreenText.End("Countdown") 
                        --settext? not addtext? ugh.
        --Shine.ScreenText.Add( 35, {X = 0.40, Y = 0.85,Text = "Rebirth/Redeem Cooldown: %s",Duration = NowToCoolDownOver,R = 255, G = 255, B = 255,Alignment = 0,Size = 2,FadeIn = 0,}, player ) 
       -- Shine.ScreenText.Add( 27, {X = 0.85, Y = 0.90,Text = "uhhhhhhh",Duration = 6,R = 255, G = 255, B = 255,Alignment = 0,Size = 2,FadeIn = 0,}, player ) 
        self:NotifyOne(player:GetClient(), "Rebirth/Redeem Cooldown : %s seconds", true, NowToCoolDownOver )
end
 
 
Shine.Hook.SetupClassHook( "Alien", "TriggerRebirthRedeemCountdown", "OnRedemedHook", "Replace" )

/*
  function Plugin:TellThemToGetOutOfCombat(player) 
            if not player:GetTeamNumber() == 2 or not player:GetIsAlive() then return end
            --Shine.ScreenText.Add( 25, {X = 0.50, Y = 0.65,Text = "Get out of Combat!!!",Duration = 2,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, player ) 
            self:NotifyGorilla(player:GetClient(), "Get out of Combat!!!", true )
end
 
 
Shine.Hook.SetupClassHook( "Onos", "GetOutOfComebat", "TellThemToGetOutOfCombat", "PassivePre" )
*/




Shine.Hook.SetupClassHook( "Alien", "TriggerRebirthCountDown", "DoCountdown", "PassivePre" )



/*
function Plugin:ShowRedemptionSetting(player)

  local redemption = "Redemption: Disabled"
    
    if player.hasRedeem then
        redemption = "Redemption: Enabled"
    end
    
    local client = player:GetClient()
    Shine.ScreenText.Add( "Foures", {X = 0.40, Y = 0.75,Text = redemption,Duration = 4,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, client )
end
function Plugin:ShowRebirthSetting(player)

  local rebirth = "Rebirth: Disabled"
    
    if player.hasRebirth then
        rebirth = "Rebirth: Enabled"
    end
    
    local client = player:GetClient()
    Shine.ScreenText.Add( "Tres", {X = 0.50, Y = 0.65,Text = rebirth,Duration = 4,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, client )
end
Shine.Hook.SetupClassHook( "Onos", "ShowRebirthSetting", "ShowRedemptionSetting", "Replace" )
Shine.Hook.SetupClassHook( "Onos", "ShowRedemptionSetting", "ShowRebirthSetting", "Replace" )

*/

function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
    //Print("JoinTeam newteam is %s", newteam)
    if ShineForce or newteam == kSpectatorIndex or newteam == kTeamReadyRoom then return end

    local chosenTeamCount = 0
    local failString = ""
    local maxSizeForTeam = 0
    
    if newteam == 1 then
        chosenTeamCount =  gamerules:GetTeam1():GetNumPlayers()
        failString = "Marine Team Capped at 19 Players"
        maxSizeForTeam = 19
    elseif newteam == 2 then
        chosenTeamCount = gamerules:GetTeam2():GetNumPlayers()
        failString = "Alien Team Capped at 23 Players"
        maxSizeForTeam = 23
    end
   


    if chosenTeamCount >= maxSizeForTeam then
        local client = player:GetClient()
        if not client:GetIsVirtual() then
            self:NotifyOne(client, "%s", true, failString )
        end
        return false
    end
end

/*
function Plugin:SiegeGetCanJoinTeamNumber(self, player, teamNumber)
        Print("teamNumber is %s", ToString(teamNumber) )
        if teamNumber == 2 then
            Print("A")
            local marineCount = GetGamerules():GetTeam1():GetNumPlayers()
            local alienCount = GetGamerules():GetTeam2():GetNumPlayers()
            if alienCount > marineCount then-- alien count
            Print("B")
            local difference = math.abs(alienCount - marineCount)
                if  difference < 4 then
                    Print("C")
                    local client = player:GetClient()
                    if not client:GetIsVirtual() then
                        --self:NotifyOne(client, "Alien Team Greter Size than Marine team by %s, allowing a size of %s more aliens than marines", true, difference, math.abs(difference - 4) )
                    end
                    return true --kTeam2Index -- Allow Alien Stack lol
                end
            end
        end
end

Shine.Hook.SetupClassHook( "NS2Gamerules", "GetCanJoinTeamNumber", "SiegeGetCanJoinTeamNumber", "PassivePre" )
--Shine.Hook.SetupClassHook( "Gamerules", "GetCanJoinPlayingTeam", "SiegeGetCanJoinTeamNumber", "PassivePre" )

*/
