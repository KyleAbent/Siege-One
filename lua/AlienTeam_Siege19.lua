
function AlienTeam:SpawnHives(techPoint)
    for _, ent in ientitylist(Shared.GetEntitiesWithClassname("TechPoint")) do
        if ent ~= techPoint and ent:GetAttached() == nil then 
            local location = GetLocationForPoint(ent:GetOrigin())
            local mylocation = GetLocationForPoint(techPoint:GetOrigin())
            if location and mylocation and location == mylocation then
                local hive = ent:SpawnCommandStructure(2) 
                      hive:SetConstructionComplete()
            end
        end
    end

end

local origSpawnStruct = AlienTeam.SpawnInitialStructures
function AlienTeam:SpawnInitialStructures(techPoint)

    self:SpawnHives(techPoint)
    return origSpawnStruct(self, techPoint)
end



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
self.techTree:AddResearchNode(kTechId.GorillaGlue, kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)


    self.techTree:SetComplete()
    PlayingTeam.InitTechTree = orig_PlayingTeam_InitTechTree
end