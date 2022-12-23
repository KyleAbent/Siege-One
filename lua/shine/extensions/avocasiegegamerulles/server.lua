--Kyle 'Avoca' Abent
Script.Load("lua/doors/timer.lua")
--Script.Load("lua/structures/ARC_Siege22.lua")
Script.Load("lua/2019/Functions22.lua")//hook the notifycommander

Script.Load("lua/2019/Conductor.lua")
Script.Load("lua/2019/Imaginator.lua")

Plugin.Version = "1.0"
------------------------------------------------------------
function Plugin:Initialise()
self.Enabled = true
self:CreateCommands()
kgameStartTime = 0
return true
end

----------Debug-------------

/*
function Plugin:ClientConfirmConnect(Client)
    print("djahsdj")
    if not Client:GetIsVirtual() then
        Shared.ConsoleCommand("cheats 1")  
        Shared.ConsoleCommand("sh_setteam avo 1")
        Shared.ConsoleCommand("sh_give avo jetpack") 
       /*
        Shared.ConsoleCommand("sh_randomrr") 
        Shared.ConsoleCommand("sh_direct avo") 
        Shared.ConsoleCommand("sh_go") 
        local bot = Server.CreateEntity(CommanderBot.kMapName)
        bot:Initialize(1, not passive)
        local bot = Server.CreateEntity(CommanderBot.kMapName)
        bot:Initialize(2, not passive)
        */
    end    
end
*/


------------------------------------------------------------
//Messy, Whatever. Deal with it. lol.
//Either Here or in map entity door convar for front and siege
//Either or, not both. For now this way.
local function GetDoorLengthByMapName()
mapName = Shared.GetMapName()

local frontTime = 330
local siegeTime = 930
local sideTime = 540

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
    
    Print("mapName is %s", mapName)
    Print("frontTime is %s",frontTime)
    Print("siegeTime is %s", siegeTime)
    
    return frontTime, siegeTime, sideTime

end

local function grabDoorMapEditorSettings()
    local gameInfo = GetGameInfoEntity()
    local frontDoor = GetFrontDoor()
    local siegeDoor = GetSiegeDoor()
    local sideDoor = GetSideDoor()
    --Print("Frontdoor is %s", frontDoor)
    --Print("siegeDoor is %s", siegeDoor)
    
    if frontDoor ~= nil and siegeDoor ~= nil then
        Print("found front and siege doors!")
    else
        Print("frontdoor siegedoor nil ugh lol")
    end

    if sideDoor ~= nil then
        Print("found side door!")
    else
        Print("sideDoor nil ugh lol")
    end
    
    
    local frontTime = 0
    local siegeTime = 0
    local sideTime = 0

    local isDefaultFront = false
    local isDefaultSiege = false
    local isDefaultSide = false

    if frontDoor.timer ~= nil and siegeDoor.timer ~= nil then
        Print("found front and siege door timers!")
        if frontDoor.timer ~= 0 then
            frontTime = frontDoor.timer
            Print("frontTime is %s", frontTime)
        else
            isDefaultFront = true
            Print("frontTime is default by mapname")
        end
        if siegeDoor.timer ~= 0 then
            siegeTime = siegeDoor.timer
            Print("siegeTime is %s", siegeTime)
        else
            isDefaultSiege = true
            Print("siegeTime is default by mapname")
        end
    else
        isDefaultFront = true
        isDefaultSiege = true
        Print("frontdoor siegedoor timers nil ugh lol")
    end
    
    
    if sideDoor ~= nil and sideDoor.timer ~= nil then
        Print("found sideDoor and sideDoor timer!")
        if sideDoor.timer ~= 0 then
            sideTime = sideDoor.timer
            Print("sideTime is %s", sideTime)
        else
            isDefaultSide = true
            Print("sideTime is default by mapname")
        end
    end
    
    local byNameFront, byNameSiege, byNameSide = GetDoorLengthByMapName()
    
    if isDefaultFront then
        frontTime = byNameFront
        Print("Front time map setting 0, so grabbing by mapname")
        Print("Front time is %s", frontTime)
    end
    
    if isDefaultSiege then
        siegeTime = byNameSiege
        Print("Siege time map setting 0, so grabbing by mapname")
        Print("siegeTime time is %s", siegeTime)
    end
    
    if isDefaultSide then
        sideTime = byNameSide
        Print("Side time map setting 0, so grabbing by mapname")
        Print("sideTime time is %s", sideTime)
    end
    
    
    Print("siegeTime is %s", siegeTime)
    
    if siegeTime ~= kSiegeTime then
      kSiegeTime = siegeTime
      Print("kSiegeTime is %s", siegeTime)
    end
    
    if sideDoor == nil then
        kSideTime = 0
        gameInfo:SetSideTime(kSideTime)
        Print("sideDoor is nil, not found on map. Don't show its timer")
    end
    
    Print("sideTime is %s", sideTime)
    if kSideTime ~= sideTime then
        kSideTime = sideTime
        gameInfo:SetSideTime(kSideTime)
        Print("kSideTime is %s", kSideTime)
    end
    




end

------------------------------------------------------------
function Plugin:MapPostLoad()
      --Server.CreateEntity(Timer.kMapName)
      --GetDoorLengthByMapName()
      Server.CreateEntity(Conductor.kMapName)
      Server.CreateEntity(Imaginator.kMapName)
end
function Plugin:OnFirstThink()
      --GetDoorLengthByMapName()
end


------------------------------------------------------------
function Plugin:OnSiege() 
Shared.ConsoleCommand("sh_csay Siege Doors now open!!!!") 
self:NotifyTimer( nil, "Siege Doors now open!!!!", true)
end
------------------------------------------------------------
function Plugin:OnFront() 
Shared.ConsoleCommand("sh_csay Front Doors now open!!!!") 
self:NotifyTimer( nil, "Front Doors now open!!!!", true)
end
function Plugin:OnSide() 
    if GetSideDoor() ~= nil then
        Shared.ConsoleCommand("sh_csay Side Doors now open!!!!") 
        self:NotifyTimer( nil, "Side Doors now open!!!!", true)
    end
end

Shine.Hook.SetupClassHook( "NS2Gamerules", "DisplayFront", "OnFront", "PassivePost" ) 
Shine.Hook.SetupClassHook( "NS2Gamerules", "DisplaySiege", "OnSiege", "PassivePost" ) 
------------------------------------------------------------
Shine.Hook.SetupClassHook( "NS2Gamerules", "DisplayFront", "OnFront", "PassivePost" ) 
Shine.Hook.SetupClassHook( "NS2Gamerules", "DisplaySide", "OnSide", "PassivePost" ) 
Shine.Hook.SetupClassHook( "NS2Gamerules", "DisplaySiege", "OnSiege", "PassivePost" ) 
------------------------------------------------------------

function Plugin:OnAdjust() 
        local adjustment = GetGameInfoEntity():GetDynamicSiegeTimerAdjustment() or 0
        local isNegative = false
            if adjustment < 0 then
                isNegative = true
                --adjustment = math.abs(adjustment)
                adjustment = adjustment * -1
            end
        local adjMi = math.floor( adjustment / 60 )
        local adjSe = math.floor( adjustment - adjMi * 60 )
        if isNegative then
            self:NotifyTimer( nil, "Siege Timer adjustment is now: -%s:%s", true, adjMi, adjSe )
        else
            self:NotifyTimer( nil, "Siege Timer adjustment is now: %s:%s", true, adjMi, adjSe )
         end
end
Shine.Hook.SetupClassHook( "Timer", "AdjustSiegeTimer", "OnAdjust", "PassivePost" ) 
------------------------------------------------------------
  function Plugin:OnRedemedHook(player) 
        if not player:GetTeamNumber() == 2 or not player:GetIsAlive() then return end
        if player:GetEligableForRebirth() then
            --Shine.ScreenText.End(35)
            return
        end
        local NowToCoolDownOver = player:GetRedemptionCoolDown() - (Shared.GetTime() - player.lastredeemorrebirthtime)
        --Shine.ScreenText.End("Countdown") 
                        --settext? not addtext? ugh.
        --Shine.ScreenText.Add( 35, {X = 0.40, Y = 0.85,Text = "Rebirth/Redeem Cooldown: %s",Duration = NowToCoolDownOver,R = 255, G = 255, B = 255,Alignment = 0,Size = 2,FadeIn = 0,}, player ) 
       -- Shine.ScreenText.Add( 27, {X = 0.85, Y = 0.90,Text = "uhhhhhhh",Duration = 6,R = 255, G = 255, B = 255,Alignment = 0,Size = 2,FadeIn = 0,}, player ) 
        --self:NotifyOne(player:GetClient(), "Rebirth/Redeem Cooldown : %s seconds", true, NowToCoolDownOver )
         Shine.ScreenText.Add( 87, {X = 0.20, Y = 0.90,Text = "Rebirth/Redeem Cooldown: %s",Duration = NowToCoolDownOver or 0,R = 255, G = 0, B = 0,Alignment = 0,Size = 1,FadeIn = 0,}, player ) 

end
 
 
Shine.Hook.SetupClassHook( "Alien", "TriggerRebirthRedeemCountdown", "OnRedemedHook", "Replace" )
------------------------------------------------------------
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
         grabDoorMapEditorSettings() --only do once per map? hm
         GetTimer():OnRoundStart()
            --local where = FindFreeSpace(GetRandomCC():GetOrigin())
            --local ent = CreateEntity(AvocaArc.kMapName, where, 1)  
         OpenAllBreakableDoors()
      else
         Shine.ScreenText.End(1) 
      end
      
     if State ==  kGameState.Team1Won  or State ==  kGameState.Team2Won then
     
       //elseif State == kGameState.Countdown then
       elseif State == kGameState.NotStarted then
       GetTimer():OnPreGame()
     end
     
end


function Plugin:OnPostInitGorge(player,tunnel)
        local Player = player --who:GetClient():GetControllingPlayer()
        local client = Player:GetClient()
        local hasKilled = FindPlayerTunnels(Player,tunnel)

        if hasKilled then
            self:NotifyOne(client, "Your previously placed PizzaGate has been replaced with this new one", true )
            return
        end
        
end

Shine.Hook.SetupGlobalHook("HookGorgeViaServer", "OnPostInitGorge", "Replace" )
-----------------------------------------------------------
function Plugin:HookNotifyCommanderLimitReached(who)
    local commander = who:GetTeam():GetCommander()
    if commander ~= nil then
        local client = commander:GetClient()
        self:NotifyOne(client, "LoneCyst count is 5. Next placement will delete the 1st.", true )
    end
end

Shine.Hook.SetupGlobalHook( "NotifyCommanderLimitReached", "HookNotifyCommanderLimitReached", "Replace" )

function Plugin:HookNotifyCommanderKill(who)
    local commander = who:GetTeam():GetCommander()
    if commander ~= nil then
        local client = commander:GetClient()
        local location = GetLocationForPoint(who:GetOrigin())
        if location then
            self:NotifyOne(client, "Deleted LoneCyst in %s", true, location.name )
        end
    end
end

Shine.Hook.SetupGlobalHook( "NotifyCommanderKill", "HookNotifyCommanderKill", "Replace" )


------------------------------------------------------------
function Plugin:OnNotifyAlienCommander(who) 
  local commander = who:GetTeam():GetCommander()
    if commander ~= nil then
        local client = commander:GetClient()
         self:NotifyOne(client, "To Build a Hive on this AlienTechPoint, Select the AlienTechPoint then click the AlienTechPointHive TechButton to build", true)
         self:NotifyOne(client, "AlienTechPoint doesn't allow traditional Hive Building by Drag and Drop due to technical difficulties :P.", true)
    end
end
Shine.Hook.SetupClassHook( "AlienTechPoint", "NotifyAlienCommander", "OnNotifyAlienCommander", "PassivePost" ) 
------------------------------------------------------------

function Plugin:NotifyOne( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Siege 2022]",  0, 255, 0, String, Format, ... )
end
function Plugin:NotifyHiveLifeInsurance( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Hive Life Insurance ]",  0, 255, 0, String, Format, ... )
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
local function MakeExo( Client, Targets ) //make sure team 1 lol
    for i = 1, #Targets do
    local Player = Targets[ i ]:GetControllingPlayer()
        if Player:GetTeamNumber() == 1 and Player:isa("Marine") then
            Player:GiveExo(Player:GetOrigin())    
         end
     end
end
local MakeExoCommand = self:BindCommand( "sh_makeexo", "makeexo", MakeExo )
MakeExoCommand:AddParam{ Type = "clients" }
MakeExoCommand:Help( "<player> if marine then give exo" )
--------------------------------------------------------------------------------
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
       GetTimer().FrontTimer = 0
     elseif String == "Siege" or String == "siege" then
       GetTimer().SiegeTimer = 0
     elseif String == "Side" or String == "side" then
       GetTimer():OpenSideDoors()
       Shine.ScreenText.End(1) 
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
//Intended to be Debugging command not for server with players :/ Root access?
local function Go( Client )
    Shared.ConsoleCommand("cheats 1") 
    Shared.ConsoleCommand("sh_forceroundstart") 
    for i = 1, 18 do
        Shared.ConsoleCommand("addbot") 
    end    
end

local BringAllCommand = self:BindCommand( "sh_go", "go", Go )
BringAllCommand:Help( "sh_go - cheats 1 and forceroundstart" )

------------------------------------------------------


--------------------------------
end//CreateCommands



