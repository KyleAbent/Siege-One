--derp
local oldfunc = PrototypeLab.GetItemList
function PrototypeLab:GetItemList(forPlayer)
        local  otherbuttons = { kTechId.Jetpack, 
                                kTechId.DualMinigunExosuit, 
                                kTechId.DualRailgunExosuit, 
                                kTechId.DualWelderExosuit, 
                                kTechId.DualFlamerExosuit, 
                                kTechId.DualGrenaderExosuit,
                                kTechId.JumpPack
                                }
      //if forPlayer.hasjumppack or forPlayer:isa("JetpackMarine")  or forPlayer:isa("Exo")  then
      if forPlayer:isa("JetpackMarine") then
              //otherbuttons[1] = kTechId.None
              otherbuttons[7] = kTechId.None
       end
       
       if forPlayer.hasjumppack then
            otherbuttons[1] = kTechId.None
       end
               
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
