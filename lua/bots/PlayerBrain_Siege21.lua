
local origUpdate = PlayerBrain.Update
function PlayerBrain:Update(bot, move,player)

    if self:isa("CommanderBrain") then
        return
    else
        origUpdate(self,bot, move,player)
        return
    end
 
end

