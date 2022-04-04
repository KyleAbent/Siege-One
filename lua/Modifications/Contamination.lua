local orig = Contamination.OnInitialized 

function Contamination:OnInitialized()

    orig(self)
    if not GetTimer():GetFrontOpenBoolean() then
        self:Kill()
        --Print("ContamKilling 1")
    end
    if GetIsInSiege(self) then
        Print("Contam is in siege?")
        if not GetTimer():GetSiegeOpenBoolean() then
            self:Kill()
            --Print("ContamKilling 2")
        end
    end 

end

function Contamination:SpewBile()
    return
end