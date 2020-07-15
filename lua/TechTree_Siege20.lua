--Kyle 'Avoca' Abent
if Server then

    local Orig = TechTree.AddResearchNode
    function TechTree:AddResearchNode(techId, prereq1, prereq2, addOnTechId)
       -- Print("UHHH")
        local returnOrig = true 

        --Hive Weaponss       
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
        
        
        --Armory Weapons, CC.
        if techId == kTechId.ShotgunTech or techId == kTechId.GrenadeTech or techId == kTechId.MinesTech or techId == kTechId.AdvancedMarineSupport 
        or techId == kTechId.PhaseTech then
            returnOrig = false
        end
        
        --Proto
        if techId == kTechId.JetpackTech or techId == kTechId.ExosuitTech then
            returnOrig = false
        end
        
        
        --Armslab
        if techId == kTechId.Armor1 or techId == kTechId.Armor2 or techId == kTechId.Armor3 or
        techId == kTechId.Weapons1 or techId == kTechId.Weapons2 or techId == kTechId.Weapons3 then 
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
        
        
        --try for marines. test it wont break aliens if it works marines. 
        techNode.hasTech = true

        if addOnTechId ~= nil then
        techNode.addOnTechId = addOnTechId
        end

        self:AddNode(techNode)    
    
    end


end