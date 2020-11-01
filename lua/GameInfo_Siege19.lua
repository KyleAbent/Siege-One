local networkVars =
{
    frontTimer = "integer",
    sideTimer = "integer",
    dynamicAdjustment = "integer",
  
    
}

local ogCreate = GameInfo.OnCreate

function GameInfo:OnCreate()
    ogCreate(self)
    self.frontTimer = kFrontTime
    self.sideTimer = kSideTime
    self.activePower = GetActivePowerCount()
    self.setupPowerCount = 0
    self.dynamicAdjustment = 0
end


function GameInfo:AddActivePower()
    local timer = GetTimer()
    if timer:GetIsFrontOpen(self) and not timer:GetIsSiegeOpen(self) then
       local newAdjustment = math.random(10,30)
       self.dynamicAdjustment = (newAdjustment) + (self.dynamicAdjustment)
       timer:AdjustSiegeTimer(newAdjustment) 
    end
end

function GameInfo:DeductActivePower()
    local timer = GetTimer()
    if timer:GetIsFrontOpen(self) and not timer:GetIsSiegeOpen(self) then
        local newAdjustment = math.random(10,30) * -1
        self.dynamicAdjustment = (newAdjustment) + (self.dynamicAdjustment)
        timer:AdjustSiegeTimer(newAdjustment)
    end
end

function GameInfo:GetFrontTime()
   return self.frontTimer
end

function GameInfo:ToggleOptimism(bool)
    self.dynamicflag = bool
end

function GameInfo:GetDynamicSiegeTimerAdjustment()
    return self.dynamicAdjustment
end

function GameInfo:SetFrontTime(time)
    self.frontTimer = time
end

function GameInfo:GetSideTime()
   return self.sideTimer
end

function GameInfo:SetSideTime(time)
    self.sideTimer = time
end


Shared.LinkClassToMap("GameInfo", GameInfo.kMapName, networkVars, true)