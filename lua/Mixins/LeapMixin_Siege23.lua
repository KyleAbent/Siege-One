local orig = LeapMixin.PerformSecondaryAttack
function LeapMixin:PerformSecondaryAttack(player)
    print("LeapMixin Step 1")
    local parent = self:GetParent()
    if not player:GetIsOnGround() then
        print("LeapMixin Step 2")
        return false
    else
        print("LeapMixin Step 3")
        return orig(self,player)    
end