local networkVars = {

lastredeemorrebirthtime = "time", 
hasTriggered = "boolean",
  
 }
 local ogCreate = Alien.OnCreate
 
function Alien:OnCreate()
    ogCreate(self)
     self.lastredeemorrebirthtime = Shared.GetTime()
     self.hasTriggered = false

     if Server then
        self:AddTimedCallback(Alien.RedemptionTimer, 1) 
     end

end

function Alien:RedemptionTimer()
    if GetHasRedemptionUpgrade(self) and ( Shared.GetTime() > self.lastredeemorrebirthtime  + self:GetRedemptionCoolDown() ) then
        local threshold =   math.random(kRedemptionEHPThresholdMin,kRedemptionEHPThresholdMax)  / 100
        local scalar = self:GetHealthScalar()
        if scalar <= threshold  and not self.hasTriggered then
                self.hasTriggered = true   
                self:AddTimedCallback(Alien.RedemAlienToHive, math.random(0.2,2.5) )   
        end
    end
          return true
end

function Alien:GetRedemptionCoolDown()
    return kRedemptionCooldown
end

function Alien:GetEligableForRebirth()
    return Shared.GetTime() > self.lastredeemorrebirthtime  + self:GetRedemptionCoolDown() 
end

function Alien:RedemAlienToHive()
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
        
        self.hasTriggered = false
        
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

function Alien:GetOutOfComebat(player)
end
function Alien:TriggerRebirthRedeemCountdown(player)
end
function Alien:DoTriggerRebirthRedeemCountdown()
        local client = self:GetClient()
        if client then
            client = client:GetControllingPlayer()
            self:TriggerRebirthRedeemCountdown(client)
        end
        return false
end
function Alien:OnRedeem(player)
--self:GiveItem(HallucinationCloud.kMapName)
    if Server then
        SingleHallucination(self, player)
    end
    self:AddScore(1, 0, false)
    self:TriggerRebirthRedeemCountdown(player)
end
    
function Alien:ShowRedemptionSetting(player)

end

function Alien:ShowRebirthSetting(player)

end

function Alien:DoBothShows(player)
    self:ShowRedemptionSetting(player)
    self:ShowRebirthSetting(player)
end

function Alien:GetRebirthLength()
    return 5
end


local origKill = Alien.OnKill 
function Alien:OnKill(attacker, doer, point, direction) 
    if  GetHasRebirthUpgrade(self) and self:GetEligableForRebirth() then
        if Server then 
            if attacker and attacker:isa("Player")  then 
                local points = self:GetPointValue()
                    attacker:AddScore(points)
            end 
        end
        self:TriggerRebirth()
        return
    else
        origKill(self,attacker, doer, point, direction)
    end
end

function Alien:TriggerRebirth()

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

local hook = Alien.SetHatched
function Alien:SetHatched()
    hook(self)
    if  GetHasRebirthUpgrade(self) or  GetHasRedemptionUpgrade(self) then
        local client = self:GetClient()
        client = client:GetControllingPlayer()
        self:TriggerRebirthRedeemCountdown(client)
        self:AddTimedCallback(Alien.DoTriggerRebirthRedeemCountdown, 45) 
    end
    
    if GetHasThickenedSkinUpgrade(self)  then
        self:UpdateHealthAmount( self:GetTeam():GetBioMassLevel() )
    end
end


function Alien:AddKill()
    --ScoringMixin.AddKill(self)
    if GetHasHungerUpgrade(self) then
       self:AddHealth( self:GetMaxHealth() * 0.10 )
       self:AddEnergy(10)
       self:TriggerEnzyme(5)
    end
end

if Server then

    function Alien:UpdateHealthAmount(bioMassLevel)
       /*
        local healthPerBiomass = self:GetHealthPerBioMass()
        if healthPerBiomass == 0 then return end
        if GetHasThickenedSkinUpgrade(self) then
            local level = math.max(0, bioMassLevel - 1)
            local newBiomassHealth = level * healthPerBiomass
            Print("[A]UpdateHealthAmount newBiomassHealth is %s",newBiomassHealth)
            newBiomassHealth = newBiomassHealth * 1.10
            Print("[B]UpdateHealthAmount newBiomassHealth is %s",newBiomassHealth)
            if self.biomassHealth ~= newBiomassHealth then
            Print("[C] self.biomassHealth is %s", self.biomassHealth)
                local healthDelta = math.round(newBiomassHealth - self.biomassHealth)
                Print("[D] healthDelta is %s", healthDelta)
                self:AdjustMaxHealth(self:GetMaxHealth() + healthDelta)
                Print("[E] AdjustMaxHealth is %s", self:GetMaxHealth() )
                self.biomassHealth = newBiomassHealth
                Print("[F] self.biomassHealth is %s", self.biomassHealth)
            end
        end
     */
     
     if GetHasThickenedSkinUpgrade(self) then
        --Print("Old Max Healthh: %s", self:GetMaxHealth() )
        self:AdjustMaxHealth(self:GetMaxHealth() * 1.10)
        --Print("News Max Healthh: %s", self:GetMaxHealth() )
     end
    
    end

end


/*

Alien.kPrimaledViewMaterialName = "cinematics/vfx_materials/primal_view.material"
Alien.kPrimaledThirdpersonMaterialName = "cinematics/vfx_materials/primal.material"
Shared.PrecacheSurfaceShader("cinematics/vfx_materials/primal_view.surface_shader")
Shared.PrecacheSurfaceShader("cinematics/vfx_materials/primal.surface_shader")

if Client then

    function Alien:UpdatePrimalEffect(isLocal)
        if self.primaledClient ~= self.primaled then

            if isLocal then
            
                local viewModel= nil        
                if self:GetViewModelEntity() then
                    viewModel = self:GetViewModelEntity():GetRenderModel()  
                end
                    
                if viewModel then
       
                    if self.primaled then
                        self.primaledViewMaterial = AddMaterial(viewModel, Alien.kPrimaledViewMaterialName)
                    else
                    
                        if RemoveMaterial(viewModel, self.primaledViewMaterial) then
                            self.primaledViewMaterial = nil
                        end
      
                    end
                
                end
            
            end
            
            local thirdpersonModel = self:GetRenderModel()
            if thirdpersonModel then
            
                if self.primaled then
                    self.primaledMaterial = AddMaterial(thirdpersonModel, Alien.kPrimaledThirdpersonMaterialName)
                else
                
                    if RemoveMaterial(thirdpersonModel, self.primaledMaterial) then
                        self.primaledMaterial = nil
                    end

                end
            
            end
            
            self.primaledClient = self.primaled
            
        end

        // update cinemtics
        if self.primaled then

            if not self.lastprimaledEffect or self.lastprimaledEffect + kEnzymeEffectInterval < Shared.GetTime() then
            
                self:TriggerEffects("enzymed")
                self.lastprimaledEffect = Shared.GetTime()
            
            end

        end 

    end

    local origcupdate = Alien.UpdateClientEffects
    function Alien:UpdateClientEffects(deltaTime, isLocal)
         self:UpdatePrimalEffect(isLocal)
         origcupdate(self, deltaTime,isLocal)
    end

end//client


*/


Shared.LinkClassToMap("Alien", Alien.kMapName, networkVars, true)