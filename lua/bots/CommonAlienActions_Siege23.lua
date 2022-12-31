--overriding, too complicated. replacing with simpler marine style.
local function FindNearestPhaseGate(alien, favoredGateId, fromPos)
    
    local gates = GetEntitiesForTeam( "PhaseGate", marine:GetTeamNumber() )

    return GetMinTableEntry( gates,
            function(gate)

                assert( gate ~= nil )

                if gate:GetIsBuilt() and gate:GetIsLinked() then

                    local dist = GetBotWalkDistance(gate, fromPos or alien)
                    if gate:GetId() == favoredGateId then
                        return dist * 0.9
                    else
                        return dist
                    end

                else
                    return nil
                end

            end)

end

--overriding, too complicated. replacing with simpler marine style.
function GetTunnelDistanceForAlien(alien, destOrTarget, destLocHint)


    local alienPos = alien:GetOrigin()
    local p0Dist, p0 = FindNearestPhaseGate(alien, lastNearestGateId)
    local p1Dist, p1 = FindNearestPhaseGate(alien, nil, to)
    local walkDistance = GetBotWalkDistance(alien, to)

    -- Favor the euclid dist just a bit..to prevent thrashing  ....McG: eh, not convinced this comment is correct
    local hasTwoPhasegates = (p0 and p1) and (p0:GetId() ~= p1:GetId())
    if hasTwoPhasegates and (p0Dist + p1Dist) < walkDistance then
        return (p0Dist + p1Dist), p0
    else
        return walkDistance, nil
    end
  

end