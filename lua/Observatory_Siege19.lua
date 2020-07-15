local origButtons = Observatory.GetTechButtons
function Observatory:GetTechButtons(techId)

    local techButtons = origButtons(self, techId)
    
    techButtons[5] = kTechId.None
    
    return techButtons
    
    
end


