//Kyle 'Avoca' Abent
local function doHiveRule(self, techIds)
    for i = 1, #techIds do
        local techId = techIds[i]
        if techId then
        //if not GetHasTech(self, techId)  then //removing this as test although biomass duplicates.. just to see if prevent bug?
            local tree = GetTechTree(self:GetTeamNumber())
            local techNode = tree:GetTechNode(techId)
            if not self:GetIsResearching() then 
                techNode:SetHasTech(true)
                tree:SetTechNodeChanged(techNode, string.format("hasTech = %s", true ))
                techNode:SetResearched(true)
                tree:QueueOnResearchComplete(techId, self)
                notifycommander(self,techId)
            end
        end
    end
end
local function doArmsEvoRule(self, techIds)
    for i = 1, #techIds do
        local techId = techIds[i]
        if techId then
            if not GetHasTech(self, techId)  then
                local tree = GetTechTree(self:GetTeamNumber())
                local techNode = tree:GetTechNode(techId)
                if not self:GetIsResearching() and tree:GetTechAvailable(techId)  then //biomass exception
                    techNode:SetHasTech(true)
                    tree:SetTechNodeChanged(techNode, string.format("hasTech = %s", true ))
                    techNode:SetResearched(true)
                    tree:QueueOnResearchComplete(techId, self)
                    notifycommander(self,techId)
                end
            end
        end
    end
end
if Server then
    local function GimmeFree(self)
         
    if (self.GetIsBuilt and not self:GetIsBuilt()) then
            return true 
         end
         
        if (self.GetIsPowered and not self:GetIsPowered()) then 
            return true 
        end

            local techIds = {}
            if self:isa("EvolutionChamber") then
                table.insert(techIds, kTechId.Charge )
                table.insert(techIds, kTechId.BileBomb )
                table.insert(techIds, kTechId.MetabolizeEnergy )
                table.insert(techIds, kTechId.Leap )
                table.insert(techIds, kTechId.Spores )
                table.insert(techIds, kTechId.Umbra )
                table.insert(techIds, kTechId.MetabolizeHealth )
                table.insert(techIds, kTechId.BoneShield )
                table.insert(techIds, kTechId.Stab )
                table.insert(techIds, kTechId.Stomp )
                table.insert(techIds, kTechId.Xenocide )
            elseif self:isa("Hive") then
                table.insert(techIds, kTechId.ResearchBioMassOne )
                table.insert(techIds, kTechId.ResearchBioMassTwo )
                table.insert(techIds, kTechId.ResearchBioMassThree )
            elseif self:isa("ArmsLab") then
                 table.insert(techIds, kTechId.Armor1 )
                 table.insert(techIds, kTechId.Weapons1 )
                 table.insert(techIds, kTechId.Armor2 )
                 table.insert(techIds, kTechId.Weapons2 )
                 table.insert(techIds, kTechId.Armor3 )
                 table.insert(techIds, kTechId.Weapons3 )
            end
            
            if techIds == nil or #techIds == 0 then 
                Print("Removing self from ResearchMixinChanges GimmeFree TimedCallBack")
                Print(self:GetMapName())
                return false 
            end 
        
        local shouldStop = false
         if self:isa("ArmsLab") then
            doArmsEvoRule(self, techIds)
            shouldStop = GetHasTech(self, kTechId.Armor3) and GetHasTech(self, kTechId.Weapons3)
         elseif self:isa("Hive") then
             doHiveRule(self, techIds)
            shouldStop = self.bioMassLevel == 4 // ? hm lol. Biomasslevel == 3??? 
         elseif self:isa("EvolutionChamber") then
            doArmsEvoRule(self, techIds)
            shouldStop = GetHasTech(self, kTechId.Xenocide)
         end
        
        if shouldStop == true then
            print("Removing self from ResearchMixinChanges GimmeFree TimedCallBack")
            print(self:GetMapName())
            return false
        end
        
        return true
        
    end


    local origInit = ResearchMixin.__initmixin

    function ResearchMixin:__initmixin()
        origInit(self) //Messy for all non others to call this but whatever deal with it, code is from Siege Zero lol
            if self:isa("ArmsLab") or self:isa("Hive") or self:isa("EvolutionChamber") then
                self:AddTimedCallback(GimmeFree, 4) 
            end
    end
    




end