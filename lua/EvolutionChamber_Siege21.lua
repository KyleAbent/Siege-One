--Override


EvolutionChamber.kUpgradeButtons ={                            
    [kTechId.CystMenu] = { kTechId.DoubleCystHP, kTechId.TripleCystHP, kTechId.QuadrupleCystHP, kTechId.DoubleCystArmor,
                           kTechId.TripleCystArmor, kTechId.QuadrupleCystArmor, kTechId.None, kTechId.None },
}

function EvolutionChamber:GetTechButtons(techId)

    local techButtons = { kTechId.CystMenu, kTechId.None, kTechId.None, kTechId.None,
                                kTechId.None, kTechId.None, kTechId.None, kTechId.None }
    
    local returnButton = kTechId.Return
    if self.kUpgradeButtons[techId] then
        techButtons = self.kUpgradeButtons[techId]
        returnButton = kTechId.RootMenu
    end
    
	techButtons[8] = returnButton
	
    if self:GetIsResearching() then
        techButtons[7] = kTechId.Cancel
    else
        techButtons[7] = kTechId.None
    end
    
    return techButtons
    
end

if Server then

    function EvolutionChamber:OnResearchComplete(researchId)
        if researchId == kTechId.DoubleCystHP or researchId == kTechId.TripleCystHP 
        or researchId == kTechId.QuadrupleCystHP or researchId == kTechId.DoubleCystArmor 
        or researchId == kTechId.TripleCystArmor or researchId == kTechId.QuadrupleCystArmor then
            AdjustCystsHPArmor()
        end

    end

end