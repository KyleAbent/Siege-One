--derp
local oldfunc = PrototypeLab.GetItemList
function PrototypeLab:GetItemList(forPlayer)
        local  otherbuttons = { kTechId.Jetpack, kTechId.DualMinigunExosuit, kTechId.DualRailgunExosuit, 
                                kTechId.DualWelderExosuit, kTechId.DualFlamerExosuit, kTechId.DualGrenaderExosuit}
        
               
           return otherbuttons
end

local origbuttons = PrototypeLab.GetTechButtons
function PrototypeLab:GetTechButtons(techId)
local table = {}

table = origbuttons(self, techId)

 table[1] = kTechId.DropExosuit
 table[5] = kTechId.None
 
 return table

end
