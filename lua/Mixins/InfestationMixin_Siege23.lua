
--Overriding and modifying for Siege

/*
local orig = InfestationMixin.CreateInfestation
function InfestationMixin:CreateInfestation()
    if self.moving then
        return
    else        
        orig(self)
    end
end
*/

