/*'
Script.Load("lua/GlowMixin.lua")

local networkVars = {


} 

AddMixinNetworkVars(GlowMixin, networkVars)

local origcreate = Player.OnCreate
function Player:OnCreate()
   origcreate(self)
end

local originit = Player.OnInitialized
function Player:OnInitialized()
    originit(self)
    InitMixin(self, GlowMixin)
    if Server then
        if not GetGameStarted() and math.random(1, 100) <= 10 then 
            self:GlowColor( math.random(1, self:GetMaxCountOfColors() ) , 120) //duration doesn't work it's ok lol (dying doesnt regive)
            notifyglow(self)
        end
    end
end

*/

function Player:HookWithShineToBuyMist(player)

end

//Shared.LinkClassToMap("Player", Player.kMapName, networkVars)