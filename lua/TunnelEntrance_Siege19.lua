--Kyle 'Avoca' Abent - Skip the "Tunnel" entity - lower the entity count by not requiring it in the first place
Script.Load("lua/MinimapConnectionMixin.lua")

local origInit = TunnelEntrance.OnInitialized
function TunnelEntrance:OnInitialized()
    origInit(self)
    InitMixin(self, MinimapConnectionMixin)
end


function TunnelEntrance:GetInfestationRadius()
  local frontdoor = GetEntitiesWithinRange("FrontDoor", self:GetOrigin(), 7)
   if #frontdoor >=1 then return 0
   else
    return 7
   end
end

function TunnelEntrance:GetInfestationMaxRadius()
  local frontdoor = GetEntitiesWithinRange("FrontDoor", self:GetOrigin(), 7)
   if #frontdoor >=1 then return 0
   else
    return 7
   end
end

function TunnelEntrance:GetGorgeOwner()
    return self.ownerId and self.ownerId ~= Entity.invalidId
end

function TunnelEntrance:GetTunnelEntity()
        return self:GetOtherEntrance()
end

function TunnelEntrance:GetIsCollapsing()
    return false
end

if Server then

    function TunnelEntrance:OnConstructionComplete()

        self.skipOpenAnimation = false
        self:UpdateConnectedTunnel()
        
    end
    
    function TunnelEntrance:SuckinEntity(entity)
    
        if entity and HasMixin(entity, "TunnelUser") then
        
            local tunnelEntity = self:GetTunnelEntity()
            if tunnelEntity then
                if HasMixin(entity, "LOS") then
                    entity:MarkNearbyDirtyImmediately()
                end
                
                tunnelEntity:MovePlayerToTunnel(entity, self)
                entity:SetVelocity(Vector(0, 0, 0))
                
                if entity.OnUseGorgeTunnel then
                    entity:OnUseGorgeTunnel()
                end

            end
            
        end
    
    end
    
    function TunnelEntrance:OnEntityExited(entity)
        self.timeLastExited = Shared.GetTime()
        self:TriggerEffects("tunnel_exit_3D")
    end
function Tunnel:GetEntranceAPosition()
    return self:GetOrigin() + self:GetCoords():TransformVector(kEntranceAPos)
end

/*
function TunnelEntrance:SetOwner(owner)

    if owner and not self.ownerClientId then
        local client = Server.GetOwner(owner)
        self.ownerClientId = client:GetUserId()
    end
    
end
*/

 function TunnelEntrance:MovePlayerToTunnel(player, entrance)
    
        assert(player)
        assert(entrance)
        
        local entranceId = entrance:GetId()
        
        local newAngles = player:GetViewAngles()
        newAngles.pitch = 0
        newAngles.roll = 0
        local origin = self:GetOrigin() --self:GetTunnelEntity():GetOrigin()
            player:SetOrigin(origin + Vector(0,1,0) )
            newAngles.yaw = GetYawFromVector(self:GetCoords().zAxis)
            player:SetOffsetAngles(newAngles)

    
  end
  
    function TunnelEntrance:SetTunnel(tunnel)  
        if tunnel == nil then
            self.otherEntranceId = nil
        else
            self.otherEntranceId = tunnel:GetId()
        end
    end

    function TunnelEntrance:UpdateConnectedTunnel()
        local hasValidTunnel = self.otherEntranceId ~= nil and Shared.GetEntity(self.otherEntranceId) ~= nil
  
        if hasValidTunnel or not self:GetIsBuilt() then
            return
        end
        
        local foundTunnel = nil
        
        -- register if a tunnel entity already exists or a free tunnel has been found
        for _, tunnel in ientitylist( Shared.GetEntitiesWithClassname("TunnelEntrance") ) do
            if not tunnel:isa("ParticleEffect") and not tunnel.open and tunnel ~= self and tunnel:GetOwnerClientId() == self:GetOwnerClientId() then
                if  self:GetTechId() == kTechId.BuildTunnelEntryOne and tunnel:GetTechId() == kTechId.BuildTunnelExitOne or
                    self:GetTechId() == kTechId.BuildTunnelEntryTwo and tunnel:GetTechId() == kTechId.BuildTunnelExitTwo or
                    self:GetTechId() == kTechId.BuildTunnelEntryThree and tunnel:GetTechId() == kTechId.BuildTunnelExitThree or
                    self:GetTechId() == kTechId.BuildTunnelEntryFour and tunnel:GetTechId() == kTechId.BuildTunnelExitFour or
                    self:GetTechId() == tunnel:GetTechId()  then
                        foundTunnel = tunnel
                        break
                end
            end
        end
    
        if foundTunnel and not foundTunnel:isa("ParticleEffect") then
            self.otherEntranceId = foundTunnel:GetId()
            --foundTunnel.otherEntranceId = self:GetId()
        
            --self:SetOtherEntrance(foundTunnel)
             if foundTunnel.otherEntranceId == Entity.invalidId or foundTunnel.otherEntranceId == nil then
                --foundTunnel:SetOtherEntrance(self) -- ParticleEffect ???? UGH 
                  foundTunnel:UpdateConnectedTunnel()
             end
        end
        
        
    end
    
    function TunnelEntrance:GetConnectionStartPoint()
        local connection = self.otherEntranceId ~= nil and Shared.GetEntity(self.otherEntranceId) ~= nil
        if connection then
            return self:GetOrigin()
        end
        
    end
    
    function TunnelEntrance:GetConnectionEndPoint()
        local connection = self.otherEntranceId ~= nil and Shared.GetEntity(self.otherEntranceId) ~= nil
        if connection then
            return Shared.GetEntity(self.otherEntranceId):GetOrigin()
        end
        
    end
    
    
end


function TunnelEntrance:GetMinimapYawOffset()
    local connection = self.otherEntranceId ~= nil and Shared.GetEntity(self.otherEntranceId) ~= nil
    if connection then
        local tunnelDirection = GetNormalizedVector( connection:GetOrigin() - self:GetOrigin() )
        return math.atan2(tunnelDirection.x, tunnelDirection.z)
    else
        return 0
    end
    
end

