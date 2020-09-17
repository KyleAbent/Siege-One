local networkVars =
{
    frontTimer = "integer"
}

local ogCreate = GameInfo.OnCreate

function GameInfo:OnCreate()
    ogCreate(self)
    self.frontTimer = kFrontTime
end

function GameInfo:GetFrontTime()
   return self.frontTimer
end

function GameInfo:SetFrontTime(time)
    self.frontTimer = time
end
Shared.LinkClassToMap("GameInfo", GameInfo.kMapName, networkVars, true)