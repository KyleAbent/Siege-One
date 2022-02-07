--Kyle 'Avoca' Abent
Script.Load("lua/ScriptActor.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/HiveVisionMixin.lua")
Script.Load("lua/MarineOutlineMixin.lua")

class 'SiegeDoor' (ScriptActor)

SiegeDoor.kMapName = "siegedoor"

local kOpeningEffect = PrecacheAsset("cinematics/dooropen.cinematic")

local networkVars =
{
    scale = "vector",
    model = "string (128)",
    savedOrigin = "vector",
    opened = "boolean",
    opening = "boolean",
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)


function SiegeDoor:OnCreate()
    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, TeamMixin)
end
function SiegeDoor:OnInitialized()

    ScriptActor.OnInitialized(self)  
    Shared.PrecacheModel(self.model) 
    self:SetModel(self.model)
    self.savedOrigin = self:GetOrigin()
	
    if Server then
    elseif Client then

    InitMixin(self, MarineOutlineMixin)
     InitMixin(self, HiveVisionMixin)
     
     /*
        	local model = self:GetRenderModel()
            HiveVision_AddModel( model )
            EquipmentOutline_AddModel( model ) 
     */
            /*
            self.OpeningEffect = Client.CreateCinematic(RenderScene.Zone_Default)
            self.OpeningEffect:SetCinematic(kOpeningEffect)
            self.OpeningEffect:SetRepeatStyle(Cinematic.Repeat_Endless)
            self.OpeningEffect:SetParent(self)
            self.OpeningEffect:SetCoords(self:GetCoords())
           // self.OpeningEffectSetAttachPoint(self:GetAttachPointIndex(attachPoint))
            self.OpeningEffect:SetIsActive(false)
            */
    end
    
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(PhysicsGroup.DefaultGroup)
    self.opened = false
    self.opening = false
    self:SetUpdates(true) 
end
  
function SiegeDoor:OnUpdate(deltaTime)
    if self.opening and not self.opened then
        if not self.timeLastNudge or ( self.timeLastNudge + 0.5 < Shared.GetTime() )  then
            self.opened = (self:GetOrigin() - self.savedOrigin):GetLength() >= 9//kDoorMoveUpVect
            if self.opened then
                self.opening = false
            else
                self:SetOrigin(self:GetOrigin() + Vector(0,.01,0) ) 
                if not self.timeLastPhys or ( self.timeLastPhys + 2 < Shared.GetTime() )  then
                    self:UpdatePosition(waypointreached)//hmm will this spam too much? Im not sure
                    self:MakeSurePlayersCanGoThroughWhenMoving()//hmm will this spam too much? Im not sure
                    self.timeLastPhys = Shared.GetTime()
                end
            end
            self.timeLastNudge = Shared.GetTime()
        end
    end
    
end


function SiegeDoor:CloseLock()    
 self:SetOrigin(self.savedOrigin)
 self.opened = false
 self.opening = false
 self:MakeSurePlayersCanGoThroughWhenMoving() 
 
         -- if Client then 
         
    --  if self.effect then
    --    Client.DestroyCinematic(self.effect)
    --    self.cinematic = nil
        
     --   end
     --   end
end
function SiegeDoor:GetIsMapEntity()
return true
end
function SiegeDoor:GetIsOpen()    
return self.opened
end
function SiegeDoor:HasOpened()    
return self.opened
end
function SiegeDoor:GetIsLocked()    
return self.opened
end
function SiegeDoor:MakeSurePlayersCanGoThroughWhenMoving()
                self:UpdateModelCoords()
                self:UpdatePhysicsModel()
               if (self._modelCoords and self.boneCoords and self.physicsModel) then
              self.physicsModel:SetBoneCoords(self._modelCoords, self.boneCoords)
               end  
               self:MarkPhysicsDirty()    
end
function SiegeDoor:UpdatePosition(waypointreached) 
     local waypoint = self.savedOrigin + Vector(0, 9,0)//kDoorMoveUpVect, 0)
      -- Print("Waypoint difference is %s", waypoint - self:GetOrigin())
   if waypoint then
       if not waypointreached then               
               self:SetOrigin(self:GetOrigin() + Vector(0,.1,0) )        
                self:MakeSurePlayersCanGoThroughWhenMoving()                      
       else
         --if Client then 
         
     -- if self.effect then
     --   Client.DestroyCinematic(self.effect)
     --   self.cinematic = nil
      --  
     --   end
       -- end
                self:MakeSurePlayersCanGoThroughWhenMoving() 
                return false
            end
  end  
 
     
    return self.opened and not waypointreached
            
end 
function SiegeDoor:OnAdjustModelCoords(modelCoords)

    local coords = modelCoords
    if self.scale and self.scale:GetLength() ~= 0 then
        coords.xAxis = coords.xAxis * self.scale.x
        coords.yAxis = coords.yAxis * self.scale.y
        coords.zAxis = coords.zAxis * self.scale.z
    end
    return coords
    
end
function SiegeDoor:OnReset()
self:CloseLock()

end
Shared.LinkClassToMap("SiegeDoor", SiegeDoor.kMapName, networkVars)

class 'FrontDoor' (SiegeDoor)

function FrontDoor:GetIsLocked()    
return not GetFrontDoorOpen()
end

FrontDoor.kMapName = "frontdoor"

function FrontDoor:OnInitialized()

SiegeDoor.OnInitialized(self)
//self:SetUpdates(true)
end

if Server then

    local function DestroyCysts(self)

        for _, cyst in ipairs( GetEntitiesForTeamWithinRange("Cyst", 2, self:GetOrigin(), 17) ) do
                cyst:Kill()
                Print("Destroying Cyst by Front Door")
        end
        
    end
    
     function FrontDoor:OnUpdate(deltaTime)
          --local gamestarted = GetGamerules():GetGameStarted()
          --if gamestarted then 
          SiegeDoor.OnUpdate(self, deltaTime)
          if not self.opened and not self.opening then
               if not self.timelasttimerup or self.timelasttimerup + 1 <= Shared.GetTime() then
                    DestroyCysts(self)
                end
          end
     end
     
end


Shared.LinkClassToMap("FrontDoor", FrontDoor.kMapName, networkVars)



class 'SideDoor' (SiegeDoor)


--function SideDoor:GetIsLocked()    
--return not GetPrimaryDoorOpen()
--end

SideDoor.kMapName = "sidedoor"

Shared.LinkClassToMap("SideDoor", SideDoor.kMapName, networkVars)


class 'SideDoor' (SiegeDoor)


--function SideDoor:GetIsLocked()    
--return not GetPrimaryDoorOpen()
--end

class 'weldComplete_Door_toOrigin' (SiegeDoor)
weldComplete_Door_toOrigin.kMapName = "wcdto"


function weldComplete_Door_toOrigin:OnCreate()    
SiegeDoor.OnCreate(self)
self:SetOrigin(self:GetOrigin() + Vector(0, 100, 0) )
end



Shared.LinkClassToMap("weldComplete_Door_toOrigin", weldComplete_Door_toOrigin.kMapName, networkVars)