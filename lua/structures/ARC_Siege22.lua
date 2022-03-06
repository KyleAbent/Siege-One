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
    self.manageARCTime = 0
end



if Server then


    function ARC:Instruct(where)
       self:SpecificRules(where)
       return true
    end

    local function MoveToHives(self, where) --Closest hive from origin
        if where then
            //self:GiveOrder(kTechId.Move, nil, FindFreeSpace(where), nil, true, true)//FindFree may go outside radius
            local inradius = FindArcHiveSpawn(where)//This might get spammy having all arcs find spot again when it already did once globally (conductor).
            if inradius then
                self:GiveOrder(kTechId.Move, nil, inradius, nil, true, true)
                SetDirectorLockedOnEntity(self)
            else
                self:GiveOrder(kTechId.Move, nil, where, nil, true, true)//Try where, if 12 arc go in 1 spot then do .. ??
                SetDirectorLockedOnEntity(self)
            end
            return
        end   
    end
    local function MoveToRandomChair(who) --Closest hive from origin
     local commandstation = GetEntitiesForTeam( "CommandStation", 1 )
      commandstation = table.random(commandstation)
     
                   if commandstation then
            local origin = commandstation:GetOrigin() -- The arc should auto deploy beforehand
            who:GiveOrder(kTechId.Move, nil, origin, nil, true, true)
                        return
                    end  
        -- Print("No closest hive????")    
    end
    local function CheckForAndActAccordingly(who)
    local stopanddeploy = false
              for _, enemy in ipairs(GetEntitiesWithMixinForTeamWithinRange("Live", 2, who:GetOrigin(), kARCRange)) do
                 if who:GetCanFireAtTarget(enemy, enemy:GetOrigin()) then
                 stopanddeploy = true
                 break
                 end
              end
            --Print("stopanddeploy is %s", stopanddeploy)
           return stopanddeploy
    end
    local function GiveUnDeploy(who)
         --Print("GiveUnDeploy")
         who:CompletedCurrentOrder()
         who:SetMode(ARC.kMode.Stationary)
         who.deployMode = ARC.kDeployMode.Undeploying
         who:TriggerEffects("arc_stop_charge")
         who:TriggerEffects("arc_undeploying")
    end
    local function GiveDeploy(who)
        --Print("GiveDeploy")
    who:GiveOrder(kTechId.ARCDeploy, who:GetId(), who:GetOrigin(), nil, true, true)
    end
    local function FindNewParent(who)
        local where = who:GetOrigin()
        local player =  GetNearest(where, "Player", 1, function(ent) return ent:GetIsAlive() end)
        if player then
        who:SetOwner(player)
        end
    end
    function ARC:GetIsDeployed()
    return  self.deployMode == ARC.kDeployMode.Deployed
    end
    function ARC:SetDeployed()
    GiveDeploy(self) 
    end

    function ARC:SpecificRules(where)
    local moving = self.mode == ARC.kMode.Moving    
    local isSiegeOpen =  GetSiegeDoorOpen() 
    //Print("SpecificRules isSiegeOpen is %s", isSiegeOpen)
            
    local attacking = self.deployMode == ARC.kDeployMode.Deployed

    local inradius =  not isSiegeOpen and ( GetIsPointWithinChairRadius(self:GetOrigin()) or CheckForAndActAccordingly(self) ) or 
                          isSiegeOpen and (  GetIsInSiege(self) and GetIsPointWithinHiveRadius(self:GetOrigin()) )
    local shouldstop = false
    local shouldmove = not shouldstop and not moving and not inradius
    local shouldstop = moving and inradius
    local shouldattack = inradius and not attacking 
    local shouldundeploy = attacking and not inradius and not moving
      
      if moving then
        
        if shouldstop or shouldattack then 
               FindNewParent(self)
           --Print("StopOrder")
           self:ClearOrders()
           self:SetMode(ARC.kMode.Stationary)
          end 
     elseif not moving then
          
        if shouldmove and not shouldattack  then
            if shouldundeploy then
          
             GiveUnDeploy(self)
           else 
                if not isSiegeOpen then
                 MoveToRandomChair(self)
                elseif where ~= nil then
                 MoveToHives(self,where)
                end
           end
           
       elseif shouldattack then
       
         GiveDeploy(self)
        return true
        
     end
     
        end
    end//function


    local origrules = ARC.AcquireTarget
    function ARC:AcquireTarget() 

    local canfire = GetSetupConcluded()
    --Print("Arc can fire is %s", canfire)
    if not canfire then return end
    return origrules(self)
    end

end//server

function ARC:ManageArcs()
    local where = nil

    if GetSiegeDoorOpen() and GetConductor().arcSiegeOrig ~= GetConductor():GetOrigin() then
        //print("ManageArcs SiegeDoorOpen and arcSiegeOrig origin is at conductor origin")
        where = GetConductor().arcSiegeOrig
    end
    
    if not GetSiegeDoorOpen() then //and power not in siege lol
        where = FindFreeSpace(GetRandomActivePowerNotInSiege():GetOrigin(), math.random(2,4), math.random(8,24), false ) 
    end
    
    if where == GetConductor():GetOrigin()  then
        //print("Could not find spot for ARC!")
        return
    end
    
     self:Instruct(where)
end

local origUpdate = ARC.OnUpdate 
function ARC:OnUpdate(deltaTime)
    origUpdate(self,deltaTime)
    if Server then
        if not self:isa("AvocaArc") and self.manageARCTime + kManageArcInterval <= Shared.GetTime() then
            if GetIsImaginatorMarineEnabled() then --and GetConductor():GetIsArcMovementAllowed() then
                self:ManageArcs()
               --  GetConductor():JustMovedArcSetTimer()
            end
             self.manageARCTime = Shared.GetTime()
        end
    end
        
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

----------------------------------------------------------------
Script.Load("lua/ConstructMixin.lua")


class 'ARCCredit' (ARC)
ARCCredit.kMapName = "arccredit"


local networkVars = {}
AddMixinNetworkVars(ConstructMixin, networkVars)

local origarc  = ARC.OnCreate
function ARCCredit:OnCreate()


origarc(self)
InitMixin(self, ConstructMixin)

end

function ARCCredit:OnConstructionComplete(builder)
    self:GiveOrder(kTechId.ARCDeploy, self:GetId(), self:GetOrigin(), nil, false, false)
    CreateEntity(Scan.kMapName, self:GetOrigin(), 1)
 end
 function ARCCredit:GetDamageType()
return kDamageType.StructuresOnly
end
 function ARCCredit:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.ARC
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end
  
Shared.LinkClassToMap("ARCCredit", ARCCredit.kMapName, networkVars)