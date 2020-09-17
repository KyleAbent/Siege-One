
function Marine:GetWeaponsToStore()
local toReturn = {}
            local weapons = self:GetWeapons()
            
          if weapons then
          
            for i = 1, #weapons do            
                weapons[i]:SetParent(nil)     
                local weapon
                table.insert(toReturn, weapons[i]:GetId())       
            end
            
           end
           
           return toReturn
end


function Marine:GiveExo(spawnPoint)
    local random = math.random(1,2)
    if random == 1 then 
        local exo = self:Replace(Exo.kMapName, self:GetTeamNumber(), false, spawnPoint, { layout = "MinigunMinigun", storedWeaponsIds = self:GetWeaponsToStore()  })
    return exo
    else
        local exo = self:Replace(Exo.kMapName, self:GetTeamNumber(), false, spawnPoint, { layout = "RailgunRailgun", storedWeaponsIds = self:GetWeaponsToStore() })
    return exo
    end

    
end

function Marine:GiveDualExo(spawnPoint)

    local exo = self:Replace(Exo.kMapName, self:GetTeamNumber(), false, spawnPoint, { layout = "MinigunMinigun", storedWeaponsIds = self:GetWeaponsToStore() })
    return exo
    
end
function Marine:GiveDualWelder(spawnPoint)

    local exo = self:Replace(Exo.kMapName, self:GetTeamNumber(), false, spawnPoint, { layout = "WelderWelder", storedWeaponsIds = self:GetWeaponsToStore() })
    return exo
    
end
function Marine:GiveDualFlamer(spawnPoint)

    local exo = self:Replace(Exo.kMapName, self:GetTeamNumber(), false, spawnPoint, { layout = "FlamerFlamer", storedWeaponsIds = self:GetWeaponsToStore() })
    return exo
    
end
function Marine:GiveDualGrenader(spawnPoint)

    local exo = self:Replace(Exo.kMapName, self:GetTeamNumber(), false, spawnPoint, { layout = "GrenaderGrenader", storedWeaponsIds = self:GetWeaponsToStore() })
    return exo
    
end
function Marine:GiveClawRailgunExo(spawnPoint)

    local exo = self:Replace(Exo.kMapName, self:GetTeamNumber(), false, spawnPoint, { layout = "ClawRailgun", storedWeaponsIds = self:GetWeaponsToStore() })
    return exo
    
end

function Marine:GiveDualRailgunExo(spawnPoint)

    local exo = self:Replace(Exo.kMapName, self:GetTeamNumber(), false, spawnPoint, { layout = "RailgunRailgun", storedWeaponsIds = self:GetWeaponsToStore() })
    return exo
    
end
kIsExoTechId = { [kTechId.DualFlamerExosuit] = true, [kTechId.DualMinigunExosuit] = true,
                 [kTechId.DualWelderExosuit] = true, [kTechId.DualRailgunExosuit] = true, [kTechId.DualGrenaderExosuit] = true }
                 
local function BuyExo(self, techId)

    local maxAttempts = 100
    for index = 1, maxAttempts do
    
        -- Find open area nearby to place the big guy.
        local capsuleHeight, capsuleRadius = self:GetTraceCapsule()
        local extents = Vector(Exo.kXZExtents, Exo.kYExtents, Exo.kXZExtents)

        local spawnPoint        
        local checkPoint = self:GetOrigin() + Vector(0, 0.02, 0)
        
        if GetHasRoomForCapsule(extents, checkPoint + Vector(0, extents.y, 0), CollisionRep.Move, PhysicsMask.Evolve, self) then
            spawnPoint = checkPoint
        else
            spawnPoint = GetRandomSpawnForCapsule(extents.y, extents.x, checkPoint, 0.5, 5, EntityFilterOne(self))
        end    
            
        local weapons 

        if spawnPoint then
        
            self:AddResources(-GetCostForTech(techId))
            
            local exo = nil
            
            if techId == kTechId.DualFlamerExosuit then
                exo = self:GiveDualFlamer(spawnPoint)
            elseif techId == kTechId.DualMinigunExosuit then
                exo = self:GiveDualExo(spawnPoint)
            elseif techId == kTechId.DualWelderExosuit then
                exo = self:GiveDualWelder(spawnPoint)
            elseif techId == kTechId.DualRailgunExosuit then
                exo = self:GiveDualRailgunExo(spawnPoint)
            elseif techId == kTechId.DualGrenaderExosuit then
                exo = self:GiveDualGrenader(spawnPoint)
            end
            

            
            exo:TriggerEffects("spawn_exo")
            
            return
            
        end
        
    end
    
    Print("Error: Could not find a spawn point to place the Exo")
    
end

local origattemptbuy = Marine.AttemptToBuy
function Marine:AttemptToBuy(techIds)

  local techId = techIds[1]
   
    local hostStructure = GetHostStructureFor(self, techId)

    if hostStructure then
    
        local mapName = LookupTechData(techId, kTechDataMapName)
        
        if mapName then
        
            Shared.PlayPrivateSound(self, Marine.kSpendResourcesSoundName, nil, 1.0, self:GetOrigin())
            
            if self:GetTeam() and self:GetTeam().OnBought then
                self:GetTeam():OnBought(techId)
            end
            
                 
              if kIsExoTechId[techId] then
                BuyExo(self, techId)    
               else
                if hostStructure:isa("Armory") then self:AddResources(-GetCostForTech(techId)) end -- o_O
                origattemptbuy(self, techIds)
            end
       end
   end
    

end

if Server then

    function Marine:GetCanEnterTunnel()
        return false
    end
    
    
    function Marine:DelayMedPack()
        self:AddTimedCallback(Marine.DelayedMedPack, 2)
    end
    
    function Marine:DelayedMedPack()
        local where = FindFreeSpace(self:GetOrigin(), 2, 5)
        local med = CreateEntity(MedPack.kMapName, where, 1)  
        self:SetResources( self:GetResources() - 1 )
        return false
    end
    
    function Marine:DelayAmmoPack()
        self:AddTimedCallback(Marine.DelayedAmmoPack, 2)
    end
    
    function Marine:DelayedAmmoPack()
        local where = FindFreeSpace(self:GetOrigin(), 2, 5)
        local med = CreateEntity(AmmoPack.kMapName, where, 1)  
        self:SetResources( self:GetResources() - 1 )
        return false
    end
    

end

Shared.LinkClassToMap("Marine", Marine.kMapName, networkVars)