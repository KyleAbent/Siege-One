

local origButtons = RoboticsFactory.GetTechButtons
function RoboticsFactory:GetTechButtons(techId)

    local techButtons = origButtons(self, techId)
   
    techButtons[3] = kTechId.Sentry
    
    return techButtons
    
     
end