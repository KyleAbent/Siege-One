AvocaMixin = CreateMixin( AvocaMixin )
AvocaMixin.type = "Avoca"

AvocaMixin.networkVars =
{
    isacreditstructure = "boolean",   
}

function AvocaMixin:__initmixin()
    -- Print("%s initmiin avoca mixin", self:GetClassName())
    self.isacreditstructure = false
    if Server then
        self:AddSupply()
    end    
    --  Print("%s isacreditstructure is %s", self:GetClassName(), self.isacreditstructure)
end

function AvocaMixin:SetIsACreditStructure(boolean)
    self.isacreditstructure = boolean
    if Server and boolean == true then
        self:RemoveSupply()
    end        
    --Print("AvocaMixin SetIsACreditStructure %s isacreditstructure is %s", self:GetClassName(), self.isacreditstructure)
end

function AvocaMixin:GetCanStick()
     local canstick = not GetSetupConcluded()
     --Print("Canstick = %s", canstick)
     return canstick and self:GetIsACreditStructure() 
end

function AvocaMixin:GetIsACreditStructure()
    -- Print("AvocaMixin GetIsACreditStructure %s isacreditstructure is %s", self:GetClassName(), self.isacreditstructure)
    return self.isacreditstructure 
end


---This is taken from SupplyUserMixin I had to override and rearrange , this is the purpsoe of this AvocaMixin :/

if Server then
    function AvocaMixin:AddSupply()
        
        local team = self:GetTeam()
        if team and team.AddSupplyUsed then

            self.supplyCost = LookupTechData(self:GetTechId(), kTechDataSupply, 0)
            if self.supplyCost then
                team:AddSupplyUsed(self.supplyCost)
                self.supplyAdded = true   
            end    
     
        end
        
    end


    function AvocaMixin:RemoveSupply()
       
        if self.supplyAdded then
            
            local team = self:GetTeam()
            if team and team.RemoveSupplyUsed then
                
                team:RemoveSupplyUsed(self.supplyCost)
                self.supplyAdded = false
                
            end
            
        end
        
    end
    
    function AvocaMixin:OnKill()
        if not self.isacreditstructure then
            self:RemoveSupply()
        end    
    end

    function AvocaMixin:OnDestroy()
        if not self.isacreditstructure then
            self:RemoveSupply()
        end
    end
    
end


