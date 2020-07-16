

local origbuttons = RoboticsFactory.GetTechButtons
function RoboticsFactory:GetTechButtons(techId)
local table = {}

table = origbuttons(self, techId)
 table[2] = kTechId.BigMac
 table[3] = kTechId.Sentry
 return table

end

