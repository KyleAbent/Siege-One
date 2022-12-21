---Overriding settings, having to bring in functions due to locality . Replacing :/ Code. by UWE.. 
JetpackMarine.kJetpackFuelReplenishDelay = kJetpackFuelReplenishDelayGlobal 
JetpackMarine.kJetpackGravity = kJetpackGravityGlobal 
JetpackMarine.kJetpackTakeOffTime = kJetpackTakeOffTimeGlobal 

local kFlySpeed = kJetpackFlySpeed --45 --9
local kFlyFriction = 0.0 --0.0
local kFlyAcceleration = kJetpackFlyAcceleration 


function JetpackMarine:GetAirFriction()
    return kFlyFriction    
end



--I did not wish to override by copy pasta uwe cdt ns2 lua
function JetpackMarine:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsJetpacking() then
        
        local verticalAccel = kJetpackverticalAccel
        
        if self:GetIsWebbed() then
            verticalAccel = kJetpackverticalAccelWebbed
        elseif input.move:GetLength() == 0 then
            verticalAccel = kJetpackverticalAccelYOnly
        end
    
        self.onGround = false
        local thrust = math.max(0, -velocity.y) / 6
        velocity.y = math.min(5, velocity.y + verticalAccel * deltaTime * (1 + thrust * 2.5))
 
    end
    
    if not self.onGround then
    
        -- do XZ acceleration
        local prevXZSpeed = velocity:GetLengthXZ()
        local maxSpeedTable = { maxSpeed = math.max(kFlySpeed, prevXZSpeed) }
        self:ModifyMaxSpeed(maxSpeedTable)
        local maxSpeed = maxSpeedTable.maxSpeed        
        
        if not self:GetIsJetpacking() then
            maxSpeed = prevXZSpeed
        end
        
        local wishDir = self:GetViewCoords():TransformVector(input.move)
        local acceleration = 0
        wishDir.y = 0
        wishDir:Normalize()
        
        acceleration = kFlyAcceleration
        
        velocity:Add(wishDir * acceleration * self:GetInventorySpeedScalar() * deltaTime)

        if velocity:GetLengthXZ() > maxSpeed then
        
            local yVel = velocity.y
            velocity.y = 0
            velocity:Normalize()
            velocity:Scale(maxSpeed)
            velocity.y = yVel
            
        end 
        
        if self:GetIsJetpacking() then
            velocity:Add(wishDir * kJetpackingAccel * deltaTime)
        end
    
    end

end


function JetpackMarine:UpdateJetpackMode()

    local newMode = JetpackMarine.kJetpackMode.Disabled

    if self:GetIsJetpacking() then
    
        if ((Shared.GetTime() - self.timeJetpackingChanged) < JetpackMarine.kJetpackTakeOffTime) and (( Shared.GetTime() - self.timeJetpackingChanged > 1.5 ) or self:GetIsOnGround() ) then

            newMode = JetpackMarine.kJetpackMode.TakeOff

        else

            newMode = JetpackMarine.kJetpackMode.Flying

        end
    end

    if newMode ~= self.jetpackMode then
        self.jetpackMode = newMode
    end

end

function JetpackMarine:GetJetPackMode()

    return self.jetpackMode

end

function JetpackMarine:ModifyJump(input, velocity, jumpVelocity)

    jumpVelocity.y = jumpVelocity.y * 0.8

    Marine.ModifyJump(self, input, velocity, jumpVelocity)

end

function JetpackMarine:FallingAfterJetpacking()
    return (self.timeJetpackingChanged + 1.5 > Shared.GetTime()) and not self:GetIsOnGround()
end
