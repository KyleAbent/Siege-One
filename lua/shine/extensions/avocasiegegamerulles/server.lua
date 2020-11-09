--Kyle 'Avoca' Abent
Script.Load("lua/doors/timer.lua")
Script.Load("lua/2019/Functions19.lua")//hook the notifycommander
Plugin.Version = "1.0"
------------------------------------------------------------
function Plugin:Initialise()
self.Enabled = true
self:CreateCommands()
kgameStartTime = 0
--kReduceDoorTimeBy = 0

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
    
    //Calculate reduction here 6.15.20
    --Print("frontTime was %s",frontTime)
    --kReduceDoorTimeBy = math.random(frontTime*0.5, frontTime*0.7)
    --frontTime = frontTime - kReduceDoorTimeBy
    Print("mapName is %s", mapName)
    Print("frontTime is %s",frontTime)
    Print("siegeTime is %s", siegeTime)
    --kFrontTime = frontTime
    --kSiegeTime = siegeTime
    
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
    
    if frontDoor.shortenTimer ~= nil then
        Print("found front shortenTimer!, set to %s", frontDoor.shortenTimer)
        if frontDoor.shortenTimer == true then
            Print("shortentimer true, reducing front timer")
            //Calculate reduction here 6.15.20
            Print("frontTime was %s",frontTime)
            kReduceDoorTimeBy = math.random(frontTime*0.5, frontTime*0.7)
            frontTime = frontTime - kReduceDoorTimeBy
            gameInfo:SetFrontTime(frontTime)
            Print("mapName is %s", mapName)
            Print("frontTime is %s",frontTime)
            kFrontTime = frontTime
       else
        Print("frontTime is %s",frontTime)
        kFrontTime = frontTime
        gameInfo:SetFrontTime(frontTime)
       end
    end
    
    --lol
    if frontDoor.shortenTimer == nil then
            Print("shortentimer true, reducing front timer")
            //Calculate reduction here 6.15.20
            Print("frontTime was %s",frontTime)
            kReduceDoorTimeBy = math.random(frontTime*0.5, frontTime*0.7)
            frontTime = frontTime - kReduceDoorTimeBy
            Print("mapName is %s", mapName)
            Print("frontTime is %s",frontTime)
            kFrontTime = frontTime
            gameInfo:SetFrontTime(frontTime)
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
      Server.CreateEntity(Timer.kMapName)
      --GetDoorLengthByMapName()
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
         if kReduceDoorTimeBy > 0 then
            local adjustment = kReduceDoorTimeBy + kFrontTime
            local adjMi = math.floor( adjustment / 60 )
            local adjSe = math.floor( adjustment - adjMi * 60 )
            self:NotifyTimer( nil, "Front Door default timer: %s:%s", true, adjMi,adjSe)
            adjustment = kReduceDoorTimeBy
            adjMi = math.floor( adjustment / 60 )
            adjSe = math.floor( adjustment - adjMi * 60 )
            self:NotifyTimer( nil, "Front Door adjustment is: -%s:%s", true, adjMi,adjSe)
         end
         OpenAllBreakableDoors()
      else
         Shine.ScreenText.End(1) 
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



------------------------------------------------------

local function TunnelColor( Client, Number )
local Player = Client:GetControllingPlayer()
    if not Player:isa("Gorge") then
         self:NotifyOne(Client, "This currently only applies to Gorges", true)
         return
    end

    if Number < 1 or Number > 11 then
         self:NotifyOne(Client, "Pick a number 1-11", true)
         return
    end
    
    Player.tunnelColor = Number
    self:NotifyOne(Client, "Set your tunnel color to %s.", true, Number)
    --self:NotifyOne(Client, "To make this easier programming for Avoca, this will apply to your NEXT dropped tunnel, and not your current. (Be careful you can have mismatching).", true, Number)

    --I'm so glad I don't have to do a for loop of all tunnels and do an if statement for if owner. lol.
    for _, ownedEnt in ipairs(Player.ownedEntities) do
        if ownedEnt:isa("TunnelEntrance") then
            Print("Found tunnel!")
            ownedEnt.tunnelColor = Number
            ownedEnt:GetMiniMapColors()
        end
    end
   

    
end    

local TunnelCommand = self:BindCommand( "sh_tunnelcolor", "tunnelcolor", TunnelColor )
TunnelCommand:AddParam{ Type = "number" }

--------------------------------
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

function Plugin:DontSpamCommandersMed(player)

  local mist = GetEntitiesWithinRange("MedPack", player:GetOrigin(), 9)
  local hasFailed = false
  local string = "lol"
  
   if #mist >=2 then 
    string = "Failed to buy: Found 2 medpack within radius"
    hasFailed = true
   end
   
   if not hasFailed then
       if player:GetResources() == 0 then
            string = "You're broke. Go to the bank. Get Res."
            hasFailed = true
       end
    end  
    
    if not hasFailed then
        string = "You have purchased medpack for 1 resource"
        --player:GiveItem(NutrientMist.kMapName)
          player:DelayMedPack()
    end
    
    local client = player:GetClient()
    Shine.ScreenText.Add( "One", {X = 0.40, Y = 0.65,Text = string,Duration = 4,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, client )

end

Shine.Hook.SetupClassHook( "Player", "HookWithShineToBuyMed", "DontSpamCommandersMed", "Replace" )

function Plugin:DontSpamCommandersAmmo(player)

  local mist = GetEntitiesWithinRange("AmmoPack", player:GetOrigin(), 9)
  local hasFailed = false
  local string = "lol"
  
   if #mist >=2 then 
    string = "Failed to buy: Found 2 ammopack within 9 radius"
    hasFailed = true
   end
   
   if not hasFailed then
       if player:GetResources() == 0 then
            string = "You're broke. Go to the bank. Get Res."
            hasFailed = true
       end
    end  
    
    if not hasFailed then
        string = "You have purchased ammopack for 1 resource"
        player:DelayAmmoPack()
    end
    
    local client = player:GetClient()
    Shine.ScreenText.Add( "One", {X = 0.40, Y = 0.65,Text = string,Duration = 4,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, client )

end
Shine.Hook.SetupClassHook( "Player", "HookWithShineToBuyAmmo", "DontSpamCommandersAmmo", "Replace" )


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
            --Shine.ScreenText.End(35)
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



function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
    //Print("JoinTeam newteam is %s", newteam)
    if ShineForce or newteam == kSpectatorIndex or newteam == kTeamReadyRoom then return end

    local chosenTeamCount = 0
    local failString = ""
    local maxSizeForTeam = 0
    
    if newteam == 1 or newteam == 2 then
        local client = player:GetClient()
       self:NotifyOne(client, "Welcome to this annoying message which will spam you every Marine or Alien teamjoin until modified", true )
       self:NotifyOne(client, "Bugs? Balance issues? Feature requests?", true )
       self:NotifyOne(client, "Greetings from Avoca. I'm here to tell you I've no idea what to write.", true )
       self:NotifyOne(client, "I am writing behind the scenes not playing for myself. ", true )
       self:NotifyOne(client, "5 years of LUA? Ok", true )
    end

end


