--Kyle 'Avoca' Abent
kSentriesPerBattery = 9
Sentry.kFov = 360
Sentry.kMaxPitch = 180
Sentry.kMaxYaw = Sentry.kFov

local function CheckState(self) --Better to have the robo do it. One check per roboo than one per sentry. But this delay should be ok.

        local robotics = GetNearest(self:GetOrigin(), "RoboticsFactory", 1, function(ent) return self:GetDistance(ent) <= 8  and ent:GetIsPowered() end)
        if robotics then
            self.attachedToBattery = true
        else
            self.attachedToBattery = false
        end

    return true

end

local ogCreate = Sentry.OnCreate 

function Sentry:OnCreate()
 ogCreate(self)
 self.attachedToBattery = true
 self.StartingAngles = self:GetAngles():GetCoords():GetInverse()
 self:AddTimedCallback(CheckState, 5)   
end


function GetRoboInRoom(origin)
      local location = GetLocationForPoint(origin)
      local locationName = location and location:GetName() or nil
      local robotics = GetNearest(origin, "RoboticsFactory", 1, function(ent) return ent:GetLocationName() == locationName  and ent:GetIsPowered() end)
      if robotics then
        return robotics
      end
    
end
function GetCheckSentryRoboLimit(techId, origin, normal, commander)

    -- Prevent the case where a Sentry in one room is being placed next to a
    -- SentryBattery in another room.
    local battery = GetRoboInRoom(origin)
    if battery then
    
        if (battery:GetOrigin() - origin):GetLength() > 8 then
            return false
        end
        
    else
        return false
    end
    
    local location = GetLocationForPoint(origin)
    local locationName = location and location:GetName() or nil
    local numInRoom = 0
    local validRoom = false
    
    if locationName then
    
        validRoom = true
        
        for index, sentry in ientitylist(Shared.GetEntitiesWithClassname("Sentry")) do
        
            if sentry:GetLocationName() == locationName then
                numInRoom = numInRoom + 1
            end
            
        end
        
    end
    
    return validRoom and numInRoom < kSentriesPerBattery
    
end

function GetRoboInRange(commander)

    local entities = { }
    local ranges = { }

    for _, battery in ipairs(GetEntitiesForTeam("RoboticsFactory", commander:GetTeamNumber())) do
        ranges[battery] = 8
        table.insert(entities, battery)
    end
    
    return entities, ranges
    
end

if Client then

    local function UpdateAttackEffects(self, deltaTime)
    
        local intervall = ConditionalValue(self.confused, Sentry.kConfusedAttackEffectInterval, Sentry.kAttackEffectIntervall)
        if self.attacking and (self.timeLastAttackEffect + intervall < Shared.GetTime()) then
        
            if self.confused then
                self:TriggerEffects("sentry_single_attack")
            end
            
            -- plays muzzle flash and smoke
            self:TriggerEffects("sentry_attack")

            self.timeLastAttackEffect = Shared.GetTime()
            
        end
        
    end
    
   function Sentry:OnUpdate(deltaTime) --all this just to remove the 180 lol
    
        ScriptActor.OnUpdate(self, deltaTime)
        
        if GetIsUnitActive(self) and self.deployed and self.attachedToBattery then
            local shouldStop = false
            local swingMult = 1.0

            -- Swing barrel yaw towards target
            if self.attacking then
            
                if self.targetDirection then -- ARC:UpdateAngles(deltaTime)
                local yawDiffRadians = GetAnglesDifference(GetYawFromVector(self.targetDirection), self:GetAngles().yaw)
                local yawDegrees = DegreesTo360(math.deg(yawDiffRadians))    
                self.desiredYawDegrees = Clamp(yawDegrees, -360, 360)
                end
                
                UpdateAttackEffects(self, deltaTime)
                
            -- Else when we have no target, swing it back and forth looking for targets
            else
            
                local interval = Sentry.kTargetScanDelay
                if (self.timeLastAttackEffect + interval < Shared.GetTime()) then
                    local sin = math.sin(math.rad((Shared.GetTime() + self:GetId() * 1) * Sentry.kBarrelScanRate))
                    self.desiredYawDegrees = sin * self:GetFov() -- removed /2 how dum

                    -- Swing barrel pitch back to flat
                    self.desiredPitchDegrees = 0
                end
            end
            
            -- swing towards desired direction
            self.barrelPitchDegrees = Slerp(self.barrelPitchDegrees, self.desiredPitchDegrees, Sentry.kBarrelMoveRate * swingMult * deltaTime)
            self.barrelYawDegrees = Slerp(self.barrelYawDegrees , self.desiredYawDegrees, Sentry.kBarrelMoveRate * swingMult * deltaTime)
        
        end
    
    end

end
