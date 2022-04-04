//Enforce short birst blink
local orig BlinkProc = Blink.ProcessMoveOnWeapon
function Blink:ProcessMoveOnWeapon(player, input)
    BlinkProc(self,player,input)
    if self:GetIsActive() and player.ethereal then
        if Shared.GetTime() > (self.timeBlinkStarted + 0.65) then
           self:SetEthereal(player, false) 
        end
    end
end

---------------unfortunately the only way to mod this content is to copy it all and override with adjustments
--there is no easy way to pull only information i wanted y



local function TriggerBlinkOutEffects(self, player)

    -- Play particle effect at vanishing position.
    if not Shared.GetIsRunningPrediction() then
    
        player:TriggerEffects("blink_out", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})
        
        if Client and player:GetIsLocalPlayer() and not player:GetIsThirdPerson() then
            player:TriggerEffects("blink_out_local", { effecthostcoords = Coords.GetTranslation(player:GetOrigin()) })
        end
        
    end
    
end

local function TriggerBlinkInEffects(self, player)

    if not Shared.GetIsRunningPrediction() then
        player:TriggerEffects("blink_in", { effecthostcoords = Coords.GetTranslation(player:GetOrigin()) })
    end
    
end


-- initial force added when starting blink.
kEtherealForce = 24 --16.25

-- Additional force for initial blink speed with celerity
kEtherealCelerityForcePerSpur = 0.4 --0.2

-- Additianal force for blink stacking speed with celerity
kBlinkAddCelerityForcePerSpur = 0.09--0.05

-- Speed of first blink
kFirstBlinkSpeed = 24--15.5

-- Speed after subsequent blinks
kBlinkAddForce = 4--2.5

-- Minimum speed gained from blink
kBlinkMinSpeed = 24--16

-- Force of first blink before blink stack
kEtherealForce = kFirstBlinkSpeed - kBlinkAddForce
kEtherealForceMin = kBlinkMinSpeed - kBlinkAddForce

-- Boost added when player blinks again in the same direction. The added benefit exact.
local kEtherealBoost = 0.833
local kEtherealVerticalForce = 8 --2

function Blink:SetEthereal(player, state)

    -- Enter or leave ethereal mode.
    if player.ethereal ~= state then
    
        if state then

            player.etherealStartTime = Shared.GetTime()
            TriggerBlinkOutEffects(self, player)
            player:TriggerMetab()

            local playerForwardAxis = player:GetViewCoords().zAxis

            local celerityLevel = GetHasCelerityUpgrade(player) and player:GetSpurLevel() or 0
            local currentVelocityVector = player:GetVelocity()
            -- Since we're applying this vector to the new one, we should zero out y otherwise we'll start floating from jumps and things
            currentVelocityVector.y = 0
            local forwardVelocity = currentVelocityVector:DotProduct(playerForwardAxis)

            local blinkSpeed = kEtherealForce + celerityLevel * kEtherealCelerityForcePerSpur
            local minBlinkSpeed = kEtherealForceMin + celerityLevel * kEtherealCelerityForcePerSpur
            -- taperedVelocity is tracked so that if we're for some reason going faster than blink speed, we use that instead of
            -- slowing the player down. This allows for a skilled build up of extra speed.
            local taperedVelocity = math.max(forwardVelocity, blinkSpeed)

            local newVelocityVector = playerForwardAxis * blinkSpeed + currentVelocityVector

            -- Ensure we don't go under our minimum blink speed (this can happen when blinking against our velocity vector)
            if newVelocityVector:GetLength() < minBlinkSpeed then
                newVelocityVector = playerForwardAxis * minBlinkSpeed
            end

            -- Ensure we don't exceed our target blink speed
            if newVelocityVector:GetLength() > taperedVelocity then
                newVelocityVector:Normalize()
                newVelocityVector:Scale(taperedVelocity)
            end

            --Apply a minimum y directional speed of kEtherealVerticalForce if on the ground.
            if player:GetIsOnGround() then
                newVelocityVector.y = math.max(newVelocityVector.y, kEtherealVerticalForce)
            end

            -- There is no need to check for a max speed here, since the logic in the active blink code will keep it
            -- from exceeding the limit.
            newVelocityVector:Add(playerForwardAxis * kBlinkAddForce * (1 + celerityLevel * kBlinkAddCelerityForcePerSpur))

            player:SetVelocity(newVelocityVector)
            player.onGround = false
            player.jumping = true
            player:TriggerMetab()
            
        else
        
            TriggerBlinkInEffects(self, player)
            player.etherealEndTime = Shared.GetTime()
            player:TriggerMetab()
            
        end

        player.ethereal = state

        -- Give player initial velocity in direction we're pressing, or forward if not pressing anything.
        if player.ethereal then
        
            -- Deduct blink start energy amount.
            player:DeductAbilityEnergy(kStartBlinkEnergyCost)
            player:TriggerBlink()
            player:TriggerMetab()
            
        -- A case where OnBlinkEnd() does not exist is when a Fade becomes Commanders and
        -- then a new ability becomes available through research which calls AddWeapon()
        -- which calls OnHolster() which calls this function. The Commander doesn't have
        -- a OnBlinkEnd() function but the new ability is still added to the Commander for
        -- when they log out and become a Fade again.
        elseif player.OnBlinkEnd then
            player:OnBlinkEnd()
        end

    end
    
end