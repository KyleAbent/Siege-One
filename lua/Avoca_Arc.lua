Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")

local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origInit = ARC.OnInitialized
function ARC:OnInitialized()
    origInit(self)
    InitMixin(self, LevelsMixin)
    InitMixin(self, AvocaMixin)
end

Shared.LinkClassToMap("ARC", ARC.kMapName, networkVars)


-----------------------------------
class 'AvocaArc' (ARC)


PrecacheAsset("Glow/green/GlowTP.surface_shader")
local kAvocaWeedMaterial = PrecacheAsset("Glow/green/green.material")

AvocaArc.kMapName = "avocaarc"
AvocaArc.kMoveSpeed = 2

local networkVars = 
{
 lastNearby = "time",
 spawnLoc = "vector",
}

local function GiveDeploy(who)
    --Print("GiveDeploy")
    who:GiveOrder(kTechId.ARCDeploy, who:GetId(), who:GetOrigin(), nil, true, true)
    who:GiveScan()
end

local function GiveUnDeploy(who)
     --Print("GiveUnDeploy")
     who:CompletedCurrentOrder()
     who:SetMode(ARC.kMode.Stationary)
     who.deployMode = ARC.kDeployMode.Undeploying
     who:TriggerEffects("arc_stop_charge")
     who:TriggerEffects("arc_undeploying")
end

function AvocaArc:OnAdjustModelCoords(coords)
    
    	local scale = 1.5
        coords.xAxis = coords.xAxis * scale
        coords.yAxis = coords.yAxis * scale
        coords.zAxis = coords.zAxis * scale
        
    return coords
    
end

if Server then   
function AvocaArc:OnInitialized()
     ARC.OnInitialized(self)
     self.lastNearby = 0
     self.spawnLoc = self:GetOrigin()
     self:AddTimedCallback(AvocaArc.Instruct, 2.5)

end
//if this is exploitable then move it out of server 
function AvocaArc:OnGetIsSelectableOveride(result, byTeamNumber)
    return false
end

function AvocaArc:GetCanTakeDamageOverride()
    return self.deployMode == ARC.kDeployMode.Deployed
end

function AvocaArc:OnTakeDamage(damage, attacker, doer, point)
    if self:GetHealth() <= 1 then
        GiveUnDeploy(self)
    end    
end

function AvocaArc:GetCanDieOverride()
    return false
end

function AvocaArc:GetDamageType()
return kDamageType.StructuresOnly
end


local function CanMoveTo(self, target)    

    if not target.GetReceivesStructuralDamage or not target:GetReceivesStructuralDamage() then        
        return false
    end
   
    
     if not target:isa("Hive") then
        return false
    end
     if target:isa("Cyst") then return false end
  --  if not target:GetIsSighted() and not GetIsTargetDetected(target) then
 --       return false
  --  end
    
   -- local distToTarget = (target:GetOrigin() - self:GetOrigin()):GetLengthXZ()
   -- if (distToTarget > ARC.kFireRange) or (distToTarget < ARC.kMinFireRange) then
   --     return false
   -- end
    
    return true
    
end
local function GetNearestEligable(self)
    local nearest = GetNearestMixin(self:GetOrigin(), "Construct", 2, function(ent) return CanMoveTo(self, ent) end)
    if nearest then
    -- Print("avoca is %s, mainroom is %s, nearest is %s", self.avoca, self.mainroom, nearest:GetMapName())
    return nearest 
    end
end



local function hasScan(who, where)
          if not where then where = who:GetOrigin() end 
          for _, scan in ipairs(GetEntitiesForTeamWithinRange("Scan", 1, where, kScanRadius)) do
               if scan then
                  return true
             end
          end
          
          return false
end


function AvocaArc:GetDeathIconIndex()
    return kDeathMessageIcon.ARC
end
function AvocaArc:GetCanFireAtTargetActual(target, targetPoint)    

    if not target.GetReceivesStructuralDamage or not target:GetReceivesStructuralDamage() then        
        return false
    end
    
    if not target:isa("Hive") then
        return false
    end
    
    if not target:GetIsSighted() and not GetIsTargetDetected(target) then
        return false
    end
    
    local distToTarget = (target:GetOrigin() - self:GetOrigin()):GetLengthXZ()
    if (distToTarget > ARC.kFireRange) or (distToTarget < ARC.kMinFireRange) then
        return false
    end
    
    return true
    
end
function AvocaArc:InRadius()
    return  GetIsPointWithinHiveRadius(self:GetOrigin()) //or CheckForAndActAccordingly(self) 
end

local function ShouldStop(who)
    return false
end

local function FindNewParent(who)
    local where = who:GetOrigin()
    local player =  GetNearest(where, "Player", 1, function(ent) return ent:GetIsAlive() end)
    if player then
    who:SetOwner(player)
    end
end


local function MoveToHives(who) --Closest hive from origin
    local where = who:GetOrigin()
    local hive =  GetNearest(where, "Hive", 2, function(ent) return not ent:GetIsDestroyed() end)
    if hive then
        local origin = hive:GetOrigin() -- The arc should auto deploy beforehand
        who:GiveOrder(kTechId.Move, nil, origin, nil, true, true)
        return
    end  
end

local function MoveToMarineMain(who) --Closest hive from origin
    local where = who.spawnLoc
    local origin = who.spawnLoc 
    who:GiveOrder(kTechId.Move, nil, origin, nil, true, true)
end

local function MoveToMainRoom(self)
           MoveToHives(self) 
end


local function AliensStop(who)
  
end

/*
local function BuffPlayers(who)

local marines =  GetEntitiesForTeamWithinRange("Player", 1, who:GetOrigin(), 6)

     
    if not who:GetInAttackMode() and #marines >= 1 then
         for i = 1, #marines do
              local marine = marines[i]
              if marine:isa("Marine") then who:AddHealth(200) marine:AddHealth( math.random(4,8) ) end
         end
    end

end

*/

local function PlayersNearby(who)
local players =  GetEntitiesForTeamWithinRange("Player", 1, who:GetOrigin(), 4)
local alive = false
    if not who:GetInAttackMode() and #players >= 1 then
         for i = 1, #players do
            local player = players[i]
             if player:isa("Marine")  then
             if player:GetIsAlive() and alive == false then alive = true who.lastNearby = Shared.GetTime() end
            end
         end
    end
return alive, #players
end

function AvocaArc:AdjustMoveSpeed(numplayers,isReverse)
 local default = 2
 local value = default
 local adjustvalue = Clamp(numplayers,1,4) * 0.5
 //lazy math
     if not isReverse then
       value = adjustvalue 
     else
        value = 1
     end    
    //Print("Arc Speed value is %s", value)    
 AvocaArc.kMoveSpeed = value 
 //AvocaArc.kMoveSpeed = 4 
end

function AvocaArc:SpecificRules() 
//local moving = self.mode == ARC.kMode.Moving     
//Print("moving is %s", moving) 
        
local attacking = self:GetInAttackMode()
local inradius = GetIsPointWithinHiveRadius(self:GetOrigin())
local playersnearby,numplayers = PlayersNearby(self)
local shouldstop = not playersnearby
local shouldmove = not shouldstop and not inradius
local shouldReverse = not shouldmove and self.lastNearby + 16 <= Shared.GetTime()
local shouldattack = inradius and not attacking and self:GetHealth() > 1
local shouldScan = self.deployMode == ARC.kDeployMode.Deployed and not hasScan(self, self:GetOrigin())
shouldstop = shouldstop and not shouldReverse
//Print("shouldReverse is %s", shouldReverse)
  

    if shouldstop or shouldattack then 
        //  Print("StopOrder")
        // FindNewParent(self)
        self:ClearOrders()
        self:SetMode(ARC.kMode.Stationary)
    end 

    if not shouldattack  then
        if shouldmove then
            // Print("GiveMove")
            MoveToHives(self)
            self:AdjustMoveSpeed(numplayers, false)
        elseif shouldReverse then
            MoveToMarineMain(self)
            self:AdjustMoveSpeed(0, true)
        end
    elseif shouldattack then
        --Print("ShouldAttack")
        GiveDeploy(self)
        return true
    end
    
    if shouldScan then
        self:GiveScan()
    end    
    
 
end



function AvocaArc:Instruct()
   --Print("Arc instructing")
   -- CheckHivesForScan(self)
   self:SpecificRules()
   return true
end

    

end--server


if Client then

    function AvocaArc:OnUpdateRender()
          local showMaterial = true
    
        local model = self:GetRenderModel()
        if model then

            model:SetMaterialParameter("glowIntensity", 4)

            if showMaterial then
                
                if not self.hallucinationMaterial then
                    self.hallucinationMaterial = AddMaterial(model, kAvocaWeedMaterial)
                end
                
                self:SetOpacity(0, "hallucination")
            
            else
            
                if self.hallucinationMaterial then
                    RemoveMaterial(model, self.hallucinationMaterial)
                    self.hallucinationMaterial = nil
                end--
                
                self:SetOpacity(1, "hallucination")
            
            end --showma
            
        end--omodel
end --up render
end -- client

function AvocaArc:OnGetMapBlipInfo()

    local success = false
    local blipType = kMinimapBlipType.ARC
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    local isParasited = HasMixin(self, "ParasiteAble") and self:GetIsParasited()
    
    
        blipType = kMinimapBlipType.Door
        blipTeam = self:GetTeamNumber()
    
    return blipType, blipTeam, isAttacked, isParasited
end


if Server then

    function AvocaArc:GiveScan()
        local where = self:GetOrigin()//well it wont be able to attack, so not really helpful
        local hive = GetNearest(self:GetOrigin(), "Hive", 2)
        if hive then
            where = hive:GetOrigin()
        end
        CreateEntity(Scan.kMapName, where, 1) 
    end


 //I'm going to just copy+paste then override this. from ARC_Server.lua
 function AvocaArc:UpdateMoveOrder(deltaTime)
    local kMoveParam = "move_speed"
    local currentOrder = self:GetCurrentOrder()
    ASSERT(currentOrder)

    self:SetMode(ARC.kMode.Moving)

    local moveSpeed =  AvocaArc.kMoveSpeed //jkust adjusting this line, everything else is the same
    local maxSpeedTable = { maxSpeed = moveSpeed }
    self:ModifyMaxSpeed(maxSpeedTable)

    self:MoveToTarget(PhysicsMask.AIMovement, currentOrder:GetLocation(), maxSpeedTable.maxSpeed, deltaTime)

    self:AdjustPitchAndRoll()

    if self:IsTargetReached(currentOrder:GetLocation(), kAIMoveOrderCompleteDistance) then

        self:CompletedCurrentOrder()
        self:SetPoseParam(kMoveParam, 0)

        -- If no more orders, we're done
        if self:GetCurrentOrder() == nil then
            self:SetMode(ARC.kMode.Stationary)
        end

    else
        self:SetPoseParam(kMoveParam, .5)
    end

end


end
Shared.LinkClassToMap("AvocaArc", AvocaArc.kMapName, networkVars)