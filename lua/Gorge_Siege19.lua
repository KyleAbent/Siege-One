local networkVars =
{
    wallWalking = "compensated boolean",
    timeLastWallWalkCheck = "private compensated time",
    isriding = "boolean",
    gorgeusingLerkID = "entityid",
     wantstobelifted = "boolean",
}

local kBallFlagAttachPoint = "babbler_attach1"


if Client then
    Script.Load("lua/Gorge_Client.lua", true)
end

local kNormalWallWalkFeelerSize = 0.25
local kNormalWallWalkRange = 0.3
local kJumpWallRange = 0.4
local kJumpWallFeelerSize = 0.1
local kWallJumpInterval = 0.4
local kWallJumpForce = 5.2 // scales down the faster you are
local kMinWallJumpForce = 0.1
local kVerticalWallJumpForce = 4.3

local origcreate = Gorge.OnCreate
function Gorge:OnCreate()

    origcreate(self)
    InitMixin(self, WallMovementMixin)
    
    self.wallWalking = false
    self.wallWalkingNormalGoal = Vector.yAxis
    self.timeLastWallJump = 0
    self.isriding = false
    self.gorgeusingLerkID = Entity.invalidI
    self.wantstobelifted = true
    self.timeLastLerkCheck = 0
end

function Gorge:GetTunnelColor()
    return self.tunnelColor
end
local originit = Gorge.OnInitialized
function Gorge:OnInitialized()

    originit(self)
    self.currentWallWalkingAngles = Angles(0.0, 0.0, 0.0)
    self.timeLastWallJump = 0
    self.lastToggled = Shared.GetTime()
end


function Gorge:GetRebirthLength()
return 3
end
function Gorge:GetRedemptionCoolDown()
return 15
end
function Gorge:GetBaseArmor()
    return kGorgeArmor
end




function Gorge:GetCanJump()
    local canWallJump = self:GetCanWallJump()
    return self:GetIsOnGround() or canWallJump
end
function Gorge:GetIsWallWalking()
    return self.wallWalking
end
function Gorge:GetIsWallWalkingPossible() 
    return not self:GetRecentlyJumped() and not self:GetCrouching()
end
local function PredictGoal(self, velocity)

    PROFILE("Gorge:PredictGoal")

    local goal = self.wallWalkingNormalGoal
    if velocity:GetLength() > 1 and not self:GetIsGround() then

        local movementDir = GetNormalizedVector(velocity)
        local trace = Shared.TraceCapsule(self:GetOrigin(), movementDir * 2.5, Gorge.kXExtents, 0, CollisionRep.Move, PhysicsMask.Movement, EntityFilterOne(self))

        if trace.fraction < 1 and not trace.entity then
            goal = trace.normal    
        end

    end

    return goal

end

// Handle transitions between starting-sliding, sliding, and ending-sliding
local function UpdateGorgeSliding(self, input)

    PROFILE("Gorge:UpdateGorgeSliding")
    
    local slidingDesired = GetIsSlidingDesired(self, input)
    if slidingDesired and not self.sliding and self:GetIsOnGround() and self:GetEnergy() >= kBellySlideCost and not self:GetIsWallWalking() then
    
        self.sliding = true
        self.startedSliding = true
        
        if Server then
            if (GetHasSilenceUpgrade(self) and ConditionalValue(self.RTDSilence == true, 3, GetVeilLevel(self:GetTeamNumber())) == 0) or not GetHasSilenceUpgrade(self) then
                self.slideLoopSound:Start()
            end
        end
        
        self:DeductAbilityEnergy(kBellySlideCost)
        self:PrimaryAttackEnd()
        self:SecondaryAttackEnd()
        
    end
    
    if not slidingDesired and self.sliding then
    
        self.sliding = false
        
        if Server then
            self.slideLoopSound:Stop()
        end
        
        self.timeSlideEnd = Shared.GetTime()
    
    end

    // Have Gorge lean into turns depending on input. He leans more at higher rates of speed.
    if self:GetIsBellySliding() then

        local desiredBellyYaw = 2 * (-input.move.x / kSlidingMoveInputScalar) * (self:GetVelocity():GetLength() / self:GetMaxSpeed())
        self.bellyYaw = Slerp(self.bellyYaw, desiredBellyYaw, input.time * kGorgeLeanSpeed)
        
    end
    
end
function Gorge:GetRecentlyWallJumped()
    return self.timeLastWallJump + kWallJumpInterval > Shared.GetTime()
end

function Gorge:GetCanWallJump()

    local wallWalkNormal = self:GetAverageWallWalkingNormal(kJumpWallRange, kJumpWallFeelerSize)
    if wallWalkNormal then -- and GetHasTech(self, kTechId.BileBomb) then
        return wallWalkNormal.y < 0.5
    end
    
    return false

end

function Gorge:ModifyJump(input, velocity, jumpVelocity)

    if self:GetCanWallJump() then
    
        local direction = input.move.z == -1 and -1 or 1
    
        // we add the bonus in the direction the move is going
        local viewCoords = self:GetViewAngles():GetCoords()
        self.bonusVec = viewCoords.zAxis * direction
        self.bonusVec.y = 0
        self.bonusVec:Normalize()
        
        jumpVelocity.y = 3 + math.min(1, 1 + viewCoords.zAxis.y) * 2

        local celerityMod = (GetHasCelerityUpgrade(self) and GetSpurLevel(self:GetTeamNumber()) or 0) * 0.4
        local currentSpeed = velocity:GetLengthXZ()
        local fraction = 1 - Clamp( currentSpeed / (11 + celerityMod), 0, 1)        
        
        local force = math.max(kMinWallJumpForce, (kWallJumpForce + celerityMod) * fraction)
          
        self.bonusVec:Scale(force)      

        if not self:GetRecentlyWallJumped() then
        
            self.bonusVec.y = viewCoords.zAxis.y * kVerticalWallJumpForce
            jumpVelocity:Add(self.bonusVec)

        end
        
        self.timeLastWallJump = Shared.GetTime()
        
    end
    
end
function Gorge:GetPerformsVerticalMove()
    return self:GetIsWallWalking()
end
function Gorge:OverrideUpdateOnGround(onGround)
    return onGround or self:GetIsWallWalking()
end


local kMaxSlideRoll = math.rad(20)

function Gorge:GetDesiredAngles()

    local desiredAngles = Alien.GetDesiredAngles(self)
    
    if self:GetIsBellySliding() then
        desiredAngles.pitch = - self.verticalVelocity / 10 
        desiredAngles.roll = GetNormalizedVectorXZ(self:GetVelocity()):DotProduct(self:GetViewCoords().xAxis) * kMaxSlideRoll
    end
   if self:GetIsWallWalking() then return self.currentWallWalkingAngles end
       return desiredAngles
end
function Gorge:GetHeadAngles()

    if self:GetIsWallWalking() then
        // When wallwalking, the angle of the body and the angle of the head is very different
        return self:GetViewAngles()
    else
        return self:GetViewAngles()
    end

end
function Gorge:GetIsUsingBodyYaw()
    return not self:GetIsWallWalking()
end

function Gorge:GetAngleSmoothingMode()

    if self:GetIsWallWalking() then
        return "quatlerp"
    else
        return "euler"
    end

end
function Gorge:OnJump()

    self.wallWalking = false

    local material = self:GetMaterialBelowPlayer()    
    local velocityLength = self:GetVelocity():GetLengthXZ()
    
    if velocityLength > 11 then
        self:TriggerEffects("jump_best", {surface = material})          
    elseif velocityLength > 8.5 then
        self:TriggerEffects("jump_good", {surface = material})       
    end

    self:TriggerEffects("jump", {surface = material})
    
end
function Gorge:OnWorldCollision(normal, impactForce, newVelocity)

    PROFILE("Gorge:OnWorldCollision")

    self.wallWalking = self:GetIsWallWalkingPossible() and normal.y < 0.5
    
end
function Gorge:PreUpdateMove(input, runningPrediction)
    PROFILE("Gorge:PreUpdateMove")
    self.prevY = self:GetOrigin().y
        if self:GetCrouching() then
        self.wallWalking = false
    end

    if self.wallWalking then

        // Most of the time, it returns a fraction of 0, which means
        // trace started outside the world (and no normal is returned)           
        local goal = self:GetAverageWallWalkingNormal(kNormalWallWalkRange, kNormalWallWalkFeelerSize)
        if goal ~= nil then 
        
            self.wallWalkingNormalGoal = goal
            self.wallWalking = true
           -- self:SetEnergy(self:GetEnergy() - kWallWalkEnergyCost)

        else
            self.wallWalking = false
        end
    
    end
    
    if not self:GetIsWallWalking() then
        // When not wall walking, the goal is always directly up (running on ground).
        self.wallWalkingNormalGoal = Vector.yAxis
    end


  //  if self.leaping and Shared.GetTime() > self.timeOfLeap + kLeapTime then
  //      self.leaping = false
  //  end
    
    self.currentWallWalkingAngles = self:GetAnglesFromWallNormal(self.wallWalkingNormalGoal or Vector.yAxis) or self.currentWallWalkingAngles

    
    if self.isriding and (self.gorgeusingLerkID ~= Entity.invalidI) then
        local lerk = Shared.GetEntity(self.gorgeusingLerkID)
        if lerk then 
                self:SetOrigin(lerk:GetOrigin() +  Vector(0, .5,0))
                input.move.z = 0
                input.move.x = 0
                input.move.y = 0
        else
           --Print("Lerk which was carrying gorge has been lost. Resetting Gorge Status")
           --self:TriggerRebirth()
           self.isriding = false
           self.gorgeusingLerkID = Entity.invalidI 
        end
    end
 
end

/*
if Server then
    --If Lerk Gestates or any other thing while LerkLift is active than OnKill
    function Gorge:OnUpdate(deltaTime)
        if self.isriding and GetIsTimeUp(self.timeLastLerkCheck, 1) then
            local lerk = Shared.GetEntity(self.gorgeusingLerkID)
            if lerk then 
                if lerk:isa("Lerk") and lerk.lerkcarryingGorgeId == self:GetId() then
                    --No Problem Here
                    Print("OnUpdate found LerkLift Lerk no problem")
                else
                    --Something happened
                    Print("OnUpdate found LerkLift Lerk WITH problem.")
                    self.isriding = false
                    self.gorgeusingLerkID = Entity.invalidI 
                end
            end
            self.timeLastLerkCheck = Shared.GetTime()
        end

    end
end
*/

function Gorge:GetMoveSpeedIs2D()
    return not self:GetIsWallWalking()
end
function Gorge:GetCanStep()
    return not self:GetIsWallWalking()
end

function Gorge:PostUpdatedsdMove(input, runningPrediction)

    if self:GetIsBellySliding() and self:GetIsOnGround() then
    
        local velocity = self:GetVelocity()
    
        local yTravel = self:GetOrigin().y - self.prevY
        local xzSpeed = velocity:GetLengthXZ()
        
        xzSpeed = xzSpeed + yTravel * -4
        
        if xzSpeed < kMaxSlidingSpeed or yTravel > 0 then
        
            local directionXZ = GetNormalizedVectorXZ(velocity)
            directionXZ:Scale(xzSpeed)

            velocity.x = directionXZ.x
            velocity.z = directionXZ.z
            
            self:SetVelocity(velocity)
            
        end

        self.verticalVelocity = yTravel / input.time
    
    end

end



if Server then


    function Gorge:GetTierFourTechId()
        return kTechId.None
    end

    function Gorge:GetTierFiveTechId()
        return kTechId.None
    end

end

function Gorge:OnUse(player, elapsedTime, useSuccessTable)
  
       
      if not player.isoccupied and not self.isriding then
        player.isoccupied = true 
        self.gorgeusingLerkID = player:GetId()
        player.lerkcarryingGorgeId = self:GetId()
        self.isriding = true
        //Print("Gorge On Use A")
        self.lastToggled = Shared.GetTime()
    elseif player.isoccupied and self.isriding and player.lerkcarryingGorgeId == self:GetId() then
        player.isoccupied = false
        self.gorgeusingLerkID = Entity.invalidI
        player.lerkcarryingGorgeId = Entity.invalidI
        self.isriding = false
        //Print("Gorge On Use B")
        self.lastToggled = Shared.GetTime()
        self:SetOrigin(self:GetOrigin() - Vector(0, 0.5, 0) )
     end
       
       
end

function Gorge:ModifyGravityForce(gravityTable)

    if self.isriding then--self:GetIsWallWalking() and not self:GetCrouching() or self.isriding or self:GetIsOnGround() then
        gravityTable.gravity = 0
    end
       // if self.gravity ~= 0 then
       // gravityTable.gravity = self.gravity
   // end
    
end

function Gorge:GetCanBeUsed(player, useSuccessTable)
    local boolean = false
    if player:isa("Lerk") and GetIsTimeUp(self.lastToggled, 2) and self.wantstobelifted then
       if ( GetHasTech(player, kTechId.LerkLift) or Shared.GetCheatsEnabled ) then
            if ( not player.isoccupied and not self.isriding ) then
                boolean = true
                //Print("Neither Gorge or Lerk is occupied, can Gorge can be used")
            elseif ( self.isriding and player.isoccupied and player.lerkcarryingGorgeId == self:GetId()  )then
                boolean = true
                //Print("Gorge is riding, Lerk is Occupied, Lerk's GorgeID Matches this gorge, Gorge can be used")
            end
        end
   end
        useSuccessTable.useSuccess = boolean
end

local orig = Gorge.OnKill
function Gorge:OnKill()
    orig(self)
   if self.isriding then
        self.isriding = false
        local lerk = Shared.GetEntity(self.gorgeusingLerkID)
        if lerk then
                lerk.isoccupied = false 
                lerk.lerkcarryingGorgeId = Entity.invalidI 
         end
   end

end

Shared.LinkClassToMap("Gorge", Gorge.kMapName, networkVars, true)