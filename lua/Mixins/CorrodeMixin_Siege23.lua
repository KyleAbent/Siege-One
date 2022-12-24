--I don't want to override like this but the way the code is written, I have to.
function CorrodeMixin:CorrodeOnInfestation()

    if self:GetMaxArmor() == 0 then
        self.corrodeOnInfestationTimerActive = false
        return false
    end

    if self.updateInitialInfestationCorrodeState and GetIsPointOnInfestation(self:GetOrigin()) then
    
        self:SetGameEffectMask(kGameEffect.OnInfestation, true)
        self.updateInitialInfestationCorrodeState = false
        
    end

    if self:GetGameEffectMask(kGameEffect.OnInfestation) and self:GetCanTakeDamage() and (not HasMixin(self, "GhostStructure") or not self:GetIsGhostStructure()) then
        
        self:SetCorroded()


        if self:GetArmor() > 0 then
            if self:isa("PowerPoint") then
                self:DoDamageLighting()
            end
            --do armor only if has armor
            self:DeductHealth(kInfestationCorrodeDamagePerSecondHealth, nil, nil, false, true, true)--just to change this line
        else--add this line
            self:DeductHealth(kInfestationCorrodeDamagePerSecond, nil, nil, true, false, true)--just to change this line    
        end
        
    end

    return true

end
