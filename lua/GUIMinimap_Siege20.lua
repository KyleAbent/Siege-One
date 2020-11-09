
      
    local function DrawLocalBlip(self, blipData)

    local icon = blipData.icon
    if icon.resetMinimapItem then
        self:InitMinimapIcon(icon, blipData.blipType, blipData.blipTeam)
    end

    self:UpdateBlipPosition(icon, blipData.position)

end

function GUIMinimap:DrawLocalBlips()
    PROFILE("GUIMinimap:DrawLocalBlips")

    for _, blipData in self.localBlipData:Iterate() do
        DrawLocalBlip(self, blipData)
    end

end



