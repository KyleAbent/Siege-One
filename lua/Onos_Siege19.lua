--Kyle 'Avoca' Abent -- I don't want to update the GUIAlienBuyMenu - so this is easy to add a 4th weapon to onos to toggle on or off
Script.Load("lua/Weapons/Alien/GorillaGlue.lua")

local networkVars = {

lastredeemorrebirthtime = "time", 
hasRedeem = "boolean",  
hasRebirth = "boolean",
canredeemorrebirth = "boolean",
  
 }
 local ogCreate = Onos.OnCreate
 
function Onos:OnCreate()
    ogCreate(self)
     self.lastredeemorrebirthtime = Shared.GetTime()
     self.hasRedeem = false
     self.hasRebirth = false
     self.canRedeem = false
     self.canredeemorrebirth = false

     if Server then
        self:AddTimedCallback(Onos.RedemptionTimer, 1) 
     end

end

function Onos:RedemptionTimer()
    if self.hasRedeem then
        local threshold =   math.random(kRedemptionEHPThresholdMin,kRedemptionEHPThresholdMax)  / 100
        local scalar = self:GetHealthScalar()
        if scalar <= threshold  then
            self.canredeemorrebirth = Shared.GetTime() > self.lastredeemorrebirthtime  + self:GetRedemptionCoolDown()
            if self.canredeemorrebirth then
                self.canredeemorrebirth = false
                self:AddTimedCallback(Onos.RedemAlienToHive, math.random(0.2,2.5) ) 
            end      
        end
    end
          return true
end

function Alien:GetRedemptionCoolDown()
    return kRedemptionCooldown
end

function Onos:GetEligableForRebirth()
    return Shared.GetTime() > self.lastredeemorrebirthtime  + self:GetRedemptionCoolDown() 
end

function Onos:RedemAlienToHive()
    if self:GetEligableForRebirth() then
        self:TeleportToHive()
        local client = self:GetClient()
        if client then
            if client.GetIsVirtual and client:GetIsVirtual() then
                return 
            end
        end
        self.lastredeemorrebirthtime = Shared:GetTime()
        client = client:GetControllingPlayer()
        
        if client and self.OnRedeem then
            self:OnRedeem(client)
        end
        
        
        
    end
        return false
end
local function GetRelocationHive(usedhive, origin, teamnumber)
    local hives = GetEntitiesForTeam("Hive", teamnumber)
	local selectedhive
	
    for i, hive in ipairs(hives) do
			selectedhive = hive
	end
	return selectedhive
end
function Alien:TeleportToHive(usedhive)
	local selectedhive = GetRelocationHive(usedhive, self:GetOrigin(), self:GetTeamNumber())
    local success = false
    if selectedhive then 
            local position = table.random(selectedhive.eggSpawnPoints)
                SpawnPlayerAtPoint(self, position)
//               Shared.Message("LOG - %s SuccessFully Redeemed", self:GetClient():GetControllingPlayer():GetUserId() )
                success = true
    end
   
end
local function SingleHallucination(self, player)
  --Why a cloud ?
                local alien = player
                local newAlienExtents = LookupTechData(alien:GetTechId(), kTechDataMaxExtents)
                local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(newAlienExtents) 
                
                local spawnPoint = GetRandomSpawnForCapsule(newAlienExtents.y, capsuleRadius, alien:GetModelOrigin(), 0.5, 5)
                
                if spawnPoint then
                    local hallucinatedPlayer = CreateEntity(alien:GetMapName(), spawnPoint, self:GetTeamNumber())
                    hallucinatedPlayer.isHallucination = true
                    InitMixin(hallucinatedPlayer, PlayerHallucinationMixin)                
                    InitMixin(hallucinatedPlayer, SoftTargetMixin)                
                    InitMixin(hallucinatedPlayer, OrdersMixin, { kMoveOrderCompleteDistance = kPlayerMoveOrderCompleteDistance }) 
                    hallucinatedPlayer:SetName(alien:GetName())
                    hallucinatedPlayer:SetHallucinatedClientIndex(alien:GetClientIndex())
                end
                    
end

function Onos:GetOutOfComebat(player)
end
function Onos:TriggerRebirthRedeemCountdown(player)
end
function Onos:OnRedeem(player)
--self:GiveItem(HallucinationCloud.kMapName)
    if Server then
        SingleHallucination(self, player)
    end
    self:AddScore(1, 0, false)
    self:TriggerRebirthRedeemCountdown(player)
end

function Onos:ToggleRedemption()
    self.hasRedeem = not self.hasRedeem
end 

function Onos:DisableRebirth()
   self.hasRebirth = false
end

function Onos:ToggleRebirth()
    self.hasRebirth = not self.hasRebirth
end 

function Onos:DisableRedemption()
   self.hasRedeem = false
end
    
function Onos:ShowRedemptionSetting(player)

end

function Onos:ShowRebirthSetting(player)

end

function Onos:DoBothShows(player)
    self:ShowRedemptionSetting(player)
    self:ShowRebirthSetting(player)
end

function Onos:GetRebirthLength()
    return 5
end

if Server then

    function Onos:GetTierFourTechId()
        return kTechId.GorillaGlue
    end
    
end

local origKill = Onos.OnKill 
function Onos:OnKill() 
    if self.hasRebirth and self:GetEligableForRebirth() then
        if Server then 
            if attacker and attacker:isa("Player")  then 
                local points = self:GetPointValue()
                    attacker:AddScore(points)
            end 
        end
        self:TriggerRebirth()
        return
    else
        origKill(self)
    end
end

function Onos:TriggerRebirth()

        local position = self:GetOrigin()
        local trace = Shared.TraceRay(position, position + Vector(0, -0.5, 0), CollisionRep.Move, PhysicsMask.AllButPCs, EntityFilterOne(self))
        
            // Check for room
            local eggExtents = LookupTechData(kTechId.Embryo, kTechDataMaxExtents)
            local newLifeFormTechId = self:GetTechId() /// :P
            local upgradeManager = AlienUpgradeManager()
            upgradeManager:Populate(self)
             upgradeManager:AddUpgrade(lifeFormTechId)
            local newAlienExtents = LookupTechData(newLifeFormTechId, kTechDataMaxExtents)
            local physicsMask = PhysicsMask.Evolve
            
            -- Add a bit to the extents when looking for a clear space to spawn.
            local spawnBufferExtents = Vector(0.1, 0.1, 0.1)
            
             local evolveAllowed = self:GetIsOnGround() and GetHasRoomForCapsule(eggExtents + spawnBufferExtents, position + Vector(0, eggExtents.y + Embryo.kEvolveSpawnOffset, 0), CollisionRep.Default, physicsMask, self)

            local roomAfter
            local spawnPoint
       
            // If not on the ground for the buy action, attempt to automatically
            // put the player on the ground in an area with enough room for the new Alien.
            if not evolveAllowed then
            
                for index = 1, 100 do
                
                    spawnPoint = GetRandomSpawnForCapsule(eggExtents.y, math.max(eggExtents.x, eggExtents.z), self:GetModelOrigin(), 0.5, 5, EntityFilterOne(self))
  
                    if spawnPoint then
                        self:SetOrigin(spawnPoint)
                        position = spawnPoint
                        break 
                    end
                    
                end
            end   
            
            if not GetHasRoomForCapsule(newAlienExtents + spawnBufferExtents, self:GetOrigin() + Vector(0, newAlienExtents.y + Embryo.kEvolveSpawnOffset, 0), CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, nil, EntityFilterOne(self)) then
           
                for index = 1, 100 do

                    roomAfter = GetRandomSpawnForCapsule(newAlienExtents.y, math.max(newAlienExtents.x, newAlienExtents.z), self:GetModelOrigin(), 0.5, 5, EntityFilterOne(self))
                    
                    if roomAfter then
                        evolveAllowed = true
                        break
                    end

                end
                
            else
                roomAfter = position
                evolveAllowed = true
            end
            
            if evolveAllowed and roomAfter ~= nil then

                local newPlayer = self:Replace(Embryo.kMapName)
                position.y = position.y + Embryo.kEvolveSpawnOffset
                newPlayer:SetOrigin(position)
                // Clear angles, in case we were wall-walking or doing some crazy alien thing
                local angles = Angles(self:GetViewAngles())
                angles.roll = 0.0
                angles.pitch = 0.0
                newPlayer:SetOriginalAngles(angles)
                newPlayer:SetValidSpawnPoint(roomAfter)
                
                // Eliminate velocity so that we don't slide or jump as an egg
                newPlayer:SetVelocity(Vector(0, 0, 0))                
                newPlayer:DropToFloor()
                

               newPlayer:SetGestationData(upgradeManager:GetUpgrades(), newLifeFormTechId, 10, 10) //Skulk to X 
               newPlayer.gestationTime = self:GetRebirthLength()
               
               //Spawn protective boneshield    
                success = true
                
                
            else
               self:TeleportToHive()
            end    
            
end


Shared.LinkClassToMap("Onos", Onos.kMapName, networkVars, true)