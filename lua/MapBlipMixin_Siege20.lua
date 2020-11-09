local function CreateMapBlip(self, blipType, blipTeam, _)

    local mapName = MapBlip.kMapName
    local shouldSetOwner = false --to draw player name on minimap near tunnel
    --special mapblips
    if self:isa("Player") then
        mapName = PlayerMapBlip.kMapName
    elseif self:isa("Scan") then
        mapName = ScanMapBlip.kMapName
   elseif self:isa("TunnelEntrance") then
        mapName = TunnelMapBlip.kMapName
        shouldSetOwner = true
    end



    local mapBlip = Server.CreateEntity(mapName)
    -- This may fail if there are too many entities.
    if mapBlip then

        mapBlip:SetOwner(self:GetId(), blipType, blipTeam)
        self.mapBlipId = mapBlip:GetId()
        if shouldSetOwner then      --commander tunnel?
            --self:DoOther()
           -- local otherEntrance = self:GetOtherEntrance()
           -- if otherEntrance then    
           --     self.randomColorNumber = otherEntrance.randomColorNumber
           -- end
             //Print("MapBlipMixin CreateMapBlip tunnel randomColorNumber is %s", self.randomColorNumber)
             mapBlip.randomColorNumber = self.randomColorNumber
        end

    end

end

function MapBlipMixin:__initmixin()

    PROFILE("MapBlipMixin:__initmixin")

    assert(Server)

    -- Check if the new entity should have a map blip to represent it.
    local success, blipType, blipTeam, isInCombat = self:GetMapBlipInfo()
    if success then
        CreateMapBlip(self, blipType, blipTeam, isInCombat)
    end

end 