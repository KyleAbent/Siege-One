local orig_MarineTeam_InitTechTree = MarineTeam.InitTechTree
function MarineTeam:InitTechTree()
    local orig_PlayingTeam_InitTechTree = PlayingTeam.InitTechTree
    PlayingTeam.InitTechTree = function() end
    orig_PlayingTeam_InitTechTree(self)
    local orig_TechTree_SetComplete = self.techTree.SetComplete
    self.techTree.SetComplete = function() end
    orig_MarineTeam_InitTechTree(self)
    self.techTree.SetComplete = orig_TechTree_SetComplete
    
      self.techTree:AddBuildNode(kTechId.Wall,     kTechId.None, kTechId.None)
      self.techTree:AddBuildNode(kTechId.BackupBattery,     kTechId.None, kTechId.None)
      self.techTree:AddBuyNode(kTechId.DualWelderExosuit, kTechId.ExosuitTech, kTechId.None)
      self.techTree:AddBuyNode(kTechId.DualFlamerExosuit, kTechId.ExosuitTech, kTechId.None)
      self.techTree:AddBuyNode(kTechId.DualGrenaderExosuit, kTechId.ExosuitTech, kTechId.None)
      self.techTree:AddTargetedActivation(kTechId.DropExosuit,     kTechId.ExosuitTech, kTechId.None)
      self.techTree:AddActivation(kTechId.AdvancedBeacon, kTechId.Observatory) 
      self.techTree:AddActivation(kTechId.SiegeBeacon, kTechId.Observatory)  
      self.techTree:AddBuyNode(kTechId.JumpPack,            kTechId.JetpackTech,         kTechId.None)
      self.techTree:AddUpgradeNode(kTechId.ArmoryBeefUp,  kTechId.AdvancedArmory)
      
    self.techTree:SetComplete()
    PlayingTeam.InitTechTree = orig_PlayingTeam_InitTechTree
    
 end