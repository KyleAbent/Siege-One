local orig_AlienTeam_InitTechTree = AlienTeam.InitTechTree
function AlienTeam:InitTechTree()
    local orig_PlayingTeam_InitTechTree = PlayingTeam.InitTechTree
    PlayingTeam.InitTechTree = function() end
    orig_PlayingTeam_InitTechTree(self)
    local orig_TechTree_SetComplete = self.techTree.SetComplete
    self.techTree.SetComplete = function() end
    orig_AlienTeam_InitTechTree(self)
    self.techTree.SetComplete = orig_TechTree_SetComplete
    
self.techTree:AddBuildNode(kTechId.EggBeacon, kTechId.CragHive)
self.techTree:AddBuildNode(kTechId.StructureBeacon, kTechId.ShiftHive)
self.techTree:AddResearchNode(kTechId.PrimalScream, kTechId.BioMassFive, kTechId.None, kTechId.AllAliens)
self.techTree:AddResearchNode(kTechId.AcidRocket, kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)


    self.techTree:SetComplete()
    PlayingTeam.InitTechTree = orig_PlayingTeam_InitTechTree
end