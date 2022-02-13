class 'StructureBeacon' (AlienBeacon)

StructureBeacon.kModelName =  PrecacheAsset("models/alien/spur/spur.model")
local kAnimationGraph = PrecacheAsset("models/alien/spur/spur.animation_graph")

StructureBeacon.kMapName = "structurebeacon"

function StructureBeacon:OnInitialized()
AlienBeacon.OnInitialized(self)
    self:SetModel(StructureBeacon.kModelName, kAnimationGraph)
end
local kLifeSpan = 9

local networkVars = { }

local function TimeUp(self)

    --self:Kill()
    DestroyEntity(self)
    return false

end
local function GetIsACreditStructure(who)
local boolean = HasMixin(who, "Avoca") and who:GetIsACreditStructure()  or false
--Print("isacredit structure is %s", boolean)
return boolean

end
    function StructureBeacon:GetTotalConstructionTime()
    local value =  ConditionalValue(GetIsInSiege(self), kStructureBeaconBuildTime * 2, kStructureBeaconBuildTime)
    return value
    end
function StructureBeacon:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.Spur
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end
local function GetIsStructureSiegeWall(self, structure)
 if structure:isa("Whip") then return false end
 local hives = GetEntitiesWithinRange("Hive", structure:GetOrigin(), 17)

 if #hives >=1 then return true end
return false
 
end
if Server then

    function StructureBeacon:OnConstructionComplete()
        self:AddTimedCallback(TimeUp, kLifeSpan )  
        self:Magnetize()
         self:AddTimedCallback(StructureBeacon.Magnetize, 1)
    end
    function StructureBeacon:Magnetize()
      local entity = {}
      
    for _, structure in ipairs(GetEntitiesWithMixinForTeamWithinRange("Supply", 2, self:GetOrigin(), 99999)) do
         if  ( structure:isa("Whip") or structure:isa("Crag") or structure:isa("Shade") or structure:isa("Shift") )
            and self:GetDistance(structure) >= 12 and not ( structure.GetIsMoving and structure:GetIsMoving() ) 
            and structure:GetIsBuilt() and not GetIsStructureSiegeWall(self, structure) then
                table.insert(entity,structure)
                break//Well Just one at a time I Guess
         end
      end
      
      for i = 1, #entity do//Well Just in case I want more than one , heh.
         local structure = entity[i]
            if self:GetIsAlive() then
                   local success = false 
                            if HasMixin(entity, "Obstacle") then  entity:RemoveFromMesh()end
                            success = structure:SetOrigin( FindFreeSpace(self:GetOrigin(), .5, 7 ) )
                             if HasMixin(structure, "Obstacle") then
                                if structure.obstacleId == -1 then structure:AddToMesh() end
                             end
                             //structure:Check()
                             if structure:isa("Whip") then  
                                structure. rooted = true 
                                structure:Root() 
                             end
                            if success then return self:GetIsAlive() end
                       
                       --  structure:ClearOrders()
                        -- success = structure:GiveOrder(kTechId.Move, self:GetId(), FindFreeSpace(self:GetOrigin(), .5, 7), nil, true, true) 
                      --  if success then return self:GetIsAlive() end
                       
            end
      end
return self:GetIsAlive()
  end
  
         function StructureBeacon:OnDestroy()
        ScriptActor.OnDestroy(self)
         end 
end //
Shared.LinkClassToMap("StructureBeacon", StructureBeacon.kMapName, networkVars)