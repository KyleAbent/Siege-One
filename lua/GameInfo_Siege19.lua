local networkVars =
{
    frontTimer = "integer",
    sideTimer = "integer",
    dynamicAdjustment = "integer",
    countofpowerwhensetup = "integer",
    countofpowercurrently = "integer",
}

local ogCreate = GameInfo.OnCreate

function GameInfo:OnCreate()
    ogCreate(self)
    self.frontTimer = kFrontTime
    self.sideTimer = kSideTime
    self.countofpowercurrently = 0 //1//marine base
    self.countofpowerwhensetup = 0
    self.dynamicAdjustment = 0
end


function GameInfo:AddActivePower()
    local timer = GetTimer()
    if not timer:GetIsFrontOpen(self)  then 
        self.countofpowerwhensetup = self.countofpowerwhensetup + 1
        self.countofpowercurrently = self.countofpowercurrently + 1
    elseif timer:GetIsFrontOpen(self) and not timer:GetIsSiegeOpen(self) then
        self.countofpowercurrently = self.countofpowercurrently + 1
    end
end

function GameInfo:DeductActivePower()
    local timer = GetTimer()
    if timer:GetIsFrontOpen(self) and not timer:GetIsSiegeOpen(self) then
        self.countofpowercurrently = self.countofpowercurrently - 1
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