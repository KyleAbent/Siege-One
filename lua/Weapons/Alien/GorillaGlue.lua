--Kyle 'Avoca' Abent
Script.Load("lua/Weapons/Alien/Ability.lua")
--Script.Load("lua/Weapons/Alien/StompMixin.lua")

class 'GorillaGlue' (Ability)

GorillaGlue.kMapName = "gorillaglue"

local networkVars =
{
   
}
--AddMixinNetworkVars(StompMixin, networkVars)

function GorillaGlue:OnCreate()

    Ability.OnCreate(self)
    self.dropping = false
    self.mouseDown = false
    self.lastClickedPosition = nil
    self.lastClickedPositionNormal = nil

end


function GorillaGlue:GetEnergyCost()
    return 80
end

function GorillaGlue:GetAnimationGraphName()
    return kAnimationGraph
end

function GorillaGlue:GetHUDSlot()
    return 3
end

    
function GorillaGlue:IsOnCooldown()
    -- local boolean = self:GetFuel() < 0.9
     --Print("IsOnCooldown is %s", boolean)
     return false
end
function GorillaGlue:IsOnCooldown()
    --do delay here lol
     return false
end

local function FilterBabblersAndTwo(ent1, ent2)
    return function (test) return test == ent1 or test == ent2 or test:isa("Babbler") end
end

function GorillaGlue:GetPositionForStructure(startPosition, direction, lastClickedPosition, lastClickedPositionNormal)


    local validPosition = false
    local range = 4 --structureAbility:GetDropRange(lastClickedPosition)
    local origin = startPosition + direction * range
    local player = self:GetParent()

    -- Trace short distance in front
    local trace = Shared.TraceRay(player:GetEyePos(), origin, CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, FilterBabblersAndTwo(player, self))

    local displayOrigin = trace.endPoint


    -- If we hit nothing, try a slightly bigger ray
    if trace.fraction == 1 then
        local boxTrace = Shared.TraceBox(Vector(0.2,0.2,0.2), player:GetEyePos(), origin,  CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, EntityFilterTwo(player, self))
        if boxTrace.entity and boxTrace.entity:isa("Web") then
            trace = boxTrace
        end

    end

    -- If we still hit nothing, trace down to place on ground
    if trace.fraction == 1 then
        origin = startPosition + direction * range
        trace = Shared.TraceRay(origin, origin - Vector(0, range, 0), CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, FilterBabblersAndTwo(player, self))
    end

    -- If it hits something, position on this surface (must be the world or another structure)
    if trace.fraction < 1 then

        if trace.entity == nil then
            validPosition = true
        end

        displayOrigin = trace.endPoint
    end


    if trace.normal:DotProduct(GetNormalizedVector(startPosition - trace.endPoint)) < 0 then --backfacing
        validPosition = false
    end

    -- Don't allow dropped structures to go too close to techpoints and resource nozzles
    if GetPointBlocksAttachEntities(displayOrigin) then
        validPosition = false
    end

   -- if not structureAbility:GetIsPositionValid(displayOrigin, player, trace.normal, lastClickedPosition, lastClickedPositionNormal, trace.entity) then
    --    validPosition = false
   -- end

    if trace.surface == "nocling" then
        validPosition = false
    end

    -- Don't allow placing above or below us and don't draw either
    local structureFacing = Vector(direction)

    if math.abs(Math.DotProduct(trace.normal, structureFacing)) > 0.9 then
        structureFacing = trace.normal:GetPerpendicular()
    end

    -- Coords.GetLookIn will prioritize the direction when constructing the coords,
    -- so make sure the facing direction is perpendicular to the normal so we get
    -- the correct y-axis.
    local perp = Math.CrossProduct( trace.normal, structureFacing )
    structureFacing = Math.CrossProduct( perp, trace.normal )

    local coords = Coords.GetLookIn( displayOrigin, structureFacing, trace.normal )

    --if structureAbility.ModifyCoords then
    --    structureAbility:ModifyCoords(coords, lastClickedPosition, trace.normal, player)
   -- end

    -- perform a final check to ensure the gorge isn't trying to build from inside a clog.
    if GetIsPointInsideClogs(player:GetEyePos()) then
        validPosition = false
    end

    return coords, validPosition, trace.entity, trace.normal

end
function GorillaGlue:OnPrimaryAttack(player)

    if self:GetEnergyCost() < player:GetEnergy() then 
        local success = false

        -- Ensure the current location is valid for placement.
        local coords, valid, _, normal = self:GetPositionForStructure(player:GetEyePos(), player:GetViewCoords().zAxis, self.lastClickedPosition, self.lastClickedPositionNormal)
        local secondClick = true

        --if LookupTechData(self:GetActiveStructure().GetDropStructureId(), kTechDataSpecifyOrientation, false) then
        --    secondClick = self.lastClickedPosition ~= nil
       -- end

        if secondClick then

            if valid then

                -- Ensure they have enough resources.
                --local cost = GetCostForTech(self:GetActiveStructure().GetDropStructureId())
               -- if player:GetResources() >= cost and not self:GetHasDropCooldown() then

                    --local message = BuildGorgeDropStructureMessage(player:GetEyePos(), player:GetViewCoords().zAxis, self.activeStructure, self.lastClickedPosition, self.lastClickedPositionNormal)
                    --Client.SendNetworkMessage("GorgeBuildStructure", message, true)
                    --self.timeLastDrop = Shared.GetTime()
                    player:DeductAbilityEnergy(self:GetEnergyCost())
                    if Server then
                        local bonewall = CreateEntity(BoneWall.kMapName, self.lastClickedPosition, 2)
                    end
                    success = true

               -- end

            end

            self.lastClickedPosition = nil
            self.lastClickedPositionNormal = nil

        elseif valid then
            self.lastClickedPosition = Vector(coords.origin)
            self.lastClickedPositionNormal = normal

        end

        if not valid then
            player:TriggerInvalidSound()
        end
    end
    
    return success

end

function GorillaGlue:OnPrimaryAttackEnd(player)
    
    if self.primaryAttacking then 
    
        --self:SetFuel( self:GetFuel() ) -- set it now, because it will go up from this point
        self.primaryAttacking = false
    
    end
    
end

function GorillaGlue:OnSecondaryAttack(player)
  --Print("Umm123")
    if not self.secondaryAttacking and not self.primaryAttacking then
          -- Print("Energy cost is %s, player energy is %s, player has more energy is %s", self:GetEnergyCost(),  player:GetEnergy(), self:GetEnergyCost() < player:GetEnergy())
          
          
        if player:GetIsOnGround() and self:GetEnergyCost() < player:GetEnergy() then
           --     Print("Umm")
            player:DeductAbilityEnergy(self:GetEnergyCost())
            
            --self:SetFuel( self:GetFuel() ) -- set it now, because it will go down from this point
            self.secondaryAttacking = true
        end
    end

end
function GorillaGlue:GetHasSecondary(player)
    return true
end
function GorillaGlue:OnSecondaryAttackEnd(player)
    
    if self.secondaryAttacking then 
    
        --self:SetFuel( self:GetFuel() ) -- set it now, because it will go up from this point
        self.secondaryAttacking = false
    
    end
    
end

function GorillaGlue:OnUpdateAnimationInput(modelMixin)

    local activityString = "none"
    local abilityString = "boneshield"
    
    if self.primaryAttacking then
        activityString = "primary" -- TODO: set anim input
    end
    
    modelMixin:SetAnimationInput("ability", abilityString)
    modelMixin:SetAnimationInput("activity", activityString)
    
end

function GorillaGlue:OnHolster(player)
    
    Ability.OnHolster(self, player)
    
    self:OnPrimaryAttackEnd(player)
    
end

function GorillaGlue:GetShowGhostModel()
    return true --self.activeStructure ~= nil and not self:GetHasDropCooldown()
end

function GorillaGlue:GetGhostModelCoords()
    return self.ghostCoords
end

function GorillaGlue:GetIsPlacementValid()
    return self.placementValid
end

function GorillaGlue:GetGhostModelTechId()
        return kTechId.BoneWall

end

function GorillaGlue:GetGhostModelName(ability)
    return BoneWall.kModelName
end

function GorillaGlue:GetIgnoreGhostHighlight()
    return false
end


if Client then

    function GorillaGlue:OnProcessIntermediate(input)

        local player = self:GetParent()
        local viewDirection = player:GetViewCoords().zAxis

        if player then --and self.activeStructure then

            self.ghostCoords, self.placementValid = self:GetPositionForStructure(player:GetEyePos(), viewDirection, self.lastClickedPosition, self.lastClickedPositionNormal)

            --if player:GetResources() < LookupTechData(self:GetActiveStructure():GetDropStructureId(), kTechDataCostKey) then
               if self:GetEnergyCost() < player:GetEnergy() then 
                self.placementValid = false
              end
            --end

        end

    end
    
    
 end   

Shared.LinkClassToMap("GorillaGlue", GorillaGlue.kMapName, networkVars)