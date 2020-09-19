local networkVars =
{
    frontTimer = "integer",
    sideTimer = "integer",
    --Siege is determined by timer as it will fluctuate
    activePower = "integer",
    setupPowerCount = "integer",
}

local ogCreate = GameInfo.OnCreate

function GameInfo:OnCreate()
    ogCreate(self)
    self.frontTimer = kFrontTime
    self.sideTimer = kSideTime
    self.activePower = GetActivePowerCount()
    self.setupPowerCount = 0
end

function GameInfo:GetSetupPowerCount()
  return self.setupPowerCount
end

function GameInfo:SetSetupPowerCount()
   self.setupPowerCount = GetActivePowerCount()
end

function GameInfo:AddActivePower()
   self.activePower = self.activePower + 1
    local timer = GetTimer()
    if not timer:GetIsSiegeOpen(self) then
        timer:AdjustSiegeTimer(self:GetDynamicSiegeTimerAdjustment(self.setupPowerCount == self.activePower, false) )
        
    end
end

function GameInfo:DeductActivePower()
   self.activePower = self.activePower - 1
    local timer = GetTimer()
    if not timer:GetIsSiegeOpen(self) then
        timer:AdjustSiegeTimer(self:GetDynamicSiegeTimerAdjustment(self.setupPowerCount == self.activePower, true))--it will still say 
        --if at 3 power then get 3 more , 100% bonus, then get another so at total 7
        --then destroy 7, this deducts. shouldnt. because it would be at 6. would be 100% lol
        
    end
end

function GameInfo:GetFrontTime()
   return self.frontTimer
end

function GameInfo:GetDynamicSiegeTimerAdjustment(force, negate)--Interesting how this is called by powerpoint toggle as well as client gui ;). Power of vars!

    --So once front door opens, the setup time count will be set to the amount of active power at time of opening
    --Then the current amount of active power will add and deduct count manually when each powerpoint is killed or constrct
    --So the idea is to compare the current count after front door open, with the count of when front door opened. 
    --Deduct or add time based on that.
    
    local whenSetupOpened = self.setupPowerCount
    if whenSetupOpened == 0 then return 0 end
    --Print("Had %s power when setup opened", whenSetupOpened)
    --Print("Current power is %s", self.activePower)
    local deduction = 0
    
    if whenSetupOpened > self.activePower then --should solve the problem by introduction of division by 0
        --Print("Marine lost power")
                        --Off by one don't count main power here.               --nor here
                        
        local mathOne = Clamp( ( self.activePower - 1 ) - whenSetupOpened, -20, 20) --Clamp( ( self.activePower - 1 ) - whenSetupOpened, ( whenSetupOpened * - 1 )  + 1, self.activePower - 1) -- negative to a postive
        if negate then 
            mathOne = mathOne * -1 
        end
        local mathTwo = mathOne/whenSetupOpened
        --Print("Lost %s Percent of power", mathTwo * 10)
        local kMaxDeduction = 120
        deduction = kMaxDeduction * mathTwo
        deduction = deduction * - 1 --negative
        --Print("[Siege Dynamic Result] %s percent of %s is %s", mathTwo, kMaxDeduction, deduction)
        --Shouldn't the loss be off by one? assuming marines have one power, their main base. 
        --maybe if count is one then pretend it's 100% anyway, deducting full 120 seconds. 
    elseif force then -- when forcing the draw, adding or subtracting to get back in the even
        --only call an even deduction on draw once when triggered
        local timer = GetTimer()
        local sLength = timer:GetSiegeLength()
        if sLength ~= kSiegeTime then
            if sLength > kSiegeTime then
                deduction = sLength - kSiegeTime
                deduction = deduction * -1
            else
                deduction = kSiegeTime - sLength
            end
        end
       -- deduction = --add back what was lost or remove what was added lol
        
    else--Yes basically the same but I wanted to think this through ;)
        --Print("Marine Gained power")
        local mathOne = self.activePower - whenSetupOpened
        local mathTwo = mathOne/whenSetupOpened
        --Print("Gained %s Percent of power", mathTwo * 10)
        local kMaxAddition = 120
        deduction = kMaxAddition * mathTwo
        --Print("[Siege Dynamic Result] %s percent of %s is %s", mathTwo, kMaxAddition, deduction)
        
        if negate then
            deduction = deduction * -1
            --Print("Marine Gained power")
            --Print("Gained %s Percent of power", mathTwo * 10)
            --Print("[Siege Dynamic Result] %s percent of %s is %s", mathTwo, kMaxAddition, deduction)
        end
        
        
    end
    
   return deduction
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

if Server then

    --on reset
    local orig = GameInfo.SetState
    function GameInfo:SetState(state)
        orig(self, state)
        self.activePower = GetActivePowerCount()
        self.setupPowerCount = 0
    end

end

Shared.LinkClassToMap("GameInfo", GameInfo.kMapName, networkVars, true)