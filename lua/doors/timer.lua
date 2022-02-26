class 'Timer' (ScriptActor)
Timer.kMapName = "timer"

if Server then
    Timer.kSiegeDoorSound = PrecacheAsset("sound/siegeroom.fev/door/siege")
    Timer.kFrontDoorSound = PrecacheAsset("sound/siegeroom.fev/door/frontdoor")
end

local networkVars = 
{
   SiegeTimer = "integer",
   FrontTimer = "integer",
   frontOpened = "boolean",
   siegeOpened = "boolean",
   siegeBeaconed = "boolean",
   SideTimer = "integer",
   sideOpened = "boolean",
   initialSiegeLength = "integer",
}

function Timer:TimerValues()
   self.SiegeTimer = kSiegeTime 
   self.FrontTimer = kFrontTime
   self.initialSiegeLength = self.SiegeTimer
   self.sideOpened = kSideTime
   self.sideOpened = false
   self.siegeOpened = false
   self.frontOpened = false
   self.siegeBeaconed = false
end
function Timer:GetInitialSiegeLength() 
    return self.initialSiegeLength
end
function Timer:OnReset() 
   self:TimerValues()
end

function Timer:GetIsMapEntity()
    return true
end

function Timer:GetHasSiegeBeaconed()
    return self.siegeBeaconed
end

function Timer:SetSiegeBeaconed(boolean)
 self.siegeBeaconed = boolean
end

function Timer:ClearAttached()
    return 
end

function Timer:OnCreate()
  self:TimerValues()
  self:SetUpdates(true)
end

local function DoubleCheckLocks(who)
   for index, door in ientitylist(Shared.GetEntitiesWithClassname("SiegeDoor")) do
     door:CloseLock()
  end 
end

function Timer:OnRoundStart() 
  self:TimerValues()
  DoubleCheckLocks(self)
  GetGamerules():SetDamageMultiplier(0)
end

function Timer:GetSiegeOpenBoolean()
 if not GetGameStarted() then
    return true
 else
    return self.siegeOpened
 end 
end
function Timer:GetFrontOpenBoolean()
 if not GetGameStarted() then
    return true
 else
    return self.frontOpened
 end
end
function Timer:GetFrontLength()
 return self.FrontTimer 
end
function Timer:GetSiegeLength()
 return self.SiegeTimer 
end
local function OpenEightTimes(who)
    if not who then return end
   // for i = 1, math.max(9 / 2, 16) do
        //who:Open()
        who.opening = true
        //who.isvisible = false
    //end
end

function Timer:OpenFrontDoors()
    self.FrontTimer = 0
    self.frontOpened = true
    GetGamerules():SetDamageMultiplier(1) 
    CloseAllBreakableDoors()

    for index, frontdoor in ientitylist(Shared.GetEntitiesWithClassname("FrontDoor")) do
        OpenEightTimes(frontdoor)
    end 
    
    if GetGameStarted() then 
        GetGamerules():DisplayFront()
        for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
            StartSoundEffectForPlayer(Timer.kFrontDoorSound, player)
        end
    end  
        
end
function Timer:OpenSiegeDoors()
     self.SiegeTimer = 0
     self.siegeOpened = true
       for index, siegedoor in ientitylist(Shared.GetEntitiesWithClassname("SiegeDoor")) do
            if not siegedoor:isa("FrontDoor") and not siegedoor:isa("SideDoor") then 
            OpenEightTimes(siegedoor) 
            end
       end
      if GetGameStarted() then
            for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
            StartSoundEffectForPlayer(Timer.kSiegeDoorSound, player)
           end
      end   
end
function Timer:OpenSideDoors()
     self.SideTimer = 0
     self.sideOpened = true
       for index, sidedoor in ientitylist(Shared.GetEntitiesWithClassname("SideDoor")) do
            OpenEightTimes(sidedoor) 
       end
       if GetGameStarted() then 
        GetGamerules():DisplaySide()
        end
end

function Timer:AdjustFrontTimer(time)
        Print("Old front timer is %s", self.FrontTimer)
        self.FrontTimer = self.FrontTimer + (time)
        Print("New front timer is %s", self.FrontTimer)
end
function Timer:AdjustSiegeTimer(time)
        Print("Old siege timer is %s", self.SiegeTimer)
        self.SiegeTimer = self.SiegeTimer + (time)
        Print("New Siege timer is %s", self.SiegeTimer)
end
function Timer:GetIsSiegeOpen(gameinfo)
            if not gameinfo then
                 gameinfo = GetGameInfoEntity()
            end
           local gamestarttime = gameinfo:GetStartTime()
           local gameLength = Shared.GetTime() - gamestarttime
           return  gameLength >= self.SiegeTimer
end

function Timer:GetIsFrontOpen(gameinfo)
            if not gameinfo then
                 gameinfo = GetGameInfoEntity()
            end
           local gamestarttime = gameinfo:GetStartTime()
           local gameLength = Shared.GetTime() - gamestarttime
           return  gameLength >= self.FrontTimer
end
function Timer:GetIsSideOpen(gameinfo)
            if not gameinfo then
                 gameinfo = GetGameInfoEntity()
            end
           local gamestarttime = gameinfo:GetStartTime()
           local gameLength = Shared.GetTime() - gamestarttime
           return  gameLength >= self.SideTimer
end
if Server then
    
     function Timer:OnUpdate(deltatime)
          local gamestarted = GetGamerules():GetGameStarted()
          if gamestarted then 
               if not self.timelasttimerup or self.timelasttimerup + 1 <= Shared.GetTime() then
                    local gameinfo = GetGameInfoEntity()
                    if not self.frontOpened then self:FrontDoorTimer(gameinfo) end
                    if not self.siegeOpened then self:SiegeDoorTimer(gameinfo) end   
                    if not self.sideOpened then self:SideDoorTimer(gameinfo) end  
                    self.timelasttimerup = Shared.GetTime()  
                    if self.frontOpened  and not self.siegeOpened then
                        if not self.timeLastTimeCheck or self.timeLastTimeCheck + math.random(30,45) <= Shared.GetTime() then
                         --   self:TimeCheck()
                            self.timeLastTimeCheck = Shared.GetTime()
                         end
                    end
                end
          end
     end
end

function Timer:SiegeDoorTimer(gameinfo)
       if  self:GetIsSiegeOpen(gameinfo) then
           self:OpenSiegeDoors()
       end
end

function Timer:FrontDoorTimer(gameinfo)

    if self:GetIsFrontOpen(gameinfo) then
       self:OpenFrontDoors()
     end
end
function Timer:SideDoorTimer(gameinfo)
    if self:GetIsSideOpen(gameinfo) then
       self:OpenSideDoors()
     end
end
function Timer:OnPreGame()
   for i = 1, 4 do
     Print("Timer OnPreGame")
   end
   
   for i = 1, 8 do
   self:OpenSiegeDoors()
   self:OpenFrontDoors()
   end
   
end

Shared.LinkClassToMap("Timer", Timer.kMapName, networkVars)