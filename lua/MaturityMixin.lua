--Fuck this bullshit calculation get it out of here

MaturityMixin = CreateMixin(MaturityMixin)
MaturityMixin.type = "Maturity"

kMaturityLevel = enum({ 'Newborn', 'Grown', 'Mature' })

MaturityMixin.networkVars =
{
}

MaturityMixin.expectedMixins =
{
    Live = "MaturityMixin will adjust max health/armor over time.", -- no it won't lol
}

MaturityMixin.optionalCallbacks = 
{
    GetMaturityRate = "Return individual maturity rate in seconds.",
    GetMatureMaxHealth = "Return individual maturity health.",
    GetMatureMaxArmor = "Return individual maturity armor.",
    OnMaturityComplete = "Callback once 100% maturity has been reached."
}

function MaturityMixin:GetMaturityLevel()

        return kMaturityLevel.Mature
end

function MaturityMixin:GetMaturityFraction()
    return 1
end

function MaturityMixin:GetIsMature()
    return true
end


if Server then


    function MaturityMixin:__initmixin()

            if Server then
                local newMaxHealth = (self.GetMatureMaxHealth and self:GetMatureMaxHealth())or LookupTechData(self:GetTechId(), kTechDataMaxHealth, 100)
                self:AdjustMaxHealth(newMaxHealth)

                local newMaxArmor = (self.GetMatureMaxArmor and self:GetMatureMaxArmor() ) or LookupTechData(self:GetTechId(), kTechDataMaxArmor, 0)
                self:AdjustMaxArmor(newMaxArmor)
                
            elseif Client then
                
                local model = self:GetRenderModel()
                if model then

                    model:SetMaterialParameter("maturity", 1)
                end
            
            end
            
    end

end