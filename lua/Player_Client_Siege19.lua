function PlayerUI_GetFrontLength()
    local gameInfo = GetGameInfoEntity()
    if not gameInfo then return kFrontTime end
    return gameInfo:GetFrontTime()
end

function PlayerUI_GetSiegeLength()
    local timer = GetTimer()
    if not timer then return kSiegeTime end
    return timer:GetSiegeLength()
end
function PlayerUI_GetInitialSiegeLength()
    local timer = GetTimer()
    if not timer then return 1 end
    return timer:GetInitialSiegeLength()
end

function PlayerUI_GetSideLength()
    local gameInfo = GetGameInfoEntity()
    if not gameInfo then return kSideTime end
    return gameInfo:GetSideTime()
end

function PlayerUI_GetActivePower()
    local gameInfo = GetGameInfoEntity()
    if not gameInfo then return 1 end
    return gameInfo:GetDynamicSiegeTimerAdjustment()
end

function PlayerUI_GetDynamicLength()
    local gameInfo = GetGameInfoEntity()
    if not gameInfo then return 1 end
    return gameInfo:GetDynamicSiegeTimerAdjustment()
end