
function PlayerUI_GetFrontLength()

    local gameInfo = GetGameInfoEntity()
    if not gameInfo then return kFrontTime end
    return gameInfo:GetFrontTime()

end
function PlayerUI_GetSiegeLength()


    return kSiegeTime

end

function PlayerUI_GetSideLength()


    return kSideTime

end