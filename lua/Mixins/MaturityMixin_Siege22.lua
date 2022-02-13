--Start Mature, lets try different direction


function MaturityMixin:__initmixin()
    
    
    PROFILE("MaturityMixin:__initmixin")

    self.maturityFraction = 1
    
    if Server then
        self._maturityFraction = 1
        self.timeMaturityLastUpdate = 0
        self.updateMaturity = false
        self.startsMature = true  
    end

    local model = self:GetRenderModel()
    if model then
        local fraction = 1
        model:SetMaterialParameter("maturity", fraction)
    end
    
end


function MaturityMixin:GetIsMature()
    return true
end

function MaturityMixin:GetMaturityFraction()
    return 1
end

function MaturityMixin:GetMaturityLevel()
        return "Mature"
end

if  Server then

    function MaturityMixin:UpdateMaturity(forceUpdate)
        return
    end

end

function MaturityMixin:OnConstructionComplete()
    if Server then
        self:AdjustMaxHealth(self:GetMatureMaxHealth() )//* 1.15) 
        self:AdjustMaxArmor(self:GetMatureMaxArmor() )//* 1.15)
    end
    return
end




