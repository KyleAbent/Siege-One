Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/Weapons/Alien/PrimalScream.lua")

--Lerk.XZExtents = 0.28
--Lerk.YExtents = 0.28


local networkVars = //Why don't  Ijust add LerkLiftMixin and make it networkvars in there sharing the same functions lol
{
 lerkcarryingGorgeId = "entityid",
 isoccupied = "boolean",
 wantstobelifted = "boolean",
}

local origCreate = Lerk.OnCreate 

function Lerk:OnCreate()
    origCreate(self)
    InitMixin(self, PredictedProjectileShooterMixin)
    self.isoccupied = false
    self.lerkcarryingGorgeId = Entity.invalidI
    self.lastToggled = Shared.GetTime()
    self.wantstobelifted = true
end

if Server then

    function Lerk:GetTierFourTechId()
        return kTechId.PrimalScream
    end


end

function Lerk:GetCanBeUsed(player, useSuccessTable)
        if GetIsTimeUp(self.lastToggled, 4) then
           if player:isa("Gorge") and ( GetHasTech(player, kTechId.LerkLift) or Shared.GetCheatsEnabled )
           and ( not self.isoccupied and not player.isriding )
           or ( player.isriding and self.isoccupied and player.gorgeusingLerkID == self:GetId()  )then
                //Print("Lerk Can Be Used")
                useSuccessTable.useSuccess = true
           else
                 //Print("Lerk Can Not Be Used")
                useSuccessTable.useSuccess = false
           end
         else
            useSuccessTable.useSuccess = false
         end
end

function Lerk:OnUse(player, elapsedTime, useSuccessTable)
      if not player.isriding and not self.occupied then
        player.isriding = true 
        player.gorgeusingLerkID = self:GetId()
        self.lerkcarryingGorgeId = player:GetId()
        self.isoccupied = true
        Print("Lerk On Use A")
        self.lastToggled = Shared.GetTime()
    elseif self.occupied and  ( player.isriding and self.lerkcarryingGorgeId == player:GetId() ) then
        player.isriding = false
        player.gorgeusingLerkID = Entity.invalidI
        self.lerkcarryingGorgeId = Entity.invalidI
        self.isoccupied = false
        Print("Lerk On Use B")
        self.lastToggled = Shared.GetTime()
        player:SetOrigin(self:GetOrigin() - Vector(0, 0.5, 0) )
     end
end

if Server then
    local orig = Lerk.OnKill
    function Lerk:OnKill()
        orig(self)
        self.occupied = false
        local gorge = Shared.GetEntity(self.lerkcarryingGorgeId)
            if gorge then
                    //Print("Lerk Died, found gorge")
                    gorge.gorgeusingLerkID = Entity.invalidI 
                    gorge.isriding = false
                    gorge:TriggerRebirth()
             end
        self.lerkcarryingGorgeId = Entity.invalidI

    end

end

/*
//local orig = Lerk.OnKill
function Lerk:PreOnKill(attacker, doer, point, direction)
  //  orig(self)
    Player.PreOnKill(self,attacker, doer, point, direction)
    local gorge = Shared.GetEntity(self.lerkcarryingGorgeId)
        if gorge then
                self.occupied = false
                gorge.gorgeusingLerkID = Entity.invalidI 
                gorge.isriding = false
                gorge:SetOrigin(self:GetOrigin()) // dont get stuck in wall or whatever
         end
    self.lerkcarryingGorgeId = Entity.invalidI
end
*/


/*
//Hitboxes aren't updated

function Lerk:GetExtentsOverride()
    return Vector(0.28, 0.28, 0.28) --70% Size
end

if Client then

    function Lerk:OnAdjustModelCoords(modelCoords)

        modelCoords.xAxis = modelCoords.xAxis * 0.7
        modelCoords.yAxis = modelCoords.yAxis * 0.7
        modelCoords.zAxis = modelCoords.zAxis * 0.7
        
    return modelCoords
    
    end
    

end

*/
Shared.LinkClassToMap("Lerk", Lerk.kMapName, networkVars, true)