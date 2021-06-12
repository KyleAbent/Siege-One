
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
   
self.techTree:AddBuildNode(kTechId.LoneCyst, kTechId.None) 
self.techTree:AddBuildNode(kTechId.EggBeacon, kTechId.CragHive)
self.techTree:AddBuildNode(kTechId.StructureBeacon, kTechId.ShiftHive)
self.techTree:AddBuildNode(kTechId.AlienTechPoint, kTechId.None)
self.techTree:AddResearchNode(kTechId.PrimalScream, kTechId.BioMassFive, kTechId.None, kTechId.AllAliens)
self.techTree:AddResearchNode(kTechId.AcidRocket, kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)
self.techTree:AddResearchNode(kTechId.GorillaGlue, kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)

self.techTree:AddResearchNode(kTechId.DoubleCystHP, kTechId.None, kTechId.None, kTechId.AllAliens)
self.techTree:AddResearchNode(kTechId.TripleCystHP, kTechId.DoubleCystHP, kTechId.None, kTechId.AllAliens)
self.techTree:AddResearchNode(kTechId.QuadrupleCystHP, kTechId.TripleCystHP, kTechId.None, kTechId.AllAliens)
self.techTree:AddResearchNode(kTechId.DoubleCystArmor, kTechId.None, kTechId.None, kTechId.AllAliens)
self.techTree:AddResearchNode(kTechId.TripleCystArmor, kTechId.DoubleCystArmor, kTechId.None, kTechId.AllAliens)
self.techTree:AddResearchNode(kTechId.QuadrupleCystArmor, kTechId.TripleCystArmor, kTechId.None, kTechId.AllAliens)

self.techTree:AddBuyNode(kTechId.Hunger, kTechId.Spur, kTechId.None, kTechId.AllAliens)
self.techTree:AddBuyNode(kTechId.ThickenedSkin, kTechId.Spur, kTechId.None, kTechId.AllAliens)

 self.techTree:AddBuyNode(kTechId.Rebirth, kTechId.Shell, kTechId.None, kTechId.AllAliens)
 self.techTree:AddBuyNode(kTechId.Redemption, kTechId.Shell, kTechId.None, kTechId.AllAliens)
 
 self.techTree:AddActivation(kTechId.AlienTechPointHive, kTechId.None, kTechId.None, kTechId.AllAliens)
 
 
                                                //biomass seven or???
 self.techTree:AddResearchNode(kTechId.LerkLift, kTechId.BioMassTwelve, kTechId.None, kTechId.AllAliens)
 
 
     self.techTree:AddPassive(kTechId.CragHiveTwo, kTechId.CragHive)
    self.techTree:AddPassive(kTechId.ShiftHiveTwo, kTechId.ShiftHive)

self.techTree:AddUpgradeNode(kTechId.HiveLifeInsurance,  kTechId.None)

self.techTree:AddMenu(kTechId.CystMenu)

    self.techTree:SetComplete()
    PlayingTeam.InitTechTree = orig_PlayingTeam_InitTechTree
end

----Override

local kUpgradeStructureTable =
{
    {
        name = "Shell",
        techId = kTechId.Shell,
        upgrades = {
            kTechId.Vampirism, kTechId.Carapace, kTechId.Regeneration, kTechId.Redemption, kTechId.Rebirth
        }
    },
    {
        name = "Veil",
        techId = kTechId.Veil,
        upgrades = {
            kTechId.Camouflage, kTechId.Aura, kTechId.Focus
        }
    },
    {
        name = "Spur",
        techId = kTechId.Spur,
        upgrades = {
            kTechId.Crush, kTechId.Celerity, kTechId.Adrenaline
        }
    }
}
function AlienTeam.GetUpgradeStructureTable()
    return kUpgradeStructureTable
end
