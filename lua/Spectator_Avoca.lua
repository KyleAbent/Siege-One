--Kyle 'Avoca' Abent 
//Well I am copying everything, you know. But I like my name cause it's a good one.
local networkVars = 

{
lastswitch = "private time", 
nextangle = "private integer (0 to 8)", 
lockedId = "entityid",
lastLockUpdate = "private time"
} 

class 'AvocaSpectator' (Spectator)
AvocaSpectator.kMapName = "Spectator"

--AvocaSpectator.kModelName = PrecacheAsset("models/alien/fade/fade.model")

function AvocaSpectator:OnInitialized()
    Spectator.OnInitialized(self)
end

function AvocaSpectator:GetControllerPhysicsGroup()
    return PhysicsGroup.BigPlayerControllersGroup  
end

function AvocaSpectator:OnCreate()
    Spectator.OnCreate(self)
    self.lastLockUpdate = Shared.GetTime()
    self.lastswitch = Shared.GetTime()
    self.nextangle = self:getNextAngleTime()
    self.lockedId = Entity.invalidI 
end

function AvocaSpectator:doTimer()
  self:AddTimedCallback( AvocaSpectator.UpdateCamera, 1 )
end

function AvocaSpectator:SetLockOnTarget(userid)
    --if self:CanChange() then
        self.lockedId = userid
        self.lastswitch = Shared.GetTime()
        self.nextangle = self:getNextAngleTime()
    --end
        
end

function AvocaSpectator:BreakChains()
  self.lockedId = Entity.invalidI 
end

function AvocaSpectator:LockAngles()//if cam then look for lock
  local playerOfLock = Shared.GetEntity( self.lockedId ) 
    if playerOfLock ~= nil then
        if (playerOfLock.GetIsAlive and playerOfLock:GetIsAlive())  then
             local dir = GetNormalizedVector(playerOfLock:GetOrigin() - self:GetOrigin()) --EyePos? (Lerk/Mac/Gorge/Embr
             local angles = Angles(GetPitchFromVector(dir), GetYawFromVector(dir), 0)
             self:SetOffsetAngles(angles)
        end
  end
end

function AvocaSpectator:ChangeView(self, untilNext, betweenLast)
--Shine
end

function AvocaSpectator:LockAnglesTarget(who)

end
function AvocaSpectator:UnlockAngles()

end

function AvocaSpectator:HookOnEntityChange(self)
--Shine
end

function AvocaSpectator:OnEntityChange(oldId)
    if self.lockedId == oldId then
        local lockee = Shared.GetEntity(self.lockedId)
        if not lockee or (lockee and not lockee:GetIsAlive()) then
            print("AvocaSpectator OnEntityChange")
            self.lockedId = Entity.invalidId
            self.lastswitch = Shared.GetTime()
            self.nextangle = self:getNextAngleTime()
            self:HookOnEntityChange(self)
            self:ChangeView(self, self.nextangle, self.lastswitch )
        end
    end    
end


local function GetCDistance(target)
local dist = 5
 if target:isa("CommandStructure") then
 dist = 8
 elseif target:isa("Contamination") then
  dist = 3
  elseif target:isa("Marine") then
  dist = 4 
  elseif target:isa("Whip") then
  dist = 5
  elseif target:isa("Shift") then
  dist = 5
  end
  return dist
  
end
function AvocaSpectator:OverrideInput(input)

    ClampInputPitch(input)
     //Attempts of Zooming in when outside radius
          if self.lockedId ~= Entity.invalidI then
            local target = Shared.GetEntity( self.lockedId ) 
              if target and  ( target.GetIsAlive and target:GetIsAlive() ) then
                 if  HasMixin(target, "Construct")  or target:isa("Contamination") then input.move.x = input.move.x + 0.15 end
                 local distance = self:GetDistance(target)
                 if distance >= GetCDistance(target) then
                    //  Print("Distance %s lastzoom %s", distance, self.lastzoom) //debug my ass
                      input.move.z = input.move.z + 0.5
                   elseif distance <= 1.8 then
                   input.move.z = input.move.z - 1
                     // Print(" new distance is %s, new lastzoom is %s", distance, self.lastzoom)
                 else//In range, now determine Y
                      local ymove = 0
                      local myY = self:GetOrigin().y
                      local urY = target:GetOrigin().y 
                      local difference =  urY - myY
                            if difference == 0 then
                                ymove = difference
                            elseif difference <= -1 then
                               ymove = -1
                            elseif difference >= 1 then
                               ymove = 1
                            end
                       input.move.y = input.move.y + (ymove) 
                 end
              end
          
          end
    
    return input
end

function AvocaSpectator:getNextAngleTime()
    local chance = math.random(1,4)
    chance = chance * 4
    return chance
end

---Spectator doesn't use this function...
function AvocaSpectator:OnUpdatePlayer()
        --if GetIsTimeUp(self.lastLockUpdate, 1) then
            self:LockAngles()
            self.lastLockUpdate = Shared.GetTime()
         --end
         
        //  Print(self.lastswitch,  " ", self.nextangle )
         if GetIsTimeUp(self.lastswitch, self.nextangle ) then
             --Print("AvocaSpectator ChangeView")
              self.nextangle = self:getNextAngleTime()
              self.lastswitch = Shared.GetTime()
              self:ChangeView(self, self.nextangle, self.lastswitch )
          end
          --return true
end

function AvocaSpectator:CanChange()
    return GetIsTimeUp(self.lastswitch, self.nextangle )
end

Shared.LinkClassToMap("AvocaSpectator", AvocaSpectator.kMapName, networkVars)