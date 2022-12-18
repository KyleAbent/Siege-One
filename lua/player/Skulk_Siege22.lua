

local origSpeed = Skulk.GetMaxSpeed
function Skulk:GetMaxSpeed(possible)
    local returnValue = origSpeed(self,possible)
    local defaultValue = returnValue
    returnValue = returnValue * (17/100) + returnValue
    return returnValue
end


--override... 
--UWE allows us to mod but prevents modding local variables without easy replacements :/ 

-- ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =====

local kLeapVerticalForce = 13.12 --10.8
local kLeapTime = 0.5 --0.2
local kLeapForce = 9 --7.6


--Ugh i have to bring these over too
local kNormalWallWalkFeelerSize = 0.25
local kNormalWallWalkRange = 0.3

function Skulk:OnLeap()

    local velocity = self:GetVelocity() * 0.5
    local forwardVec = self:GetViewAngles():GetCoords().zAxis
    local newVelocity = velocity + GetNormalizedVectorXZ(forwardVec) * kLeapForce
    
    -- Add in vertical component.
    newVelocity.y = kLeapVerticalForce * forwardVec.y + kLeapVerticalForce * 0.5 + ConditionalValue(velocity.y < 0, velocity.y, 0)
    
    self:SetVelocity(newVelocity)
    
    self.leaping = true
    self.wallWalking = false
    self.jumping = true
    self:DisableGroundMove(0.2)
    
    self.timeOfLeap = Shared.GetTime()
    
end


-- Update wall-walking from current origin
function Skulk:PreUpdateMove(input, runningPrediction)

    PROFILE("Skulk:PreUpdateMove")
    --[[
    local dashDesired = bit.band(input.commands, Move.MovementModifier) ~= 0 and self:GetVelocity():GetLength() > 4
    if not self.dashing and dashDesired and self:GetEnergy() > 15 then
        self.dashing = true    
    elseif self.dashing and not dashDesired then
        self.dashing = false
    end
    
    if self.dashing then    
        self:DeductAbilityEnergy(input.time * 30)    
    end
    
    if self:GetEnergy() == 0 then
        self.dashing = false
    end
    --]]
    if self:GetCrouching() then
        self.wallWalking = false
    end

    if self.wallWalking then

        -- Most of the time, it returns a fraction of 0, which means
        -- trace started outside the world (and no normal is returned)
        local goal = self:GetAverageWallWalkingNormal(kNormalWallWalkRange, kNormalWallWalkFeelerSize, PhysicsMask.AllButPCsAndWebs)
        if goal ~= nil then
        
            self.wallWalkingNormalGoal = goal
            self.wallWalking = true

        else
            self.wallWalking = false
        end
    
    end
    
    if not self:GetIsWallWalking() then
        -- When not wall walking, the goal is always directly up (running on ground).
        self.wallWalkingNormalGoal = Vector.yAxis
    end

    if self.leaping and Shared.GetTime() > self.timeOfLeap + kLeapTime then
        self.leaping = false
    end
        
    self.currentWallWalkingAngles = self:GetAnglesFromWallNormal(self.wallWalkingNormalGoal or Vector.yAxis) or self.currentWallWalkingAngles

    -- adjust the sneakOffset so sneaking skulks can look around corners without having to expose themselves too much
    local delta = input.time * math.min(1, self:GetVelocityLength())
    if self.movementModiferState then
        if self.sneakOffset < Skulk.kMaxSneakOffset then
            self.sneakOffset = math.min(Skulk.kMaxSneakOffset, self.sneakOffset + delta)
        end
    else
        if self.sneakOffset > 0 then
            self.sneakOffset = math.max(0, self.sneakOffset - delta)
        end
    end
    
end