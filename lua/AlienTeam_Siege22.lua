----------------override---------
function AlienTeam:UpdateBioMassLevel()
    --print("AlienTeam UpdateBioMassLevel Override")
    
   
    local newBiomass = 0
    
    for _, hive in ipairs(GetEntitiesForTeam("Hive", self:GetTeamNumber())) do
        if GetIsUnitActive(hive) then
            newBiomass = newBiomass + 3
        end
    end
    
    if newBiomass ~= self.maxBioMassLevel then
        self.maxBioMassLevel = newBiomass
    end    
    
    --Print("Biomass level is %s",  self.bioMassLevel)
    self:SetBiomassLevel(newBiomass)
   

end
---------------------------------------

function AlienTeam:SpawnHives(techPoint)
    for _, ent in ientitylist(Shared.GetEntitiesWithClassname("TechPoint")) do
        if ent ~= techPoint and ent:GetAttached() == nil then 
            local location = GetLocationForPoint(ent:GetOrigin())
            local mylocation = GetLocationForPoint(techPoint:GetOrigin())
            if location and mylocation and location.name == mylocation.name then
                local hive = ent:SpawnCommandStructure(2) 
                      hive:SetConstructionComplete()
            end
        elseif ent:GetAttached() then
            Print("Techpoint is already attached?!")
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

    self.techTree:AddResearchNode(kTechId.PrimalScream, kTechId.BioMassFive, kTechId.None, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.AcidRocket, kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)


    self.techTree:AddResearchNode(kTechId.CragStackOne, kTechId.BioMassThree, kTechId.CragHive, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.CragStackTwo, kTechId.BioMassSix, kTechId.CragStackOne, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.CragStackThree, kTechId.BioMassNine, kTechId.CragStackTwo, kTechId.AllAliens)

    self.techTree:AddBuyNode(kTechId.Hunger, kTechId.Spur, kTechId.None, kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.ThickenedSkin, kTechId.Spur, kTechId.None, kTechId.AllAliens)

    self.techTree:AddBuyNode(kTechId.Rebirth, kTechId.Shell, kTechId.None, kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.Redemption, kTechId.Shell, kTechId.None, kTechId.AllAliens)

    self.techTree:AddPassive(kTechId.CragHiveTwo, kTechId.CragHive)
    self.techTree:AddPassive(kTechId.ShiftHiveTwo, kTechId.ShiftHive)


    self.techTree:AddBuildNode(kTechId.EggBeacon, kTechId.CragHive)
    self.techTree:AddBuildNode(kTechId.StructureBeacon, kTechId.ShiftHive)
    self.techTree:AddBuildNode(kTechId.AlienPhaseGate, kTechId.BioMassNine)


    self.techTree:AddMenu(kTechId.CragMenu)
    self.techTree:AddMenu(kTechId.WhipMenu)
    self.techTree:AddMenu(kTechId.ShiftMenu)
    self.techTree:AddMenu(kTechId.ShadeMenu)
    
    self.techTree:AddBuildNode(kTechId.AlienTechPoint, kTechId.BioMassNine)
    self.techTree:AddActivation(kTechId.AlienTechPointHive, kTechId.None, kTechId.None, kTechId.AllAliens)
    
    

    
  

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



----This is a override to rid the requirement of Eggs being Skulk in order to spawn in. That's dumb. Ugh.
function AlienTeam:AssignPlayerToEgg(player, enemyTeamPosition)

    local success = false

    local spawnPoint = player:GetDesiredSpawnPoint()

    if not spawnPoint then
        spawnPoint = enemyTeamPosition or player:GetOrigin()
    end

    local eggs = GetEntitiesForTeam("Egg", self:GetTeamNumber())
    Shared.SortEntitiesByDistance(spawnPoint, eggs)

    -- Find the closest egg, doesn't matter which Hive owns it.
    for _, egg in ipairs(eggs) do

        -- Any unevolved egg is fine as long as it is free, and make sure its not a lifeform egg.
        if egg:GetIsFree() then

            --if egg:GetGestateTechId() == kTechId.Skulk then

                egg:SetQueuedPlayerId(player:GetId())
                success = true
                break

            --end

        end

    end

    return success

end