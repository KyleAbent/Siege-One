/*

local origbuttons = RoboticsFactory.GetTechButtons
function RoboticsFactory:GetTechButtons(techId)
local table = {}

table = origbuttons(self, techId)

 table[3] = kTechId.MacDefenseBuff
 return table

end

*/