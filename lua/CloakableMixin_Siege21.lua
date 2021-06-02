//All of this just to get the fade to cloak while blink. Better be worth it.

CloakableMixin.kCloakRate = 2
CloakableMixin.kUncloakRate = 4
CloakableMixin.kTriggerCloakDuration = .6
CloakableMixin.kTriggerUncloakDuration = 2.5

local kPlayerMaxCloak = 0.88
local kPlayerHideModelMin = 0
local kPlayerHideModelMax = 0.15
local kEnemyUncloakDistanceSquared = 1.5 ^ 2


function CloakableMixin:FadeRules()
    return GetHasCamouflageUpgrade(self) and not self:GetIsInCombat() and self:GetIsBlinking() //and not self:GetIsDetected()
end


local function UpdateFadeDesiredCloakFraction(self, deltaTime, isDetected)

    if Server then
    
        self.cloakingDesired = false
    
        -- Animate towards uncloaked if triggered
        if Shared.GetTime() > self.timeUncloaked and 
            (not isDetected )
            and ( not GetConcedeSequenceActive() ) 
        then
            
            -- Uncloaking takes precedence over cloaking
            if Shared.GetTime() < self.timeCloaked then        
                self.cloakingDesired = true
                self.cloakRate = 3
            elseif self.GetIsCamouflaged and self:GetIsCamouflaged() then
                
                self.cloakingDesired = true
                
                if self:isa("Player") then
                    self.cloakRate = self:GetVeilLevel()
                elseif self:isa("Babbler") then
                    local babblerParent = self:GetParent()
                    if babblerParent and HasMixin(babblerParent, "Cloakable") then
                        self.cloakRate = babblerParent.cloakRate
                    end
                else
                    self.cloakRate = 3
                end
                
            end
            
        end
    
    end
    
    local newDesiredCloakFraction = self.cloakingDesired and 1 or 0

    -- Update cloaked fraction according to our speed and max speed
    if self.GetSpeedScalar then
        -- Always cloak no matter how fast we go.
        -- TODO: Fix that GetSpeedScalar returns incorrect values for aliens with celerity
        local speedScalar = math.min(self:GetSpeedScalar(), 1)
        newDesiredCloakFraction = newDesiredCloakFraction - 0.8 * speedScalar
        self.speedScalar = speedScalar * 3
    end
    
    if newDesiredCloakFraction ~= nil then
        self.desiredCloakFraction = Clamp(newDesiredCloakFraction, 0, (self:isa("Player") or self:isa("Drifter") or self:isa("Babbler") or self:isa("Web")) and kPlayerMaxCloak or 1)
    end
    
end

local function UpdateFadeCloakState(self, deltaTime)
    PROFILE("CloakableMixin:OnUpdate")
    
    local isDetected = self:GetIsDetected()
    local isAllowed = self:FadeRules()
    local rate = 0
    local newCloak = 0 
    if not isAllowed or isDetected then
        UpdateFadeDesiredCloakFraction(self, deltaTime, isDetected)
        rate =(self.desiredCloakFraction > self.cloakFraction) and CloakableMixin.kCloakRate * (self.cloakRate / 3) or CloakableMixin.kUncloakRate
        newCloak = Clamp(Slerp(self.cloakFraction, self.desiredCloakFraction, deltaTime * rate), 0, 1)
    else
         self.desiredCloakFraction = 0.8
         rate = 4
         newCloak = 1
    end
    
 
    if newCloak ~= self.cloakFraction then
    
        local callOnCloak = (newCloak == 1) and (self.cloakFraction ~= 1) and self.OnCloak
        self.cloakFraction = newCloak
        
        if callOnCloak then
            self:OnCloak()
        end
        
    end

    if Server then
        
        self.fullyCloaked = self:GetCloakFraction() >= kPlayerMaxCloak
        
        if self.lastTouchedEntityId then
        
            local enemyEntity = Shared.GetEntity(self.lastTouchedEntityId)
            if enemyEntity and (self:GetOrigin() - enemyEntity:GetOrigin()):GetLengthSquared() < kEnemyUncloakDistanceSquared then
                self:TriggerUncloak()
            else
                self.lastTouchedEntityId = nil
            end
        
        end
        
    end
    
end


local cloakOnUpdate = CloakableMixin.OnUpdate

function CloakableMixin:OnUpdate(deltaTime)
    if self:isa("Fade") then
     UpdateFadeCloakState(self, deltaTime)
    else
        cloakOnUpdate(self, deltaTime)
    end
end

local cloakOnProcess = CloakableMixin.OnProcessMove
function CloakableMixin:OnProcessMove(input)
   if self:isa("Fade") then
    UpdateFadeCloakState(self, input.time)
   else
    cloakOnProcess(self, input)
    end
end

local cloakOnProcessSpectate = CloakableMixin.OnProcessSpectate
function CloakableMixin:OnProcessSpectate(deltaTime)
    if self:isa("Fade") then
    UpdateFadeCloakState(self, deltaTime)
    else
        cloakOnProcessSpectate(self, deltaTime)
        cloakOnUpdate(self, deltaTime)
    end
end    

local derp = CloakableMixin.SecondaryAttack
function CloakableMixin:SecondaryAttack()
    if self:isa("Fade") then
    else
        derp(self)
    end
    
end