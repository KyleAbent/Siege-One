
LoneCyst.kTouchRange = 0.9 -- Max model extents for "touch" uncloaking

function LoneCyst:GetCanAutoBuild()
    return true
end


function LoneCyst:GetSendDeathMessageOverride()
    return false
end



function LoneCyst:GetMaturityRate()
    return kLoneCystMaturationTime
end


function LoneCyst:OnUpdate(deltaTime)

    PROFILE("LoneCyst:OnUpdate")

    ScriptActor.OnUpdate(self, deltaTime)

    if self:GetIsAlive() then

    else

        local destructionAllowedTable = { allowed = true }
        if self.GetDestructionAllowed then
            self:GetDestructionAllowed(destructionAllowedTable)
        end

        if destructionAllowedTable.allowed then
            DestroyEntity(self)
        end

    end

end

function LoneCyst:UpdateInfestationCloaking()
    PROFILE("LoneCyst:UpdateInfestationCloaking")

    self.cloakInfestation = self.timeUncloaked < self.timeCloaked and self.timeCloaked > Shared.GetTime()

    return self:GetIsAlive()
end

function LoneCyst:ScanForNearbyEnemy()

    self.lastDetectedTime = self.lastDetectedTime or 0
    if self.lastDetectedTime + kDetectInterval < Shared.GetTime() then

        local done = false

        -- LoneCysts are in the "SmallStructures" physics group, so CloakableMixin's OnCapsuleTraceHit does not trigger since the player movement masks excludes aforementioned group.
        if #GetEntitiesForTeamWithinRange("Player", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), LoneCyst.kTouchRange) > 0 then
            self:TriggerUncloak()
            done = true
        end

        -- Check shades in range, and stop if a shade is in range and is cloaked.
        if not done then
            for _, shade in ipairs(GetEntitiesForTeamWithinRange("Shade", self:GetTeamNumber(), self:GetOrigin(), Shade.kCloakRadius)) do
                if shade:GetIsCloaked() then
                    done = true
                    break
                end
            end
        end

        -- Finally check if the LoneCysts have players in range.
        if not done and #GetEntitiesForTeamWithinRange("Player", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), kCystDetectRange) > 0 then
            self:TriggerUncloak()
            done = true
        end

        self.lastDetectedTime = Shared.GetTime()
    end

    return self:GetIsAlive()
end
function LoneCyst:UpdateInfestationCloaking()
    PROFILE("Cyst:UpdateInfestationCloaking")

    self.cloakInfestation = self.timeUncloaked < self.timeCloaked and self.timeCloaked > Shared.GetTime()

    return self:GetIsAlive()
end