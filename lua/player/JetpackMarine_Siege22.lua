---Overriding settings, having to bring in functions due to locality . Replacing :/ Code. by UWE.. 


-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\JetpackMarine.lua
--
--    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at
--
--    Thanks to twiliteblue for initial input.
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================


JetpackMarine.kJetpackFuelReplenishDelay = .5 --.4
JetpackMarine.kJetpackGravity = 12 ---16
JetpackMarine.kJetpackTakeOffTime = .31 --.39

local kFlySpeed = 12 --9

function JetpackMarine:GetAirFriction()
    return kFlyFriction    
end


local kFlyFriction = 0.0 --0.0
local kFlyAcceleration = 42 --28


function JetpackMarine:UpdateJetpack(input)
    
    local jumpPressed = (bit.band(input.commands, Move.Jump) ~= 0)
    
    local enoughTimePassed = not self:GetIsOnGround() and self:GetTimeGroundTouched() + 0.3 <= Shared.GetTime() or false

    self:UpdateJetpackMode()
    
    -- handle jetpack start, ensure minimum wait time to deal with sound errors
    if not self.jetpacking and (Shared.GetTime() - self.timeJetpackingChanged > 0.2) and jumpPressed and self:GetFuel() > 0 then
    
        self:HandleJetpackStart()
        
        if Server and self.jetpackLoop then
            self.jetpackLoop:Start()
        end
        
        if Server and self.fuelWarning then
            self.fuelWarning:Start()
        end

    end
    
    -- handle jetpack stop, ensure minimum flight time to deal with sound errors
    if self.jetpacking and (Shared.GetTime() - self.timeJetpackingChanged) > 0.2 and (self:GetFuel()== 0 or not jumpPressed) then
        self:HandleJetPackEnd()
    end
    
    if Client then
    
        local fuel = self:GetFuel()
        if self:GetIsWebbed() then
            fuel = 0
        end

        local jetpackloop = Shared.GetEntity(self.jetpackLoopId)
        if jetpackloop then            
            jetpackloop:SetParameter("fuel", fuel, 1)
        end
        
        local fuelWarning = Shared.GetEntity(self.fuelWarningId)
        if fuelWarning then            
            fuelWarning:SetParameter("fuel", fuel, 1)
        end
        
    end

end

-- required to not stick to the ground during jetpacking
function JetpackMarine:ComputeForwardVelocity(input)

    -- Call the original function to get the base forward velocity.
    local forwardVelocity = Marine.ComputeForwardVelocity(self, input)
    
    if self:GetIsJetpacking() then
        forwardVelocity = forwardVelocity + Vector(0, 2, 0) * input.time
    end
    
    return forwardVelocity
    
end


function JetpackMarine:ModifyGravityForce(gravityTable)

    if self:GetIsJetpacking() or self:FallingAfterJetpacking() then
        gravityTable.gravity = JetpackMarine.kJetpackGravity
    end
    
    Marine.ModifyGravityForce(self, gravityTable)
    
end

function JetpackMarine:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsJetpacking() then
        
        local verticalAccel = 22
        
        if self:GetIsWebbed() then
            verticalAccel = 5
        elseif input.move:GetLength() == 0 then
            verticalAccel = 26
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
