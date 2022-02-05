if Server then

-- overwrite get rid of scale with player count

    function Hive:UpdateSpawnEgg()

        local success = false
        local egg

        local eggCount = self:GetNumEggs()
        if eggCount < kAlienEggsPerHive then

            egg = self:SpawnEgg()
            success = egg ~= nil

        end

        return success, egg

    end

    function Hive:HatchEggs() --overwrite get rid of scaleplayer
        local amountEggsForHatch = kEggsPerHatch
        local eggCount = 0
        for i = 1, amountEggsForHatch do
            local egg = self:SpawnEgg(true)
            if egg then eggCount = eggCount + 1 end
        end

        if eggCount > 0 then
            self:TriggerEffects("hatch")
            return true
        end

        return false
    end


    function Hive:GetNumEggs() --Well all 3 hives in same location, and if each hive is suppose to have X eggs then assign them the hive id via egg

        local numEggs = 0
        local eggs = GetEntitiesForTeam("Egg", self:GetTeamNumber())

        for index, egg in ipairs(eggs) do

            if self == egg:GetHive() and egg:GetIsAlive() and egg:GetIsFree() and not egg.manuallySpawned then
                numEggs = numEggs + 1
            end

        end

        return numEggs

    end

    local ogResearch = Hive.OnResearchComplete
    function Hive:OnResearchComplete(researchId)
         
         --Prevent two hives from having the same type
         if  researchId ==  kTechId.UpgradeToCragHive then
            if GetHasHiveType(kTechId.CragHive) then
                self:SetTechId(kTechId.Hive) 
                return 
            end
         elseif researchId == kTechId.UpgradeToShiftHive then
            if GetHasHiveType(kTechId.ShiftHive) then 
                self:SetTechId(kTechId.Hive) 
                return 
            end
         elseif researchId == kTechId.UpgradeToShadeHive then
            if GetHasHiveType(kTechId.ShadeHive) then 
                self:SetTechId(kTechId.Hive) 
                return 
            end
         end
         ogResearch(self, researchId)
    end
    
    function Hive:DoResearch(what, isbiomass)
        if isbiomass or not GetTechTree(self:GetTeamNumber()):GetHasTech(what) then
            --self:OnResearchComplete(what)
            --self:GetTeam():GetTechTree():SetTechChanged()
            
                local techTree = self:GetTeam():GetTechTree()
                local researchNode = techTree:GetTechNode(what)
                
                if researchNode then     
           
                    researchNode:SetResearchProgress(1)
                    techTree:SetTechNodeChanged(researchNode, string.format("researchProgress = %.2f", self.researchProgress))
                    researchNode:SetResearched(true)
                    techTree:QueueOnResearchComplete(what, self)
                    
                end
        
        end
    end
    
    function Hive:WeaponsTimer()
    local biomass = self:GetTeam():GetBioMassLevel()

        if biomass >=3 then
            --print("Biomass 3!")
            self:DoResearch(kTechId.BileBomb, false)
            self:DoResearch(kTechId.MetabolizeEnergy, false)
            self:DoResearch(kTechId.MetabolizeHealth, false)
            self:DoResearch(kTechId.Charge, false)
        end    
        if biomass >=6 then
            --print("Biomass 6!")
            self:DoResearch(kTechId.Leap, false)
            self:DoResearch(kTechId.Umbra, false)
            self:DoResearch(kTechId.Spores, false)
            self:DoResearch(kTechId.BoneShield, false)
         end
        if biomass >=9 then
            --print("Biomass 9!")
            self:DoResearch(kTechId.Stab, false)
            self:DoResearch(kTechId.Stomp, false)
            self:DoResearch(kTechId.Xenocide, false)
        end

        return false    

    end


    local orig = Hive.OnConstructionComplete
    function Hive:OnConstructionComplete()
            orig(self)
            self.bioMassLevel = 3
            self:DoResearch(kTechId.ResearchBioMassOne, true)
            self:DoResearch(kTechId.ResearchBioMassTwo, true)
            self:DoResearch(kTechId.ResearchBioMassThree, true)
            
         if Server then
            self:AddTimedCallback(Hive.WeaponsTimer, math.random(4,16)) 
         end
            
    end

end --server



//Shared.LinkClassToMap("Hive", Hive.kMapName, networkVars, true)