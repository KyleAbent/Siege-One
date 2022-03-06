
local origUpdate = PlayerBrain.Update
function PlayerBrain:Update(bot, move)

    if self:isa("CommanderBrain") then
        return
    else
        origUpdate(self,bot, move)
        return
    end
 
end

