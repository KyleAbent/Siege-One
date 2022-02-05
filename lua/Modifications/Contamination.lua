local orig = Contamination.OnCreate 

function Contamination:OnCreate()

    orig(self)
    if not GetTimer():GetFrontOpenBoolean() then
        self:Kill()
    elseif (  GetIsInSiege(self)  and not GetTimer():GetSiegeOpenBoolean() ) then
        self:Kill()
    end 

end

function Contamination:SpewBile()
    return
end