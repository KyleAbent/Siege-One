--Kyle 'Avoca' Abent
Script.Load("lua/Weapons/Alien/Ability.lua")
--Script.Load("lua/Weapons/Alien/StompMixin.lua")

class 'GorillaGlue' (Ability)

GorillaGlue.kMapName = "gorillaglue"

local networkVars =
{
   
}
--AddMixinNetworkVars(StompMixin, networkVars)

function GorillaGlue:OnCreate()

    Ability.OnCreate(self)
    
    --InitMixin(self, StompMixin)
   -- local player = self:GetParent()
   -- if player then
   --     player:DoBothShows(player)
   -- end

end


function GorillaGlue:GetEnergyCost()
    return 20
end

function GorillaGlue:GetAnimationGraphName()
    return kAnimationGraph
end

function GorillaGlue:GetHUDSlot()
    return 3
end

    
function GorillaGlue:IsOnCooldown()
    -- local boolean = self:GetFuel() < 0.9
     --Print("IsOnCooldown is %s", boolean)
     return false
end
function GorillaGlue:IsOnCooldown()
    --do delay here lol
     return false
end
function GorillaGlue:GetCanToggleRedemption(player)
    local boolean = not self:IsOnCooldown() and not self.secondaryAttacking and not player.charging
   -- Print("Canuse is %s", boolean)
    return boolean
end
function GorillaGlue:GetCanToggleRebirth(player)
    local boolean = not self:IsOnCooldown() and not self.primaryAttacking and not player.charging
   -- Print("Canuse is %s", boolean)
    return boolean
end
function GorillaGlue:OnPrimaryAttack(player)
  --Print("Umm123")
    if not self.primaryAttacking and not self.secondaryAttacking then
          -- Print("Energy cost is %s, player energy is %s, player has more energy is %s", self:GetEnergyCost(),  player:GetEnergy(), self:GetEnergyCost() < player:GetEnergy())
          
          if player:GetIsInCombat() then
            player:GetOutOfComebat(player)
            return
          end
          
        if player:GetIsOnGround() and self:GetCanToggleRedemption(player) and self:GetEnergyCost() < player:GetEnergy() then
           --     Print("Umm")
            player:DeductAbilityEnergy(self:GetEnergyCost())
            
            --self:SetFuel( self:GetFuel() ) -- set it now, because it will go down from this point
            self.primaryAttacking = true
            player:ToggleRedemption()
            player:DisableRebirth()
            player:DoBothShows(player)
            
            if Server then
                player:TriggerEffects("onos_shield_start")
            end
        end
    end

end

function GorillaGlue:OnPrimaryAttackEnd(player)
    
    if self.primaryAttacking then 
    
        --self:SetFuel( self:GetFuel() ) -- set it now, because it will go up from this point
        self.primaryAttacking = false
    
    end
    
end

function GorillaGlue:OnSecondaryAttack(player)
  --Print("Umm123")
    if not self.secondaryAttacking and not self.primaryAttacking then
          -- Print("Energy cost is %s, player energy is %s, player has more energy is %s", self:GetEnergyCost(),  player:GetEnergy(), self:GetEnergyCost() < player:GetEnergy())
          
          if player:GetIsInCombat() then
            player:GetOutOfComebat(player)
            return
          end
          
        if player:GetIsOnGround() and self:GetCanToggleRebirth(player) and self:GetEnergyCost() < player:GetEnergy() then
           --     Print("Umm")
            player:DeductAbilityEnergy(self:GetEnergyCost())
            
            --self:SetFuel( self:GetFuel() ) -- set it now, because it will go down from this point
            self.secondaryAttacking = true
            player:ToggleRebirth()
            player:DisableRedemption()
            player:DoBothShows(player)
            
            if Server then
                player:TriggerEffects("onos_shield_start")
            end
        end
    end

end
function GorillaGlue:GetHasSecondary(player)
    return true
end
function GorillaGlue:OnSecondaryAttackEnd(player)
    
    if self.secondaryAttacking then 
    
        --self:SetFuel( self:GetFuel() ) -- set it now, because it will go up from this point
        self.secondaryAttacking = false
    
    end
    
end

function GorillaGlue:OnUpdateAnimationInput(modelMixin)

    local activityString = "none"
    local abilityString = "boneshield"
    
    if self.primaryAttacking then
        activityString = "primary" -- TODO: set anim input
    end
    
    modelMixin:SetAnimationInput("ability", abilityString)
    modelMixin:SetAnimationInput("activity", activityString)
    
end

function GorillaGlue:OnHolster(player)
    
    Ability.OnHolster(self, player)
    
    self:OnPrimaryAttackEnd(player)
  --  player:DoBothShows(player)
    --player:TriggerRebirthRedeemCountdown(player)
    
end



Shared.LinkClassToMap("GorillaGlue", GorillaGlue.kMapName, networkVars)