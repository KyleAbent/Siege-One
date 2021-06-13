/*
local origCC = ArmsLab.GetTechButtons
function ArmsLab:GetTechButtons(techId)
 local orig = origCC(self, techId)
  orig[1] = kTechId.None
  orig[2] = kTechId.None
  orig[3] = kTechId.None
  orig[4] = kTechId.None
  orig[5] = kTechId.None
  orig[6] = kTechId.None
  orig[7] = kTechId.None
  return orig
end
*/

function ArmsLab:OnPowerOn()
	 GetImaginator().activeArms = GetImaginator().activeArms + 1;  
end

function ArmsLab:OnPowerOff()
	 GetImaginator().activeArms = GetImaginator().activeArms - 1;  
end

 function ArmsLab:PreOnKill(attacker, doer, point, direction)
	  if self:GetIsPowered() then
	    GetImaginator().activeArms  = GetImaginator().activeArms- 1;  
	  end
end