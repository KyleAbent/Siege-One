--Kyle 'Avoca' Abent 
local networkVars = 

{
isDirecting = "boolean",
lockedId = "entityid",
}

function Spectator:ToggleDirectorOff()
    self.isDirecting = false
end
function Spectator:ToggleDirectorOn()
    self.isDirecting = true
end

function Spectator:ToggleDirector()
    self.isDirecting = not self.isDirecting
end

local origCr = Spectator.OnCreate
function Spectator:OnCreate()
  origCr(self)
  self.lockedId = Entity.invalidI 
         if Server then
         self:AddTimedCallback( Spectator.UpdateCamera, 1 )
         self:AddTimedCallback( Spectator.ChangeTarget, 6 ) //OnUpdate if I want to change interval
        end
end
if Server then
    function Spectator:ChangeTarget()

        if not self.isDirecting then
            return
        end
        
        local nearest = GetNearestMixin(self:GetOrigin(), "Combat", nil, function(ent)  return ent:isa("Player") and ent:GetIsInCombat() end)
        if nearest then
            self.lockedId = nearest:GetId()
        end
        return true
    end
end
function Spectator:SetLockOnTarget(userid)
    self.lockedId = userid
    self:LockAngles()
end
function Spectator:BreakChains()
  self.lockedId = Entity.invalidI 
end
function Spectator:LockAngles()

    if not self.isDirecting then
        return
    end
  if self:GetSpectatorMode() ~= kSpectatorMode.FreeLook then self:SetSpectatorMode(kSpectatorMode.FreeLook) end
  local playerOfLock = Shared.GetEntity( self.lockedId ) 
    if playerOfLock ~= nil then
            if (playerOfLock.GetIsAlive and playerOfLock:GetIsAlive())  then
             local dir = GetNormalizedVector(playerOfLock:GetOrigin() - self:GetOrigin())
             local angles = Angles(GetPitchFromVector(dir), GetYawFromVector(dir), 0)
             self:SetOffsetAngles(angles)
            end
   else
        self:FindLockAnyone()
  end
end

function Spectator:LockAnglesTarget(who)

end
function Spectator:UnlockAngles()

end
function Spectator:FindLockAnyone()
        local nearest = GetNearest(self:GetOrigin(), "Player", nil, function(ent)  return (ent:GetTeamNumber() == 1 or ent:GetTeamNumber() == 2) and ( not ent:isa("Commander") and ent:GetIsAlive() ) end)
        if nearest then
            self.lockedId = nearest:GetId()
        end
        return true
end
/*
function Spectator:OnEntityChange(oldId)
    if self.lockedId == oldId then
        self.lockedId = Entity.invalidId
       self.lastswitch = Shared.GetTime()
       self.nextangle = 1
        //hm
        self:FindLockAnyone()
    end    
end
*/
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

local orig = Spectator.OverrideInput
function Spectator:OverrideInput(input)

    orig(self, input)
    
    ClampInputPitch(input)
     //Attempts of Zooming in when outside radius
          if self.isDirecting and self.lockedId ~= Entity.invalidI then //elseif valid then breakchain and call for a new ?
            local target = Shared.GetEntity( self.lockedId ) 
              if target and  ( target.GetIsAlive and target:GetIsAlive() ) then
                 if  HasMixin(target, "Construct")  or target:isa("Contamination") then input.move.x = input.move.x + 0.15 end
                 //Print("My Origin is %s and the Target origin is %s", self:GetOrigin(), target:GetOrigin() )
                 local distance = self:GetDistance(target) //I don't think distance works when outside of map. Needs Origin/Vector.
                 //Print("Distance is %s", distance)
                 local shouldStop = distance <= GetCDistance(target)
                    //  Print("Distance %s lastzoom %s", distance, self.lastzoom) //debug my ass
                    if not shouldStop then
                      input.move.z = input.move.z + 0.5
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
                   elseif distance <= 1.8 then
                    input.move.z = input.move.z - 1
                     // Print(" new distance is %s, new lastzoom is %s", distance, self.lastzoom)
                  //else
                    //Print("Distance is %s", distance)
                 end
              end
          
          end
    
    return input
    
end
function Spectator:UpdateCamera()
         self:LockAngles()
          return true
end

Shared.LinkClassToMap("Spectator", Spectator.kMapName, networkVars)