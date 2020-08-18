--Kyle 'Avoca' Abent - Skip the "Tunnel" entity - lower the entity count by not requiring it in the first place
Script.Load("lua/MinimapConnectionMixin.lua")

local networkVars =
{
    index = "integer",
    randomColorNumber = "integer",
    onTop = "entityid",
}

local origCreate = TunnelEntrance.OnCreate
function TunnelEntrance:OnCreate()
    origCreate(self)
    self.index = 0
    self.randomColorNumber = math.random(1,11)
    self.onTop = Entity.invalidId
    Print("self.currentMapBlipColor is %s", self.currentMapBlipColor)
end

function TunnelEntrance:GetMiniMapColors()
    --local otherEntrance = self:GetOtherEntrance()--doesnt work if not built ugh
    if not self:GetIsBuilt() then  
        return Color(1, 138/255, 0, 1)
    else
        local num = self.randomColorNumber
        Print("GetMiniMapColors is %s", self.randomColorNumber)
        if num == 1 then
         return ColorIntToColor(0x6638D4)
        elseif num == 2 then
           return ColorIntToColor(0x48CE83)
        elseif num == 3 then
           return ColorIntToColor(0x721E51)
        elseif num == 4 then
           return ColorIntToColor(0x7CFC87)
        elseif num == 5 then
           return ColorIntToColor(0x6E03A3)
        elseif num == 6 then
             return ColorIntToColor(0xDA2BFD)
        elseif num == 7 then
           return ColorIntToColor(0x1BC4D3)
        elseif num == 8 then
           return ColorIntToColor(0xC8ED0C)
        elseif num == 9 then--not good color it shows grey
           return ColorIntToColor(0xA99CFF)
        elseif num == 10 then
           return ColorIntToColor(0x0AD5C2)
        elseif num == 11 then
           return ColorIntToColor(0x9C121C)
        end
     end    
      
end
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
function TunnelEntrance:SetOtherEntrance(otherEntranceEnt)
    
    -- Convert the entity to an id (or to invalid id if nil).
    local otherEntranceId = Entity.invalidId
    if otherEntranceEnt then
        otherEntranceId = otherEntranceEnt:GetId()
    end
    
    -- Skip if the other entrance is already setup.
    if otherEntranceId == self.otherEntranceId then
        return
    end
    
    self.otherEntranceId = otherEntranceId
    
    -- Have the other entrance set its 'other' entrance to this entrance.
  -- - if otherEntranceEnt then
    --    otherEntranceEnt:SetOtherEntrance(self)
    --end
    
end
function TunnelEntrance:GetGorgeOwner()
    return self.ownerId and self.ownerId ~= Entity.invalidId
end
function TunnelEntrance:SetIndex(index)
    self.index = index
end
function TunnelEntrance:GetIndex()
    return self.index
end

function TunnelEntrance:GetTunnelEntity()
        return self:GetOtherEntrance()
end

function TunnelEntrance:GetIsCollapsing()
    return false
end

function TunnelEntrance:GetShowHitIndicator()
    return false
end

function TunnelEntrance:GetCanBeUsed(player, useSuccessTable)

    if self.onTop ~= nil and self.onTop ~= Entity.invalidId then
        if self.onTop == player:GetId() then
            useSuccessTable.useSuccess = true
        end
    else
        useSuccessTable.useSuccess = false
    end
    
end
    

function TunnelEntrance:OnUse(player, elapsedTime, useSuccessTable)
    --What if Gorge wants to Destroy? lol 
    local success = false
    if player:isa("Alien") then
        if self:GetIsBuilt() then
            local tunnelEntity = self:GetTunnelEntity()
            if tunnelEntity then
            
                if HasMixin(player, "LOS") then
                    player:MarkNearbyDirtyImmediately()
                end

                tunnelEntity:MovePlayerToTunnel(player, self)
                player:SetVelocity(Vector(0, 0, 0))

                if player.OnUseGorgeTunnel then
                    player:OnUseGorgeTunnel()
                end
                self.onTop = Entity.invalidId
            end
            success = true
        end
    end
    
    useSuccessTable.useSuccess = useSuccessTable.useSuccess or success
    
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
                tunnelEntity:MarkBlipDirty()
                self:MarkBlipDirty()
                self.onTop = entity:GetId()
                local mapBlip = entity and entity.mapBlipId and Shared.GetEntity(entity.mapBlipId)
                if mapBlip then
                    mapBlip:Update()
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

    function TunnelEntrance:UpdateConnectedTunnel() --I am NOT happy about OnUpdate with a For Loop. Still better than Tunnel, though.
        local hasValidTunnel = self.otherEntranceId ~= nil and Shared.GetEntity(self.otherEntranceId) ~= nil
  
        if hasValidTunnel or not self:GetIsBuilt() then
            return
        end
        
        local foundTunnel = nil
        --Print("Self Index Is %s", self.index )
        -- register if a tunnel entity already exists or a free tunnel has been found
        for _, tunnel in ientitylist( Shared.GetEntitiesWithClassname("TunnelEntrance") ) do
          --Print("Tunnel Index  Is %s", tunnel.index )
            if not tunnel.open and tunnel ~= self and tunnel:GetOwnerClientId() == self:GetOwnerClientId() then
                if  self.index == 0 and tunnel.index == 0  or --0 is gorge tunnel
                    self.index == 1 and tunnel.index == 1  or
                    self.index == 2 and tunnel.index == 2  or
                    self.index == 3 and tunnel.index == 3  then
                        foundTunnel = tunnel
                        break
                end
            end
        end
        
        self:SetOtherEntrance(foundTunnel)
        
        if (foundTunnel) then
            --foundTunnel:SetOtherEntrance(self)
            foundTunnel:UpdateConnectedTunnel()
            foundTunnel.randomColorNumber = self.randomColorNumber
            self.randomColorNumber = foundTunnel.randomColorNumber
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
    
    
    local origUpdate = TunnelEntrance.OnUpdate
    function TunnelEntrance:OnUpdate(deltaTime)
            --Why is it being set to other entities? ParticleEffect, d
        local otherEntrance = self:GetOtherEntrance()
        if otherEntrance then                                                                   --or not other.getisalive bleh
            if not ( otherEntrance:isa("TunnelEntrance") or otherEntrance:isa("GorgeTunnel") ) or  ( otherEntrance.GetIsAlive and not otherEntrance:GetIsAlive() ) then
                --Print("UHHH")
                self.otherEntranceId = Entity.invalidId 
                self.open = false
            else
                origUpdate(self, deltaTime)
            end
        else
            if not self.timeLastBallsSweat or ( self.timeLastBallsSweat + 0.5 < Shared.GetTime() )  then
                self:UpdateConnectedTunnel()
                self.timeLastBallsSweat = Shared.GetTime()
            end
            origUpdate(self, deltaTime)
        end
        
    end

    
end //Server


function TunnelEntrance:GetMinimapYawOffset()
    local connection = self.otherEntranceId ~= nil and Shared.GetEntity(self.otherEntranceId) ~= nil
    if connection then
        local tunnelDirection = GetNormalizedVector( connection:GetOrigin() - self:GetOrigin() )
        return math.atan2(tunnelDirection.x, tunnelDirection.z)
    else
        return 0
    end
    
end


/*
function TunnelEntrance:GetMapBlipColor(minimap, item)
            return self:GetMiniMapColors()
end
*/


Shared.LinkClassToMap("TunnelEntrance", TunnelEntrance.kMapName, networkVars)