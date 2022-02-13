/*Kyle 'Avoca' Abent Credits Season 3
KyleAbent@gmail.com 
*/
local Shine = Shine
local Plugin = Plugin
local HTTPRequest = Shared.SendHTTPRequest


Plugin.HasConfig = true
Plugin.ConfigName = "CreditsConfig.json"

Plugin.DefaultConfig  = { kCreditMultiplier = 1, kCreditsCapPerRound = 200 }

Shine.CreditData = {}
Shine.LinkFile = {}
Shine.BadgeFile = {}
Plugin.Version = "11.16"

local CreditsPath = "config://shine/plugins/credits.json"
local URLPath = "config://shine/CreditsLink.json"
--local BadgeURLPath = "config://shine/BadgesLink.json"
--local BadgesPath = "config://shine/UserConfig.json"

Shine.Hook.SetupClassHook( "ScoringMixin", "AddScore", "OnScore", "PassivePost" )
Shine.Hook.SetupClassHook( "NS2Gamerules", "ResetGame", "OnReset", "PassivePost" )



function Plugin:Initialise()
self:CreateCommands()
self.Enabled = true
self.GameStarted = false
self.CreditAmount = 0
self.CreditUsers = {}
self.BuyUsersTimer = {}
self.marinecredits = 0
self.aliencredits = 0
self.marinebonus = 0
self.alienbonus = 0

self.UserStartOfRoundCredits = {}
self.MarineTotalSpent = 0
self.AlienTotalSpent = 0
self.Refunded = false

self.PlayerSpentAmount = {}
self.ShadeInkCoolDown = 0 

return true
end


function Plugin:GenereateTotalCreditAmount()
local credits = 0
Print("%s users", table.Count(self.CreditData.Users))
for i = 1, table.Count(self.CreditData.Users) do
    local table = self.CreditData.Users.credits
    credits = credits + table
end
Print("%s Credit",credits)
end


local function GetPathingRequirementsMet(position, extents)

    local noBuild = Pathing.GetIsFlagSet(position, extents, Pathing.PolyFlag_NoBuild)
    local walk = Pathing.GetIsFlagSet(position, extents, Pathing.PolyFlag_Walk)
    return not noBuild and walk
    
end


function Plugin:HasLimitOfCragInHive(Player, mapname, teamnumbber, limit, Client)
--3 crag outside of hive and 5 inside hive
local entitycount = 0
local entities = {}
if limitMod == true then limit = 8 end
        for index, entity in ipairs(GetEntitiesWithMixinForTeam("Live", teamnumbber)) do
        if entity:GetMapName() == mapname and entity:GetOwner() == Player and GetIsOriginInHiveRoom( entity:GetOrigin() ) then entitycount = entitycount + 1 table.insert(entities, entity) end 
    end

     //             <
    if entitycount ~= limit then return false end
     return true
end

function Plugin:PregameLimit(teamnum)
local entitycount = 0
local entities = {}
        for index, entity in ipairs(GetEntitiesWithMixinForTeam("Live", teamnum)) do
       entitycount = entitycount + 1  
    end
       if entitycount <= 99 then return false end
       return false 
end


function Plugin:HasLimitOfCragOutHive(Player, mapname, teamnumbber, limit, Client)
local entitycount = 0
local entities = {}
if limitMod == true then limit = 8 end
        for index, entity in ipairs(GetEntitiesWithMixinForTeam("Live", teamnumbber)) do
        if entity:GetMapName() == mapname and entity:GetOwner() == Player and not GetIsOriginInHiveRoom( entity:GetOrigin() )  then entitycount = entitycount + 1 table.insert(entities, entity) end 
    end

     //             <
    if entitycount ~= limit then return false end
     return true
end


function Plugin:HasLimitOf(Player, mapname, teamnumbber, limit, Client)
local entitycount = 0
local entities = {}
        for index, entity in ipairs(GetEntitiesWithMixinForTeam("Live", teamnumbber)) do
        if entity:GetMapName() == mapname and entity:GetOwner() == Player then entitycount = entitycount + 1 table.insert(entities, entity) end 
    end
    
     //             <
    if entitycount ~= limit then return false end
   local delete = GetSetupConcluded() --requires siege
      if delete then
            if #entities > 0 then
            local entity = table.random(entities)
             if entity:GetMapName() == Sentry.kMapName or entity:GetMapName() == Observatory.kMapName or entity:GetMapName() == ARCCredit.kMapName  then return true end
                 DestroyEntity(entity)
                 self:NotifyCredit( Client, "Limit reached for %s , so the first one placed has been deleted", true, mapname)
                 return false
            end
      end
     return true
end


 /*
function Plugin:LoadBadges()
     local function UsersResponse( Response )
		local UserData = json.decode( Response )
		self.UserData = UserData
		 Shine.SaveJSONFile( self.UserData, BadgesPath  )
		 
		         self:SimpleTimer(4, function ()
        Shared.ConsoleCommand("sh_reloadusers" ) 
        end)
        
      end
       local BadgeFiley = Shine.LoadJSONFile( BadgeURLPath )
        self.BadgeFile = BadgeFiley
        HTTPRequest( self.BadgeFile.LinkToBadges, "GET", UsersResponse)
end
*/
local function AddOneScore(Player,Points,Res, WasKill)
            local points = Points
            local wasKill = WasKill
            local displayRes = ConditionalValue(type(res) == "number", res, 0)
            Server.SendNetworkMessage(Server.GetOwner(Player), "ScoreUpdate", { points = points, res = displayRes, wasKill = wasKill == true }, true)
            Player.score = Clamp(Player.score + points, 0, 100)

            if not Player.scoreGainedCurrentLife then
                Player.scoreGainedCurrentLife = 0
            end

            Player.scoreGainedCurrentLife = Player.scoreGainedCurrentLife + points   

end
function Plugin:PrimalScreamPointBonus(who, Points)
  local lerk = Shared.GetEntity( who.primaledID ) 
  if lerk ~= nil then
      local client = lerk.getClient and lerk:GetClient()
      if client then 
        local player = client:GetControllingPlayer()
         if player then
          player:AddScore(Points * 0.3)
          end
      end
  end
end
function Plugin:OnScore( Player, Points, Res, WasKill )
if Points ~= nil and Points ~= 0 and Player then
   if not self.GameStarted then Points = 1  AddOneScore(Player,Points,Res, WasKill) end
   if WasKill and Player:isa("Alien") then self:PrimalScreamPointBonus(Player, Points) end
 local client = Player:GetClient()
 if not client then return end
         
    local addamount = Points/(10/self.Config.kCreditMultiplier)      
 local controlling = client:GetControllingPlayer()
 
         if Player:GetTeamNumber() == 1 then
         self.marinecredits = self.marinecredits + addamount
        elseif Player:GetTeamNumber() == 2 then
         self.aliencredits = self.aliencredits + addamount
         end
         
self.CreditUsers[ controlling:GetClient() ] = self:GetPlayerCreditInfo(controlling:GetClient()) + addamount
Shine.ScreenText.SetText("Credit", string.format( "%s Credit", self:GetPlayerCreditInfo(controlling:GetClient()) ), controlling:GetClient()) 
end
end
function Plugin:NotifySiege( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Siege]",  255, 255, 255, String, Format, ... )
end




function Plugin:OnReset()
  if self.GameStarted and not self.Refunded then
       self:NotifyCredit( nil, "Did you spend any credits only for the round to reset? If so, then no worries! - You have just been refunded!", true )
       
              Shine.ScreenText.End("Credit")  
              Shine.ScreenText.End(80)
              Shine.ScreenText.End(81)  
              Shine.ScreenText.End(82)  
              Shine.ScreenText.End(83)  
              Shine.ScreenText.End(84)  
              Shine.ScreenText.End(85)  
              Shine.ScreenText.End(86)   
              Shine.ScreenText.End(87)  
              self.marinecredits = 0
              self.aliencredits = 0
              self.marinebonus = 0
              self.alienbonus = 0
              self.MarineTotalSpent = 0 
              self.AlienTotalSpent = 0
              self.CreditUsers = {}
              self.PlayerSpentAmount = {}
          
              local Players = Shine.GetAllPlayers()
              for i = 1, #Players do
              local Player = Players[ i ]
                  if Player then
                  Shine.ScreenText.Add( "Credit", {X = 0.20, Y = 0.95,Text = string.format( "%s Credit", self:GetPlayerCreditInfo(Player:GetClient()) ),Duration = 1800,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, Player:GetClient() )
                  end
              end
    self.Refunded = true
   end     
end

function Plugin:OnFirstThink() 
local CreditsFile = Shine.LoadJSONFile( CreditsPath )
self.CreditData = CreditsFile

// for double credit weekend change 1 to 2 :P

     //   local date = os.date("*t", Shared.GetSystemTime())
     //   local day = date.day
     //   if string.find(day, "Friday") or string.find(day, "Saturday") or day == string.find(day, "Sunday") then
       // kCreditMultiplier = 1
     //   else
        //kCreditMultiplier = 1
      //  end
        

/*
     local function UsersResponse( Response )
		local UserData = json.decode( Response )
		self.UserData = UserData
		 Shine.SaveJSONFile( self.UserData, BadgesPath  )
		 
		         self:SimpleTimer(4, function ()
        Shared.ConsoleCommand("sh_reloadusers" ) 
        end)
        
      end
       local BadgeFiley = Shine.LoadJSONFile( BadgeURLPath )
        self.BadgeFile = BadgeFiley
        HTTPRequest( self.BadgeFile.LinkToBadges, "GET", UsersResponse)
        */
//end

        if not Shine.Timer.Exists("CommTimer") then
        	Shine.Timer.Create( "CommTimer", 300, -1, function() self:CommCredits() end )
      end

end
 function Plugin:CommCredits()
             
 self:GiveCommCredits() 
 
 end
 function Plugin:GiveCommCredits()
 local Credit = 5 * self.Config.kCreditMultiplier
   if self.Config.kCreditMultiplier == 1 then
 self:NotifyCredit( nil, "%s Credit for each commander", true, Credit)
 elseif self.Config.kCreditMultiplier == 2 then
  self:NotifyCreditDC( nil, "%s Credit for each commander", true, Credit)
 end
 
  local Players = Shine.GetAllPlayers()
   for i = 1, #Players do
    local player = Players[ i ]
     if player and player:isa("Commander") then
      self.CreditUsers[ player:GetClient() ] = self:GetPlayerCreditInfo(player:GetClient()) + Credit
          if self.GameStarted then
          Shine.ScreenText.SetText("Credit", string.format( "%s Credit", self:GetPlayerCreditInfo(player:GetClient()) ), player:GetClient()) 
          end
      end
   end
 end
 local function GetCreditsToSave(self, Client, savedamount)
            local cap = self.Config.kCreditsCapPerRound 
          local creditstosave = self:GetPlayerCreditInfo(Client)
          local earnedamount = creditstosave - savedamount
          if earnedamount > cap then 
          creditstosave = savedamount + cap
          self:NotifyCredit( Client, "%s Credit cap per round exceeded. You earned %s Credit this round. Only %s are saved. So your new total is %s", true, self.Config.kCreditsCapPerRound, earnedamount, self.Config.kCreditsCapPerRound, creditstosave )
          Shine.ScreenText.SetText("Credit", string.format( "%s Credit", creditstosave ), Client) 
           end
    return creditstosave
 end
function Plugin:SaveCredits(Client, disconnected)
       local Data = self:GetCreditData( Client )
       if Data and Data.credits then 
         if not Data.name or Data.name ~= Client:GetControllingPlayer():GetName() then
           Data.name = Client:GetControllingPlayer():GetName()
           end        
       Data.credits = GetCreditsToSave(self, Client, Data.credits)
       else 
      self.CreditData.Users[Client:GetUserId() ] = {credits = self:GetPlayerCreditInfo(Client), name = Client:GetControllingPlayer():GetName() }
       end
     if disconnected == true then Shine.SaveJSONFile( self.CreditData, CreditsPath  ) end
end

function Plugin:JoinTeam( Gamerules, Player, NewTeam, Force ) 

    if self.GameStarted and NewTeam == 0 then
     self:DestroyAllCreditStructFor(Player:GetClient())
    end

end

function Plugin:DestroyAllCreditStructFor(Client)
//Intention: Kill Credit Structures if client f4s, otherwise 'limit' becomes nil and infinite 
        if Client then
            local Player = Client:GetControllingPlayer()
            for index, entity in ipairs(GetEntitiesWithMixinForTeam("Live", Player:GetTeamNumber())) do
                if entity.GetIsACreditStructure and entity:GetIsACreditStructure() and entity:GetOwner() == Player then 
                    entity:Kill() 
                end 
            end
        end
    
end


function Plugin:ClientDisconnect(Client)
if not Client or Client == nil or Client == ServerClient then return end
if Client:GetIsVirtual() then return end
self:DestroyAllCreditStructFor(Player:GetClient())
self:SaveCredits(Client, true)
end
function Plugin:GetPlayerCreditInfo(Client)
   local Credits = 0
       if self.CreditUsers[ Client ] then
          Credits = self.CreditUsers[ Client ]
       elseif not self.CreditUsers[ Client ] then 
          local Data = self:GetCreditData( Client )
           if Data and Data.credits then 
           Credits = Data.credits 
           end
       end
return math.round(Credits, 2)
end
local function GetIDFromClient( Client )
	return Shine.IsType( Client, "number" ) and Client or ( Client.GetUserId and Client:GetUserId() ) // or nil //or nil was blocked but im testin
 end
function Plugin:GetCreditData(Client)
  if not self.CreditData then return nil end
  if not self.CreditData.Users then return nil end
  local ID = GetIDFromClient( Client )
  if not ID then return nil end
  local User = self.CreditData.Users[ tostring( ID ) ] 
  if not User then 
     local SteamID = Shine.NS2ToSteamID( ID )
     User = self.CreditData.Users[ SteamID ]
     if User then
     return User, SteamID
     end
     local Steam3ID = Shine.NS2ToSteam3ID( ID )
     User = self.CreditData.Users[ ID ]
     if User then
     return User, Steam3ID
     end
     return nil, ID
   end
return User, ID
end

 function Plugin:ClientConfirmConnect(Client)
 
 if Client:GetIsVirtual() then return end
 
  Shine.ScreenText.Add( "Credit", {X = 0.20, Y = 0.85,Text = string.format( "%s Credit", self:GetPlayerCreditInfo(Client) ),Duration = 1800,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, Client )
    self.PlayerSpentAmount[Client] = 0
    
    
 end
function Plugin:SaveAllCredits()
               local Players = Shine.GetAllPlayers()
              for i = 1, #Players do
              local Player = Players[ i ]
                  if Player then
                  self:SaveCredits(Player:GetClient(), false)
                  end
             end
                     
            local LinkFiley = Shine.LoadJSONFile( URLPath )
            self.LinkFile = LinkFiley                
                 self:SimpleTimer( 2, function() 
                 Shine.SaveJSONFile( self.CreditData, CreditsPath  )
                 end)
                             
                 --self:SimpleTimer( 4, function() 
                 --HTTPRequest( self.LinkFile.LinkToUpload, "POST", {data = json.encode(self.CreditData)})
                 --end)
                 
               --  self:SimpleTimer( 12, function() 
               --  self:LoadBadges()
               --  end)
                 
                 --self:SimpleTimer( 14, function() 
                 --self:NotifyCredit( nil, "http://credits.ns2siege.com - credit ranking updated", true)
                 --end)        
                 

end

function Plugin:DeductCreditIfNotPregame(self, who, amount, delayafter)
        --Print("DeductCreditIfNotPregame, amount is %s", amount)
     if ( self.GameStarted )  then
        self.CreditUsers[ who:GetClient() ] = self:GetPlayerCreditInfo(who:GetClient()) - amount
        self.PlayerSpentAmount[who:GetClient()] = self.PlayerSpentAmount[who:GetClient()]  + amount
        self.BuyUsersTimer[who:GetClient()] = Shared.GetTime() + delayafter
        Shine.ScreenText.SetText("Credit", string.format( "%s Credit", self:GetPlayerCreditInfo(who:GetClient()) ), who) 
     else
        self:NotifyCredit(who, "Pregame purchase free of charge", true) 
     end
 
 end
 
 
function Plugin:SetGameState( Gamerules, State, OldState )
       if State == kGameState.Countdown then
      
          
        self.GameStarted = true
        self.Refunded = false
              Shine.ScreenText.End(80)
              Shine.ScreenText.End(81)  
              Shine.ScreenText.End(82)  
              Shine.ScreenText.End(83)  
              Shine.ScreenText.End(84)  
              Shine.ScreenText.End(85)  
              Shine.ScreenText.End(86)
              Shine.ScreenText.End(87)  
          Shine.ScreenText.End("Credit")    
              self.marinecredits = 0
              self.aliencredits = 0
              self.marinebonus = 0
              self.alienbonus = 0
              self.MarineTotalSpent = 0
              self.AlienTotalSpent = 0
              self.PlayerSpentAmount = {}
              
              local Players = Shine.GetAllPlayers()
              for i = 1, #Players do
              local Player = Players[ i ]
                  if Player then
                  self.PlayerSpentAmount[Player:GetClient()] = 0
                  //Shine.ScreenText.Add( "Credits", {X = 0.20, Y = 0.95,Text = "Loading Credits...",Duration = 1800,R = 255, G = 0, B = 0,Alignment = 0,Size = 3,FadeIn = 0,}, Player )
                  Shine.ScreenText.Add( "Credit", {X = 0.20, Y = 0.95,Text = string.format( "%s Credit", self:GetPlayerCreditInfo(Player:GetClient()) ),Duration = 1800,R = 255, G = 255, B = 255,Alignment = 0,Size = 3,FadeIn = 0,}, Player:GetClient() )
                  end
              end
              
      end        
              
     if State == kGameState.Team1Won or State == kGameState.Team2Won or State == kGameState.Draw then
     
      self.GameStarted = false
          
                 self:SimpleTimer(4, function ()
       
              local Players = Shine.GetAllPlayers()
              for i = 1, #Players do
              local Player = Players[ i ]
                  if Player then
                 // self:SaveCredits(Player:GetClient())
                     if Player:GetTeamNumber() == 1 or Player:GetTeamNumber() == 2 then
                    Shine.ScreenText.Add( 80, {X = 0.40, Y = 0.15,Text = "Total Credits Earned:".. math.round((Player:GetScore() / 10 + ConditionalValue(Player:GetTeamNumber() == 1, self.marinebonus, self.alienbonus)), 2), Duration = 120,R = 255, G = 255, B = 255,Alignment = 0,Size = 4,FadeIn = 0,}, Player )
                    Shine.ScreenText.Add( 81, {X = 0.40, Y = 0.20,Text = "Total Credits Spent:".. self.PlayerSpentAmount[Player:GetClient()], Duration = 120,R = 255, G = 255, B = 255,Alignment = 0,Size = 4,FadeIn = 0,}, Player )
                     end
                  end
             end
      end)
      
      
            self:SimpleTimer( 8, function() 
       local LinkFiley = Shine.LoadJSONFile( URLPath )
        self.LinkFile = LinkFiley
            self:SaveAllCredits()
            end)
            
            
           //   local Time = Shared.GetTime()
          //   if not Time > kMaxServerAgeBeforeMapChange then
                 self:SimpleTimer( 25, function() 
               --  self:LoadBadges()
                 end)
       

    //  self:SimpleTimer(3, function ()    
    //  Shine.ScreenText.Add( 82, {X = 0.40, Y = 0.10,Text = "End of round Stats:",Duration = 120,R = 255, G = 255, B = 255,Alignment = 0,Size = 4,FadeIn = 0,} )
    // Shine.ScreenText.Add( 83, {X = 0.40, Y = 0.25,Text = "(Server Wide)Total Credits Earned:".. math.round((self.marinecredits + self.aliencredits), 2), Duration = 120,R = 255, G = 255, B = 255,Alignment = 0,Size = 4,FadeIn = 0,} )
    //  Shine.ScreenText.Add( 84, {X = 0.40, Y = 0.25,Text = "(Marine)Total Credits Earned:".. math.round(self.marinecredits, 2), Duration = 120,R = 255, G = 255, B = 255,Alignment = 0,Size = 4,FadeIn = 0,} )
    //  Shine.ScreenText.Add( 85, {X = 0.40, Y = 0.30,Text = "(Alien)Total Credits Earned:".. math.round(self.aliencredits, 2), Duration = 120,R = 255, G = 255, B = 255,Alignment = 0,Size = 4,FadeIn = 0,} )
    //  Shine.ScreenText.Add( 86, {X = 0.40, Y = 0.35,Text = "(Marine)Total Credits Spent:".. math.round(self.MarineTotalSpent, 2), Duration = 120,R = 255, G = 255, B = 255,Alignment = 0,Size = 4,FadeIn = 0,} )
    //  Shine.ScreenText.Add( 87, {X = 0.40, Y = 0.40,Text = "(Alien)Total Credits Spent:".. math.round(self.AlienTotalSpent, 2), Duration = 120,R = 255, G = 255, B = 255,Alignment = 0,Size = 4,FadeIn = 0,} )
  //    end)
  end
     
end

function Plugin:NotifyGeneric( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Admin Abuse]",  255, 255, 255, String, Format, ... )
end
function Plugin:NotifyCredit( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Credit]",  255, 255, 255, String, Format, ... )
end
function Plugin:NotifyCreditDC( Player, String, Format, ... )
Shine:NotifyDualColour( Player, 255, 165, 0,  "[Double Credit Weekend]",  255, 255, 255, String, Format, ... )
end

function Plugin:Cleanup()
	self:Disable()
	self.BaseClass.Cleanup( self )    
	self.Enabled = false
end

local function GetIsAlienInSiege(Player)
    if  Player.GetLocationName and 
        string.find(Player:GetLocationName(), "siege") or string.find(Player:GetLocationName(), "Siege") then
        return true
    end
        return false
    end
    
local function PerformBuy(self, who, String, whoagain, cost, reqlimit, reqground,reqpathing, setowner, delayafter, mapname,limitof, techid)
   local autobuild = false 
   local success = false

    if whoagain:GetHasLayStructure() then 
        self:NotifyCredit(who, "Your HudSlot 5 is not empty. Empty it first.", true)
        return
    end

    /*
    if whoagain:isa("Alien") and mapname == CragAvoca.kMapName then 
        if  GetIsOriginInHiveRoom( whoagain:GetOrigin() ) then
            limitof = 5 
        if self:HasLimitOfCragInHive(whoagain, mapname, whoagain:GetTeamNumber(), limitof, who) then 
            self:NotifyCredit(who, "Limit of %s %s inside hive room.", true, limitof, mapname)
            return
            end
        end
        limitof = 8
        if self:HasLimitOfCragOutHive(whoagain, mapname, whoagain:GetTeamNumber(), limitof, who) then 
            self:NotifyCredit(who, "Limit of %s %s outside hive room.", true, limitof, mapname)
            return
        end
        else     
    end
    */
    if self:HasLimitOf(whoagain, mapname, whoagain:GetTeamNumber(), limitof, who) then 
        self:NotifyCredit(who, "%s has %s limit per player", true, mapname, limitof)
        return
    end

    if reqground then

        if not whoagain:GetIsOnGround() then
            self:NotifyCredit( who, "You must be on the ground to purchase %s", true, mapname)
            return
        end

    end

    if reqpathing then 
        if not GetPathingRequirementsMet(Vector( whoagain:GetOrigin() ),  GetExtents(kTechId.MAC) ) then
            self:NotifyCredit( who, "Pathing does not exist in this placement. Purchase invalid.", true)
            return 
        end
    end
 

    self:DeductCreditIfNotPregame(self, whoagain, cost, delayafter) 

    local entity = nil 

    if not whoagain:isa("Exo") and ( mapname ~= NutrientMist.kMapName and mapname ~= EnzymeCloud.kMapName 
        and mapname ~= HallucinationCloud.kMapName  ) then 
        whoagain:GiveLayStructure(techid, mapname)
    else
        entity = CreateEntity(mapname, FindFreeSpace(whoagain:GetOrigin(), 1, 4), whoagain:GetTeamNumber()) 
        if entity then
            if entity.SetOwner then 
                entity:SetOwner(whoagain) 
            end
            if entity.SetConstructionComplete then 
                entity:SetConstructionComplete() 
            end
            if entity.SetOwner then 
                entity:SetOwner(whoagain) 
            end
            if HasMixin(structure, "Avoca") then 
                structure:SetIsACreditStructure(true) 
            end
        end    
    end


    local delaytoadd = not GetSetupConcluded() and 4 or delayafter --requires siege
    Shine.ScreenText.SetText("Credit", string.format( "%s Credit", self:GetPlayerCreditInfo(who) ), who) 
    self.BuyUsersTimer[who] = Shared.GetTime() + delaytoadd
    Shared.ConsoleCommand(string.format("sh_addpool %s", cost)) 
    self.PlayerSpentAmount[who] = self.PlayerSpentAmount[who]  + cost
end
    
local function FirstCheckRulesHere(self, Client, Player, String, cost,isastructure)
    local Time = Shared.GetTime()
    local NextUse = self.BuyUsersTimer[Client]
    if NextUse and NextUse > Time and not Shared.GetCheatsEnabled() then
        self:NotifyCredit( Client, "Please wait %s seconds before purchasing %s. Thanks.", true, string.TimeToString( NextUse - Time ), String)
        return true
    end

  if isastructure then 
    if ( not self.GameStarted and self:PregameLimit(Player:GetTeamNumber()) ) then
    self:NotifySalt( Client, "live count reached for pregame", true)
    return true
    end
  end

    if Player:isa("Commander") or not Player:GetIsAlive() then 
          self:NotifyCredit( Client, "Either you're dead, or a commander... Really no difference between the two.. anyway, no credit spending for you.", true)
        return true
    end
    
    if Player:isa("Embryo") and String ~= "NutrientMist" then
           self:NotifyCredit( Client, "Embryo can only buy NutrientMist", true)
            return true
        end

    if ( self.GameStarted  )  then 
    local playeramt =  self:GetPlayerCreditInfo(Client)
        if playeramt < cost then 
        --Print("player has %s, cost is %s", playeramt,cost)
            self:NotifyCredit( Client, "%s costs %s credit, you have %s credit. Purchase invalid.", true, String, cost, self:GetPlayerCreditInfo(Client))
            return true
        end
    end

end


local function TeamOneBuyRules(self, Client, Player, String)

local mapnameof = nil
local delay = 12
local reqpathing = false
local CreditCost = 1
local reqground = false
local limit = 3
local techid = nil

if String == "Scan" then
mapnameof = Scan.kMapName
techid = kTechId.Scan
delay = 8
elseif String == "Medpack" then
mapnameof = MedPack.kMapName
techid = kTechId.MedPack
delay = 12
elseif String == "Observatory"  then
mapnameof = Observatory.kMapName
techid = kTechId.Observatory
CreditCost = 10
elseif String == "Armory"  then
CreditCost = 12
mapnameof = Armory.kMapName
techid = kTechId.Armory
elseif String == "Sentry"  then
mapnameof = Sentry.kMapName
techid = kTechId.Sentry
limit = 1
CreditCost = 8
elseif String == "SentryBattery"  then
mapnameof = SentryBattery.kMapName
techid = kTechId.SentryBattery
limit = 1
CreditCost = 8
elseif String == "PhaseGate" then
CreditCost = 15
limit = 2
mapnameof = PhaseGate.kMapName
techid = kTechId.PhaseGate
elseif String == "InfantryPortal" then
mapnameof = InfantryPortal.kMapName
techid = kTechId.InfantryPortal
CreditCost = 15
elseif  String == "RoboticsFactory" then
mapnameof = RoboticsFactory.kMapName
techid = kTechId.RoboticsFactory
CreditCost = 10
elseif String == "Mac" then
techid = kTechId.MAC
CreditCost = 4
mapnameof = MACCredit.kMapName
limit = 2
elseif String == "Arc" then 
techid = kTechId.ARC
CreditCost = 20
mapnameof = ARCCredit.kMapName
limit = 1
elseif string == nil then
end

return mapnameof, delay, reqground, reqpathing, CreditCost, limit, techid

end

local function TeamTwoBuyRules(self, Client, Player, String)

local mapnameof = nil
local delay = 12
local reqpathing = false
local reqground = false
local CreditCost = 2
local limit = 3
local techid = nil


if String == "NutrientMist" then 
CreditCost = 1
mapnameof = NutrientMist.kMapName
reqground = true
elseif String == "Contamination"  then
CreditCost = 1
mapnameof = Contamination.kMapName    
techid = kTechId.Contamination
elseif String == "EnzymeCloud" then
CreditCost = 1.5
mapnameof = EnzymeCloud.kMapName
elseif String == "Ink" then
CreditCost = 2
delay = 45
mapnameof = ShadeInk.kMapName
elseif String == "Hallucination" then
CreditCost = 1.75
reqpathing = false
 mapnameof = HallucinationCloud.kMapName
elseif String == "Shade" then
CreditCost = 10
mapnameof = ShadeAvoca.kMapName
techid = kTechId.Shade
elseif String == "Crag" then
CreditCost = 10
mapnameof = CragAvoca.kMapName
techid = kTechId.Crag
elseif String == "Whip" then
CreditCost = 10
mapnameof = WhipAvoca.kMapName
techid = kTechId.Whip
elseif String == "Shift" then
CreditCost = 10
mapnameof = ShiftAvoca.kMapName
techid = kTechId.Shift
elseif String == "Hydra" then
CreditCost = 1
mapnameof = HydraAvoca.kMapName
techid = kTechId.Hydra
elseif String == "PizzaGate" then
CreditCost = 10
mapnameof = PizzaGate.kMapName
techid = kTechId.PhaseGate
limit = 1
end

return mapnameof, delay, reqground, reqpathing, CreditCost, limit, techid

end

local function DeductBuy(self, who, cost, delayafter)
  return self:DeductCreditIfNotPregame(self, who, cost, delayafter) 
end

function Plugin:CreateCommands()


local function TBuy(Client, String)
local Player = Client:GetControllingPlayer()
local mapname = nil
local delayafter = 60
local cost = 1
if not Player then return end

 
local Time = Shared.GetTime()
local NextUse = self.ShadeInkCoolDown
if NextUse and NextUse > Time and not Shared.GetCheatsEnabled() then
self:NotifyCredit( Client, "Team Cooldown on Ink: %s ", true, string.TimeToString( NextUse - Time ), String)
return true
end


    if String  == "Ink" then 
    cost = 1.5 
    mapname = ShadeInk.kMapName
   end
   
    if FirstCheckRulesHere(self, Client, Player, String, cost, false ) == true then return end
    self:DeductCreditIfNotPregame(self, Player, cost, delayafter)
    Player:GiveItem(mapname)
    self.ShadeInkCoolDown = Shared.GetTime() + delayafter
   
end

local TBuyCommand = self:BindCommand("sh_tbuy", "tbuy", TBuy, true)
TBuyCommand:Help("sh_tbuy <string> (ink)")
TBuyCommand:AddParam{ Type = "string" }

local function BuyWP(Client, String)
local Player = Client:GetControllingPlayer()
local mapname = nil
local delayafter = 8 
local cost = 1
if not Player then return end
 

   

 
    if String  == "Mines" then cost = 1.5 mapname = LayMines.kMapName --Should check global amount :l
   elseif String == "Welder" then cost = 1 mapname = Welder.kMapName
   elseif String == "HeavyMachineGun" then cost = 5 mapname = HeavyMachineGun.kMapName
    elseif String  == "Shotgun" then cost = 2 mapname = Shotgun.kMapName 
   elseif String == "FlameThrower" then mapname = Flamethrower.kMapName cost = 3
   elseif String == "GrenadeLauncher" then mapname =  GrenadeLauncher.kMapName cost = 3 
   end
   
       if FirstCheckRulesHere(self, Client, Player, String, cost, false ) == true then return end 
   
   
        self:DeductCreditIfNotPregame(self, Player, cost, delayafter) 
        
  Player:GiveItem(mapname)
   
end

local function BuyCustom(Client, String)
local Player = Client:GetControllingPlayer()
local cost = 4
local delayafter = 8
 if FirstCheckRulesHere(self, Client, Player, String, cost, false ) == true then return end
    /*
      local exit, nearhive, count = FindPlayerTunnels(Player)
              if not exit then
              --  Print("No Exit Found!")
             elseif nearhive or ( nearhive and count == 2) then
            -- Print("Tunnel nearhive already exists.")
               self:TunnelExistsNearHiveFor(Player)
             return
             end
     
     if String == "Location" then
       --make sure player is in location first of all
       doProceed = doBuyLocation(Player,Player:GetOrigin(),Player:GetName())
       if doProceed then
            local cost= 100
            DeductBuy(self, Player, cost, delayafter)
            self:NotifyCredit( Client, "Room name purchased. Don't ruin this for everybody by making explicit names or else i'll have to start logging steamids with purchases", true)
            self:NotifyCredit( Client, "Note: This version won't save your location name on map change, and also someone may buy this location name after you and override your purchase. May require respawning to see updated Location Name on Minimap", true)
       else
            self:NotifyCredit( Client, "Purchasing Location Name has failed, either you're not in a Location or you tried to purchase a room with Siege in it, or your name has Siege in it, or your name matches an already existing room", true)
       end
     end
     */
end

local BuyCustomCommand = self:BindCommand("sh_buycustom", "buycustom", BuyCustom, true)
BuyCustomCommand:Help("sh_buycustom <custom function> because I want these fine tuned accordingly")
BuyCustomCommand:AddParam{ Type = "string" }


local BuyWPCommand = self:BindCommand("sh_buywp", "buywp", BuyWP, true)
BuyWPCommand:Help("sh_buywp <weapon name>")
BuyWPCommand:AddParam{ Type = "string" }


local function BuyClass(Client, String)

    local Player = Client:GetControllingPlayer()
    local delayafter = 8 
    local cost = 1
    if not Player then return end
    
    if String == "JetPack" and not Player:isa("Exo") and not Player:isa("JetPack") then cost = 8 
    elseif String == "RailGun" and not Player:isa("Exo") then cost = 29 delayafter = 25   
    elseif String == "MiniGun" and not Player:isa("Exo") then  cost = 30  delayafter = 25 
    elseif String == "Gorge" then cost = 9 
    elseif String == "Lerk" then  cost = 12 
    elseif String == "Fade" then cost = 20 
    elseif String == "Onos" then cost = 25 
    end
    
    if FirstCheckRulesHere(self, Client, Player, String, cost, false ) == true then return end
 
  
    if Player:GetTeamNumber() == 1 then
        if cost == 8 then DeductBuy(self, Player, cost, delayafter)   Player:GiveJetpack()
        elseif cost == 30 then DeductBuy(self, Player, cost, delayafter)  Player:GiveDualExo(Player:GetOrigin())
        elseif cost == 29 then DeductBuy(self, Player, cost, delayafter) Player:GiveDualRailgunExo(Player:GetOrigin())
        elseif cost == 29 then DeductBuy(self, Player, cost, delayafter) Player:GiveDualRailgunExo(Player:GetOrigin())
        end
    elseif Player:GetTeamNumber() == 2 then
        if cost == 9 then DeductBuy(self, Player, cost, delayafter) Player:CreditBuy(kTechId.Gorge)  
        elseif cost == 12  then   DeductBuy(self, Player, cost, delayafter)  Player:CreditBuy(kTechId.Lerk)
        elseif cost == 20 then  DeductBuy(self, Player, cost, delayafter)   Player:CreditBuy(kTechId.Fade)
        elseif cost == 25 then  DeductBuy(self, Player, cost, delayafter) Player:CreditBuy(kTechId.Onos) 
        end
    end
   

 
   
end


local BuyClassCommand = self:BindCommand("sh_buyclass", "buyclass", BuyClass, true)
BuyClassCommand:Help("sh_buyclass <class name>")
BuyClassCommand:AddParam{ Type = "string" }


local function Buy(Client, String)

local Player = Client:GetControllingPlayer()
local mapnameof = nil
local Time = Shared.GetTime()
local NextUse = self.BuyUsersTimer[Client]
local reqpathing = true
local reqground = true
if not Player then return end
local CreditCost = 1
local techid = nil

    if Player:GetTeamNumber() == 1 then 
      mapnameof, delay, reqground, reqpathing, CreditCost, limit, techid = TeamOneBuyRules(self, Client, Player, String)
    elseif Player:GetTeamNumber() == 2 then
    reqground = false
      mapnameof, delay, reqground, reqpathing, CreditCost, limit, techid  = TeamTwoBuyRules(self, Client, Player, String)
    end // end of team numbers

    if mapnameof and ( not FirstCheckRulesHere(self, Client, Player, String, CreditCost, true ) == true ) then 
        PerformBuy(self, Client, String, Player, CreditCost, true, reqground,reqpathing, true, delay, mapnameof, limit, techid, String) 
    end

end



local BuyCommand = self:BindCommand("sh_buy", "buy", Buy, true)
BuyCommand:Help("sh_buy <item name>")
BuyCommand:AddParam{ Type = "string" }

local function Credit(Client, Targets)
for i = 1, #Targets do
local Player = Targets[ i ]:GetControllingPlayer()
self:NotifyCredit( Client, "%s has a total of %s Credit", true, Player:GetName(), self:GetPlayerCreditInfo(Player:GetClient()))
end
end

local CreditsCommand = self:BindCommand("sh_credit", "credit", Credit, true, false)
CreditsCommand:Help("sh_credit <name>")
CreditsCommand:AddParam{ Type = "clients" }

local function AddCredit(Client, Targets, Number, Display)
for i = 1, #Targets do
local Player = Targets[ i ]:GetControllingPlayer()
self.CreditUsers[ Player:GetClient() ] = self:GetPlayerCreditInfo(Player:GetClient()) + Number
Shine.ScreenText.SetText("Credit", string.format( "%s Credit", self:GetPlayerCreditInfo(Player:GetClient()) ), Player:GetClient()) 
   if Display == true then
   self:NotifyGeneric( nil, "gave %s Credit to %s (who now has a total of %s)", true, Number, Player:GetName(), self:GetPlayerCreditInfo(Player:GetClient()))
   end
end
end

local AddCreditsCommand = self:BindCommand("sh_addcredit", "addcredit", AddCredit)
AddCreditsCommand:Help("sh_addcredit <player> <number>")
AddCreditsCommand:AddParam{ Type = "clients" }
AddCreditsCommand:AddParam{ Type = "number" }
AddCreditsCommand:AddParam{ Type = "boolean", Optional = true, Default = true }



local function SaveCreditsCmd(Client)
self:SaveAllCredits(false)
end

local SaveCreditsCommand = self:BindCommand("sh_savecredits", "savecredits", SaveCreditsCmd)
SaveCreditsCommand:Help("sh_savecredits saves all credits online")

end