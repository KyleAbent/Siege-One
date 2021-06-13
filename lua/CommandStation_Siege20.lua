/*

local origCC = CommandStation.GetTechButtons
function CommandStation:GetTechButtons(techId)
 local orig = origCC(self, techId)
  orig[1] = kTechId.None
  return orig
end

*/