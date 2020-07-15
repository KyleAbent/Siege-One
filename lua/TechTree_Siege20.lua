--Replace the Alien Biomass and Weapons. < 3 == One Hive. > 4 and < 8 == Second hive. >=9 == Three Hive.
if Server then

    local Orig = TechTree.AddResearchNode
    function TechTree:AddResearchNode(techId, prereq1, prereq2, addOnTechId)
        
        local returnOrig = true        
        if prereq1 == kTechId.BioMassOne or prereq1 == kTechId.BioMassTwo or prereq1 == kTechId.BioMassThree then
            prereq1 = kTechId.None
            returnOrig = false
        elseif prereq1 == kTechId.BioMassFour or prereq1 == kTechId.BioMassFive or prereq1 == kTechId.BioMassSix then
            prereq1 = kTechId.TwoHives
            returnOrig = false
        elseif prereq1 == kTechId.BioMassSeven or prereq1 == kTechId.BioMassEight or prereq1 == kTechId.BioMassNine then
            prereq1 = kTechId.ThreeHives
            returnOrig = false
        end
        
        if returnOrig then
            Orig(self, techId, prereq1, prereq2, addOnTechId)
            return
        end
        --Original down below except for researchProgress
        local techNode = TechNode()
        techNode:Initialize(techId, kTechType.Research, prereq1, prereq2)
        techNode.researched = true
        techNode.researchProgress = 1

        if addOnTechId ~= nil then
        techNode.addOnTechId = addOnTechId
        end

        self:AddNode(techNode)    
    
    end


end