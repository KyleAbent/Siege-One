/*

local orig = Metabolize.OnTag
function Metabolize:OnTag(tagName)//override
    if tagName == "hit" then
        orig(self,tagName)
        return
    end    
    return
end

--override
function Metabolize:OnPrimaryAttack(player)

return
    
end

function Metabolize:OnPrimaryAttackEnd()
    
return
end
*/

local kMetabolizeDelay = 0.65
function Metabolize:GetHasAttackDelay()
	local parent = self:GetParent()
    return self.lastPrimaryAttackTime + kMetabolizeDelay > Shared.GetTime() or parent and parent:GetIsStabbing()
end