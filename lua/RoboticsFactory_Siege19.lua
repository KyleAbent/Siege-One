

local origButtons = RoboticsFactory.GetTechButtons
function RoboticsFactory:GetTechButtons(techId)

    local techButtons = origButtons(self, techId)
   
    techButtons[3] = kTechId.Sentry
    
    return techButtons
    
     
end

function RoboticsFactory:OnPowerOn()
	GetRoomPower(self):ToggleCountMapName(self:GetMapName(),1)
end

function RoboticsFactory:OnPowerOff()
	GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1) 
end

 function RoboticsFactory:PreOnKill(attacker, doer, point, direction)
      
	  if self:GetIsPowered() then
	   GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
	  end
end