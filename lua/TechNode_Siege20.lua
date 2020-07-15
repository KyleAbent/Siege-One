/*
local origInit = TechNode.Initialize

function TechNode:Initialize(techId, techType, prereq1, prereq2)
    
    local oneHive = false
    local twoHive = false
    local threeHive = false
    
    if prereq1 == kTechId.BioMassOne or prereq1 == kTechId.BioMassTwo or prereq1 == kTechId.BioMassThree then
        oneHive = true
    elseif prereq1 == kTechId.BioMassFour or prereq1 == kTechId.BioMassFive or prereq1 == kTechId.BioMassSix then
        twoHive = true
    elseif prereq1 == kTechId.BioMassSeven or prereq1 == kTechId.BioMassThree or prereq1 == kTechId.BioMassFour then
        threeHive = true
    end
    
    if oneHive then
        origInit(self, techId, techType, kTechId.None, prereq2)
    elseif twoHive then
        origInit(self, techId, techType, kTechId.TwoHives, prereq2)
    elseif threeHive then
        origInit(self, techId, techType, kTechId.ThreeHives, prereq2)
    else
        origInit(self, techId, techType, prereq1, prereq2)
    end

end
*/