local orig = TechNode.Initialize 

function TechNode:Initialize(techId, techType, prereq1, prereq2)
    if techId == kTechId.Contamination then
        prereq1 = kTechId.BioMassNine
    end
        orig(self,techId, techType, prereq1, prereq2)
end