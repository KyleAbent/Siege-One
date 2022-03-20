function Metabolize:GetAttackDelay()
    return 0.5
end

--Why does this function reference kMetabolizeDelay and not GetAttackDelay
function Metabolize:GetHasAttackDelay()
	local parent = self:GetParent()
    --return self.lastPrimaryAttackTime + kMetabolizeDelay > Shared.GetTime() or parent and parent:GetIsStabbing()
    return self.lastPrimaryAttackTime + self:GetAttackDelay() > Shared.GetTime() or parent and parent:GetIsStabbing()
end