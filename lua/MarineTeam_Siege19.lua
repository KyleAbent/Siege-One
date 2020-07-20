function MarineTeam:SpawnExtraIPS(techPoint)
    local techPointOrigin = techPoint:GetOrigin() + Vector(0, 2, 0)
     local ipCount = GetEntitiesWithinRange("InfantryPortal", techPoint:GetOrigin(), 99999999)
    for i = 1, 4 - #ipCount do
        local spawnOrigin = FindFreeIPSpace(techPointOrigin, 4, kInfantryPortalAttachRange)
        local ip = CreateEntity(InfantryPortal.kMapName, spawnOrigin,  1)
        ip:SetConstructionComplete()
    end
end
function MarineTeam:SpawnEverythingElse(techPoint)
            --if not spawnpoint is in techpoint location :/  --error prone if not written well lol
    local techPointOrigin = techPoint:GetOrigin() + Vector(0, 2, 0)

    local spawnOrigin = FindFreeMarineBaseConsSpace(techPointOrigin, 4, 20)
    local armory = CreateEntity(Armory.kMapName, spawnOrigin,  1) --adv
          armory:SetConstructionComplete()
          
          spawnOrigin = FindFreeMarineBaseConsSpace(armory:GetOrigin(), 4, 20)
    local obs = CreateEntity(Observatory.kMapName, spawnOrigin,  1)
          obs:SetConstructionComplete()
          
          spawnOrigin = FindFreeMarineBaseConsSpace(obs:GetOrigin(), 4, 20)
    local proto = CreateEntity(PrototypeLab.kMapName, spawnOrigin,  1)
          proto:SetConstructionComplete()
          
          spawnOrigin = FindFreeMarineBaseConsSpace(proto:GetOrigin(), 4, 20)
    local pg = CreateEntity(PhaseGate.kMapName, spawnOrigin,  1)
          pg:SetConstructionComplete()
          
          spawnOrigin = FindFreeMarineBaseConsSpace(pg:GetOrigin(), 4, 20)
    local bigmac = CreateEntity(BigMac.kMapName, spawnOrigin,  1)
          bigmac:SetConstructionComplete()

end
local origSpawnStruct = MarineTeam.SpawnInitialStructures
function MarineTeam:SpawnInitialStructures(techPoint)
    self:SpawnExtraIPS(techPoint)
    self:SpawnEverythingElse(techPoint)
    return origSpawnStruct(self, techPoint)
end


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
      self.techTree:AddBuildNode(kTechId.BigMac,     kTechId.None, kTechId.None)
      self.techTree:AddBuyNode(kTechId.DualWelderExosuit, kTechId.ExosuitTech, kTechId.None)
      self.techTree:AddBuyNode(kTechId.DualFlamerExosuit, kTechId.ExosuitTech, kTechId.None)
      self.techTree:AddTargetedActivation(kTechId.DropExosuit,     kTechId.ExosuitTech, kTechId.None)
      
    self.techTree:SetComplete()
    PlayingTeam.InitTechTree = orig_PlayingTeam_InitTechTree
    
 end