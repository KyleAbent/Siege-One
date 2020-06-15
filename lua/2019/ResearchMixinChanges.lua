//Kyle 'Avoca' Abent
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
            
            //print("DoResearches [D]")
            //local techId = table.random(techIds)
            for i = 1, #techIds do
            local techId = techIds[i]
            if techId and techId ~= kTechId.None and techId ~= kTechId.Recycle and techId ~= kTechId.Consume then
                //print("DoResearches [E]")
                if not GetHasTech(self, techId)  then
                    //print("DoResearches [F]")
                    local tree = GetTechTree(self:GetTeamNumber())
                    local techNode = tree:GetTechNode(techId)
                    if tree:GetTechAvailable(techId) or self:isa("Hive") then //biomass exception
                         //print("DoResearches [G]")
                        techNode:SetHasTech(true)
                        tree:SetTechNodeChanged(techNode, string.format("hasTech = %s", true ))
                        techNode:SetResearched(true)
                        tree:QueueOnResearchComplete(techId, self)
                   end
               end
            end
           end
        
        //Hold off on the "Not Being Researched" // duplication issue ... 
        local shouldStop = false
         if self:isa("ArmsLab") then
            shouldStop = GetHasTech(self, kTechId.Armor3) and GetHasTech(self, kTechId.Weapons3)
         elseif self:isa("Hive") then
            return self.bioMassLevel == 4 // ? hm lol. Biomasslevel == 3??? 
         elseif self:isa("EvolutionChamber") then
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