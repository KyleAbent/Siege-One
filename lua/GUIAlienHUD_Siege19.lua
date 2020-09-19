local origUpdate = GUIAlienHUD.Update

function GUIAlienHUD:Update(deltaTime)
    origUpdate(self, deltaTime)
    --Update front and siege timers through the resource display
    
    -- Update resource display
    local resourceUpdate = {
        PlayerUI_GetActivePower(),
        PlayerUI_GetGameLengthTime(),
        PlayerUI_GetFrontLength(),
        PlayerUI_GetSiegeLength(),
        PlayerUI_GetSideLength()
    }
    
    

    self.resourceDisplay:UpdateFrontSiege(deltaTime, resourceUpdate)
end